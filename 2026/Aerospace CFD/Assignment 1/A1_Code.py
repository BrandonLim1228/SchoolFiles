import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

x_start = 0
x_end = 1

t_start = 0
t_end = 2

nx = 100 #number of grid points for x
CFL = 0.5

a = 1

dx = (x_end-x_start)/nx
dt = (CFL*dx)/a

nt = int((t_end-t_start)/dt)

x = np.arange(x_start,x_end,dx)

u0 = np.exp(-100*(x-0.5)**2)

u_n = np.zeros(len(x))
u_np1 = np.zeros(len(x))
u_history = np.zeros((nt,nx))


u_n = u0.copy()

for n in range(nt):
    for i in range(nx):
        if i == 0:
            u_np1[i] = u_n[i] - CFL*(u_n[i] - u_n[-1])
        else:
            u_np1[i] = u_n[i] - CFL*(u_n[i] - u_n[i-1])
    u_n = u_np1.copy()
    u_history[n,:] = u_n.copy()


plt.plot(x,u_np1)
plt.xlabel("x")
plt.ylabel("u")
plt.title("t = 1")
plt.show()


plt.plot(x,u_history[0,:],"k",label="Initial Solution")
plt.plot(x,u_history[-1,:],"r",label="Final Solution")
plt.xlabel("x")
plt.ylabel("u")
plt.legend()
plt.title("Initial and Final Solutions")

plt.show()


fig, ax = plt.subplots()

line, = ax.plot(x, u_history[0, :])
ax.set_xlim(x_start, x_end)
ax.set_ylim(np.min(u_history), np.max(u_history))

def update(frame):
    line.set_ydata(u_history[frame, :])
    ax.set_title(f"Time = {frame * dt:.3f} s")
    return line,

animation = FuncAnimation(
    fig,
    update,
    frames=len(u_history),
    interval=50
)

plt.show()

# %%

