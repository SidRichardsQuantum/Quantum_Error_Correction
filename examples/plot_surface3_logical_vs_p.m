% Plot logical failure for the small distance-3 surface-code prototype.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
rng(4);
addpath(genpath(fullfile(thisdir,'..','src')));

ps = linspace(0, 0.2, 11);
N = 2000;
[ps, fail] = sweep_surface3_x_logical_error(ps, N);

figure;
plot(ps, fail, 'o-');
grid on;
xlabel('X error probability per data qubit');
ylabel('logical failure probability');
title(sprintf('Surface-3 prototype logical error vs X error, N=%d trials per point', N));
print(fullfile(outdir,'surface3_logical_error_vs_x_error.png'),'-dpng');
