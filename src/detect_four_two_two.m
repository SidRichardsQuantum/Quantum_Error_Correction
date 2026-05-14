% Detect whether a state or Pauli error has nonzero [[4,2,2]] syndrome.

function [detected, syndrome, psi_post] = detect_four_two_two(input)
if ischar(input)
    syndrome = pauli_error_syndrome(four_two_two_stabilizers(), input);
    psi_post = [];
else
    [syndrome, psi_post] = syndrome_four_two_two(input);
end
detected = any(syndrome);
end
