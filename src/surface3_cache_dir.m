% Directory for cached Monte Carlo sweep results.

function cache_dir = surface3_cache_dir()
rootdir = fileparts(fileparts(mfilename('fullpath')));
cache_dir = fullfile(rootdir, 'cache');
if ~exist(cache_dir, 'dir')
    mkdir(cache_dir);
end
end
