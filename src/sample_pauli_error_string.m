% Sample an n-qubit independent Pauli error string.
% With probability p per qubit, apply X, Y, or Z uniformly.

function labels = sample_pauli_error_string(n, p)
labels = repmat('I', 1, n);
paulis = 'XYZ';
for q = 1:n
    if rand() < p
        labels(q) = paulis(randi(3));
    end
end
end
