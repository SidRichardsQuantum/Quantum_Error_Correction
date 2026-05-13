% Correct the 3-qubit phase-flip code and preserve the encoded state.

function [psi_corr, s] = recover_phaseflip(psi)
[s, psi_meas] = syndrome_phaseflip(psi);
psi_corr = correct_phaseflip(psi_meas, s);
end
