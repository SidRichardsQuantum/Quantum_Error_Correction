% Small surface-code prototype tests.

for q = 1:9
    e = zeros(1,9);
    e(q) = 1;
    s = surface3_x_syndrome(e);
    ehat = decode_surface3_x_matching(s);
    assert(isequal(surface3_x_syndrome(xor(e, ehat)), [0 0 0 0]));
    assert(~surface3_logical_failure(xor(e, ehat)));
end

for q = 1:9
    e = zeros(1,9);
    e(q) = 1;
    s = surface3_z_syndrome(e);
    ehat = decode_surface3_z_matching(s);
    assert(isequal(surface3_z_syndrome(xor(e, ehat)), [0 0 0 0]));
    assert(~surface3_logical_failure(xor(e, ehat)));
end

for q = 1:9
    labels = repmat('I', 1, 9);

    labels(q) = 'X';
    x_error = (labels == 'X') | (labels == 'Y');
    z_error = (labels == 'Z') | (labels == 'Y');
    assert(~surface3_logical_failure(xor(x_error, decode_surface3_x_matching(surface3_x_syndrome(x_error)))));
    assert(~surface3_logical_failure(xor(z_error, decode_surface3_z_matching(surface3_z_syndrome(z_error)))));

    labels(q) = 'Y';
    x_error = (labels == 'X') | (labels == 'Y');
    z_error = (labels == 'Z') | (labels == 'Y');
    assert(~surface3_logical_failure(xor(x_error, decode_surface3_x_matching(surface3_x_syndrome(x_error)))));
    assert(~surface3_logical_failure(xor(z_error, decode_surface3_z_matching(surface3_z_syndrome(z_error)))));

    labels(q) = 'Z';
    x_error = (labels == 'X') | (labels == 'Y');
    z_error = (labels == 'Z') | (labels == 'Y');
    assert(~surface3_logical_failure(xor(x_error, decode_surface3_x_matching(surface3_x_syndrome(x_error)))));
    assert(~surface3_logical_failure(xor(z_error, decode_surface3_z_matching(surface3_z_syndrome(z_error)))));
end

out = simulate_surface3_pauli_once(0);
assert(out.success);
assert(isequal(out.error, repmat('I', 1, 9)));

history = [1 0 1 0; 1 1 1 0; 0 0 1 1];
assert(isequal(surface3_majority_syndrome(history), [1 0 1 0]));

assert(isequal(noisy_syndrome_surface3([1 0 1 0], 0), [1 0 1 0]));

for q = 1:9
    e = zeros(1,9);
    e(q) = 1;

    [~, s_hat_x, history_x, residual_x] = recover_surface3_x_noisy_syndrome(e, 0, 3);
    assert(isequal(history_x, repmat(surface3_x_syndrome(e), 3, 1)));
    assert(isequal(s_hat_x, surface3_x_syndrome(e)));
    assert(~surface3_logical_failure(residual_x));

    [~, s_hat_z, history_z, residual_z] = recover_surface3_z_noisy_syndrome(e, 0, 3);
    assert(isequal(history_z, repmat(surface3_z_syndrome(e), 3, 1)));
    assert(isequal(s_hat_z, surface3_z_syndrome(e)));
    assert(~surface3_logical_failure(residual_z));
end
