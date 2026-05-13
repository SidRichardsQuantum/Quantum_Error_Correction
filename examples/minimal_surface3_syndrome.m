% Minimal surface-3 syndrome and correction example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

x_error = [0 0 0 0 1 0 0 0 0];
x_syndrome = surface3_x_syndrome(x_error);
x_correction = decode_surface3_x_matching(x_syndrome);
x_residual = xor(x_error, x_correction);

z_error = [0 0 0 0 0 0 1 0 0];
z_syndrome = surface3_z_syndrome(z_error);
z_correction = decode_surface3_z_matching(z_syndrome);
z_residual = xor(z_error, z_correction);

fprintf('Surface-3 minimal syndrome example\n');
fprintf('X error:       [%s]\n', sprintf('%d ', x_error));
fprintf('Z-check syn:   [%s]\n', sprintf('%d ', x_syndrome));
fprintf('X correction:  [%s]\n', sprintf('%d ', x_correction));
fprintf('X residual:    [%s]\n', sprintf('%d ', x_residual));
fprintf('X logical fail: %d\n\n', surface3_logical_failure(x_residual));

fprintf('Z error:       [%s]\n', sprintf('%d ', z_error));
fprintf('X-check syn:   [%s]\n', sprintf('%d ', z_syndrome));
fprintf('Z correction:  [%s]\n', sprintf('%d ', z_correction));
fprintf('Z residual:    [%s]\n', sprintf('%d ', z_residual));
fprintf('Z logical fail: %d\n', surface3_logical_failure(z_residual));
