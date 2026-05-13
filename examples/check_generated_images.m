% Check that selected plotting examples create their expected image files.

thisdir = fileparts(mfilename('fullpath'));
rootdir = fullfile(thisdir, '..');
outdir = fullfile(rootdir, 'images');
addpath(genpath(fullfile(rootdir, 'src')));
addpath(thisdir);

expected = {fullfile(outdir, 'surface3_channel_logical_error_comparison.png'), ...
            fullfile(outdir, 'surface3_noisy_syndrome_rounds.png')};
for k = 1:numel(expected)
    if exist(expected{k}, 'file')
        delete(expected{k});
    end
end

N = 50;
seed = 5;
plot_surface3_channel_comparison;
close all;
clear N seed;

N = 50;
seed = 6;
plot_surface3_noisy_syndrome_rounds;
close all;

for k = 1:numel(expected)
    if ~exist(expected{k}, 'file')
        error('check_generated_images:missing_file', 'Expected image was not generated: %s', expected{k});
    end

    info = dir(expected{k});
    if isempty(info) || info.bytes == 0
        error('check_generated_images:empty_file', 'Generated image is empty: %s', expected{k});
    end

    fprintf('Generated image exists: %s (%d bytes)\n', expected{k}, info.bytes);
end
