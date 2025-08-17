% Plot distribution of error weights (0–3 flips).
% Saves PNG in docs/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir); end

rng(1);
thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
p = 0.15; N = 2e5;
w = error_weight_counts(N, p);
figure; bar(0:3, w/sum(w));
grid on; xlabel('error weight'); ylabel('empirical probability');
title(sprintf('Error-weight distribution, p=%.2f', p));
print(fullfile(outdir,'plot_error_weight.png'),'-dpng')
