% Minimal 9-qubit Shor-code recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

alpha_beta = normalize_state([sqrt(0.35); exp(1i*pi/8)*sqrt(0.65)]);
psi = encode_shor(alpha_beta);

error_string = 'IIIIYIIII';
psi_noisy = apply_pauli_error(psi, error_string);
[psi_corr, syndrome] = recover_shor(psi_noisy);

fprintf('9-qubit Shor recovery\n');
fprintf('Injected Pauli error: %s\n', error_string);
fprintf('Bit syndromes by block:\n');
for block = 1:3
    fprintf('  block %d: [%s]\n', block, sprintf('%d ', syndrome.bit(block, :)));
end
fprintf('Phase syndrome: [%s]\n', sprintf('%d ', syndrome.phase));
fprintf('Recovery fidelity: %.12f\n', state_fidelity(psi, psi_corr));
