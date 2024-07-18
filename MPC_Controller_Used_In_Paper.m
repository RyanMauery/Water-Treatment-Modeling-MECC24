%% Initialization

clc;
clear variables;
close all;

% simulation parameters
tstep=5; % minutes for each step 
hours=24*5; % hours to simulate. Chosen to be 5 days to represent a work week
steps=(60/tstep)*hours; %number of steps in simulation

% linearized resistance and capacitance around 3500 GPM
Rs=5.2107e-4; %psi/GPM for L=100 ft D=12 in
Cp=5.7574e4; %G/psi for D=50 ft
% tank time constant = Rs*Cp = 30 minutes
R=10*Rs; % Resistance of filter cartridge

%initialize chlorine concentration in tank 2
concentration=12;   % mg/G for chlorine

%initialize tank pressures
x1=88;
x2=88;

% initialize actuator inputs
P_s=75;
fp1_0=0;
fp1=0;
r1=0;
Pb=10;
fp2=0;
r2=0;

%% Simulation

for i=1:steps
% Get current time (in hours) and demand from sample pattern (in GPM)
t(i)=i/12;
f_D=demandfcn(t(i));

% calculate current output pressure
P_d=1/(1+R*r2)*(P_s+Pb-R*(f_D+fp2-r2*x2));

% calculate pressure-driven valve flows
f_v1=r1/(4*R)*(x1-P_s);
f_v2=r2/(4*R)*(x2-P_d);
F(:,i)=[f_v1,f_v2];

%determine necessary controls using best_settings function
[Pb,r2new,fp2new,r1new,fp1new]=best_settings_Cl(x1,x2,P_s,t(i),concentration);

%discrete filter for soft opening/closing valves and pumps
r1=(9*r1+r1new)/10;
r2=(9*r2+r2new)/10;
fp1=(4*fp1+fp1new)/5;
fp2=(9*fp2+fp2new)/10;

%determine change in concentration from valve flow
Cl_in_tank=concentration*(x2-75);
Cl_in_tank=Cl_in_tank+(22*fp2-concentration*f_v2)*tstep/Cp;

%difference equation for pressure change in tanks and update tank pressure
dx1dt=1/Cp*(fp1-f_v1);
dx2dt=1/Cp*(fp2-f_v2);
x1=x1+tstep*dx1dt;
x2=x2+tstep*dx2dt;

% New chlorine concentration after decay reaction
concentration=0.998*Cl_in_tank/(x2-75);

%save current data points to arrays
X(:,i)=[x1,x2];
valvesettings(:,i)=[r1,r2];
Chlorine(i)=concentration;
P_dist(i)=P_d;
Pbooster(i)=Pb;
P_source(i)=P_s;
Demand(i)=f_D;
Treatment(i)=f_D+fp2-f_v2;
Intake(i)=f_D+fp1-f_v1+fp2-f_v2;

% Energy consumption scaled with current emissions cost of energy to obtain
% emissions generation
E_pump1(i)=emission_sample((20+i)/20)*abs(fp1*x1);
E_pump2(i)=emission_sample((20+i)/20)*abs(fp2*x2);
E_booster(i)=emission_sample((20+i)/20)*abs(Pb*(f_D-f_v2));
E_source(i)=emission_sample((20+i)/20)*abs(P_s*(f_D-f_v1+fp2-f_v2));
E_total(i)=emission_sample((20+i)/20)*(E_pump1(i)+E_pump2(i)+E_booster(i)+E_source(i));

end

%% plotting and data reporting
figure
plot(t,X)
title("tank levels")
legend("tank 1", "tank 2")
ylabel("Pressure (PSI)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")

figure
plot(t,[P_source; Pbooster; P_dist; P_dist-Pbooster])
axis padded
title("System Pressures")
legend("Source pump","Booster pump", "Distribution pressure", "Post-treatment pressure")
ylabel("Pressure (PSI)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")

figure
plot(t,[Intake;Treatment;Demand;F])
axis padded
title("System flows")
legend("Intake flow","Treatment flow","Distribution flow","Valve 1 flow","Valve 2 flow")
ylabel("Flow (GPM)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")

figure
plot(t,[E_pump1; E_pump2; E_booster; E_source])
hold on
plot(t,(E_pump1+ E_pump2+ E_booster+ E_source),"--")
axis padded
title("energy consumption")
legend("Tank 1 pump","Tank 2 pump", "Booster pump", "Intake pump","total")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")


consumption=trapz(E_total);
pressure_deviation=std(P_dist);

disp(consumption)
disp(pressure_deviation)

%save mpcnoffchlorine.mat Chlorine t

% figure
% plot(t,Demand)
% title("Demand pattern")
% ylabel("Flow demand (GPM)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")