% Decode a Bacon-Shor Z-error syndrome to a representative Z correction.

function z_corr = decode_bacon_shor_z(s)
s = s(:).';
if numel(s) ~= 2
    error('decode_bacon_shor_z:bad_syndrome', 'Expected a length-2 syndrome.');
end

row = repetition_syndrome_to_index(s);
z_corr = zeros(1, 9);
if row > 0
    layout = bacon_shor_layout();
    z_corr(layout(row, 1)) = 1;
end
end

function idx = repetition_syndrome_to_index(s)
if isequal(s, [1 0])
    idx = 1;
elseif isequal(s, [1 1])
    idx = 2;
elseif isequal(s, [0 1])
    idx = 3;
else
    idx = 0;
end
end
