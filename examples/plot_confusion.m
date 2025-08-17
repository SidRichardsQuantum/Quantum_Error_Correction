% Plot confusion matrix (true vs inferred errors) as heatmap.
% Saves PNG in docs/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir); end

rng(1);
thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));
p = 0.12; N = 3e4;
C = confusion_bitflip(N, p, 0);
figure; imagesc(C); axis image; colorbar;
set(gca,'XTick',1:4,'XTickLabel',{'I','X1','X2','X3'});
set(gca,'YTick',1:5,'YTickLabel',{'I','X1','X2','X3','multi'});
xlabel('inferred'); ylabel('true');
title(sprintf('Confusion matrix at p=%.2f, N=%d', p, N));
thisdir = fileparts(mfilename('fullpath')); outdir = fullfile(thisdir,'..','docs');
if ~exist(outdir,'dir'), mkdir(outdir); end
print(fullfile(outdir,'plot_confusion.png'),'-dpng');
