% Cached repeated noisy-syndrome surface-3 sweep.

function [rounds, fail_x, fail_z, meta] = surface3_cached_noisy_syndrome_sweep(p_data, p_meas, rounds, N, seed, force)
if nargin < 1 || isempty(p_data), p_data = 0.08;
end
if nargin < 2 || isempty(p_meas), p_meas = 0.08;
end
if nargin < 3 || isempty(rounds), rounds = [1 3 5 7];
end
if nargin < 4 || isempty(N), N = 1000;
end
if nargin < 5 || isempty(seed), seed = 6;
end
if nargin < 6 || isempty(force), force = false;
end

cache_path = fullfile(surface3_cache_dir(), sprintf('surface3_noisy_r%d_%d_pd%03d_pm%03d_n%d_seed%d_v1.mat', rounds(1), rounds(end), round(1000*p_data), round(1000*p_meas), N, seed));
meta = surface3_cache_meta('surface3_noisy_syndrome', seed, N);
meta.p_data = p_data;
meta.p_meas = p_meas;

if ~force && exist(cache_path, 'file')
    data = load(cache_path);
    if isfield(data, 'meta') && strcmp(data.meta.cache_version, meta.cache_version) && isequal(data.rounds, rounds)
        fail_x = data.fail_x;
        fail_z = data.fail_z;
        meta = data.meta;
        meta.cache_hit = true;
        return;
    end
end

rng(seed);
[rounds, fail_x, fail_z] = sweep_surface3_noisy_syndrome(p_data, p_meas, rounds, N);
meta.cache_hit = false;
save(cache_path, 'rounds', 'fail_x', 'fail_z', 'meta');
end
