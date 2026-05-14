% Print a compact benchmark table for the generic surface-layout decoder.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir, '..', 'src')));

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

fprintf('Generic surface-layout decoder benchmark, N=%d trials per point\n', N);
fprintf('seed=%d, ps=[%s], distances=[%s]\n', seed, num2str(ps), num2str(distances));

for decoder_idx = 1:numel(decoders)
    decoder = strtrim(decoders{decoder_idx});
    results = sweep_surface_distance_logical_error(distances, ps, N, seed, decoder);

    fprintf('\nDecoder: %s\n', decoder);
    fprintf('p');
    for a = 1:numel(distances)
        fprintf('\td=%d', distances(a));
    end
    fprintf('\n');

    for b = 1:numel(ps)
        fprintf('%.3f', ps(b));
        for a = 1:numel(distances)
            fprintf('\t%.3f', results.logical_error(a, b));
        end
        fprintf('\n');
    end
end
