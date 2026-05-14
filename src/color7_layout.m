% Small triangular color-code layout metadata.

function layout = color7_layout()
layout.n = 7;
layout.faces = {[1 2 3 5], [1 3 4 6], [2 3 4 7]};
layout.face_colors = {'red', 'green', 'blue'};
layout.logical_x = 1:7;
layout.logical_z = 1:7;
end
