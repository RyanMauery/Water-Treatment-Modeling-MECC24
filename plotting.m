clc
clear variables
close all

h=matfile("h_variables.mat");
m=matfile("mpc_variables.mat");

% subplot(1,2,1)
% plot(h.t,[h.E_pump1; h.E_pump2; h.E_booster; h.E_source])
% hold on
% plot(h.t,(h.E_pump1+ h.E_pump2+ h.E_booster+ h.E_source),"--")
% axis padded
% title("CO2 Emissions, Heuristic")
% legend("Tank 1 pump","Tank 2 pump", "Booster pump", "Intake pump","total")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")
% 
% subplot(1,2,2)
% plot(m.t,[m.E_pump1; m.E_pump2; m.E_booster; m.E_source])
% hold on
% plot(m.t,(m.E_pump1+ m.E_pump2+ m.E_booster+ m.E_source),"--")
% axis padded
% title("CO2 Emissions, MPC")
% legend("Tank 1 pump","Tank 2 pump", "Booster pump", "Intake pump","total")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")


% figure
% subplot(2,2,1)
% plot(h.t,[h.P_source; h.P_booster; h.P_dist; h.P_dist-h.P_booster])
% axis padded
% title("System Pressures, Heuristic")
% legend("Source pump","Booster pump", "Distribution pressure", "Post-treatment pressure")
% ylabel("Pressure (PSI)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")
% 
% subplot(2,2,3)
% plot(h.t,[h.Intake;h.Treatment;h.Demand;h.F])
% axis padded
% title("System Flows, Heuristic")
% legend("Intake flow","Treatment flow","Distribution flow","Valve 1 flow","Valve 2 flow")
% ylabel("Flow (GPM)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")
% 
% subplot(2,2,2)
% plot(m.t,[m.P_source; m.Pbooster; m.P_dist; m.P_dist-m.Pbooster])
% axis padded
% title("System Pressures, MPC")
% legend("Source pump","Booster pump", "Distribution pressure", "Post-treatment pressure")
% ylabel("Pressure (PSI)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")
% 
% subplot(2,2,4)
% plot(m.t,[m.Intake;m.Treatment;m.Demand;m.F])
% axis padded
% title("System Flows, MPC")
% legend("Intake flow","Treatment flow","Distribution flow","Valve 1 flow","Valve 2 flow")
% ylabel("Flow (GPM)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")

% 
% h_tanks=variables_h.X;
% h_t=variables_h.t;
% mpc_tanks=variables_mpc.X;
% mpc_t=variables_mpc.t;
% 
% %tank comparison
% figure
% hold on
% plot(h_t,h_tanks(1,:),'b--')
% plot(h_t,h_tanks(2,:),'r--')
% plot(mpc_t,mpc_tanks(1,:),'b')
% plot(mpc_t,mpc_tanks(2,:),'r')
% title("Tank Levels")
% legend("tank 1, simple", "tank 2, simple","tank 1, MPC", "tank 2, MPC")
% ylabel("Pressure (PSI)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")

v_simple=matfile("simplechlorine.mat");
v_mpc_no=matfile("mpcnoffchlorine.mat");
v_mpc_yes=matfile("mpcnochlorine.mat");

figure
hold on
plot(v_simple.t,v_simple.Chlorine,'b')
plot(v_mpc_no.t,v_mpc_no.Chlorine,'r--')
plot(v_mpc_yes.t,v_mpc_yes.Chlorine,'r')
title("Chlorine Concentration in Tank 2")
legend("Simple", "MPC, no Cl_2 weighting","MPC, CL_2 weighted")
ylabel("Chlorine concentration (mg/gal)")
xlabel("Time (h)")
set(gcf,"Color",'w')
set(gca,"FontName","Cambria")


% v_brown=matfile("mpc_variables_brown.mat");
% v_normal=matfile("mpc_variables_nobrown.mat");
% figure
% hold on
% plot(v_normal.t,v_normal.E_total,'b')
% plot(v_brown.t,v_brown.E_total,'r')
% title("Load Shedding Energy Consumption")
% legend("Original MPC","Relaxed MPC")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")
% 
% figure
% hold on
% plot(v_normal.t,v_normal.P_dist,'b')
% plot(v_normal.t,v_normal.X(1,:),'b--')
% plot(v_normal.t,v_normal.X(2,:),'b:')
% plot(v_brown.t,v_brown.P_dist,'r')
% plot(v_normal.t,v_brown.X(1,:),'r--')
% plot(v_normal.t,v_brown.X(2,:),'r:')
% title("Load Shedding System Pressures")
% legend("Original distribution","Tank 1","Tank 2","Relaxed distribution","Tank 1","Tank 2")
% ylabel("Pressure (PSI)")
% xlabel("Time (h)")
% set(gcf,"Color",'w')
% set(gca,"FontName","Cambria")



