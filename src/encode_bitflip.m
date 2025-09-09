% Encode |ψ> = α|0>+β|1> into 3-qubit repetition code.

function psi_enc = encode_bitflip(alpha_beta)
% alpha_beta: 2x1 vector alpha|0>+beta|1>
[~,X,~,~] = pauli();
[z0,z1] = qstates();

% logical |0_L>=|000>, |1_L>=|111>
zeroL = kronN(z0,z0,z0);
oneL  = kronN(z1,z1,z1);
psi_enc = alpha_beta(1)*zeroL + alpha_beta(2)*oneL;
end
