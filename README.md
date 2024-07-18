# Water-Treatment-Modeling-MECC24

### Introduction

MATLAB code used to simulate the pressures, flows, energy consumption, emissions generation, and output water quality of a water treatment plant. 
Used to compare the performance of a model-based predictive controller to a baseline heuristic rules-based controller

## Installation

As long as all the functions are in the same MATLAB directory, everything should work. 

### Clone the repository and change into the directory
```sh
git clone https://github.com/RyanMauery/Water-Treatment-Modeling-MECC24.git

cd Water-Treatment-Modeling-MECC24
```

## Explanation of files

### Demand_and_Emissions_patterns
Plots the daily and weekly patterns used in the study for demand and emissions. 

![demand](https://github.com/user-attachments/assets/19dccf88-fd28-4f90-a27b-c391456cd0ab)
![emissions](https://github.com/user-attachments/assets/40dae28d-e296-458e-afd4-d03e66ccbc96)

### Heuristic_Controller_Used_In_Paper
A model of the system that uses rules-based control. 
When a tank is empty, its valves close and pumps turn on. When a tank is full, valves open and pumps turn off

### MPC_Controller_Used_In_Paper
A model of the system that uses a predictive controller. The function "best_settings_Cl.m" simulates the system over a range of control actions, and then returns the actions that resulted in the best performance over the range of simulations

# Supplemental information about the model and simulation

### Component diagram for elements with notation for node pressure and link flow rate

Pumps: have either a prescribed flow rate or prescribed pressure head. Energy consumed is proportional to the product of pressure and flow
Pipes/filters: a pressure drop occurs proportional to and in the direction of the flow through
Tanks: tank pressure increases linearly when filled with a constant flow rate (pumped) and decreases exponentially when emptied by pressure-driven flow (valve)

![image](https://github.com/user-attachments/assets/25d5c289-dfbf-4ed8-a095-c123416c3b4f)
Diagram from a conference poster on the dynamic elements used in the system

### System model topology

The main pathway of the treatment process starts at a low pressure reservoir and flows through the pressure-controlled source pump P_S. The source pump raises the node pressure to the source pump pressure, the treatment block RT induces time delay and pressure drop for flocculation and cartridge filtration, and the compensating booster pump PB regulates the effluent pressure. Parallel to the source and pressure pumps are the raw and processed storage tanks x1 and x2. The flow-controlled pumps Fp1 and Fp2 connect to the tank inlets, and the tank outlets flow through the valves r1 and r2 respectively.

![flow - controlled system model](https://github.com/user-attachments/assets/96c0bc73-9162-4906-bfa9-e3f2f9cdff94)

Flow-circuit diagram of the system model

### MPC design
