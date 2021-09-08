function lena_pendulum_2
% based on demo_pendulum_3 https://campbell-muscle-lab.github.io/MATMyoSim/pages/demos/pendulum/pendulum_3/pendulum_3.html
% This is a 3 state model with no tendon
% Idea is to let the pendulum come to a steady state position with a
% constant activation and then perturb it with a force
% requires new functions in @simulation
%        function obj = implement_pendulum_protocol_perturbed(obj, varargin)


% Variables
model_file = 'sim_input/model.json'
pendulum_file = 'sim_input/pendulum.json'
options_file = 'sim_input/options.json'
output_file = 'sim_output/pendulum_output2.myo'

% Make sure the path allows us to find the right files
addpath(genpath('../../../../code'));

% Create a simulation
sim = simulation(model_file)

% Set up a mini protocol with the number of time-points
% and pCa held at 9
no_of_time_points = 8000;
pCa = 9.0 * ones(no_of_time_points, 1);
dt = 0.001*ones(no_of_time_points,1);
Fext = zeros(no_of_time_points,1);

% Activations
%pCa(1:4000) = 4.5; pCa(4000:8000) = 6.0;

% External forces
%Fext(1:2000) = 0; Fext(2001:8000) = 3e4;

% some test cases for Activations and external forces
pCa(1:8000) = 5.8; Fext(4000:8000) = 20; 
pCa(1:8000) = 9 ; Fext(4000:8000) = 20; % ok so for modeling for a limb we need to add some damping

% Implement the protocol
sim.implement_pendulum_protocol_perturbed( ...
    'pendulum_file_string', pendulum_file, ...
    'options_file_string', options_file, ...
    'dt', dt, ...
    'pCa', pCa, ...
    'Fext', Fext);

% Save the output
sim_output = sim.sim_output;

if (~isempty(output_file))
    % Check directory exists
    output_dir = fileparts(output_file);
    if (~isdir(output_dir))
        sprintf('Creating output directory: %s', fullfile(cd,output_dir))
        [status, msg, msgID] = mkdir(output_dir);
    end
    save(output_file,'sim_output');
end

% plot length and force - adapted from demo_simple_twitch.m
figure(4)
%clf
subplot(3,2,1)
plot(sim_output.time_s,sim_output.f_activated,'k-','LineWidth',2);
ylabel('fraction CBs activated')
hold on
subplot(3,2,3);
plot(sim_output.time_s,sim_output.muscle_force,'k-','LineWidth',2);
ylabel('Force (N m^{-2})');
hold on
subplot(3,2,5);
plot(sim_output.time_s,sim_output.hs_length,'k-','LineWidth',2);
ylabel('Half-sarcomere length (nm)');
xlabel('Time (s)')
hold on

% now I would like to plot CB distributions every 50 point or so

skip_samples = 50;

plot_samples = [1:skip_samples:sim_output.no_of_time_points];
N_samples = length(plot_samples);
colors = hsv(length(plot_samples));

for i = 1:N_samples
    sample = plot_samples(i);
    % mark the points on the activation, force, and length plots
    subplot(3,2,1)
    plot(sim_output.time_s(sample),sim_output.f_activated(sample),'o', 'color',colors(i,:),'LineWidth',1)
    subplot(3,2,3)
    plot(sim_output.time_s(sample),sim_output.muscle_force(sample),'o', 'color',colors(i,:),'LineWidth',1)
    subplot(3,2,5)
    plot(sim_output.time_s(sample),sim_output.hs_length(sample),'o', 'color', colors(i,:),'LineWidth',1)
    
    % plot the distributions
    subplot(1,2,2)
    plot(squeeze(sim_output.cb_pops(plot_samples(i),:,:)),'color',colors(i,:),'LineWidth',1)
    hold on
 
end
colormap(colors); colorbar
xlabel('XB length')
ylabel('fraction of CB''s?')

% Convert sim_output to a table - this requires deleting some fields
sim_output = sim.sim_output;
sim_output = rmfield(sim_output, 'myosim_muscle');
sim_output = rmfield(sim_output, 'subplots');
sim_output = rmfield(sim_output, 'no_of_time_points');
sim_output = rmfield(sim_output, 'cb_pops')
sim_output = struct2table(sim_output);

% Draw some of the output fields as a stacked plot
figure (3)
stackedplot(sim_output, ...
    {'pendulum_position', 'muscle_length', 'hs_length', ...
    'hs_force'}, ...
    'XVariable', 'time_s', ...
    'DisplayLabels', { ...
        {'Pendulum','Position','(m)'}, ...
        {'MATMyoSim','muscle','length','(nm)'}, ...
        {'Half-sarcomere','length','(nm)'}, ...
        {'Muscle','stress','(N m^{-2})'}});
     
  
