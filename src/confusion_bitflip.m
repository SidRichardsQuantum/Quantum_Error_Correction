function C = confusion_bitflip(N, p, logical_bit)
% rows: true {I,X1,X2,X3}, cols: inferred {I,X1,X2,X3}
if nargin < 1 || isempty(N), N = 1e5; end
if nargin < 2 || isempty(p), p = 0.1; end
if nargin < 3, logical_bit = 0; end

alpha_beta = logical_bit==0 ? [1;0] : [0;1];
C = zeros(4,4);
for n = 1:N
    o = simulate_bitflip_once(p, alpha_beta, logical_bit);
    it = label_idx(o.e_true);
    ih = label_idx(o.e_hat);
    C(it, ih) = C(it, ih) + 1;
end
end

function k = label_idx(e)
% e in [e1 e2 e3] with one-hot or zeros
labels = [0 0 0; 1 0 0; 0 1 0; 0 0 1];
[~,k] = ismember(e, labels, 'rows'); % 1..4
end
