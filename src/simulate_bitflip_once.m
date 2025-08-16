function out = simulate_bitflip_once(p, alpha_beta, logical_bit)
% logical_bit in {0,1}; alpha_beta optional (default basis state)
if nargin < 2 || isempty(alpha_beta)
    if logical_bit==0
    alpha_beta = [1;0];
else
    alpha_beta = [0;1];
end
end
psi_enc = encode_bitflip(alpha_beta);

% sample physical error, compute syndrome, correct, decode
e_true = sample_error_pattern(p);
psi_noisy = apply_error_pattern(psi_enc, e_true);
s = syndrome_bitflip(psi_noisy);
psi_corr = correct_bitflip(psi_noisy, s);
bhat = decode_majority(psi_corr);

% inferred error label
ehat = infer_from_syndrome_bitflip(s);

out.decoded_bit = bhat;
out.true_bit    = logical_bit;
out.success     = (bhat == logical_bit);
out.syndrome    = s;
out.e_true      = e_true;
out.e_hat       = ehat;
end
