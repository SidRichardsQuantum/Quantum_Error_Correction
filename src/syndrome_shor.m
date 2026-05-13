% Measure Shor-code bit-flip and phase-flip stabilizer syndromes.

function [syn, psi_post] = syndrome_shor(psi)
psi_post = psi;
bit_pairs = [1 2; 2 3; 4 5; 5 6; 7 8; 8 9];
syn.bit = zeros(3,2);
for r = 1:size(bit_pairs,1)
    labels = repmat('I', 1, 9);
    labels(bit_pairs(r,1)) = 'Z';
    labels(bit_pairs(r,2)) = 'Z';
    [b, psi_post] = measure_observable(psi_post, pauli_string_operator(labels));
    block = ceil(r / 2);
    col = r - 2 * (block - 1);
    syn.bit(block, col) = b;
end

phase_checks = {'XXXXXXIII', 'IIIXXXXXX'};
syn.phase = zeros(1,2);
for r = 1:2
    [syn.phase(r), psi_post] = measure_observable(psi_post, pauli_string_operator(phase_checks{r}));
end
end
