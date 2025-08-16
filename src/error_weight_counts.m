function w = error_weight_counts(N, p)
% counts of number of flips {0,1,2,3} under independent flips prob p
if nargin < 1 || isempty(N), N = 1e5; end
if nargin < 2 || isempty(p), p = 0.15; end
w = zeros(4,1);
for n = 1:N
    e = sample_error_pattern(p);
    k = sum(e);
    w(k+1) = w(k+1) + 1;
end
end
