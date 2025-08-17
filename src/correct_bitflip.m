% Apply single-qubit correction operator based on syndrome bits.

function psi_corr = correct_bitflip(psi,s)
[~,X,~,~] = pauli();
X1 = kronN(X,eye(2),eye(2));
X2 = kronN(eye(2),X,eye(2));
X3 = kronN(eye(2),eye(2),X);
if isequal(s,[1 0])      % flip on qubit 1
    psi_corr = X1*psi;
elseif isequal(s,[1 1])  % flip on qubit 2
    psi_corr = X2*psi;
elseif isequal(s,[0 1])  % flip on qubit 3
    psi_corr = X3*psi;
else
    psi_corr = psi;      % no error
end
end
