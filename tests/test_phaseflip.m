% 3-qubit phase-flip code tests.

tol = 1e-10;

alpha_beta = normalize_state([sqrt(0.3); exp(1i*pi/5)*sqrt(0.7)]);
psi = encode_phaseflip(alpha_beta);

for q = 1:3
    e = zeros(1,3);
    e(q) = 1;
    psi_noisy = apply_phase_error_pattern(psi, e);
    psi_corr = recover_phaseflip(psi_noisy);
    assert(state_fidelity(psi, psi_corr) > 1 - tol);
end
