% Decode a generic surface-layout syndrome with an MWPM-style decoder.
%
% Active syndrome defects are matched either to another defect or to a
% virtual boundary. Edge weights come from bounded minimum-weight correction
% fragments for the requested endpoint syndrome. The final matching is solved
% exactly by dynamic programming over the active defects, which is practical
% for the small d=3/5/7 educational benchmarks used by this package.
%
% This is an Octave-only teaching decoder. It is MWPM-style, but it is not a
% Blossom implementation and should not be presented as a threshold-quality
% surface-code decoder.

function ehat = decode_surface_mwpm(s, d, kind, max_fragment_weight)
if nargin < 3
    kind = 'z';
end
if nargin < 4
    max_fragment_weight = default_fragment_weight(d);
end

s = mod(s(:).', 2);
layout = surface_layout(d);
n = layout.n;
m = numel(s);
defects = find(s);

if isempty(defects)
    ehat = zeros(1, n);
    return;
end

ehat = surface_decoder_lookup(s, d, kind, max_fragment_weight);
if isequal(surface_syndrome(ehat, d, kind), s)
    return;
end

% The DP is exact in the number of defects, so keep pathological dense
% syndromes on the existing robust teaching path.
if numel(defects) > 18
    ehat = decode_surface_min_weight(s, d, kind);
    return;
end

[single_fragments, single_costs] = endpoint_fragments(defects, [], m, d, kind, max_fragment_weight);
[pair_fragments, pair_costs] = endpoint_fragments(defects, defects, m, d, kind, max_fragment_weight);

memo = {};
[best_cost, ehat] = best_matching(uint64(2^numel(defects) - 1), single_fragments, ...
                                  single_costs, pair_fragments, pair_costs, memo, n);

if isinf(best_cost) || ~isequal(surface_syndrome(ehat, d, kind), s)
    ehat = decode_surface_min_weight(s, d, kind);
end
end

function max_weight = default_fragment_weight(d)
if d <= 3
    max_weight = inf;
elseif d <= 5
    max_weight = 3;
else
    max_weight = 2;
end
end

function [fragments, costs] = endpoint_fragments(rows, cols, m, d, kind, max_weight)
n = d * d;
if isempty(cols)
    fragments = zeros(numel(rows), n);
    costs = inf(1, numel(rows));
    for a = 1:numel(rows)
        target = zeros(1, m);
        target(rows(a)) = 1;
        candidate = surface_decoder_lookup(target, d, kind, max_weight);
        if isequal(surface_syndrome(candidate, d, kind), target)
            fragments(a, :) = candidate;
            costs(a) = sum(candidate);
        end
    end
else
    fragments = zeros(numel(rows), numel(cols), n);
    costs = inf(numel(rows), numel(cols));
    for a = 1:numel(rows)
        for b = (a + 1):numel(cols)
            target = zeros(1, m);
            target(rows(a)) = 1;
            target(cols(b)) = 1;
            candidate = surface_decoder_lookup(target, d, kind, max_weight);
            if isequal(surface_syndrome(candidate, d, kind), target)
                fragments(a, b, :) = candidate;
                fragments(b, a, :) = candidate;
                costs(a, b) = sum(candidate);
                costs(b, a) = costs(a, b);
            end
        end
    end
end
end

function [cost, correction, memo] = best_matching(mask, single_fragments, single_costs, ...
                                                  pair_fragments, pair_costs, memo, n)
key = sprintf('%u', mask);
for k = 1:size(memo, 1)
    if strcmp(memo{k, 1}, key)
        cost = memo{k, 2};
        correction = memo{k, 3};
        return;
    end
end

if mask == 0
    cost = 0;
    correction = zeros(1, n);
    memo(end + 1, :) = {key, cost, correction};
    return;
end

first = first_set_bit(mask);
rest = bitset(mask, first, 0);
best_cost = inf;
best_correction = zeros(1, n);

if ~isinf(single_costs(first))
    [tail_cost, tail_correction, memo] = best_matching(rest, single_fragments, ...
        single_costs, pair_fragments, pair_costs, memo, n);
    trial_correction = xor(single_fragments(first, :), tail_correction);
    trial_cost = single_costs(first) + tail_cost + 0.001 * sum(trial_correction);
    if trial_cost < best_cost
        best_cost = trial_cost;
        best_correction = trial_correction;
    end
end

for j = 1:numel(single_costs)
    if bitget(rest, j) && ~isinf(pair_costs(first, j))
        next_mask = bitset(rest, j, 0);
        [tail_cost, tail_correction, memo] = best_matching(next_mask, single_fragments, ...
            single_costs, pair_fragments, pair_costs, memo, n);
        fragment = reshape(pair_fragments(first, j, :), 1, n);
        trial_correction = xor(fragment, tail_correction);
        trial_cost = pair_costs(first, j) + tail_cost + 0.001 * sum(trial_correction);
        if trial_cost < best_cost
            best_cost = trial_cost;
            best_correction = trial_correction;
        end
    end
end

cost = best_cost;
correction = best_correction;
memo(end + 1, :) = {key, cost, correction};
end

function idx = first_set_bit(mask)
idx = 1;
while ~bitget(mask, idx)
    idx = idx + 1;
end
end
