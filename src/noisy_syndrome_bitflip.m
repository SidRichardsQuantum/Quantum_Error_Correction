% Measure bit-flip syndrome and flip each reported syndrome bit with prob q.

function [s_noisy, s_true, psi_post] = noisy_syndrome_bitflip(psi, q)
if nargin < 2 || isempty(q), q = 0;
end
[s_true, psi_post] = syndrome_bitflip(psi);
s_noisy = xor(s_true, rand(size(s_true)) < q);
end
