clc
clear all

%% Set parameters:
w = 75000 %bits - number of CPU cycles required to accomplish the computation task
%d = 12000 %Mbit per s - data rate between tasks vi and vj
v = 1 %km/h the speed of the end user
f_c = 5000 %MHz - carrier frequency

%LAN parameters
B_channel_lan = 80 %MHz => N = 980
N_sd = 980
M_lan = 2 %MIMO 2x2
cod = 3/4
T_ofdm = 12.8*10^(-6) %OFDM symbol duration
T_interval = 0.8*10^(-6) % Guiard interval duration
%SNR_lan = 25 %db
q_lan = 10 % QAM - 1024
%v = 1 %km/h the speed of the end user

%WAN parameters
B_channel_wan = 80 %MHz
%SNR_wan = 15 %db
M_wan = 8 % MIMO 8x8
q_wan = 8 % QAM - 256
rate = 948/1024 %max code rate
factor = 1 %scaling factor
OH = 0.2 % overhead
N_PRB = 217 %maximum transmission bandwidth configuration
mu = 1 %SCS = 30 kHz
%v = 1 %km/h the speed of the end user
%f_c_wan = 30000 %MHz - carrier frequency
D_fiber = 200000000 %bps - optic cable data rate

%B_lan = 800 %Mbps - LAN data rate
%B_wan = 60 %Mbps - WAN data rate
%W = 80 %MHz users bandwidth
%T_lan = 0.002 %s - LAN delay
%T_wan = 0.006 %s - WAN delay
f_iot = 28800 %MHz - IoT computing frequency
f_edge = 75200 %MHz - Edge computing frequency
f_cloud = 288000 %MHz - Cloud computing frequency
p_idle = 0.001 %W - IoT idle power, i.o. when the computing located outside the device
p_ex = 0.08 %W - CPU computational power of IoT device
p_tr = 0.085 %W - data transmission power of IoT device
c = 300000000 %m/s - speed of light
%dist_lan = 0.05 %km - distance to edge server
%dist_wan = 1000000 %m - distance to cloud server
T_hop = 0.0005 %s - the latency in the hope

%% Converting SNR, calculating the maximum channel capacity in bps according the Shennon's Theory and implementing the modulation coefficient
%S_N_lan = 10.^(SNR_lan/10);
%C_lan = q_lan*B_channel_lan*1000000*log2(1+S_N_lan); %bps

%S_N_wan = 10.^(SNR_wan/10);
%C_wan = q_wan*B_channel_wan*1000000*log2(1+S_N_wan); %bps


%%Calculating the maximum throughput
C_lan = (N_sd*q_lan*cod*M_lan)/(T_ofdm +T_interval);

T_s_mu = 10^(-3)/(14*2^mu);
L = N_PRB*12/T_s_mu;
C_wan = M_wan*q_wan*factor*rate*L*(1-OH);

%% Calculating the Doppler effect for moving devices
D_s = 2*f_c*1000000*v*1000/(c*3600);
T_doppler = 1/(4*D_s); %sec

%% IoT Model
T_comm_iot = 0;
T_comp_iot=w/f_iot; %[s] w - computational workload of the task, f_iot - IoT computing frequency
T_iot=T_comp_iot + T_comm_iot;
E_iot=p_ex*T_comp_iot*3.6; % E_iot - energy consumption when computing in IoT device

%% MEC model
T_comp_mec = w/f_edge; %w - computational workload of the task, f_edge - MEC computing frequency
T_comm_mec = w/C_lan+T_doppler;


%T_lan = dist_lan/c; 
%T_comm_mec = d/B_lan + T_lan; % communication time between tasks vi and vj, D - ransferred data between tasks vi and vj
E_comp_mec = p_idle*T_comp_mec*3.6;
E_comm_mec = p_tr*T_comm_mec*3.6;
%% Cloud Model
T_comp_mcc = w/f_cloud; %w - computational workload of the task, f_edge - MEC computing frequency
T_comm_mec_mcc = w/C_wan+T_doppler;
T_comm_mcc = w/D_fiber; % fiber


%T_wan = dist_wan/c;
%T_comm_mec_mcc = d/B_lan+T_lan+T_hop;
%T_comm_mcc= d/B_wan+T_wan; % communication time between tasks vi and vj, D - ransferred data between tasks vi and vj
E_comp_mcc = p_idle*T_comp_mcc*3.6;
E_comm_mec_mcc = p_tr*T_comm_mec_mcc*3.6;
E_comm_mcc = p_tr*T_comm_mcc*3.6;
%% Figures
figure 
x1=categorical({'IoT','IoT-MEC','IoT-MEC-MCC'});
x1= reordercats(x1,{'IoT','IoT-MEC','IoT-MEC-MCC'});
T=[T_iot 0 0 0 0; 0 T_comm_mec T_comp_mec 0 0; 0 T_comm_mec_mcc 0 T_comm_mcc T_comp_mcc];
E=[E_iot 0 0 0 0; 0 E_comm_mec E_comp_mec 0 0; 0 E_comm_mec_mcc 0 E_comm_mcc E_comp_mcc];
subplot(1,2,1)
b1=bar(x1,T); 
set(gca, 'YScale', 'log')
xtips1 = b1(1).XEndPoints;
ytips1 = b1(1).YEndPoints;
labels1 = string(b1(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips1 = b1(2).XEndPoints;
ytips1 = b1(2).YEndPoints;
labels1 = string(b1(2).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips1 = b1(3).XEndPoints;
ytips1 = b1(3).YEndPoints;
labels1 = string(b1(3).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips1 = b1(4).XEndPoints;
ytips1 = b1(4).YEndPoints;
labels1 = string(b1(4).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips1 = b1(5).XEndPoints;
ytips1 = b1(5).YEndPoints;
labels1 = string(b1(5).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
legend('IoT computing', 'Transmission from Iot to Edge', 'Edge Computing (IoT waiting time)', 'Transmission from Edge to Cloud (waiting time)', 'Cloud Computing (IoT waiting time)')
title('Response Time')
ylabel('Response time [s]')
subplot(1,2,2)
b2=bar(x1,E, 'stacked');
set(gca, 'YScale', 'log')
xtips2 = b2(1).XEndPoints;
ytips2 = b2(1).YEndPoints;
labels2 = string(b2(1).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips2 = b2(2).XEndPoints;
ytips2 = b2(2).YEndPoints;
labels2 = string(b2(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips2 = b2(3).XEndPoints;
ytips2 = b2(3).YEndPoints;
labels2 = string(b2(3).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips2 = b2(4).XEndPoints;
ytips2 = b2(4).YEndPoints;
labels2 = string(b2(4).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
xtips2 = b2(5).XEndPoints;
ytips2 = b2(5).YEndPoints;
labels2 = string(b2(5).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
legend('IoT computing', 'Transmission from Iot to Edge', 'Edge Computing (IoT waiting time)', 'Transmission from Edge to Cloud (waiting time)', 'Cloud Computing (IoTwaiting time)')
title('Power Consumption')
xlabel('Computing location')
ylabel('Power Consumption [kWh]')
