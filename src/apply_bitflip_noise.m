% Apply independent bit-flip noise to a 3-qubit state vector.
% Uses the same Monte-Carlo sampling model as the rest of the codebase:
% sample a random error pattern e~Bernoulli(p)^3 and apply X where e_i=1.

function psi_noisy = apply_bitflip_noise(psi,p)
e = sample_error_pattern(p);
psi_noisy = apply_error_pattern(psi, e);
end
