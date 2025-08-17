% Compute stabilizer measurement outcomes Z1Z2, Z2Z3.

function s = syndrome_bitflip(psi)
% measure Z1Z2 and Z2Z3 stabilizers; return [s12 s23] in {0,1}
[~,~,~,Z] = pauli();
Z1Z2 = kronN(Z,Z,eye(2));
Z2Z3 = kronN(eye(2),Z,Z);
s = [measure_pm(psi,Z1Z2), measure_pm(psi,Z2Z3)];
end

function b = measure_pm(psi,Obs)
v = real(psi'*(Obs*psi)); % expectation in {-1,1}
b = (1 - sign(v))/2;      % map +1->0, -1->1
end
