% Repeated noisy syndrome extraction for the 3-qubit bit-flip code.
% Uses majority vote on each syndrome bit across rounds.

function [psi_corr, s_hat, history] = recover_bitflip_noisy_syndrome(psi, q, rounds)
if nargin < 2 || isempty(q), q = 0.05;
end
if nargin < 3 || isempty(rounds), rounds = 3;
end

psi_meas = psi;
history = zeros(rounds, 2);
for r = 1:rounds
    [history(r,:), ~, psi_meas] = noisy_syndrome_bitflip(psi_meas, q);
end

s_hat = sum(history, 1) > rounds / 2;
psi_corr = correct_bitflip(psi_meas, s_hat);
end
