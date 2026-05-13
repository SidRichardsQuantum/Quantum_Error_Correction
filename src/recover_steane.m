% Measure and correct a 7-qubit Steane-code state.

function [psi_corr, syn] = recover_steane(psi)
[syn, psi_meas] = syndrome_steane(psi);
psi_corr = correct_steane(psi_meas, syn);
end
