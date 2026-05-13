% Measurement schedule for the compact surface-3 circuit-level model.
% Data qubits are 1..9. Ancilla qubits 10..13 measure Z checks and
% ancilla qubits 14..17 measure X checks.

function schedule = surface3_measurement_schedule()
schedule.data_qubits = 1:9;

schedule.z_checks = surface3_z_checks();
schedule.z_ancillas = 10:13;
schedule.z_order = schedule.z_checks;

schedule.x_checks = surface3_x_checks();
schedule.x_ancillas = 14:17;
schedule.x_order = schedule.x_checks;
end
