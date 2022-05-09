close all
clearvars

%INPUTS
w = 1; % Mbit -workload
k = 2; %GHz - IoT CPU
k1 = 75; %GHz - MEC CPU
k2 = 288; %GHz - MCC CPU
N_rb = 106; %number of resourse blocks (depends on the bandwidth) 5G
N_ss2 = 1; %SISO 5G
Q2 = 6; %QAM-64 5G
sn = 2.7; %wired chanel snr parameter
 
%other parameters
w1=w*10^6; % bit
b = 1.1*10^3; % cycles/bit
            
% IoT power consumption
p_idle = 0.003; %Wh - IoT idle power, i.o. when the computing located outside the device
p_tr = 1.2; %Wh - transmission power of IoT device
p_ex = 0.9; %Wh - CPU computational power of IoT device
            
%IoT model
f_iot = k.*10^9; % Hz
T_comp_iot = b*w1./f_iot; %in [s]
T_iot = T_comp_iot;
T_iot1= T_iot/3600; %in hours
E_comp_iot = T_iot1*p_ex; % [W] P_iot - power consumption when computing in IoT device
E_iot = E_comp_iot;
            
% Calculating 5G NR bit rate
%mu = 1; % numerology for subcarrier space 30kHz (in formula 2^mu)
f = 0.75; %scaling factor
r = 0.92578125; %max code rate
%OH = 0.2; % max overhead (1-OH = 0.8)
C = 10^(-6)*N_ss2*Q2*f*r*N_rb*12*14*2*0.8*1000; % 5G NR bit rate in [Mbps]
            
%MEC model
f_mec = k1.*10^9; % Hz
T_comp_mec = b*w1./f_mec; % in [s]         
T_comm_mec = w./C; %communication time mec
T_mec = T_comp_mec+T_comm_mec;
E_comp_mec = p_idle*T_comp_mec/3600;
E_comm_mec = p_tr*T_comm_mec/3600;
E_mec = E_comp_mec+ E_comm_mec;
            
%MCC model
f_mcc = k2.*10^9; %  Hz
T_comp_mcc = b*w1./f_mcc;% in [s]
            
% Calculating the wired channel delay
W = 20*10^3*log2(1+sn);
T_mcc2 = w./W; %communication time in wired channel

T_mcc1 = w./C; %communication time 5G
T_comm_mcc = T_mcc1 + T_mcc2;
T_mcc = T_comp_mcc+T_comm_mcc;
E_comp_mcc = p_idle*T_comp_mcc/3600;
E_comm_mcc1 = p_tr*T_mcc1/3600;
E_comm_mcc2 = p_idle*T_mcc2/3600;
E_comm_mcc = E_comm_mcc1 + E_comm_mcc2;
E_mcc = E_comp_mcc+ E_comm_mcc;

k= 0/0;
            
%plotting
fig=figure;
x=categorical({'IoT-only', 'MEC-only', 'MCC-only'});
x=reordercats(x,{'IoT-only', 'MEC-only', 'MCC-only'});
T=[k, k, T_comp_iot; T_comp_mec, T_comm_mec, k; T_comp_mcc, T_comm_mcc, k];
E=[k, k, E_comp_iot;E_comp_mec, E_comm_mec, k; E_comp_mcc+E_comm_mcc2, E_comm_mcc1, k];
subplot(1,2,1)
b1=bar(x,T, 'stacked', 'FaceColor',"flat");
xtips1 = b1(1).XEndPoints;
ytips1 = b1(1).YEndPoints;
labels1 = string(b1(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
xtips2 = b1(2).XEndPoints;
ytips2 = b1(2).YEndPoints;
labels2 = string(b1(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
xtips3 = b1(3).XEndPoints;
ytips3 = b1(3).YEndPoints;
labels3 = string(b1(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
set(gca, 'YScale', 'log')
fig.Position(3:4)=[1000,400];
legend('Offladed Computing','Communication','Local computing','FontSize',14)
title('Response Time','fontsize',16)
xlabel('Computing location','fontsize',14)
ylabel('Time [s]','fontsize',14)
subplot(1,2,2)
b2=bar(x,E, 'stacked');
xtips1 = b2(1).XEndPoints;
ytips1 = b2(1).YEndPoints;
labels1 = string(b2(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
xtips1 = b2(2).XEndPoints;
ytips1 = b2(2).YEndPoints;
labels1 = string(b2(2).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
xtips1 = b2(3).XEndPoints;
ytips1 = b2(3).YEndPoints;
labels1 = string(b2(3).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',12)
set(gca, 'YScale', 'log')
fig.Position(3:4)=[800,300];
legend('Idle state', 'Transmitting state','Computing state','FontSize',14)
title('Power Consumption','fontsize',16)
xlabel('Computing location','fontsize',14)
ylabel('Power Consumption [Wh]','fontsize',14)
saveas(gcf,'matlab_plot.png')