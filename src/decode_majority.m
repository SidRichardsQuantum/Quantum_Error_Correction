% Decode logical bit by majority vote over 3 physical qubits.

function bit = decode_majority(psi)
% projectively read out each qubit in Z and take majority vote
probs = zeros(8,1);
for k=1:8, probs(k)=abs(psi(k))^2; end
% states are |q1 q2 q3> in binary order 000..111
ones_count = [0 1 1 2 1 2 2 3];
p1 = sum(probs(ones_count>=2));
p0 = 1 - p1;
bit = p1 > p0;
end
