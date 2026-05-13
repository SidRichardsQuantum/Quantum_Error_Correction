% Run non-plotting examples that print compact text output.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
addpath(thisdir);

scripts = {'minimal_bitflip_recovery', ...
           'minimal_steane_recovery', ...
           'minimal_surface3_syndrome', ...
           'minimal_surface3_circuit_level', ...
           'surface3_walkthrough'};

for k = 1:numel(scripts)
    fprintf('\nRunning %s...\n', scripts{k});
    feval(scripts{k});
end

disp('All text examples completed.');
