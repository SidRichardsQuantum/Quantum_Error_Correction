% Number of physical qubits for a named code.

function n = code_num_qubits(code)
switch lower(code)
    case {'bitflip','phaseflip'}
        n = 3;
    case {'fivequbit','five'}
        n = 5;
    case 'steane'
        n = 7;
    case 'shor'
        n = 9;
    otherwise
        error('code_num_qubits:unknown_code', 'Unknown code %s.', code);
end
end
