% Projectively measure stabilizers Z1Z2, Z2Z3.

function [s, psi_post] = syndrome_bitflip(psi)
% return [s12 s23] in {0,1}; optional second output is post-measurement state
[~,~,~,Z] = pauli();
Z1Z2 = kronN(Z,Z,eye(2));
Z2Z3 = kronN(eye(2),Z,Z);

[s12, psi_post] = measure_observable(psi, Z1Z2);
[s23, psi_post] = measure_observable(psi_post, Z2Z3);
s = [s12 s23];
end
