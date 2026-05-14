% Return true when Bacon-Shor residual X/Z chains have logical parity.

function logical_fail = bacon_shor_logical_failure(x_residual, z_residual)
if nargin < 1 || isempty(x_residual), x_residual = zeros(1, 9); end
if nargin < 2 || isempty(z_residual), z_residual = zeros(1, 9); end

x_residual = logical(x_residual(:).');
z_residual = logical(z_residual(:).');
if numel(x_residual) ~= 9 || numel(z_residual) ~= 9
    error('bacon_shor_logical_failure:bad_length', 'Expected length-9 residual vectors.');
end

layout = bacon_shor_layout();
logical_fail = false;

for c = 1:3
    if mod(sum(x_residual(layout(:, c))), 2) == 1
        logical_fail = true;
        return;
    end
end

for r = 1:3
    if mod(sum(z_residual(layout(r, :))), 2) == 1
        logical_fail = true;
        return;
    end
end
end
