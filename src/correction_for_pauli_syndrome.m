% Minimum-weight single-qubit correction for a Pauli syndrome.

function corr = correction_for_pauli_syndrome(code, s)
n = code_num_qubits(code);
stabilizers = stabilizers_for_code(code);
corr = repmat('I', 1, n);

if ~any(s)
    return;
end

for q = 1:n
    for label = 'XYZ'
        candidate = repmat('I', 1, n);
        candidate(q) = label;
        if isequal(pauli_error_syndrome(stabilizers, candidate), s)
            corr = candidate;
            return;
        end
    end
end
end
