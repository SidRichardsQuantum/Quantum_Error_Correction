% Minimum-weight decoder for a 1D repetition-code syndrome.
% Syndrome s(k)=e(k) xor e(k+1). Returns the lower-weight compatible error.

function ehat = decode_repetition_min_weight(s)
s = s(:).';
n = numel(s) + 1;

e0 = zeros(1, n);
for k = 1:numel(s)
    e0(k+1) = xor(e0(k), s(k));
end

e1 = zeros(1, n);
e1(1) = 1;
for k = 1:numel(s)
    e1(k+1) = xor(e1(k), s(k));
end

if sum(e1) < sum(e0)
    ehat = e1;
else
    ehat = e0;
end
end
