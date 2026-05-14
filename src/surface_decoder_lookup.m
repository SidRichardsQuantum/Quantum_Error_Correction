% Cached bounded minimum-weight lookup for generic surface-layout syndromes.
%
% For small distances this helper can build an exhaustive syndrome table. For
% larger layouts, max_weight limits the data-error combinations considered.

function ehat = surface_decoder_lookup(s, d, kind, max_weight)
if nargin < 3
    kind = 'z';
end
if nargin < 4
    max_weight = inf;
end

s = s(:).';
n = d * d;

if isinf(max_weight) || max_weight >= n
    table = lookup_table(d, kind, n);
else
    table = lookup_table(d, kind, max_weight);
end

matches = find(all(table.syndromes == repmat(s, size(table.syndromes, 1), 1), 2), 1);
if ~isempty(matches)
    ehat = table.candidates(matches, :);
else
    ehat = zeros(1, n);
end
end

function table = lookup_table(d, kind, max_weight)
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
H = surface_lookup_check_matrix(d, kind);
syndromes = mod(candidates(1, :) * H.', 2);
weights = 0;

if max_weight >= n
    for mask = 1:(2^n - 1)
        candidate = zeros(1, n);
        for q = 1:n
            candidate(q) = bitget(mask, n - q + 1);
        end
        [candidates, syndromes, weights] = add_candidate( ...
            candidates, syndromes, weights, candidate, H);
    end
else
    for w = 1:max_weight
        combos = nchoosek(1:n, w);
        for row = 1:size(combos, 1)
            candidate = zeros(1, n);
            candidate(combos(row, :)) = 1;
            [candidates, syndromes, weights] = add_candidate( ...
                candidates, syndromes, weights, candidate, H);
        end
    end
end

table.candidates = candidates;
table.syndromes = syndromes;
table.weights = weights;
cache(end + 1, :) = {cache_key, table};
end

function [candidates, syndromes, weights] = add_candidate(candidates, syndromes, weights, candidate, H)
syndrome = mod(candidate * H.', 2);
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

function H = surface_lookup_check_matrix(d, kind)
checks = surface_checks(d, kind);
n = d * d;
H = zeros(numel(checks), n);
for row = 1:numel(checks)
    H(row, checks{row}) = 1;
end
end
