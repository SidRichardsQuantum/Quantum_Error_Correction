% Measure and correct a 5-qubit perfect-code state.

function [psi_corr, s] = recover_fivequbit(psi)
[s, psi_meas] = syndrome_fivequbit(psi);
psi_corr = correct_fivequbit(psi_meas, s);
end
