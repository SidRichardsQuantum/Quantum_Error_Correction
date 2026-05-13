% Measure and correct a 9-qubit Shor-code state.

function [psi_corr, syn] = recover_shor(psi)
[syn, psi_meas] = syndrome_shor(psi);
psi_corr = correct_shor(psi_meas, syn);
end
