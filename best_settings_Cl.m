function [Pb_best,r2_best,fp2_best,r1_best,fp1_best]=best_settings_Cl(x1start,x2start,P_sstart,currentT,concentration)

% This function takes the current values for pressure in the two tanks, the pressure at the inlet of the system, 
% time (in hours from the start of the simulation) and chlorine concentration in tank 2

% It returns the pump and valve settings that produced the best system
% performance out of all the values simulated

% limits & discretization for possible actuator options
%valves are either closed or open
r2_explore=[0 0.5]; 
r1_explore=[0 0.5];
%pumps have discrete choices to generate pressure or flow
Pb_explore=linspace(0,30,60); %pressure
fp2_explore=linspace(0,1000,8);%flow
fp1_explore=linspace(0,1000,8);%flow

% Empty arrays to hold costs over the actuator space for the 4 criteria 
pressure_cost=zeros(length(Pb_explore),length(fp2_explore),length(r2_explore),length(r1_explore),length(fp1_explore));
emissions_cost=pressure_cost; 
tank_cost=pressure_cost; 
Cl_cost=pressure_cost;

% simulation parameters
tstep=5; % minutes for each step 
% linearized resistance and capacitance around 3500 GPM
Rs=5.2107e-4; %psi/GPM for L=100 ft D=12 in
Cp=5.7574e4; %G/psi for D=50 ft
% tank time constant = R*C1 = 30 minutes
R=10*Rs; %resistance for filtration cartridge

% Model the possible actuator outcomes
for jr2=1:length(r2_explore)
    r2=r2_explore(jr2);
    for jfp2=1:length(fp2_explore)
        fp2=fp2_explore(jfp2);
        for jPb=1:length(Pb_explore)
            Pb=Pb_explore(jPb);
            for jr1=1:length(r1_explore)
                r1=r1_explore(jr1);
                for jp1=1:length(fp1_explore)
                    fp1=fp1_explore(jp1);
                    %current pressure and flow from the system
                    x1=x1start;
                    x2=x2start;
                    P_s=P_sstart;

                    %get demand from the demand curve function
                    f_D=demandfcn(currentT);
                    
                    % potential pressure at demand (uses old values because booster pump lags by 5 minutes to represent holding in flocculation+sedimentation)
                    P_d=1/(1+R*r2)*(P_s+Pb-R*(f_D+fp2-r2*x2));
                    
                    % update valve flows
                    f_v1=r1/R*(x1-P_s);
                    f_v2=r2/R*(x2-P_d);
                    
                    %determine change in concentration from valve flow
                    Cl_in_tank=concentration*(x2-75);
                    Cl_in_tank=Cl_in_tank+(22*fp2-concentration*f_v2)*tstep/Cp;

                    %calculate pressure change and update tank pressures
                    dx1dt=1/Cp*(fp1-f_v1);
                    dx2dt=1/Cp*(fp2-f_v2);
                    x1=x1+tstep*dx1dt;
                    x2=x2+tstep*dx2dt;

                    %update chlorine concentration due to decay reaction intank
                    concentration=0.998*Cl_in_tank/(x2-75);

                    %update flow and pressure at the outlet according to demand and system states
                    f_D=demandfcn(currentT+5/60);
                    P_d=1/(1+R*r2)*(P_s+Pb-R*(f_D+fp2-r2*x2));
                    
                    % Energy consumption
                    E_pump1=abs(fp1*x1);
                    E_pump2=abs(fp2*x2);
                    E_booster=abs(Pb*(f_D-f_v2));
                    E_source=abs(P_s*(f_D-f_v1+fp2-f_v2));   
                    E_total=E_pump1+ E_pump2+ E_booster+E_source;

                    % Calculate costs
                    pressure_cost(jPb,jfp2,jr2,jr1,jp1)=(P_d-70)*(P_d-70)';  % Quadratic cost for how far the pressure at the outlet is from the set point
                    emissions_cost(jPb,jfp2,jr2,jr1,jp1)=E_total*emission_sample(currentT+1); % Linear cost for energy consumption multiplied by emissions per energy
                    tank_cost(jPb,jfp2,jr2,jr1,jp1)=([x1-100;1.3*(x2-100)])'*([x1-100;1.3*(x2-100)]); % Quadratic cost for how far tanks are from their set points
                    Cl_cost(jPb,jfp2,jr2,jr1,jp1)=(10-concentration)*(10-concentration); % Quadratic cost for how far tank 2 chlorine concentration is from its set point
                end
            end
        end
    end
end

% Total cost as linear combination of cost categories
cost=pressure_cost*700+emissions_cost*4.8104e-04+10*tank_cost+1*Cl_cost;

% Find the minimum cost over all the simulations
[~,loc] = min(cost(:));
[ii,jj,kk,ll,mm] = ind2sub(size(cost),loc);

% Choose and return the best settings
Pb_best=Pb_explore(ii);
fp2_best=fp2_explore(jj);
r2_best=r2_explore(kk);
r1_best=r1_explore(ll);
fp1_best=fp1_explore(mm);

end

