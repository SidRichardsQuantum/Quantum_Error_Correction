% Plot depolarizing-noise logical failure for several QEC codes.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
rng(2);
addpath(genpath(fullfile(thisdir,'..','src')));

codes = {'bitflip', 'phaseflip', 'fivequbit', 'steane'};
labels = {'bit flip', 'phase flip', '5-qubit', 'Steane'};
ps = linspace(0, 0.2, 6);
N = 200;

figure;
hold on;
for k = 1:numel(codes)
    [~, fail] = sweep_depolarizing_logical_error(codes{k}, ps, N);
    plot(ps, fail, 'o-', 'DisplayName', labels{k});
end
hold off;
grid on;
xlabel('depolarizing probability per qubit');
ylabel('logical failure probability');
title(sprintf('QEC logical error under depolarizing noise, N=%d trials per point', N));
legend('Location','northwest');
print(fullfile(outdir,'qec_depolarizing_logical_error_comparison.png'),'-dpng');
