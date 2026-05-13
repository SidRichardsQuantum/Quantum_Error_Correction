% Correct any single-qubit Pauli error on the 9-qubit Shor code.

function psi_corr = correct_shor(psi, syn)
psi_corr = psi;

for block = 1:3
    local_s = syn.bit(block, :);
    qlocal = bitflip_syndrome_to_qubit(local_s);
    if qlocal > 0
        q = 3 * (block - 1) + qlocal;
        psi_corr = single_pauli_operator(9, q, 'X') * psi_corr;
    end
end

block = bitflip_syndrome_to_qubit(syn.phase);
if block > 0
    q = 3 * (block - 1) + 1;
    psi_corr = single_pauli_operator(9, q, 'Z') * psi_corr;
end
end

function q = bitflip_syndrome_to_qubit(s)
if isequal(s, [1 0])
    q = 1;
elseif isequal(s, [1 1])
    q = 2;
elseif isequal(s, [0 1])
    q = 3;
else
    q = 0;
end
end
