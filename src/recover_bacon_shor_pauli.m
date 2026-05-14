% Recover a Bacon-Shor Pauli-frame error string using row/column syndromes.

function out = recover_bacon_shor_pauli(error_string)
if numel(error_string) ~= 9
    error('recover_bacon_shor_pauli:bad_length', 'Expected a 9-character Pauli string.');
end

x_error = (error_string == 'X') | (error_string == 'Y');
z_error = (error_string == 'Z') | (error_string == 'Y');

x_syndrome = bacon_shor_x_syndrome(x_error);
z_syndrome = bacon_shor_z_syndrome(z_error);
x_correction = decode_bacon_shor_x(x_syndrome);
z_correction = decode_bacon_shor_z(z_syndrome);
x_residual = xor(x_error, x_correction);
z_residual = xor(z_error, z_correction);

out.error = error_string;
out.x_error = x_error;
out.z_error = z_error;
out.x_syndrome = x_syndrome;
out.z_syndrome = z_syndrome;
out.x_correction = x_correction;
out.z_correction = z_correction;
out.x_residual = x_residual;
out.z_residual = z_residual;
out.success = ~bacon_shor_logical_failure(x_residual, z_residual);
end
