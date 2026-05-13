% Z-check supports for a small distance-3 rotated surface-code layout.
% Data qubits are a 3x3 grid numbered row-major:
% 1 2 3
% 4 5 6
% 7 8 9

function checks = surface3_z_checks()
checks = {[1 2 4 5], [2 3 5 6], [4 5 7 8], [5 6 8 9]};
end
