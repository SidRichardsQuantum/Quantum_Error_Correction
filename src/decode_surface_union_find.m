% Lightweight peeling decoder for the generic surface layout.
%
% This is a local-search decoder over the binary parity-check matrix. It is
% union-find-style in spirit for teaching purposes, but it is intentionally a
% compact heuristic rather than a full cluster-growth implementation.

function ehat = decode_surface_union_find(s, d, kind)
layout = surface_layout(d);
n = layout.n;
ehat = zeros(1, n);
target = s(:).';
H = surface_check_matrix(d, kind);
current = zeros(1, size(H, 1));

for iter = 1:(2 * n)
    defect = xor(current, target);
    if ~any(defect)
        return;
    end

    best_q = 0;
    best_score = inf;
    for q = 1:n
        trial_defect = xor(xor(current, H(:, q).'), target);
        score = sum(trial_defect) + 0.01 * (sum(ehat) + 1 - 2 * ehat(q));
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

function H = surface_check_matrix(d, kind)
checks = surface_checks(d, kind);
layout = surface_layout(d);
H = zeros(numel(checks), layout.n);
for row = 1:numel(checks)
    H(row, checks{row}) = 1;
end
end
