% Return true for a residual color-code Pauli with logical support.

function fail = color7_logical_failure(error_label)
layout = color7_layout();
x_part = (error_label == 'X') | (error_label == 'Y');
z_part = (error_label == 'Z') | (error_label == 'Y');
fail = mod(sum(x_part(layout.logical_x)), 2) == 1 || ...
       mod(sum(z_part(layout.logical_z)), 2) == 1;
end
