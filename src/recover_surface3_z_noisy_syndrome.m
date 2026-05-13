% Decode Z errors using repeated noisy X-check syndrome measurements.

function [correction, s_hat, history, residual] = recover_surface3_z_noisy_syndrome(e, q, rounds)
if nargin < 2 || isempty(q), q = 0.05;
end
if nargin < 3 || isempty(rounds), rounds = 3;
end

s_true = surface3_z_syndrome(e);
history = zeros(rounds, numel(s_true));
for r = 1:rounds
    history(r,:) = noisy_syndrome_surface3(s_true, q);
end

s_hat = surface3_majority_syndrome(history);
correction = decode_surface3_z_matching(s_hat);
residual = xor(e, correction);
end
