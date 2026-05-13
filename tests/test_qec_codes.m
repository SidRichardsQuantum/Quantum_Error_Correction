% Unit tests for phase-flip, Shor, and Steane QEC implementations.

function tests = test_qec_codes
thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
tests = functiontests(localfunctions);
end

function testPhaseFlipCorrectsEverySingleZ(~)
alpha_beta = normalize_state([sqrt(0.3); exp(1i*pi/5)*sqrt(0.7)]);
psi = encode_phaseflip(alpha_beta);

for q = 1:3
    e = zeros(1,3);
    e(q) = 1;
    psi_noisy = apply_phase_error_pattern(psi, e);
    psi_corr = recover_phaseflip(psi_noisy);
    assert(state_fidelity(psi, psi_corr) > 1 - 1e-10);
end
end

function testShorCorrectsEverySinglePauli(~)
alpha_beta = normalize_state([sqrt(0.4); exp(1i*pi/7)*sqrt(0.6)]);
psi = encode_shor(alpha_beta);
labels = 'XYZ';

for q = 1:9
    for label = labels
        err = repmat('I', 1, 9);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_shor(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - 1e-10);
    end
end
end

function testSteaneCorrectsEverySinglePauli(~)
alpha_beta = normalize_state([sqrt(0.2); exp(1i*pi/9)*sqrt(0.8)]);
psi = encode_steane(alpha_beta);
labels = 'XYZ';

for q = 1:7
    for label = labels
        err = repmat('I', 1, 7);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_steane(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - 1e-10);
    end
end
end

function testFiveQubitCorrectsEverySinglePauli(~)
alpha_beta = normalize_state([sqrt(0.45); exp(1i*pi/11)*sqrt(0.55)]);
psi = encode_fivequbit(alpha_beta);
labels = 'XYZ';

for q = 1:5
    for label = labels
        err = repmat('I', 1, 5);
        err(q) = label;
        psi_noisy = apply_pauli_error(psi, err);
        psi_corr = recover_fivequbit(psi_noisy);
        assert(state_fidelity(psi, psi_corr) > 1 - 1e-10);
    end
end
end

function testRepetitionMinWeightDecoder(~)
assert(isequal(decode_repetition_min_weight([1 1 0 0]), [0 1 0 0 0]));
assert(isequal(decode_repetition_min_weight([0 0 1 1]), [0 0 0 1 0]));
assert(isequal(decode_repetition_min_weight([1 0 0 0]), [1 0 0 0 0]));
end

function testDepolarizingZeroNoiseSucceeds(~)
out = simulate_depolarizing_once('steane', 0);
assert(out.success);
end

function testNoisySyndromeNoiselessSingleError(~)
alpha_beta = normalize_state([sqrt(0.41); exp(1i*pi/8)*sqrt(0.59)]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [0 1 0]);
[psi_corr, s_hat] = recover_bitflip_noisy_syndrome(psi_noisy, 0, 3);
assert(isequal(s_hat, [1 1]));
assert(state_fidelity(psi, psi_corr) > 1 - 1e-10);
end

function testSurfacePrototypeSingleXErrors(~)
for q = 1:9
    e = zeros(1,9);
    e(q) = 1;
    s = surface3_x_syndrome(e);
    ehat = decode_surface3_x_matching(s);
    assert(isequal(surface3_x_syndrome(xor(e, ehat)), [0 0 0 0]));
end
end
