% Plot exact recovery failure by Pauli-error weight for several codes.

thisdir = fileparts(mfilename('fullpath'));
outdir  = fullfile(thisdir,'..','images');
if ~exist(outdir,'dir'), mkdir(outdir);
end
addpath(genpath(fullfile(thisdir,'..','src')));

codes = {'bitflip', 'phaseflip', 'fivequbit', 'steane', 'shor'};
labels = {'bit flip', 'phase flip', '5-qubit', 'Steane', 'Shor'};

figure;
hold on;
for k = 1:numel(codes)
    [weights, fail] = sweep_single_pauli_recovery_by_weight(codes{k}, 2);
    plot(weights, fail, 'o-', 'DisplayName', labels{k});
end
hold off;
grid on;
xlabel('Pauli error weight');
ylabel('fraction not recovered');
title('QEC recovery failure by Pauli error weight');
legend('Location','southeast');
print(fullfile(outdir,'qec_recovery_failure_by_error_weight.png'),'-dpng');
