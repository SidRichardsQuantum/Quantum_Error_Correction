% Convert repeated syndrome measurements into detector-history differences.
%
% The first detector row compares the first measurement with an all-zero prior
% row. Later rows mark syndrome bits that changed between adjacent rounds.

function detectors = syndrome_detector_history(history)
if isempty(history)
    detectors = history;
    return;
end

prior = [zeros(1, size(history, 2)); history(1:end-1, :)];
detectors = xor(history, prior);
end
