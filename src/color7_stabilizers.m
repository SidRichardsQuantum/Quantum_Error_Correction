% Stabilizer generators for the 7-qubit triangular color code.
%
% The smallest triangular 2D color code is locally equivalent to the Steane
% code. This representation uses the standard [7,1,3] CSS parity checks.

function stabilizers = color7_stabilizers()
H = steane_parity_check();
stabilizers = {};
for r = 1:3
    stabilizers{end+1} = row_to_pauli(H(r,:), 'Z');
end
for r = 1:3
    stabilizers{end+1} = row_to_pauli(H(r,:), 'X');
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
