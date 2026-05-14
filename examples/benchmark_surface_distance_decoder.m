% Print a compact benchmark table for the generic surface-layout decoder.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir, '..', 'src')));

if ~exist('distances', 'var'), distances = [3 5 7]; end
if ~exist('ps', 'var'), ps = [0 0.03 0.06 0.09]; end
if ~exist('N', 'var'), N = 8; end
if ~exist('seed', 'var'), seed = 11; end

results = sweep_surface_distance_logical_error(distances, ps, N, seed);

fprintf('Generic surface-layout decoder benchmark, N=%d trials per point\n', N);
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
