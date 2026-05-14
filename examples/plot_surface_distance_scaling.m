% Plot generic surface-layout logical failure estimates across distances.

thisdir = fileparts(mfilename('fullpath'));
outdir = fullfile(thisdir, '..', 'images');
if ~exist(outdir, 'dir'), mkdir(outdir); end
addpath(genpath(fullfile(thisdir, '..', 'src')));
warning('off', 'all');

if ~exist('distances', 'var'), distances = [3 5 7]; end
if ~exist('ps', 'var'), ps = [0 0.03 0.06 0.09]; end
if ~exist('N', 'var'), N = 8; end
if ~exist('seed', 'var'), seed = 11; end
if ~exist('decoders', 'var'), decoders = {'min_weight', 'mwpm', 'graph_matching'}; end

opts = surface_benchmark_options(distances, ps, N, seed, decoders);
distances = opts.distances;
ps = opts.ps;
N = opts.trials;
seed = opts.seed;
decoders = opts.decoders;

figure('visible', 'off');
hold on;
markers = {'o-', 's-', '^-', 'd-', 'x-', '+-'};
series_idx = 0;
for decoder_idx = 1:numel(decoders)
    decoder = strtrim(decoders{decoder_idx});
    results = sweep_surface_distance_logical_error(distances, ps, N, seed, decoder);
    for a = 1:numel(distances)
        series_idx = series_idx + 1;
        style = markers{1 + mod(series_idx - 1, numel(markers))};
        plot(ps, results.logical_error(a, :), style, ...
             'DisplayName', sprintf('%s d=%d', decoder, distances(a)));
    end
end
hold off;
grid on;
xlabel('depolarizing error probability per data qubit');
ylabel('logical failure probability');
title(sprintf('Generic surface-layout decoder scaling, N=%d trials per point', N));
legend('Location', 'northwest');
print(fullfile(outdir, 'surface_distance_logical_error_scaling.png'), '-dpng');
