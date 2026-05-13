% Normalize a state vector and reject the zero vector.

function psi = normalize_state(psi)
n = norm(psi);
if n == 0
    error('normalize_state:zero_state', 'Cannot normalize the zero vector.');
end
psi = psi / n;
end
