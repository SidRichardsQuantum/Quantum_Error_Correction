% Plot histogram of measured syndromes at fixed p.
% Saves PNG in images/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end

rng(1);
addpath(genpath(fullfile(thisdir,'..','src')));
p = 0.12;
N = 2e4;
counts = collect_syndromes(N, p, 0);

figure;
bar(counts);
xticklabels({'00','10','11','01'});
xlabel('syndrome [s12 s23]');
ylabel('count');
grid on;
title(sprintf('Syndrome histogram at p=%.2f, N=%d', p, N));
print(fullfile(outdir,'plot_syndrome_hist.png'),'-dpng')
