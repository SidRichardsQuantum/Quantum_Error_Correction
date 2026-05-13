% Unit test for encoding/decoding correctness of 3-qubit bit-flip code.

function tests = test_bitflip
thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
tests = functiontests(localfunctions);
end

function testEncodeDecodeNoNoise(~)
psi = encode_bitflip([1; 0]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi,s);
b = decode_majority(psi2);
assert(b == 0);
end

function testEncodeDecodeNoNoiseLogicalOne(~)
psi = encode_bitflip([0; 1]);
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi,s);
b = decode_majority(psi2);
assert(b == 1);
end

function testSingleQubitErrorIsCorrected(~)
psi = encode_bitflip([1; 0]);

% Flip qubit 2, then correct from syndrome.
psi_noisy = apply_error_pattern(psi, [0 1 0]);
s = syndrome_bitflip(psi_noisy);
psi2 = correct_bitflip(psi_noisy, s);
b = decode_majority(psi2);

assert(isequal(s, [1 1]));
assert(b == 0);
end

function testArbitraryLogicalStateIsRecovered(~)
alpha_beta = normalize_state([1; 1i]);
psi = encode_bitflip(alpha_beta);
psi_noisy = apply_error_pattern(psi, [1 0 0]);
[psi2, s] = recover_bitflip(psi_noisy);

assert(isequal(s, [1 0]));
assert(state_fidelity(psi, psi2) > 1 - 1e-10);
end
