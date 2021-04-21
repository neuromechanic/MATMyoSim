function check_new_force(obj, new_length, time_step)
% Function calculates the force for a given length

delta_hs_length = new_length - obj.hs_length;

if (startsWith(obj.kinetic_scheme, '2state'))
    bin_pops = obj.myofilaments.y(1+(1:obj.myofilaments.no_of_x_bins));
    temp_cb_stress = ...
            obj.parameters.cb_number_density * obj.parameters.k_cb * 1e-9 * ...
            sum(bin_pops' .* ...
                (obj.myofilaments.x + obj.parameters.x_ps + ...
                    (obj.parameters.compliance_factor * delta_hs_length)));

    delta_cb_stress = temp_cb_stress - obj.cb_stress;
end

if (startsWith(obj.kinetic_scheme, '3state_with_SRX'))
    bin_pops = obj.myofilaments.y(2+(1:obj.myofilaments.no_of_x_bins));
    temp_cb_stress = ...
            obj.parameters.cb_number_density * obj.parameters.k_cb * 1e-9 * ...
            sum(bin_pops' .* ...
                (obj.myofilaments.x + obj.parameters.x_ps + ...
                    (obj.parameters.compliance_factor * delta_hs_length)));

    delta_cb_stress = temp_cb_stress - obj.cb_stress;
end

if (startsWith(obj.kinetic_scheme, '4state_with_SRX'))
    M3_indices = 2+(1:obj.myofilaments.no_of_x_bins);
    M4_indices = (2+obj.myofilaments.no_of_x_bins) + ...
        (1:obj.myofilaments.no_of_x_bins);

    temp_cb_stress = ...
            obj.parameters.cb_number_density * obj.parameters.k_cb * 1e-9 * ...
            (sum(obj.myofilaments.y(M3_indices)' .* ...
                (obj.myofilaments.x + ...
                    (obj.parameters.compliance_factor * delta_hs_length))) + ...
             sum(obj.myofilaments.y(M4_indices)' .* ...
                (obj.myofilaments.x + obj.parameters.x_ps + ...
                    (obj.parameters.compliance_factor * delta_hs_length))));

    delta_cb_stress = temp_cb_strss - obj.cb_stress;        
end

% Now passive stresses
[temp_intracellular_passive_stress, temp_extracellular_passive_stress] = ...
    obj.return_passive_forces(new_length);

delta_intracellular_passive_stress = temp_intracellular_passive_stress - ...
    obj.intracellular_passive_stress;

delta_extracellular_passive_stress = temp_extracellular_passive_stress - ...
    obj.extracellular_passive_stress;

% Deal with viscous force
temp_viscous_stress = obj.parameters.viscosity * delta_hs_length / time_step;
delta_viscous_stress = temp_viscous_stress - obj.viscous_stress;


% Finally, calculate the hs_force allowing for the different relative areas
obj.check_force = obj.hs_force + ...
                    ((1.0 - obj.parameters.prop_fibrosis) * ...
                        obj.parameters.prop_myofilaments * ...
                            (delta_cb_stress + ...
                                delta_intracellular_passive_stress + ...
                                delta_viscous_stress)) + ...
                    (obj.parameters.prop_fibrosis * ...
                        delta_extracellular_passive_stress);
