% Projectively measure phase-flip code stabilizers X1X2, X2X3.

function [s, psi_post] = syndrome_phaseflip(psi)
[~,X,~,~] = pauli();
X1X2 = kronN(X,X,eye(2));
X2X3 = kronN(eye(2),X,X);
[s12, psi_post] = measure_observable(psi, X1X2);
[s23, psi_post] = measure_observable(psi_post, X2X3);
s = [s12 s23];
end
