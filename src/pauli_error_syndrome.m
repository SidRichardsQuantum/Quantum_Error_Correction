% Return stabilizer syndrome bits for a Pauli error string.

function s = pauli_error_syndrome(stabilizers, error_label)
s = zeros(1, numel(stabilizers));
for r = 1:numel(stabilizers)
    s(r) = pauli_strings_anticommute(stabilizers{r}, error_label);
end
end

function bit = pauli_strings_anticommute(a, b)
count = 0;
for k = 1:numel(a)
    if a(k) ~= 'I' && b(k) ~= 'I' && a(k) ~= b(k)
        count = count + 1;
    end
end
bit = mod(count, 2);
end
