% Dispatch recovery for a named code.

function psi_corr = recover_code_state(code, psi)
switch lower(code)
    case 'bitflip'
        psi_corr = recover_bitflip(psi);
    case 'phaseflip'
        psi_corr = recover_phaseflip(psi);
    case 'shor'
        psi_corr = recover_shor(psi);
    case 'steane'
        psi_corr = recover_steane(psi);
    case {'fivequbit','five'}
        psi_corr = recover_fivequbit(psi);
    otherwise
        error('recover_code_state:unknown_code', 'Unknown code %s.', code);
end
end
