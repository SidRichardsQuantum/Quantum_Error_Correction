% Return true when a residual chain has odd overlap with a logical line.

function fail = surface_logical_failure(residual, d)
layout = surface_layout(d);
fail = false;
for k = 1:d
    if mod(sum(residual(layout.logical_x{k})), 2) == 1
        fail = true;
        return;
    end
    if mod(sum(residual(layout.logical_z{k})), 2) == 1
        fail = true;
        return;
    end
end
end
