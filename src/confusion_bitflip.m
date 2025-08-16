function C = confusion_bitflip(N, p, logical_bit)
% rows: true {I,X1,X2,X3,Multi}, cols: inferred {I,X1,X2,X3}
if nargin < 1 || isempty(N), N = 1e5; end
if nargin < 2 || isempty(p), p = 0.1; end
if nargin < 3, logical_bit = 0; end

if logical_bit==0
    alpha_beta = [1;0];
else
    alpha_beta = [0;1];
end

C = zeros(5,4);
for n = 1:N
    o = simulate_bitflip_once(p, alpha_beta, logical_bit);
    it = label_idx(o.e_true);
    ih = label_idx(o.e_hat);
    C(it, ih) = C(it, ih) + 1;
end

% --- normalise each row to probabilities ---
row_sums = sum(C,2);
for r = 1:size(C,1)
    if row_sums(r) > 0
        C(r,:) = C(r,:) / row_sums(r);
    end
end
end

function k = label_idx(e)
e = e(:).';  % force row
labels = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
[tf,k] = ismember(e, labels, 'rows');
if ~tf
    k = 5; % any multi-qubit error
end
end
