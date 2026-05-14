% Simulate one Bacon-Shor Pauli-frame recovery trial under depolarizing noise.

function out = simulate_bacon_shor_pauli_once(p)
if nargin < 1 || isempty(p), p = 0.05; end
error_string = sample_pauli_error_string(9, p);
out = recover_bacon_shor_pauli(error_string);
end
