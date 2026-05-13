% Parity-check matrix used by the 7-qubit Steane CSS code.

function H = steane_parity_check()
H = [1 0 1 0 1 0 1;
     0 1 1 0 0 1 1;
     0 0 0 1 1 1 1];
end
