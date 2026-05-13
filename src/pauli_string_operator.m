% Build an n-qubit Pauli string operator from characters I, X, Y, Z.

function P = pauli_string_operator(labels)
labels = upper(labels);
persistent cache;
if isempty(cache)
    cache = containers.Map();
end
if isKey(cache, labels)
    P = cache(labels);
    return;
end

[I,X,Y,Z] = pauli();
P = 1;
for k = 1:numel(labels)
    switch labels(k)
        case 'I'
            op = I;
        case 'X'
            op = X;
        case 'Y'
            op = Y;
        case 'Z'
            op = Z;
        otherwise
            error('pauli_string_operator:bad_label', 'Unknown Pauli label %s.', labels(k));
    end
    P = kron(P, op);
end
cache(labels) = P;
end
