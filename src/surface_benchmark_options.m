% Read generic surface-layout benchmark defaults, environment, and CLI args.

function opts = surface_benchmark_options(default_distances, default_ps, default_trials, default_seed, default_decoders)
opts.distances = default_distances;
opts.ps = default_ps;
opts.trials = default_trials;
opts.seed = default_seed;
opts.decoders = default_decoders;

opts = apply_env(opts);
opts = apply_args(opts, argv());
end

function opts = apply_env(opts)
env_trials = getenv('QEC_SURFACE_TRIALS');
env_seed = getenv('QEC_SURFACE_SEED');
env_ps = getenv('QEC_SURFACE_PS');
env_distances = getenv('QEC_SURFACE_DISTANCES');
env_decoders = getenv('QEC_SURFACE_DECODERS');

if ~isempty(env_trials), opts.trials = str2num(env_trials); end
if ~isempty(env_seed), opts.seed = str2num(env_seed); end
if ~isempty(env_ps), opts.ps = str2num(env_ps); end
if ~isempty(env_distances), opts.distances = str2num(env_distances); end
if ~isempty(env_decoders), opts.decoders = split_decoders(env_decoders); end
end

function opts = apply_args(opts, args)
for k = 1:numel(args)
    arg = args{k};
    if strncmp(arg, '--trials=', 9)
        opts.trials = str2num(arg(10:end));
    elseif strncmp(arg, '--seed=', 7)
        opts.seed = str2num(arg(8:end));
    elseif strncmp(arg, '--ps=', 5)
        opts.ps = str2num(arg(6:end));
    elseif strncmp(arg, '--distances=', 12)
        opts.distances = str2num(arg(13:end));
    elseif strncmp(arg, '--decoders=', 11)
        opts.decoders = split_decoders(arg(12:end));
    end
end
end

function decoders = split_decoders(raw)
decoders = strsplit(raw, ',');
for k = 1:numel(decoders)
    decoders{k} = strtrim(decoders{k});
end
end
