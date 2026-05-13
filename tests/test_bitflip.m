% 3-qubit bit-flip code tests.

tol = 1e-10;

psi = encode_bitflip([1; 0]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi, s);
assert(decode_majority(psi2) == 0);

psi = encode_bitflip([0; 1]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi, s);
assert(decode_majority(psi2) == 1);

psi = encode_bitflip([1; 0]);
psi_noisy = apply_error_pattern(psi, [0 1 0]);
s = syndrome_bitflip(psi_noisy);
psi2 = correct_bitflip(psi_noisy, s);
assert(isequal(s, [1 1]));
assert(decode_majority(psi2) == 0);

alpha_beta = normalize_state([1; 1i]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [1 0 0]);
[psi2, s] = recover_bitflip(psi_noisy);
assert(isequal(s, [1 0]));
assert(state_fidelity(psi, psi2) > 1 - tol);
