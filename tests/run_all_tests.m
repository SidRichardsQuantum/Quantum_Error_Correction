% Octave-compatible test runner for the repository.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

tol = 1e-10;

% 3-qubit bit-flip code: basis states and arbitrary logical state.
psi = encode_bitflip([1; 0]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi, s);
assert(decode_majority(psi2) == 0);

psi = encode_bitflip([0; 1]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi, s);
assert(decode_majority(psi2) == 1);

alpha_beta = normalize_state([1; 1i]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [1 0 0]);
[psi2, s] = recover_bitflip(psi_noisy);
assert(isequal(s, [1 0]));
assert(state_fidelity(psi, psi2) > 1 - tol);

% 3-qubit phase-flip code: every single Z error.
alpha_beta = normalize_state([sqrt(0.3); exp(1i*pi/5)*sqrt(0.7)]);
psi = encode_phaseflip(alpha_beta);
for q = 1:3
    e = zeros(1,3);
    e(q) = 1;
    psi_noisy = apply_phase_error_pattern(psi, e);
    psi_corr = recover_phaseflip(psi_noisy);
    assert(state_fidelity(psi, psi_corr) > 1 - tol);
end

% 9-qubit Shor code: every single-qubit Pauli error.
alpha_beta = normalize_state([sqrt(0.4); exp(1i*pi/7)*sqrt(0.6)]);
psi = encode_shor(alpha_beta);
for q = 1:9
    for label = 'XYZ'
        err = repmat('I', 1, 9);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_shor(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end

% 7-qubit Steane code: every single-qubit Pauli error.
alpha_beta = normalize_state([sqrt(0.2); exp(1i*pi/9)*sqrt(0.8)]);
psi = encode_steane(alpha_beta);
for q = 1:7
    for label = 'XYZ'
        err = repmat('I', 1, 7);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_steane(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end

% 5-qubit perfect code: every single-qubit Pauli error.
alpha_beta = normalize_state([sqrt(0.45); exp(1i*pi/11)*sqrt(0.55)]);
psi = encode_fivequbit(alpha_beta);
for q = 1:5
    for label = 'XYZ'
        err = repmat('I', 1, 5);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_fivequbit(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - tol);
    end
end

% 1D repetition minimum-weight decoder.
assert(isequal(decode_repetition_min_weight([1 1 0 0]), [0 1 0 0 0]));
assert(isequal(decode_repetition_min_weight([0 0 1 1]), [0 0 0 1 0]));
assert(isequal(decode_repetition_min_weight([1 0 0 0]), [1 0 0 0 0]));

% Depolarizing simulator should be exact at p=0.
out = simulate_depolarizing_once('steane', 0);
assert(out.success);

% Repeated noisy syndrome extraction should recover a noiseless single error.
alpha_beta = normalize_state([sqrt(0.41); exp(1i*pi/8)*sqrt(0.59)]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [0 1 0]);
[psi_corr, s_hat] = recover_bitflip_noisy_syndrome(psi_noisy, 0, 3);
assert(isequal(s_hat, [1 1]));
assert(state_fidelity(psi, psi_corr) > 1 - tol);

% Small surface-code prototype should correct any single X error.
for q = 1:9
    e = zeros(1,9);
    e(q) = 1;
    s = surface3_x_syndrome(e);
    ehat = decode_surface3_x_matching(s);
    assert(isequal(surface3_x_syndrome(xor(e, ehat)), [0 0 0 0]));
end

disp('All QEC tests passed.');
