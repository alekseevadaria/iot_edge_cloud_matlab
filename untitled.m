clc
clear all

%% Set parameters:
w = 3000 %G - task workload
d = 0.1 %Mbit - data rate between tasks vi and vj
B_lan = 600 %Mbit/sec - LAN bandwidth
B_wan = 1000 %Mbit/sec - WAN bandwidth
T_lan = 3 %ms - LAN delay
T_wan = 1 %ms - WAN delay
f_iot = 500 %MHz - IoT computing frequency
f_edge = 3000 %MHz - Edge computing frequency
f_cloud = 5000 %MHz - Cloud computing frequency
p_idle = 0.005 %W - IoT idle power, i.o. when the computing located outside the device
p_ex = 0.8 %W - CPU computational power of IoT device
p_tr = 1.3 %W - data transmission power of IoT device

%% IoT Model
T_comm_iot = 0;
T_comp_iot=w/f_iot; %[ms] w - computational workload of the task, f_iot - IoT computing frequency
T_iot=T_comp_iot + T_comm_iot;
E_iot=p_ex*T_comp_iot; % E_iot - energy consumption when computing in IoT device

%% MEC model
T_comp_mec = w/f_edge; %w - computational workload of the task, f_edge - MEC computing frequency
T_comm_mec = d/B_lan + T_lan; % communication time between tasks vi and vj, D - ransferred data between tasks vi and vj
E_comp_mec = p_idle*T_comp_mec;
E_comm_mec = p_tr*T_comm_mec;
%% Cloud Model
T_comp_mcc = w/f_cloud; %w - computational workload of the task, f_edge - MEC computing frequency
T_comm_mcc= d/B_wan+T_wan; % communication time between tasks vi and vj, D - ransferred data between tasks vi and vj
E_comp_mcc = p_idle*T_comp_mcc;
E_comm_mec = p_tr*T_comm_mec;
E_comm_mcc = p_idle*T_comm_mcc;
%% Figures
figure 
x1=categorical({'IoT','IoT-MEC','IoT-MEC-MCC'});
x1= reordercats(x1,{'IoT','IoT-MEC','IoT-MEC-MCC'});
y1=categorical({'IoT computing time','Transmission IoT-Edge','Idle time (Edge computing time)','Transmission Edge-Cloud','Idle time (Cloud computing time)',});
y1= reordercats(y1,{'IoT computing time','Transmission IoT-Edge','Idle time (Edge computing time)','Transmission Edge-Cloud','Idle time (Cloud computing time)'});
T=[T_iot 0 0 0 0; 0 T_comm_mec T_comp_mec 0 0; 0 T_comm_mec 0 T_comm_mcc T_comp_mcc];
E=[E_iot 0 0 0 0; 0 E_comm_mec E_comp_mec 0 0; 0 E_comm_mec 0 E_comm_mcc E_comp_mcc];
subplot(1,2,1)
b1=bar(x1,T) 
xtips1 = b1(1).XEndPoints;
ytips1 = b1(1).YEndPoints;
labels1 = string(b1(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
     'VerticalAlignment','bottom')
legend('IoT computing', 'Transmission from Iot to Edge', 'Edge Computing (IoT waiting time)', 'Transmission from Edge to Cloud (waiting time)', 'Cloud Computing (IoT waiting time)')
title('Response Time')
ylabel('Response time [ms]')
subplot(1,2,2)
b2=bar(x1,E, 'stacked')
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
legend('IoT computing', 'Transmission from Iot to Edge', 'Edge Computing (IoT waiting time)', 'Transmission from Edge to Cloud (waiting time)', 'Cloud Computing (IoTwaiting time)')
title('Energy Consumption')
xlabel('Computing location')
ylabel('Energy Consumption [J]')
