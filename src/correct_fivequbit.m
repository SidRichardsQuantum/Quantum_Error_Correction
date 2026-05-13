% Correct any single-qubit Pauli error on the 5-qubit perfect code.

function psi_corr = correct_fivequbit(psi, s)
stabilizers = fivequbit_stabilizers();
psi_corr = psi;

for q = 1:5
    for label = 'XYZ'
        err = repmat('I', 1, 5);
        err(q) = label;
        if isequal(pauli_error_syndrome(stabilizers, err), s)
            psi_corr = apply_pauli_error(psi_corr, err);
            return;
        end
    end
end
end
