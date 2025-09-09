% Simulate 3-qubit bit-flip code over range of p and plot fail rate.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir);
end

% Simple experiment sweep over p
alpha_beta = [1;0];  % logical |0>
psi_enc = encode_bitflip(alpha_beta);
ps = linspace(0,0.4,21);
fail = zeros(size(ps));
for i = 1:numel(ps)
    psi_n = apply_bitflip_noise(psi_enc, ps(i));
    s = syndrome_bitflip(psi_n);
    psi_c = correct_bitflip(psi_n, s);
    decoded = decode_majority(psi_c);
    fail(i) = decoded ~= 0;
end

figure;
plot(ps, fail, 'o-');
xlabel('bit-flip p');
ylabel('fail prob');
