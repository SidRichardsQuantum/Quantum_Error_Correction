% Monte Carlo logical failure sweep for Z errors on the small surface-code prototype.

function [ps, fail] = sweep_surface3_z_logical_error(ps, N)
if nargin < 1 || isempty(ps), ps = linspace(0, 0.2, 11);
end
if nargin < 2 || isempty(N), N = 1000;
end

fail = zeros(size(ps));
for i = 1:numel(ps)
    c = 0;
    for trial = 1:N
        out = simulate_surface3_z_once(ps(i));
        c = c + (~out.success);
    end
    fail(i) = c / N;
end
end
