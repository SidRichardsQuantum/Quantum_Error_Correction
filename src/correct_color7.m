% Correct any single-qubit Pauli error on the 7-qubit color code.

function psi_corr = correct_color7(psi, syn)
psi_corr = correct_steane(psi, syn);
end
