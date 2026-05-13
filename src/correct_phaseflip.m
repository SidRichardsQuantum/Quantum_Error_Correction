% Apply single-qubit Z correction for the 3-qubit phase-flip code.

function psi_corr = correct_phaseflip(psi, s)
[~,~,~,Z] = pauli();
Z1 = kronN(Z,eye(2),eye(2));
Z2 = kronN(eye(2),Z,eye(2));
Z3 = kronN(eye(2),eye(2),Z);

if isequal(s,[1 0])
    psi_corr = Z1 * psi;
elseif isequal(s,[1 1])
    psi_corr = Z2 * psi;
elseif isequal(s,[0 1])
    psi_corr = Z3 * psi;
else
    psi_corr = psi;
end
end
