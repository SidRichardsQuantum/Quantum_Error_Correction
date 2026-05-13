% Encode alpha|0>+beta|1> into the 7-qubit Steane code.

function psi_enc = encode_steane(alpha_beta)
persistent zeroL oneL;
if isempty(zeroL)
    H = steane_parity_check();
    zeroL = zeros(2^7, 1);
    for mask = 0:7
        coeffs = bitget(mask, 1:3);
        bits = mod(coeffs * H, 2);
        zeroL = zeroL + computational_basis_state(bits);
    end
    zeroL = zeroL / sqrt(8);

    oneL = zeros(2^7, 1);
    for idx = 1:numel(zeroL)
        if abs(zeroL(idx)) > 0
            bits = index_to_bits(idx - 1, 7);
            oneL = oneL + computational_basis_state(1 - bits);
        end
    end
    oneL = oneL / sqrt(8);
end

psi_enc = normalize_state(alpha_beta(1) * zeroL + alpha_beta(2) * oneL);
end

function bits = index_to_bits(idx, n)
bits = zeros(1, n);
for k = 1:n
    bits(k) = bitget(idx, n-k+1);
end
end
