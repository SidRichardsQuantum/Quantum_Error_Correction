% Projectively measure a Hermitian observable with eigenvalues +/-1.
% Returns bit 0 for +1 and bit 1 for -1, plus the post-measurement state.

function [bit, psi_post, prob] = measure_observable(psi, Obs)
psi = normalize_state(psi);
d = numel(psi);
tol = 1e-12;

Pplus = (eye(d) + Obs) / 2;
Pminus = (eye(d) - Obs) / 2;
pplus = real(psi' * (Pplus * psi));
pminus = real(psi' * (Pminus * psi));
pplus = min(max(pplus, 0), 1);
pminus = min(max(pminus, 0), 1);

if pminus <= tol
    bit = 0;
    psi_post = psi;
    prob = pplus;
elseif pplus <= tol
    bit = 1;
    psi_post = psi;
    prob = pminus;
elseif rand() < pplus
    bit = 0;
    psi_post = Pplus * psi / sqrt(pplus);
    prob = pplus;
else
    bit = 1;
    psi_post = Pminus * psi / sqrt(pminus);
    prob = pminus;
end
end
