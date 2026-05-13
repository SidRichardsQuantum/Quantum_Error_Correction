% Plot histogram of measured syndromes at fixed p.
% Saves PNG in images/.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end

rng(1);
addpath(genpath(fullfile(thisdir,'..','src')));
p = 0.12;
N = 2000;
counts = collect_syndromes(N, p, 0);

figure;
bar(counts);
set(gca,'XTick',1:4,'XTickLabel',{'|00>','|01>','|10>','|11>'});
xlabel('syndrome [s12 s23]');
ylabel('count');
grid on;
title(sprintf('Bit-flip syndrome distribution, p=%.2f, N=%d', p, N));
print(fullfile(outdir,'bitflip_syndrome_distribution.png'),'-dpng')
