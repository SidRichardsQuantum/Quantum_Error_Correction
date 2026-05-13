% Compare repeated noisy syndrome rounds for the bit-flip code.

function fail = sweep_noisy_syndrome_bitflip(p_data, p_meas, rounds_list, N)
if nargin < 1 || isempty(p_data), p_data = 0.08;
end
if nargin < 2 || isempty(p_meas), p_meas = 0.05;
end
if nargin < 3 || isempty(rounds_list), rounds_list = [1 3 5];
end
if nargin < 4 || isempty(N), N = 1000;
end

fail = zeros(size(rounds_list));
for i = 1:numel(rounds_list)
    c = 0;
    for trial = 1:N
        out = simulate_noisy_syndrome_bitflip_once(p_data, p_meas, rounds_list(i));
        c = c + (~out.success);
    end
    fail(i) = c / N;
end
end
