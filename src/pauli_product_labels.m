% Multiply Pauli strings, ignoring global phase.

function out = pauli_product_labels(a, b)
a = upper(a);
b = upper(b);
if numel(a) ~= numel(b)
    error('pauli_product_labels:size_mismatch', 'Pauli strings must have equal length.');
end

out = repmat('I', 1, numel(a));
for k = 1:numel(a)
    out(k) = pauli_product_one(a(k), b(k));
end
end

function c = pauli_product_one(a, b)
if a == 'I'
    c = b;
elseif b == 'I'
    c = a;
elseif a == b
    c = 'I';
elseif (a == 'X' && b == 'Y') || (a == 'Y' && b == 'X')
    c = 'Z';
elseif (a == 'X' && b == 'Z') || (a == 'Z' && b == 'X')
    c = 'Y';
elseif (a == 'Y' && b == 'Z') || (a == 'Z' && b == 'Y')
    c = 'X';
else
    error('pauli_product_labels:bad_label', 'Unknown Pauli labels %s and %s.', a, b);
end
end
