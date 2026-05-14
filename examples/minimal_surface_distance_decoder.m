% Minimal variable-distance surface-layout decoder example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

d = 5;
error = zeros(1, d * d);
error(13) = 1;

syn = surface_syndrome(error, d, 'z');
corr = decode_surface_min_weight(syn, d, 'z');
residual = xor(error, corr);

fprintf('Generic surface-layout decoder, d=%d\n', d);
fprintf('Injected X-error qubit: 13\n');
fprintf('Syndrome weight: %d\n', sum(syn));
fprintf('Correction weight: %d\n', sum(corr));
fprintf('Residual syndrome weight: %d\n', sum(surface_syndrome(residual, d, 'z')));
fprintf('Logical success: %d\n', ~surface_logical_failure(residual, d));
