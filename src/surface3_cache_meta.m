% Metadata stored with cached surface-3 Monte Carlo results.

function meta = surface3_cache_meta(experiment, seed, N)
meta.experiment = experiment;
meta.cache_version = surface3_cache_version();
meta.seed = seed;
meta.trials = N;
meta.generated_at = datestr(now, 30);
meta.octave_version = version();
meta.cache_hit = false;
end
