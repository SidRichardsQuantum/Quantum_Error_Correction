% Estimate logical failure under independent depolarizing noise.

function [ps, fail] = sweep_depolarizing_logical_error(code, ps, N, alpha_beta)
if nargin < 2 || isempty(ps), ps = linspace(0, 0.25, 11);
end
if nargin < 3 || isempty(N), N = 200;
end
if nargin < 4 || isempty(alpha_beta)
    alpha_beta = normalize_state([sqrt(0.37); exp(1i*pi/6)*sqrt(0.63)]);
end

fail = zeros(size(ps));
for i = 1:numel(ps)
    c = 0;
    for trial = 1:N
        out = simulate_depolarizing_once(code, ps(i), alpha_beta);
        c = c + (~out.success);
    end
    fail(i) = c / N;
end
end
