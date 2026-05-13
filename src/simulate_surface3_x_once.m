% One X-noise decoding trial for the small surface-code prototype.

function out = simulate_surface3_x_once(p)
if nargin < 1 || isempty(p), p = 0.05;
end

e = rand(1,9) < p;
s = surface3_x_syndrome(e);
ehat = decode_surface3_x_matching(s);
residual = xor(e, ehat);

% Horizontal or vertical length-3 residual chains are logical representatives
% in this compact rotated-layout model.
logical_sets = {[1 2 3], [4 5 6], [7 8 9], [1 4 7], [2 5 8], [3 6 9]};
logical_fail = false;
for k = 1:numel(logical_sets)
    if mod(sum(residual(logical_sets{k})), 2) == 1
        logical_fail = true;
        break;
    end
end

out.error = e;
out.syndrome = s;
out.correction = ehat;
out.residual = residual;
out.success = ~logical_fail;
end
