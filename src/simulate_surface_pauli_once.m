% Simulate one generic surface-layout code-capacity Pauli correction trial.

function out = simulate_surface_pauli_once(d, p)
if nargin < 2
    p = 0.05;
end

error_label = sample_pauli_error_string(d * d, p);
x_error = (error_label == 'X') | (error_label == 'Y');
z_error = (error_label == 'Z') | (error_label == 'Y');

x_corr = decode_surface_min_weight(surface_syndrome(x_error, d, 'z'), d, 'z');
z_corr = decode_surface_min_weight(surface_syndrome(z_error, d, 'x'), d, 'x');

x_residual = xor(x_error, x_corr);
z_residual = xor(z_error, z_corr);

out.d = d;
out.error = error_label;
out.x_residual = x_residual;
out.z_residual = z_residual;
out.success = ~surface_logical_failure(x_residual, d) && ...
              ~surface_logical_failure(z_residual, d);
end
