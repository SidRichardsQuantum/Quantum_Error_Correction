% Decode a Bacon-Shor X-error syndrome to a representative X correction.

function x_corr = decode_bacon_shor_x(s)
s = s(:).';
if numel(s) ~= 2
    error('decode_bacon_shor_x:bad_syndrome', 'Expected a length-2 syndrome.');
end

col = repetition_syndrome_to_index(s);
x_corr = zeros(1, 9);
if col > 0
    layout = bacon_shor_layout();
    x_corr(layout(1, col)) = 1;
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
