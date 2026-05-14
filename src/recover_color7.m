% Measure and correct a 7-qubit triangular color-code state.

function [psi_corr, syn] = recover_color7(psi)
[syn, psi_meas] = syndrome_color7(psi);
psi_corr = correct_color7(psi_meas, syn);
end
