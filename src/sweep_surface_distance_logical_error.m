% Compare generic surface-layout logical failure estimates across distances.

function results = sweep_surface_distance_logical_error(distances, ps, trials, seed, decoder)
if nargin < 4
    seed = 1;
end
if nargin < 5
    decoder = 'min_weight';
end
rand('seed', seed);

results.distances = distances;
results.ps = ps;
results.trials = trials;
results.seed = seed;
results.decoder = decoder;
results.logical_error = zeros(numel(distances), numel(ps));

for a = 1:numel(distances)
    d = distances(a);
    for b = 1:numel(ps)
        failures = 0;
        for t = 1:trials
            out = simulate_surface_pauli_once(d, ps(b), decoder);
            failures = failures + (~out.success);
        end
        results.logical_error(a, b) = failures / trials;
    end
end
end
