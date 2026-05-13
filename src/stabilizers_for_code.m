% Return stabilizer generators for a named small code.

function stabilizers = stabilizers_for_code(code)
switch lower(code)
    case 'bitflip'
        stabilizers = {'ZZI', 'IZZ'};
    case 'phaseflip'
        stabilizers = {'XXI', 'IXX'};
    case {'fivequbit','five'}
        stabilizers = fivequbit_stabilizers();
    case 'steane'
        H = steane_parity_check();
        stabilizers = {};
        for r = 1:3
            stabilizers{end+1} = row_to_pauli(H(r,:), 'Z');
        end
        for r = 1:3
            stabilizers{end+1} = row_to_pauli(H(r,:), 'X');
        end
    case 'shor'
        stabilizers = {'ZZIIIIIII', 'IZZIIIIII', 'IIIZZIIII', 'IIIIZZIII', ...
                       'IIIIIIZZI', 'IIIIIIIZZ', 'XXXXXXIII', 'IIIXXXXXX'};
    otherwise
        error('stabilizers_for_code:unknown_code', 'Unknown code %s.', code);
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
