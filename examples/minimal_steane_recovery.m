% Minimal 7-qubit Steane-code recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

alpha_beta = normalize_state([sqrt(0.2); exp(1i*pi/9)*sqrt(0.8)]);
psi = encode_steane(alpha_beta);

error_string = 'IIYIIII';
psi_noisy = apply_pauli_error(psi, error_string);
[psi_corr, syndrome] = recover_steane(psi_noisy);

fprintf('7-qubit Steane recovery\n');
fprintf('Injected Pauli error: %s\n', error_string);
fprintf('X-error syndrome from Z checks: [%s]\n', sprintf('%d ', syndrome.x));
fprintf('Z-error syndrome from X checks: [%s]\n', sprintf('%d ', syndrome.z));
fprintf('Recovery fidelity: %.12f\n', state_fidelity(psi, psi_corr));
