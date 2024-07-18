%% Initialization

clc
clear variables
close all

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
f_p1_0=900;
f_p1=f_p1_0;
r1=0;
P_b=13.8;
f_p2_0=500;
f_p2=f_p2_0;
r2=0;

for i=1:steps
% Get current time (in hours) and demand from sample pattern (in GPM)
t(i)=i/12;
f_D=demandfcn(t(i));

% Rules based control: Fill the tanks if the level reaches the upper limit, empty the
% tanks if the level reaches the lower limit
if x1>95
    r1=1/(4*R);
    f_p1=0;
elseif x1<77
    r1=0;
    f_p1=f_p1_0;
end
if x2>95
    r2=1/(4*R);
    f_p2=0;
elseif x2<77
    r2=0;
    f_p2=f_p2_0;
end

% calculate current potential pressure at demand (Booster pump lags by 5 minutes)
P_d=1/(1+R*r2)*(P_s+P_b-R*(f_D+f_p2-r2*x2));

% calculate pressure-driven valve flows
f_v1=r1*(x1-P_s);
f_v2=r2*(x2-P_d);
F(:,i)=[f_v1,f_v2];

%determine change in concentration from valve flow
Cl_in_tank=concentration*(x2-75);
Cl_in_tank=Cl_in_tank+(22*f_p2-concentration*f_v2)*tstep/Cp;

%determine necessary booster pressure based on pressure deficit and low
%pass filter to represent smooth control action
P_b=70*(1+R*r2)-(P_s-R*(f_D+f_p2-r2*x2));
P_b=P_b+0.1*(70-P_d);

%difference equation for pressure change in tanks and update tank pressure
dx1dt=1/Cp*(f_p1-f_v1);
dx2dt=1/Cp*(f_p2-f_v2);
x1=x1+tstep*dx1dt;
x2=x2+tstep*dx2dt;

% New chlorine concentration after decay reaction
concentration=0.998*Cl_in_tank/(x2-75);

%save current data points to arrays
X(:,i)=[x1,x2];
Chlorine(i)=concentration;
P_dist(i)=P_d;
P_booster(i)=P_b;
P_source(i)=P_s;
Demand(i)=f_D;
Treatment(i)=f_D+f_p2-f_v2;
Intake(i)=f_D+f_p1-f_v1+f_p2-f_v2;

% Energy consumption scaled with current emissions cost of energy to obtain
% emissions generation
E_pump1(i)=emission_sample((12+i)/12)*abs(f_p1*x1);
E_pump2(i)=emission_sample((12+i)/12)*abs(f_p2*x2);
E_booster(i)=emission_sample((12+i)/12)*abs(P_b*(f_D-f_v2));
E_source(i)=emission_sample((12+i)/12)*abs(P_s*(f_D-f_v1+f_p2-f_v2));
E_total(i)=emission_sample((12+i)/12)*(E_pump1(i)+E_pump2(i)+E_booster(i)+E_source(i));

end

%% Plotting
figure
plot(t,X)
title("tank levels")
legend("tank 1", "tank 2")
ylabel("Pressure (PSI)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")

figure
plot(t,[P_source; P_booster; P_dist; P_dist-P_booster])
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
plot(t,E_total,"--")
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

%save simplechlorine.mat Chlorine t

% 
% figure
% plot(t,Demand)
% title("Demand pattern")
% ylabel("Flow demand (GPM)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")