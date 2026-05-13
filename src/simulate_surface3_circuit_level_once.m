% One circuit-level surface-3 trial with data, measurement, and hook faults.
%
% The simulator tracks X and Z Pauli-frame bits on data qubits. Each round:
%   1. applies independent data Pauli noise,
%   2. measures all Z-check ancillas to detect X errors,
%   3. measures all X-check ancillas to detect Z errors,
%   4. majority-votes the reported syndrome history and decodes.
%
% Gate faults are modeled as hook-like correlated data faults created by an
% ancilla interaction schedule. This is intentionally compact and educational;
% it is not a calibrated hardware noise model.

function out = simulate_surface3_circuit_level_once(p_data, p_meas, p_gate, rounds)
if nargin < 1 || isempty(p_data), p_data = 0.01;
end
if nargin < 2 || isempty(p_meas), p_meas = 0.01;
end
if nargin < 3 || isempty(p_gate), p_gate = 0.001;
end
if nargin < 4 || isempty(rounds), rounds = 3;
end

schedule = surface3_measurement_schedule();
x_error = zeros(1, 9);
z_error = zeros(1, 9);
x_history = zeros(rounds, numel(schedule.z_checks));
z_history = zeros(rounds, numel(schedule.x_checks));
hook_events = {};

for r = 1:rounds
    labels = sample_pauli_error_string(9, p_data);
    x_error = xor(x_error, (labels == 'X') | (labels == 'Y'));
    z_error = xor(z_error, (labels == 'Z') | (labels == 'Y'));

    for c = 1:numel(schedule.z_checks)
        [bit, x_error, events] = measure_surface3_component_check( ...
            x_error, schedule.z_checks{c}, schedule.z_order{c}, ...
            schedule.z_ancillas(c), p_meas, p_gate, r, c, 'Z');
        x_history(r, c) = bit;
        hook_events = append_hook_events(hook_events, events);
    end

    for c = 1:numel(schedule.x_checks)
        [bit, z_error, events] = measure_surface3_component_check( ...
            z_error, schedule.x_checks{c}, schedule.x_order{c}, ...
            schedule.x_ancillas(c), p_meas, p_gate, r, c, 'X');
        z_history(r, c) = bit;
        hook_events = append_hook_events(hook_events, events);
    end
end

x_syndrome_hat = surface3_majority_syndrome(x_history);
z_syndrome_hat = surface3_majority_syndrome(z_history);
x_correction = decode_surface3_x_matching(x_syndrome_hat);
z_correction = decode_surface3_z_matching(z_syndrome_hat);
x_residual = xor(x_error, x_correction);
z_residual = xor(z_error, z_correction);

out.schedule = schedule;
out.x_error = x_error;
out.z_error = z_error;
out.x_syndrome_history = x_history;
out.z_syndrome_history = z_history;
out.x_syndrome_hat = x_syndrome_hat;
out.z_syndrome_hat = z_syndrome_hat;
out.x_correction = x_correction;
out.z_correction = z_correction;
out.x_residual = x_residual;
out.z_residual = z_residual;
out.hook_events = hook_events;
out.x_logical_fail = surface3_logical_failure(x_residual);
out.z_logical_fail = surface3_logical_failure(z_residual);
out.success = ~(out.x_logical_fail || out.z_logical_fail);
end

function [reported_bit, component_error, events] = measure_surface3_component_check( ...
    component_error, support, order, ancilla, p_meas, p_gate, round_index, check_index, check_type)

true_bit = mod(sum(component_error(support)), 2);
reported_bit = true_bit;
events = {};

for step = 1:numel(order)
    if rand() < p_gate
        if step < numel(order)
            affected = order(step:step+1);
        else
            affected = order(step);
        end

        component_error(affected) = xor(component_error(affected), 1);
        reported_bit = xor(reported_bit, 1);

        event.round = round_index;
        event.check_index = check_index;
        event.check_type = check_type;
        event.ancilla = ancilla;
        event.step = step;
        event.data_qubits = affected;
        events{end+1} = event;
    end
end

reported_bit = xor(reported_bit, rand() < p_meas);
end

function all_events = append_hook_events(all_events, new_events)
for k = 1:numel(new_events)
    all_events{end+1} = new_events{k};
end
end
