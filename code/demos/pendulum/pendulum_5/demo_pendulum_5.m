function demo_pendulum_5


mac=1;
if mac==1
    % define file paths
    fp_MATMyoSim = '/Users/surabhisimha/OneDrive - Emory University/Emory University/Projects/Muscle Spindle/Code/NeuromechanicCloneMatMyoSim/MATMyoSim/code/';
else
    fp_MATMyoSim = 'C:\Users\ssimha\Documents\MATLAB\';
    fp_CurrCode = 'C:\Users\ssimha\Documents\MATLAB\MechanisticModelTests\MyoSim\';
    fp_CurrSimIN = 'C:\Users\ssimha\Documents\MATLAB\MechanisticModelTests\MyoSim\sim_input\';
    fp_CurrSimOUT = 'C:\Users\ssimha\Documents\MATLAB\MechanisticModelTests\MyoSim\sim_output\';
    fp_CommonFunc = 'C:\Users\ssimha\Documents\MATLAB\MechanisticModelTests\';
end

% Variables
model_file = 'sim_input/model.json';
pendulum_file = 'sim_input/pendulum.json';
options_file = 'sim_input/options.json';
protocol_file = 'sim_input/protocol.txt';
output_file = 'sim_output/output.myo';

% Make sure the path allows us to find the right files
addpath(genpath(fp_MATMyoSim));

% Generate a protocol
generate_pendulum_protocol( ...
    'time_step', 0.001, ...
    'no_of_points', 8000, ...
    'pre_Ca_s',0.1, ...
    'initial_pCa',9.0,...
    'activating_pCa',6.0,...
    'F_ext',0.0,...
    'output_file_string', protocol_file);

% Run a simulation
sim_output = pendulum_simulation_driver( ...
    'pendulum_file_string',pendulum_file,...
    'protocol_file_string', protocol_file, ...
    'model_json_file_string', model_file, ...
    'options_file_string', options_file, ...
    'output_file_string', output_file);

%%
% Load the simulation back in
sim = load(output_file, '-mat');
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

% Convert sim_output to a table - this requires deleting some fields
sim_output = sim.sim_output
sim_output = rmfield(sim_output, 'myosim_muscle');
sim_output = rmfield(sim_output, 'subplots');
sim_output = rmfield(sim_output, 'no_of_time_points');
sim_output = rmfield(sim_output, 'cb_pops');
sim_output = struct2table(sim_output);

% Draw some of the output fields as a stacked plot
figure(99);
clf
stackedplot(sim_output, ...
    {'pendulum_position', 'muscle_length', 'hs_length', ...
    'hs_force'}, ...
    'XVariable', 'time_s', ...
    'DisplayLabels', { ...
        {'Pendulum','Position','(m)'}, ...
        {'MATMyoSim','muscle','length','(nm)'}, ...
        {'Half-sarcomere','length','(nm)'}, ...
        {'Muscle','stress','(N m^{-2})'}});
        
end