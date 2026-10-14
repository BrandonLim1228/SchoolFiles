import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Initializing Variables
x_start = 0
x_end = 1

t_start = 0
t_end = 1

nx = 100 #number of grid points
CFL = 0.8

dx = (x_end-x_start)/nx
x = np.arange(x_start,x_end,dx) #establishing discretized x locations

u0 = np.exp(-100*(x-0.5)**2) #Calculating inital condition on the x grid

u_n = np.zeros(len(x)) #Initializing current time grid point velocity vector
u_np1 = np.zeros(len(x)) #Initializing next time grid point velocity vector


u_n = u0.copy() #Assigning the first current time grid point velocity vector to the initial condition

dt = (CFL*dx)/max(np.abs(u0)) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum velocity in my domain

u_history = [] #Initializing a time history velocity vector to store information for animations
t_history = []

t_current = 0

while t_current < t_end: #Loop through time until we have simulated up until the end time 
    for i in range(nx): #Loop through the grid points
        if i == 0:
            u_np1[i] = u_n[i] - (u_n[i] * dt/dx)*(u_n[i] - u_n[-1])
        else:
            u_np1[i] = u_n[i] - (u_n[i] * dt/dx)*(u_n[i] - u_n[i-1])

    t_current = t_current + dt
    u_n = u_np1.copy()
    dt = (CFL*dx)/max(np.abs(u_n))

    u_history.append(u_n.copy())
    t_history.append(t_current)

u_history = np.array(u_history)

u_history_nc = u_history.copy()

Q_nc = np.sum(u_history_nc*dx,axis=1)
t_history_nc = t_history

# plt.plot(x,u_np1)
# plt.xlabel("x")
# plt.ylabel("u")
# plt.title("t = 1")
# plt.show()


# plt.plot(x,u_history[0,:],"k",label="Initial Solution")
# plt.plot(x,u_history[-1,:],"r",label="Final Solution")
# plt.xlabel("x")
# plt.ylabel("u")
# plt.legend()
# plt.title("Initial and Final Solutions")

# plt.show()


# fig, ax = plt.subplots()

# line, = ax.plot(x, u_history[0, :])
# ax.set_xlim(x_start, x_end)
# ax.set_ylim(np.min(u_history), np.max(u_history))

# def update(frame):
#     line.set_ydata(u_history[frame, :])
#     ax.set_title(f"Time = {t_history[frame]:.3f} s")
#     return line,

# animation = FuncAnimation(
#     fig,
#     update,
#     frames=len(u_history),
#     interval=50
# )

# plt.show()


# Initializing Variables
x_start = 0
x_end = 1

t_start = 0
t_end = 1

nx = 100 #number of grid points
CFL = 0.8

dx = (x_end-x_start)/nx
x = np.arange(x_start,x_end,dx) #establishing discretized x locations

u0 = np.exp(-100*(x-0.5)**2) #Calculating inital condition on the x grid

u_n = np.zeros(len(x)) #Initializing current time grid point velocity vector
u_np1 = np.zeros(len(x)) #Initializing next time grid point velocity vector


u_n = u0.copy() #Assigning the first current time grid point velocity vector to the initial condition

dt = (CFL*dx)/max(np.abs(u0)) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum velocity in my domain

u_history = [] #Initializing a time history velocity vector to store information for animations
t_history = []

t_current = 0

while t_current < t_end: #Loop through time until we have simulated up until the end time 
    for i in range(nx): #Loop through the grid points
        if i == 0:
            u_np1[i] = u_n[i] - (dt/(2*dx))*(u_n[i]**2 - u_n[-1]**2)
        else:
            u_np1[i] = u_n[i] - (dt/(2*dx))*(u_n[i]**2 - u_n[i-1]**2)

    t_current = t_current + dt
    u_n = u_np1.copy()
    dt = (CFL*dx)/max(np.abs(u_n))

    u_history.append(u_n.copy())
    t_history.append(t_current)

u_history = np.array(u_history)

u_history_c = u_history.copy()

Q_c = np.sum(u_history_c*dx,axis=1)
t_history_c = t_history


Q0 = np.sum(u0*dx)
# plt.plot(x,u_np1)
# plt.xlabel("x")
# plt.ylabel("u")
# plt.title("t = 1")
# plt.show()


# plt.plot(x,u_history_nc[-1,:],"k",label="Non Conservative Solution")
# plt.plot(x,u_history_c[-1,:],"r",label="Conservative Solution")
# plt.xlabel("x")
# plt.ylabel("u")
# plt.legend()
# plt.title("Non Conservative vs Conservative Solutions")

# plt.show()


# fig, ax = plt.subplots()

# line, = ax.plot(x, u_history[0, :])
# ax.set_xlim(x_start, x_end)
# ax.set_ylim(np.min(u_history), np.max(u_history))

# def update(frame):
#     line.set_ydata(u_history[frame, :])
#     ax.set_title(f"Time = {t_history[frame]:.3f} s")
#     return line,

# animation = FuncAnimation(
#     fig,
#     update,
#     frames=len(u_history),
#     interval=50
# )

# plt.show()

plt.plot(t_history_nc,Q_nc,"k",label="Non Conservative")
plt.plot(t_history_c,Q_c,"r",label="Conservative ")
plt.plot(0,Q0,"bo",label="Q0")

plt.xlabel("t")
plt.ylabel("Q")
plt.legend()
plt.title("Non Conservative vs Conservative")

plt.show()