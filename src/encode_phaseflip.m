% Encode alpha|0>+beta|1> into the 3-qubit phase-flip repetition code.

function psi_enc = encode_phaseflip(alpha_beta)
[z0,z1] = qstates();
plus = (z0 + z1) / sqrt(2);
minus = (z0 - z1) / sqrt(2);
zeroL = kronN(plus, plus, plus);
oneL = kronN(minus, minus, minus);
psi_enc = normalize_state(alpha_beta(1) * zeroL + alpha_beta(2) * oneL);
end
