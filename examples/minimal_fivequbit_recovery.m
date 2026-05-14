% Minimal 5-qubit perfect-code recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

alpha_beta = normalize_state([sqrt(0.45); exp(1i*pi/11)*sqrt(0.55)]);
psi = encode_fivequbit(alpha_beta);

error_string = 'IIIXI';
psi_noisy = apply_pauli_error(psi, error_string);
[psi_corr, syndrome] = recover_fivequbit(psi_noisy);

fprintf('5-qubit perfect-code recovery\n');
fprintf('Injected Pauli error: %s\n', error_string);
fprintf('Measured syndrome: [%s]\n', sprintf('%d ', syndrome));
fprintf('Recovery fidelity: %.12f\n', state_fidelity(psi, psi_corr));
