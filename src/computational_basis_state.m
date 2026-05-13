% Return computational basis vector |bits> for bits ordered q1...qn.

function ket = computational_basis_state(bits)
bits = bits(:).';
n = numel(bits);
idx = 1;
for k = 1:n
    idx = idx + bits(k) * 2^(n-k);
end
ket = zeros(2^n, 1);
ket(idx) = 1;
end
