clear;
clc;
%% ----- Input/output requirements of buck converter -----
Vin = 3.7; % Nominal input voltage (V)
Vout = 5; % Nominal output voltage (V)
Pout = 30;
Iout = 0.5; % Nominal output current (A)
Rout = 5000; 
Vripple = Vout * 0.0005; % Nominal ripple voltage (0.05% of nominal value) (V)
Fs = 40e3; % Switching Frequency (Hz)
D = 1-(Vin/Vout); % Duty Cycle (V/V)
I_L = Iout / (1-D) ; % Inductor current (A) used for calculating Iripple
Iripple = I_L * 0.1  ; % Ripple current (10% of nominal value) (A)

%% ----- L and C calculations -----
L = (Vin*D)/(Iripple*Fs); % Inductor value (H)
C = (D*Iout)/(Vripple*Fs); % Minimum capacitor value (C)

%% ----- Display the information -----
load_system('BoostConverter');
set_param('BoostConverter','StopTime','3');
sim('BoostConverter');
disp("----- Boost Converter values -----");
disp("L = " + L*1e6 + " uH");
disp("C = " + C*1e6 + " uF");
disp("Load = " + Rout+ " Ω");
disp("Duty Cycle = " + D*100 + " %");
disp("Efficiency = 100 %");
disp("Output Voltage = " + Voltage_out(end) + " V");
disp("Output Current = " + Current_out(end) + " A");
%% ----- Gather results -----
set_param('BoostConverter','StartTime','2','StopTime','2+(5*(1/Fs))');
sim('BoostConverter');
% ----- Voltages -----
a = figure('Name','Voltages and Currents - Boost converter','NumberTitle','off');
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

