% Measure the four stabilizers of the 5-qubit perfect code.

function [s, psi_post] = syndrome_fivequbit(psi)
stabilizers = fivequbit_stabilizers();
psi_post = psi;
s = zeros(1, numel(stabilizers));
for r = 1:numel(stabilizers)
    [s(r), psi_post] = measure_observable(psi_post, pauli_string_operator(stabilizers{r}));
end
end
