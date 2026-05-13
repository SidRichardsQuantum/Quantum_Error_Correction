% Compare X-only, Z-only, and Pauli-noise logical failure for surface-3.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
addpath(genpath(fullfile(thisdir,'..','src')));
warning('off','all');

if ~exist('ps','var'), ps = linspace(0, 0.2, 11); end
if ~exist('N','var'), N = 2000; end
if ~exist('seed','var'), seed = 5; end
if ~exist('force_cache','var'), force_cache = false; end

[ps, fail_x, fail_z, fail_pauli, meta] = surface3_cached_channel_sweep(ps, N, seed, force_cache);

figure('visible','off');
hold on;
plot(ps, fail_x, 'o-', 'DisplayName', 'X only');
plot(ps, fail_z, 's-', 'DisplayName', 'Z only');
plot(ps, fail_pauli, '^-', 'DisplayName', 'Pauli X/Y/Z');
hold off;
grid on;
xlabel('error probability per data qubit');
ylabel('logical failure probability');
title(sprintf('Surface-3 logical failure by error channel, N=%d trials per point', N));
legend('Location','northwest');
print(fullfile(outdir,'surface3_channel_logical_error_comparison.png'),'-dpng');
fprintf('Surface-3 channel sweep cache hit: %d\n', meta.cache_hit);
