close all
clearvars

% Switches and basic parameters
running = true;
%min_index = 100; % Parameter to avoid transitory behavior
stepsize = 0.001;
delta = stepsize : stepsize : 350;

% Check whether to rerun the Monte Carlo
%if (running)
    % Simulation parameters
    lambda = 0.5;
    %mu = 1;
    %D = 0.8;
    t_iot = 0.0035;
    t_mec = 0.0013;
    t_mcc = 0.0003;
    t_comm = 0.0386;
    t_comm_mcc = 0.015;
    p_iot = 0.001;
    p_mec = 0.0002;
    p_mcc = 0.0001;
    p_comm = 0.0083;
    p_comm_mcc = 0.0015;
    num_packets = 10000;
    num_packets_mec = 8000;
    num_vm_mec = 100;
    num_vm_mcc = 500;
    
    % System time: W1, S1, W2, S2 for each packet
    system_times_mec = zeros(6, num_packets_mec);
    system_times_mcc = zeros(6, num_packets-num_packets_mec);
    
    system_times_mec_o = zeros(6, num_packets);
    system_times_mcc_o = zeros(6, num_packets);
    %system_times_iot_o = zeros(2, num_packets);
    
    % Compute origin times at the source
    origin_times = cumsum((exprnd(0.01 / lambda, 1, num_packets)));
    origin_times_mec = origin_times(1:num_packets_mec);
    origin_times_mcc = origin_times(num_packets_mec + 1 : end);
    
    % The first packet has no queue
   
    system_times_mec(2, :) = t_comm; % edge comm UL
    system_times_mec(4, :) = t_mec; % edge comp
    system_times_mec(6, :) = t_comm; % edge comm DL
    
    system_times_mec(2,1:2) = 0; %iot
    system_times_mec(4,1:2) = t_iot; %iot
    system_times_mec(6,1:2) = 0; %iot
    
    system_times_mcc(2, :) = t_comm + t_comm_mcc; % cloud comm UL
    system_times_mcc(4, :) = t_mcc; % cloud comp
    system_times_mcc(6, :) = t_comm + t_comm_mcc; %  cloud comm DL
    
 %% only edge  
    system_times_mec_o(2, :) = t_comm; % edge comm UL
    system_times_mec_o(4, :) = t_mec; % edge comp
    system_times_mec_o(6, :) = t_comm; % edge comm DL
    % Compute waiting time at each relay
    for i = 1+num_vm_mec : num_packets
        system_times_mec_o(1, i) = max(0, origin_times(i - 1) + sum(system_times_mec_o(1 : 2, i - 1)) - origin_times(i));
        system_times_mec_o(3, i) = max(0, origin_times(i - 1) + sum(system_times_mec_o(1 : 4, i - 1)) - (origin_times(i) + sum(system_times_mec_o(1 : 2, i))));
        system_times_mec_o(5, i) = max(0, origin_times(i - 1) + sum(system_times_mec_o(1 : 6, i - 1)) - (origin_times(i) + sum(system_times_mec_o(1 : 4, i))));
    end
 
    
     %% only cloud  
    system_times_mcc_o(2, :) = t_comm+ t_comm_mcc; % edge comm UL
    system_times_mcc_o(4, :) = t_mcc; % edge comp
    system_times_mcc_o(6, :) = t_comm+ t_comm_mcc; % edge comm DL
    % Compute waiting time at each relay
    for i = 1+num_vm_mcc : num_packets
        system_times_mcc_o(1, i) = max(0, origin_times(i - 1) + sum(system_times_mcc_o(1 : 2, i - 1)) - origin_times(i));
        system_times_mcc_o(3, i) = max(0, origin_times(i - 1) + sum(system_times_mcc_o(1 : 4, i - 1)) - (origin_times(i) + sum(system_times_mcc_o(1 : 2, i))));
        system_times_mcc_o(5, i) = max(0, origin_times(i - 1) + sum(system_times_mcc_o(1 : 6, i - 1)) - (origin_times(i) + sum(system_times_mcc_o(1 : 4, i))));
    end
 
     %% only iot  
 %   system_times_iot_o(2, :) = t_iot; % iot comp
    % Compute waiting time at each relay
 %   for i = 2 : num_packets
 %       system_times_iot_o(1, i) = max(0, origin_times(i - 1) + sum(system_times_iot_o(1 : 2, i - 1)) - origin_times(i));
 %  end
 
    %% Complex
   
    % Compute waiting time at each relay
    for i = 3+num_vm_mec : num_packets_mec
        system_times_mec(1, i) = max(0, origin_times_mec(i - 1) + sum(system_times_mec(1 : 2, i - 1)) - origin_times_mec(i));
        system_times_mec(3, i) = max(0, origin_times_mec(i - 1) + sum(system_times_mec(1 : 4, i - 1)) - (origin_times_mec(i) + sum(system_times_mec(1 : 2, i))));
        system_times_mec(5, i) = max(0, origin_times_mec(i - 1) + sum(system_times_mec(1 : 6, i - 1)) - (origin_times_mec(i) + sum(system_times_mec(1 : 4, i))));
    end
    
    for i = 1+num_vm_mcc : num_packets-num_packets_mec
        system_times_mcc(1, i) = max(0, origin_times_mcc(i - 1) + sum(system_times_mcc(1 : 2, i - 1)) - origin_times_mcc(i));
        system_times_mcc(3, i) = max(0, origin_times_mcc(i - 1) + sum(system_times_mcc(1 : 4, i - 1)) - (origin_times_mcc(i) + sum(system_times_mcc(1 : 2, i))));
        system_times_mcc(5, i) = max(0, origin_times_mcc(i - 1) + sum(system_times_mcc(1 : 6, i - 1)) - (origin_times_mcc(i) + sum(system_times_mcc(1 : 4, i))));
    end


% Simulation results
departure_times_mec = origin_times_mec + sum(system_times_mec, 1);
departure_times_mcc = origin_times_mcc + sum(system_times_mcc, 1);
departure_times_mec_o = origin_times + sum(system_times_mec_o, 1);
departure_times_mcc_o = origin_times + sum(system_times_mcc_o, 1);
%departure_times_iot_o = origin_times + sum(system_times_iot_o, 1);

t_sim_mec = departure_times_mec(1 : end) - origin_times_mec(1 : end);
t_sim_mcc = departure_times_mcc(1 : end) - origin_times_mcc(1 : end);
t_sim= cat(2,t_sim_mec,t_sim_mcc);
t_sim_mec_o = departure_times_mec_o(1 : end) - origin_times(1 : end);
t_sim_mcc_o = departure_times_mcc_o(1 : end) - origin_times(1 : end);
%t_sim_iot_o = departure_times_iot_o(1 : end) - origin_times(1 : end);

[t_sim_hist, ~] = hist(t_sim, delta);
[t_sim_hist_mec_o, ~] = hist(t_sim_mec_o, delta);
[t_sim_hist_mcc_o, ~] = hist(t_sim_mcc_o, delta);
%[t_sim_hist_iot_o, ~] = hist(t_sim_iot_o, delta);


f1 = figure(1);
%scatter(delta, cumsum(t_sim_hist_iot_o) / sum(t_sim_hist_iot_o), 'p')
%hold on
scatter(delta, cumsum(t_sim_hist_mcc_o) / sum(t_sim_hist_mcc_o), 'g')
hold on
scatter(delta, cumsum(t_sim_hist_mec_o) / sum(t_sim_hist_mec_o), 'r')
hold on
scatter(delta, cumsum(t_sim_hist) / sum(t_sim_hist), 'b')
hold on

xlabel('Response Time')
ylabel('CDF')
legend('MCC only', 'MEC only', 'Hybrid system')

%% power consumption
 % only edge  
%    power_mec_o(1:2, :) = system_times_mec_o(1:2, :)*p_comm; % edge comm UL
%    power_mec_o(3:4, :) = system_times_mec_o(3:4, :)*p_mec; % edge comp
%    power_mec_o(5:6, :) = system_times_mec_o(5:6, :)*p_comm; % edge comm DL
 
   
% Simulation results
%overall_power_mec_o = sum(power_mec_o, 1);

%p_sim_mec_o = overall_power_mec_o(1 : end);

%[p_sim_hist_mec_o, ~] = hist(p_sim_mec_o, delta);


%f2 = figure(2);
%scatter(delta, cumsum(p_sim_hist_mec_o) / sum(p_sim_hist_mec_o), 'r')

%xlabel('Power Consumption')
%ylabel('CDF')
%legend('MEC only')