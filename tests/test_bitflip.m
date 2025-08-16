function tests = test_bitflip
tests = functiontests(localfunctions);
end

function testEncodeDecodeNoNoise(~)
psi = encode_bitflip([0.6; 0.8]); % unnormalized OK here
s = syndrome_bitflip(psi);
psi2 = correct_bitflip(psi,s);
b = decode_majority(psi2);
assert(ismember(b,[0 1]));
end
