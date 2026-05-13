% Plot distribution of error weights (0–3 flips).
% Saves PNG in images/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end

rng(1);
thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
p = 0.15;
N = 2e4;
w = error_weight_counts(N, p);

figure;
bar(0:3, w/sum(w));
grid on;
xlabel('error weight');
ylabel('empirical probability');
title(sprintf('Bit-flip error-weight distribution, p=%.2f', p));
print(fullfile(outdir,'bitflip_error_weight_distribution.png'),'-dpng')
