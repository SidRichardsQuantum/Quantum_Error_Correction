% Decoder and simulator smoke tests.

tol = 1e-10;

assert(isequal(decode_repetition_min_weight([1 1 0 0]), [0 1 0 0 0]));
assert(isequal(decode_repetition_min_weight([0 0 1 1]), [0 0 0 1 0]));
assert(isequal(decode_repetition_min_weight([1 0 0 0]), [1 0 0 0 0]));

out = simulate_depolarizing_once('steane', 0);
assert(out.success);

alpha_beta = normalize_state([sqrt(0.41); exp(1i*pi/8)*sqrt(0.59)]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [0 1 0]);
[psi_corr, s_hat] = recover_bitflip_noisy_syndrome(psi_noisy, 0, 3);
assert(isequal(s_hat, [1 1]));
assert(state_fidelity(psi, psi_corr) > 1 - tol);

out = simulate_noisy_syndrome_bitflip_once(0, 0, 3, alpha_beta);
assert(isequal(out.detector_history, syndrome_detector_history(out.syndrome_history)));
