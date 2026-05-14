% Syndrome of a binary data-qubit error against generic surface checks.

function s = surface_syndrome(error, d, kind)
if nargin < 2 || isempty(d)
    d = sqrt(numel(error));
end
checks = surface_checks(d, kind);
s = zeros(1, numel(checks));
for k = 1:numel(checks)
    s(k) = mod(sum(error(checks{k})), 2);
end
end
