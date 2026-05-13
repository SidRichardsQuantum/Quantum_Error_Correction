% Minimal surface-3 circuit-level schedule example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

rand('seed', 7);
out = simulate_surface3_circuit_level_once(0.02, 0.01, 0.002, 3);

fprintf('Surface-3 circuit-level schedule example\n');
fprintf('Data qubits:       [%s]\n', sprintf('%d ', out.schedule.data_qubits));
fprintf('Z-check ancillas:  [%s]\n', sprintf('%d ', out.schedule.z_ancillas));
fprintf('X-check ancillas:  [%s]\n', sprintf('%d ', out.schedule.x_ancillas));
fprintf('X syndrome vote:   [%s]\n', sprintf('%d ', out.x_syndrome_hat));
fprintf('Z syndrome vote:   [%s]\n', sprintf('%d ', out.z_syndrome_hat));
fprintf('X residual:        [%s]\n', sprintf('%d ', out.x_residual));
fprintf('Z residual:        [%s]\n', sprintf('%d ', out.z_residual));
fprintf('Hook events:       %d\n', numel(out.hook_events));
fprintf('Success:           %d\n', out.success);
