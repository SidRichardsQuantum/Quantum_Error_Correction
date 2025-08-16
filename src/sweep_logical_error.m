function [ps, fail] = sweep_logical_error(ps, N, logical_bit)
% returns empirical logical failure prob for each p
if nargin < 1 || isempty(ps), ps = linspace(0,0.4,21); end
if nargin < 2 || isempty(N),  N  = 2e4; end
if nargin < 3, logical_bit = 0; end

fail = zeros(size(ps));
alpha_beta = logical_bit==0 ? [1;0] : [0;1];
for i = 1:numel(ps)
    c = 0;
    for n = 1:N
        o = simulate_bitflip_once(ps(i), alpha_beta, logical_bit);
        c = c + (~o.success);
    end
    fail(i) = c / N;
end
end
