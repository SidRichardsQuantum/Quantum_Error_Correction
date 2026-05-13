% X-check supports for the small distance-3 surface-code prototype.
% Data qubits are a 3x3 grid numbered row-major:
% 1 2 3
% 4 5 6
% 7 8 9
% These low-weight supports commute with the Z-check supports in
% surface3_z_checks and give unique single-Z-error syndromes.

function checks = surface3_x_checks()
checks = {[3 6 7 8], [3 4 5 9], [2 5 7 9], [1 5 6 7]};
end
