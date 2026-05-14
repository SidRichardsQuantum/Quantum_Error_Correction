% Minimal 3-qubit phase-flip recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

alpha_beta = normalize_state([1; -1i]);
psi = encode_phaseflip(alpha_beta);

error_pattern = [0 0 1];
psi_noisy = apply_phase_error_pattern(psi, error_pattern);
[psi_corr, syndrome] = recover_phaseflip(psi_noisy);

fprintf('3-qubit phase-flip recovery\n');
fprintf('Injected Z error pattern: [%d %d %d]\n', error_pattern);
fprintf('Measured syndrome: [%d %d]\n', syndrome);
fprintf('Recovery fidelity: %.12f\n', state_fidelity(psi, psi_corr));
