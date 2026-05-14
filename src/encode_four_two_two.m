% Encode two logical qubits into the [[4,2,2]] error-detecting code.
%
% alpha_beta is a four-component vector ordered as |00>, |01>, |10>, |11>.

function psi_enc = encode_four_two_two(alpha_beta)
if numel(alpha_beta) ~= 4
    error('encode_four_two_two:bad_input', ...
          'Input must contain four amplitudes for two logical qubits.');
end

amps = normalize_state(alpha_beta(:));
pairs = [0 15; 3 12; 5 10; 6 9];
psi_enc = zeros(16, 1);
for k = 1:4
    psi_enc(pairs(k, 1) + 1) = psi_enc(pairs(k, 1) + 1) + amps(k) / sqrt(2);
    psi_enc(pairs(k, 2) + 1) = psi_enc(pairs(k, 2) + 1) + amps(k) / sqrt(2);
end
psi_enc = normalize_state(psi_enc);
end
