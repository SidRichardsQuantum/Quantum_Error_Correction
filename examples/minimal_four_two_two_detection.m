% Minimal [[4,2,2]] error-detection example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

logical_state = normalize_state([sqrt(0.1); sqrt(0.2); sqrt(0.3); sqrt(0.4)]);
psi = encode_four_two_two(logical_state);

err = 'IXII';
psi_noisy = apply_pauli_error(psi, err);
[detected, syn] = detect_four_two_two(psi_noisy);

logical_op = 'XXII';
[logical_detected, logical_syn] = detect_four_two_two(apply_pauli_error(psi, logical_op));

fprintf('[[4,2,2]] error-detecting code\n');
fprintf('Stabilizers: XXXX, ZZZZ\n');
fprintf('Injected Pauli error: %s\n', err);
fprintf('Measured syndrome: [%d %d]\n', syn);
fprintf('Detected error: %d\n', detected);
fprintf('Logical operator example: %s\n', logical_op);
fprintf('Logical-operator syndrome: [%d %d]\n', logical_syn);
fprintf('Logical operator detected as error: %d\n', logical_detected);
