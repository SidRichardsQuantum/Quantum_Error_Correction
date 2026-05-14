% Syndrome for X errors in the 3x3 Bacon-Shor code.
% X errors are detected by comparing Z parity between neighboring columns.

function s = bacon_shor_x_syndrome(x_error)
x_error = logical(x_error(:).');
if numel(x_error) ~= 9
    error('bacon_shor_x_syndrome:bad_length', 'Expected a length-9 X-error vector.');
end

layout = bacon_shor_layout();
col_parity = zeros(1, 3);
for c = 1:3
    col_parity(c) = mod(sum(x_error(layout(:, c))), 2);
end
s = [xor(col_parity(1), col_parity(2)), xor(col_parity(2), col_parity(3))];
end
