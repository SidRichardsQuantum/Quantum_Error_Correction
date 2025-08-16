function counts = collect_syndromes(N, p, logical_bit)
% counts over syndromes 00,10,11,01 (binary order by s=[s12 s23])
if nargin < 1 || isempty(N), N = 1e5; end
if nargin < 2 || isempty(p), p = 0.1; end
if nargin < 3, logical_bit = 0; end

if logical_bit==0
    alpha_beta = [1;0];
else
    alpha_beta = [0;1];
end

counts = zeros(4,1);
for n = 1:N
    o = simulate_bitflip_once(p, alpha_beta, logical_bit);
    idx = s2idx(o.syndrome); % 1..4
    counts(idx) = counts(idx) + 1;
end
end

function k = s2idx(s)
s = s(:).';                          % force 1×2
map = [0 0; 1 0; 1 1; 0 1];
[~,k] = ismember(s, map, 'rows');
end
