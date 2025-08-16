function e = sample_error_pattern(p)
% independent bit flips on 3 qubits
e = rand(1,3) < p;
end
