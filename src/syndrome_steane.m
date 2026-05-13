% Measure Steane-code CSS stabilizers.

function [syn, psi_post] = syndrome_steane(psi)
H = steane_parity_check();
psi_post = psi;
syn.x = zeros(1,3);  % Z stabilizers detect X errors
syn.z = zeros(1,3);  % X stabilizers detect Z errors

for r = 1:3
    labels = row_to_pauli(H(r,:), 'Z');
    [syn.x(r), psi_post] = measure_observable(psi_post, pauli_string_operator(labels));
end

for r = 1:3
    labels = row_to_pauli(H(r,:), 'X');
    [syn.z(r), psi_post] = measure_observable(psi_post, pauli_string_operator(labels));
end
end

function labels = row_to_pauli(row, label)
labels = repmat('I', 1, numel(row));
for k = 1:numel(row)
    if row(k) == 1
        labels(k) = label;
    end
end
end
