% Minimal variable-length repetition decoder example.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir,'..','src')));

true_error = [0 1 1 0 0];
syndrome = xor(true_error(1:end-1), true_error(2:end));
decoded = decode_repetition_min_weight(syndrome);

fprintf('1D repetition minimum-weight decoder\n');
fprintf('True error chain: [%s]\n', sprintf('%d ', true_error));
fprintf('Syndrome:         [%s]\n', sprintf('%d ', syndrome));
fprintf('Decoded chain:    [%s]\n', sprintf('%d ', decoded));
fprintf('Decoded syndrome: [%s]\n', sprintf('%d ', xor(decoded(1:end-1), decoded(2:end))));
