import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Initializing Variables
x_start = 0
x_end   = 1
y_start = -0.5
y_end   = 0.5
t_start = 0
t_end   = 0.0002
nx      = 101 #number of grid points in x
ny      = 101 #number of grid points in y
CFL     = 0.8
R       = 287 #gas constant
gamma   = 1.4 #ratio of specific heats

# Calculating problem parameters
dx = (x_end-x_start)/(nx-1)
dy = (y_end-y_start)/(ny-1)
x  = np.linspace(x_start,x_end,nx) #establishing discretized x locations
y  = np.linspace(y_start,y_end,ny) #establishing discretized x locations

# Initializing Variable Matricies
u_n     = np.zeros((len(x), len(y)))  #Initializing current time grid point u vector
u_np1   = np.zeros((len(x), len(y)))  #Initializing next time grid point u vector
v_n     = np.zeros((len(x), len(y)))  #Initializing current time grid point v vector
v_np1   = np.zeros((len(x), len(y)))  #Initializing next time grid point v vector
rho_n   = np.zeros((len(x), len(y)))  #Initializing current time grid point density vector
rho_np1 = np.zeros((len(x), len(y)))  #Initializing next time grid point demsotu vector
p_n     = np.zeros((len(x), len(y)))  #Initializing current time grid point pressure vector
p_np1   = np.zeros((len(x), len(y)))  #Initializing next time grid point pressure 
E_n     = np.zeros((len(x), len(y)))  #Initializing current time grid point rho vector
E_np1   = np.zeros((len(x), len(y)))  #Initializing next time grid point rho vector

# Initial Conditions
u0   = 2000 + u_n
v0   = v_n.copy()
rho0 = 1 + rho_n
p0   = 101325 + p_n
E0   = ((p0/(gamma-1)) + (0.5*rho0*(u0**2+v0**2)))/rho0

# Applying initial conditions to current time step matricies
u_n   = u0.copy()
v_n   = v0.copy()
rho_n = rho0.copy()
p_n   = p0.copy()
E_n   = E0.copy()

# Initializing time history matricies
u_history = np.empty((nx,ny,0)) #Initializing a time history u vector to store information for animations
v_history = np.empty((nx,ny,0)) #Initializing a time history v vector to store information for animations
rho_history = np.empty((nx,ny,0)) #Initializing a time history density vector to store information for animations
p_history = np.empty((nx,ny,0)) #Initializing a time history pressure vector to store information for animations
E_history = np.empty((nx,ny,0)) #Initializing a time history energy vector to store information for animations
t_history = []

# Creating time variables
a = np.sqrt((gamma*p_n)/rho_n)          #Calculating the speed of sound at every point in space
dt_x = (CFL*dx)/np.max(np.abs(u_n) + a) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum u in my domain
dt_y = (CFL*dy)/np.max(np.abs(v_n) + a) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum u in my domain 
dt   = min([dt_x,dt_y])                 #Choosing the smallest dt from the minumum dt of x and y

t_current = 0

box_x_start_idx = np.argmin(np.abs(x - 0.45))
box_x_end_idx   = np.argmin(np.abs(x - 0.55))
box_y_start_idx = np.argmin(np.abs(y - (-0.05)))
box_y_end_idx   = np.argmin(np.abs(y - 0.05))

while t_current < t_end: #Loop through time until we have simulated up until the end time 
    for j in range(ny): #Loop through y grid points (j==0, y==-0.5)
        for i in range(nx): #Loop through the x grid points (i==0, x==0)
            if (j == 0)or(j == ny-1)or(i==0):
              # Top, Bottom, and Inlet Boundary Conditions
              rho_np1[i,j] = 1
              u_np1[i,j]   = 2000
              v_np1[i,j]   = 0
              p_np1[i,j]   = 101325
              E_np1[i,j]   = ((p_np1[i,j]/(gamma-1)) + (0.5*rho_np1[i,j]*(u_np1[i,j]**2+v_np1[i,j]**2)))/rho_np1[i,j]
            elif(i==nx-1): 
              # Zero Gradient Boundary Condition for Outlet
              u_np1[i,j]   = u_np1[i-1,j]
              v_np1[i,j]   = v_np1[i-1,j]
              rho_np1[i,j] = rho_np1[i-1,j]
              p_np1[i,j]   = p_np1[i-1,j]
              E_np1[i,j]   = E_np1[i-1,j]
            elif(i>box_x_start_idx)and(i<box_x_end_idx)and(j>box_y_start_idx)and(j<box_y_end_idx):
              # Nothing happens inside the box, in this region the points will always represent the initial condition and will skip the flow evolution update
              u_np1[i,j]   = u_n[i,j]
              v_np1[i,j]   = v_n[i,j]
              rho_np1[i,j] = rho_n[i,j]
              p_np1[i,j]   = p_n[i,j]
              E_np1[i,j]   = E_n[i,j]
            elif(i==box_x_start_idx)and(j>box_y_start_idx)and(j<box_y_end_idx):
               # Slip-wall conditions for the box left wall
               u_np1[i,j]   = 0
               v_np1[i,j]   = v_n[i-1,j]
               rho_np1[i,j] = rho_n[i-1,j]
               p_np1[i,j]   = p_n[i-1,j]
               E_np1[i,j]   = E_n[i-1,j]
            elif(i==box_x_end_idx)and(j>box_y_start_idx)and(j<box_y_end_idx):
               # Slip-wall conditions for the box right wall
               u_np1[i,j]   = 0
               v_np1[i,j]   = v_n[i+1,j]
               rho_np1[i,j] = rho_n[i+1,j]
               p_np1[i,j]   = p_n[i+1,j]
               E_np1[i,j]   = E_n[i+1,j]
            elif(j==box_y_start_idx)and(i>box_x_start_idx)and(i<box_x_end_idx):
               # Slip-wall conditions for the box bottom wall
               u_np1[i,j]   = u_n[i,j-1]
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i,j-1]
               p_np1[i,j]   = p_n[i,j-1]
               E_np1[i,j]   = E_n[i,j-1]
            elif(j==box_y_end_idx)and(i>box_x_start_idx)and(i<box_x_end_idx):
               # Slip-wall conditions for the box top wall
               u_np1[i,j]   = u_n[i,j+1]
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i,j+1]
               p_np1[i,j]   = p_n[i,j+1]
               E_np1[i,j]   = E_n[i,j+1]
            elif(i==box_x_start_idx)and(j==box_y_start_idx):
               # Slip-wall conditions for the box bottom left corner
               u_np1[i,j]   = 0
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i-1,j-1]
               p_np1[i,j]   = p_n[i-1,j-1]
               E_np1[i,j]   = E_n[i-1,j-1]
            elif(i==box_x_start_idx)and(j==box_y_end_idx):
               # Slip-wall conditions for the box top left corner
               u_np1[i,j]   = 0
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i-1,j+1]
               p_np1[i,j]   = p_n[i-1,j+1]
               E_np1[i,j]   = E_n[i-1,j+1]
            elif(i==box_x_end_idx)and(j==box_y_start_idx):
               # Slip-wall conditions for the box bottom right corner
               u_np1[i,j]   = 0
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i+1,j-1]
               p_np1[i,j]   = p_n[i+1,j-1]
               E_np1[i,j]   = E_n[i+1,j-1]
            elif(i==box_x_end_idx)and(j==box_y_end_idx):
               # Slip-wall conditions for the box top right corner
               u_np1[i,j]   = 0
               v_np1[i,j]   = 0
               rho_np1[i,j] = rho_n[i+1,j+1]
               p_np1[i,j]   = p_n[i+1,j+1]
               E_np1[i,j]   = E_n[i+1,j+1]
            else:
              rho_np1[i,j] = (
                             0.25*(rho_n[i+1,j] + rho_n[i-1,j] + rho_n[i,j+1] + rho_n[i,j-1]) - 
                             dt*rho_n[i,j]*( ((u_n[i+1,j]-u_n[i-1,j])/(2*dx)) + ((v_n[i,j+1]-v_n[i,j-1])/(2*dy))) -
                             dt*( u_n[i,j]*((rho_n[i+1,j]-rho_n[i-1,j])/(2*dx)) + v_n[i,j]*((rho_n[i,j+1]-rho_n[i,j-1])/(2*dy)))
                             )
              u_np1[i,j]   = (
                             0.25*rho_n[i,j]*(u_n[i+1,j] + u_n[i-1,j] + u_n[i,j+1] + u_n[i,j-1]) + 
                             0.25*u_n[i,j]*(rho_n[i+1,j] + rho_n[i-1,j] + rho_n[i,j+1] + rho_n[i,j-1]) -
                             dt*(2*u_n[i,j]*rho_n[i,j]*((u_n[i+1,j]-u_n[i-1,j])/(2*dx)) + (u_n[i,j]**2)*((rho_n[i+1,j]-rho_n[i-1,j])/(2*dx))
                                + rho_n[i,j]*u_n[i,j]*((v_n[i,j+1]-v_n[i,j-1])/(2*dy)) + rho_n[i,j]*v_n[i,j]*((u_n[i,j+1]-u_n[i,j-1])/(2*dy))
                                + v_n[i,j]*u_n[i,j]*((rho_n[i,j+1]-rho_n[i,j-1])/(2*dy)) + 
                                ((p_n[i+1,j]-p_n[i-1,j])/(2*dx))) - 
                            (u_n[i,j]*rho_np1[i,j])
                             ) / rho_n[i,j]
              v_np1[i,j]   = (
                             0.25*rho_n[i,j]*(v_n[i+1,j] + v_n[i-1,j] + v_n[i,j+1] + v_n[i,j-1]) + 
                             0.25*v_n[i,j]*(rho_n[i+1,j] + rho_n[i-1,j] + rho_n[i,j+1] + rho_n[i,j-1]) -
                             dt*(2*v_n[i,j]*rho_n[i,j]*((v_n[i,j+1]-v_n[i,j-1])/(2*dy)) + (v_n[i,j]**2)*((rho_n[i,j+1]-rho_n[i,j-1])/(2*dy))
                                + rho_n[i,j]*u_n[i,j]*((v_n[i+1,j]-v_n[i-1,j])/(2*dx)) + rho_n[i,j]*v_n[i,j]*((u_n[i+1,j]-u_n[i-1,j])/(2*dx))
                                + v_n[i,j]*u_n[i,j]*((rho_n[i+1,j]-rho_n[i-1,j])/(2*dx)) + 
                                ((p_n[i,j+1]-p_n[i,j-1])/(2*dy))) - 
                            (v_n[i,j]*rho_np1[i,j])
                             ) / rho_n[i,j]
              E_np1[i,j]   = (
                             0.25*rho_n[i,j]*(E_n[i+1,j] + E_n[i-1,j] + E_n[i,j+1] + E_n[i,j-1]) + 
                             0.25*E_n[i,j]*(rho_n[i+1,j] + rho_n[i-1,j] + rho_n[i,j+1] + rho_n[i,j-1]) - 
                             dt*(
                                rho_n[i,j]*E_n[i,j]*((u_n[i+1,j]-u_n[i-1,j])/(2*dx)) + 
                                rho_n[i,j]*u_n[i,j]*((E_n[i+1,j]-E_n[i-1,j])/(2*dx)) + 
                                u_n[i,j]*E_n[i,j]*((rho_n[i+1,j]-rho_n[i-1,j])/(2*dx)) +
                                rho_n[i,j]*E_n[i,j]*((v_n[i,j+1]-v_n[i,j-1])/(2*dy)) +
                                rho_n[i,j]*v_n[i,j]*((E_n[i,j+1]-E_n[i,j-1])/(2*dy)) +
                                E_n[i,j]*v_n[i,j]*((rho_n[i,j+1]-rho_n[i,j-1])/(2*dy)) +
                                p_n[i,j]*((u_n[i+1,j]-u_n[i-1,j])/(2*dx)) + 
                                u_n[i,j]*((p_n[i+1,j]-p_n[i-1,j])/(2*dx)) +
                                p_n[i,j]*((v_n[i,j+1]-v_n[i,j-1])/(2*dy)) +
                                v_n[i,j]*((p_n[i,j+1]-p_n[i,j-1])/(2*dy))
                             ) -
                             (E_n[i,j] * rho_np1[i,j])
                             ) / rho_n[i,j]
              p_np1[i,j] = (gamma-1) * (rho_np1[i,j]*E_np1[i,j] - 0.5*rho_np1[i,j]*(u_np1[i,j]**2+v_np1[i,j]**2))
    #Updating the time
    t_current = t_current + dt

    #Updating the current time parameters
    u_n = u_np1.copy()
    v_n = v_np1.copy()
    rho_n = rho_np1.copy()
    p_n = p_np1.copy()
    E_n = E_np1.copy()

    a    = np.sqrt((gamma*p_n)/rho_n)       #Calculating the speed of sound at every point in space
    dt_x = (CFL*dx)/np.max(np.abs(u_n) + a) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum u in my domain
    dt_y = (CFL*dy)/np.max(np.abs(v_n) + a) #Calculating the most restrictive dt I can use based on a constant CFL number and the maximum u in my domain 
    dt   = min([dt_x,dt_y])                 #Choosing the smallest dt from the minumum dt of x and y

    #Keeping track of variables in history
    u_history   = np.dstack((u_history,u_n))
    v_history   = np.dstack((v_history,v_n))
    rho_history = np.dstack((rho_history,rho_n))
    p_history   = np.dstack((p_history,p_n))
    E_history   = np.dstack((E_history,E_n))
    t_history.append(t_current)

print("U1 = ", u_history[:,:,0])
print("Uend = ", u_history[:,:,-1])

print("V1 = ", v_history[:,:,0])
print("Vend = ", v_history[:,:,-1])

print("rho1 = ", rho_history[:,:,0])
print("rhoend = ", rho_history[:,:,-1])

print("p1 = ", p_history[:,:,0])
print("pend = ", p_history[:,:,-1])

print("E1 = ", E_history[:,:,0])
print("Eend = ", E_history[:,:,-1])