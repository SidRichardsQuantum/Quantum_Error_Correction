% Decode a generic surface-layout syndrome with a bounded syndrome-graph search.
%
% This baseline treats candidate data-qubit flips as edges in the syndrome
% state graph and returns the lightest candidate found up to max_weight. It is
% a clear graph-search comparison point for the lookup-plus-peeling decoder,
% not a threshold-quality MWPM implementation.

function ehat = decode_surface_graph_matching(s, d, kind, max_weight)
if nargin < 3
    kind = 'z';
end
if nargin < 4
    if d <= 3
        max_weight = inf;
    else
        max_weight = min(2, floor((d - 1) / 2));
    end
end

ehat = surface_decoder_lookup(s, d, kind, max_weight);
end
