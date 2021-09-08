% plot the cross bridge populations in a MatMyoSim simulation
% LHT Sept 7, 2021
%
% [sim_output] = function plot_cb_pops
% Function lets you use a user interface to choose an output.myo file
% ? loads it and plots the f_activated, muscle_force, and hs_length
% ? plot cb_pops, with skip_samples defaulting at 50, or as a user input.
% ? returns the struct sim_output in case you want to plot more by hand

function [sim_output] =  plot_cb_pops(varargin)
% load output - goes to a temp file in main MATMyoSim directory
[filename path] = uigetfile('*.myo')
model_output_file_string = [path,filename]
% Load it back up and display to show how that can be done
sim = load(model_output_file_string,'-mat');
sim_output = sim.sim_output;

% plot length and force - adapted from demo_simple_twitch.m
figure
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
if isempty(varargin)
    skip_samples = 50;
else
    skip_samples = varargin{1}
end

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

title(path)




