% Minimum-weight decoder for X errors on the small distance-3 surface layout.
% For this tiny code, exhaustive lookup gives the same minimum-weight result
% a matching decoder would choose on the syndrome graph.

function ehat = decode_surface3_x_matching(s)
s = s(:).';
persistent table weights;

if isempty(table)
    table = zeros(16, 9);
    weights = inf(16, 1);
    for mask = 0:(2^9 - 1)
        e = zeros(1,9);
        for q = 1:9
            e(q) = bitget(mask, 10-q);
        end
        idx = syndrome_to_index(surface3_x_syndrome(e));
        w = sum(e);
        if w < weights(idx)
            weights(idx) = w;
            table(idx,:) = e;
        end
    end
end

ehat = table(syndrome_to_index(s), :);
end

function idx = syndrome_to_index(s)
idx = 1;
for k = 1:numel(s)
    idx = idx + s(k) * 2^(numel(s)-k);
end
end
