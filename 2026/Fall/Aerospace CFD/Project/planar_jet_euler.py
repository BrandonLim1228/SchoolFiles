"""Second-order 2-D Euler solver for a supersonic planar jet.

The upper half of a symmetric planar jet is computed and mirrored for output.

Numerical method
----------------
* cell-centred finite-volume method on a uniform Cartesian grid;
* piecewise-linear MUSCL reconstruction of primitive variables;
* monotonized-central (MC) slope limiter;
* HLLC approximate Riemann solver at cell faces;
* second-order SSP-RK2 time integration.

Default boundary conditions
---------------------------
* left: dirichlet, prescribed jet state below the nozzle lip, ambient state above it;
* bottom: symmetry (the jet centerline);
* top: prescribed ambient state;
* right: zero-gradient Neumann

Run with either:
    python planar_jet_euler.py
    python3 planar_jet_euler.py

The output directory contains fixed-scale contour images, a four-panel evolution
video, final centerline plots, and final two-dimensional CSV fields.  The video
is MP4 when FFmpeg is available and an animated GIF otherwise.

The pressure ratio P_EXIT/P_AMBIENT is controlled by the variable PRESSURE_RATIO. 
Values below 1.0 are over-expanded, those above 1.0 are under-expanded, and 1.0 is perfectly expanded.
"""

from pathlib import Path
import time as wall_clock

import matplotlib.animation as animation
import matplotlib.pyplot as plt
import numpy as np


# =============================================================================
# 1. Case settings (Modify these as necessary for the assignment)
# =============================================================================
# Calorically perfect air
GAMMA = 1.4
R_GAS = 287.05                 # J/(kg K)

# Jet-exit and ambient conditions.
P_AMBIENT = 101325.0           # Pa
T_AMBIENT = 300.0              # K
M_EXIT = 3.0		       # Initial Jet Mach Number
T_EXIT = 260.0                 # K, Initial Jet Temperature
PRESSURE_RATIO = 0.8         # P_exit/P_ambient;

# Nozzle height h provides the reference length.  Only y >= 0 is computed, so
# the prescribed inlet jet occupies 0 <= y <= h/2.
NOZZLE_HEIGHT = 0.006          # m
DOMAIN_LENGTHS_X = 6.0        # Lx/h (Note: Domain is this many nozzle heights long)
DOMAIN_LENGTHS_Y = 3.0        # Ly/h in the computed half-domain (Note: Domain is this many nozzle heights tall)
CELLS_PER_HEIGHT = 16          # Number of points across nozzle height (Note: This defines NY, NX, DX, and DY given NOZZLE_HEIGHT)

# Define whether the initial field should be constant (0), or a strip down the middle (1)
INITIAL_JET = 1

NX = int(DOMAIN_LENGTHS_X * CELLS_PER_HEIGHT)
NY = int(DOMAIN_LENGTHS_Y * CELLS_PER_HEIGHT)
LX = DOMAIN_LENGTHS_X * NOZZLE_HEIGHT
LY = DOMAIN_LENGTHS_Y * NOZZLE_HEIGHT
DX, DY = LX / NX, LY / NY

CFL = 0.45
CONVECTIVE_TIMES = 50.0        # final time measured in h/U_exit (Note: Use this to adjust end time)
SAVE_EVERY = 500               # How many timesteps between saving a figure
NG = 2                         # two ghost layers for MUSCL reconstruction (Note: Don't touch)

OUTPUT_DIRECTORY = Path("euler_jet_output")

# Video output
SAVE_VIDEO = True
VIDEO_EVERY = 25
VIDEO_FRAMES_PER_SECOND = 10
VIDEO_DPI = 120

# Fixed image and video color limits
PLOT_LIMITS = {
    "density": (0.50, 2.00),
    "pressure": (0.30, 2.00),       # p/P_ambient
    "mach": (0.00, 4.0),
    "schlieren": (-4.00, 3.00),     # log10(|grad rho|), dimensional
}


# =============================================================================
# 2. Thermodynamics and physical fluxes
# =============================================================================
def primitive_to_conserved(W):
    """Convert [..., rho, u, v, p] to [..., rho, rho*u, rho*v, rho*E]."""
    rho, u, v, p = [W[..., n] for n in range(4)]
    rho_E = p / (GAMMA - 1.0) + 0.5 * rho * (u**2 + v**2)
    return np.stack((rho, rho * u, rho * v, rho_E), axis=-1)


def conserved_to_primitive(U):
    """Convert [..., rho, rho*u, rho*v, rho*E] to [..., rho, u, v, p]."""
    rho = U[..., 0]
    u = U[..., 1] / rho
    v = U[..., 2] / rho
    kinetic_energy = 0.5 * rho * (u**2 + v**2)
    p = (GAMMA - 1.0) * (U[..., 3] - kinetic_energy)

    # Pressure floor
    p = np.maximum(p, 1.0)
    return np.stack((rho, u, v, p), axis=-1)


def uniform_state(p, T, mach):
    """Return [rho, u, v, p] for horizontal flow at the requested Mach number."""
    rho = p / (R_GAS * T)
    sound_speed = np.sqrt(GAMMA * R_GAS * T)
    return np.array([rho, mach * sound_speed, 0.0, p])


def physical_flux(W, direction):
    """Euler flux in x (direction=0) or y (direction=1)."""
    rho, u, v, p = [W[..., n] for n in range(4)]
    rho_E = p / (GAMMA - 1.0) + 0.5 * rho * (u**2 + v**2)
    if direction == 0:
        return np.stack((rho * u,
                         rho * u**2 + p,
                         rho * u * v,
                         (rho_E + p) * u), axis=-1)
    return np.stack((rho * v,
                     rho * u * v,
                     rho * v**2 + p,
                     (rho_E + p) * v), axis=-1)


# Initial and boundary states
P_EXIT = PRESSURE_RATIO * P_AMBIENT
W_AMBIENT = uniform_state(P_AMBIENT, T_AMBIENT, 0.0)
W_EXIT = uniform_state(P_EXIT, T_EXIT, M_EXIT)

# Pressure-matched initial jet state
W_INITIAL_JET = W_EXIT.copy()
W_INITIAL_JET[0] = P_AMBIENT / (R_GAS * T_EXIT)
W_INITIAL_JET[3] = P_AMBIENT

U_AMBIENT = primitive_to_conserved(W_AMBIENT)
U_EXIT = primitive_to_conserved(W_EXIT)
U_INITIAL_JET = primitive_to_conserved(W_INITIAL_JET)

U_EXIT_SPEED = W_EXIT[1]
T_FINAL = CONVECTIVE_TIMES * NOZZLE_HEIGHT / U_EXIT_SPEED


# =============================================================================
# 3. HLLC Riemann solver
# =============================================================================
def hllc_flux(W_left, W_right, direction):
    """Return the HLLC flux for arrays of left and right primitive states."""
    rho_L, u_L, v_L, p_L = [W_left[..., n] for n in range(4)]
    rho_R, u_R, v_R, p_R = [W_right[..., n] for n in range(4)]

    un_L = u_L if direction == 0 else v_L
    un_R = u_R if direction == 0 else v_R
    a_L = np.sqrt(GAMMA * p_L / rho_L)
    a_R = np.sqrt(GAMMA * p_R / rho_R)

    S_L = np.minimum(un_L - a_L, un_R - a_R)
    S_R = np.maximum(un_L + a_L, un_R + a_R)
    denominator = rho_L * (S_L - un_L) - rho_R * (S_R - un_R)
    denominator = np.where(np.abs(denominator) < 1.0e-14,
                           np.copysign(1.0e-14, denominator), denominator)
    S_star = (p_R - p_L
              + rho_L * un_L * (S_L - un_L)
              - rho_R * un_R * (S_R - un_R)) / denominator

    U_left = primitive_to_conserved(W_left)
    U_right = primitive_to_conserved(W_right)
    F_left = physical_flux(W_left, direction)
    F_right = physical_flux(W_right, direction)

    def star_state(W, U, S, un):
        rho, u, v, p = [W[..., n] for n in range(4)]
        rho_star = rho * (S - un) / (S - S_star)
        E_specific = U[..., 3] / rho
        rho_E_star = rho_star * (
            E_specific + (S_star - un)
            * (S_star + p / (rho * (S - un)))
        )
        if direction == 0:
            return np.stack((rho_star, rho_star * S_star,
                             rho_star * v, rho_E_star), axis=-1)
        return np.stack((rho_star, rho_star * u,
                         rho_star * S_star, rho_E_star), axis=-1)

    U_star_L = star_state(W_left, U_left, S_L, un_L)
    U_star_R = star_state(W_right, U_right, S_R, un_R)
    F_star_L = F_left + S_L[..., None] * (U_star_L - U_left)
    F_star_R = F_right + S_R[..., None] * (U_star_R - U_right)

    return np.where((S_L >= 0.0)[..., None], F_left,
           np.where((S_star >= 0.0)[..., None], F_star_L,
           np.where((S_R > 0.0)[..., None], F_star_R, F_right)))


# =============================================================================
# 4. Grid and boundary conditions
# =============================================================================
X = (np.arange(NX) + 0.5) * DX
Y = (np.arange(NY) + 0.5) * DY
XX, YY = np.meshgrid(X, Y)


def apply_boundary_conditions(U):
    """Fill boundary ghost cells."""
    # Left: prescribed jet and ambient states
    y_with_ghosts = (np.arange(NY + 2 * NG) - NG + 0.5) * DY
    inside_nozzle = y_with_ghosts <= 0.5 * NOZZLE_HEIGHT
    U[:, :NG, :] = U_AMBIENT
    U[inside_nozzle, :NG, :] = U_EXIT

    # Right: zero normal gradient
    U[:, -NG:, :] = U[:, -NG - 1:-NG, :]

    # Top: prescribed ambient state
    U[-NG:, :, :] = U_AMBIENT

    # Bottom: centerline symmetry
    for layer in range(NG):
        ghost = NG - 1 - layer
        image = NG + layer
        U[ghost, :, :] = U[image, :, :]
        U[ghost, :, 2] *= -1.0


def initial_condition():
    """Ambient gas surrounding a pressure-matched straight jet."""
    U = np.empty((NY + 2 * NG, NX + 2 * NG, 4))
    U[...] = U_AMBIENT
    if (INITIAL_JET == 1):
    	physical = U[NG:NG + NY, NG:NG + NX, :]
    	physical[YY <= 0.5 * NOZZLE_HEIGHT] = U_INITIAL_JET
    apply_boundary_conditions(U)
    return U


# =============================================================================
# 5. MUSCL reconstruction and finite-volume residual
# =============================================================================
def minmod_three(a, b, c):
    """Return the smallest argument when all three have the same sign."""
    same_sign = (a * b > 0.0) & (a * c > 0.0)
    smallest = np.minimum(np.abs(a), np.minimum(np.abs(b), np.abs(c)))
    return np.where(same_sign, np.sign(a) * smallest, 0.0)


def mc_limiter(backward_difference, forward_difference):
    """Return a monotonized-central limited slope."""
    centered_difference = 0.5 * (backward_difference + forward_difference)
    return minmod_three(2.0 * backward_difference,
                        centered_difference,
                        2.0 * forward_difference)


def muscl_face_fluxes(W):
    """Reconstruct primitive states and solve a Riemann problem at every face."""
    slope_x = np.zeros_like(W)
    slope_y = np.zeros_like(W)

    backward_x = W[:, 1:-1, :] - W[:, :-2, :]
    forward_x = W[:, 2:, :] - W[:, 1:-1, :]
    backward_y = W[1:-1, :, :] - W[:-2, :, :]
    forward_y = W[2:, :, :] - W[1:-1, :, :]

    slope_x[:, 1:-1, :] = mc_limiter(backward_x, forward_x)
    slope_y[1:-1, :, :] = mc_limiter(backward_y, forward_y)

    W_left_x = W[:, :-1, :] + 0.5 * slope_x[:, :-1, :]
    W_right_x = W[:, 1:, :] - 0.5 * slope_x[:, 1:, :]
    W_left_y = W[:-1, :, :] + 0.5 * slope_y[:-1, :, :]
    W_right_y = W[1:, :, :] - 0.5 * slope_y[1:, :, :]

    flux_x = hllc_flux(W_left_x, W_right_x, direction=0)
    flux_y = hllc_flux(W_left_y, W_right_y, direction=1)
    return flux_x, flux_y


def right_hand_side(U):
    """Compute dU/dt = -div(F) in every physical control volume."""
    apply_boundary_conditions(U)
    W = conserved_to_primitive(U)
    flux_x, flux_y = muscl_face_fluxes(W)

    physical_x = slice(NG, NG + NX)
    physical_y = slice(NG, NG + NY)

    divergence = (
        (flux_x[physical_y, NG:NG + NX, :]
         - flux_x[physical_y, NG - 1:NG + NX - 1, :]) / DX
        +
        (flux_y[NG:NG + NY, physical_x, :]
         - flux_y[NG - 1:NG + NY - 1, physical_x, :]) / DY
    )

    dUdt = np.zeros_like(U)
    dUdt[physical_y, physical_x, :] = -divergence
    return dUdt


# =============================================================================
# 6. CFL time step and second-order RK2 update
# =============================================================================
def stable_time_step(U):
    """Use the two-dimensional convective/acoustic CFL restriction."""
    apply_boundary_conditions(U)
    W = conserved_to_primitive(U)[NG:-NG, NG:-NG, :]
    rho, u, v, p = [W[..., n] for n in range(4)]
    sound_speed = np.sqrt(GAMMA * p / rho)
    spectral_rate = ((np.abs(u) + sound_speed) / DX
                     + (np.abs(v) + sound_speed) / DY)
    return CFL / np.max(spectral_rate)


def advance_rk2(U, dt):
    """Advance one second-order strong-stability-preserving RK step."""
    U_stage = U + dt * right_hand_side(U)
    apply_boundary_conditions(U_stage)
    U_next = 0.5 * (U + U_stage + dt * right_hand_side(U_stage))
    apply_boundary_conditions(U_next)
    return U_next


# =============================================================================
# 7. Output
# =============================================================================
def mirror_for_plot(field):
    """Reflect a scalar half-domain field to display the complete planar jet."""
    return np.vstack((field[::-1, :], field))


def displayed_fields(U):
    """Return the four full-domain fields shared by images and video frames."""
    W = conserved_to_primitive(U)[NG:-NG, NG:-NG, :]
    rho, u, v, p = [W[..., n] for n in range(4)]
    sound_speed = np.sqrt(GAMMA * p / rho)
    mach = np.sqrt(u**2 + v**2) / sound_speed
    density_gradient = np.sqrt(np.gradient(rho, DY, axis=0)**2
                               + np.gradient(rho, DX, axis=1)**2)

    return [
        (mirror_for_plot(rho), "density [kg/m³]", "density"),
        (mirror_for_plot(p / P_AMBIENT),
         "pressure / ambient pressure", "pressure"),
        (mirror_for_plot(mach), "Mach number", "mach"),
        (mirror_for_plot(np.log10(density_gradient + 1.0e-8)),
         "log₁₀ |∇density|", "schlieren"),
    ]


def figure_title(time):
    """Use the same title for still images and video frames."""
    convective_time = time * U_EXIT_SPEED / NOZZLE_HEIGHT
    return (f"Planar jet: pₑ/p∞ = {PRESSURE_RATIO:.2f}, "
            f"tUₑ/h = {convective_time:.1f}")


def plot_solution(U, time, step):
    """Save four contours using the fixed limits in PLOT_LIMITS."""
    y_full = np.concatenate((-Y[::-1], Y)) / NOZZLE_HEIGHT
    x_scaled = X / NOZZLE_HEIGHT

    fig, axes = plt.subplots(2, 2, figsize=(12, 7), constrained_layout=True)
    for ax, (field, title, key) in zip(axes.flat, displayed_fields(U)):
        lower, upper = PLOT_LIMITS[key]
        levels = np.linspace(lower, upper, 61)
        contour = ax.contourf(x_scaled, y_full, field, levels=levels,
                              cmap="turbo", extend="both")
        fig.colorbar(contour, ax=ax)
        ax.set_title(title)
        ax.set_xlabel("x/h")
        ax.set_ylabel("y/h")
        ax.set_aspect("equal")
    fig.suptitle(figure_title(time))
    fig.savefig(OUTPUT_DIRECTORY / f"jet_{step:05d}.png", dpi=160)
    plt.close(fig)


def create_video_figure(U, time):
    """Create four image artists whose data can be updated for each frame."""
    extent = (0.0, DOMAIN_LENGTHS_X, -DOMAIN_LENGTHS_Y, DOMAIN_LENGTHS_Y)
    fig, axes = plt.subplots(2, 2, figsize=(12, 7), constrained_layout=True)
    image_artists = []

    for ax, (field, title, key) in zip(axes.flat, displayed_fields(U)):
        lower, upper = PLOT_LIMITS[key]
        image = ax.imshow(field, origin="lower", extent=extent, cmap="turbo",
                          vmin=lower, vmax=upper, interpolation="bilinear")
        fig.colorbar(image, ax=ax, extend="both")
        ax.set_title(title)
        ax.set_xlabel("x/h")
        ax.set_ylabel("y/h")
        ax.set_aspect("equal")
        image_artists.append(image)

    title_artist = fig.suptitle(figure_title(time))
    return fig, image_artists, title_artist


def write_video_frame(U, time, image_artists, title_artist, writer):
    """Update the four fields and send one frame to the active video writer."""
    for image, (field, _, _) in zip(image_artists, displayed_fields(U)):
        image.set_data(field)
    title_artist.set_text(figure_title(time))
    writer.grab_frame()


def start_video(U, time):
    """Start an MP4 writer, with an animated-GIF fallback when needed."""
    figure, images, title = create_video_figure(U, time)
    if animation.FFMpegWriter.isAvailable():
        path = OUTPUT_DIRECTORY / "jet_evolution.mp4"
        writer = animation.FFMpegWriter(fps=VIDEO_FRAMES_PER_SECOND,
                                        bitrate=2400)
    else:
        path = OUTPUT_DIRECTORY / "jet_evolution.gif"
        writer = animation.PillowWriter(fps=VIDEO_FRAMES_PER_SECOND)
        print("FFmpeg was not found; writing an animated GIF instead of MP4")

    writer.setup(figure, str(path), dpi=VIDEO_DPI)
    write_video_frame(U, time, images, title, writer)
    return writer, figure, images, title, path


def save_centerline_curve(values, ylabel, filename,
                          reference_value=None, reference_label=None):
    """Save one final centerline quantity versus x/h."""
    fig, ax = plt.subplots(figsize=(8, 3.5), constrained_layout=True)
    ax.plot(X / NOZZLE_HEIGHT, values, color="black", linewidth=1.5)
    if reference_value is not None:
        ax.axhline(reference_value, color="tab:red", linestyle="--",
                   label=reference_label)
    ax.set(xlabel="x/h", ylabel=ylabel, xlim=(0.0, DOMAIN_LENGTHS_X))
    ax.grid(alpha=0.25)
    if reference_value is not None:
        ax.legend()
    fig.savefig(OUTPUT_DIRECTORY / filename, dpi=180)
    plt.close(fig)


def plot_centerline_quantities(U):
    """Save final pressure, temperature, and Mach-number centerline plots."""
    W = conserved_to_primitive(U)[NG:-NG, NG:-NG, :]
    rho, u, v, p = [W[0, :, n] for n in range(4)]
    temperature = p / (rho * R_GAS)
    mach = np.sqrt(u**2 + v**2) / np.sqrt(GAMMA * p / rho)

    save_centerline_curve(p / P_AMBIENT,
                          "centerline pressure / ambient pressure",
                          "centerline_pressure.png", 1.0, "ambient pressure")
    save_centerline_curve(temperature, "centerline temperature [K]",
                          "centerline_temperature.png",
                          T_AMBIENT, "ambient temperature")
    save_centerline_curve(mach, "centerline Mach number",
                          "centerline_mach.png", M_EXIT, "exit Mach number")


def export_final_fields(U):
    """Export final full-domain scalar fields as CSV matrices."""
    W = conserved_to_primitive(U)[NG:-NG, NG:-NG, :]
    rho, u, v, p = [W[..., n] for n in range(4)]
    temperature = p / (rho * R_GAS)
    mach = np.sqrt(u**2 + v**2) / np.sqrt(GAMMA * p / rho)

    fields = {
        "final_density.csv": rho,
        "final_pressure.csv": p,
        "final_temperature.csv": temperature,
        "final_mach.csv": mach,
    }
    for filename, half_domain_field in fields.items():
        full_domain_field = mirror_for_plot(half_domain_field)
        np.savetxt(OUTPUT_DIRECTORY / filename, full_domain_field,
                   delimiter=",", fmt="%.10e")


# =============================================================================
# 8. Main time-marching loop
# =============================================================================
def main():
    OUTPUT_DIRECTORY.mkdir(exist_ok=True)
    U = initial_condition()
    simulation_time = 0.0
    step = 0
    start_time = wall_clock.perf_counter()

    print("Two-dimensional Euler simulation of a planar jet")
    print(f"pressure ratio p_exit/p_ambient = {PRESSURE_RATIO:.3f}")
    print(f"half-domain grid = {NX} x {NY} cells")
    print(f"resolution = {CELLS_PER_HEIGHT} cells per nozzle height")
    print(f"final time = {T_FINAL * 1.0e6:.1f} microseconds "
          f"= {CONVECTIVE_TIMES:.1f} h/U_exit")
    plot_solution(U, simulation_time, step)

    video_writer = None
    video_figure = None
    video_images = None
    video_title = None
    video_path = None
    last_video_step = -1
    if SAVE_VIDEO:
        (video_writer, video_figure, video_images,
         video_title, video_path) = start_video(U, simulation_time)
        last_video_step = 0

    try:
        while simulation_time < T_FINAL:
            dt = min(stable_time_step(U), T_FINAL - simulation_time)
            U = advance_rk2(U, dt)
            simulation_time += dt
            step += 1

            if SAVE_VIDEO and step % VIDEO_EVERY == 0:
                write_video_frame(U, simulation_time, video_images,
                                  video_title, video_writer)
                last_video_step = step

            if SAVE_EVERY and step % SAVE_EVERY == 0:
                elapsed = wall_clock.perf_counter() - start_time
                convective_time = simulation_time * U_EXIT_SPEED / NOZZLE_HEIGHT
                W = conserved_to_primitive(U)[NG:-NG, NG:-NG, :]
                print(f"step {step:5d}: tU/h = {convective_time:6.2f}, "
                      f"min(p) = {W[..., 3].min():9.1f} Pa, "
                      f"wall time = {elapsed:6.1f} s")
                plot_solution(U, simulation_time, step)

        if SAVE_VIDEO and last_video_step != step:
            write_video_frame(U, simulation_time, video_images,
                              video_title, video_writer)
    finally:
        if video_writer is not None:
            video_writer.finish()
            plt.close(video_figure)

    plot_solution(U, simulation_time, step)
    plot_centerline_quantities(U)
    export_final_fields(U)
    elapsed = wall_clock.perf_counter() - start_time
    print(f"Finished {step} steps in {elapsed:.1f} s")
    print(f"Figures written to {OUTPUT_DIRECTORY}/")
    if video_path is not None:
        print(f"Video written to {video_path}")


if __name__ == "__main__":
    main()
