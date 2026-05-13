% Longer walkthrough of the compact surface-3 prototype.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

fprintf('Surface-3 walkthrough\n\n');

fprintf('Data layout:\n');
fprintf('1 2 3\n');
fprintf('4 5 6\n');
fprintf('7 8 9\n\n');

z_checks = surface3_z_checks();
x_checks = surface3_x_checks();
fprintf('Z-check supports for X errors:\n');
for k = 1:numel(z_checks)
    fprintf('  Z%d: [%s]\n', k, sprintf('%d ', z_checks{k}));
end

fprintf('\nX-check supports for Z errors:\n');
for k = 1:numel(x_checks)
    fprintf('  X%d: [%s]\n', k, sprintf('%d ', x_checks{k}));
end

x_error = [1 0 0 0 0 0 0 0 0];
x_syndrome = surface3_x_syndrome(x_error);
x_correction = decode_surface3_x_matching(x_syndrome);
x_residual = xor(x_error, x_correction);

fprintf('\nSingle X-error decoding:\n');
fprintf('  error:      [%s]\n', sprintf('%d ', x_error));
fprintf('  syndrome:   [%s]\n', sprintf('%d ', x_syndrome));
fprintf('  correction: [%s]\n', sprintf('%d ', x_correction));
fprintf('  residual:   [%s]\n', sprintf('%d ', x_residual));
fprintf('  logical failure: %d\n', surface3_logical_failure(x_residual));

z_error = [0 0 0 0 0 0 0 0 1];
z_syndrome = surface3_z_syndrome(z_error);
z_correction = decode_surface3_z_matching(z_syndrome);
z_residual = xor(z_error, z_correction);

fprintf('\nSingle Z-error decoding:\n');
fprintf('  error:      [%s]\n', sprintf('%d ', z_error));
fprintf('  syndrome:   [%s]\n', sprintf('%d ', z_syndrome));
fprintf('  correction: [%s]\n', sprintf('%d ', z_correction));
fprintf('  residual:   [%s]\n', sprintf('%d ', z_residual));
fprintf('  logical failure: %d\n', surface3_logical_failure(z_residual));

rng(11);
p = 0.08;
out = simulate_surface3_pauli_once(p);
fprintf('\nOne random Pauli-noise trial at p=%.2f:\n', p);
fprintf('  error string: %s\n', out.error);
fprintf('  X syndrome:   [%s]\n', sprintf('%d ', out.x_syndrome));
fprintf('  Z syndrome:   [%s]\n', sprintf('%d ', out.z_syndrome));
fprintf('  X residual:   [%s]\n', sprintf('%d ', out.x_residual));
fprintf('  Z residual:   [%s]\n', sprintf('%d ', out.z_residual));
fprintf('  success: %d\n', out.success);

ps = [0.02 0.08 0.14];
N = 200;
[~, fail_x] = sweep_surface3_x_logical_error(ps, N);
[~, fail_z] = sweep_surface3_z_logical_error(ps, N);
[~, fail_pauli] = sweep_surface3_pauli_logical_error(ps, N);

fprintf('\nSmall logical-failure sweep, N=%d trials per point:\n', N);
fprintf('p       X-only   Z-only   Pauli\n');
for k = 1:numel(ps)
    fprintf('%.2f    %.3f    %.3f    %.3f\n', ps(k), fail_x(k), fail_z(k), fail_pauli(k));
end
