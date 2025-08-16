function ehat = infer_from_syndrome_bitflip(s)
% map syndrome [s12 s23] to most likely single-qubit flip
% returns ehat in {I,X1,X2,X3} encoded as [e1 e2 e3]
if isequal(s,[1 0])
    ehat = [1 0 0];
elseif isequal(s,[1 1])
    ehat = [0 1 0];
elseif isequal(s,[0 1])
    ehat = [0 0 1];
else
    ehat = [0 0 0];
end
end
