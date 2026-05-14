% Compare generic surface-layout logical failure estimates across distances.

function results = sweep_surface_distance_logical_error(distances, ps, trials, seed)
if nargin < 4
    seed = 1;
end
rand('seed', seed);

results.distances = distances;
results.ps = ps;
results.logical_error = zeros(numel(distances), numel(ps));

for a = 1:numel(distances)
    d = distances(a);
    for b = 1:numel(ps)
        failures = 0;
        for t = 1:trials
            out = simulate_surface_pauli_once(d, ps(b));
            failures = failures + (~out.success);
        end
        results.logical_error(a, b) = failures / trials;
    end
end
end
