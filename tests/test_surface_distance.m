% Generic odd-distance surface-layout tests.

for d = [3 5]
    layout = surface_layout(d);
    assert(layout.n == d * d);
    assert(isequal(layout.data, reshape(1:(d*d), d, d).'));
    assert(numel(surface_checks(d, 'z')) == (d - 1)^2);
    assert(numel(surface_checks(d, 'x')) == (d - 1)^2);

    for q = 1:(d * d)
        e = zeros(1, d * d);
        e(q) = 1;
        s = surface_syndrome(e, d, 'z');
        ehat = decode_surface_min_weight(s, d, 'z');
        residual = xor(e, ehat);
        assert(isequal(surface_syndrome(residual, d, 'z'), zeros(1, (d - 1)^2)));
        assert(~surface_logical_failure(residual, d));
    end
end

out = simulate_surface_pauli_once(3, 0);
assert(out.success);
assert(isequal(out.error, repmat('I', 1, 9)));

rand('seed', 23);
results = sweep_surface_distance_logical_error([3 5], [0 0.05], 5, 23);
assert(isequal(size(results.logical_error), [2 2]));
assert(isequal(results.logical_error(:,1), [0; 0]));
