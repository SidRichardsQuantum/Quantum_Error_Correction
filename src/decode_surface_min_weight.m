% Decode a generic surface-layout syndrome with a small-code-capacity decoder.
%
% For d <= 3 this uses exhaustive minimum-weight lookup. For d = 5 it builds
% a cached bounded minimum-weight lookup through weight 2 data-qubit errors.
% Larger distances use a single-error table, then unresolved syndromes fall
% back to a local peeling heuristic
% that repeatedly chooses the qubit that most reduces syndrome weight. This is
% a stronger benchmark decoder than the original single-error branch, but it is
% still an educational code-capacity decoder rather than a threshold-quality
% MWPM implementation.

function ehat = decode_surface_min_weight(s, d, kind)
if nargin < 3
    kind = 'z';
end

s = s(:).';
layout = surface_layout(d);

if d <= 3
    ehat = exhaustive_lookup(s, d, kind);
    return;
end

if d <= 5
    lookup_weight = min(floor((d - 1) / 2), 2);
else
    lookup_weight = 1;
end
ehat = bounded_lookup(s, d, kind, lookup_weight);
if any(ehat)
    return;
end

ehat = decode_surface_union_find(s, d, kind);
if ~isequal(surface_syndrome(ehat, d, kind), s)
    ehat = greedy_polish(ehat, s, d, kind, layout.n);
end
end

function ehat = exhaustive_lookup(s, d, kind)
table = exhaustive_lookup_table(d, kind);
matches = find(all(table.syndromes == repmat(s, size(table.syndromes, 1), 1), 2), 1);
if ~isempty(matches)
    ehat = table.candidates(matches, :);
    return;
end
n = d * d;
ehat = zeros(1, n);
end

function table = exhaustive_lookup_table(d, kind)
persistent cache;
if isempty(cache)
    cache = {};
end

cache_key = sprintf('exhaustive:%d:%s', d, lower(kind));
for k = 1:size(cache, 1)
    if strcmp(cache{k, 1}, cache_key)
        table = cache{k, 2};
        return;
    end
end

n = d * d;
best_w = inf;
candidates = zeros(0, n);
syndromes = zeros(0, numel(surface_checks(d, kind)));
weights = [];
for mask = 0:(2^n - 1)
    candidate = zeros(1, n);
    for q = 1:n
        candidate(q) = bitget(mask, n - q + 1);
    end
    syndrome = surface_syndrome(candidate, d, kind);
    w = sum(candidate);
    match = find(all(syndromes == repmat(syndrome, size(syndromes, 1), 1), 2), 1);
    if isempty(match)
        candidates(end + 1, :) = candidate;
        syndromes(end + 1, :) = syndrome;
        weights(end + 1) = w;
    elseif w < weights(match)
        candidates(match, :) = candidate;
        weights(match) = w;
    end
end
table.candidates = candidates;
table.syndromes = syndromes;
table.weights = weights;
cache(end + 1, :) = {cache_key, table};
end

function ehat = bounded_lookup(s, d, kind, max_weight)
n = d * d;
table = bounded_lookup_table(d, kind, max_weight);
matches = find(all(table.syndromes == repmat(s, size(table.syndromes, 1), 1), 2), 1);
if ~isempty(matches)
    ehat = table.candidates(matches, :);
    return;
end
ehat = zeros(1, n);
end

function table = bounded_lookup_table(d, kind, max_weight)
persistent cache;
if isempty(cache)
    cache = {};
end

cache_key = sprintf('%d:%s:%d', d, lower(kind), max_weight);
for k = 1:size(cache, 1)
    if strcmp(cache{k, 1}, cache_key)
        table = cache{k, 2};
        return;
    end
end

n = d * d;
candidates = zeros(1, n);
syndromes = surface_syndrome(candidates(1, :), d, kind);
weights = 0;

for w = 1:max_weight
    combos = nchoosek(1:n, w);
    for row = 1:size(combos, 1)
        candidate = zeros(1, n);
        candidate(combos(row, :)) = 1;
        syndrome = surface_syndrome(candidate, d, kind);
        match = find(all(syndromes == repmat(syndrome, size(syndromes, 1), 1), 2), 1);
        if isempty(match)
            candidates(end + 1, :) = candidate;
            syndromes(end + 1, :) = syndrome;
            weights(end + 1) = w;
        elseif w < weights(match)
            candidates(match, :) = candidate;
            weights(match) = w;
        end
    end
end

table.candidates = candidates;
table.syndromes = syndromes;
table.weights = weights;
cache(end + 1, :) = {cache_key, table};
end

function ehat = greedy_polish(ehat, target, d, kind, n)
H = local_surface_check_matrix(d, kind, n);
current = mod(ehat * H.', 2);
for pass = 1:(2 * n)
    residual = xor(current, target);
    if ~any(residual)
        return;
    end

    best_q = 0;
    best_score = sum(residual);
    for q = 1:n
        trial_current = xor(current, H(:, q).');
        score = sum(xor(trial_current, target));
        if score < best_score
            best_score = score;
            best_q = q;
        end
    end

    if best_q == 0
        return;
    end
    ehat(best_q) = ~ehat(best_q);
    current = xor(current, H(:, best_q).');
end
end

function H = local_surface_check_matrix(d, kind, n)
checks = surface_checks(d, kind);
H = zeros(numel(checks), n);
for row = 1:numel(checks)
    H(row, checks{row}) = 1;
end
end
