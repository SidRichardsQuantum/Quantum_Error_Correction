% Return generic surface-layout CSS check supports.

function checks = surface_checks(d, kind)
layout = surface_layout(d);
switch lower(kind)
    case 'x'
        checks = layout.x_checks;
    case 'z'
        checks = layout.z_checks;
    otherwise
        error('surface_checks:bad_kind', 'Check kind must be x or z.');
end
end
