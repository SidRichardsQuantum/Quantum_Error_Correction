% Correct any single-qubit Pauli error on the 7-qubit Steane code.

function psi_corr = correct_steane(psi, syn)
H = steane_parity_check();
psi_corr = psi;

qx = binary_syndrome_index(H, syn.x);
if qx > 0
    psi_corr = single_pauli_operator(7, qx, 'X') * psi_corr;
end

qz = binary_syndrome_index(H, syn.z);
if qz > 0
    psi_corr = single_pauli_operator(7, qz, 'Z') * psi_corr;
end
end
