% Fast Pauli-error recovery check using stabilizer syndrome algebra.

function [success, residual, correction, syndrome] = pauli_recovery_success(code, err, alpha_beta)
if nargin < 3 || isempty(alpha_beta)
    alpha_beta = normalize_state([sqrt(0.37); exp(1i*pi/6)*sqrt(0.63)]);
end

stabilizers = stabilizers_for_code(code);
syndrome = pauli_error_syndrome(stabilizers, err);
correction = correction_for_pauli_syndrome(code, syndrome);
residual = pauli_product_labels(correction, err);

psi = encode_code_state(code, alpha_beta);
psi_residual = apply_pauli_error(psi, residual);
success = state_fidelity(psi, psi_residual) > 1 - 1e-8;
end
