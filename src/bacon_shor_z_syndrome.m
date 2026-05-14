% Syndrome for Z errors in the 3x3 Bacon-Shor code.
% Z errors are detected by comparing X parity between neighboring rows.

function s = bacon_shor_z_syndrome(z_error)
z_error = logical(z_error(:).');
if numel(z_error) ~= 9
    error('bacon_shor_z_syndrome:bad_length', 'Expected a length-9 Z-error vector.');
end

layout = bacon_shor_layout();
row_parity = zeros(1, 3);
for r = 1:3
    row_parity(r) = mod(sum(z_error(layout(r, :))), 2);
end
s = [xor(row_parity(1), row_parity(2)), xor(row_parity(2), row_parity(3))];
end
