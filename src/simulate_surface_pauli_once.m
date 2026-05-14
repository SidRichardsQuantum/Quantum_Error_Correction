% Simulate one generic surface-layout code-capacity Pauli correction trial.

function out = simulate_surface_pauli_once(d, p, decoder)
if nargin < 2
    p = 0.05;
end
if nargin < 3
    decoder = 'min_weight';
end

error_label = sample_pauli_error_string(d * d, p);
x_error = (error_label == 'X') | (error_label == 'Y');
z_error = (error_label == 'Z') | (error_label == 'Y');

x_corr = decode_surface_with(surface_syndrome(x_error, d, 'z'), d, 'z', decoder);
z_corr = decode_surface_with(surface_syndrome(z_error, d, 'x'), d, 'x', decoder);

x_residual = xor(x_error, x_corr);
z_residual = xor(z_error, z_corr);

out.d = d;
out.decoder = decoder;
out.error = error_label;
out.x_residual = x_residual;
out.z_residual = z_residual;
out.success = ~surface_logical_failure(x_residual, d) && ...
              ~surface_logical_failure(z_residual, d);
end

function ehat = decode_surface_with(s, d, kind, decoder)
if isa(decoder, 'function_handle')
    ehat = decoder(s, d, kind);
    return;
end

switch lower(decoder)
    case {'min_weight', 'lookup_peeling'}
        ehat = decode_surface_min_weight(s, d, kind);
    case {'graph_matching', 'graph_search'}
        ehat = decode_surface_graph_matching(s, d, kind);
    case {'mwpm', 'mwpm_style', 'matching'}
        ehat = decode_surface_mwpm(s, d, kind);
    case {'union_find', 'peeling'}
        ehat = decode_surface_union_find(s, d, kind);
    otherwise
        error('simulate_surface_pauli_once:bad_decoder', ...
              'Unknown decoder "%s".', decoder);
end
end
