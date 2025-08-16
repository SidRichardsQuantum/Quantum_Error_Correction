rng(1); addpath(genpath('src'));
p = 0.15; N = 2e5;
w = error_weight_counts(N, p);
figure; bar(0:3, w/sum(w));
grid on; xlabel('error weight'); ylabel('empirical probability');
title(sprintf('Error-weight distribution, p=%.2f', p));
