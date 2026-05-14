% Number of physical qubits for a named code.

function n = code_num_qubits(code)
switch lower(code)
    case {'bitflip','phaseflip'}
        n = 3;
    case {'fivequbit','five'}
        n = 5;
    case {'steane','color7','color_code','colorcode'}
        n = 7;
    case 'shor'
        n = 9;
    case {'baconshor','bacon_shor'}
        n = 9;
    otherwise
        error('code_num_qubits:unknown_code', 'Unknown code %s.', code);
end
end
