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
    ehat = surface_decoder_lookup(s, d, kind, inf);
    return;
end

if d <= 5
    lookup_weight = min(floor((d - 1) / 2), 2);
else
    lookup_weight = 1;
end
ehat = surface_decoder_lookup(s, d, kind, lookup_weight);
if any(ehat)
    return;
end

ehat = decode_surface_union_find(s, d, kind);
if ~isequal(surface_syndrome(ehat, d, kind), s)
    ehat = greedy_polish(ehat, s, d, kind, layout.n);
end
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
