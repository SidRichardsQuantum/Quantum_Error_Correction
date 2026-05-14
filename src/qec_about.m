% Print a short package summary.

function qec_about()
fprintf('Quantum_Error_Correction %s\n', qec_version());
fprintf('Educational MATLAB/Octave quantum error-correction codes and decoders.\n');
fprintf('Implemented families include repetition, Shor, Steane, 5-qubit, color, Bacon-Shor, and surface-layout prototypes.\n');
end
