clear;
clc;
%% ----- Input/output requirements of buck converter -----
Vin = 15; % Nominal input voltage (V)
Vout = 3; % Nominal output voltage (V)
Iout = 2; % Nominal output current (A)
Rout = Vout/Iout; % Resistive laod (Ω)
Vripple = 0.1; % Nominal ripple voltage (V)
Iripple = Iout * 0.01; % Ripple current (1% of nominal value) (A)
Fs = 100e3; % Switching Frequency (Hz)
D = Vout/Vin; % Duty Cycle (V/V)

%% ----- Diode Parameters (1N5821) -----
Vd = 0.475; % Forward voltage (V)
Id = (1-D)*Iout; % Max forward current (A) max is 3

%% ----- L and C calculations -----
L = ((Vin-Vout)*D)/(Iripple*Fs); % Inductor value (H)
ESR_L = 56e-3; % DC resistance of inductor (Ω)
C_min = (Vout*(1-D))/(8*L*Vripple*(Fs^2)); % Minimum capacitor value (C)
C = 0.47e-6; % Chosen capacitor value (F)
ESR_C = 13e-3; % Chosen capacitor ESR (Ω)

%% ----- MOSFET Parameters (IRF520NPBF) -----
Rds = 2e-3; % Max on-resistance (Ω)
Vgs = -20; % Vgs @ max on-resistance (Ω)
Trise = 23e-9; % Rise time (s)
Tfall = 23e-9; % Fall time (s)
Coss = 92e-12; % Maximum ouptut capacitance (F)
Imosfet = Iout*D; % MOSFET drain current (Pulsed) (A)

%% ----- Power disspation calculations -----
Pconduction = (Imosfet^2)*Rds; % Power dissipation of MOSFET in conduction (W)
Pswitching = (Vin-Vgs)*Imosfet*(Trise+Tfall)*Fs+Coss*(Vin-Vgs)^2*Fs; % Power dissipation of MOSFET when switching (W)
Pm = Pconduction + Pswitching; % Total MOSFET power disspiation (W)
Pl = ESR_L * Iout^2; % Inductor power dissipation (W)
Pc = ESR_C * Iripple^2; % Capacitor power disspation (W)
Pd = Vd * Id; % Diode power disspation (W)
Ptloss = Pl + Pc + Pd + Pm; % Sum of losses of components (W)
Pout = Vout * Iout; % Nominal output power (W)

%% ----- Efficiency calculation -----
Eff = (Pout/(Pout+Ptloss))*100; % Efficiency of Buck converter (%)

%% ----- Fcrit and Rcrit -----
Iob = Iripple/2;
Fcrit = (Rout*(1-D))/(2*L);
Rcrit = Vout/Iob;
%% ----- Display the data -----
load_system('BuckConverter');
set_param('BuckConverter','StopTime','3'); %simulate the buck converter model for 3 seconds
sim('BuckConverter');
disp("----- Buck Converter values -----"); %display the values
disp("L = " + L*1e3 + " mH");
disp("C = " + C_min*1e9 + " nF (Calcualted)");
disp("C = " + C*1e9 + " nF (Chosen)");
disp("R = " + Rout + " Ω");
disp("Inductor ESR = " + ESR_L*1e3 + " mΩ");
disp("Capacitor ESR = " + ESR_C*1e3 + " mΩ");
disp("Diode Vf = " + Vd + " V");
disp("MOSFET Rds = " + Rds*1e3 + " mΩ");
disp("Duty Cycle = " + D*100 + " %");
disp("Efficiency = " + Eff + " %");
disp("Critical frequency = " + Fcrit + " Hz");
disp("Critical Resistance = " + Rcrit + " Ω"); 
disp("Output Voltage = " + Voltage_out(end) + " V"); % display the final value of the output voltage array
disp("Output Current = " + Current_out(end) + " A"); % Display the final value of the output current array
%% ----- Run simulation and obtain data -----
set_param('BuckConverter','StopTime','20e-6'); % Re-run the simulation for 20us to graph 2 periods of V and I parameters for each component
sim('BuckConverter');
% ----- Voltages -----
a = figure('Name','Voltages and Currents - Buck converter','NumberTitle','off');
tiledlayout(4,2);
nexttile;
plot(Inductor_Voltage);
title('Inductor Voltage');
ylabel('Voltage (V)');
xlabel('Time (s)');
nexttile;

plot(Inductor_Current);
title('Inductor Current');
ylabel('Current (A)');
xlabel('Time (s)');
nexttile;

plot(Capacitor_Voltage);
title('Capacitor Voltage');
ylabel('Voltage (V)');
xlabel('Time (s)');
nexttile;

plot(Capacitor_Current);
title('Capacitor Current');
ylabel('Current (A)');
xlabel('Time (s)');
nexttile;

plot(Mosfet_Voltage);
title('Mosfet Voltage');
ylabel('Voltage (V)');
xlabel('Time (s)');
nexttile;

plot(Mosfet_Current);
title('Mosfet Current');
ylabel('Current (A)');
xlabel('Time (s)');
nexttile;

plot(Diode_Voltage);
title('Diode Voltage');
ylabel('Voltage (V)');
xlabel('Time (s)');
nexttile;

plot(Diode_Current);
title('Diode Current');
ylabel('Current (A)');
xlabel('Time (s)');
