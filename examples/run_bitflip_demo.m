% Simulate 3-qubit bit-flip code over range of p and plot fail rate.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
addpath(genpath(fullfile(thisdir,'..','src')));

% Monte Carlo experiment sweep over p
ps = linspace(0,0.4,21);
N = 500;
[ps, fail] = sweep_logical_error(ps, N, 0);

figure;
plot(ps, fail, 'o-');
xlabel('bit-flip p');
ylabel('logical fail probability');
title(sprintf('3-qubit bit-flip Monte Carlo logical error, N=%d trials per p', N));
grid on;
print(fullfile(outdir,'bitflip_monte_carlo_demo.png'),'-dpng');
