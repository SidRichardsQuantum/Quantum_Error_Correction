% Single-qubit Pauli recovery tests for stabilizer codes.

tol = 1e-10;
labels = 'XYZ';

alpha_beta = normalize_state([sqrt(0.4); exp(1i*pi/7)*sqrt(0.6)]);
psi = encode_shor(alpha_beta);
for q = 1:9
    for label = labels
        err = repmat('I', 1, 9);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_shor(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end

alpha_beta = normalize_state([sqrt(0.2); exp(1i*pi/9)*sqrt(0.8)]);
psi = encode_steane(alpha_beta);
for q = 1:7
    for label = labels
        err = repmat('I', 1, 7);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_steane(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end

alpha_beta = normalize_state([sqrt(0.45); exp(1i*pi/11)*sqrt(0.55)]);
psi = encode_fivequbit(alpha_beta);
for q = 1:5
    for label = labels
        err = repmat('I', 1, 5);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_fivequbit(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end
