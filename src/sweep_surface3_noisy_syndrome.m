% Compare repeated noisy syndrome rounds for surface-3 X and Z channels.

function [rounds_list, fail_x, fail_z] = sweep_surface3_noisy_syndrome(p_data, p_meas, rounds_list, N)
if nargin < 1 || isempty(p_data), p_data = 0.08;
end
if nargin < 2 || isempty(p_meas), p_meas = 0.05;
end
if nargin < 3 || isempty(rounds_list), rounds_list = [1 3 5];
end
if nargin < 4 || isempty(N), N = 1000;
end

fail_x = zeros(size(rounds_list));
fail_z = zeros(size(rounds_list));
for i = 1:numel(rounds_list)
    cx = 0;
    cz = 0;
    for trial = 1:N
        out_x = simulate_surface3_x_noisy_syndrome_once(p_data, p_meas, rounds_list(i));
        out_z = simulate_surface3_z_noisy_syndrome_once(p_data, p_meas, rounds_list(i));
        cx = cx + (~out_x.success);
        cz = cz + (~out_z.success);
    end
    fail_x(i) = cx / N;
    fail_z(i) = cz / N;
end
end
