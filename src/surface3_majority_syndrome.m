% Majority vote each syndrome bit across repeated measurement rounds.

function s_hat = surface3_majority_syndrome(history)
rounds = size(history, 1);
s_hat = sum(history, 1) > rounds / 2;
end
