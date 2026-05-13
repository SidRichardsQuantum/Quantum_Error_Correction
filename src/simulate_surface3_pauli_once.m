% One independent Pauli-noise decoding trial for the small surface-code model.
% X and Z components are decoded independently; Y contributes to both.

function out = simulate_surface3_pauli_once(p)
if nargin < 1 || isempty(p), p = 0.05;
end

labels = sample_pauli_error_string(9, p);
x_error = (labels == 'X') | (labels == 'Y');
z_error = (labels == 'Z') | (labels == 'Y');

x_syndrome = surface3_x_syndrome(x_error);
z_syndrome = surface3_z_syndrome(z_error);
x_correction = decode_surface3_x_matching(x_syndrome);
z_correction = decode_surface3_z_matching(z_syndrome);
x_residual = xor(x_error, x_correction);
z_residual = xor(z_error, z_correction);

x_logical_fail = surface3_logical_failure(x_residual);
z_logical_fail = surface3_logical_failure(z_residual);

out.error = labels;
out.x_error = x_error;
out.z_error = z_error;
out.x_syndrome = x_syndrome;
out.z_syndrome = z_syndrome;
out.x_correction = x_correction;
out.z_correction = z_correction;
out.x_residual = x_residual;
out.z_residual = z_residual;
out.x_logical_fail = x_logical_fail;
out.z_logical_fail = z_logical_fail;
out.success = ~(x_logical_fail || z_logical_fail);
end
