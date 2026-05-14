% One bit-flip trial with noisy repeated syndrome measurements.

function out = simulate_noisy_syndrome_bitflip_once(p_data, p_meas, rounds, alpha_beta)
if nargin < 4 || isempty(alpha_beta)
    alpha_beta = normalize_state([sqrt(0.41); exp(1i*pi/8)*sqrt(0.59)]);
end

psi = encode_bitflip(alpha_beta);
err = sample_error_pattern(p_data);
psi_noisy = apply_error_pattern(psi, err);
[psi_corr, s_hat, history] = recover_bitflip_noisy_syndrome(psi_noisy, p_meas, rounds);

out.error = err;
out.syndrome_history = history;
out.detector_history = syndrome_detector_history(history);
out.syndrome_hat = s_hat;
out.fidelity = state_fidelity(psi, psi_corr);
out.success = out.fidelity > 1 - 1e-8;
end
