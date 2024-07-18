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

## Highlighted scripts for reproducing the results of the study

### Demand_and_Emissions_patterns
Plots the daily and weekly patterns used in the study for demand and emissions. 

![demand](https://github.com/user-attachments/assets/19dccf88-fd28-4f90-a27b-c391456cd0ab)
![emissions](https://github.com/user-attachments/assets/40dae28d-e296-458e-afd4-d03e66ccbc96)

### Heuristic_Controller_Used_In_Paper
A model of the system that uses rules-based control. 
When a tank is empty, its valves close and pumps turn on. When a tank is full, valves open and pumps turn off.
Running this script provides you with the results for the reactive system, as seen in the case study of the paper.

### MPC_Controller_Used_In_Paper
A model of the system that uses a predictive controller. 
The function "best_settings_Cl.m" simulates the system over a range of control actions, and then returns the actions that resulted in the best performance over the range of simulations.
Running this script provides you with the results for the predictive system, as seen in the case study of the paper.

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

The predictive control scheme uses the function best_settings_Cl.m to determine the control actions that result in the best performance over a range of simulations.

The cost weights for pressure, emissions, and chlorine were determined by starting with weights that scaled the minimum cost in each category to 1, and then iteratively adjusting their values and re-running the simulation until a desired performance was achieved.
Future work will apply adaptive methods to develop the weights for water treatment systems.

The control and prediction horizons cover the current and next time step and are both 5 minutes (out of a 5-day simulation period).
A short prediction horizon as possible was chosen for low computational complexity and fast turnaround to confirm the feasibility of the control scheme.
Future work will refine the code to increase the length of the predictive, control and windows (delay) horizons and examine their sensitivities.

## Conclusions from the study
A control-oriented model was developed for a water treatment facility and a dynamic modeling framework is applied to a hydraulic system to evaluate the performance of MPC methods on meeting system objectives for a water treatment plant.
The controller has been simulated in a case study to show improvement for hydraulic performance as well as emissions and chemical objectives specific to sustainable water treatment.

This study is limited by the assumption that the model precisely predicts the behavior of the true system.
This is a result of making simplifying assumptions such as sufficiently fast low-level control, linear system element dynamics, and knowledge of true system parameters.
Further studies will be refined by incorporating complexities such as model mismatch, state uncertainty due to process noise, or dynamic state observation to compensate for poorly instrumented systems.

Ongoing work is investigating the robustness of the controller with further case study simulating disruptive scenarios such as pump fouling and load shedding.
A planned future extension to this work is development and experimental testing of a physical hydraulic testbed to test the proposed model and controller in more realistic scenarios.

