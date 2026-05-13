% Encode alpha|0>+beta|1> into the 9-qubit Shor code.

function psi_enc = encode_shor(alpha_beta)
persistent zeroL oneL;
if isempty(zeroL)
    [z0,z1] = qstates();
    ghz_plus = (kronN(z0,z0,z0) + kronN(z1,z1,z1)) / sqrt(2);
    ghz_minus = (kronN(z0,z0,z0) - kronN(z1,z1,z1)) / sqrt(2);
    zeroL = kronN(ghz_plus, ghz_plus, ghz_plus);
    oneL = kronN(ghz_minus, ghz_minus, ghz_minus);
end
psi_enc = normalize_state(alpha_beta(1) * zeroL + alpha_beta(2) * oneL);
end
