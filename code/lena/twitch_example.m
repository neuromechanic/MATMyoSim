% look at twitch example
% LHT Sept 7, 2021

% simple twitch demo by Ken
% https://campbell-muscle-lab.github.io/MATMyoSim/pages/demos/getting_started/simple_twitch/simple_twitch.html
% run MATMyoSim/code/demos/getting-started
% output .myo file saves to MATMyoSim/temp

% load output - goes to a temp file in main MATMyoSim directory
path = '/Users/lenating/Dropbox/My Docs/Matlab/MATMyoSim/'
model_output_file_string = [path,'/temp/simple_twitch_output.myo'];
% Load it back up and display to show how that can be done
sim = load(model_output_file_string,'-mat');
sim_output = sim.sim_output;

% plot length and force - adapted from demo_simple_twitch.m
clf
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

% now I would like to plot CB distributions during this twitch
% there are 500 data points, lets plot every 50 points
skip_samples = 10;
plot_samples = [1:skip_samples:sim_output.no_of_time_points];
N_samples = length(plot_samples);
colors = hsv(length(plot_samples));

for i = 1:N_samples
    sample = plot_samples(i);
    % mark the points on the activation, force, and length plots
    subplot(3,2,1)
    plot(sim_output.time_s(sample),sim_output.f_activated(sample),'o', 'color',colors(i,:),'LineWidth',2)
    subplot(3,2,3)
    plot(sim_output.time_s(sample),sim_output.muscle_force(sample),'o', 'color',colors(i,:),'LineWidth',2)
    subplot(3,2,5)
    plot(sim_output.time_s(sample),sim_output.hs_length(sample),'o', 'color', colors(i,:),'LineWidth',2)
    
    % plot the distributions
    subplot(1,2,2)
    plot(squeeze(sim_output.cb_pops(plot_samples(i),:,:)),'color',colors(i,:),'LineWidth',2)
    hold on
 
end
colormap(colors); colorbar
xlabel('XB length')
ylabel('fraction of CB''s?')

title('simple twitch demo')




