% Add Quantum_Error_Correction source and examples to the Octave/MATLAB path.
%
% Run from the repository root:
%
%   qec_setup

rootdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(rootdir, 'src')));
addpath(fullfile(rootdir, 'examples'));

fprintf('Quantum_Error_Correction paths loaded from %s\n', rootdir);
fprintf('Run tests with: octave --no-gui tests/run_all_tests.m\n');
