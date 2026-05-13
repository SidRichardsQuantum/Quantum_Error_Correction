% Octave-compatible test runner for the repository.

thisdir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisdir, '..', 'src')));

files = dir(fullfile(thisdir, 'test_*.m'));
names = sort({files.name});

for k = 1:numel(names)
    fprintf('Running %s...\n', names{k});
    run(fullfile(thisdir, names{k}));
end

fprintf('All %d QEC test files passed.\n', numel(names));
