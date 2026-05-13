% Exact logical failure by low Pauli-error weight for a named code.

function [weights, fail] = sweep_single_pauli_recovery_by_weight(code, max_weight)
n = code_num_qubits(code);
if nargin < 2 || isempty(max_weight), max_weight = min(2, n);
end
weights = 0:max_weight;
fail = zeros(size(weights));
alpha_beta = normalize_state([sqrt(0.31); exp(1i*pi/10)*sqrt(0.69)]);
psi = encode_code_state(code, alpha_beta);

for w = weights
    total = 0;
    failed = 0;
    masks = nchoosek(1:n, w);
    if w == 0
        masks = zeros(1,0);
    end
    for row = 1:size(masks,1)
        positions = masks(row,:);
        pauli_count = 3^w;
        for codeword = 0:(pauli_count - 1)
            err = repmat('I', 1, n);
            x = codeword;
            for j = 1:w
                digit = mod(x, 3) + 1;
                x = floor(x / 3);
                paulis = 'XYZ';
                err(positions(j)) = paulis(digit);
            end
            psi_noisy = apply_pauli_error(psi, err);
            psi_corr = recover_code_state(code, psi_noisy);
            total = total + 1;
            failed = failed + (state_fidelity(psi, psi_corr) < 1 - 1e-8);
        end
    end
    fail(find(weights == w)) = failed / total;
end
end
