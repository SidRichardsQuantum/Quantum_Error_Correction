% Lightweight union-find-style peeling decoder for the generic surface layout.

function ehat = decode_surface_union_find(s, d, kind)
layout = surface_layout(d);
n = layout.n;
ehat = zeros(1, n);
target = s(:).';

for iter = 1:(2 * n)
    current = surface_syndrome(ehat, d, kind);
    defect = xor(current, target);
    if ~any(defect)
        return;
    end

    best_q = 0;
    best_score = inf;
    for q = 1:n
        trial = ehat;
        trial(q) = ~trial(q);
        trial_defect = xor(surface_syndrome(trial, d, kind), target);
        score = sum(trial_defect) + 0.01 * sum(trial);
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
