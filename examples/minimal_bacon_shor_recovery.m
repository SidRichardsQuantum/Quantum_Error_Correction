% Minimal 3x3 Bacon-Shor Pauli-frame recovery example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

error_string = 'IIIIYIIII';
out = recover_bacon_shor_pauli(error_string);

fprintf('3x3 Bacon-Shor Pauli-frame recovery\n');
fprintf('Injected Pauli error: %s\n', error_string);
fprintf('X syndrome from Z-column checks: [%s]\n', sprintf('%d ', out.x_syndrome));
fprintf('Z syndrome from X-row checks:    [%s]\n', sprintf('%d ', out.z_syndrome));
fprintf('X correction: [%s]\n', sprintf('%d ', out.x_correction));
fprintf('Z correction: [%s]\n', sprintf('%d ', out.z_correction));
fprintf('Logical success: %d\n', out.success);
