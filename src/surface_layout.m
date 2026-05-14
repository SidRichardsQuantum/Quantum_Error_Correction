% Build a compact odd-distance surface-code-style square layout.
%
% This generic educational layout uses d-by-d data qubits and 2-by-2
% plaquette parity checks for both X- and Z-error decoding. It is intended
% for small code-capacity experiments and decoder comparisons, complementing
% the hand-tuned surface3_* prototype.

function layout = surface_layout(d)
if nargin < 1
    d = 3;
end

if d < 3 || mod(d, 2) == 0
    error('surface_layout:bad_distance', 'Distance must be an odd integer >= 3.');
end

layout.d = d;
layout.n = d * d;
layout.data = reshape(1:layout.n, d, d).';
layout.x_checks = {};
layout.z_checks = {};

for r = 1:(d - 1)
    for c = 1:(d - 1)
        support = [layout.data(r,c), layout.data(r,c+1), ...
                   layout.data(r+1,c), layout.data(r+1,c+1)];
        layout.z_checks{end+1} = support;
        layout.x_checks{end+1} = support;
    end
end

layout.logical_x = cell(1, d);
layout.logical_z = cell(1, d);
for k = 1:d
    layout.logical_x{k} = layout.data(k, :);
    layout.logical_z{k} = layout.data(:, k).';
end
end
