% Return the row-major 3x3 Bacon-Shor data-qubit layout.

function layout = bacon_shor_layout()
layout = reshape(1:9, 3, 3).';
end
