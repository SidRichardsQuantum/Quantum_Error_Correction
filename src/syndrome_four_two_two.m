% Measure the two stabilizers of the [[4,2,2]] error-detecting code.

function [s, psi_post] = syndrome_four_two_two(psi)
stabilizers = four_two_two_stabilizers();
psi_post = psi;
s = zeros(1, numel(stabilizers));
for r = 1:numel(stabilizers)
    [s(r), psi_post] = measure_observable(psi_post, pauli_string_operator(stabilizers{r}));
end
end
