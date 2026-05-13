% Return true when a residual chain has odd overlap with a logical set.

function logical_fail = surface3_logical_failure(residual)
sets = surface3_logical_sets();
logical_fail = false;
for k = 1:numel(sets)
    if mod(sum(residual(sets{k})), 2) == 1
        logical_fail = true;
        return;
    end
end
end
