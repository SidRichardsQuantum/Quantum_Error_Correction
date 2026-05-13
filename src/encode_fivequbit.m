% Encode alpha|0>+beta|1> into the 5-qubit perfect code.

function psi_enc = encode_fivequbit(alpha_beta)
persistent zeroL oneL;
if isempty(zeroL)
    stabilizers = fivequbit_stabilizers();
    d = 2^5;
    P = eye(d);
    for r = 1:numel(stabilizers)
        S = pauli_string_operator(stabilizers{r});
        P = ((eye(d) + S) / 2) * P;
    end

    logicalZ = pauli_string_operator('ZZZZZ');
    zero_seed = computational_basis_state([0 0 0 0 0]);
    zeroL = P * ((eye(d) + logicalZ) / 2) * zero_seed;
    zeroL = normalize_state(zeroL);

    logicalX = pauli_string_operator('XXXXX');
    oneL = logicalX * zeroL;
end

psi_enc = normalize_state(alpha_beta(1) * zeroL + alpha_beta(2) * oneL);
end
