% Plot effect of repeated noisy syndrome measurements.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
rng(3);
addpath(genpath(fullfile(thisdir,'..','src')));

p_data = 0.08;
p_meas = 0.08;
rounds = [1 3 5 7];
N = 1000;
fail = sweep_noisy_syndrome_bitflip(p_data, p_meas, rounds, N);

figure;
plot(rounds, fail, 'o-');
grid on;
xlabel('syndrome measurement rounds');
ylabel('logical failure probability');
title(sprintf('Bit-flip logical error with noisy syndrome rounds, p_data=%.2f, p_meas=%.2f', p_data, p_meas));
print(fullfile(outdir,'bitflip_noisy_syndrome_rounds.png'),'-dpng');
