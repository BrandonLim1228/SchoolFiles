import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import time

start_time1 = time.perf_counter()

x_start = 0
x_end = 1

t_start = 0
t_end = 1

nx = 50 #number of grid points for x
CFL = 0.8

a = 1

dx = (x_end-x_start)/nx
dt = (CFL*dx)/a

nt = int((t_end-t_start)/dt)

x50 = np.arange(x_start,x_end,dx)

u0 = np.exp(-100*(x50-0.5)**2)

u_n = np.zeros(len(x50))
u_np1 = np.zeros(len(x50))
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

u_history50 = u_history

end_time1 = time.perf_counter()

time1 = start_time1-end_time1

start_time2 = time.perf_counter()

x_start = 0
x_end = 1

t_start = 0
t_end = 1

dx50 = dx
e50 = 1/nx * np.sum(np.abs(u_history50[-1,:] - u_history50[0,:]))

nx = 100 #number of grid points for x
CFL = 0.8

a = 1

dx = (x_end-x_start)/nx
dt = (CFL*dx)/a

nt = int((t_end-t_start)/dt)

x100 = np.arange(x_start,x_end,dx)

u0 = np.exp(-100*(x100-0.5)**2)

u_n = np.zeros(len(x100))
u_np1 = np.zeros(len(x100))
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

u_history100 = u_history

end_time2 = time.perf_counter()

time2 = start_time2-end_time2

start_time3 = time.perf_counter()

dx100 = dx

e100 = 1/nx * np.sum(np.abs(u_history100[-1,:] - u_history100[0,:]))


x_start = 0
x_end = 1

t_start = 0
t_end = 1

nx = 200 #number of grid points for x
CFL = 0.8

a = 1

dx = (x_end-x_start)/nx
dt = (CFL*dx)/a

nt = int((t_end-t_start)/dt)

x200 = np.arange(x_start,x_end,dx)

u0 = np.exp(-100*(x200-0.5)**2)

u_n = np.zeros(len(x200))
u_np1 = np.zeros(len(x200))
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

u_history200 = u_history

dx200 = dx
e200 = 1/nx * np.sum(np.abs(u_history200[-1,:] - u_history200[0,:]))

end_time3 = time.perf_counter()

time3 = start_time3-end_time3

start_time4 = time.perf_counter()

x_start = 0
x_end = 1

t_start = 0
t_end = 1

nx = 400 #number of grid points for x
CFL = 0.8

a = 1

dx = (x_end-x_start)/nx
dt = (CFL*dx)/a

nt = int((t_end-t_start)/dt)

x400 = np.arange(x_start,x_end,dx)

u0 = np.exp(-100*(x400-0.5)**2)

u_n = np.zeros(len(x400))
u_np1 = np.zeros(len(x400))
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

u_history400 = u_history

dx400 = dx
e400 = 1/nx * np.sum(np.abs(u_history400[-1,:] - u_history400[0,:]))

end_time4 = time.perf_counter()

time4 = start_time4-end_time4




plt.subplot(2,2,1)
plt.plot(x50,u_history50[0,:],"k",label="Initial Solution")
plt.plot(x50,u_history50[-1,:],"r",label="Final Solution")
plt.xlabel("x")
plt.ylabel("u")
plt.legend()
plt.title("n = 50")

plt.subplot(2,2,2)
plt.plot(x100,u_history100[0,:],"k",label="Initial Solution")
plt.plot(x100,u_history100[-1,:],"r",label="Final Solution")
plt.xlabel("x")
plt.ylabel("u")
plt.legend()
plt.title("n = 100")

plt.subplot(2,2,3)
plt.plot(x200,u_history200[0,:],"k",label="Initial Solution")
plt.plot(x200,u_history200[-1,:],"r",label="Final Solution")
plt.xlabel("x")
plt.ylabel("u")
plt.legend()
plt.title("n = 200")

plt.subplot(2,2,4)
plt.plot(x400,u_history400[0,:],"k",label="Initial Solution")
plt.plot(x400,u_history400[-1,:],"r",label="Final Solution")
plt.xlabel("x")
plt.ylabel("u")
plt.legend()
plt.title("n = 400")

plt.show()

n = [50, 100, 200, 400]
t = [-time1, -time2, -time3, -time4]
plt.plot(n,t)
plt.xlabel("Number of Nodes")
plt.ylabel("Computing Time")
plt.show()

e = [e50, e100, e200, e400]
dxvec = [dx50, dx100, dx200,dx400]
plt.plot(dxvec,e)
plt.xlabel("dx")
plt.ylabel("error")
plt.show()