thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir); end

rng(1); addpath(genpath('src'));
p = 0.12; N = 3e4;
C = confusion_bitflip(N, p, 0);
figure; heatmap(C);
xlabel('inferred'); ylabel('true');
xticklabels({'I','X1','X2','X3'}); yticklabels({'I','X1','X2','X3'});
title(sprintf('Confusion matrix at p=%.2f, N=%d', p, N));
print(fullfile(outdir,'plot_confusion.png'),'-dpng')
