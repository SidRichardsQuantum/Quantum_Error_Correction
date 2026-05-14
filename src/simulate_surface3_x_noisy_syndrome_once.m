% One X-noise trial with repeated noisy surface-code syndrome measurements.

function out = simulate_surface3_x_noisy_syndrome_once(p_data, p_meas, rounds)
if nargin < 1 || isempty(p_data), p_data = 0.08;
end
if nargin < 2 || isempty(p_meas), p_meas = 0.05;
end
if nargin < 3 || isempty(rounds), rounds = 3;
end

e = rand(1,9) < p_data;
[correction, s_hat, history, residual] = recover_surface3_x_noisy_syndrome(e, p_meas, rounds);

out.error = e;
out.syndrome_true = surface3_x_syndrome(e);
out.syndrome_history = history;
out.detector_history = syndrome_detector_history(history);
out.syndrome_hat = s_hat;
out.correction = correction;
out.residual = residual;
out.success = ~surface3_logical_failure(residual);
end
