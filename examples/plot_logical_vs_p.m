thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir); end

rng(1); addpath(genpath('src'));
ps = linspace(0,0.4,21);
N  = 5e3;    % increase for smoother curves
[ps, fail0] = sweep_logical_error(ps, N, 0);
[~,  fail1] = sweep_logical_error(ps, N, 1);
figure; plot(ps, fail0,'o-', ps, fail1,'s-');
grid on; xlabel('bit-flip probability p'); ylabel('logical fail probability');
legend('|0_L>','|1_L>','Location','northwest');
title('3-qubit bit-flip code: logical error vs p');
print(fullfile(outdir,'plot_loglogical_vs_p.png'),'-dpng')
