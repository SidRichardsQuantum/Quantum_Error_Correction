% Decode a generic surface-layout syndrome with a small-code-capacity decoder.
%
% For d <= 3 this uses exhaustive minimum-weight lookup. For larger odd d it
% first applies exact single-defect-pattern lookup and then a local peeling
% heuristic that repeatedly chooses the qubit that most reduces syndrome
% weight. The larger-d branch is deliberately lightweight and educational,
% not a production MWPM threshold decoder.

function ehat = decode_surface_min_weight(s, d, kind)
if nargin < 3
    kind = 'z';
end

s = s(:).';
layout = surface_layout(d);

if d <= 3
    ehat = exhaustive_decode(s, d, kind);
    return;
end

ehat = single_error_lookup(s, d, kind);
if any(ehat)
    return;
end

ehat = decode_surface_union_find(s, d, kind);
if ~isequal(surface_syndrome(ehat, d, kind), s)
    ehat = greedy_polish(ehat, s, d, kind, layout.n);
end
end

function ehat = exhaustive_decode(s, d, kind)
n = d * d;
best_w = inf;
ehat = zeros(1, n);
for mask = 0:(2^n - 1)
    candidate = zeros(1, n);
    for q = 1:n
        candidate(q) = bitget(mask, n - q + 1);
    end
    if isequal(surface_syndrome(candidate, d, kind), s)
        w = sum(candidate);
        if w < best_w
            best_w = w;
            ehat = candidate;
        end
    end
end
end

function ehat = single_error_lookup(s, d, kind)
n = d * d;
ehat = zeros(1, n);
for q = 1:n
    candidate = zeros(1, n);
    candidate(q) = 1;
    if isequal(surface_syndrome(candidate, d, kind), s)
        ehat = candidate;
        return;
    end
end
end

function ehat = greedy_polish(ehat, target, d, kind, n)
for pass = 1:(2 * n)
    residual = xor(surface_syndrome(ehat, d, kind), target);
    if ~any(residual)
        return;
    end

    best_q = 0;
    best_score = sum(residual);
    for q = 1:n
        trial = ehat;
        trial(q) = ~trial(q);
        score = sum(xor(surface_syndrome(trial, d, kind), target));
        if score < best_score
            best_score = score;
            best_q = q;
        end
    end

    if best_q == 0
        return;
    end
    ehat(best_q) = ~ehat(best_q);
end
end
