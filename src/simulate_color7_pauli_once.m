% Simulate one color-code Pauli-frame correction trial.

function out = simulate_color7_pauli_once(p)
if nargin < 1
    p = 0.05;
end
out = recover_color7_pauli(sample_pauli_error_string(7, p));
end
