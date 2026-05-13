% Apply an n-qubit Pauli string such as 'IXYZ' to a state vector.

function psi_out = apply_pauli_error(psi, labels)
labels = upper(labels);
n = numel(labels);
d = 2^n;
psi_out = zeros(size(psi));

for idx0 = 0:(d-1)
    amp = psi(idx0 + 1);
    if amp == 0
        continue;
    end

    out_idx = idx0;
    phase = 1;
    for q = 1:n
        bit = bitget(idx0, n-q+1);
        switch labels(q)
            case 'I'
            case 'X'
                out_idx = bitxor(out_idx, 2^(n-q));
            case 'Z'
                if bit == 1
                    phase = -phase;
                end
            case 'Y'
                out_idx = bitxor(out_idx, 2^(n-q));
                if bit == 0
                    phase = phase * 1i;
                else
                    phase = phase * -1i;
                end
            otherwise
                error('apply_pauli_error:bad_label', 'Unknown Pauli label %s.', labels(q));
        end
    end
    psi_out(out_idx + 1) = psi_out(out_idx + 1) + phase * amp;
end
end
