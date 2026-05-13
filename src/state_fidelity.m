% Fidelity between two pure state vectors, insensitive to global phase.

function f = state_fidelity(psi, phi)
psi = normalize_state(psi);
phi = normalize_state(phi);
f = abs(psi' * phi)^2;
end
