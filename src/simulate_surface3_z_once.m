% One Z-noise decoding trial for the small surface-code prototype.

function out = simulate_surface3_z_once(p)
if nargin < 1 || isempty(p), p = 0.05;
end

e = rand(1,9) < p;
s = surface3_z_syndrome(e);
ehat = decode_surface3_z_matching(s);
residual = xor(e, ehat);
logical_fail = surface3_logical_failure(residual);

out.error = e;
out.syndrome = s;
out.correction = ehat;
out.residual = residual;
out.success = ~logical_fail;
end
