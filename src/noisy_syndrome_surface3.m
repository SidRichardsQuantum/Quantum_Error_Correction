% Flip each reported surface-code syndrome bit with probability q.

function s_noisy = noisy_syndrome_surface3(s_true, q)
if nargin < 2 || isempty(q), q = 0;
end
s_noisy = xor(s_true, rand(size(s_true)) < q);
end
