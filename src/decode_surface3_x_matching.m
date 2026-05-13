% Minimum-weight decoder for X errors on the small distance-3 surface layout.
% For this tiny code, exhaustive lookup gives the same minimum-weight result
% a matching decoder would choose on the syndrome graph.

function ehat = decode_surface3_x_matching(s)
ehat = decode_surface3_min_weight(s, 'x');
end
