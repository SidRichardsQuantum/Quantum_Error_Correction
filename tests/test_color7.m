% 7-qubit triangular color-code tests.

tol = 1e-10;
labels = 'XYZ';

layout = color7_layout();
assert(layout.n == 7);
assert(numel(layout.faces) == 3);
assert(isequal(color7_stabilizers(), stabilizers_for_code('color7')));

alpha_beta = normalize_state([sqrt(0.3); exp(1i*pi/13)*sqrt(0.7)]);
psi = encode_color7(alpha_beta);
for q = 1:7
    for label = labels
        err = repmat('I', 1, 7);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_color7(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);

        out = recover_color7_pauli(err);
        assert(out.success);
    end
end

out = simulate_color7_pauli_once(0);
assert(out.success);
assert(isequal(out.residual, repmat('I', 1, 7)));
