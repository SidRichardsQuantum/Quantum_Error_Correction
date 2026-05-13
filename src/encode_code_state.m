% Dispatch encoding for a named code.

function psi = encode_code_state(code, alpha_beta)
switch lower(code)
    case 'bitflip'
        psi = encode_bitflip(alpha_beta);
    case 'phaseflip'
        psi = encode_phaseflip(alpha_beta);
    case 'shor'
        psi = encode_shor(alpha_beta);
    case 'steane'
        psi = encode_steane(alpha_beta);
    case {'fivequbit','five'}
        psi = encode_fivequbit(alpha_beta);
    otherwise
        error('encode_code_state:unknown_code', 'Unknown code %s.', code);
end
end
