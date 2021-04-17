clear;
clc;
%% ----- Input/output requirements of buck converter -----
Vin = 15; % Nominal input voltage (V)
dVin = 10; %Change in input voltage (V)
Vout = 3; % Nominal output voltage (V)
Iout = 2; % Nominal output current (A)
Rout = Vout/Iout; % Resistive laod (Ω)
Vripple = 0.1; % Nominal ripple voltage (V)
Iripple = Iout * 0.01; % Ripple current (1% of nominal value) (A)
Fs = 100e3; % Switching Frequency (Hz)
D = Vout/Vin; % Duty Cycle (V/V)

%% ----- L and C calculations -----
L = ((Vin-Vout)*D)/(Iripple*Fs); % Inductor value (H)
C = (Vout*(1-D))/(8*L*Vripple*(Fs^2)); % Minimum capacitor value (C)

%% ----- Display the data -----
load_system('BuckConverter_ideal');
set_param('BuckConverter_ideal','StopTime','3'); %simulate the buck converter model for 3 seconds
sim('BuckConverter_ideal');
disp("----- Buck Converter values (ideal) -----"); %display the values
disp("L = " + L*1e3 + " mH");
disp("C = " + C*1e9 + " nF");
disp("Load = " + Rout + " Ω");
disp("Duty Cycle = " + D*100 + " %");
disp("Output Voltage = " + max(Voltage_out) + " V"); % display the final value of the output voltage array
disp("Output Current = " + max(Current_out) + " A"); % Display the final value of the output current array
disp("Efficiency = 100 %");
%% ----- Run simulation and obtain data -----
set_param('BuckConverter_ideal','StartTime','0.02','StopTime','0.02+(2*(1/Fs))'); % Re-run the simulation for 20us to graph 2 periods of V and I parameters for each component
sim('BuckConverter_ideal');
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

