% Build an n-qubit operator with one non-identity Pauli at qubit q.

function P = single_pauli_operator(n, q, label)
persistent cache;
if isempty(cache)
    cache = containers.Map();
end
key = sprintf('%d:%d:%s', n, q, upper(label));
if isKey(cache, key)
    P = cache(key);
    return;
end

labels = repmat('I', 1, n);
labels(q) = upper(label);
P = pauli_string_operator(labels);
cache(key) = P;
end
