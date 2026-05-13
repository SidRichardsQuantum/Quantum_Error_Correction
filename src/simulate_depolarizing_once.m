% One depolarizing-noise recovery trial for a named code.

function out = simulate_depolarizing_once(code, p, alpha_beta)
if nargin < 3 || isempty(alpha_beta)
    alpha_beta = [1; 0];
end

n = code_num_qubits(code);
err = sample_pauli_error_string(n, p);
[success, residual, correction, syndrome] = pauli_recovery_success(code, err, alpha_beta);

out.error = err;
out.syndrome = syndrome;
out.correction = correction;
out.residual = residual;
out.success = success;
out.fidelity = double(success);
end
