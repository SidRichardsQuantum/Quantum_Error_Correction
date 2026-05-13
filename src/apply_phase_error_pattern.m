% Deterministically apply Z errors for a phase-flip pattern [e1 e2 e3].

function psi_out = apply_phase_error_pattern(psi, e)
labels = repmat('I', 1, 3);
for k = 1:3
    if e(k) == 1
        labels(k) = 'Z';
    end
end
psi_out = apply_pauli_error(psi, labels);
end
