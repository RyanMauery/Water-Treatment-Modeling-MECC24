clc;
clear variables;
close all;

% Shows the demand (one day, repeats) and emissions patterns (five days, doesn't repeat) used over the study

t=1:24;
i=1:120;

demand=demandfcn(t);
emissions=emission_sample(i);

figure
stairs(t,demand)
title("Demand pattern, one day")
ylabel("Flow demand (GPM)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")

figure
plot(i,emissions*2.83*10e-8)
title("Emissions Cost of Energy Consumption")
ylabel("Emissions per energy (MMt CO2e / MWh)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")