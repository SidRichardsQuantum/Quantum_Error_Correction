% Pauli-frame recovery for the 7-qubit triangular color code.

function out = recover_color7_pauli(error_label)
stabilizers = color7_stabilizers();
syn = pauli_error_syndrome(stabilizers, error_label);
corr = correction_for_pauli_syndrome('color7', syn);
residual = pauli_product_labels(error_label, corr);

out.syndrome = syn;
out.correction = corr;
out.residual = residual;
out.success = ~color7_logical_failure(residual);
end
