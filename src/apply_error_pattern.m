% Deterministically apply a chosen error pattern [e1 e2 e3].
% Each entry ei=1 applies X on that qubit.

function psi_out = apply_error_pattern(psi, e)
% e is [e1 e2 e3] with entries 0 or 1
[~,X,~,~] = pauli();
ops = { (e(1)==1)*X + (e(1)==0)*eye(2), ...
        (e(2)==1)*X + (e(2)==0)*eye(2), ...
        (e(3)==1)*X + (e(3)==0)*eye(2) };
E = kronN(ops{:});
psi_out = E*psi;
end
