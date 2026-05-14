% Compact 3x3 Bacon-Shor subsystem-code tests.

layout = bacon_shor_layout();
assert(isequal(layout, [1 2 3; 4 5 6; 7 8 9]));

assert(isequal(bacon_shor_stabilizers(), ...
    {'ZZIZZIZZI', 'IZZIZZIZZ', 'XXXXXXIII', 'IIIXXXXXX'}));

for q = 1:9
    labels = repmat('I', 1, 9);

    labels(q) = 'X';
    out = recover_bacon_shor_pauli(labels);
    assert(out.success);
    assert(isequal(bacon_shor_x_syndrome(out.x_residual), [0 0]));

    labels(q) = 'Z';
    out = recover_bacon_shor_pauli(labels);
    assert(out.success);
    assert(isequal(bacon_shor_z_syndrome(out.z_residual), [0 0]));

    labels(q) = 'Y';
    out = recover_bacon_shor_pauli(labels);
    assert(out.success);
    assert(isequal(bacon_shor_x_syndrome(out.x_residual), [0 0]));
    assert(isequal(bacon_shor_z_syndrome(out.z_residual), [0 0]));
end

assert(isequal(decode_bacon_shor_x([1 0]), [1 0 0 0 0 0 0 0 0]));
assert(isequal(decode_bacon_shor_x([1 1]), [0 1 0 0 0 0 0 0 0]));
assert(isequal(decode_bacon_shor_x([0 1]), [0 0 1 0 0 0 0 0 0]));
assert(isequal(decode_bacon_shor_x([0 0]), zeros(1, 9)));

assert(isequal(decode_bacon_shor_z([1 0]), [1 0 0 0 0 0 0 0 0]));
assert(isequal(decode_bacon_shor_z([1 1]), [0 0 0 1 0 0 0 0 0]));
assert(isequal(decode_bacon_shor_z([0 1]), [0 0 0 0 0 0 1 0 0]));
assert(isequal(decode_bacon_shor_z([0 0]), zeros(1, 9)));

assert(~bacon_shor_logical_failure([1 0 0 1 0 0 0 0 0], zeros(1, 9)));
assert(bacon_shor_logical_failure([1 0 0 1 0 0 1 0 0], zeros(1, 9)));
assert(~bacon_shor_logical_failure(zeros(1, 9), [1 1 0 0 0 0 0 0 0]));
assert(bacon_shor_logical_failure(zeros(1, 9), [1 1 1 0 0 0 0 0 0]));

rand('seed', 17);
out = simulate_bacon_shor_pauli_once(0);
assert(out.success);
assert(isequal(out.error, repmat('I', 1, 9)));
