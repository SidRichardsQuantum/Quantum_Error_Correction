% Correct the 3-qubit bit-flip code and preserve the encoded state.

function [psi_corr, s] = recover_bitflip(psi)
[s, psi_meas] = syndrome_bitflip(psi);
psi_corr = correct_bitflip(psi_meas, s);
end
