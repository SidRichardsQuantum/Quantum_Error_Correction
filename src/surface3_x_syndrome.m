% Z-check syndrome caused by X errors on the small surface-code layout.

function s = surface3_x_syndrome(e)
checks = surface3_z_checks();
s = zeros(1, numel(checks));
for r = 1:numel(checks)
    s(r) = mod(sum(e(checks{r})), 2);
end
end
