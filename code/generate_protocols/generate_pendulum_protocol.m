function generate_pendulum_protocol(varargin)
 
p = inputParser;
addOptional(p,'time_step',0.001);
addOptional(p,'output_file_string','protocol\pendulum.txt');
addOptional(p,'no_of_points',1000);
addOptional(p,'pre_Ca_s',0.1);
addOptional(p,'initial_pCa',9.0);   
addOptional(p,'activating_pCa',6.0);
addOptional(p,'F_ext',0);
parse(p,varargin{:});
p=p.Results;
 
% Generate hsl
% output.dhsl = NaN*ones(p.no_of_points,1);
 
% Generate dt
output.dt = p.time_step * ones(p.no_of_points,1);
 
% Generate mode
output.Mode = -2 * ones(numel(output.dt),1);
 
% Generate pCa
output.pCa = p.initial_pCa * ones(numel(output.dt),1);
output.pCa(cumsum(output.dt)>p.pre_Ca_s) = p.activating_pCa;

% Generate Fext
output.Fext = p.F_ext*ones(numel(output.dt),1);
 
% Output
output_table = struct2table(output);
writetable(output_table,p.output_file_string,'delimiter','\t');

