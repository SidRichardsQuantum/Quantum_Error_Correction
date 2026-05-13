% Plot logical failure probability vs bit-flip probability p.
% Saves PNG in images/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end

rng(1);
addpath(genpath(fullfile(thisdir,'..','src')));
ps = linspace(0,0.4,21);
N  = 500;  % increase for smoother curves
[ps, fail0] = sweep_logical_error(ps, N, 0);
[~,  fail1] = sweep_logical_error(ps, N, 1);

figure;
plot(ps, fail0,'o-', ps, fail1,'s-');
grid on;
xlabel('bit-flip probability p');
ylabel('logical fail probability');
legend('|0_L>','|1_L>','Location','northwest');
title('3-qubit bit-flip logical error vs physical error');
print(fullfile(outdir,'bitflip_logical_error_vs_physical_error.png'),'-dpng')
