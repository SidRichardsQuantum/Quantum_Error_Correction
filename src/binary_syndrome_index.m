% Find the qubit whose parity-check column matches a syndrome row vector.

function q = binary_syndrome_index(H, s)
s = s(:);
q = 0;
for k = 1:size(H, 2)
    if isequal(H(:,k), s)
        q = k;
        return;
    end
end
end
