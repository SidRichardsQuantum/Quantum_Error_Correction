% Shared exhaustive minimum-weight decoder for compact surface-3 syndromes.

function ehat = decode_surface3_min_weight(s, channel)
s = s(:).';
persistent table_x weights_x table_z weights_z;

if strcmp(channel, 'x')
    if isempty(table_x)
        [table_x, weights_x] = build_table(channel);
    end
    ehat = table_x(syndrome_to_index(s), :);
elseif strcmp(channel, 'z')
    if isempty(table_z)
        [table_z, weights_z] = build_table(channel);
    end
    ehat = table_z(syndrome_to_index(s), :);
else
    error('decode_surface3_min_weight:bad_channel', 'Channel must be x or z.');
end
end

function [table, weights] = build_table(channel)
table = zeros(16, 9);
weights = inf(16, 1);
for mask = 0:(2^9 - 1)
    e = zeros(1,9);
    for q = 1:9
        e(q) = bitget(mask, 10-q);
    end

    if strcmp(channel, 'x')
        idx = syndrome_to_index(surface3_x_syndrome(e));
    else
        idx = syndrome_to_index(surface3_z_syndrome(e));
    end

    w = sum(e);
    if w < weights(idx)
        weights(idx) = w;
        table(idx,:) = e;
    end
end
end

function idx = syndrome_to_index(s)
idx = 1;
for k = 1:numel(s)
    idx = idx + s(k) * 2^(numel(s)-k);
end
end
