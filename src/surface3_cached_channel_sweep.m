% Cached X/Z/Pauli surface-3 logical-failure sweep.

function [ps, fail_x, fail_z, fail_pauli, meta] = surface3_cached_channel_sweep(ps, N, seed, force)
if nargin < 1 || isempty(ps), ps = linspace(0, 0.2, 11);
end
if nargin < 2 || isempty(N), N = 2000;
end
if nargin < 3 || isempty(seed), seed = 5;
end
if nargin < 4 || isempty(force), force = false;
end

cache_path = fullfile(surface3_cache_dir(), sprintf('surface3_channel_m%d_p%03d_%03d_n%d_seed%d_v1.mat', numel(ps), round(1000*ps(1)), round(1000*ps(end)), N, seed));
meta = surface3_cache_meta('surface3_channel', seed, N);

if ~force && exist(cache_path, 'file')
    data = load(cache_path);
    if isfield(data, 'meta') && strcmp(data.meta.cache_version, meta.cache_version) && isequal(data.ps, ps)
        fail_x = data.fail_x;
        fail_z = data.fail_z;
        fail_pauli = data.fail_pauli;
        meta = data.meta;
        meta.cache_hit = true;
        return;
    end
end

rng(seed);
[ps, fail_x] = sweep_surface3_x_logical_error(ps, N);
[~, fail_z] = sweep_surface3_z_logical_error(ps, N);
[~, fail_pauli] = sweep_surface3_pauli_logical_error(ps, N);
meta.cache_hit = false;
save(cache_path, 'ps', 'fail_x', 'fail_z', 'fail_pauli', 'meta');
end
