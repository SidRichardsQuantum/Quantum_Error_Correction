% Minimal 3-qubit bit-flip recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

alpha_beta = normalize_state([1; 1i]);
psi = encode_bitflip(alpha_beta);

error_pattern = [0 1 0];
psi_noisy = apply_error_pattern(psi, error_pattern);
[psi_corr, syndrome] = recover_bitflip(psi_noisy);

fprintf('3-qubit bit-flip recovery\n');
fprintf('Injected X error pattern: [%d %d %d]\n', error_pattern);
fprintf('Measured syndrome: [%d %d]\n', syndrome);
fprintf('Recovery fidelity: %.12f\n', state_fidelity(psi, psi_corr));
