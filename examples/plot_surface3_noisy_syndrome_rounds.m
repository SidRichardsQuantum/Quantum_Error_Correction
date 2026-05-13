% Plot effect of repeated noisy surface-3 syndrome measurements.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
addpath(genpath(fullfile(thisdir,'..','src')));
warning('off','all');

if ~exist('p_data','var'), p_data = 0.08; end
if ~exist('p_meas','var'), p_meas = 0.08; end
if ~exist('rounds','var'), rounds = [1 3 5 7]; end
if ~exist('N','var'), N = 1000; end
if ~exist('seed','var'), seed = 6; end
if ~exist('force_cache','var'), force_cache = false; end

[rounds, fail_x, fail_z, meta] = surface3_cached_noisy_syndrome_sweep(p_data, p_meas, rounds, N, seed, force_cache);

figure('visible','off');
hold on;
plot(rounds, fail_x, 'o-', 'DisplayName', 'X errors');
plot(rounds, fail_z, 's-', 'DisplayName', 'Z errors');
hold off;
grid on;
xlabel('syndrome measurement rounds');
ylabel('logical failure probability');
title(sprintf('Surface-3 logical error with noisy syndrome rounds, p_data=%.2f, p_meas=%.2f', p_data, p_meas));
legend('Location','northeast');
print(fullfile(outdir,'surface3_noisy_syndrome_rounds.png'),'-dpng');
fprintf('Surface-3 noisy syndrome cache hit: %d\n', meta.cache_hit);
