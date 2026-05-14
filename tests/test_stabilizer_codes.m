% Single-qubit Pauli recovery tests for stabilizer codes.

tol = 1e-10;
labels = 'XYZ';

logical_two = normalize_state([sqrt(0.1); exp(1i*pi/5)*sqrt(0.2); ...
                               exp(1i*pi/7)*sqrt(0.3); sqrt(0.4)]);
psi = encode_four_two_two(logical_two);
[syn, psi_post] = syndrome_four_two_two(psi);
assert(isequal(syn, [0 0]));
assert(state_fidelity(psi, psi_post) > 1 - tol);
assert(code_num_qubits('four_two_two') == 4);
assert(isequal(stabilizers_for_code('422'), four_two_two_stabilizers()));

for q = 1:4
    for label = labels
        err = repmat('I', 1, 4);
        err(q) = label;
        [detected, syn] = detect_four_two_two(err);
        assert(detected);
        assert(any(syn));

        psi_noisy = apply_pauli_error(psi, err);
        [detected_state, syn_state] = detect_four_two_two(psi_noisy);
        assert(detected_state);
        assert(any(syn_state));
    end
end

logical_ops = {'XXII', 'ZIZI', 'XIXI', 'ZZII'};
for k = 1:numel(logical_ops)
    err = logical_ops{k};
    [detected, syn] = detect_four_two_two(err);
    assert(~detected);
    assert(isequal(syn, [0 0]));

    psi_logical = apply_pauli_error(psi, err);
    [detected_state, syn_state] = detect_four_two_two(psi_logical);
    assert(~detected_state);
    assert(isequal(syn_state, [0 0]));
end

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
