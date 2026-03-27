; HEADER_BLOCK_START
; BambuStudio 02.00.03.54
; model printing time: 33m 3s; total estimated time: 39m 59s
; total layer number: 45
; total filament length [mm] : 1262.26
; total filament volume [cm^3] : 3036.08
; total filament weight [g] : 0.00
; filament_density: 0
; filament_diameter: 1.75
; max_z_height: 9.00
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_pattern = zig-zag
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 25
; brim_object_gap = 0
; brim_type = auto_brim
; brim_width = 0
; chamber_temperatures = 0
; change_filament_gcode = ;===== A1 20250206 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nM620.10 A0 F[old_filament_e_feedrate]\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\nM620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[nozzle_temperature_range_high]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_fan_the_first_x_layers = 1
; complete_print_exhaust_fan_speed = 80
; cool_plate_temp = 35
; cool_plate_temp_initial_layer = 35
; counter_coef_1 = 0
; counter_coef_2 = 0.025
; counter_coef_3 = -0.11
; counter_limit_max = 0.05
; counter_limit_min = -0.04
; curr_bed_type = Cool Plate
; default_acceleration = 6000
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL A1"
; default_jerk = 0
; default_print_profile = 0.20mm Standard @BBL A1
; deretraction_speed = 0
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = ;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 60
; elefant_foot_compensation = 0.075
; enable_arc_fitting = 0
; enable_circle_compensation = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 0
; enforce_support_layers = 0
; eng_plate_temp = 45
; eng_plate_temp_initial_layer = 45
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 
; extruder_clearance_dist_to_rod = 56.5
; extruder_clearance_height_to_lid = 256
; extruder_clearance_height_to_rod = 25
; extruder_clearance_max_radius = 73
; extruder_colour = ""
; extruder_offset = 0x0
; extruder_printable_area = 
; extruder_printable_height = 0
; extruder_type = Direct Drive
; fan_cooling_layer_time = 80
; fan_max_speed = 80
; fan_min_speed = 60
; filament_adhesiveness_category = 0
; filament_change_length = 10
; filament_colour = #00AE42
; filament_cost = 0
; filament_density = 0
; filament_diameter = 1.75
; filament_end_gcode = " "
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 1
; filament_ids = ""
; filament_is_support = 0
; filament_map = 1
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 2
; filament_minimal_purge_on_wipe_tower = 15
; filament_notes = 
; filament_pre_cooling_temperature = 0
; filament_prime_volume = 45
; filament_ramming_travel_time = 0
; filament_ramming_volumetric_speed = -1
; filament_scarf_gap = 0
; filament_scarf_height = 0%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_settings_id = "Generic PLA @BBL A1"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = " "
; filament_type = PLA
; filename_format = [input_filename_base].gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,280,280,280,280,0,280,280,280,280,0,280,280,280,280,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 30
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 17.4
; has_scarf_joint_seam = 1
; head_wrap_detect_zone = 226x224,256x224,256x256,226x256
; hole_coef_1 = 0
; hole_coef_2 = -0.025
; hole_coef_3 = 0.28
; hole_limit_max = 0.25
; hole_limit_min = 0.08
; hot_plate_temp = 65
; hot_plate_temp_initial_layer = 65
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 0
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_jerk = 9
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;
; initial_layer_acceleration = 300
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 60
; initial_layer_jerk = 9
; initial_layer_line_width = 0.4
; initial_layer_print_height = 0.2
; initial_layer_speed = 30
; initial_layer_travel_acceleration = 500
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.4
; inner_wall_speed = 60
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0
; internal_solid_infill_line_width = 0.4
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 100
; ironing_direction = 45
; ironing_flow = 10%
; ironing_inset = 0
; ironing_pattern = zig-zag
; ironing_spacing = 0.1
; ironing_speed = 20
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.4
; long_retractions_when_cut = 0
; machine_end_gcode = ;===== date: 20231229 =====================\nG392 S0 ;turn off nozzle clog detect\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-13.0 F3000 ; move to safe pos\n{if !spiral_mode && print_sequence != "by object"}\nM1002 judge_flag timelapse_record_flag\nM622 J1\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM991 S0 P-1 ;end timelapse at safe pos\nM623\n{endif}\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n;G1 X27 F15000 ; wipe\n\n; pull back filament to AMS\nM620 S255\nG1 X267 F15000\nT255\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nM621 S255\n\nM104 S0 ; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 256}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z256 F600\n    G1 Z256\n{endif}\nM400 P100\nM17 R ; restore z current\n\nG90\nG1 X-48 Y180 F3600\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N80\nM1006 A44 B20 L100 C49 D20 M80 E41 F20 N80\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N80\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n;=====printer finish  sound=========\n\n;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM400\nM18 X Y Z\n\n
; machine_load_filament_time = 25
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 12000,12000
; machine_max_acceleration_retracting = 1500,1250
; machine_max_acceleration_travel = 1500,1250
; machine_max_acceleration_x = 6000,6000
; machine_max_acceleration_y = 6000,6000
; machine_max_acceleration_z = 1500,1500
; machine_max_jerk_e = 3,3
; machine_max_jerk_x = 10,10
; machine_max_jerk_y = 10,10
; machine_max_jerk_z = 0.2,0.4
; machine_max_speed_e = 120,120
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = 
; machine_start_gcode = ;===== machine: A1 =========================\n;===== date: 20240620 =====================\nG392 S0\nM9833.2\n;M400\n;M73 P1.717\n\n;===== start to heat heatbead&hotend==========\nM1002 gcode_claim_action : 2\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM104 S140\nM140 S[bed_temperature_initial_layer_single]\n\n;=====start printer sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A43 B10 L100 C46 D10 M70 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C43 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C41 D10 M80 E41 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E44 F10 N80\nM1006 A0 B10 L100 C49 D10 M80 E49 F10 N80\nM1006 A0 B10 L100 C0 D10 M80 E0 F10 N80\nM1006 A44 B10 L100 C48 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A43 B10 L100 C46 D10 M60 E39 F10 N80\nM1006 W\nM18 \n;=====start printer sound ===================\n\n;=====avoid end stop =================\nG91\nG380 S2 Z40 F1200\nG380 S3 Z-15 F1200\nG90\n\n;===== reset machine status =================\n;M290 X39 Y39 Z8\nM204 S6000\n\nM630 S0 P0\nG91\nM17 Z0.3 ; lower the z-motor current\n\nG90\nM17 X0.65 Y1.2 Z0.6 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\n;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\nM1002 gcode_claim_action : 13\n\nG28 X\nG91\nG1 Z5 F1200\nG90\nG0 X128 F30000\nG0 Y254 F3000\nG91\nG1 Z-5 F1200\n\nM109 S25 H140\n\nM17 E0.3\nM83\nG1 E10 F1200\nG1 E-0.5 F30\nM17 D\n\nG28 Z P0 T140; home z with low precision,permit 300deg temperature\nM104 S{nozzle_temperature_initial_layer[initial_extruder]}\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n  G39.4\n  G90\n  G1 Z5 F1200\nM623\n\n;M400\n;M73 P1.717\n\n;===== prepare print temperature and material ==========\nM1002 gcode_claim_action : 24\n\nM400\n;G392 S1\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on\n\nG90\nG1 X-28.5 F30000\nG1 X-48.2 F3000\n\nM620 M ;enable remap\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M1002 gcode_claim_action : 4\n    M400\n    M1002 set_filament_type:UNKNOWN\n    M109 S[nozzle_temperature_initial_layer]\n    M104 S250\n    M400\n    T[initial_no_support_extruder]\n    G1 X-48.2 F3000\n    M400\n\n    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}\n    M109 S250 ;set nozzle to common flush temp\n    M106 P1 S0\n    G92 E0\n    G1 E50 F200\n    M400\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300\nG92 E0\nG1 E50 F200 ; lower extrusion speed to avoid clog\nM400\nM106 P1 S178\nG92 E0\nG1 E5 F200\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG92 E0\nG1 E-0.5 F300\n\nG1 X-28.5 F30000\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\n\n;G392 S0\n\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n;M400\n;M73 P1.717\n\n;===== auto extrude cali start =========================\nM975 S1\n;G392 S1\n\nG90\nM83\nT1000\nG1 X-48.2 Y0 Z10 F10000\nM400\nM1002 set_filament_type:UNKNOWN\n\nM412 S1 ;  ===turn on  filament runout detection===\nM400 P10\nM620.3 W1; === turn on filament tangle detection===\nM400 S2\n\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n;M1002 set_flag extrude_cali_flag=1\nM1002 judge_flag extrude_cali_flag\n\nM622 J1\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_extruder]}\n    G1 E10 F{outer_wall_volumetric_speed/2.4*60}\n    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n\n    M106 P1 S255\n    M400 S5\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\n\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n        M106 P1 S255\n        M400 S5\n        G1 X-28.5 F18000\n        G1 X-48.2 F3000\n        G1 X-28.5 F18000 ;wipe and shake\n        G1 X-48.2 F3000\n        G1 X-28.5 F12000 ;wipe and shake\n        M400\n        M106 P1 S0\n    M623\n    \n    G1 X-48.2 F3000\n    M400\n    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]\n    M106 P1 S178\n    M400 S7\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\nM623 ; end of "draw extrinsic para cali paint"\n\n;G392 S0\n;===== auto extrude cali end ========================\n\n;M400\n;M73 P1.717\n\nM104 S170 ; prepare to wipe nozzle\nM106 S255 ; turn on fan\n\n;===== mech mode fast check start =====================\nM1002 gcode_claim_action : 3\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q1 A5 K0 O3\nM974 Q1 S2 P0\n\nM970.2 Q1 K1 W58 Z0.1\nM974 S2\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q0 A10 K0 O1\nM974 Q0 S2 P0\n\nM970.2 Q0 K1 W78 Z0.1\nM974 S2\n\nM975 S1\nG1 F30000\nG1 X0 Y5\nG28 X ; re-home XY\n\nG1 Z4 F1200\n\n;===== mech mode fast check end =======================\n\n;M400\n;M73 P1.717\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\n\nM975 S1\nM106 S255 ; turn on fan (G28 has turn off fan)\nM211 S; push soft endstop status\nM211 X0 Y0 Z0 ;turn off Z axis endstop\n\n;===== remove waste by touching start =====\n\nM104 S170 ; set temp down to heatbed acceptable\n\nM83\nG1 E-1 F500\nG90\nM83\n\nM109 S170\nG0 X108 Y-0.5 F30000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X110 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X112 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X114 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X116 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X118 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X120 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X122 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X124 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X126 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X128 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X130 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X132 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X134 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X136 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X138 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X140 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X142 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X144 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X146 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X148 F10000\nG380 S3 Z-5 F1200\n\nG1 Z5 F30000\n;===== remove waste by touching end =====\n\nG1 Z10 F1200\nG0 X118 Y261 F30000\nG1 Z5 F1200\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-50}\n\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nM104 S140 ; prepare to abl\nG0 Z5 F20000\n\nG0 X128 Y261 F20000  ; move to exposed steel surface\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nG90\nG1 Z10 F1200\n\n;===== brush material wipe nozzle =====\n\nG90\nG1 Y250 F30000\nG1 X55\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X-35 F30000\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Z5.000 F1200\n\nG90\nG1 X30 Y250.000 F30000\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X35 F30000\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Z10.000 F1200\n\n;===== brush material wipe nozzle end =====\n\nG90\n;G0 X128 Y261 F20000  ; move to exposed steel surface\nG1 Y250 F30000\nG1 X138\nG1 Y261\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nM109 S140\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM211 R; pop softend status\n\n;===== wipe nozzle end ================================\n\n;M400\n;M73 P1.717\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\n\nG90\nG1 Z5 F1200\nG1 X0 Y0 F30000\nG29.2 S1 ; turn on ABL\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n\n;===== home after wipe mouth end =======================\n\n;M400\n;M73 P1.717\n\nG1 X108.000 Y-0.500 F30000\nG1 Z0.300 F1200\nM400\nG2814 Z0.32\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print\n\n;===== nozzle load line ===============================\n;G90\n;M83\n;G1 Z5 F1200\n;G1 X88 Y-0.5 F20000\n;G1 Z0.3 F1200\n\n;M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n\n;G1 E2 F300\n;G1 X168 E4.989 F6000\n;G1 Z1 F1200\n;===== nozzle load line end ===========================\n\n;===== extrude cali test ===============================\n\nM400\n    M900 S\n    M900 C\n    G90\n    M83\n\n    M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n    G0 X128 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\n\nM900 R\n\nM1002 judge_flag extrude_cali_flag\nM622 J1\n    G90\n    G1 X108.000 Y1.000 F30000\n    G91\n    G1 Z-0.700 F1200\n    G90\n    M83\n    G0 X128 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\nM623\n\nG1 Z0.2\n\n;M400\n;M73 P1.717\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.02} ; for Textured PEI Plate\n{endif}\n\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n\nM211 X0 Y0 Z0 ;turn off soft endstop\n;G392 S1 ; turn on clog detection\nM1007 S1 ; turn on mass estimation\nG29.4\n
; machine_switch_extruder_time = 5
; machine_unload_filament_time = 0
; master_extruder_id = 1
; max_bridge_length = 10
; max_layer_height = 0
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.07
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; nozzle_diameter = 0.4
; nozzle_height = 4.76
; nozzle_temperature = 200
; nozzle_temperature_initial_layer = 200
; nozzle_temperature_range_high = 240
; nozzle_temperature_range_low = 190
; nozzle_type = stainless_steel
; nozzle_volume = 92
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 500
; outer_wall_jerk = 9
; outer_wall_line_width = 0
; outer_wall_speed = 60
; overhang_1_4_speed = 0
; overhang_2_4_speed = 0
; overhang_3_4_speed = 0
; overhang_4_4_speed = 0
; overhang_fan_speed = 100
; overhang_fan_threshold = 95%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; print_compatible_printers = "Bambu Lab A1 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL A1
; printable_area = 0x0,200x0,200x200,0x200
; printable_height = 256
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab A1
; printer_notes = 
; printer_settings_id = Bambu Lab A1 0.4 nozzle
; printer_structure = i3
; printer_technology = FFF
; printer_variant = 0.4
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = 2
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 0
; reduce_infill_retraction = 0
; required_nozzle_HRC = 0
; resolution = 0.01
; retract_before_wipe = 100%
; retract_length_toolchange = 10
; retract_lift_above = 0
; retract_lift_below = 255
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 0
; retraction_distances_when_cut = 18
; retraction_length = 0.8
; retraction_minimum_travel = 2
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_inner_walls = 1
; seam_slope_steps = 10
; silent_mode = 0
; single_extruder_multi_material = 0
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 1
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 5
; slow_down_min_speed = 10
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 80
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 1
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 20%
; sparse_infill_filament = 1
; sparse_infill_line_width = 0.4
; sparse_infill_pattern = cubic
; sparse_infill_speed = 100
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 35
; supertack_plate_temp_initial_layer = 35
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 0
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 3
; support_line_width = 0.4
; support_object_first_layer_gap = 0.2
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 80
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = normal(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 100
; template_custom_gcode = 
; textured_plate_temp = 65
; textured_plate_temp_initial_layer = 65
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;===================== date: 20250206 =====================\n{if !spiral_mode && print_sequence != "by object"}\n; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\nG92 E0\nG1 Z{max_layer_z + 0.4}\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-48.2 F3000 ; move to safe pos\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X0 F18000\nM623\n\n; SKIPTYPE: head_wrap_detect\nM622.1 S1\nM1002 judge_flag g39_3rd_layer_detect_flag\nM622 J1\n    ; enable nozzle clog detect at 3rd layer\n    {if layer_num == 2}\n      M400\n      G90\n      M83\n      M204 S5000\n      G0 Z2 F4000\n      G0 X261 Y250 F20000\n      M400 P200\n      G39 S1\n      G0 Z2 F4000\n    {endif}\n\n\n    M622.1 S1\n    M1002 judge_flag g39_detection_flag\n    M622 J1\n      {if !in_head_wrap_detect_zone}\n        M622.1 S0\n        M1002 judge_flag g39_mass_exceed_flag\n        M622 J1\n        {if layer_num > 2}\n            G392 S0\n            M400\n            G90\n            M83\n            M204 S5000\n            G0 Z{max_layer_z + 0.4} F4000\n            G39.3 S1\n            G0 Z{max_layer_z + 0.4} F4000\n            G392 S0\n          {endif}\n        M623\n    {endif}\n    M623\nM623\n; SKIPPABLE_END\n{endif}\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 4
; top_one_wall_type = all top
; top_shell_layers = 4
; top_shell_thickness = 0.6
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 500
; top_surface_jerk = 9
; top_surface_line_width = 0.4
; top_surface_pattern = zig-zag
; top_surface_speed = 100
; travel_acceleration = 500
; travel_jerk = 9
; travel_speed = 700
; travel_speed_z = 0
; tree_support_branch_angle = 40
; tree_support_branch_diameter = 5
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = 0
; unprintable_filament_types = ""
; upward_compatible_machine = "Bambu Lab H2D 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; wall_distribution_count = 1
; wall_filament = 1
; wall_generator = arachne
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 0
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 220
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Spiral Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R40
M201 X6000 Y6000 Z1500 E5000
M203 X500 Y500 Z30 E120
M204 P12000 R1500 T12000
M205 X10.00 Y10.00 Z0.20 E3.00
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: A1 =========================
;===== date: 20240620 =====================
G392 S0
M9833.2
;M400
;M73 P1.717

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2
M1002 set_filament_type:PLA
M104 S140
M140 S35

;=====start printer sound ===================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18 
;=====start printer sound ===================

;=====avoid end stop =================
G91
G380 S2 Z40 F1200
G380 S3 Z-15 F1200
G90

;===== reset machine status =================
;M290 X39 Y39 Z8
M204 S6000

M630 S0 P0
G91
M17 Z0.3 ; lower the z-motor current

G90
M17 X0.65 Y1.2 Z0.6 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

M1002 gcode_claim_action : 13

G28 X
G91
G1 Z5 F1200
G90
G0 X128 F30000
G0 Y254 F3000
G91
G1 Z-5 F1200

M109 S25 H140

M17 E0.3
M83
M73 P0 R39
G1 E10 F1200
G1 E-0.5 F30
M17 D

G28 Z P0 T140; home z with low precision,permit 300deg temperature
M104 S200

M1002 judge_flag build_plate_detect_flag
M622 S1
  G39.4
  G90
  G1 Z5 F1200
M623

;M400
;M73 P1.717

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24

M400
;G392 S1
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on

G90
G1 X-28.5 F30000
G1 X-48.2 F3000

M620 M ;enable remap
M620 S0A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S200
    M104 S250
    M400
    T0
    G1 X-48.2 F3000
    M400

    M620.1 E F49.8898 T240
    M109 S250 ;set nozzle to common flush temp
    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:PLA
M621 S0A

M109 S240 H300
G92 E0
G1 E50 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S178
G92 E0
G1 E5 F200
M104 S200
G92 E0
M73 P1 R39
G1 E-0.5 F300

G1 X-28.5 F30000
M73 P2 R39
G1 X-48.2 F3000
M73 P2 R38
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000

;G392 S0

M400
M106 P1 S0
;===== prepare print temperature and material end =====

;M400
;M73 P1.717

;===== auto extrude cali start =========================
M975 S1
;G392 S1

G90
M83
T1000
G1 X-48.2 Y0 Z10 F10000
M400
M1002 set_filament_type:UNKNOWN

M412 S1 ;  ===turn on  filament runout detection===
M400 P10
M620.3 W1; === turn on filament tangle detection===
M400 S2

M1002 set_filament_type:PLA

;M1002 set_flag extrude_cali_flag=1
M1002 judge_flag extrude_cali_flag

M622 J1
    M1002 gcode_claim_action : 8

    M109 S200
    G1 E10 F50
    M983 F0.833333 A0.3 H0.4; cali dynamic extrusion compensation

    M106 P1 S255
    M400 S5
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
M73 P3 R38
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0

    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F0.833333 A0.3 H0.4; cali dynamic extrusion compensation
        M106 P1 S255
        M400 S5
        G1 X-28.5 F18000
        G1 X-48.2 F3000
        G1 X-28.5 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-28.5 F12000 ;wipe and shake
        M400
        M106 P1 S0
    M623
    
M73 P4 R38
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F0.833333 H0.4
    M106 P1 S178
    M400 S7
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0
M623 ; end of "draw extrinsic para cali paint"

;G392 S0
;===== auto extrude cali end ========================

;M400
;M73 P1.717

M104 S170 ; prepare to wipe nozzle
M106 S255 ; turn on fan

;===== mech mode fast check start =====================
M1002 gcode_claim_action : 3

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q1 A5 K0 O3
M974 Q1 S2 P0

M970.2 Q1 K1 W58 Z0.1
M974 S2

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q0 A10 K0 O1
M974 Q0 S2 P0

M970.2 Q0 K1 W78 Z0.1
M974 S2

M975 S1
G1 F30000
G1 X0 Y5
G28 X ; re-home XY

G1 Z4 F1200

;===== mech mode fast check end =======================

;M400
;M73 P1.717

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14

M975 S1
M106 S255 ; turn on fan (G28 has turn off fan)
M211 S; push soft endstop status
M211 X0 Y0 Z0 ;turn off Z axis endstop

;===== remove waste by touching start =====

M104 S170 ; set temp down to heatbed acceptable

M83
G1 E-1 F500
G90
M83

M109 S170
G0 X108 Y-0.5 F30000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X110 F10000
G380 S3 Z-5 F1200
M73 P15 R33
G1 Z2 F1200
G1 X112 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X114 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X116 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X118 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X120 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X122 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X124 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X126 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X128 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X130 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X132 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X134 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X136 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X138 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X140 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X142 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X144 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X146 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X148 F10000
G380 S3 Z-5 F1200

G1 Z5 F30000
;===== remove waste by touching end =====

G1 Z10 F1200
G0 X118 Y261 F30000
G1 Z5 F1200
M109 S150

G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
M104 S140 ; prepare to abl
G0 Z5 F20000

G0 X128 Y261 F20000  ; move to exposed steel surface
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

G90
G1 Z10 F1200

;===== brush material wipe nozzle =====

G90
G1 Y250 F30000
G1 X55
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X-35 F30000
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200

G90
G1 X30 Y250.000 F30000
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X35 F30000
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200

;===== brush material wipe nozzle end =====

G90
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000
G1 X138
G1 Y261
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

M109 S140
M106 S255 ; turn on fan (G28 has turn off fan)

M211 R; pop softend status

;===== wipe nozzle end ================================

;M400
;M73 P1.717

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag

G90
G1 Z5 F1200
G1 X0 Y0 F30000
G29.2 S1 ; turn on ABL

M190 S35; ensure bed temp
M109 S140
M106 S0 ; turn off fan , too noisy

M622 J1
    M1002 gcode_claim_action : 1
    G29 A1 X95.9771 Y40.4236 I8.04581 J119.157
    M400
    M500 ; save cali data
M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623

;===== home after wipe mouth end =======================

;M400
;M73 P1.717

G1 X108.000 Y-0.500 F30000
G1 Z0.300 F1200
M400
G2814 Z0.32

M104 S200 ; prepare to print

;===== nozzle load line ===============================
;G90
;M83
;G1 Z5 F1200
;G1 X88 Y-0.5 F20000
;G1 Z0.3 F1200

;M109 S200

;G1 E2 F300
;G1 X168 E4.989 F6000
;G1 Z1 F1200
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400
    M900 S
    M900 C
    G90
    M83

    M109 S200
    G0 X128 E8  F120
    G0 X133 E.3742  F200
    G0 X138 E.3742  F800
    G0 X143 E.3742  F200
    G0 X148 E.3742  F800
    G0 X153 E.3742  F200
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400

M900 R

M1002 judge_flag extrude_cali_flag
M622 J1
    G90
    G1 X108.000 Y1.000 F30000
    G91
    G1 Z-0.700 F1200
    G90
    M83
    G0 X128 E10  F120
    G0 X133 E.3742  F200
    G0 X138 E.3742  F800
    G0 X143 E.3742  F200
    G0 X148 E.3742  F800
    G0 X153 E.3742  F200
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400
M623

G1 Z0.2

;M400
;M73 P1.717

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Cool Plate


M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4
; MACHINE_START_GCODE_END
;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 1/45
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
G1 E-.8 F1800
G1 X97.147 Y41.658 F42000
M204 S500
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Skirt
; LINE_WIDTH: 0.4
M73 P16 R33
G1 F1680.297
M204 S300
G1 X98.192 Y40.789 E.04034
G1 X99.113 Y40.602 E.0279
G1 X100.887 Y40.602 E.0527
G1 X102.188 Y40.994 E.04034
G1 X103.057 Y42.038 E.04034
G1 X103.244 Y42.959 E.0279
G1 X103.256 Y157.044 E3.38734
G1 X102.865 Y158.345 E.04034
G1 X101.82 Y159.214 E.04034
G1 X100.899 Y159.402 E.02792
M73 P17 R33
G1 X99.101 Y159.402 E.05338
G1 X97.8 Y159.01 E.04034
G1 X96.931 Y157.966 E.04034
G1 X96.744 Y157.044 E.02792
G1 X96.755 Y42.959 E3.38734
G1 X97.13 Y41.716 E.03856
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z.6 I-.641 J1.034 P1  F42000
G1 X100.217 Y43.63 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.47687
G1 F1382.648
M204 S300
G1 X100.217 Y43.847 E.00783
; LINE_WIDTH: 0.48824
G1 F1347.346
G1 X100.223 Y156.368 E4.16651
G1 X99.777 Y156.368 E.01649
G1 X99.783 Y43.847 E4.16651
; LINE_WIDTH: 0.47687
G1 F1382.648
G1 X99.783 Y43.63 E.00783
G1 X100.157 Y43.63 E.01349
M204 S500
G1 X100.612 Y43.234 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S300
M73 P17 R32
G1 X100.612 Y43.847 E.01818
G1 X100.624 Y156.77 E3.35274
G1 X99.376 Y156.77 E.03705
G1 X99.388 Y43.234 E3.37092
G1 X100.552 Y43.234 E.03458
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 2/45
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S170.85
; open powerlost recovery
M1003 S1
; OBJECT_ID: 14
G1 X100.962 Y43.516 F42000
M204 S500
G1 Z.4
; FEATURE: Inner wall
G1 F1680.343
M204 S6000
G1 X100.962 Y44.478 E.02856
G1 X100.967 Y156.487 E3.32561
G1 X100.899 Y156.487 E.00203
G1 X100.819 Y156.487 E.00238
G1 X100.739 Y156.487 E.00238
G1 X99.261 Y156.487 E.04388
G1 X99.181 Y156.487 E.00238
G1 X99.101 Y156.487 E.00238
M73 P18 R32
G1 X99.033 Y156.487 E.00203
G1 X99.038 Y43.516 E3.35417
G1 X99.113 Y43.516 E.00221
G1 X99.193 Y43.516 E.00238
G1 X99.273 Y43.516 E.00238
G1 X100.727 Y43.516 E.0432
G1 X100.807 Y43.516 E.00238
G1 X100.887 Y43.516 E.00238
G1 X100.902 Y43.516 E.00043
M204 S500
G1 X101.087 Y43.159 F42000
; FEATURE: Overhang wall
M106 S255
G1 F600
G1 X101.319 Y43.159 E.00687
G1 X101.319 Y44.478 E.03916
M106 S170.85
M106 S255

G1 X101.324 Y156.845 E3.33621
G1 X101.099 Y156.845 E.0067
M106 S170.85
; FEATURE: Outer wall
G1 F1680.343
G1 X101.059 Y156.845 E.00119
G1 X100.979 Y156.845 E.00237
G1 X100.899 Y156.845 E.00238
G1 X100.819 Y156.845 E.00238
G1 X100.739 Y156.845 E.00238
G1 X99.261 Y156.845 E.04388
G1 X99.181 Y156.845 E.00238
G1 X99.101 Y156.845 E.00238
G1 X99.021 Y156.845 E.00238
G1 X98.941 Y156.845 E.00237
G1 X98.901 Y156.845 E.00119
; FEATURE: Overhang wall
M106 S255
M73 P19 R32
G1 F600
G1 X98.675 Y156.845 E.0067
G1 X98.681 Y43.159 E3.37537
G1 X98.913 Y43.159 E.00687
M106 S170.85
; FEATURE: Outer wall
G1 F1680.343
G1 X98.953 Y43.159 E.00119
G1 X99.033 Y43.159 E.00238
G1 X99.113 Y43.159 E.00238
G1 X99.193 Y43.159 E.00238
G1 X99.273 Y43.159 E.00238
G1 X100.727 Y43.159 E.04319
G1 X100.807 Y43.159 E.00238
G1 X100.887 Y43.159 E.00238
G1 X100.967 Y43.159 E.00238
G1 X101.027 Y43.159 E.00178
G1 E-.8 F1800
G17
G3 Z.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X100.605 Y44.478 F42000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X100.605 Y43.873 E.01796
G1 X99.395 Y43.873 E.03592
G1 X99.39 Y156.13 E3.33297
G1 X100.61 Y156.13 E.03624
G1 X100.605 Y44.538 E3.31323
G1 E-.8 F1800
M204 S500
G17
G3 Z.8 I-1.217 J-.004 P1  F42000
G1 X100.216 Y155.52 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.47197
G1 F1398.44
M204 S6000
G1 X100.213 Y44.265 E3.96909
G1 X99.787 Y44.265 E.01521
G1 X99.784 Y155.736 E3.97679
G1 X100.216 Y155.736 E.0154
G1 X100.216 Y155.58 E.00556
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 3/45
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
M106 S163.2
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
M73 P20 R32
G3 Z.8 I1.217 J.013 P1  F42000
G1 X101.408 Y43.516 Z.8
M73 P20 R31
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X101.408 Y44.925 E.04181
G1 X101.412 Y156.487 E3.31236
G1 X101.364 Y156.487 E.0014
G1 X98.636 Y156.487 E.08102
G1 X98.588 Y156.487 E.0014
G1 X98.592 Y43.516 E3.35417
G1 X98.641 Y43.516 E.00146
G1 X101.348 Y43.516 E.08038
M204 S500
G1 X101.439 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.519 Y43.159 E.00238
G1 F1470.823
G1 X101.599 Y43.159 E.00237
G1 F1076.459
G1 X101.679 Y43.159 E.00238
G1 F743.445
G1 X101.719 Y43.159 E.00119
; FEATURE: Overhang wall
M106 S255
G1 F600
G1 X101.765 Y43.159 E.00138
G1 X101.765 Y44.925 E.05241
M106 S163.2
M106 S255

G1 X101.769 Y156.845 E3.32296
G1 X101.724 Y156.845 E.00131
M106 S163.2
; FEATURE: Outer wall
M73 P21 R31
G1 F743.482
G1 X101.684 Y156.845 E.00119
G1 F1076.414
G1 X101.604 Y156.845 E.00237
G1 F1470.823
G1 X101.524 Y156.845 E.00238
G1 F1680.343
G1 X101.444 Y156.845 E.00238
G1 X101.364 Y156.845 E.00238
G1 X98.635 Y156.845 E.08102
G1 X98.555 Y156.845 E.00238
G1 X98.475 Y156.845 E.00238
G1 F1470.823
G1 X98.395 Y156.845 E.00238
G1 F1076.414
G1 X98.316 Y156.845 E.00237
G1 F743.482
G1 X98.275 Y156.845 E.00119
; FEATURE: Overhang wall
M106 S255
G1 F600
G1 X98.231 Y156.845 E.00131
G1 X98.235 Y43.159 E3.37537
G1 X98.281 Y43.159 E.00138
M106 S163.2
; FEATURE: Outer wall
G1 F743.445
G1 X98.321 Y43.159 E.00119
G1 F1076.459
G1 X98.401 Y43.159 E.00238
G1 F1470.823
G1 X98.481 Y43.159 E.00237
G1 F1680.343
G1 X98.561 Y43.159 E.00238
G1 X98.641 Y43.159 E.00238
G1 X101.359 Y43.159 E.0807
G1 X101.379 Y43.159 E.00059
G1 E-.8 F1800
G17
G3 Z1 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    
      M400
      G90
      M83
      M204 S5000
      G0 Z2 F4000
      G0 X261 Y250 F20000
      M400 P200
      G39 S1
      G0 Z2 F4000
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X100 Y155.076 F42000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.36333
G1 F1872.601
M204 S6000
G1 X100 Y44.985 E2.93307
M204 S500
G1 X100.337 Y44.925 F42000
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
M73 P22 R31
G1 X100.337 Y44.587 E.01001
G1 X99.663 Y44.587 E.02002
G1 X99.66 Y155.416 E3.29056
G1 X100.34 Y155.416 E.02021
G1 X100.337 Y44.985 E3.27877
M204 S500
G1 X100.694 Y44.925 F42000
G1 F1680.343
M204 S6000
G1 X100.694 Y44.23 E.02061
G1 X99.306 Y44.23 E.04122
G1 X99.303 Y155.773 E3.31176
G1 X100.698 Y155.773 E.04142
G1 X100.694 Y44.985 E3.28937
M204 S500
G1 X101.051 Y44.925 F42000
G1 F1680.343
M204 S6000
G1 X101.051 Y43.873 E.03121
G1 X98.949 Y43.873 E.06242
G1 X98.945 Y156.13 E3.33297
G1 X101.055 Y156.13 E.06262
G1 X101.051 Y44.985 E3.29997
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 4/45
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S175.95
; OBJECT_ID: 14
M204 S500
G1 X101.707 Y43.516 Z.8 F42000
; FEATURE: Inner wall
G1 F1680.343
M204 S6000
G1 X101.708 Y45.224 E.0507
M73 P22 R30
G1 X101.711 Y156.487 E3.30347
G1 X98.289 Y156.487 E.1016
G1 X98.292 Y43.516 E3.35417
G1 X101.647 Y43.516 E.09961
M204 S500
G1 X101.885 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.965 Y43.159 E.00238
G1 X102.045 Y43.159 E.00238
G1 X102.065 Y43.159 E.00057
G1 X102.065 Y45.224 E.0613
G1 X102.068 Y156.845 E3.31407
M73 P23 R30
G1 X102.049 Y156.845 E.00057
G1 X101.969 Y156.845 E.00238
G1 X101.889 Y156.845 E.00237
G1 X101.809 Y156.845 E.00238
G1 X98.191 Y156.845 E.1074
G1 X98.111 Y156.845 E.00238
G1 X98.031 Y156.845 E.00237
G1 X97.951 Y156.845 E.00238
G1 X97.932 Y156.845 E.00057
G1 X97.935 Y43.159 E3.37537
G1 X97.955 Y43.159 E.00057
G1 X98.035 Y43.159 E.00238
G1 X98.115 Y43.159 E.00238
G1 X98.195 Y43.159 E.00238
G1 X101.805 Y43.159 E.1072
G1 X101.825 Y43.159 E.00059
G1 E-.8 F1800
G17
G3 Z1.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.2
G1 X0 Y100.002 F18000 ; move to safe pos
M73 P24 R30
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.2 F4000
            G39.3 S1
            G0 Z1.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X100.954 Y44.078 F42000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42601
G1 F1566.212
M204 S6000
G1 X100.959 Y156.118 E3.5689
G1 X101.341 Y156.118 E.01219
G1 X101.337 Y43.887 E3.57501
G1 X100.954 Y43.887 E.01222
G1 X100.954 Y44.018 E.0042
M204 S500
G1 X100.313 Y43.82 F42000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X100.583 Y43.82 E.00802
G1 X100.583 Y44.978 E.03439
G1 X99.417 Y45.291 E.03587
G1 X99.417 Y45.593 E.00898
G1 X100.583 Y46.76 E.049
G1 X100.584 Y50.523 E.11173
G1 X99.416 Y50.836 E.03588
G1 X99.416 Y53.167 E.06923
G1 X100.584 Y54.335 E.04903
G1 X100.584 Y54.246 E.00264
G1 X99.416 Y58.605 E.13398
G1 X99.416 Y60.742 E.06345
G1 X100.584 Y61.91 E.04906
G1 X100.584 Y61.613 E.00882
G1 X99.416 Y61.926 E.03592
G1 X99.416 Y63.355 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.092 J.537 P1  F42000
G1 X100.584 Y65.73 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.584 Y67.158 E.04241
G1 X99.415 Y67.471 E.03593
G1 X99.415 Y68.316 E.02508
G1 X100.585 Y69.485 E.04909
G1 X100.585 Y70.914 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.203 J-.184 P1  F42000
G1 X99.415 Y78.562 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.585 Y78.248 E.03597
G1 X100.585 Y77.061 E.03527
G1 X99.415 Y75.891 E.04912
G1 X99.415 Y73.017 E.08533
G1 X100.585 Y72.703 E.03595
G1 X100.585 Y74.937 E.06633
G1 X99.415 Y79.303 E.13421
G1 X99.415 Y80.732 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-.989 J.709 P1  F42000
G1 X100.585 Y82.365 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.585 Y83.793 E.04241
G1 X99.415 Y84.107 E.03598
G1 X99.415 Y83.465 E.01906
G1 X100.585 Y84.636 E.04915
G1 X100.586 Y89.338 E.13963
G1 X99.414 Y89.652 E.036
G1 X99.414 Y91.04 E.04119
G1 X100.586 Y92.211 E.04918
G1 X100.586 Y90.783 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.133 J-.444 P1  F42000
G1 X99.414 Y93.769 Z1.2
M73 P25 R30
G1 Z.8
M73 P25 R29
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X99.414 Y95.197 E.04241
G1 X100.586 Y94.884 E.03602
G1 X100.586 Y95.628 E.02211
G1 X99.414 Y100.002 E.13444
G1 X99.414 Y100.743 E.022
G1 X100.586 Y100.429 E.03603
G1 X100.586 Y99.786 E.01908
G1 X99.414 Y98.614 E.04922
G1 X99.414 Y97.186 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.202 J.191 P1  F42000
G1 X100.586 Y104.545 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.586 Y105.974 E.04241
G1 X99.414 Y106.288 E.03605
G1 X99.414 Y106.188 E.00295
G1 X100.586 Y107.361 E.04925
G1 X100.587 Y111.519 E.12344
G1 X99.413 Y111.833 E.03606
G1 X99.413 Y113.763 E.0573
G1 X100.587 Y114.936 E.04928
G1 X100.587 Y116.319 E.04105
G1 X99.413 Y120.7 E.13467
G1 X99.413 Y121.337 E.01891
G1 X100.587 Y122.512 E.04931
G1 X100.587 Y122.609 E.00289
G1 X99.413 Y122.924 E.0361
G1 X99.413 Y124.352 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.091 J.54 P1  F42000
G1 X100.587 Y126.726 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.587 Y128.154 E.04241
G1 X99.413 Y128.469 E.03611
G1 X99.413 Y128.912 E.01315
G1 X100.588 Y130.087 E.04934
G1 X100.588 Y131.515 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.217 J0 P1  F42000
G1 X100.588 Y137.662 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X99.412 Y136.486 E.04937
G1 X99.412 Y134.014 E.0734
G1 X100.588 Y133.699 E.03613
G1 X100.588 Y137.01 E.09831
G1 X99.412 Y141.399 E.1349
G1 X99.412 Y144.061 E.07903
G1 X100.588 Y145.237 E.0494
G1 X100.588 Y144.789 E.0133
G1 X99.412 Y145.104 E.03616
G1 X99.412 Y146.533 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I-1.09 J.541 P1  F42000
G1 X100.588 Y148.906 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.588 Y150.334 E.04241
G1 X99.411 Y150.65 E.03618
G1 X99.411 Y151.635 E.02926
G1 X100.589 Y152.812 E.04943
G1 X100.589 Y155.879 E.09106
G1 X99.452 Y156.184 E.03496
G1 X99.411 Y156.184 E.0012
G1 X99.411 Y154.796 E.04121
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I1.213 J.101 P1  F42000
G1 X100.588 Y140.672 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.588 Y139.244 E.04241
G1 X99.412 Y139.559 E.03615
G1 X99.412 Y138.131 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I1.215 J.068 P1  F42000
G1 X100.587 Y117.064 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X99.413 Y117.378 E.03608
G1 X99.413 Y115.95 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I1.217 J.024 P1  F42000
G1 X100.584 Y57.496 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.584 Y56.068 E.04241
G1 X99.416 Y56.381 E.0359
G1 X99.416 Y54.953 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I1.216 J-.041 P1  F42000
G1 X99.046 Y44.078 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.426025
G1 F1566.15
M204 S6000
G1 X99.046 Y43.887 E.00611
G1 X98.663 Y43.887 E.01222
G1 X98.659 Y156.118 E3.57515
G1 X99.041 Y156.118 E.01219
G1 X99.046 Y44.138 E3.56713
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 5/45
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S178.5
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z1.2 I.25 J1.191 P1  F42000
G1 X102.007 Y43.516 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.007 Y45.523 E.05958
G1 X102.009 Y156.487 E3.29459
G1 X97.991 Y156.487 E.11931
G1 X97.993 Y43.516 E3.35417
G1 X101.947 Y43.516 E.11738
M204 S500
G1 X102.185 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.265 Y43.159 E.00238
G1 X102.345 Y43.159 E.00238
G1 X102.364 Y43.159 E.00057
G1 X102.364 Y45.523 E.07018
G1 X102.366 Y156.845 E3.30519
G1 X102.348 Y156.845 E.00054
G1 X102.268 Y156.845 E.00238
G1 X102.188 Y156.845 E.00237
G1 X102.108 Y156.845 E.00238
G1 X97.892 Y156.845 E.12518
G1 X97.812 Y156.845 E.00238
G1 X97.732 Y156.845 E.00237
G1 X97.652 Y156.845 E.00238
G1 X97.634 Y156.845 E.00055
G1 X97.636 Y43.159 E3.37537
G1 X97.655 Y43.159 E.00057
G1 X97.735 Y43.159 E.00238
G1 X97.815 Y43.159 E.00238
G1 X97.895 Y43.159 E.00238
G1 X102.105 Y43.159 E.12497
G1 X102.125 Y43.159 E.00059
G1 E-.8 F1800
G17
G3 Z1.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.4
G1 X0 Y100.002 F18000 ; move to safe pos
M73 P26 R29
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.4 F4000
            G39.3 S1
            G0 Z1.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.363 Y44.005 F42000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.352745
G1 F1936.578
M204 S6000
G1 X101.366 Y156.154 E2.88919
G1 X101.676 Y156.154 E.00798
G1 X101.673 Y43.85 E2.89319
G1 X101.363 Y43.85 E.00799
G1 X101.363 Y43.945 E.00245
M204 S500
G1 X100.786 Y43.82 F42000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.03 Y43.82 E.00722
G1 X101.03 Y45.005 E.03518
G1 X98.97 Y45.557 E.0633
G1 X98.97 Y44.947 E.01811
G1 X101.03 Y47.006 E.08648
G1 X101.03 Y48.435 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I1.071 J-.578 P1  F42000
G1 X98.637 Y44.005 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.3528
G1 F1936.233
M204 S6000
G1 X98.637 Y43.85 E.004
G1 X98.327 Y43.85 E.00799
G1 X98.324 Y156.154 E2.8937
G1 X98.634 Y156.154 E.00798
G1 X98.637 Y44.065 E2.88816
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.216 J.036 P1  F42000
G1 X98.97 Y55.219 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X98.97 Y56.647 E.04241
G1 X101.03 Y56.095 E.06333
G1 X101.03 Y54.581 E.04495
G1 X98.97 Y52.521 E.0865
G1 X98.97 Y51.102 E.04215
M73 P27 R29
G1 X101.03 Y50.55 E.06331
G1 X101.03 Y52.035 E.04409
G1 X98.97 Y59.723 E.23633
G1 X98.97 Y60.096 E.01107
G1 X101.03 Y62.156 E.08652
G1 X101.03 Y61.64 E.01533
G1 X98.97 Y62.192 E.06334
G1 X98.97 Y63.62 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-.876 J.845 P1  F42000
G1 X101.03 Y65.757 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.03 Y67.185 E.04241
G1 X98.97 Y67.737 E.06335
G1 X98.97 Y67.67 E.00199
G1 X101.03 Y69.731 E.08653
G1 X101.03 Y71.16 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.156 J-.382 P1  F42000
G1 X98.969 Y77.399 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.969 Y78.828 E.04241
G1 X101.031 Y78.275 E.06337
G1 X101.031 Y77.306 E.02877
G1 X98.969 Y75.245 E.08655
G1 X98.969 Y73.283 E.05827
G1 X101.031 Y72.727 E.06338
G1 X98.969 Y80.42 E.23647
G1 X98.969 Y82.82 E.07124
G1 X101.031 Y84.881 E.08657
G1 X101.031 Y83.82 E.0315
G1 X98.969 Y84.373 E.06338
G1 X98.969 Y85.801 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-.876 J.845 P1  F42000
G1 X101.031 Y87.937 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.031 Y89.366 E.04241
G1 X98.969 Y89.918 E.06339
G1 X98.969 Y90.394 E.01414
G1 X101.031 Y92.456 E.08659
G1 X101.031 Y93.42 E.0286
G1 X98.969 Y101.117 E.23661
G1 X98.969 Y101.008 E.00323
G1 X101.031 Y100.456 E.06341
G1 X101.031 Y100.031 E.0126
G1 X98.969 Y97.969 E.08661
G1 X98.969 Y95.463 E.07439
M73 P27 R28
G1 X101.031 Y94.911 E.0634
G1 X101.031 Y96.339 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.217 J0 P1  F42000
G1 X101.032 Y104.572 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.032 Y106.001 E.04241
G1 X98.968 Y106.554 E.06342
G1 X98.968 Y105.543 E.03
G1 X101.032 Y107.606 E.08663
G1 X101.032 Y109.035 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.217 J0 P1  F42000
G1 X101.032 Y115.181 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.968 Y113.118 E.08665
G1 X98.968 Y112.099 E.03026
G1 X101.032 Y111.546 E.06343
G1 X101.032 Y114.112 E.07619
G1 X98.968 Y121.814 E.23676
G1 X98.968 Y123.189 E.04082
G1 X101.032 Y122.636 E.06345
G1 X101.032 Y122.756 E.00357
G1 X98.968 Y120.692 E.08667
G1 X98.968 Y117.644 E.09051
G1 X101.032 Y117.091 E.06344
G1 X101.032 Y118.519 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.217 J0 P1  F42000
G1 X101.032 Y126.753 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.032 Y128.181 E.04241
G1 X98.968 Y128.734 E.06346
G1 X98.968 Y128.267 E.01388
G1 X101.032 Y130.331 E.08669
G1 X101.032 Y131.76 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.162 J-.362 P1  F42000
G1 X98.967 Y138.396 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.967 Y139.825 E.04241
G1 X101.033 Y139.271 E.06348
G1 X101.033 Y137.907 E.04052
G1 X98.968 Y135.842 E.08671
G1 X98.968 Y134.279 E.04638
G1 X101.032 Y133.726 E.06347
G1 X101.032 Y134.804 E.03201
G1 X98.967 Y142.511 E.2369
G1 X98.967 Y143.416 E.02686
G1 X101.033 Y145.482 E.08673
G1 X101.033 Y144.816 E.01975
G1 X98.967 Y145.37 E.06349
G1 X98.967 Y146.798 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-.875 J.846 P1  F42000
G1 X101.033 Y148.933 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.033 Y150.362 E.04241
G1 X98.967 Y150.915 E.0635
G1 X98.967 Y150.991 E.00225
G1 X101.033 Y153.057 E.08675
G1 X101.033 Y151.628 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I-1.196 J-.225 P1  F42000
G1 X100.177 Y156.184 Z1.4
G1 Z1
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.849 Y156.184 E.01996
G1 X101.033 Y155.497 E.02112
G1 X101.033 Y155.907 E.01217
G1 X99.998 Y156.184 E.03182
G1 X98.967 Y156.184 E.03061
G1 X98.967 Y155.787 E.0118
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 6/45
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z1.4 I1.216 J.035 P1  F42000
G1 X102.207 Y43.516 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.207 Y45.723 E.06553
G1 X102.209 Y156.487 E3.28864
G1 X97.791 Y156.487 E.13119
G1 X97.793 Y43.516 E3.35417
G1 X102.147 Y43.516 E.12927
M204 S500
G1 X102.484 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.564 Y43.159 E.00238
G1 X102.564 Y45.723 E.07613
G1 X102.566 Y156.845 E3.29924
G1 X102.486 Y156.845 E.00238
G1 X102.406 Y156.845 E.00238
G1 X97.594 Y156.845 E.14289
G1 X97.514 Y156.845 E.00238
G1 X97.434 Y156.845 E.00238
G1 X97.436 Y43.159 E3.37537
G1 X97.516 Y43.159 E.00238
G1 X97.596 Y43.159 E.00238
G1 X102.404 Y43.159 E.14274
G1 X102.424 Y43.159 E.00059
G1 E-.8 F1800
G17
G3 Z1.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.6 F4000
            G39.3 S1
            G0 Z1.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.152 Y43.82 F42000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.329 Y43.82 E.00526
G1 X101.329 Y45.071 E.03715
G1 X98.671 Y45.783 E.0817
M73 P28 R28
G1 X98.671 Y44.447 E.03966
G1 X101.329 Y47.105 E.11161
G1 X101.329 Y48.534 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.136 J-.437 P1  F42000
G1 X98.671 Y55.445 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.671 Y56.874 E.04241
G1 X101.329 Y56.161 E.08172
G1 X101.329 Y54.68 E.04396
G1 X98.671 Y52.022 E.11163
G1 X98.671 Y51.328 E.02059
G1 X101.329 Y50.616 E.08171
G1 X101.329 Y50.372 E.00725
G1 X98.671 Y60.294 E.30499
G1 X98.67 Y62.419 E.06309
G1 X101.329 Y61.706 E.08173
G1 X101.329 Y62.256 E.01631
G1 X98.671 Y59.597 E.11165
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.119 J.478 P1  F42000
G1 X101.33 Y65.823 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.33 Y67.251 E.04241
G1 X98.67 Y67.964 E.08174
G1 X98.67 Y67.171 E.02354
G1 X101.33 Y69.831 E.11167
G1 X101.33 Y71.064 E.03663
G1 X98.67 Y80.991 E.30513
G1 X98.67 Y82.32 E.03947
G1 X101.33 Y84.981 E.11171
G1 X101.33 Y83.887 E.03248
G1 X98.67 Y84.599 E.08178
G1 X98.67 Y86.028 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.127 J.459 P1  F42000
G1 X101.33 Y92.556 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.67 Y89.895 E.11173
G1 X98.67 Y90.145 E.00742
G1 X101.33 Y89.432 E.08179
G1 X101.33 Y91.757 E.06903
G1 X98.669 Y101.688 E.30528
G1 X98.669 Y105.044 E.09965
G1 X101.331 Y107.706 E.11176
G1 X101.331 Y106.067 E.04865
G1 X98.669 Y106.78 E.08182
G1 X98.669 Y108.209 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I1.217 J0 P1  F42000
G1 X98.669 Y101.235 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.331 Y100.522 E.08181
G1 X101.331 Y100.131 E.01162
G1 X98.669 Y97.469 E.11174
G1 X98.669 Y95.69 E.05284
G1 X101.33 Y94.977 E.0818
G1 X101.331 Y96.405 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P29 R28
G3 Z1.6 I1.205 J-.171 P1  F42000
G1 X98.67 Y77.626 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.67 Y79.054 E.04241
G1 X101.33 Y78.342 E.08176
G1 X101.33 Y77.406 E.02779
G1 X98.67 Y74.746 E.11169
G1 X98.67 Y73.509 E.03672
G1 X101.33 Y72.796 E.08175
G1 X101.33 Y74.225 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.215 J-.077 P1  F42000
G1 X98.669 Y116.442 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.669 Y117.871 E.04241
G1 X101.331 Y117.157 E.08184
G1 X101.331 Y115.281 E.05572
G1 X98.669 Y112.619 E.11178
G1 X98.669 Y112.325 E.0087
G1 X101.331 Y111.612 E.08183
G1 X101.331 Y112.449 E.02485
G1 X98.669 Y122.385 E.30542
G1 X98.669 Y123.416 E.0306
G1 X101.331 Y122.702 E.08185
G1 X101.331 Y122.856 E.00456
G1 X98.669 Y120.193 E.1118
G1 X98.669 Y118.765 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.155 J.382 P1  F42000
G1 X101.331 Y126.819 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.331 Y128.247 E.04241
G1 X98.668 Y128.961 E.08186
G1 X98.668 Y127.768 E.03543
G1 X101.332 Y130.431 E.11182
G1 X101.332 Y133.141 E.08048
G1 X98.668 Y143.082 E.30556
G1 X98.668 Y142.917 E.00491
G1 X101.332 Y145.581 E.11186
G1 X101.332 Y144.883 E.02073
G1 X98.668 Y145.596 E.08189
G1 X98.668 Y147.025 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-.725 J.978 P1  F42000
G1 X101.332 Y148.999 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.332 Y150.428 E.04241
G1 X98.668 Y151.142 E.0819
G1 X98.668 Y150.491 E.01931
G1 X101.332 Y153.156 E.11188
G1 X101.332 Y153.834 E.02013
G1 X100.703 Y156.184 E.07224
G1 X100.544 Y156.184 E.00469
G1 X101.332 Y155.973 E.02422
G1 X101.332 Y154.937 E.03074
M204 S500
G1 X101.771 Y156.049 F42000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56345
G1 F1152.671
M204 S6000
G1 X101.768 Y44.015 E4.84906
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.217 J-.006 P1  F42000
G1 X101.332 Y133.792 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X98.668 Y134.506 E.08187
G1 X98.668 Y135.342 E.02483
G1 X101.332 Y138.006 E.11184
G1 X101.332 Y139.338 E.03954
G1 X98.668 Y140.051 E.08188
G1 X98.668 Y138.623 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I-1.217 J-.031 P1  F42000
G1 X98.229 Y156.049 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.56352
G1 F1152.516
M204 S6000
G1 X98.232 Y44.015 E4.84971
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 7/45
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z1.6 I.144 J1.208 P1  F42000
G1 X102.407 Y43.516 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.407 Y45.923 E.07147
G1 X102.409 Y156.487 E3.2827
G1 X97.591 Y156.487 E.14307
G1 X97.593 Y43.516 E3.35417
G1 X102.347 Y43.516 E.14115
M204 S500
G1 X102.764 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.764 Y45.923 E.08207
G1 X102.766 Y156.845 E3.2933
G1 X102.686 Y156.845 E.00238
G1 X102.606 Y156.845 E.00238
G1 X97.394 Y156.845 E.15477
G1 X97.314 Y156.845 E.00238
G1 X97.234 Y156.845 E.00238
G1 X97.236 Y43.159 E3.37537
G1 X97.316 Y43.159 E.00238
G1 X97.396 Y43.159 E.00238
G1 X102.604 Y43.159 E.15463
G1 X102.684 Y43.159 E.00238
G1 X102.704 Y43.159 E.00059
G1 E-.8 F1800
G17
G3 Z1.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.8 F4000
            G39.3 S1
            G0 Z1.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.517 Y43.82 F42000
G1 Z1.4
M73 P30 R27
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.628 Y43.82 E.00329
G1 X101.628 Y45.137 E.03912
G1 X98.372 Y46.01 E.1001
G1 X98.372 Y43.948 E.06121
G1 X101.628 Y47.205 E.13674
G1 X101.628 Y48.709 E.04466
G1 X98.371 Y60.864 E.37363
G1 X98.371 Y62.645 E.05289
G1 X101.629 Y61.773 E.10012
G1 X101.629 Y62.355 E.01728
G1 X98.371 Y59.097 E.13677
G1 X98.371 Y57.1 E.0593
G1 X101.628 Y56.227 E.10012
G1 X101.628 Y54.78 E.04299
G1 X98.372 Y51.523 E.13675
G1 X98.372 Y51.555 E.00096
G1 X101.628 Y50.682 E.10011
G1 X101.628 Y52.111 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-1.217 J0 P1  F42000
G1 X101.629 Y69.93 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.371 Y66.672 E.13678
G1 X98.371 Y68.19 E.04508
G1 X101.629 Y67.318 E.10013
G1 X101.629 Y69.402 E.06189
G1 X98.371 Y81.56 E.37373
G1 X98.371 Y81.821 E.00775
G1 X101.629 Y85.079 E.13681
G1 X101.629 Y83.953 E.03345
G1 X98.371 Y84.826 E.10015
G1 X98.371 Y86.254 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I1.217 J0 P1  F42000
G1 X98.371 Y77.853 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.371 Y79.281 E.04241
G1 X101.629 Y78.408 E.10015
G1 X101.629 Y77.505 E.02682
G1 X98.371 Y74.247 E.1368
G1 X98.371 Y73.736 E.01517
G1 X101.629 Y72.863 E.10014
G1 X101.629 Y74.291 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-1.208 J-.145 P1  F42000
G1 X98.37 Y101.461 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.629 Y100.588 E.10018
G1 X101.629 Y100.229 E.01065
G1 X98.371 Y96.971 E.13684
M73 P31 R27
G1 X98.371 Y95.916 E.0313
G1 X101.629 Y95.043 E.10017
G1 X101.629 Y92.654 E.07092
G1 X98.371 Y89.396 E.13682
G1 X98.371 Y90.371 E.02896
G1 X101.629 Y89.498 E.10016
G1 X101.629 Y90.095 E.01772
G1 X98.37 Y102.257 E.37384
G1 X98.37 Y104.545 E.06795
G1 X101.63 Y107.804 E.13685
G1 X101.63 Y106.133 E.04961
G1 X98.37 Y107.007 E.10018
G1 X98.37 Y108.435 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-.332 J1.171 P1  F42000
G1 X101.63 Y109.36 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.63 Y110.788 E.04241
G1 X98.37 Y122.953 E.37394
G1 X98.37 Y123.642 E.02046
G1 X101.63 Y122.769 E.10021
G1 X101.63 Y122.954 E.00551
G1 X98.37 Y119.694 E.13688
G1 X98.37 Y118.097 E.04743
G1 X101.63 Y117.224 E.1002
G1 X101.63 Y115.379 E.05476
G1 X98.37 Y112.12 E.13687
G1 X98.37 Y112.552 E.01283
G1 X101.63 Y111.678 E.10019
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-1.217 J0 P1  F42000
G1 X101.63 Y126.885 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.63 Y128.314 E.04241
G1 X98.37 Y129.187 E.10021
G1 X98.37 Y127.269 E.05695
G1 X101.63 Y130.529 E.13689
G1 X101.63 Y131.481 E.02826
G1 X98.37 Y143.65 E.37404
G1 X98.37 Y145.823 E.06453
G1 X101.63 Y144.949 E.10024
G1 X101.63 Y145.679 E.02168
G1 X98.37 Y142.418 E.13692
G1 X98.37 Y140.278 E.06356
G1 X101.63 Y139.404 E.10023
G1 X101.63 Y138.104 E.03859
G1 X98.37 Y134.844 E.13691
G1 X98.37 Y134.733 E.0033
G1 X101.63 Y133.859 E.10022
G1 X101.63 Y135.287 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-1.217 J0 P1  F42000
G1 X101.631 Y153.254 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.369 Y149.993 E.13694
G1 X98.369 Y151.368 E.04083
G1 X101.631 Y150.494 E.10024
G1 X101.631 Y152.174 E.04988
G1 X100.556 Y156.184 E.12326
G1 X101.091 Y156.184 E.01588
G1 X101.631 Y156.039 E.01659
G1 X101.631 Y154.611 E.04241
M204 S500
G1 X102.02 Y156.098 F42000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.46471
G1 F1422.509
M204 S6000
G1 X102.018 Y43.966 E3.9327
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I-1.216 J-.044 P1  F42000
G1 X97.98 Y156.098 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.46472
G1 F1422.475
M204 S6000
G1 X97.982 Y43.966 E3.9328
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 8/45
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z1.8 I.118 J1.211 P1  F42000
G1 X102.594 Y43.516 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.594 Y46.11 E.07702
G1 X102.596 Y156.487 E3.27715
G1 X97.404 Y156.487 E.15413
G1 X97.406 Y43.516 E3.35417
G1 X102.534 Y43.516 E.15226
M204 S500
G1 X102.951 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.951 Y46.11 E.08762
G1 X102.953 Y156.845 E3.28775
G1 X102.886 Y156.845 E.00197
G1 X102.806 Y156.845 E.00238
G1 X97.194 Y156.845 E.16665
G1 X97.114 Y156.845 E.00238
G1 X97.047 Y156.845 E.00197
G1 X97.049 Y43.159 E3.37537
G1 X97.116 Y43.159 E.00199
G1 X97.196 Y43.159 E.00238
G1 X102.804 Y43.159 E.16651
G1 X102.884 Y43.159 E.00238
G1 X102.891 Y43.159 E.00021
G1 E-.8 F1800
G17
G3 Z2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2 F4000
            G39.3 S1
            G0 Z2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.81 Y43.82 F42000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.828 Y43.82 E.00054
G1 X101.828 Y45.23 E.04187
G1 X98.171 Y46.21 E.11241
G1 X98.172 Y43.82 E.07097
G1 X98.443 Y43.82 E.00807
G1 X101.828 Y47.205 E.14214
G1 X101.828 Y47.415 E.00625
M73 P32 R27
G1 X98.171 Y61.065 E.41956
G1 X98.171 Y62.845 E.05287
G1 X101.829 Y61.865 E.11243
G1 X101.829 Y62.355 E.01453
G1 X98.171 Y58.697 E.15358
G1 X98.171 Y57.3 E.04148
G1 X101.829 Y56.32 E.11242
G1 X101.829 Y54.78 E.04574
M73 P32 R26
G1 X98.171 Y51.123 E.15357
G1 X98.171 Y51.755 E.01878
G1 X101.829 Y50.775 E.11242
G1 X101.829 Y52.203 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I-1.205 J-.171 P1  F42000
G1 X98.171 Y78.053 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.171 Y79.481 E.04241
G1 X101.829 Y78.501 E.11245
G1 X101.829 Y77.505 E.02957
G1 X98.171 Y73.847 E.15361
G1 X98.171 Y73.936 E.00265
G1 X101.829 Y72.956 E.11245
G1 X101.829 Y69.93 E.08984
G1 X98.171 Y66.272 E.15359
G1 X98.171 Y68.391 E.06291
G1 X101.829 Y67.41 E.11244
G1 X101.829 Y68.109 E.02073
G1 X98.171 Y81.761 E.41966
G1 X98.171 Y81.421 E.01009
G1 X101.829 Y85.08 E.15362
G1 X101.829 Y84.046 E.0307
G1 X98.171 Y85.026 E.11246
G1 X98.171 Y86.454 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I-.296 J1.18 P1  F42000
G1 X101.829 Y87.373 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.829 Y88.802 E.04241
G1 X98.17 Y102.457 E.41975
G1 X98.17 Y104.145 E.05011
G1 X101.83 Y107.804 E.15366
G1 X101.83 Y106.226 E.04686
G1 X98.17 Y107.207 E.11249
G1 X98.17 Y108.635 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I.187 J1.203 P1  F42000
G1 X101.83 Y108.067 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.83 Y109.495 E.04241
G1 X98.17 Y123.154 E.41985
G1 X98.17 Y123.842 E.02045
G1 X101.83 Y122.861 E.11251
G1 X101.83 Y122.954 E.00276
G1 X98.17 Y119.294 E.15368
M73 P33 R26
G1 X98.17 Y118.297 E.02961
G1 X101.83 Y117.316 E.1125
G1 X101.83 Y115.379 E.05751
G1 X98.17 Y111.72 E.15367
G1 X98.17 Y112.752 E.03065
G1 X101.83 Y111.771 E.11249
G1 X101.83 Y113.2 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I1.16 J-.368 P1  F42000
G1 X98.17 Y101.662 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.83 Y100.681 E.11248
G1 X101.83 Y100.23 E.01341
G1 X98.17 Y96.57 E.15365
G1 X98.17 Y96.116 E.01348
G1 X101.829 Y95.136 E.11247
G1 X101.829 Y92.655 E.07368
G1 X98.171 Y88.996 E.15363
G1 X98.171 Y90.571 E.04678
G1 X101.829 Y89.591 E.11247
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I-1.217 J0 P1  F42000
G1 X101.83 Y126.978 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.83 Y128.407 E.04241
G1 X98.17 Y129.387 E.11251
G1 X98.17 Y126.869 E.07477
G1 X101.83 Y130.529 E.1537
G1 X101.83 Y130.188 E.01014
G1 X98.169 Y143.85 E.41995
G1 X98.169 Y146.023 E.06452
G1 X101.83 Y145.042 E.11253
G1 X101.83 Y145.679 E.01892
G1 X98.17 Y142.018 E.15372
G1 X98.17 Y140.478 E.04574
G1 X101.83 Y139.497 E.11253
G1 X101.83 Y138.104 E.04135
G1 X98.17 Y134.444 E.15371
G1 X98.17 Y134.933 E.01452
G1 X101.83 Y133.952 E.11252
G1 X101.83 Y135.38 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I-1.217 J0 P1  F42000
G1 X101.831 Y154.682 Z2
G1 Z1.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.831 Y153.254 E.04241
G1 X98.169 Y149.593 E.15374
G1 X98.169 Y151.568 E.05864
G1 X101.831 Y150.587 E.11254
G1 X101.831 Y150.881 E.00873
G1 X100.41 Y156.184 E.163
G1 X98.981 Y156.184 E.04241
M204 S500
G1 X97.787 Y156.105 F42000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45119
G1 F1469.616
M204 S6000
G1 X97.789 Y43.959 E3.8071
G1 E-.8 F1800
M204 S500
G17
G3 Z2 I-1.216 J.048 P1  F42000
G1 X102.213 Y156.105 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.45117
G1 F1469.688
M204 S6000
G1 X102.211 Y43.959 E3.80692
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/45
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 14
M204 S500
G1 X102.728 Y43.516 Z1.8 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.728 Y46.244 E.08099
G1 X102.729 Y156.487 E3.27318
G1 X97.271 Y156.487 E.16206
G1 X97.272 Y43.516 E3.35417
G1 X102.668 Y43.516 E.16019
M204 S500
G1 X103.085 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.085 Y46.244 E.09159
G1 X103.086 Y156.845 E3.28378
G1 X103.073 Y156.845 E.00041
G1 X102.993 Y156.845 E.00238
G1 X97.007 Y156.845 E.17771
G1 X96.927 Y156.845 E.00238
G1 X96.914 Y156.845 E.0004
G1 X96.915 Y43.159 E3.37537
G1 X96.929 Y43.159 E.0004
G1 X97.009 Y43.159 E.00238
G1 X102.991 Y43.159 E.17761
G1 X103.025 Y43.159 E.001
G1 E-.8 F1800
G17
G3 Z2.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.2 F4000
            G39.3 S1
            G0 Z2.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.029 Y47.205 F42000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X98.643 Y43.82 E.14214
G1 X97.971 Y43.82 E.01995
G1 X97.971 Y46.41 E.0769
G1 X102.028 Y45.323 E.12471
G1 X102.028 Y46.123 E.02374
G1 X97.971 Y61.265 E.46545
G1 X97.971 Y63.045 E.05287
G1 X102.029 Y61.958 E.12473
G1 X102.029 Y62.355 E.01178
G1 X97.971 Y58.297 E.17038
G1 X97.971 Y57.5 E.02366
M73 P34 R26
G1 X102.029 Y56.413 E.12472
G1 X102.029 Y54.78 E.04849
G1 X97.971 Y50.723 E.17037
G1 X97.971 Y51.955 E.03659
G1 X102.029 Y50.868 E.12471
G1 X102.029 Y52.296 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.217 J0 P1  F42000
G1 X102.029 Y65.387 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.029 Y66.816 E.04241
G1 X97.971 Y81.961 E.46555
G1 X97.971 Y85.226 E.09694
G1 X102.029 Y84.139 E.12476
G1 X102.029 Y85.08 E.02794
G1 X97.971 Y81.021 E.17042
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I1.217 J0 P1  F42000
G1 X97.971 Y78.253 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.971 Y79.681 E.04241
G1 X102.029 Y78.593 E.12475
G1 X102.029 Y77.505 E.03233
G1 X97.971 Y73.446 E.1704
G1 X97.971 Y74.136 E.02046
G1 X102.029 Y73.048 E.12474
G1 X102.029 Y69.93 E.09259
G1 X97.971 Y65.872 E.17039
G1 X97.971 Y68.591 E.08072
G1 X102.029 Y67.503 E.12474
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.217 J0 P1  F42000
G1 X102.029 Y86.081 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.029 Y87.509 E.04241
G1 X97.97 Y102.657 E.46565
G1 X97.97 Y103.745 E.0323
G1 X102.03 Y107.805 E.17046
G1 X102.03 Y108.202 E.0118
G1 X97.97 Y123.354 E.46574
G1 X97.97 Y124.042 E.02044
G1 X102.03 Y122.954 E.1248
G1 X97.97 Y118.894 E.17048
G1 X97.97 Y118.497 E.0118
G1 X102.03 Y117.409 E.1248
G1 X102.03 Y115.379 E.06026
G1 X97.97 Y111.32 E.17047
G1 X97.97 Y112.952 E.04846
G1 X102.03 Y111.864 E.12479
G1 X102.03 Y113.292 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I.9 J-.819 P1  F42000
G1 X97.97 Y108.835 Z2.2
G1 Z1.8
G1 E.8 F1800
M73 P35 R26
G1 F1680.297
M204 S6000
G1 X97.97 Y107.407 E.04241
G1 X102.03 Y106.319 E.12478
G1 X102.03 Y104.891 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P35 R25
G3 Z2.2 I.728 J-.975 P1  F42000
G1 X97.97 Y101.862 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.03 Y100.774 E.12478
G1 X102.03 Y100.23 E.01616
G1 X97.97 Y96.17 E.17044
G1 X97.97 Y96.316 E.00433
G1 X102.029 Y95.229 E.12477
G1 X102.029 Y92.655 E.07643
G1 X97.971 Y88.596 E.17043
G1 X97.971 Y90.771 E.06459
G1 X102.029 Y89.684 E.12476
G1 X102.029 Y91.112 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.217 J0 P1  F42000
G1 X102.03 Y131.958 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.03 Y130.529 E.04241
G1 X97.97 Y126.469 E.17049
G1 X97.97 Y129.587 E.09259
G1 X102.03 Y128.499 E.12481
G1 X102.03 Y128.895 E.01175
G1 X97.969 Y144.05 E.46584
G1 X97.969 Y146.223 E.06452
G1 X102.03 Y145.135 E.12483
G1 X102.031 Y145.679 E.01617
G1 X97.97 Y141.618 E.17052
G1 X97.97 Y140.678 E.02793
G1 X102.03 Y139.59 E.12483
G1 X102.03 Y138.104 E.0441
G1 X97.97 Y134.044 E.17051
G1 X97.97 Y135.133 E.03233
G1 X102.03 Y134.045 E.12482
G1 X102.03 Y135.473 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.217 J0 P1  F42000
G1 X102.031 Y148.16 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.031 Y149.588 E.04241
G1 X100.263 Y156.184 E.20274
G1 X102.031 Y156.184 E.05248
G1 X102.031 Y153.254 E.08699
G1 X97.969 Y149.193 E.17053
G1 X97.969 Y151.768 E.07646
G1 X102.031 Y150.68 E.12484
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.214 J.078 P1  F42000
G1 X102.38 Y156.138 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38479
G1 F1755.053
M204 S6000
G1 X102.378 Y43.926 E3.18981
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I-1.216 J-.052 P1  F42000
G1 X97.62 Y156.138 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.38478
G1 F1755.105
M204 S6000
G1 X97.622 Y43.926 E3.18972
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 10/45
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z2.2 I.095 J1.213 P1  F42000
G1 X102.861 Y43.516 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.861 Y46.378 E.08495
G1 X102.863 Y156.487 E3.26922
G1 X97.137 Y156.487 E.17
G1 X97.139 Y43.516 E3.35417
G1 X102.801 Y43.516 E.16813
M204 S500
G1 X103.218 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.218 Y46.378 E.09556
G1 X103.22 Y156.845 E3.27982
G1 X103.206 Y156.845 E.00041
G1 X103.126 Y156.845 E.00238
G1 X96.874 Y156.845 E.18564
G1 X96.794 Y156.845 E.00238
G1 X96.78 Y156.845 E.0004
G1 X96.782 Y43.159 E3.37537
G1 X96.795 Y43.159 E.0004
G1 X96.875 Y43.159 E.00238
G1 X103.125 Y43.159 E.18555
G1 X103.158 Y43.159 E.001
G1 E-.8 F1800
G17
G3 Z2.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.4 F4000
            G39.3 S1
            G0 Z2.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.846 Y43.82 F42000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.215 Y43.82 E.01098
G1 X102.215 Y44.878 E.03143
G1 X97.784 Y61.416 E.50834
G1 X97.784 Y63.242 E.05422
G1 X102.216 Y62.054 E.13622
G1 X102.216 Y62.342 E.00853
G1 X97.784 Y57.91 E.18607
G1 X97.784 Y57.697 E.00634
G1 X102.216 Y56.509 E.13621
G1 X102.216 Y54.767 E.05174
G1 X97.784 Y50.336 E.18606
G1 X97.784 Y52.152 E.05392
G1 X102.215 Y50.964 E.13621
M73 P36 R25
G1 X102.215 Y47.192 E.11201
G1 X98.843 Y43.82 E.14159
G1 X97.784 Y43.82 E.03144
G1 X97.784 Y46.606 E.08274
G1 X102.215 Y45.419 E.1362
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.217 J0 P1  F42000
G1 X102.216 Y64.144 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.216 Y65.572 E.04241
G1 X97.784 Y82.112 E.5084
G1 X97.784 Y85.422 E.09831
G1 X102.216 Y84.235 E.13624
G1 X102.216 Y85.066 E.02469
G1 X97.784 Y80.634 E.1861
G1 X97.784 Y79.877 E.02248
G1 X102.216 Y78.69 E.13623
G1 X102.216 Y77.491 E.03558
G1 X97.784 Y73.06 E.18609
G1 X97.784 Y74.332 E.03778
G1 X102.216 Y73.145 E.13623
G1 X102.216 Y74.573 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I.853 J-.868 P1  F42000
G1 X97.784 Y70.215 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.784 Y68.787 E.04241
G1 X102.216 Y67.6 E.13622
G1 X102.216 Y69.917 E.06879
G1 X97.784 Y65.485 E.18608
G1 X97.784 Y66.913 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.183 J.286 P1  F42000
G1 X102.216 Y85.245 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.216 Y86.266 E.03031
G1 X97.784 Y102.807 E.50847
G1 X97.784 Y103.358 E.01636
G1 X102.216 Y107.791 E.18612
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.217 J0 P1  F42000
G1 X102.216 Y110.532 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.216 Y111.961 E.04241
G1 X97.784 Y113.148 E.13626
G1 X97.784 Y110.933 E.06577
G1 X102.216 Y115.366 E.18613
G1 X102.216 Y117.506 E.06353
G1 X97.783 Y118.693 E.13626
G1 X97.783 Y118.508 E.00551
M73 P37 R25
G1 X102.216 Y122.941 E.18614
G1 X102.216 Y123.051 E.00326
G1 X97.783 Y124.239 E.13627
G1 X97.783 Y123.503 E.02184
G1 X102.216 Y106.959 E.50853
G1 X102.216 Y106.415 E.01615
G1 X97.784 Y107.603 E.13625
G1 X97.784 Y106.175 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I1.217 J0 P1  F42000
G1 X97.784 Y102.058 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.216 Y100.87 E.13625
G1 X102.216 Y100.216 E.01942
G1 X97.784 Y95.784 E.18612
G1 X97.784 Y96.513 E.02165
G1 X102.216 Y95.325 E.13624
G1 X102.216 Y92.641 E.07969
G1 X97.784 Y88.209 E.18611
G1 X97.784 Y90.968 E.08191
G1 X102.216 Y89.78 E.13624
G1 X102.216 Y91.208 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.217 J0 P1  F42000
G1 X102.217 Y126.225 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.217 Y127.653 E.04241
G1 X97.783 Y144.199 E.5086
G1 X97.783 Y146.419 E.06592
G1 X102.217 Y145.231 E.13629
G1 X102.217 Y145.666 E.0129
G1 X97.783 Y141.232 E.18617
G1 X97.783 Y140.874 E.01063
G1 X102.217 Y139.686 E.13628
G1 X102.217 Y138.091 E.04737
G1 X97.783 Y133.657 E.18616
G1 X97.783 Y135.329 E.04963
G1 X102.217 Y134.141 E.13628
G1 X102.217 Y130.516 E.10764
G1 X97.783 Y126.083 E.18615
G1 X97.783 Y129.784 E.10989
G1 X102.217 Y128.596 E.13627
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.217 J0 P1  F42000
G1 X102.217 Y146.918 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.217 Y148.347 E.04241
G1 X100.117 Y156.184 E.2409
G1 X97.783 Y156.184 E.0693
G1 X97.783 Y151.964 E.12528
G1 X102.217 Y150.776 E.13629
G1 X102.217 Y153.24 E.07316
G1 X97.783 Y148.807 E.18618
G1 X97.783 Y150.235 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.215 J-.066 P1  F42000
G1 X97.46 Y156.164 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F1764.706
M204 S6000
G1 X97.462 Y43.899 E3.17386
G1 E-.8 F1800
M204 S500
G17
G3 Z2.4 I-1.216 J.055 P1  F42000
G1 X102.54 Y156.164 Z2.4
G1 Z2
G1 E.8 F1800
G1 F1764.706
M204 S6000
G1 X102.538 Y43.899 E3.17386
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 11/45
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 14
M204 S500
G1 X102.995 Y43.516 Z2.2 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.995 Y46.511 E.08892
G1 X102.996 Y156.487 E3.26525
G1 X97.004 Y156.487 E.17793
G1 X97.005 Y43.516 E3.35417
G1 X102.935 Y43.516 E.17606
M204 S500
G1 X103.352 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.352 Y46.511 E.09952
G1 X103.354 Y156.845 E3.27585
G1 X103.34 Y156.845 E.0004
G1 X103.26 Y156.845 E.00238
G1 X96.74 Y156.845 E.19358
G1 X96.66 Y156.845 E.00238
G1 X96.646 Y156.845 E.0004
M73 P37 R24
G1 X96.648 Y43.159 E3.37537
G1 X96.662 Y43.159 E.0004
G1 X96.742 Y43.159 E.00238
G1 X103.258 Y43.159 E.19349
G1 X103.292 Y43.159 E.001
G1 E-.8 F1800
G17
G3 Z2.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.6 F4000
            G39.3 S1
            G0 Z2.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X97.651 Y45.36 F42000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X97.651 Y46.789 E.04241
G1 X102.349 Y45.53 E.14442
G1 X102.349 Y47.126 E.04738
G1 X99.043 Y43.82 E.13881
G1 X102.349 Y43.82 E.09815
G1 X97.651 Y61.368 E.53938
G1 X97.651 Y62.796 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-.078 J1.214 P1  F42000
G1 X102.349 Y63.099 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.349 Y64.527 E.04241
M73 P38 R24
G1 X97.65 Y82.064 E.53906
G1 X97.65 Y83.492 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I.148 J1.208 P1  F42000
G1 X102.35 Y82.917 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.35 Y84.346 E.04241
G1 X97.65 Y85.605 E.14445
G1 X97.65 Y87.875 E.06742
G1 X102.35 Y92.575 E.19733
G1 X102.35 Y89.891 E.0797
G1 X97.65 Y91.15 E.14446
G1 X97.65 Y92.578 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-.82 J.899 P1  F42000
G1 X102.35 Y96.864 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.35 Y95.436 E.04241
G1 X97.65 Y96.695 E.14446
G1 X97.65 Y95.45 E.03696
G1 X102.35 Y100.15 E.19734
G1 X102.35 Y100.981 E.02467
G1 X97.65 Y102.24 E.14446
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-1.217 J0 P1  F42000
G1 X97.65 Y106.357 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.65 Y107.785 E.04241
G1 X102.35 Y106.526 E.14447
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I1.217 J0 P1  F42000
G1 X102.35 Y104.486 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.35 Y105.914 E.04241
G1 X97.65 Y123.455 E.53919
G1 X97.65 Y124.421 E.02866
G1 X102.35 Y123.161 E.14448
G1 X102.35 Y122.875 E.00852
G1 X97.65 Y118.174 E.19736
G1 X97.65 Y118.876 E.02082
G1 X102.35 Y117.616 E.14448
G1 X102.35 Y115.3 E.06878
M73 P39 R24
G1 X97.65 Y110.6 E.19736
G1 X97.65 Y113.33 E.08108
G1 X102.35 Y112.071 E.14447
G1 X102.35 Y107.725 E.12905
G1 X97.65 Y103.025 E.19735
G1 X97.65 Y102.76 E.00788
G1 X102.35 Y85.221 E.53913
G1 X102.35 Y85 E.00655
G1 X97.65 Y80.301 E.19732
G1 X97.65 Y80.06 E.00716
G1 X102.35 Y78.8 E.14445
G1 X102.35 Y77.425 E.04083
G1 X97.65 Y72.726 E.19731
G1 X97.65 Y74.514 E.0531
G1 X102.349 Y73.255 E.14444
G1 X102.349 Y74.684 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I1.017 J-.669 P1  F42000
G1 X97.651 Y67.541 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.651 Y68.969 E.04241
G1 X102.349 Y67.71 E.14444
G1 X102.349 Y69.85 E.06354
G1 X97.651 Y65.151 E.1973
G1 X97.651 Y63.424 E.05129
G1 X102.349 Y62.165 E.14443
G1 X102.349 Y62.275 E.00327
G1 X97.651 Y57.577 E.19729
G1 X97.651 Y57.879 E.00897
G1 X102.349 Y56.62 E.14443
G1 X102.349 Y54.7 E.05699
G1 X97.651 Y50.002 E.19729
G1 X97.651 Y52.334 E.06923
G1 X102.349 Y51.075 E.14442
G1 X102.349 Y49.647 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-1.217 J0 P1  F42000
G1 X102.35 Y125.18 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.35 Y126.608 E.04241
G1 X97.65 Y144.151 E.53925
G1 X97.65 Y145.579 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-.076 J1.215 P1  F42000
G1 X102.35 Y145.873 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.35 Y147.302 E.04241
G1 X99.97 Y156.184 E.27303
G1 X97.786 Y156.184 E.06487
G1 X97.649 Y156.048 E.00572
G1 X97.649 Y152.147 E.11583
G1 X102.351 Y150.887 E.14451
G1 X102.351 Y153.174 E.06791
G1 X97.649 Y148.473 E.1974
G1 X97.649 Y146.601 E.05557
G1 X102.35 Y145.342 E.1445
G1 X102.35 Y145.599 E.00764
G1 X97.65 Y140.898 E.19739
G1 X97.65 Y141.056 E.00469
G1 X102.35 Y139.797 E.1445
G1 X102.35 Y138.024 E.05262
G1 X97.65 Y133.324 E.19738
G1 X97.65 Y135.511 E.06495
G1 X102.35 Y134.252 E.14449
G1 X102.35 Y132.823 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I.354 J-1.164 P1  F42000
G1 X97.65 Y131.394 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.65 Y129.966 E.04241
G1 X102.35 Y128.706 E.14449
G1 X102.35 Y130.449 E.05175
G1 X97.65 Y125.749 E.19737
G1 X97.65 Y127.177 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-1.217 J-.014 P1  F42000
G1 X97.327 Y156.164 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F1764.706
M204 S6000
G1 X97.328 Y43.899 E3.17386
G1 E-.8 F1800
M204 S500
G17
G3 Z2.6 I-1.216 J.058 P1  F42000
G1 X102.673 Y156.164 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F1764.706
M204 S6000
G1 X102.672 Y43.899 E3.17386
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 12/45
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
M106 S181.05
; OBJECT_ID: 14
M204 S500
G1 X103.083 Y43.516 Z2.4 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.083 Y46.599 E.09153
G1 X103.084 Y156.487 E3.26264
G1 X96.916 Y156.487 E.18311
G1 X96.917 Y43.516 E3.35417
G1 X103.023 Y43.516 E.18128
M204 S500
G1 X103.44 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.44 Y46.599 E.10213
G1 X103.441 Y156.845 E3.27324
G1 X103.394 Y156.845 E.0014
G1 X96.606 Y156.845 E.20151
G1 X96.559 Y156.845 E.0014
G1 X96.56 Y43.159 E3.37537
G1 X96.608 Y43.159 E.00142
G1 X103.38 Y43.159 E.20106
G1 E-.8 F1800
G17
G3 Z2.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.8 F4000
            G39.3 S1
            G0 Z2.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.779 Y52.534 F42000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.779 Y51.106 E.04241
G1 X97.221 Y52.595 E.17087
G1 X97.221 Y54.024 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-.939 J.774 P1  F42000
G1 X102.779 Y60.768 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.779 Y62.196 E.04241
G1 X97.221 Y63.686 E.17087
G1 X97.221 Y64.521 E.02481
G1 X102.779 Y70.08 E.23342
G1 X102.779 Y67.741 E.06945
G1 X97.22 Y69.231 E.17088
G1 X97.221 Y67.803 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P40 R23
G3 Z2.8 I1.217 J0 P1  F42000
G1 X97.221 Y63.507 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.221 Y62.427 E.03208
G1 X102.206 Y43.82 E.57195
G1 X99.243 Y43.82 E.08797
G1 X102.779 Y47.356 E.14847
G1 X102.779 Y45.561 E.05329
G1 X97.221 Y47.05 E.17086
G1 X97.221 Y49.372 E.06893
G1 X102.779 Y54.931 E.23341
G1 X102.779 Y56.651 E.05108
G1 X97.221 Y58.141 E.17087
G1 X97.221 Y56.947 E.03545
G1 X102.779 Y62.505 E.23341
G1 X102.779 Y62.375 E.00386
G1 X97.22 Y83.122 E.63772
G1 X97.22 Y84.55 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-1.217 J0 P1  F42000
G1 X97.22 Y89.983 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.22 Y91.411 E.04241
G1 X102.78 Y89.922 E.17089
G1 X102.78 Y88.494 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I1.217 J0 P1  F42000
G1 X102.78 Y81.641 Z2.8
M73 P41 R23
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.78 Y83.07 E.04241
G1 X97.22 Y103.817 E.63776
G1 X97.22 Y105.246 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I.564 J1.078 P1  F42000
G1 X102.78 Y102.335 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.78 Y103.764 E.04241
G1 X97.22 Y124.513 E.6378
G1 X97.22 Y124.682 E.00503
G1 X102.78 Y123.193 E.1709
G1 X102.78 Y123.104 E.00262
G1 X97.22 Y117.544 E.23346
G1 X97.22 Y119.137 E.04729
G1 X102.78 Y117.647 E.1709
G1 X102.78 Y115.529 E.06289
G1 X97.22 Y109.97 E.23345
G1 X97.22 Y108.047 E.05709
G1 X102.78 Y106.557 E.1709
G1 X102.78 Y107.955 E.04149
G1 X97.22 Y102.395 E.23345
G1 X97.22 Y102.502 E.00317
G1 X102.78 Y101.012 E.17089
G1 X102.78 Y100.38 E.01878
G1 X97.22 Y94.82 E.23344
G1 X97.22 Y96.957 E.06343
G1 X102.78 Y95.467 E.17089
G1 X102.78 Y92.805 E.07904
G1 X97.22 Y87.246 E.23344
G1 X97.22 Y85.866 E.04095
G1 X102.78 Y84.377 E.17088
G1 X102.78 Y85.23 E.02534
G1 X97.22 Y79.671 E.23343
G1 X97.22 Y80.321 E.01931
G1 X102.78 Y78.832 E.17088
G1 X102.78 Y77.655 E.03493
G1 X97.22 Y72.096 E.23343
G1 X97.22 Y74.776 E.07957
G1 X102.78 Y73.286 E.17088
G1 X102.78 Y74.715 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-1.217 J0 P1  F42000
G1 X102.78 Y110.674 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.78 Y112.102 E.04241
G1 X97.22 Y113.592 E.1709
G1 X97.22 Y115.02 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-1.217 J0 P1  F42000
G1 X97.22 Y137.201 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.22 Y135.773 E.04241
G1 X102.78 Y134.283 E.17091
G1 X102.78 Y135.711 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-1.217 J0 P1  F42000
G1 X102.78 Y145.829 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.22 Y140.269 E.23347
G1 X97.22 Y141.318 E.03115
G1 X102.78 Y139.828 E.17091
G1 X102.78 Y138.254 E.04673
G1 X97.22 Y132.694 E.23347
G1 X97.22 Y130.228 E.07323
G1 X102.78 Y128.738 E.17091
G1 X102.78 Y130.679 E.05765
G1 X97.22 Y125.119 E.23346
G1 X97.22 Y126.548 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I.604 J1.057 P1  F42000
G1 X102.78 Y123.371 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.78 Y124.458 E.03226
G1 X97.22 Y145.208 E.63784
G1 X97.22 Y146.637 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I-1.217 J0 P1  F42000
G1 X97.22 Y150.98 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.22 Y152.408 E.04241
G1 X102.78 Y150.918 E.17092
G1 X102.78 Y153.404 E.0738
G1 X97.22 Y147.843 E.23348
G1 X97.22 Y146.863 E.02911
G1 X102.78 Y145.373 E.17092
G1 X102.78 Y145.152 E.00657
G1 X99.824 Y156.184 E.33911
G1 X97.986 Y156.184 E.05459
G1 X97.22 Y155.418 E.03216
G1 X97.22 Y153.99 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 13/45
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z2.8 I1.215 J.065 P1  F42000
G1 X103.166 Y43.516 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.166 Y46.682 E.09399
G1 X103.167 Y156.487 E3.26018
G1 X96.833 Y156.487 E.18803
G1 X96.834 Y43.516 E3.35417
G1 X103.106 Y43.516 E.1862
M204 S500
G1 X103.523 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.523 Y46.682 E.10459
G1 X103.524 Y156.845 E3.27078
G1 X103.481 Y156.845 E.00127
G1 X96.519 Y156.845 E.20669
G1 X96.476 Y156.845 E.00127
G1 X96.477 Y43.159 E3.37537
G1 X96.52 Y43.159 E.00127
G1 X103.463 Y43.159 E.20613
G1 E-.8 F1800
G17
G3 Z3 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3 F4000
            G39.3 S1
            G0 Z3 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.862 Y49.802 F42000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.862 Y51.23 E.04241
G1 X97.138 Y52.764 E.17596
G1 X97.138 Y54.192 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-.873 J.847 P1  F42000
G1 X102.862 Y60.092 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.862 Y61.52 E.04241
G1 X97.138 Y82.885 E.65673
G1 X97.138 Y84.313 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
G1 X97.137 Y90.152 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.137 Y91.58 E.04241
G1 X102.863 Y90.046 E.17598
G1 X102.863 Y92.688 E.07844
G1 X97.137 Y86.963 E.24039
M73 P42 R23
G1 X97.137 Y86.035 E.02755
G1 X102.862 Y84.501 E.17598
G1 X102.862 Y85.113 E.01817
G1 X97.138 Y79.388 E.24039
G1 X97.138 Y80.49 E.03272
G1 X102.862 Y78.956 E.17598
G1 X102.862 Y77.538 E.0421
G1 X97.138 Y71.813 E.24038
M73 P42 R22
G1 X97.138 Y69.399 E.07167
G1 X102.862 Y67.866 E.17597
G1 X102.862 Y69.963 E.06228
G1 X97.138 Y64.238 E.24038
G1 X97.138 Y63.854 E.01141
G1 X102.862 Y62.32 E.17597
M204 S500
G1 X102.862 Y62.388 F42000
G1 F1680.297
M204 S6000
G1 X97.138 Y56.664 E.24037
G1 X97.138 Y58.309 E.04886
G1 X102.862 Y56.775 E.17596
G1 X102.862 Y54.813 E.05825
G1 X97.138 Y49.089 E.24037
G1 X97.138 Y47.219 E.05553
G1 X102.862 Y45.685 E.17596
G1 X102.862 Y47.239 E.04613
G1 X99.443 Y43.82 E.14356
G1 X102.06 Y43.82 E.07769
G1 X97.138 Y62.19 E.56467
G1 X97.138 Y63.618 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
G1 X97.138 Y76.373 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.138 Y74.945 E.04241
G1 X102.862 Y73.411 E.17597
G1 X102.862 Y74.839 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
G1 X102.862 Y80.786 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.862 Y82.214 E.04241
G1 X97.137 Y103.58 E.65677
G1 X97.137 Y105.009 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
M73 P43 R22
G1 X97.137 Y112.332 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.137 Y113.761 E.04241
G1 X102.863 Y112.227 E.17599
G1 X102.863 Y110.798 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
G1 X102.863 Y121.559 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.863 Y122.987 E.04241
G1 X97.137 Y117.262 E.24042
G1 X97.137 Y119.306 E.0607
G1 X102.863 Y117.772 E.176
G1 X102.863 Y115.412 E.07005
G1 X97.137 Y109.687 E.24041
G1 X97.137 Y108.216 E.04369
G1 X102.863 Y106.681 E.17599
G1 X102.863 Y107.837 E.03432
G1 X97.137 Y102.112 E.24041
G1 X97.137 Y100.684 E.04241
M204 S500
G1 X97.137 Y102.67 F42000
G1 F1680.297
M204 S6000
G1 X102.863 Y101.136 E.17599
G1 X102.863 Y100.263 E.02594
G1 X97.137 Y94.537 E.2404
G1 X97.137 Y97.125 E.07684
G1 X102.863 Y95.591 E.17598
G1 X102.863 Y97.019 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.217 J0 P1  F42000
G1 X102.863 Y101.48 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.863 Y102.908 E.04241
G1 X97.137 Y124.276 E.65681
G1 X97.137 Y124.658 E.01134
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-1.003 J.69 P1  F42000
G1 X102.863 Y132.979 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.863 Y134.407 E.04241
G1 X97.137 Y135.941 E.176
G1 X97.137 Y137.37 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I-.843 J.878 P1  F42000
G1 X102.863 Y142.868 Z3
G1 Z2.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.863 Y144.296 E.04241
G1 X99.678 Y156.184 E.36541
G1 X98.186 Y156.184 E.0443
G1 X97.137 Y155.135 E.04403
G1 X97.137 Y152.577 E.07597
G1 X102.863 Y151.042 E.17601
G1 X102.863 Y153.287 E.06663
G1 X97.137 Y147.561 E.24044
G1 X97.137 Y147.032 E.01571
G1 X102.863 Y145.497 E.17601
G1 X102.863 Y145.712 E.00637
G1 X97.137 Y139.986 E.24043
G1 X97.137 Y141.486 E.04455
G1 X102.863 Y139.952 E.17601
G1 X102.863 Y138.137 E.0539
G1 X97.137 Y132.411 E.24043
G1 X97.137 Y130.396 E.05983
G1 X102.863 Y128.862 E.176
G1 X102.863 Y130.562 E.05048
G1 X97.137 Y124.836 E.24042
G1 X97.137 Y124.851 E.00043
G1 X102.863 Y123.317 E.176
G1 X102.863 Y123.602 E.00847
G1 X97.137 Y144.971 E.65685
G1 X97.137 Y146.399 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 14/45
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z3 I1.215 J.072 P1  F42000
G1 X103.248 Y43.516 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.248 Y46.765 E.09645
G1 X103.249 Y156.487 E3.25772
G1 X96.751 Y156.487 E.19296
G1 X96.751 Y43.516 E3.35417
G1 X103.188 Y43.516 E.19112
M204 S500
G1 X103.606 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.606 Y46.765 E.10705
G1 X103.606 Y156.845 E3.26832
G1 X103.564 Y156.845 E.00127
G1 X96.436 Y156.845 E.21161
G1 X96.393 Y156.845 E.00127
G1 X96.394 Y43.159 E3.37537
G1 X96.437 Y43.159 E.00127
G1 X103.546 Y43.159 E.21105
G1 E-.8 F1800
G17
G3 Z3.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.2 F4000
            G39.3 S1
            G0 Z3.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.945 Y49.926 F42000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.945 Y51.354 E.04241
G1 X97.055 Y52.933 E.18105
G1 X97.055 Y51.504 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I-1.217 J0 P1  F42000
G1 X97.055 Y76.542 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.055 Y75.113 E.04241
G1 X102.945 Y73.535 E.18107
G1 X102.945 Y74.963 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I-1.217 J0 P1  F42000
G1 X102.945 Y79.93 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.945 Y81.358 E.04241
G1 X97.054 Y103.343 E.67578
G1 X97.054 Y104.772 E.04241
M204 S500
G1 X97.054 Y102.839 F42000
G1 F1680.297
M204 S6000
G1 X102.945 Y101.261 E.18108
G1 X102.945 Y102.052 E.02351
M73 P44 R22
G1 X97.054 Y124.039 E.67582
G1 X97.054 Y124.375 E.00999
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I.191 J1.202 P1  F42000
G1 X102.946 Y123.441 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.054 Y125.02 E.18109
G1 X97.054 Y124.553 E.01384
G1 X102.946 Y130.445 E.24738
G1 X102.946 Y128.986 E.04331
G1 X97.054 Y130.565 E.1811
G1 X97.054 Y132.128 E.04642
G1 X102.946 Y138.02 E.24738
G1 X102.946 Y140.076 E.06106
G1 X97.054 Y141.655 E.1811
G1 X97.054 Y139.703 E.05796
G1 X102.946 Y145.595 E.24739
G1 X102.946 Y145.621 E.0008
G1 X97.054 Y147.2 E.1811
G1 X97.054 Y147.278 E.0023
G1 X102.946 Y153.169 E.24739
G1 X102.946 Y151.167 E.05947
G1 X97.054 Y152.745 E.18111
G1 X97.054 Y154.852 E.06256
G1 X98.386 Y156.184 E.05591
G1 X99.531 Y156.184 E.03402
G1 X102.946 Y143.441 E.39171
G1 X102.946 Y142.012 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I-.701 J-.995 P1  F42000
G1 X97.054 Y146.162 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.054 Y144.734 E.04241
G1 X102.946 Y122.747 E.67586
G1 X102.946 Y122.87 E.00367
G1 X97.054 Y116.979 E.24737
G1 X97.054 Y119.474 E.0741
G1 X102.946 Y117.896 E.18109
G1 X102.946 Y115.295 E.07722
G1 X97.054 Y109.404 E.24737
G1 X97.054 Y108.384 E.03028
G1 X102.945 Y106.806 E.18108
G1 X102.946 Y107.72 E.02716
G1 X97.054 Y101.829 E.24736
G1 X97.055 Y97.294 E.13466
G1 X102.945 Y95.715 E.18108
G1 X102.945 Y100.145 E.13153
G1 X97.055 Y94.255 E.24736
G1 X97.055 Y91.749 E.0744
G1 X102.945 Y90.17 E.18108
G1 X102.945 Y92.571 E.07127
G1 X97.055 Y86.68 E.24735
G1 X97.055 Y86.204 E.01414
G1 X102.945 Y84.625 E.18107
G1 X102.945 Y84.996 E.011
G1 X97.055 Y79.105 E.24735
G1 X97.055 Y80.658 E.04612
G1 X102.945 Y79.08 E.18107
G1 X102.945 Y77.421 E.04926
G1 X97.055 Y71.53 E.24734
G1 X97.055 Y69.568 E.05826
G1 X102.945 Y67.99 E.18106
G1 X102.945 Y69.846 E.05511
G1 X97.055 Y63.956 E.24734
G1 X97.055 Y64.023 E.002
M73 P45 R22
G1 X102.945 Y62.445 E.18106
G1 X102.945 Y62.271 E.00515
M73 P45 R21
G1 X97.055 Y56.381 E.24733
G1 X97.055 Y58.478 E.06226
G1 X102.945 Y56.9 E.18106
G1 X102.945 Y54.696 E.06542
G1 X97.055 Y48.806 E.24733
G1 X97.055 Y47.388 E.04212
G1 X102.945 Y45.809 E.18105
G1 X102.945 Y47.121 E.03896
G1 X99.643 Y43.82 E.13864
G1 X101.913 Y43.82 E.0674
G1 X97.055 Y61.953 E.55738
G1 X97.055 Y63.381 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I.7 J.995 P1  F42000
G1 X102.945 Y59.236 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.945 Y60.664 E.04241
G1 X97.055 Y82.648 E.67574
G1 X97.055 Y84.076 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I-1.189 J.261 P1  F42000
G1 X102.946 Y110.922 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.946 Y112.351 E.04241
G1 X97.054 Y113.929 E.18109
G1 X97.054 Y112.501 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I-1.17 J.335 P1  F42000
G1 X102.946 Y133.103 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.946 Y134.531 E.04241
G1 X97.054 Y136.11 E.1811
G1 X97.054 Y134.682 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 15/45
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z3.2 I1.214 J.083 P1  F42000
G1 X103.321 Y43.516 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.321 Y46.837 E.0986
G1 X103.321 Y156.487 E3.25557
G1 X96.679 Y156.487 E.19723
G1 X96.679 Y43.516 E3.35417
G1 X103.261 Y43.516 E.19542
M204 S500
G1 X103.678 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.678 Y46.837 E.1092
G1 X103.678 Y156.845 E3.26617
G1 X103.646 Y156.845 E.00095
G1 X96.353 Y156.845 E.21653
G1 X96.321 Y156.845 E.00095
G1 X96.322 Y43.159 E3.37537
G1 X96.354 Y43.159 E.00096
G1 X103.618 Y43.159 E.21566
G1 E-.8 F1800
G17
G3 Z3.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.4 F4000
            G39.3 S1
            G0 Z3.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.017 Y50.053 F42000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.017 Y51.481 E.04241
G1 X96.982 Y53.098 E.18551
G1 X96.982 Y51.67 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I-1.217 J0 P1  F42000
G1 X96.982 Y73.851 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.982 Y75.279 E.04241
G1 X103.018 Y73.662 E.18551
G1 X103.018 Y77.293 E.10782
G1 X96.982 Y71.258 E.25342
G1 X96.982 Y69.734 E.04525
G1 X103.018 Y68.117 E.18551
G1 X103.018 Y69.718 E.04755
G1 X96.982 Y63.683 E.25341
G1 X96.982 Y64.189 E.01501
G1 X103.018 Y62.572 E.18551
G1 X103.017 Y62.144 E.01271
G1 X96.982 Y56.108 E.25341
G1 X96.982 Y58.644 E.07527
G1 X103.017 Y57.027 E.18551
G1 X103.017 Y54.569 E.07298
G1 X96.982 Y48.534 E.25341
G1 X96.982 Y47.553 E.02911
G1 X103.017 Y45.936 E.18551
G1 X103.017 Y46.994 E.0314
G1 X99.843 Y43.82 E.13328
M73 P46 R21
G1 X101.767 Y43.82 E.05712
G1 X96.982 Y61.676 E.54888
G1 X96.982 Y63.105 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I.746 J.961 P1  F42000
G1 X103.017 Y58.419 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.017 Y59.848 E.04241
G1 X96.982 Y82.371 E.69234
G1 X96.982 Y83.8 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I-1.217 J0 P1  F42000
G1 X96.982 Y134.847 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.982 Y136.276 E.04241
G1 X103.018 Y134.658 E.18553
G1 X103.018 Y133.23 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I-1.217 J0 P1  F42000
G1 X103.018 Y141.197 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.018 Y142.625 E.04241
G1 X99.385 Y156.184 E.41677
G1 X98.586 Y156.184 E.02373
G1 X96.982 Y154.58 E.06733
G1 X96.982 Y152.911 E.04957
G1 X103.018 Y151.294 E.18553
G1 X103.018 Y153.041 E.05189
G1 X96.982 Y147.006 E.25344
G1 X96.982 Y147.366 E.0107
G1 X103.018 Y145.749 E.18553
G1 X103.018 Y145.467 E.00837
G1 X96.982 Y139.431 E.25344
G1 X96.982 Y141.821 E.07096
G1 X103.018 Y140.203 E.18553
G1 X103.018 Y137.892 E.06864
G1 X96.982 Y131.856 E.25344
G1 X96.982 Y130.73 E.03342
G1 X103.018 Y129.113 E.18553
G1 X103.018 Y130.317 E.03574
G1 X96.982 Y124.281 E.25343
G1 X96.982 Y123.761 E.01544
G1 X103.018 Y101.237 E.69238
G1 X103.018 Y101.388 E.00448
G1 X96.982 Y103.005 E.18552
G1 X96.982 Y103.066 E.00183
G1 X103.018 Y80.542 E.69236
G1 X103.018 Y79.207 E.03964
G1 X96.982 Y80.824 E.18552
G1 X96.982 Y78.833 E.05913
G1 X103.018 Y84.868 E.25342
G1 X103.018 Y84.752 E.00344
G1 X96.982 Y86.369 E.18552
G1 X96.982 Y86.408 E.00113
G1 X103.018 Y92.443 E.25342
G1 X103.018 Y90.297 E.0637
G1 X96.982 Y91.914 E.18552
G1 X96.982 Y93.982 E.0614
G1 X103.018 Y100.018 E.25342
G1 X103.018 Y95.842 E.12397
G1 X96.982 Y97.46 E.18552
G1 X96.982 Y101.557 E.12166
G1 X103.018 Y107.592 E.25343
G1 X103.018 Y106.933 E.01959
G1 X96.982 Y108.55 E.18552
G1 X96.982 Y109.132 E.01728
G1 X103.018 Y115.167 E.25343
G1 X103.018 Y112.478 E.07985
G1 X96.982 Y114.095 E.18552
G1 X96.982 Y116.707 E.07754
G1 X103.018 Y122.742 E.25343
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I-1.217 J0 P1  F42000
G1 X103.018 Y124.996 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.018 Y123.568 E.04241
G1 X96.982 Y125.185 E.18553
G1 X96.982 Y126.614 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I1.217 J0 P1  F42000
G1 X96.982 Y121.068 Z3.4
G1 Z3
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.982 Y119.64 E.04241
M73 P47 R21
G1 X103.018 Y118.023 E.18552
G1 X103.018 Y121.931 E.11603
G1 X96.982 Y144.456 E.6924
G1 X96.982 Y145.885 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 16/45
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z3.4 I1.215 J.076 P1  F42000
G1 X103.361 Y43.516 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.361 Y46.877 E.09978
G1 X103.361 Y156.487 E3.25439
G1 X96.639 Y156.487 E.19959
G1 X96.639 Y43.516 E3.35417
G1 X103.301 Y43.516 E.19778
M204 S500
G1 X103.718 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.718 Y46.877 E.11038
G1 X103.718 Y156.845 E3.26499
G1 X96.282 Y156.845 E.22079
G1 X96.282 Y43.159 E3.37537
G1 X103.658 Y43.159 E.21898
G1 E-.8 F1800
G17
G3 Z3.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.6 F4000
            G39.3 S1
            G0 Z3.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X96.943 Y57.372 F42000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X96.943 Y58.801 E.04241
G1 X103.057 Y57.162 E.18795
G1 X103.057 Y59.153 E.05911
G1 X96.943 Y81.973 E.70146
G1 X96.943 Y83.401 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.6 I1.217 J0 P1  F42000
G1 X96.943 Y80.981 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.057 Y79.343 E.18796
G1 X103.057 Y79.847 E.01498
G1 X96.943 Y102.668 E.70148
G1 X96.943 Y103.162 E.01466
G1 X103.057 Y101.523 E.18796
G1 E-.8 F1800
M204 S500
G17
G3 Z3.6 I1.217 J0 P1  F42000
G1 X103.057 Y97.407 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.057 Y95.978 E.04241
G1 X96.943 Y97.617 E.18796
G1 X96.943 Y101.317 E.10988
G1 X103.057 Y107.432 E.25676
G1 X103.057 Y107.068 E.0108
G1 X96.943 Y108.707 E.18796
G1 X96.942 Y108.892 E.0055
G1 X103.057 Y115.007 E.25677
G1 X103.057 Y112.614 E.07106
G1 X96.942 Y114.252 E.18797
M73 P47 R20
G1 X96.942 Y116.467 E.06576
G1 X103.057 Y122.582 E.25677
G1 X103.058 Y123.704 E.03331
G1 X96.942 Y125.342 E.18797
G1 X96.942 Y126.771 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.6 I1.217 J0 P1  F42000
M73 P48 R20
G1 X96.942 Y118.369 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.942 Y119.797 E.04241
G1 X103.057 Y118.159 E.18797
G1 X103.057 Y121.236 E.09138
G1 X96.942 Y144.058 E.70152
G1 X96.942 Y145.487 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.6 I1.217 J0 P1  F42000
G1 X96.942 Y140.549 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.942 Y141.978 E.04241
G1 X103.058 Y140.339 E.18797
G1 X103.058 Y141.931 E.04725
G1 X99.238 Y156.184 E.43813
G1 X98.786 Y156.184 E.01344
G1 X96.942 Y154.341 E.0774
G1 X96.942 Y153.068 E.03778
G1 X103.058 Y151.43 E.18798
G1 X103.058 Y152.881 E.0431
G1 X96.942 Y146.766 E.25678
G1 X96.942 Y147.523 E.02248
G1 X103.058 Y145.884 E.18797
G1 X103.058 Y145.306 E.01716
G1 X96.942 Y139.191 E.25678
G1 X96.942 Y136.433 E.0819
G1 X103.058 Y134.794 E.18797
G1 X103.058 Y137.732 E.08722
G1 X96.942 Y131.616 E.25677
G1 X96.942 Y130.888 E.02164
G1 X103.058 Y129.249 E.18797
G1 X103.058 Y130.157 E.02695
G1 X96.942 Y124.042 E.25677
G1 X96.942 Y123.363 E.02014
G1 X103.057 Y100.542 E.7015
G1 X103.057 Y99.857 E.02032
G1 X96.943 Y93.743 E.25676
G1 X96.943 Y92.072 E.04961
G1 X103.057 Y90.433 E.18796
G1 X103.057 Y92.283 E.05491
G1 X96.943 Y86.168 E.25676
G1 X96.943 Y86.526 E.01065
G1 X103.057 Y84.888 E.18796
G1 X103.057 Y84.708 E.00535
G1 X96.943 Y78.593 E.25676
G1 X96.943 Y75.436 E.09373
G1 X103.057 Y73.798 E.18796
G1 X103.057 Y77.133 E.09903
G1 X96.943 Y71.018 E.25675
G1 X96.943 Y69.891 E.03347
G1 X103.057 Y68.253 E.18796
G1 X103.057 Y69.558 E.03876
G1 X96.943 Y63.443 E.25675
G1 X96.943 Y64.346 E.02679
G1 X103.057 Y62.707 E.18795
G1 X103.057 Y61.983 E.0215
G1 X96.943 Y55.869 E.25675
G1 X96.943 Y53.256 E.07759
G1 X103.057 Y51.617 E.18795
G1 X103.057 Y54.408 E.08288
G1 X96.943 Y48.294 E.25675
G1 X96.943 Y47.71 E.01733
G1 X103.057 Y46.072 E.18795
G1 X103.057 Y46.834 E.02261
G1 X100.043 Y43.82 E.12655
G1 X101.621 Y43.82 E.04683
G1 X96.943 Y61.278 E.53664
G1 X96.943 Y62.706 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 17/45
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z3.6 I1.153 J.388 P1  F42000
G1 X103.4 Y43.516 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.4 Y46.917 E.10096
G1 X103.401 Y156.488 E3.25321
G1 X96.599 Y156.487 E.20195
G1 X96.6 Y43.516 E3.35417
G1 X103.34 Y43.516 E.20014
M204 S500
G1 X103.758 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.758 Y46.917 E.11156
G1 X103.758 Y156.845 E3.26381
G1 X96.242 Y156.845 E.22315
G1 X96.242 Y43.159 E3.37537
G1 X103.698 Y43.159 E.22134
G1 E-.8 F1800
G17
G3 Z3.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.8 F4000
            G39.3 S1
            G0 Z3.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X96.903 Y57.529 F42000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X96.903 Y58.958 E.04241
G1 X103.097 Y57.298 E.1904
G1 X103.097 Y58.458 E.03445
G1 X96.903 Y81.575 E.71058
G1 X96.903 Y83.003 E.04241
M204 S500
G1 X96.903 Y81.138 F42000
G1 F1680.297
M204 S6000
G1 X103.097 Y79.479 E.1904
M73 P49 R20
G1 X103.097 Y79.153 E.00968
G1 X96.903 Y102.27 E.7106
G1 X96.903 Y103.319 E.03114
G1 X103.097 Y101.659 E.19041
G1 X103.097 Y103.087 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.8 I1.217 J0 P1  F42000
G1 X103.097 Y94.686 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.097 Y96.114 E.04241
G1 X96.903 Y97.774 E.19041
G1 X96.903 Y101.078 E.0981
G1 X103.097 Y107.272 E.2601
G1 X103.097 Y107.204 E.00201
G1 X96.903 Y108.864 E.19041
G1 X96.903 Y108.652 E.00628
G1 X103.097 Y114.847 E.2601
G1 X103.097 Y112.749 E.06228
G1 X96.903 Y114.409 E.19041
G1 X96.903 Y116.227 E.05398
G1 X103.097 Y122.422 E.26011
G1 X103.097 Y123.84 E.0421
G1 X96.903 Y125.499 E.19041
G1 X96.903 Y126.928 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.8 I1.217 J0 P1  F42000
G1 X96.903 Y118.526 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.903 Y119.954 E.04241
G1 X103.097 Y118.294 E.19041
G1 X103.097 Y120.541 E.06672
G1 X96.903 Y143.66 E.71064
G1 X96.903 Y145.088 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z3.8 I1.217 J0 P1  F42000
G1 X96.903 Y140.707 Z3.8
G1 Z3.4
G1 E.8 F1800
M73 P50 R19
G1 F1680.297
M204 S6000
G1 X96.903 Y142.135 E.04241
G1 X103.097 Y140.475 E.19042
G1 X103.097 Y141.236 E.02259
G1 X99.092 Y156.184 E.45949
G1 X98.986 Y156.184 E.00316
G1 X96.903 Y154.101 E.08747
G1 X96.903 Y153.225 E.026
G1 X103.097 Y151.565 E.19042
G1 X103.097 Y152.721 E.03431
G1 X96.903 Y146.526 E.26012
G1 X96.903 Y147.68 E.03426
G1 X103.097 Y146.02 E.19042
G1 X103.097 Y145.146 E.02595
G1 X96.903 Y138.951 E.26011
G1 X96.903 Y136.59 E.07012
G1 X103.097 Y134.93 E.19042
G1 X103.097 Y137.571 E.07843
G1 X96.903 Y131.377 E.26011
G1 X96.903 Y131.045 E.00986
G1 X103.097 Y129.385 E.19041
G1 X103.097 Y129.996 E.01816
G1 X96.903 Y123.802 E.26011
G1 X96.903 Y122.965 E.02485
G1 X103.097 Y99.847 E.71062
G1 X103.097 Y99.697 E.00445
G1 X96.903 Y93.503 E.2601
G1 X96.903 Y92.229 E.03783
G1 X103.097 Y90.569 E.1904
G1 X103.097 Y92.122 E.04613
G1 X96.903 Y85.928 E.2601
G1 X96.903 Y86.683 E.02243
G1 X103.097 Y85.024 E.1904
G1 X103.097 Y84.548 E.01414
G1 X96.903 Y78.353 E.26009
G1 X96.903 Y75.593 E.08195
G1 X103.097 Y73.933 E.1904
G1 X103.097 Y76.973 E.09024
G1 X96.903 Y70.779 E.26009
G1 X96.903 Y70.048 E.02169
G1 X103.097 Y68.388 E.1904
G1 X103.097 Y69.398 E.02997
G1 X96.903 Y63.204 E.26009
G1 X96.903 Y64.503 E.03857
G1 X103.097 Y62.843 E.1904
G1 X103.097 Y61.823 E.03029
G1 X96.903 Y55.629 E.26009
G1 X96.903 Y53.413 E.06581
G1 X103.097 Y51.753 E.1904
G1 X103.097 Y54.248 E.07409
G1 X96.903 Y48.054 E.26008
G1 X96.903 Y47.867 E.00554
G1 X103.097 Y46.208 E.19039
G1 X103.097 Y46.673 E.01382
G1 X100.243 Y43.82 E.11982
G1 X101.474 Y43.82 E.03654
G1 X96.903 Y60.88 E.52441
G1 X96.903 Y62.308 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 18/45
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z3.8 I1.149 J.4 P1  F42000
G1 X103.44 Y43.516 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.44 Y46.957 E.10214
G1 X103.441 Y156.488 E3.25203
G1 X96.559 Y156.488 E.20431
G1 X96.56 Y43.516 E3.35417
G1 X103.38 Y43.516 E.2025
M204 S500
G1 X103.797 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.797 Y46.957 E.11274
G1 X103.798 Y156.845 E3.26263
G1 X96.202 Y156.845 E.22551
G1 X96.203 Y43.159 E3.37537
G1 X103.737 Y43.159 E.2237
G1 E-.8 F1800
G17
G3 Z4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4 F4000
            G39.3 S1
            G0 Z4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X96.863 Y57.686 F42000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X96.863 Y59.115 E.04241
G1 X103.137 Y57.434 E.19284
G1 X103.137 Y57.763 E.00979
G1 X96.863 Y81.177 E.7197
G1 X96.863 Y81.295 E.00352
G1 X103.137 Y79.614 E.19285
G1 X103.137 Y81.043 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4 I1.217 J0 P1  F42000
G1 X103.137 Y72.641 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.137 Y74.069 E.04241
G1 X96.863 Y75.75 E.19284
G1 X96.863 Y78.114 E.07017
G1 X103.137 Y84.387 E.26343
G1 X103.137 Y85.159 E.02293
G1 X96.863 Y86.841 E.19285
G1 X96.863 Y85.688 E.03421
G1 X103.137 Y91.962 E.26343
G1 X103.137 Y90.705 E.03734
G1 X96.863 Y92.386 E.19285
G1 X96.863 Y93.263 E.02605
G1 X103.137 Y99.537 E.26344
G1 E-.8 F1800
M204 S500
G17
G3 Z4 I-1.217 J0 P1  F42000
G1 X103.137 Y103.223 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.137 Y101.795 E.04241
G1 X96.863 Y103.476 E.19285
G1 X96.863 Y101.872 E.04763
G1 X103.137 Y78.458 E.71972
G1 X103.137 Y76.812 E.04885
M73 P51 R19
G1 X96.863 Y70.539 E.26343
G1 X96.863 Y70.205 E.00991
G1 X103.137 Y68.524 E.19284
G1 X103.137 Y69.238 E.02119
G1 X96.863 Y62.964 E.26343
G1 X96.863 Y64.66 E.05035
G1 X103.137 Y62.979 E.19284
G1 X103.137 Y61.663 E.03908
G1 X96.863 Y55.389 E.26342
G1 X96.863 Y53.57 E.05403
G1 X103.137 Y51.889 E.19284
G1 X103.137 Y54.088 E.0653
G1 X96.863 Y47.814 E.26342
G1 X96.863 Y48.025 E.00624
G1 X103.137 Y46.344 E.19284
G1 X103.137 Y46.513 E.00504
G1 X100.443 Y43.82 E.11309
G1 X101.328 Y43.82 E.02626
G1 X96.863 Y60.482 E.51217
G1 X96.863 Y61.91 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4 I-1.217 J0 P1  F42000
G1 X96.863 Y118.683 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.863 Y120.111 E.04241
G1 X103.137 Y118.43 E.19285
G1 X103.137 Y119.847 E.04206
G1 X96.863 Y143.262 E.71975
G1 X96.863 Y144.69 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4 I1.217 J0 P1  F42000
G1 X96.863 Y142.292 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.137 Y140.611 E.19286
G1 X103.137 Y140.541 E.00207
G1 X98.946 Y156.184 E.48084
G1 X99.186 Y156.184 E.00713
G1 X96.863 Y153.861 E.09753
G1 X96.863 Y153.382 E.01422
G1 X103.137 Y151.701 E.19286
G1 X103.137 Y152.561 E.02553
G1 X96.863 Y146.286 E.26345
G1 X96.863 Y147.837 E.04604
G1 X103.137 Y146.156 E.19286
G1 X103.137 Y144.986 E.03474
G1 X96.863 Y138.712 E.26345
G1 X96.863 Y136.747 E.05834
G1 X103.137 Y135.066 E.19286
G1 X103.137 Y137.411 E.06964
G1 X96.863 Y131.137 E.26345
G1 X96.863 Y131.202 E.00192
G1 X103.137 Y129.52 E.19286
G1 X103.137 Y129.836 E.00937
G1 X96.863 Y123.562 E.26345
G1 X96.863 Y122.567 E.02955
G1 X103.137 Y99.152 E.71974
G1 X103.137 Y96.25 E.08618
G1 X96.863 Y97.931 E.19285
G1 X96.863 Y96.502 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P52 R19
G3 Z4 I-1.217 J0 P1  F42000
G1 X96.863 Y100.838 Z4
G1 Z3.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.137 Y107.112 E.26344
G1 X103.137 Y107.34 E.00678
G1 X96.863 Y109.021 E.19285
G1 X96.863 Y108.413 E.01807
G1 X103.137 Y114.687 E.26344
G1 X103.137 Y112.885 E.05349
G1 X96.863 Y114.566 E.19285
G1 X96.863 Y115.987 E.0422
G1 X103.137 Y122.261 E.26344
G1 X103.137 Y123.975 E.05089
G1 X96.863 Y125.656 E.19286
G1 X96.863 Y127.085 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 19/45
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z4 I1.213 J.096 P1  F42000
G1 X103.466 Y43.516 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.466 Y46.982 E.1029
G1 X103.466 Y156.488 E3.25127
G1 X96.534 Y156.488 E.2058
G1 X96.534 Y43.516 E3.35417
G1 X103.406 Y43.516 E.20402
M204 S500
G1 X103.823 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.823 Y46.982 E.1135
G1 X103.823 Y156.845 E3.26187
G1 X96.177 Y156.845 E.22701
G1 X96.177 Y43.159 E3.37537
G1 X103.763 Y43.159 E.22523
G1 E-.8 F1800
G17
G3 Z4.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.2 F4000
            G39.3 S1
            G0 Z4.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.162 Y55.693 F42000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.162 Y57.122 E.04241
G1 X96.838 Y80.726 E.72556
G1 X96.838 Y81.449 E.02147
G1 X103.162 Y79.754 E.19441
G1 X103.162 Y81.182 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I1.217 J0 P1  F42000
G1 X103.162 Y72.78 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y74.209 E.04241
G1 X96.838 Y75.903 E.19441
G1 X96.838 Y77.888 E.05893
G1 X103.162 Y84.213 E.26557
G1 X103.162 Y85.299 E.03225
G1 X96.838 Y86.994 E.19441
G1 X96.838 Y85.463 E.04545
G1 X103.162 Y91.788 E.26557
G1 X103.162 Y90.844 E.02801
G1 X96.838 Y92.539 E.19441
G1 X96.838 Y93.038 E.01481
G1 X103.162 Y99.362 E.26557
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I-1.217 J0 P1  F42000
G1 X103.162 Y103.363 Z4.2
G1 Z3.8
M73 P52 R18
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y101.934 E.04241
G1 X96.838 Y103.629 E.19441
G1 X96.838 Y101.42 E.06558
G1 X103.162 Y77.816 E.72556
G1 X103.162 Y76.638 E.03498
G1 X96.838 Y70.313 E.26557
G1 X96.838 Y70.358 E.00134
G1 X103.162 Y68.664 E.19441
G1 X103.162 Y69.063 E.01186
G1 X96.838 Y62.738 E.26557
G1 X96.838 Y64.813 E.0616
G1 X103.162 Y63.118 E.19441
G1 X103.162 Y61.488 E.0484
G1 X96.838 Y55.164 E.26557
G1 X96.838 Y53.723 E.04278
G1 X103.162 Y52.028 E.19441
M73 P53 R18
G1 X103.162 Y53.914 E.05598
G1 X96.838 Y47.589 E.26557
G1 X96.838 Y48.178 E.01749
G1 X103.162 Y46.483 E.19441
G1 X103.162 Y46.339 E.00429
G1 X100.643 Y43.82 E.10577
G1 X101.181 Y43.82 E.01597
G1 X96.838 Y60.031 E.4983
G1 X96.838 Y61.459 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I1.217 J0 P1  F42000
G1 X96.838 Y59.268 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y57.573 E.19441
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I-1.211 J-.125 P1  F42000
G1 X96.838 Y118.836 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y120.265 E.04241
G1 X103.162 Y118.57 E.19441
G1 X103.162 Y119.206 E.01888
G1 X96.838 Y142.81 E.72556
G1 X96.838 Y144.238 E.04241
M204 S500
G1 X96.838 Y142.445 F42000
G1 F1680.297
M204 S6000
G1 X103.162 Y140.75 E.19441
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I1.217 J0 P1  F42000
G1 X103.162 Y138.472 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y139.9 E.04241
G1 X98.799 Y156.184 E.50054
G1 X99.386 Y156.184 E.01741
G1 X96.838 Y153.636 E.10699
G1 X96.838 Y153.535 E.00299
G1 X103.162 Y151.841 E.19441
G1 X103.162 Y152.386 E.01619
G1 X96.838 Y146.061 E.26557
G1 X96.838 Y147.99 E.05727
G1 X103.162 Y146.296 E.19441
G1 X103.162 Y144.811 E.04407
G1 X96.838 Y138.486 E.26557
G1 X96.838 Y136.9 E.04711
G1 X103.162 Y135.205 E.19441
G1 X103.162 Y137.236 E.0603
G1 X96.838 Y130.912 E.26557
G1 X96.838 Y131.355 E.01316
G1 X103.162 Y129.66 E.19441
G1 X96.838 Y123.337 E.26554
G1 X96.838 Y122.115 E.03628
G1 X103.162 Y98.511 E.72556
G1 X103.162 Y96.389 E.06299
G1 X96.838 Y98.084 E.19441
G1 X96.838 Y96.656 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I-1.217 J0 P1  F42000
G1 X96.838 Y100.612 Z4.2
G1 Z3.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y106.937 E.26557
G1 X103.162 Y107.48 E.01611
G1 X96.838 Y109.174 E.19441
G1 X96.838 Y108.187 E.02931
G1 X103.162 Y114.512 E.26557
G1 X103.162 Y113.025 E.04416
G1 X96.838 Y114.719 E.19441
G1 X96.838 Y115.762 E.03096
G1 X103.162 Y122.087 E.26557
G1 X103.162 Y124.115 E.06022
G1 X96.838 Y125.81 E.19441
G1 X96.838 Y127.238 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 20/45
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z4.2 I1.213 J.096 P1  F42000
G1 X103.466 Y43.516 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.466 Y46.982 E.1029
G1 X103.466 Y156.488 E3.25127
G1 X96.534 Y156.488 E.2058
G1 X96.534 Y43.516 E3.35417
G1 X103.406 Y43.516 E.20402
M204 S500
G1 X103.823 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.823 Y46.982 E.1135
M73 P54 R18
G1 X103.823 Y156.845 E3.26187
G1 X96.177 Y156.845 E.22701
G1 X96.177 Y43.159 E3.37537
G1 X103.763 Y43.159 E.22523
G1 E-.8 F1800
G17
G3 Z4.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.4 F4000
            G39.3 S1
            G0 Z4.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.162 Y55.147 F42000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.162 Y56.575 E.04241
G1 X96.838 Y80.179 E.72556
G1 X96.838 Y81.595 E.04204
G1 X103.162 Y79.9 E.19441
G1 X103.162 Y81.329 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.4 I1.217 J0 P1  F42000
G1 X103.162 Y72.927 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y74.355 E.04241
G1 X96.838 Y76.05 E.19441
G1 X96.838 Y77.688 E.04864
G1 X103.162 Y84.013 E.26557
G1 X103.162 Y85.445 E.04254
G1 X96.838 Y87.14 E.19441
G1 X96.838 Y85.263 E.05574
G1 X103.162 Y91.588 E.26557
G1 X103.162 Y90.991 E.01772
G1 X96.838 Y92.685 E.19441
G1 X96.838 Y92.838 E.00452
G1 X103.162 Y99.162 E.26557
G1 X103.162 Y102.081 E.08665
G1 X96.838 Y103.776 E.19441
G1 X96.838 Y100.874 E.08616
G1 X103.162 Y77.27 E.72556
G1 X103.162 Y76.438 E.0247
G1 X96.838 Y70.113 E.26557
G1 X96.838 Y70.505 E.01162
G1 X103.162 Y68.81 E.19441
G1 X103.162 Y68.863 E.00158
G1 X96.838 Y62.538 E.26557
G1 X96.838 Y64.96 E.07189
G1 X103.162 Y63.265 E.19441
G1 X103.162 Y61.288 E.05869
G1 X96.838 Y54.964 E.26557
G1 X96.838 Y53.869 E.03249
G1 X103.162 Y52.175 E.19441
G1 X103.162 Y53.714 E.04569
G1 X96.838 Y47.389 E.26557
G1 X96.838 Y48.324 E.02777
G1 X103.162 Y46.63 E.19441
G1 X103.162 Y46.139 E.01457
G1 X100.843 Y43.82 E.09737
G1 X101.035 Y43.82 E.00569
G1 X96.838 Y59.484 E.48151
G1 X96.838 Y59.414 E.00208
G1 X103.162 Y57.72 E.19441
M73 P55 R17
G1 X103.162 Y59.148 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.4 I-1.21 J-.128 P1  F42000
G1 X96.838 Y118.983 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y120.411 E.04241
G1 X103.162 Y118.716 E.19441
G1 X103.162 Y118.659 E.00169
G1 X96.838 Y142.263 E.72556
G1 X96.838 Y142.591 E.00975
G1 X103.162 Y140.897 E.19441
G1 X103.162 Y142.325 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.4 I1.217 J0 P1  F42000
G1 X103.162 Y137.926 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y139.354 E.04241
G1 X98.653 Y156.184 E.51733
G1 X99.586 Y156.184 E.0277
G1 X96.838 Y153.436 E.11539
G1 X96.838 Y153.682 E.0073
G1 X103.162 Y151.987 E.19441
G1 X103.162 Y152.186 E.0059
G1 X96.838 Y145.861 E.26557
G1 X96.838 Y148.137 E.06756
G1 X103.162 Y146.442 E.19441
G1 X103.162 Y144.611 E.05436
G1 X96.838 Y138.286 E.26557
G1 X96.838 Y137.046 E.03682
G1 X103.162 Y135.352 E.19441
G1 X103.162 Y137.036 E.05002
G1 X96.838 Y130.712 E.26557
G1 X96.838 Y131.501 E.02344
G1 X103.162 Y129.807 E.19441
G1 X103.162 Y129.462 E.01024
G1 X96.838 Y123.137 E.26557
G1 X96.838 Y121.569 E.04656
G1 X103.162 Y97.965 E.72556
G1 X103.162 Y96.536 E.04242
G1 X96.838 Y98.23 E.19441
G1 X96.838 Y96.802 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.4 I-1.217 J0 P1  F42000
G1 X96.838 Y100.412 Z4.4
G1 Z4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y106.737 E.26557
G1 X103.162 Y107.626 E.02639
G1 X96.838 Y109.321 E.19441
G1 X96.838 Y107.987 E.03959
G1 X103.162 Y114.312 E.26557
G1 X103.162 Y113.171 E.03387
G1 X96.838 Y114.866 E.19441
G1 X96.838 Y115.562 E.02067
G1 X103.162 Y121.887 E.26557
G1 X103.162 Y124.261 E.07051
G1 X96.838 Y125.956 E.19441
G1 X96.838 Y127.384 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 21/45
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z4.4 I1.213 J.096 P1  F42000
G1 X103.466 Y43.516 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.466 Y46.982 E.1029
G1 X103.466 Y156.488 E3.25127
G1 X96.534 Y156.488 E.2058
G1 X96.534 Y43.516 E3.35417
G1 X103.406 Y43.516 E.20402
M204 S500
G1 X103.823 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.823 Y46.982 E.1135
G1 X103.823 Y156.845 E3.26187
G1 X96.177 Y156.845 E.22701
G1 X96.177 Y43.159 E3.37537
G1 X103.763 Y43.159 E.22523
G1 E-.8 F1800
G17
G3 Z4.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.6 F4000
            G39.3 S1
            G0 Z4.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.162 Y54.6 F42000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.162 Y56.029 E.04241
G1 X96.838 Y79.633 E.72556
G1 X96.838 Y81.741 E.06261
G1 X103.162 Y80.047 E.19441
G1 X103.162 Y81.475 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.6 I1.217 J0 P1  F42000
G1 X103.162 Y73.073 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y74.502 E.04241
G1 X96.838 Y76.196 E.19441
G1 X96.838 Y77.488 E.03836
G1 X103.162 Y83.813 E.26557
G1 X103.162 Y85.592 E.05282
G1 X96.838 Y87.287 E.19441
G1 X96.838 Y85.063 E.06602
G1 X103.162 Y91.388 E.26557
G1 X103.162 Y91.137 E.00744
G1 X96.838 Y92.832 E.19441
G1 X96.838 Y92.638 E.00576
G1 X103.162 Y98.962 E.26557
G1 X103.162 Y102.227 E.09694
G1 X96.838 Y103.922 E.19441
G1 X96.838 Y105.35 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P56 R17
G3 Z4.6 I1.217 J0 P1  F42000
G1 X96.838 Y96.949 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y98.377 E.04241
G1 X103.162 Y96.682 E.19441
G1 X103.162 Y97.418 E.02185
G1 X96.838 Y121.022 E.72556
G1 X96.838 Y122.937 E.05685
G1 X103.162 Y129.262 E.26557
G1 X103.162 Y129.953 E.02053
G1 X96.838 Y131.648 E.19441
G1 X96.838 Y130.512 E.03373
G1 X103.162 Y136.836 E.26557
G1 X103.162 Y135.498 E.03973
G1 X96.838 Y137.193 E.19441
G1 X96.838 Y138.086 E.02654
G1 X103.162 Y144.411 E.26557
G1 X103.162 Y146.588 E.06464
G1 X96.838 Y148.283 E.19441
G1 X96.838 Y145.661 E.07784
G1 X103.162 Y151.986 E.26557
G1 X103.162 Y152.133 E.00438
G1 X96.838 Y153.828 E.19441
G1 X96.838 Y153.236 E.01758
G1 X99.786 Y156.184 E.12378
G1 X98.506 Y156.184 E.03798
G1 X103.162 Y138.808 E.53413
G1 X103.162 Y137.379 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.6 I-1.217 J0 P1  F42000
G1 X103.162 Y142.472 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y141.043 E.04241
G1 X96.838 Y142.738 E.19441
G1 X96.838 Y141.717 E.03032
M73 P57 R17
G1 X103.162 Y118.113 E.72556
G1 X103.162 Y116.685 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.6 I-1.217 J0 P1  F42000
G1 X103.162 Y118.863 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y120.557 E.19441
G1 E-.8 F1800
M204 S500
G17
G3 Z4.6 I-1.217 J0 P1  F42000
G1 X96.838 Y127.531 Z4.6
G1 Z4.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y126.102 E.04241
G1 X103.162 Y124.408 E.19441
G1 X103.162 Y121.687 E.08079
G1 X96.838 Y115.362 E.26557
G1 X96.838 Y115.012 E.01039
G1 X103.162 Y113.318 E.19441
G1 X103.162 Y114.112 E.02359
G1 X96.838 Y107.787 E.26557
G1 X96.838 Y109.467 E.04988
G1 X103.162 Y107.772 E.19441
G1 X103.162 Y106.537 E.03668
G1 X96.838 Y100.212 E.26557
G1 X96.838 Y100.327 E.00341
G1 X103.162 Y76.723 E.72556
G1 X103.162 Y76.238 E.01441
G1 X96.838 Y69.913 E.26557
G1 X96.838 Y70.651 E.02191
G1 X103.162 Y68.956 E.19441
G1 X103.162 Y68.663 E.00871
G1 X96.838 Y62.338 E.26557
G1 X96.838 Y65.106 E.08217
G1 X103.162 Y63.411 E.19441
G1 X103.162 Y61.088 E.06897
G1 X96.838 Y54.764 E.26557
G1 X96.838 Y54.016 E.02221
G1 X103.162 Y52.321 E.19441
G1 X103.162 Y53.514 E.03541
G1 X96.838 Y47.189 E.26557
G1 X96.838 Y48.471 E.03806
G1 X103.162 Y46.776 E.19441
G1 X103.162 Y45.939 E.02486
G1 X101.043 Y43.82 E.08897
G1 X100.889 Y43.82 E.0046
G1 X96.838 Y58.938 E.46471
G1 X96.838 Y59.561 E.01849
G1 X103.162 Y57.866 E.19441
G1 X103.162 Y59.294 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 22/45
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z4.6 I1.217 J.023 P1  F42000
G1 X103.466 Y43.516 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.466 Y46.982 E.1029
G1 X103.466 Y156.488 E3.25127
G1 X96.534 Y156.488 E.2058
G1 X96.534 Y43.516 E3.35417
G1 X103.406 Y43.516 E.20402
M204 S500
G1 X103.823 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.823 Y46.982 E.1135
G1 X103.823 Y156.845 E3.26187
G1 X96.177 Y156.845 E.22701
G1 X96.177 Y43.159 E3.37537
G1 X103.763 Y43.159 E.22523
G1 E-.8 F1800
G17
G3 Z4.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
M73 P57 R16
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.8 F4000
            G39.3 S1
            G0 Z4.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.162 Y54.054 F42000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.162 Y55.482 E.04241
G1 X96.838 Y79.086 E.72556
G1 X96.838 Y81.888 E.08318
G1 X103.162 Y80.193 E.19441
G1 X103.162 Y81.621 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.8 I1.217 J0 P1  F42000
G1 X103.162 Y73.22 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y74.648 E.04241
G1 X96.838 Y76.343 E.19441
G1 X96.838 Y77.288 E.02807
G1 X103.162 Y83.613 E.26557
G1 X103.162 Y85.738 E.06311
G1 X96.838 Y87.433 E.19441
G1 X96.838 Y84.863 E.07631
G1 X103.162 Y91.188 E.26557
G1 X103.162 Y91.283 E.00285
G1 X96.838 Y92.978 E.19441
G1 X96.838 Y92.438 E.01605
G1 X103.162 Y98.762 E.26557
G1 X103.162 Y102.374 E.10723
G1 X96.838 Y104.068 E.19441
G1 X96.838 Y102.64 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.8 I1.217 J0 P1  F42000
G1 X96.838 Y97.095 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.838 Y98.523 E.04241
G1 X103.162 Y96.829 E.19441
G1 X103.162 Y96.872 E.00128
G1 X96.838 Y120.476 E.72556
G1 X96.838 Y120.704 E.00677
G1 X103.162 Y119.009 E.19441
G1 X103.162 Y121.487 E.07356
G1 X96.838 Y115.162 E.26557
G1 X103.162 Y113.464 E.19444
G1 X103.162 Y113.912 E.0133
G1 X96.838 Y107.587 E.26557
G1 X96.838 Y109.614 E.06016
M73 P58 R16
G1 X103.162 Y107.919 E.19441
G1 X103.162 Y106.337 E.04696
G1 X96.838 Y100.012 E.26557
G1 X96.838 Y99.781 E.00687
G1 X103.162 Y76.177 E.72556
G1 X103.162 Y76.038 E.00413
G1 X96.838 Y69.713 E.26557
G1 X96.838 Y70.798 E.03219
G1 X103.162 Y69.103 E.19441
G1 X103.162 Y68.463 E.01899
G1 X96.838 Y62.138 E.26557
G1 X96.838 Y65.252 E.09246
G1 X103.162 Y63.558 E.19441
G1 X103.162 Y60.888 E.07926
G1 X96.838 Y54.564 E.26557
G1 X96.838 Y54.162 E.01192
G1 X103.162 Y52.467 E.19441
G1 X103.162 Y53.314 E.02512
G1 X96.838 Y46.989 E.26557
G1 X96.838 Y48.617 E.04834
G1 X103.162 Y46.922 E.19441
G1 X103.162 Y45.739 E.03514
G1 X101.243 Y43.82 E.08057
G1 X100.742 Y43.82 E.01488
G1 X96.838 Y58.392 E.44792
G1 X96.838 Y59.707 E.03906
G1 X103.162 Y58.013 E.19441
G1 X103.162 Y59.441 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.8 I-1.217 J0 P1  F42000
G1 X103.162 Y116.138 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y117.566 E.04241
G1 X96.838 Y141.17 E.72556
G1 X96.838 Y142.884 E.05089
G1 X103.162 Y141.19 E.19441
G1 X103.162 Y142.618 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z4.8 I1.217 J0 P1  F42000
G1 X103.162 Y136.833 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.162 Y138.261 E.04241
G1 X98.36 Y156.184 E.55092
G1 X99.986 Y156.184 E.04827
G1 X96.838 Y153.036 E.13218
G1 X96.838 Y153.975 E.02787
G1 X103.162 Y152.28 E.19441
G1 X103.162 Y151.786 E.01467
G1 X96.838 Y145.461 E.26557
G1 X96.838 Y148.429 E.08813
G1 X103.162 Y146.735 E.19441
G1 X103.162 Y144.211 E.07493
G1 X96.838 Y137.886 E.26557
G1 X96.838 Y137.339 E.01625
G1 X103.162 Y135.644 E.19441
G1 X103.162 Y136.636 E.02945
G1 X96.838 Y130.312 E.26557
G1 X96.838 Y131.794 E.04401
M73 P59 R16
G1 X103.162 Y130.099 E.19441
G1 X103.162 Y129.062 E.03081
G1 X96.838 Y122.737 E.26557
G1 X96.838 Y126.249 E.10428
G1 X103.162 Y124.554 E.19441
G1 X103.162 Y125.983 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 23/45
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z4.8 I1.217 J.004 P1  F42000
G1 X103.45 Y43.516 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.45 Y46.967 E.10244
G1 X103.45 Y156.488 E3.25173
G1 X96.55 Y156.488 E.20485
G1 X96.55 Y43.516 E3.35417
G1 X103.39 Y43.516 E.2031
M204 S500
G1 X103.807 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.807 Y46.967 E.11304
G1 X103.807 Y156.845 E3.26233
G1 X96.193 Y156.845 E.22605
G1 X96.193 Y43.159 E3.37537
G1 X103.747 Y43.159 E.2243
G1 E-.8 F1800
G17
G3 Z5 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5 F4000
            G39.3 S1
            G0 Z5 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.147 Y53.566 F42000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.147 Y54.994 E.04241
G1 X96.853 Y78.481 E.72195
G1 X96.853 Y79.909 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I-1.217 J0 P1  F42000
G1 X96.853 Y89.003 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.853 Y87.575 E.04241
G1 X103.147 Y85.889 E.19344
G1 X103.147 Y83.397 E.07399
G1 X96.853 Y77.104 E.26425
G1 X96.853 Y76.485 E.01838
G1 X103.147 Y74.799 E.19345
G1 X103.147 Y73.37 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I-1.217 J0 P1  F42000
G1 X103.147 Y78.915 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.147 Y80.344 E.04241
G1 X96.853 Y82.03 E.19344
G1 X96.853 Y84.679 E.07864
G1 X103.147 Y90.972 E.26425
G1 X103.147 Y91.434 E.01373
G1 X96.853 Y93.12 E.19344
G1 X96.853 Y92.253 E.02574
G1 X103.147 Y98.547 E.26424
G1 X103.146 Y102.524 E.11811
G1 X96.854 Y104.211 E.19344
G1 X96.854 Y102.782 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I1.217 J0 P1  F42000
G1 X96.853 Y98.665 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.147 Y96.979 E.19344
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I1.217 J0 P1  F42000
G1 X103.147 Y94.956 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.147 Y96.384 E.04241
G1 X96.854 Y119.87 E.72192
G1 X96.854 Y120.846 E.02898
G1 X103.146 Y119.16 E.19343
G1 X103.146 Y121.271 E.06268
G1 X96.854 Y114.978 E.26424
G1 X96.854 Y115.301 E.00959
M73 P60 R15
G1 X103.146 Y113.615 E.19344
G1 X103.146 Y113.696 E.00242
G1 X96.854 Y107.403 E.26424
G1 X96.854 Y109.756 E.06985
G1 X103.146 Y108.069 E.19344
G1 X103.146 Y106.121 E.05784
G1 X96.853 Y99.828 E.26424
G1 X96.853 Y99.176 E.01938
G1 X103.147 Y75.689 E.72193
G1 X103.147 Y75.822 E.00394
G1 X96.853 Y69.529 E.26425
G1 X96.853 Y70.94 E.04189
G1 X103.147 Y69.253 E.19345
G1 X103.147 Y68.247 E.02987
G1 X96.853 Y61.954 E.26425
G1 X96.853 Y65.395 E.10215
G1 X103.147 Y63.708 E.19345
G1 X103.147 Y60.673 E.09013
G1 X96.853 Y54.379 E.26426
G1 X96.853 Y54.304 E.00223
G1 X103.147 Y52.618 E.19345
G1 X103.147 Y53.098 E.01425
G1 X96.853 Y46.804 E.26426
G1 X96.853 Y48.759 E.05804
G1 X103.147 Y47.073 E.19345
G1 X103.147 Y45.523 E.04602
G1 X101.443 Y43.82 E.07152
G1 X100.596 Y43.82 E.02517
G1 X96.853 Y57.787 E.42932
G1 X96.853 Y59.85 E.06125
G1 X103.147 Y58.163 E.19345
G1 X103.147 Y59.592 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I-1.217 J0 P1  F42000
G1 X103.146 Y136.599 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.146 Y137.774 E.0349
G1 X98.214 Y156.184 E.56589
G1 X100.186 Y156.184 E.05856
G1 X96.854 Y152.852 E.13991
G1 X96.854 Y154.117 E.03755
G1 X103.146 Y152.431 E.19343
G1 X103.146 Y151.57 E.02556
G1 X96.854 Y145.277 E.26423
G1 X96.854 Y143.026 E.06683
G1 X103.146 Y141.34 E.19343
G1 X103.146 Y143.995 E.07882
G1 X96.854 Y137.702 E.26423
G1 X96.854 Y137.481 E.00657
G1 X103.146 Y135.795 E.19343
G1 X103.146 Y136.42 E.01856
G1 X96.854 Y130.128 E.26423
G1 X96.854 Y131.936 E.0537
G1 X103.146 Y130.25 E.19343
G1 X103.146 Y128.846 E.0417
G1 X96.854 Y122.553 E.26423
G1 X96.854 Y126.391 E.11396
G1 X103.146 Y124.705 E.19343
G1 X103.146 Y126.133 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I1.217 J0 P1  F42000
G1 X103.146 Y115.651 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.146 Y117.079 E.04241
G1 X96.854 Y140.564 E.7219
G1 X96.854 Y141.993 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I-1.217 J0 P1  F42000
G1 X96.854 Y150 Z5
G1 Z4.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.854 Y148.572 E.04241
G1 X103.146 Y146.885 E.19343
G1 X103.146 Y148.314 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 24/45
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z5 I1.217 J.003 P1  F42000
G1 X103.41 Y43.516 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.41 Y46.927 E.10126
G1 X103.41 Y156.488 E3.25291
G1 X96.59 Y156.488 E.20249
G1 X96.589 Y43.516 E3.35417
G1 X103.35 Y43.516 E.20074
M204 S500
G1 X103.768 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
M73 P61 R15
G1 X103.768 Y46.927 E.11186
G1 X103.767 Y156.845 E3.26351
G1 X96.233 Y156.845 E.22369
G1 X96.232 Y43.159 E3.37537
G1 X103.708 Y43.159 E.22194
G1 E-.8 F1800
G17
G3 Z5.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.2 F4000
            G39.3 S1
            G0 Z5.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.107 Y53.168 F42000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.107 Y54.596 E.04241
G1 X96.893 Y77.786 E.71284
G1 X96.893 Y79.215 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I-1.217 J0 P1  F42000
G1 X96.893 Y89.139 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.893 Y87.711 E.04241
G1 X103.107 Y86.046 E.191
G1 X103.107 Y87.474 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I1.165 J-.353 P1  F42000
G1 X96.893 Y66.959 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.893 Y65.53 E.04241
G1 X103.107 Y63.865 E.191
G1 X103.107 Y65.294 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I-1.217 J0 P1  F42000
G1 X103.107 Y73.527 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.107 Y74.956 E.04241
G1 X96.893 Y76.621 E.191
G1 X96.893 Y75.192 E.04241
M204 S500
G1 X96.893 Y76.944 F42000
G1 F1680.297
M204 S6000
G1 X103.107 Y83.157 E.26091
G1 X103.107 Y80.501 E.07887
G1 X96.893 Y82.166 E.191
G1 X96.893 Y84.518 E.06985
G1 X103.107 Y90.732 E.26091
G1 X103.107 Y91.591 E.02551
G1 X96.893 Y93.256 E.191
G1 X96.893 Y92.093 E.03453
G1 X103.107 Y98.307 E.26091
G1 X103.107 Y97.136 E.03475
G1 X96.893 Y98.801 E.191
G1 X96.893 Y98.481 E.00951
G1 X103.107 Y75.291 E.71282
G1 X103.107 Y75.582 E.00864
G1 X96.893 Y69.369 E.26091
G1 X96.893 Y71.076 E.05068
G1 X103.107 Y69.411 E.191
G1 X103.107 Y68.008 E.04165
G1 X96.893 Y61.794 E.26092
G1 X96.893 Y59.985 E.0537
G1 X103.107 Y58.32 E.19101
G1 X103.107 Y60.433 E.06273
G1 X96.893 Y54.219 E.26092
G1 X96.893 Y54.44 E.00656
G1 X103.107 Y52.775 E.19101
M73 P62 R15
G1 X103.107 Y52.858 E.00246
G1 X96.893 Y46.644 E.26092
G1 X96.893 Y48.895 E.06683
G1 X103.107 Y47.23 E.19101
G1 X103.107 Y45.283 E.0578
G1 X101.643 Y43.82 E.06145
G1 X100.449 Y43.82 E.03546
G1 X96.893 Y57.092 E.40797
G1 X96.893 Y58.52 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I-1.21 J.132 P1  F42000
G1 X103.107 Y115.253 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.107 Y116.681 E.04241
G1 X96.893 Y139.87 E.71278
G1 X96.893 Y141.298 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I.757 J.953 P1  F42000
G1 X103.107 Y136.359 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.107 Y137.376 E.0302
G1 X98.067 Y156.184 E.57812
G1 X100.386 Y156.184 E.06884
G1 X96.893 Y152.692 E.14664
G1 X96.893 Y154.252 E.04634
G1 X103.107 Y152.588 E.19098
G1 X103.107 Y151.33 E.03734
G1 X96.893 Y145.117 E.26089
G1 X96.893 Y143.162 E.05804
G1 X103.107 Y141.497 E.19099
G1 X103.107 Y143.755 E.06704
G1 X96.893 Y137.542 E.26089
G1 X96.893 Y137.617 E.00223
G1 X103.107 Y135.952 E.19099
G1 X103.107 Y136.181 E.00678
G1 X96.893 Y129.967 E.26089
G1 X96.893 Y132.072 E.06249
G1 X103.107 Y130.407 E.19099
G1 X103.107 Y128.606 E.05348
G1 X96.893 Y122.392 E.2609
G1 X96.893 Y120.982 E.04189
G1 X103.107 Y119.317 E.19099
M73 P62 R14
G1 X103.107 Y121.031 E.0509
G1 X96.893 Y114.818 E.2609
G1 X96.893 Y115.437 E.01838
G1 X103.107 Y113.772 E.19099
G1 X103.107 Y113.456 E.00936
G1 X96.893 Y107.243 E.2609
G1 X96.893 Y109.891 E.07864
G1 X103.107 Y108.227 E.19099
G1 X103.107 Y105.882 E.06963
G1 X96.893 Y99.668 E.2609
G1 X96.893 Y104.346 E.1389
G1 X103.107 Y102.681 E.19099
G1 X103.107 Y101.253 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I1.217 J0 P1  F42000
G1 X103.107 Y94.558 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.107 Y95.986 E.04241
G1 X96.893 Y119.175 E.7128
G1 X96.893 Y120.604 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I-1.217 J0 P1  F42000
G1 X96.893 Y125.099 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.893 Y126.527 E.04241
G1 X103.107 Y124.862 E.19099
G1 X103.107 Y123.434 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I-1.217 J0 P1  F42000
G1 X103.107 Y148.471 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.107 Y147.043 E.04241
G1 X96.893 Y148.707 E.19098
G1 X96.893 Y150.136 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 25/45
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z5.2 I1.215 J.074 P1  F42000
G1 X103.371 Y43.516 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.371 Y46.887 E.10008
G1 X103.37 Y156.488 E3.25409
G1 X96.63 Y156.488 E.20013
G1 X96.629 Y43.516 E3.35417
G1 X103.311 Y43.516 E.19838
M204 S500
G1 X103.728 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.728 Y46.887 E.11068
G1 X103.727 Y156.845 E3.26469
G1 X96.273 Y156.845 E.22133
G1 X96.272 Y43.159 E3.37537
G1 X103.668 Y43.159 E.21958
G1 E-.8 F1800
G17
G3 Z5.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.4 F4000
            G39.3 S1
            G0 Z5.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.067 Y53.111 F42000
M73 P63 R14
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.067 Y54.198 E.03229
G1 X96.933 Y77.092 E.70372
G1 X96.933 Y78.52 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I.56 J1.081 P1  F42000
G1 X103.067 Y75.343 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y69.208 E.25758
G1 X96.933 Y71.211 E.05947
G1 X103.067 Y69.568 E.18856
G1 X103.067 Y67.768 E.05344
G1 X96.933 Y61.634 E.25758
G1 X96.933 Y60.121 E.04491
G1 X103.067 Y58.477 E.18856
G1 X103.067 Y60.193 E.05095
G1 X96.933 Y54.059 E.25758
G1 X96.933 Y54.576 E.01535
G1 X103.067 Y52.932 E.18856
G1 X103.067 Y52.618 E.00932
G1 X96.933 Y46.484 E.25758
G1 X96.933 Y49.031 E.07562
G1 X103.067 Y47.387 E.18856
G1 X103.067 Y45.044 E.06958
G1 X101.843 Y43.82 E.05139
G1 X100.303 Y43.82 E.04574
G1 X96.933 Y56.397 E.38662
G1 X96.933 Y57.826 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.217 J0 P1  F42000
G1 X96.933 Y64.238 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y65.666 E.04241
G1 X103.067 Y64.022 E.18856
G1 X103.067 Y62.594 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.186 J-.273 P1  F42000
G1 X96.933 Y89.275 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y87.847 E.04241
G1 X103.067 Y86.203 E.18856
G1 X103.067 Y87.631 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.217 J0 P1  F42000
G1 X103.067 Y94.16 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.067 Y95.588 E.04241
G1 X96.933 Y118.481 E.70368
G1 X96.933 Y119.909 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.217 J0 P1  F42000
G1 X96.933 Y125.234 Z5.4
M73 P64 R14
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y126.663 E.04241
G1 X103.067 Y125.019 E.18855
G1 X103.067 Y123.591 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.217 J0 P1  F42000
G1 X103.067 Y136.288 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.067 Y136.978 E.0205
G1 X97.921 Y156.184 E.59036
G1 X100.586 Y156.184 E.07913
G1 X96.933 Y152.532 E.15337
G1 X96.933 Y154.388 E.05513
G1 X103.067 Y152.745 E.18854
G1 X103.067 Y151.09 E.04912
G1 X96.933 Y144.957 E.25755
G1 X96.933 Y143.298 E.04925
G1 X103.067 Y141.654 E.18854
G1 X103.067 Y143.516 E.05526
G1 X96.933 Y137.382 E.25755
G1 X96.933 Y137.753 E.01101
G1 X103.067 Y136.109 E.18854
G1 X103.067 Y135.941 E.005
G1 X96.933 Y129.807 E.25756
G1 X96.933 Y132.208 E.07128
G1 X103.067 Y130.564 E.18854
G1 X103.067 Y128.366 E.06526
G1 X96.933 Y122.232 E.25756
G1 X96.933 Y121.117 E.0331
G1 X103.067 Y119.474 E.18855
G1 X103.067 Y120.791 E.03912
G1 X96.933 Y114.657 E.25756
G1 X96.933 Y115.572 E.02717
G1 X103.067 Y113.929 E.18855
G1 X103.067 Y113.217 E.02115
G1 X96.933 Y107.083 E.25756
G1 X96.933 Y104.482 E.07721
G1 X103.067 Y102.838 E.18855
G1 X103.067 Y101.41 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I.483 J-1.117 P1  F42000
G1 X96.933 Y98.758 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y97.786 E.02887
G1 X103.067 Y74.893 E.7037
G1 X103.067 Y75.113 E.00652
G1 X96.933 Y76.756 E.18856
G1 X96.933 Y76.783 E.0008
G1 X103.067 Y82.917 E.25757
G1 X103.067 Y80.658 E.06709
G1 X96.933 Y82.302 E.18856
G1 X96.933 Y84.358 E.06106
G1 X103.067 Y90.492 E.25757
G1 X103.067 Y91.748 E.03729
G1 X96.933 Y93.392 E.18855
G1 X96.933 Y91.933 E.04332
G1 X103.067 Y98.067 E.25757
G1 X103.067 Y97.293 E.02297
G1 X96.933 Y98.937 E.18855
G1 X96.933 Y99.508 E.01695
G1 X103.067 Y105.642 E.25757
G1 X103.067 Y108.384 E.08141
G1 X96.933 Y110.027 E.18855
G1 X96.933 Y111.456 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-.59 J1.064 P1  F42000
G1 X103.067 Y114.855 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.067 Y116.283 E.04241
G1 X96.933 Y139.175 E.70366
G1 X96.933 Y140.603 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I-1.217 J0 P1  F42000
G1 X96.933 Y147.415 Z5.4
G1 Z5
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.933 Y148.843 E.04241
G1 X103.067 Y147.2 E.18854
G1 X103.067 Y148.628 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 26/45
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z5.4 I1.217 J.003 P1  F42000
G1 X103.331 Y43.516 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.331 Y46.847 E.0989
G1 X103.331 Y156.488 E3.25527
G1 X96.669 Y156.488 E.19777
G1 X96.669 Y43.516 E3.35417
G1 X103.271 Y43.516 E.19602
M204 S500
G1 X103.688 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.688 Y46.847 E.1095
G1 X103.688 Y156.845 E3.26587
G1 X96.312 Y156.845 E.21897
G1 X96.312 Y43.159 E3.37537
G1 X103.628 Y43.159 E.21722
G1 E-.8 F1800
G17
G3 Z5.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.6 F4000
            G39.3 S1
            G0 Z5.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X103.027 Y53.268 F42000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X103.027 Y53.8 E.01581
G1 X96.973 Y76.397 E.6946
G1 X96.973 Y76.623 E.00671
G1 X103.027 Y82.678 E.25424
G1 X103.027 Y80.815 E.05531
G1 X96.973 Y82.437 E.18611
G1 X96.973 Y84.198 E.05227
G1 X103.027 Y90.252 E.25423
G1 X103.027 Y91.905 E.04907
G1 X96.973 Y93.528 E.18611
G1 X96.973 Y91.773 E.05211
G1 X103.027 Y97.827 E.25423
G1 X103.027 Y97.45 E.01119
G1 X96.973 Y99.073 E.18611
G1 X96.973 Y99.347 E.00816
M73 P65 R14
G1 X103.027 Y105.402 E.25423
G1 X103.027 Y102.996 E.07145
M73 P65 R13
G1 X96.973 Y104.618 E.18611
G1 X96.973 Y106.922 E.06842
G1 X103.027 Y112.977 E.25423
G1 X103.027 Y114.086 E.03293
G1 X96.973 Y115.708 E.1861
G1 X96.973 Y114.497 E.03595
G1 X103.027 Y120.552 E.25422
G1 X103.027 Y119.631 E.02733
G1 X96.973 Y121.253 E.1861
G1 X96.973 Y122.072 E.02431
G1 X103.027 Y128.126 E.25422
G1 X103.027 Y130.721 E.07705
G1 X96.973 Y132.343 E.1861
G1 X96.973 Y129.647 E.08007
G1 X103.027 Y135.701 E.25422
G1 X103.027 Y134.273 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-.296 J-1.18 P1  F42000
G1 X96.973 Y135.793 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y137.222 E.04241
G1 X103.027 Y143.276 E.25422
G1 X103.027 Y141.812 E.04348
G1 X96.973 Y143.434 E.1861
G1 X96.973 Y144.796 E.04046
G1 X103.027 Y150.851 E.25421
G1 X103.027 Y152.902 E.0609
G1 X96.973 Y154.524 E.1861
G1 X96.973 Y152.371 E.06392
G1 X100.786 Y156.184 E.1601
G1 X97.774 Y156.184 E.08941
G1 X103.027 Y136.58 E.60259
G1 X103.027 Y136.266 E.00932
G1 X96.973 Y137.889 E.1861
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.217 J0 P1  F42000
G1 X96.973 Y139.909 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y138.48 E.04241
G1 X103.027 Y115.885 E.69454
G1 X103.027 Y114.457 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I1.217 J0 P1  F42000
G1 X103.027 Y109.969 Z5.6
G1 Z5.2
M73 P66 R13
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.027 Y108.541 E.04241
G1 X96.973 Y110.163 E.18611
G1 X96.973 Y111.591 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.089 J.543 P1  F42000
G1 X103.027 Y123.748 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.027 Y125.176 E.04241
G1 X96.973 Y126.798 E.1861
G1 X96.973 Y125.37 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I1.217 J0 P1  F42000
G1 X96.973 Y119.214 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y117.786 E.04241
G1 X103.027 Y95.19 E.69456
G1 X103.027 Y93.762 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I1.217 J0 P1  F42000
G1 X103.027 Y87.788 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.027 Y86.36 E.04241
G1 X96.973 Y87.982 E.18611
G1 X96.973 Y89.411 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.217 J0 P1  F42000
G1 X96.973 Y98.52 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y97.092 E.04241
G1 X103.027 Y74.495 E.69458
G1 X103.027 Y73.067 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-.798 J-.919 P1  F42000
G1 X96.973 Y78.32 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y76.892 E.04241
G1 X103.027 Y75.27 E.18611
M204 S500
G1 X103.027 Y75.103 F42000
G1 F1680.297
M204 S6000
G1 X96.973 Y69.048 E.25424
G1 X96.973 Y71.347 E.06826
G1 X103.027 Y69.725 E.18612
G1 X103.027 Y67.528 E.06522
G1 X96.973 Y61.473 E.25424
G1 X96.973 Y60.257 E.03612
G1 X103.027 Y58.634 E.18612
G1 X103.027 Y59.953 E.03916
G1 X96.973 Y53.899 E.25424
G1 X96.973 Y52.47 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.217 J0 P1  F42000
G1 X96.973 Y54.712 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.027 Y53.089 E.18612
G1 X103.027 Y52.379 E.0211
G1 X96.972 Y46.324 E.25425
G1 X96.972 Y49.167 E.08441
G1 X103.027 Y47.544 E.18612
G1 X103.027 Y44.804 E.08136
G1 X102.043 Y43.82 E.04132
G1 X100.157 Y43.82 E.05603
G1 X96.973 Y55.703 E.36526
G1 X96.973 Y57.131 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.217 J0 P1  F42000
G1 X96.973 Y64.374 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X96.973 Y65.802 E.04241
G1 X103.027 Y64.18 E.18612
G1 X103.027 Y62.751 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I-1.217 J0 P1  F42000
G1 X103.027 Y145.928 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X103.027 Y147.357 E.04241
G1 X96.973 Y148.979 E.1861
G1 X96.973 Y147.551 E.04241
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 27/45
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
M106 S175.95
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z5.6 I1.215 J.074 P1  F42000
G1 X103.269 Y43.516 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.269 Y46.786 E.09707
G1 X103.268 Y156.488 E3.2571
G1 X96.732 Y156.488 E.19408
G1 X96.731 Y43.516 E3.35417
G1 X103.209 Y43.516 E.19236
M204 S500
G1 X103.626 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.626 Y46.786 E.10767
G1 X103.625 Y156.845 E3.2677
G1 X96.374 Y156.845 E.21529
G1 X96.373 Y43.159 E3.37537
G1 X103.566 Y43.159 E.21356
G1 E-.8 F1800
G17
G3 Z5.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.8 F4000
            G39.3 S1
            G0 Z5.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.642 Y50.365 F42000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.642 Y51.793 E.04241
G1 X97.358 Y46.509 E.22189
G1 X97.358 Y49.21 E.08019
G1 X102.642 Y47.794 E.16243
G1 X102.642 Y44.219 E.10615
G1 X102.243 Y43.82 E.01674
G1 X100.01 Y43.82 E.06631
G1 X97.358 Y53.718 E.30426
G1 X97.358 Y54.084 E.01086
G1 X102.642 Y59.368 E.22188
G1 X102.642 Y58.884 E.01437
G1 X97.358 Y60.3 E.16243
G1 X97.358 Y61.659 E.04035
G1 X102.642 Y66.943 E.22188
G1 X102.642 Y64.429 E.07463
G1 X97.358 Y65.845 E.16243
G1 X97.358 Y64.417 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I1.217 J0 P1  F42000
G1 X97.358 Y56.183 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
M73 P67 R13
G1 X97.358 Y54.755 E.04241
G1 X102.642 Y53.339 E.16243
G1 X102.642 Y54.692 E.04017
G1 X97.358 Y74.412 E.60618
G1 X97.358 Y75.841 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I.562 J1.079 P1  F42000
G1 X102.642 Y73.089 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.642 Y74.518 E.04241
G1 X97.358 Y69.234 E.22187
G1 X97.358 Y71.39 E.06403
G1 X102.642 Y69.974 E.16242
G1 X102.642 Y71.403 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-1.217 J0 P1  F42000
G1 X102.642 Y85.181 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.642 Y86.61 E.04241
G1 X97.358 Y88.026 E.16241
G1 X97.358 Y89.454 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-1.217 J0 P1  F42000
G1 X97.358 Y96.535 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.358 Y95.106 E.04241
G1 X102.642 Y75.387 E.60614
M73 P67 R12
G1 X102.642 Y75.519 E.00393
G1 X97.358 Y76.935 E.16242
G1 X97.358 Y76.808 E.00377
G1 X102.642 Y82.092 E.22187
G1 X102.642 Y81.065 E.03051
G1 X97.358 Y82.48 E.16242
G1 X97.358 Y84.383 E.0565
G1 X102.642 Y89.667 E.22186
G1 X102.642 Y92.155 E.07387
G1 X97.358 Y93.571 E.16241
G1 X97.358 Y91.958 E.04788
G1 X102.642 Y97.242 E.22186
G1 X102.642 Y97.7 E.01361
M73 P68 R12
G1 X97.358 Y99.116 E.16241
G1 X97.358 Y99.533 E.01239
G1 X102.642 Y104.816 E.22185
G1 X102.642 Y103.245 E.04665
G1 X97.358 Y104.661 E.1624
G1 X97.358 Y107.108 E.07265
G1 X102.642 Y112.391 E.22185
G1 X102.642 Y114.336 E.05773
G1 X97.358 Y115.751 E.1624
G1 X97.358 Y115.8 E.00146
G1 X102.642 Y96.082 E.6061
G1 X102.642 Y94.654 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-1.217 J0 P1  F42000
G1 X102.642 Y107.362 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.642 Y108.79 E.04241
G1 X97.358 Y110.206 E.1624
G1 X97.358 Y114.683 E.13292
G1 X102.642 Y119.966 E.22184
G1 X102.642 Y119.881 E.00253
G1 X97.358 Y121.296 E.1624
G1 X97.358 Y122.258 E.02854
G1 X102.642 Y127.541 E.22183
G1 X102.642 Y125.426 E.06279
G1 X97.359 Y126.841 E.16239
G1 X97.358 Y125.413 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-.749 J.959 P1  F42000
G1 X102.641 Y129.543 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.641 Y130.971 E.04241
G1 X97.359 Y132.387 E.16239
G1 X97.359 Y129.833 E.07583
G1 X102.641 Y135.115 E.22183
G1 X102.641 Y133.687 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-.678 J-1.011 P1  F42000
G1 X97.359 Y137.229 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.359 Y136.494 E.02181
G1 X102.642 Y116.778 E.60606
G1 X102.642 Y115.35 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-1.217 J0 P1  F42000
G1 X102.641 Y154.58 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.641 Y153.152 E.04241
G1 X97.359 Y154.567 E.16238
G1 X97.359 Y156.184 E.04801
G1 X97.628 Y156.184 E.00799
G1 X102.641 Y137.473 E.57514
G1 X102.641 Y136.516 E.02842
G1 X97.359 Y137.932 E.16239
G1 X97.359 Y137.407 E.01557
G1 X102.641 Y142.69 E.22182
G1 X102.641 Y142.061 E.01867
G1 X97.359 Y143.477 E.16238
G1 X97.359 Y144.982 E.0447
G1 X102.641 Y150.265 E.22182
G1 X102.641 Y147.606 E.07893
G1 X97.359 Y149.022 E.16238
G1 X97.359 Y152.557 E.10496
G1 X100.986 Y156.184 E.15229
G1 X102.414 Y156.184 E.04241
M204 S500
G1 X102.955 Y156.174 F42000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X102.956 Y43.89 E3.17439
; Slow Down End
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I-1.215 J-.064 P1  F42000
G1 X97.045 Y156.174 Z5.8
G1 Z5.4
G1 E.8 F1800
; Slow Down Start
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X97.044 Y43.89 E3.17439
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 28/45
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
M106 S178.5
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z5.8 I.074 J1.215 P1  F42000
G1 X103.187 Y43.516 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.186 Y46.703 E.09461
G1 X103.186 Y156.488 E3.25956
G1 X96.814 Y156.488 E.18916
G1 X96.813 Y43.516 E3.35417
G1 X103.127 Y43.516 E.18744
M204 S500
G1 X103.544 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.544 Y46.703 E.10521
G1 X103.543 Y156.845 E3.27016
G1 X96.457 Y156.845 E.21037
G1 X96.456 Y43.159 E3.37537
G1 X103.484 Y43.159 E.20864
G1 E-.8 F1800
G17
G3 Z6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6 F4000
            G39.3 S1
            G0 Z6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X102.516 Y50.039 F42000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.516 Y51.467 E.04241
G1 X97.484 Y46.435 E.21132
G1 X97.484 Y49.322 E.08573
G1 X102.516 Y47.974 E.1547
G1 X102.516 Y43.82 E.12334
G1 X99.864 Y43.82 E.07876
G1 X97.484 Y52.702 E.27303
G1 X97.484 Y53.831 E.03353
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-1.217 J0 P1  F42000
G1 X97.484 Y64.529 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.484 Y65.958 E.04241
G1 X102.516 Y64.609 E.15468
G1 X102.516 Y66.617 E.05961
G1 X97.484 Y61.585 E.2113
G1 X97.484 Y60.413 E.0348
G1 X102.516 Y59.064 E.15469
G1 X102.516 Y59.042 E.00065
G1 X97.484 Y54.01 E.21131
G1 X97.484 Y54.867 E.02547
G1 X102.516 Y53.519 E.15469
G1 X102.516 Y54.615 E.03255
G1 X97.484 Y73.396 E.57729
G1 X97.484 Y74.824 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-.209 J1.199 P1  F42000
G1 X102.516 Y75.7 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.484 Y77.048 E.15467
G1 X97.484 Y76.734 E.00931
G1 X102.516 Y81.766 E.21129
G1 X102.516 Y81.245 E.01548
G1 X97.484 Y82.593 E.15467
G1 X97.484 Y84.309 E.05096
G1 X102.516 Y89.341 E.21128
G1 X102.516 Y86.79 E.07574
M73 P69 R12
G1 X97.484 Y88.138 E.15466
G1 X97.484 Y91.884 E.11123
G1 X102.516 Y96.916 E.21127
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-1.217 J0 P1  F42000
G1 X102.516 Y99.309 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.516 Y97.88 E.04241
G1 X97.484 Y99.228 E.15465
G1 X97.484 Y99.459 E.00685
G1 X102.516 Y104.49 E.21126
G1 X102.516 Y103.425 E.03162
G1 X97.484 Y104.774 E.15465
G1 X97.484 Y107.034 E.06712
G1 X102.515 Y112.065 E.21125
G1 X102.515 Y108.971 E.09188
G1 X97.485 Y110.319 E.15465
G1 X97.485 Y111.747 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-1.217 J0 P1  F42000
G1 X97.485 Y117.292 Z6
G1 Z5.6
M73 P70 R11
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.485 Y115.864 E.04241
G1 X102.515 Y114.516 E.15464
G1 X102.515 Y116.702 E.06493
G1 X97.485 Y135.477 E.5771
G1 X97.485 Y136.905 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I.701 J.995 P1  F42000
G1 X102.515 Y133.361 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.515 Y134.789 E.04241
G1 X97.485 Y129.759 E.21122
G1 X97.485 Y132.499 E.08136
G1 X102.515 Y131.151 E.15463
G1 X102.515 Y129.723 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I.78 J-.934 P1  F42000
G1 X97.485 Y125.526 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.485 Y126.954 E.04241
G1 X102.515 Y125.606 E.15463
G1 X102.515 Y127.214 E.04775
G1 X97.485 Y122.184 E.21123
G1 X97.485 Y121.409 E.02301
G1 X102.515 Y120.061 E.15464
G1 X102.515 Y119.64 E.0125
G1 X97.485 Y114.609 E.21124
G1 X97.485 Y114.783 E.00517
G1 X102.516 Y96.007 E.57716
G1 X102.516 Y92.335 E.10901
G1 X97.484 Y93.683 E.15466
M204 S500
G1 X97.484 Y95.518 F42000
G1 F1680.297
M204 S6000
G1 X97.484 Y94.089 E.04241
G1 X102.516 Y75.311 E.57722
G1 X102.516 Y74.192 E.03324
G1 X97.484 Y69.16 E.21129
G1 X97.484 Y71.503 E.06958
G1 X102.516 Y70.155 E.15468
G1 X102.516 Y71.583 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-1.214 J-.08 P1  F42000
G1 X97.485 Y147.706 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.485 Y149.134 E.04241
G1 X102.515 Y147.787 E.15461
G1 X102.515 Y149.939 E.06389
G1 X97.485 Y144.909 E.21121
G1 X97.485 Y143.589 E.03917
G1 X102.515 Y142.242 E.15462
G1 X102.515 Y142.364 E.00363
G1 X97.485 Y137.334 E.21122
G1 X97.485 Y138.044 E.0211
G1 X102.515 Y136.696 E.15462
G1 X102.515 Y137.398 E.02084
G1 X97.485 Y156.184 E.57742
G1 X101.186 Y156.184 E.10987
G1 X97.485 Y152.483 E.15539
G1 X97.485 Y154.68 E.06521
G1 X102.515 Y153.332 E.15461
G1 X102.515 Y154.76 E.04241
M204 S500
G1 X102.85 Y156.152 F42000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F1764.706
M204 S6000
G1 X102.851 Y43.912 E3.17317
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I-1.215 J-.062 P1  F42000
G1 X97.15 Y156.152 Z6
G1 Z5.6
G1 E.8 F1800
G1 F1764.706
M204 S6000
G1 X97.149 Y43.912 E3.17317
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 29/45
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z6 I.081 J1.214 P1  F42000
G1 X103.104 Y43.516 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.104 Y46.62 E.09215
G1 X103.103 Y156.488 E3.26202
G1 X96.897 Y156.488 E.18424
G1 X96.896 Y43.516 E3.35417
G1 X103.044 Y43.516 E.18252
M204 S500
G1 X103.461 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.461 Y46.62 E.10275
G1 X103.46 Y156.845 E3.27262
G1 X96.54 Y156.845 E.20545
G1 X96.539 Y43.159 E3.37537
G1 X103.401 Y43.159 E.20372
G1 E-.8 F1800
G17
G3 Z6.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.2 F4000
            G39.3 S1
            G0 Z6.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X97.617 Y48.005 F42000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X97.617 Y49.433 E.04241
G1 X102.383 Y48.156 E.14648
G1 X102.383 Y51.134 E.08841
G1 X97.617 Y46.368 E.2001
G1 X97.617 Y43.82 E.07567
G1 X99.717 Y43.82 E.06235
G1 X97.617 Y51.657 E.2409
G1 X97.617 Y53.085 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I-1.165 J.351 P1  F42000
G1 X102.382 Y68.908 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.382 Y70.337 E.04241
G1 X97.618 Y71.613 E.14646
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I-1.217 J0 P1  F42000
G1 X97.618 Y73.779 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.618 Y72.351 E.04241
G1 X102.383 Y54.568 E.54663
G1 X102.383 Y53.701 E.02572
G1 X97.617 Y54.978 E.14648
G1 X97.617 Y53.943 E.03072
M73 P71 R11
G1 X102.383 Y58.709 E.20009
G1 X102.383 Y59.246 E.01597
G1 X97.617 Y60.523 E.14647
G1 X97.617 Y61.518 E.02954
G1 X102.382 Y66.283 E.20008
G1 X102.382 Y64.792 E.04429
G1 X97.618 Y66.068 E.14647
G1 X97.618 Y69.093 E.08981
G1 X102.382 Y73.858 E.20007
G1 X102.382 Y75.263 E.04173
G1 X97.618 Y93.044 E.54657
G1 X97.618 Y93.794 E.02226
G1 X102.382 Y92.517 E.14644
G1 X102.382 Y95.959 E.10219
G1 X97.618 Y113.738 E.5465
G1 X97.618 Y114.543 E.02389
G1 X102.382 Y119.306 E.20002
G1 X102.382 Y120.243 E.02782
G1 X97.618 Y121.519 E.14642
G1 X97.618 Y122.117 E.01776
G1 X102.382 Y126.881 E.20001
G1 X102.382 Y125.788 E.03244
G1 X97.618 Y127.065 E.14642
G1 X97.618 Y129.692 E.07802
G1 X102.382 Y134.455 E.2
G1 X102.382 Y131.333 E.0927
G1 X97.618 Y132.61 E.14641
G1 X97.618 Y131.181 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I-1.217 J0 P1  F42000
G1 X97.618 Y135.86 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.618 Y134.432 E.04241
G1 X102.382 Y116.655 E.54644
G1 X102.382 Y114.698 E.0581
G1 X97.618 Y115.974 E.14643
M73 P72 R11
G1 X97.618 Y117.403 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I1.217 J0 P1  F42000
G1 X97.618 Y109.001 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.618 Y110.429 E.04241
G1 X102.382 Y109.153 E.14643
G1 X102.382 Y111.731 E.07656
G1 X97.618 Y106.968 E.20003
G1 X97.618 Y104.884 E.06186
G1 X102.382 Y103.608 E.14644
G1 X102.382 Y104.157 E.0163
G1 X97.618 Y99.393 E.20004
G1 X97.618 Y99.339 E.0016
G1 X102.382 Y98.063 E.14644
G1 X102.382 Y99.491 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I1.217 J0 P1  F42000
G1 X102.382 Y96.582 Z6.2
G1 Z5.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.618 Y91.818 E.20005
G1 X97.618 Y88.249 E.10597
G1 X102.382 Y86.972 E.14645
G1 X102.382 Y89.007 E.06043
G1 X97.618 Y84.243 E.20005
G1 X97.618 Y82.704 E.0457
G1 X102.382 Y81.427 E.14645
G1 X97.618 Y76.668 E.19995
G1 X97.618 Y77.159 E.01456
G1 X102.382 Y75.882 E.14646
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I-1.217 J0 P1  F42000
G1 X102.381 Y152.086 Z6.2
G1 Z5.8
G1 E.8 F1800
M73 P72 R10
G1 F1680.297
M204 S6000
G1 X102.381 Y153.514 E.04241
G1 X97.619 Y154.79 E.14639
G1 X97.619 Y155.125 E.00995
G1 X102.381 Y137.351 E.54637
G1 X102.381 Y136.879 E.01402
G1 X97.619 Y138.155 E.14641
G1 X97.618 Y137.267 E.02635
G1 X102.381 Y142.03 E.19999
G1 X102.381 Y142.424 E.01169
G1 X97.619 Y143.7 E.1464
G1 X97.619 Y144.842 E.03391
G1 X102.381 Y149.605 E.19999
G1 X102.381 Y147.969 E.04857
G1 X97.619 Y149.245 E.1464
G1 X97.619 Y152.417 E.09418
G1 X101.386 Y156.184 E.15817
G1 X99.957 Y156.184 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I.026 J-1.217 P1  F42000
G1 X97.258 Y156.127 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.40715
G1 F1647.311
M204 S6000
G1 X97.257 Y43.937 E3.39777
G1 E-.8 F1800
M204 S500
G17
G3 Z6.2 I-1.216 J.059 P1  F42000
G1 X102.742 Y156.127 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.40716
G1 F1647.266
M204 S6000
G1 X102.743 Y43.937 E3.39786
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 30/45
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
; OBJECT_ID: 14
M204 S500
G1 X103.021 Y43.516 Z6 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X103.021 Y46.537 E.08969
G1 X103.02 Y156.488 E3.26448
G1 X96.98 Y156.488 E.17932
G1 X96.979 Y43.516 E3.35417
G1 X102.961 Y43.516 E.1776
M204 S500
G1 X103.378 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.378 Y46.537 E.10029
G1 X103.377 Y156.845 E3.27508
G1 X96.623 Y156.845 E.20052
G1 X96.622 Y43.159 E3.37537
G1 X103.318 Y43.159 E.1988
G1 E-.8 F1800
G17
G3 Z6.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.4 F4000
            G39.3 S1
            G0 Z6.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X97.751 Y49.544 F42000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X102.249 Y48.338 E.13827
G1 X102.249 Y50.8 E.0731
G1 X97.751 Y46.302 E.18887
G1 X97.751 Y43.998 E.0684
G1 X98.417 Y43.82 E.02049
G1 X99.571 Y43.82 E.03425
G1 X97.751 Y50.612 E.20878
G1 X97.751 Y52.04 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I-1.177 J.31 P1  F42000
G1 X102.249 Y69.091 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.249 Y70.519 E.04241
G1 X97.751 Y71.724 E.13825
G1 X97.751 Y71.306 E.01242
G1 X102.249 Y54.52 E.51597
G1 X102.249 Y53.883 E.0189
G1 X97.751 Y55.089 E.13826
G1 X97.751 Y53.877 E.03598
G1 X102.249 Y58.375 E.18887
M73 P73 R10
G1 X102.249 Y59.429 E.03129
G1 X97.751 Y60.634 E.13826
G1 X97.751 Y61.452 E.02429
G1 X102.249 Y65.95 E.18886
G1 X102.249 Y64.974 E.02897
G1 X97.751 Y66.179 E.13825
G1 X97.751 Y69.027 E.08456
G1 X102.249 Y73.524 E.18885
G1 X102.249 Y75.216 E.05022
G1 X97.751 Y91.999 E.51591
G1 X97.751 Y91.751 E.00736
G1 X102.248 Y96.248 E.18882
G1 X102.248 Y95.911 E.01
G1 X97.752 Y112.693 E.51584
G1 X97.752 Y114.121 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I1.217 J0 P1  F42000
G1 X97.752 Y109.112 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.752 Y110.54 E.04241
G1 X102.248 Y109.335 E.13821
G1 X102.248 Y111.398 E.06124
G1 X97.752 Y106.901 E.18881
G1 X97.752 Y104.995 E.05661
G1 X102.248 Y103.79 E.13822
G1 X102.248 Y103.823 E.00098
G1 X97.752 Y99.326 E.18881
G1 X97.752 Y99.45 E.00366
G1 X102.248 Y98.245 E.13822
G1 X102.248 Y99.673 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I.845 J-.876 P1  F42000
G1 X97.752 Y95.333 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.752 Y93.905 E.04241
G1 X102.248 Y92.7 E.13823
G1 X102.248 Y91.271 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I.845 J-.876 P1  F42000
G1 X97.751 Y86.931 Z6.4
G1 Z6
M73 P74 R10
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.751 Y88.359 E.04241
G1 X102.248 Y87.154 E.13823
G1 X102.248 Y88.674 E.04511
G1 X97.751 Y84.177 E.18883
G1 X97.751 Y82.814 E.04045
G1 X102.249 Y81.609 E.13824
G1 X102.249 Y81.099 E.01515
G1 X97.751 Y76.602 E.18884
G1 X97.751 Y77.269 E.01982
G1 X102.249 Y76.064 E.13824
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I-1.213 J-.096 P1  F42000
G1 X97.752 Y132.72 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.248 Y131.516 E.1382
G1 X102.248 Y134.122 E.07738
G1 X97.752 Y129.626 E.18878
G1 X97.752 Y127.175 E.07277
G1 X102.248 Y125.971 E.1382
G1 X102.248 Y126.547 E.01712
G1 X97.752 Y122.051 E.18879
G1 X97.752 Y121.63 E.0125
G1 X102.248 Y120.425 E.13821
G1 X102.248 Y118.972 E.04314
G1 X97.752 Y114.476 E.1888
G1 X97.752 Y116.085 E.04777
G1 X102.248 Y114.88 E.13821
G1 X102.248 Y116.607 E.05128
G1 X97.752 Y133.387 E.51578
G1 X97.752 Y134.815 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I-1.178 J.304 P1  F42000
G1 X102.248 Y152.268 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.248 Y153.696 E.04241
G1 X97.752 Y154.901 E.13818
G1 X97.752 Y154.08 E.02436
G1 X102.248 Y137.303 E.51571
G1 X102.248 Y137.061 E.00719
G1 X97.752 Y138.265 E.13819
G1 X97.752 Y137.201 E.03161
G1 X102.248 Y141.697 E.18877
G1 X102.248 Y142.606 E.027
G1 X97.752 Y143.811 E.13819
G1 X97.752 Y144.776 E.02866
G1 X102.248 Y149.271 E.18876
G1 X102.248 Y148.151 E.03326
G1 X97.752 Y149.356 E.13818
G1 X97.752 Y152.351 E.08893
G1 X101.586 Y156.184 E.16096
G1 X100.157 Y156.184 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I.041 J1.216 P1  F42000
G1 X102.634 Y156.101 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.45795
G1 F1445.679
M204 S6000
G1 X102.635 Y43.962 E3.86991
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I-1.216 J-.057 P1  F42000
G1 X97.366 Y156.101 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.45789
G1 F1445.888
M204 S6000
G1 X97.365 Y43.962 E3.86935
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 31/45
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z6.4 I.098 J1.213 P1  F42000
G1 X102.895 Y43.516 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.895 Y46.411 E.08595
G1 X102.893 Y156.488 E3.26822
G1 X97.107 Y156.488 E.17182
G1 X97.105 Y43.516 E3.35417
G1 X102.835 Y43.516 E.17013
M204 S500
G1 X103.252 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.252 Y46.411 E.09655
G1 X103.251 Y156.845 E3.27882
G1 X96.749 Y156.845 E.19302
G1 X96.748 Y43.159 E3.37537
G1 X103.192 Y43.159 E.19133
G1 E-.8 F1800
G17
G3 Z6.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.6 F4000
            G39.3 S1
            G0 Z6.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X98.785 Y43.82 F42000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X97.921 Y43.82 E.02566
G1 X97.921 Y44.099 E.0083
G1 X98.964 Y43.82 E.03205
G1 X99.424 Y43.82 E.01368
G1 X97.921 Y49.43 E.17245
G1 X97.921 Y49.644 E.00636
G1 X102.079 Y48.53 E.1278
G1 X102.079 Y50.43 E.0564
G1 X97.921 Y46.272 E.17458
G1 X97.921 Y44.844 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I-1.2 J.204 P1  F42000
G1 X102.078 Y69.283 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
M73 P75 R10
G1 X102.078 Y70.711 E.04241
G1 X97.922 Y71.825 E.12777
G1 X97.922 Y70.123 E.05052
M73 P75 R9
G1 X102.079 Y54.609 E.47689
G1 X102.079 Y54.076 E.01584
G1 X97.921 Y55.189 E.12779
G1 X97.921 Y53.847 E.03985
G1 X102.079 Y58.005 E.17456
G1 X102.079 Y59.621 E.04798
G1 X97.921 Y60.735 E.12778
G1 X97.921 Y61.422 E.02042
G1 X102.078 Y65.579 E.17455
G1 X102.078 Y65.166 E.01227
G1 X97.922 Y66.28 E.12778
G1 X97.922 Y68.997 E.08069
G1 X102.078 Y73.154 E.17454
G1 X102.078 Y75.305 E.06388
G1 X97.922 Y90.816 E.47679
G1 X97.922 Y91.722 E.02689
G1 X102.078 Y95.878 E.1745
G1 X102.078 Y96.002 E.00368
G1 X97.922 Y111.51 E.4767
G1 X97.922 Y112.938 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I1.217 J0 P1  F42000
G1 X97.922 Y110.641 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X102.078 Y109.527 E.12772
G1 X102.078 Y111.027 E.04453
G1 X97.922 Y106.872 E.17447
G1 X97.922 Y105.095 E.05275
G1 X102.078 Y103.982 E.12773
G1 X102.078 Y103.452 E.01572
G1 X97.922 Y99.297 E.17449
G1 X97.922 Y99.55 E.00752
G1 X102.078 Y98.437 E.12774
G1 X102.078 Y99.865 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I.888 J-.832 P1  F42000
G1 X97.922 Y95.434 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.922 Y94.005 E.04241
G1 X102.078 Y92.892 E.12774
G1 X102.078 Y91.463 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I.888 J-.832 P1  F42000
G1 X97.922 Y87.032 Z6.6
G1 Z6.2
M73 P76 R9
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.922 Y88.46 E.04241
G1 X102.078 Y87.347 E.12775
G1 X102.078 Y88.303 E.0284
G1 X97.922 Y84.147 E.17451
G1 X97.922 Y82.915 E.03658
G1 X102.078 Y81.801 E.12776
G1 X102.078 Y80.729 E.03185
G1 X97.922 Y76.572 E.17453
G1 X97.922 Y77.37 E.02369
G1 X102.078 Y76.256 E.12776
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I-1.213 J-.102 P1  F42000
G1 X97.923 Y125.848 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.923 Y127.276 E.04241
G1 X102.077 Y126.163 E.1277
G1 X102.077 Y126.176 E.00041
G1 X97.923 Y122.022 E.17445
G1 X97.923 Y121.731 E.00864
G1 X102.077 Y120.618 E.12771
G1 X102.077 Y118.602 E.05985
G1 X97.922 Y114.447 E.17446
G1 X97.923 Y116.186 E.05163
G1 X102.077 Y115.072 E.12772
G1 X102.077 Y116.698 E.04826
G1 X97.923 Y132.203 E.4766
G1 X97.923 Y132.821 E.01835
G1 X102.077 Y131.708 E.1277
G1 X102.077 Y133.751 E.06066
G1 X97.923 Y129.597 E.17444
G1 X97.923 Y128.168 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I-1.217 J0 P1  F42000
G1 X97.923 Y148.028 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X97.923 Y149.456 E.04241
G1 X102.077 Y148.343 E.12767
G1 X102.077 Y148.9 E.01654
G1 X97.923 Y144.747 E.17441
G1 X97.923 Y143.911 E.02481
G1 X102.077 Y142.798 E.12768
G1 X102.077 Y141.326 E.04372
G1 X97.923 Y137.172 E.17442
G1 X97.923 Y138.366 E.03546
G1 X102.077 Y137.253 E.12769
G1 X102.077 Y137.394 E.00419
G1 X97.923 Y152.896 E.47651
G1 X97.923 Y155.001 E.06251
G1 X102.077 Y153.889 E.12767
G1 X102.077 Y156.184 E.06816
G1 X101.786 Y156.184 E.00864
G1 X97.923 Y152.322 E.16218
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I-1.21 J-.131 P1  F42000
G1 X97.515 Y156.079 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.50239
G1 F1305.852
M204 S6000
G1 X97.513 Y43.984 E4.28259
G1 E-.8 F1800
M204 S500
G17
G3 Z6.6 I-1.216 J.054 P1  F42000
G1 X102.485 Y156.079 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.50242
G1 F1305.767
M204 S6000
G1 X102.487 Y43.984 E4.28286
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 32/45
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
; OBJECT_ID: 14
M204 S500
G1 X102.761 Y43.516 Z6.4 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.761 Y46.278 E.08199
G1 X102.76 Y156.488 E3.27218
G1 X97.24 Y156.488 E.16388
G1 X97.239 Y43.516 E3.35417
G1 X102.701 Y43.516 E.16219
M204 S500
G1 X103.118 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X103.118 Y46.278 E.09259
G1 X103.117 Y156.845 E3.28279
G1 X96.883 Y156.845 E.18508
G1 X96.882 Y43.159 E3.37537
G1 X103.058 Y43.159 E.18339
G1 E-.8 F1800
G17
G3 Z6.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.8 F4000
            G39.3 S1
            G0 Z6.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X98.519 Y43.82 F42000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X98.121 Y43.82 E.01183
G1 X98.121 Y44.192 E.01105
G1 X99.51 Y43.82 E.0427
G1 X99.278 Y43.82 E.00689
G1 X98.121 Y48.138 E.13272
G1 X98.121 Y49.737 E.0475
G1 X101.879 Y48.73 E.1155
G1 X101.879 Y50.03 E.03859
G1 X98.121 Y46.272 E.15778
G1 X98.121 Y44.844 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I-1.217 J0 P1  F42000
G1 X98.121 Y64.944 Z6.8
G1 Z6.4
M73 P77 R9
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.122 Y66.373 E.04241
G1 X101.878 Y65.366 E.11548
G1 X101.878 Y65.179 E.00554
G1 X98.121 Y61.422 E.15776
G1 X98.121 Y60.827 E.01766
G1 X101.879 Y59.821 E.11549
G1 X101.879 Y57.605 E.0658
G1 X98.121 Y53.847 E.15777
G1 X98.121 Y55.282 E.04261
G1 X101.879 Y54.276 E.1155
G1 X101.879 Y54.809 E.01584
G1 X98.122 Y68.831 E.43101
G1 X98.122 Y68.997 E.00494
G1 X101.878 Y72.754 E.15774
G1 X101.878 Y70.911 E.05472
G1 X98.122 Y71.918 E.11548
G1 X98.122 Y73.346 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I-.232 J1.195 P1  F42000
G1 X101.878 Y74.077 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.878 Y75.505 E.04241
G1 X98.122 Y89.524 E.43091
G1 X98.122 Y91.722 E.06527
G1 X101.878 Y95.478 E.15771
G1 X101.878 Y96.201 E.02149
G1 X98.122 Y110.217 E.43082
G1 X98.122 Y110.733 E.01533
G1 X101.878 Y109.727 E.11543
G1 X101.878 Y110.627 E.02672
G1 X98.122 Y106.872 E.15768
G1 X98.122 Y105.188 E.04999
G1 X101.878 Y104.182 E.11544
G1 X101.878 Y103.052 E.03354
G1 X98.122 Y99.297 E.15769
G1 X98.122 Y99.643 E.01028
G1 X101.878 Y98.637 E.11544
G1 X101.878 Y100.065 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I.938 J-.776 P1  F42000
G1 X98.122 Y95.526 Z6.8
G1 Z6.4
M73 P77 R8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.122 Y94.098 E.04241
G1 X101.878 Y93.092 E.11545
G1 X101.878 Y91.663 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P78 R8
G3 Z6.8 I.776 J-.937 P1  F42000
G1 X98.122 Y88.553 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.878 Y87.547 E.11546
G1 X101.878 Y87.903 E.01059
G1 X98.122 Y84.147 E.15772
G1 X98.122 Y83.008 E.03383
G1 X101.878 Y82.001 E.11546
G1 X101.878 Y80.329 E.04967
G1 X98.122 Y76.572 E.15773
G1 X98.122 Y77.463 E.02644
G1 X101.878 Y76.456 E.11547
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I-1.217 J0 P1  F42000
G1 X101.877 Y119.63 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.877 Y118.202 E.04241
G1 X98.122 Y114.447 E.15767
G1 X98.123 Y116.278 E.05438
G1 X101.877 Y115.272 E.11542
G1 X101.877 Y116.898 E.04826
G1 X98.123 Y130.91 E.43072
G1 X98.123 Y132.914 E.05949
G1 X101.877 Y131.908 E.1154
G1 X101.877 Y133.351 E.04285
G1 X98.123 Y129.597 E.15764
G1 X98.123 Y127.369 E.06616
G1 X101.877 Y126.363 E.11541
G1 X101.877 Y125.776 E.01741
G1 X98.123 Y122.022 E.15766
G1 X98.123 Y121.824 E.00589
G1 X101.877 Y120.818 E.11541
G1 X101.877 Y122.246 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I-1.204 J-.175 P1  F42000
G1 X98.123 Y148.121 Z6.8
G1 Z6.4
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.123 Y149.549 E.04241
G1 X101.877 Y148.543 E.11538
G1 X101.877 Y148.5 E.00128
G1 X98.123 Y144.747 E.15762
G1 X98.123 Y144.004 E.02205
G1 X101.877 Y142.998 E.11539
G1 X101.877 Y140.926 E.06153
G1 X98.123 Y137.172 E.15763
G1 X98.123 Y138.459 E.03822
G1 X101.877 Y137.453 E.11539
G1 X101.877 Y137.594 E.00419
G1 X98.123 Y151.603 E.43062
G1 X98.123 Y152.322 E.02133
G1 X101.877 Y156.075 E.1576
G1 X101.877 Y154.089 E.05898
G1 X98.123 Y155.094 E.11537
G1 X98.123 Y156.184 E.03236
G1 X98.462 Y156.184 E.01005
M204 S500
G1 X97.682 Y156.046 F42000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.56877
G1 F1141.01
M204 S6000
G1 X97.68 Y44.018 E4.89839
G1 E-.8 F1800
M204 S500
G17
G3 Z6.8 I-1.216 J.05 P1  F42000
G1 X102.318 Y156.046 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.56875
G1 F1141.053
M204 S6000
G1 X102.32 Y44.018 E4.8982
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 33/45
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
M106 S175.95
; OBJECT_ID: 14
M204 S500
G1 X102.628 Y43.516 Z6.6 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.628 Y46.144 E.07802
G1 X102.626 Y156.488 E3.27615
G1 X97.374 Y156.488 E.15595
G1 X97.372 Y43.516 E3.35417
G1 X102.568 Y43.516 E.15425
M204 S500
G1 X102.985 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.985 Y46.144 E.08862
G1 X102.983 Y156.845 E3.28675
G1 X97.017 Y156.845 E.17715
G1 X97.015 Y43.159 E3.37537
G1 X102.925 Y43.159 E.17546
G1 E-.8 F1800
G17
G3 Z7 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7 F4000
            G39.3 S1
            G0 Z7 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.485 Y43.82 F42000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X100.057 Y43.82 E.04241
G1 X98.321 Y44.285 E.05335
G1 X98.321 Y45.713 E.04241
M204 S500
G1 X98.321 Y46.272 F42000
G1 F1680.297
M204 S6000
G1 X101.679 Y49.63 E.14099
G1 X101.679 Y48.93 E.02077
G1 X98.321 Y49.83 E.10321
G1 X98.321 Y46.845 E.08864
G1 X99.132 Y43.82 E.09298
M73 P79 R8
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-1.216 J-.044 P1  F42000
G1 X98.322 Y66.465 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.678 Y65.566 E.10319
G1 X101.679 Y64.779 E.02335
G1 X98.321 Y61.422 E.14096
G1 X98.321 Y60.92 E.0149
G1 X101.679 Y60.021 E.1032
G1 X101.679 Y57.205 E.08361
G1 X98.321 Y53.847 E.14098
G1 X98.321 Y55.375 E.04536
G1 X101.679 Y54.476 E.1032
G1 X101.679 Y55.009 E.01583
G1 X98.322 Y67.538 E.38513
G1 X98.322 Y68.997 E.04333
G1 X101.678 Y72.354 E.14095
G1 X101.678 Y71.111 E.03691
G1 X98.322 Y72.01 E.10318
G1 X98.322 Y73.439 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-.295 J1.181 P1  F42000
G1 X101.678 Y74.277 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.678 Y75.705 E.04241
G1 X98.322 Y88.231 E.38503
G1 X98.322 Y88.646 E.01231
G1 X101.678 Y87.746 E.10316
G1 X101.678 Y87.503 E.00722
G1 X98.322 Y84.147 E.14093
G1 X98.322 Y83.101 E.03107
G1 X101.678 Y82.201 E.10317
G1 X101.678 Y79.929 E.06748
G1 X98.322 Y76.572 E.14094
G1 X98.322 Y77.556 E.0292
G1 X101.678 Y76.656 E.10318
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-1.217 J0 P1  F42000
G1 X101.678 Y91.863 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.678 Y93.292 E.04241
G1 X98.322 Y94.191 E.10315
G1 X98.322 Y91.722 E.0733
G1 X101.678 Y95.078 E.14091
G1 X101.678 Y96.401 E.0393
G1 X98.322 Y108.924 E.38494
G1 X98.322 Y110.826 E.05647
G1 X101.678 Y109.927 E.10313
G1 X101.678 Y110.227 E.00891
G1 X98.322 Y106.872 E.14089
G1 X98.322 Y105.281 E.04723
G1 X101.678 Y104.382 E.10314
M73 P80 R7
G1 X101.678 Y102.653 E.05135
G1 X98.322 Y99.297 E.1409
G1 X98.322 Y99.736 E.01303
G1 X101.678 Y98.837 E.10315
G1 X101.678 Y100.265 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-1.217 J0 P1  F42000
G1 X101.677 Y117.802 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.322 Y114.447 E.14087
G1 X98.323 Y116.371 E.05714
G1 X101.677 Y115.472 E.10313
G1 X101.677 Y117.098 E.04826
G1 X98.323 Y129.617 E.38484
G1 X98.323 Y129.597 E.00061
G1 X101.677 Y132.951 E.14085
G1 X101.677 Y132.108 E.02504
G1 X98.323 Y133.007 E.10311
G1 X98.323 Y134.435 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I1.217 J0 P1  F42000
G1 X98.323 Y126.033 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.323 Y127.461 E.04241
G1 X101.677 Y126.563 E.10311
G1 X101.677 Y125.376 E.03522
G1 X98.323 Y122.022 E.14086
G1 X98.323 Y121.916 E.00313
G1 X101.677 Y121.017 E.10312
G1 X101.677 Y122.446 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-1.208 J-.149 P1  F42000
G1 X98.323 Y149.642 Z7
G1 Z6.6
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.677 Y148.743 E.10309
G1 X101.677 Y148.1 E.01909
G1 X98.323 Y144.747 E.14082
G1 X98.323 Y144.097 E.0193
G1 X101.677 Y143.198 E.10309
G1 X101.677 Y140.526 E.07935
G1 X98.323 Y137.172 E.14083
G1 X98.323 Y138.552 E.04097
G1 X101.677 Y137.653 E.1031
G1 X101.677 Y137.794 E.00418
G1 X98.323 Y150.311 E.38474
G1 X98.323 Y152.322 E.05971
G1 X101.677 Y155.675 E.14081
G1 X101.677 Y154.288 E.04117
G1 X98.323 Y155.187 E.10308
G1 X98.323 Y156.184 E.0296
G1 X98.755 Y156.184 E.01281
M204 S500
G1 X97.849 Y156.013 F42000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.63515
G1 F1013.12
M204 S6000
G1 X97.847 Y44.051 E5.51346
G1 E-.8 F1800
M204 S500
G17
G3 Z7 I-1.216 J.047 P1  F42000
G1 X102.151 Y156.013 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.63505
G1 F1013.291
M204 S6000
G1 X102.153 Y44.051 E5.51254
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 34/45
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
; OBJECT_ID: 14
M204 S500
G1 X102.457 Y43.516 Z6.8 F42000
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.457 Y45.974 E.07296
G1 X102.455 Y156.488 E3.28121
G1 X97.545 Y156.488 E.14579
G1 X97.542 Y43.516 E3.35417
G1 X102.397 Y43.516 E.14415
M204 S500
G1 X102.815 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.814 Y45.974 E.08357
G1 X102.812 Y156.845 E3.29181
G1 X97.188 Y156.845 E.167
G1 X97.185 Y43.159 E3.37537
G1 X102.755 Y43.159 E.16535
G1 E-.8 F1800
G17
G3 Z7.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.2 F4000
            G39.3 S1
            G0 Z7.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.857 Y43.869 F42000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.39121
G1 F1722.702
M204 S6000
G1 X102.105 Y43.869 E.00717
G1 X102.105 Y44.043 E.00504
G1 X102.102 Y156.135 E3.24623
G1 X101.855 Y156.135 E.00716
; Slow Down Start
; LINE_WIDTH: 0.39121
G1 F1500;_EXTRUDE_SET_SPEED
M73 P81 R7
G1 X101.754 Y156.135 E.00294
G1 X101.757 Y43.869 E3.25126
; Slow Down End
; LINE_WIDTH: 0.39093
G1 F1724.088
G1 X101.797 Y43.869 E.00117
M204 S500
G1 X101.404 Y44.447 F42000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.404 Y43.82 E.01861
G1 X100.603 Y43.82 E.02379
G1 X98.596 Y44.358 E.06171
M204 S500
G1 X98.596 Y44.179 F42000
G1 F1680.297
M204 S6000
G1 X98.596 Y43.82 E.01067
G1 X98.985 Y43.82 E.01157
G1 X98.596 Y45.274 E.0447
G1 X98.596 Y46.347 E.03186
G1 X101.404 Y49.156 E.11794
G1 X98.596 Y49.903 E.08629
G1 X98.596 Y51.331 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.125 J.463 P1  F42000
G1 X101.404 Y58.158 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.404 Y56.73 E.04241
G1 X98.596 Y53.922 E.11792
G1 X98.596 Y55.448 E.04531
G1 X101.404 Y54.695 E.08632
G1 X101.404 Y55.487 E.02351
G1 X98.596 Y65.966 E.32212
G1 X98.596 Y66.538 E.01698
G1 X101.404 Y65.786 E.0863
G1 X101.404 Y64.305 E.04398
G1 X98.596 Y61.497 E.1179
G1 X98.596 Y60.993 E.01496
G1 X101.404 Y60.241 E.08631
G1 X101.404 Y61.669 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.16 J-.369 P1  F42000
G1 X98.596 Y70.5 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.596 Y69.072 E.04241
G1 X101.404 Y71.879 E.11788
G1 X101.404 Y71.331 E.01628
G1 X98.596 Y72.083 E.08629
G1 X98.596 Y73.512 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-.493 J1.113 P1  F42000
G1 X101.404 Y74.756 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.403 Y76.184 E.04241
G1 X98.597 Y86.659 E.32197
G1 X98.597 Y88.718 E.06116
G1 X101.403 Y87.967 E.08626
G1 X101.403 Y87.028 E.02786
G1 X98.597 Y84.222 E.11784
G1 X98.597 Y83.173 E.03113
G1 X101.403 Y82.421 E.08627
G1 X101.403 Y79.454 E.08811
M73 P82 R7
G1 X98.597 Y76.647 E.11786
G1 X98.597 Y77.628 E.02914
G1 X101.403 Y76.876 E.08628
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.191 J-.248 P1  F42000
G1 X98.597 Y90.369 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
M73 P82 R6
G1 X98.597 Y91.797 E.04241
G1 X101.403 Y94.603 E.11782
G1 X101.403 Y93.512 E.0324
G1 X98.597 Y94.264 E.08625
G1 X98.597 Y95.692 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I.103 J1.213 P1  F42000
G1 X101.403 Y95.453 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.403 Y96.881 E.04241
G1 X98.597 Y107.351 E.32183
G1 X98.598 Y110.899 E.10534
G1 X101.402 Y110.147 E.08622
G1 X101.402 Y109.752 E.01173
G1 X98.597 Y106.947 E.11778
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I1.217 J0 P1  F42000
G1 X98.597 Y103.925 Z7.2
M73 P83 R6
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.597 Y105.354 E.04241
G1 X101.403 Y104.602 E.08623
G1 X101.403 Y102.177 E.07199
G1 X98.597 Y99.372 E.1178
G1 X98.597 Y99.809 E.01296
G1 X101.403 Y99.057 E.08624
G1 X101.403 Y100.485 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.217 J0 P1  F42000
G1 X101.402 Y114.264 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.402 Y115.692 E.04241
G1 X98.598 Y116.444 E.08621
G1 X98.598 Y114.522 E.05706
G1 X101.402 Y117.327 E.11776
G1 X101.402 Y117.578 E.00747
G1 X98.598 Y128.044 E.32169
G1 X98.598 Y129.672 E.04835
G1 X101.402 Y132.476 E.11772
G1 X101.402 Y132.328 E.00439
G1 X98.598 Y133.079 E.08618
G1 X98.598 Y134.508 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I1.217 J0 P1  F42000
G1 X98.598 Y127.534 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.402 Y126.783 E.08619
G1 X101.402 Y124.901 E.05587
G1 X98.598 Y122.097 E.11774
G1 X98.598 Y121.989 E.00321
G1 X101.402 Y121.238 E.0862
G1 X101.402 Y122.666 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.217 J0 P1  F42000
G1 X101.402 Y141.479 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.402 Y140.05 E.04241
G1 X98.598 Y137.247 E.11771
G1 X98.598 Y138.624 E.04089
G1 X101.402 Y137.873 E.08617
G1 X101.402 Y138.275 E.01194
G1 X98.599 Y148.736 E.32154
G1 X98.599 Y149.715 E.02905
G1 X101.401 Y148.964 E.08615
G1 X101.401 Y147.625 E.03975
G1 X98.599 Y144.822 E.11769
G1 X98.599 Y144.169 E.01938
G1 X101.401 Y143.418 E.08616
G1 X101.401 Y144.847 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I-1.162 J-.363 P1  F42000
G1 X98.599 Y153.826 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.599 Y152.397 E.04241
G1 X101.401 Y155.199 E.11767
G1 X101.401 Y154.509 E.02051
G1 X98.599 Y155.26 E.08614
G1 X98.599 Y156.184 E.02745
G1 X99.103 Y156.184 E.01496
M204 S500
G1 X98.246 Y155.96 F42000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.39153
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X98.246 Y156.135 E.00505
G1 X98.145 Y156.135 E.00294
; Slow Down End
; LINE_WIDTH: 0.39126
G1 F1722.458
G1 X97.898 Y156.135 E.00716
G1 X97.895 Y43.869 E3.25173
G1 X98.243 Y43.869 E.01008
G1 X98.246 Y155.9 E3.24494
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 35/45
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z7.2 I1.216 J.043 P1  F42000
G1 X102.257 Y43.516 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.257 Y45.774 E.06703
G1 X102.255 Y156.488 E3.28714
G1 X97.745 Y156.488 E.13392
G1 X97.742 Y43.516 E3.35417
G1 X102.197 Y43.516 E.13227
M204 S500
G1 X102.615 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.615 Y45.774 E.07763
G1 X102.612 Y156.845 E3.29774
G1 X97.388 Y156.845 E.15512
G1 X97.385 Y43.159 E3.37537
G1 X102.555 Y43.159 E.15347
G1 E-.8 F1800
G17
G3 Z7.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.4 F4000
            G39.3 S1
            G0 Z7.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.482 Y44.093 F42000
G1 Z7
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.44063
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X101.482 Y43.894 E.00658
G1 X101.583 Y43.894 E.00333
; Slow Down End
; LINE_WIDTH: 0.44091
G1 F1507.576
G1 X101.88 Y43.894 E.00983
G1 X101.878 Y156.11 E3.71357
G1 X101.58 Y156.11 E.00986
; Slow Down Start
; LINE_WIDTH: 0.441004
G1 F1500;_EXTRUDE_SET_SPEED
G1 X101.479 Y156.11 E.00332
G1 X101.479 Y155.911 E.00659
; Slow Down End
; LINE_WIDTH: 0.44091
G1 F1507.576
G1 X101.482 Y44.153 E3.69841
M204 S500
G1 X101.105 Y45.26 F42000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X101.105 Y43.832 E.04241
G1 X98.895 Y44.424 E.06794
G1 X98.895 Y46.446 E.06004
G1 X101.105 Y48.656 E.0928
G1 X101.105 Y49.377 E.0214
G1 X98.895 Y49.969 E.06793
G1 X98.895 Y51.397 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-.838 J.883 P1  F42000
G1 X101.105 Y53.494 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.105 Y54.922 E.04241
G1 X98.895 Y55.514 E.06792
G1 X98.895 Y54.021 E.04433
G1 X101.105 Y56.231 E.09278
G1 X101.105 Y56.058 E.00513
G1 X98.896 Y64.303 E.25343
G1 X98.896 Y66.604 E.06833
G1 X101.104 Y66.012 E.0679
G1 X101.104 Y63.805 E.06553
G1 X98.895 Y61.596 E.09276
G1 X98.895 Y61.059 E.01595
G1 X101.105 Y60.467 E.06791
G1 X101.105 Y61.896 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.18 J-.299 P1  F42000
G1 X98.896 Y70.6 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.896 Y69.171 E.04241
G1 X101.104 Y71.38 E.09274
G1 X101.104 Y71.558 E.00528
G1 X98.896 Y72.149 E.06789
G1 X98.896 Y73.578 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.217 J0 P1  F42000
G1 X98.896 Y81.811 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.896 Y83.24 E.04241
G1 X101.104 Y82.648 E.06787
G1 X101.104 Y78.954 E.10967
G1 X98.896 Y76.746 E.09272
G1 X98.896 Y77.695 E.02815
G1 X101.104 Y77.103 E.06788
M73 P84 R6
G1 X101.104 Y76.755 E.01032
G1 X98.896 Y84.995 E.25329
G1 X98.896 Y86.424 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I1.217 J0 P1  F42000
G1 X98.896 Y84.321 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.104 Y86.529 E.0927
G1 X101.104 Y88.193 E.04941
G1 X98.896 Y88.785 E.06785
G1 X98.896 Y91.896 E.09239
G1 X101.104 Y94.104 E.09268
G1 X101.104 Y93.738 E.01084
G1 X98.896 Y94.33 E.06784
G1 X98.896 Y95.758 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-.146 J1.208 P1  F42000
G1 X101.104 Y96.024 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.103 Y97.452 E.04241
G1 X98.897 Y105.688 E.25315
G1 X98.897 Y105.42 E.00795
G1 X101.103 Y104.829 E.06782
G1 X101.103 Y101.678 E.09355
G1 X98.897 Y99.471 E.09266
G1 X98.897 Y99.875 E.01198
G1 X101.103 Y99.284 E.06783
G1 X101.103 Y100.712 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.171 J-.333 P1  F42000
G1 X98.897 Y108.475 Z7.4
M73 P85 R5
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.897 Y107.046 E.04241
G1 X101.103 Y109.253 E.09264
G1 X101.103 Y110.374 E.03329
G1 X98.897 Y110.965 E.06781
G1 X98.897 Y114.621 E.10856
G1 X101.103 Y116.827 E.09262
G1 X101.103 Y115.919 E.02696
G1 X98.897 Y116.51 E.0678
G1 X98.897 Y117.938 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I.474 J1.121 P1  F42000
G1 X101.103 Y117.006 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X101.103 Y118.149 E.03395
G1 X98.897 Y126.38 E.253
G1 X98.897 Y127.6 E.03623
G1 X101.103 Y127.009 E.06778
G1 X101.103 Y124.402 E.07742
G1 X98.897 Y122.196 E.0926
G1 X98.897 Y122.055 E.00419
G1 X101.103 Y121.464 E.06779
G1 X101.103 Y122.893 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.176 J-.312 P1  F42000
G1 X98.898 Y131.2 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.898 Y129.771 E.04241
G1 X101.102 Y131.976 E.09258
G1 X101.102 Y132.555 E.01717
G1 X98.898 Y133.145 E.06777
G1 X98.898 Y134.574 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.113 J.493 P1  F42000
G1 X101.102 Y139.551 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.898 Y137.347 E.09256
G1 X98.898 Y138.691 E.0399
G1 X101.102 Y138.1 E.06776
G1 X101.102 Y138.846 E.02217
G1 X98.898 Y147.073 E.25286
G1 X98.898 Y149.781 E.08041
G1 X101.102 Y149.19 E.06774
G1 X101.102 Y147.126 E.0613
G1 X98.898 Y144.922 E.09255
G1 X98.898 Y144.236 E.02037
G1 X101.102 Y143.645 E.06775
G1 X101.102 Y142.217 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I-1.196 J-.225 P1  F42000
G1 X98.898 Y153.925 Z7.4
G1 Z7
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X98.898 Y152.497 E.04241
G1 X101.102 Y154.7 E.09253
G1 X101.102 Y154.735 E.00105
G1 X98.898 Y155.326 E.06773
G1 X98.898 Y156.184 E.02548
G1 X99.468 Y156.184 E.01693
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I1.217 J-.01 P1  F42000
G1 X98.518 Y44.093 Z7.4
G1 Z7
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.440946
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X98.521 Y156.11 E3.70732
G1 X98.42 Y156.11 E.00332
; Slow Down End
; LINE_WIDTH: 0.440944
G1 F1507.447
G1 X98.122 Y156.11 E.00986
G1 X98.12 Y43.894 E3.71388
G1 X98.518 Y43.894 E.01316
G1 X98.518 Y44.033 E.0046
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 36/45
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
M106 S173.4
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z7.4 I.176 J1.204 P1  F42000
G1 X102.058 Y43.516 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X102.057 Y45.574 E.06109
G1 X102.055 Y156.488 E3.29308
G1 X97.945 Y156.488 E.12204
G1 X97.942 Y43.516 E3.35417
G1 X101.998 Y43.516 E.1204
M204 S500
G1 X102.415 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.415 Y45.574 E.07169
G1 X102.412 Y156.845 E3.30368
G1 X97.588 Y156.845 E.14325
G1 X97.585 Y43.159 E3.37537
G1 X102.355 Y43.159 E.1416
G1 E-.8 F1800
G17
G3 Z7.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.6 F4000
            G39.3 S1
            G0 Z7.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.132 Y44.193 F42000
G1 Z7.2
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.54066
G1 F1205.449;_EXTRUDE_SET_SPEED
M204 S6000
G1 X101.132 Y43.944 E.0103
G1 X101.284 Y43.944 E.00626
; Slow Down End
; LINE_WIDTH: 0.541465
G1 F1203.502
G1 X101.63 Y43.944 E.01436
G1 X101.627 Y155.81 E4.63731
G1 X101.627 Y156.059 E.01035
G1 X101.28 Y156.059 E.01438
; Slow Down Start
; LINE_WIDTH: 0.541771
G1 F1202.766;_EXTRUDE_SET_SPEED
G1 X101.128 Y156.059 E.00633
G1 X101.128 Y155.81 E.01036
; Slow Down End
; LINE_WIDTH: 0.541465
G1 F1203.502
G1 X101.132 Y44.253 E4.62451
M204 S500
G1 X100.705 Y45.514 F42000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X100.705 Y44.085 E.04241
G1 X99.295 Y44.463 E.04335
G1 X99.295 Y46.646 E.06482
G1 X100.705 Y48.056 E.0592
G1 X100.705 Y49.631 E.04675
G1 X99.295 Y50.008 E.04333
G1 X99.295 Y54.221 E.12509
G1 X100.705 Y55.631 E.05917
G1 X100.705 Y55.176 E.0135
G1 X99.295 Y55.553 E.04331
G1 X99.296 Y61.098 E.16464
G1 X100.704 Y60.721 E.0433
G1 X100.704 Y63.205 E.07375
G1 X99.296 Y61.797 E.05914
M204 S500
G1 X99.296 Y63.691 F42000
G1 F1680.297
M204 S6000
G1 X99.296 Y62.263 E.04241
G1 X100.704 Y57.006 E.1616
G1 X100.705 Y55.809 E.03553
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I-1.217 J0 P1  F42000
G1 X100.704 Y67.694 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.704 Y66.266 E.04241
G1 X99.296 Y66.643 E.04328
G1 X99.296 Y69.372 E.08101
G1 X100.704 Y70.779 E.05911
G1 X100.704 Y71.811 E.03064
G1 X99.296 Y72.189 E.04326
G1 X99.296 Y73.617 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I-1.167 J.347 P1  F42000
G1 X100.703 Y78.354 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X99.296 Y76.947 E.05908
G1 X99.297 Y77.734 E.02336
M73 P86 R5
G1 X100.703 Y77.357 E.04325
G1 X100.703 Y77.704 E.01032
G1 X99.297 Y82.954 E.16137
G1 X99.297 Y83.279 E.00965
G1 X100.703 Y82.902 E.04323
G1 X100.703 Y81.473 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I-1.161 J-.365 P1  F42000
G1 X99.297 Y85.95 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X99.297 Y84.522 E.04241
G1 X100.703 Y85.928 E.05904
G1 X100.703 Y88.447 E.07479
G1 X99.297 Y88.824 E.04321
G1 X99.297 Y92.097 E.0972
G1 X100.703 Y93.503 E.05901
G1 X100.703 Y93.992 E.01454
G1 X99.297 Y94.369 E.0432
G1 X99.297 Y95.797 E.04241
M204 S500
G1 X100.702 Y96.974 F42000
G1 F1680.297
M204 S6000
G1 X100.702 Y98.403 E.04241
G1 X99.298 Y103.645 E.16114
G1 X99.298 Y105.073 E.04241
G1 E-.8 F1800
M204 S500
G17
M73 P87 R5
G3 Z7.6 I1.153 J.388 P1  F42000
G1 X100.702 Y100.899 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.702 Y99.537 E.04041
G1 X99.298 Y99.914 E.04318
G1 X99.298 Y99.672 E.00717
G1 X100.702 Y101.077 E.05898
G1 X100.702 Y105.083 E.11893
G1 X99.298 Y105.459 E.04316
G1 X99.298 Y107.248 E.05311
G1 X100.702 Y108.652 E.05895
G1 X100.702 Y110.628 E.05868
G1 X99.298 Y111.004 E.04315
G1 X99.298 Y114.823 E.11338
G1 X100.702 Y116.226 E.05892
G1 X100.702 Y116.173 E.00157
G1 X99.298 Y116.549 E.04313
G1 X99.299 Y117.977 E.04241
M204 S500
G1 X100.701 Y117.673 F42000
G1 F1680.297
M204 S6000
G1 X100.701 Y119.101 E.04241
G1 X99.299 Y124.336 E.1609
G1 X99.299 Y125.764 E.04241
M73 P87 R4
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I1.073 J.575 P1  F42000
G1 X100.701 Y123.147 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.701 Y121.718 E.04241
G1 X99.299 Y122.094 E.04311
G1 X99.299 Y122.398 E.00902
G1 X100.701 Y123.8 E.05889
G1 X100.701 Y127.263 E.10282
G1 X99.299 Y127.639 E.0431
G1 X99.299 Y129.973 E.0693
G1 X100.701 Y131.375 E.05886
G1 X100.701 Y132.809 E.04257
G1 X99.299 Y133.184 E.04308
G1 X99.299 Y137.548 E.12957
G1 X100.7 Y138.949 E.05883
G1 X100.7 Y138.354 E.01768
G1 X99.3 Y138.729 E.04306
G1 X99.3 Y140.158 E.04241
M204 S500
G1 X100.7 Y139.128 F42000
G1 F1680.297
M204 S6000
G1 X100.7 Y139.8 E.01995
G1 X99.3 Y145.027 E.16067
G1 X99.3 Y145.123 E.00287
G1 X100.7 Y146.524 E.0588
G1 X100.7 Y143.899 E.07793
G1 X99.3 Y144.274 E.04305
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I-1.19 J.253 P1  F42000
G1 X100.7 Y150.873 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F1680.297
M204 S6000
G1 X100.7 Y149.444 E.04241
G1 X99.3 Y149.819 E.04303
G1 X99.3 Y152.699 E.08549
G1 X100.7 Y154.098 E.05876
G1 X100.7 Y154.99 E.02647
G1 X99.3 Y155.364 E.04301
G1 X99.3 Y156.184 E.02433
G1 X99.909 Y156.184 E.01807
M204 S500
G1 X98.872 Y155.81 F42000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.54225
G1 F1201.61;_EXTRUDE_SET_SPEED
M204 S6000
G1 X98.872 Y156.059 E.01037
G1 X98.72 Y156.059 E.00633
; Slow Down End
; LINE_WIDTH: 0.541443
G1 F1203.556
G1 X98.373 Y156.059 E.01438
G1 X98.37 Y43.944 E4.64745
G1 X98.868 Y43.944 E.02063
G1 X98.872 Y155.75 E4.63462
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 37/45
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
M106 S165.75
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z7.6 I1.217 J.032 P1  F42000
G1 X101.783 Y43.516 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X101.783 Y45.299 E.05294
G1 X101.78 Y156.488 E3.30123
G1 X98.22 Y156.488 E.10568
G1 X98.217 Y43.516 E3.35417
G1 X101.723 Y43.516 E.1041
M204 S500
G1 X102.14 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X102.14 Y45.299 E.06354
G1 X102.137 Y156.845 E3.31183
G1 X97.863 Y156.845 E.12688
G1 X97.86 Y43.159 E3.37537
G1 X102.08 Y43.159 E.1253
G1 E-.8 F1800
G17
G3 Z7.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
M73 P88 R4
G1 Z7.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.8 F4000
            G39.3 S1
            G0 Z7.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.426 Y43.873 F42000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
G1 F1680.343
M204 S6000
G1 X101.423 Y156.13 E3.33297
G1 X98.577 Y156.13 E.08447
G1 X98.574 Y43.873 E3.33297
G1 X101.366 Y43.873 E.08289
M204 S500
G1 X100.884 Y44.231 F42000
G1 F1680.343
M204 S6000
G1 X101.069 Y44.231 E.0055
G1 X101.066 Y155.773 E3.31176
G1 X98.934 Y155.773 E.06327
G1 X98.931 Y44.231 E3.31176
G1 X100.824 Y44.231 E.05619
G1 E-.8 F1800
M204 S500
G17
G3 Z7.8 I-1.217 J-.017 P1  F42000
G1 X99.292 Y155.416 Z7.8
G1 Z7.4
G1 E.8 F1800
; Slow Down Start
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X99.288 Y44.588 E3.29056
G1 X100.712 Y44.588 E.04227
G1 X100.708 Y155.416 E3.29056
G1 X99.352 Y155.416 E.04029
; Slow Down End
G1 E-.8 F1800
M204 S500
G17
G3 Z7.8 I1.217 J.011 P1  F42000
G1 X100.355 Y45.299 Z7.8
G1 Z7.4
G1 E.8 F1800
; Slow Down Start
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X100.351 Y155.059 E3.25883
G1 X99.649 Y155.059 E.02087
G1 X99.645 Y44.945 E3.26936
G1 X100.355 Y44.945 E.02106
G1 X100.355 Y45.239 E.00875
; Slow Down End
G1 E-.8 F1800
M204 S500
G17
G3 Z7.8 I-1.217 J-.004 P1  F42000
G1 X100 Y154.708 Z7.8
G1 Z7.4
G1 E.8 F1800
; Slow Down Start
; LINE_WIDTH: 0.38868
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X100 Y45.359 E3.14378
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 38/45
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
M106 S173.4
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z7.8 I.948 J.763 P1  F42000
G1 X101.484 Y43.516 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X101.484 Y45 E.04405
G1 X101.48 Y156.488 E3.31012
G1 X98.52 Y156.488 E.0879
G1 X98.516 Y43.516 E3.35417
G1 X101.424 Y43.516 E.08632
M204 S500
G1 X101.841 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.841 Y45 E.05465
G1 X101.837 Y156.845 E3.32072
G1 X98.163 Y156.845 E.1091
G1 X98.159 Y43.159 E3.37537
G1 X101.781 Y43.159 E.10753
G1 E-.8 F1800
G17
G3 Z8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8 F4000
            G39.3 S1
            G0 Z8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X100 Y155.007 F42000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.50739
G1 F1291.795
M204 S6000
G1 X100 Y45.06 E4.24625
M204 S500
G1 X100.412 Y45 F42000
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.412 Y44.588 E.01225
G1 X99.588 Y44.588 E.02449
G1 X99.591 Y155.416 E3.29056
G1 X100.409 Y155.416 E.02429
G1 X100.412 Y45.06 E3.27653
M204 S500
G1 X100.77 Y45 F42000
M73 P89 R4
G1 F1680.343
M204 S6000
G1 X100.77 Y44.231 E.02285
G1 X99.23 Y44.231 E.04569
G1 X99.234 Y155.773 E3.31176
G1 X100.766 Y155.773 E.0455
G1 X100.769 Y45.06 E3.28713
M204 S500
G1 X101.127 Y45 F42000
G1 F1680.343
M204 S6000
G1 X101.127 Y43.873 E.03345
G1 X98.873 Y43.873 E.0669
G1 X98.877 Y156.13 E3.33297
G1 X101.123 Y156.13 E.0667
G1 X101.127 Y45.06 E3.29774
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 39/45
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
M106 S181.05
; OBJECT_ID: 14
M204 S500
G1 X101.084 Y43.516 Z7.8 F42000
; FEATURE: Inner wall
G1 F1680.343
M204 S6000
G1 X101.084 Y44.6 E.03218
G1 X101.078 Y156.488 E3.32199
G1 X98.922 Y156.488 E.06402
G1 X98.916 Y43.516 E3.35417
G1 X101.024 Y43.516 E.06257
M204 S500
G1 X101.441 Y43.159 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.441 Y44.6 E.04278
G1 X101.435 Y156.845 E3.33259
G1 X98.565 Y156.845 E.08522
G1 X98.559 Y43.159 E3.37537
G1 X101.381 Y43.159 E.08377
G1 E-.8 F1800
G17
M73 P90 R3
G3 Z8.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.2 F4000
            G39.3 S1
            G0 Z8.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X100.036 Y43.82 F42000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
G1 F1680.297
M204 S6000
G1 X100.78 Y43.82 E.02208
G1 X100.78 Y44.504 E.02033
G1 X99.22 Y44.923 E.04796
G1 X99.22 Y45.971 E.03113
G1 X100.78 Y47.531 E.06551
G1 X100.78 Y50.05 E.07478
G1 X99.22 Y50.468 E.04795
G1 X99.22 Y51.896 E.04241
G1 E-.8 F1800
M204 S500
G17
G3 Z8.2 I-1.217 J.01 P1  F42000
G1 X100 Y143.617 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41962
M73 P91 R3
G1 F1592.779
M204 S6000
G1 X100 Y53.2 E2.83211
G1 E-.8 F1800
M204 S500
G17
G3 Z8.2 I-1.217 J.005 P1  F42000
G1 X100.365 Y143.982 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.369 Y52.771 E2.7081
G1 X99.631 Y52.771 E.02192
G1 X99.635 Y143.982 E2.7081
G1 X100.305 Y143.982 E.01987
M204 S500
G1 X100.722 Y143.617 F42000
G1 F1680.343
M204 S6000
G1 X100.726 Y52.409 E2.708
G1 X99.344 Y52.414 E.04104
G1 X99.274 Y52.39 E.0022
G1 X99.278 Y144.361 E2.73066
G1 X100 Y144.339 E.02144
G1 X100.711 Y144.339 E.0211
G1 X100.721 Y143.677 E.01965
G1 E-.8 F1800
M204 S500
G17
G3 Z8.2 I-1.015 J-.672 P1  F42000
G1 X99.225 Y145.937 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4
M73 P92 R3
G1 F1680.297
M204 S6000
G1 X99.225 Y144.812 E.03339
G1 X99.256 Y144.825 E.00101
G1 X99.386 Y144.696 E.00544
G1 X99.472 Y144.696 E.00257
G1 X100.775 Y145.999 E.05471
G1 X100.775 Y149.863 E.11475
G1 X99.225 Y150.279 E.04764
G1 X99.225 Y152.023 E.0518
G1 X100.042 Y152.84 E.03428
G1 X100.669 Y152.84 E.01863
G1 X100.743 Y152.765 E.00313
G1 X100.775 Y152.778 E.00101
G1 X100.775 Y152.117 E.01964
G1 E-.8 F1800
M204 S500
G17
G3 Z8.2 I-1.185 J-.279 P1  F42000
G1 X100 Y155.409 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41409
M73 P92 R2
G1 F1616.51
M204 S6000
G1 X100 Y153.978 E.04417
M204 S500
G1 X100.364 Y153.554 F42000
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X99.636 Y153.554 E.02163
G1 X99.636 Y155.773 E.0659
G1 X100.364 Y155.773 E.02162
G1 X100.364 Y153.614 E.06412
M204 S500
G1 X99.279 Y153.175 F42000
M73 P93 R2
G1 F1680.343
M204 S6000
G1 X99.279 Y156.13 E.08775
G1 X100.721 Y156.13 E.04282
G1 X100.721 Y153.194 E.08718
G1 X99.336 Y153.194 E.04114
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 40/45
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
M106 S186.15
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z8.2 I1.217 J-.002 P1  F42000
G1 X99.156 Y52.435 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1680.343
M204 S6000
G1 X99.156 Y43.512 E.26492
G1 X100.899 Y43.512 E.05176
G1 X100.899 Y44.384 E.02588
G1 X100.899 Y52.435 E.23904
G1 X99.216 Y52.435 E.04998
G1 E-.8 F1800
M204 S500
G17
G3 Z8.4 I-1.217 J.021 P1  F42000
G1 X100.788 Y144.317 Z8.4
G1 Z8
M73 P94 R2
G1 E.8 F1800
G1 F1680.343
M204 S6000
G1 X100.899 Y144.317 E.00331
G1 X100.899 Y153.218 E.26429
G1 X99.156 Y153.218 E.05176
G1 X99.156 Y144.317 E.26429
G1 X100.728 Y144.317 E.04668
M204 S500
G1 X100.931 Y143.76 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X100.966 Y143.866 E.00332
G1 X101.11 Y143.939 E.00477
G1 X101.256 Y143.939 E.00435
G1 X101.256 Y153.597 E.28676
G1 X101.109 Y153.597 E.00438
G1 X100.971 Y153.661 E.0045
G1 X100.93 Y153.776 E.00361
G1 X100.93 Y156.845 E.09112
G1 X99.07 Y156.845 E.05521
G1 X99.07 Y153.776 E.09112
G1 X99.059 Y153.714 E.00187
G1 X98.891 Y153.597 E.00606
G1 X98.799 Y153.597 E.00275
G1 X98.799 Y143.939 E.28676
G1 X98.89 Y143.939 E.00273
G1 X99.034 Y143.866 E.00477
G1 X99.069 Y143.76 E.00332
G1 X99.06 Y52.992 E2.69494
G1 X99.049 Y52.932 E.00183
G1 X98.881 Y52.814 E.00609
G1 X98.799 Y52.814 E.00245
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X101.119 Y52.814 E.00408
G1 X100.98 Y52.88 E.00455
G1 X100.94 Y52.992 E.00355
G1 X100.931 Y143.7 E2.69316
G1 E-.8 F1800
G17
G3 Z8.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.4 F4000
            G39.3 S1
            G0 Z8.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


M73 P95 R1
G1 X100.22 Y144.174 F42000
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.4005
G1 F1677.946
G1 X100.628 Y143.766 E.01715
G1 X100.628 Y143.261 E.01504
G1 X99.875 Y144.014 E.03166
G1 X99.369 Y144.014 E.01504
G1 X100.628 Y142.755 E.05293
G1 X100.628 Y142.249 E.01504
G1 X99.372 Y143.505 E.0528
G1 X99.372 Y142.999 E.01503
G1 X100.628 Y141.743 E.0528
G1 X100.628 Y141.238 E.01504
G1 X99.372 Y142.494 E.0528
G1 X99.372 Y141.988 E.01503
G1 X100.628 Y140.732 E.05281
G1 X100.628 Y140.226 E.01504
G1 X99.372 Y141.482 E.05281
G1 X99.372 Y140.977 E.01503
G1 X100.628 Y139.721 E.05282
G1 X100.628 Y139.215 E.01504
G1 X99.372 Y140.471 E.05282
G1 X99.372 Y139.965 E.01503
G1 X100.628 Y138.709 E.05283
G1 X100.628 Y138.203 E.01504
G1 X99.372 Y139.46 E.05283
G1 X99.372 Y138.954 E.01503
G1 X100.628 Y137.698 E.05283
G1 X100.628 Y137.192 E.01504
G1 X99.372 Y138.448 E.05284
G1 X99.372 Y137.943 E.01503
G1 X100.628 Y136.686 E.05284
G1 X100.628 Y136.18 E.01504
G1 X99.372 Y137.437 E.05285
G1 X99.372 Y136.931 E.01503
G1 X100.628 Y135.675 E.05285
G1 X100.629 Y135.169 E.01504
G1 X99.372 Y136.426 E.05285
G1 X99.371 Y135.92 E.01503
G1 X100.629 Y134.663 E.05286
G1 X100.629 Y134.157 E.01504
G1 X99.371 Y135.415 E.05286
G1 X99.371 Y134.909 E.01503
G1 X100.629 Y133.652 E.05287
G1 X100.629 Y133.146 E.01504
G1 X99.371 Y134.403 E.05287
G1 X99.371 Y133.898 E.01503
G1 X100.629 Y132.64 E.05288
G1 X100.629 Y132.134 E.01504
G1 X99.371 Y133.392 E.05288
G1 X99.371 Y132.886 E.01503
G1 X100.629 Y131.629 E.05288
G1 X100.629 Y131.123 E.01504
G1 X99.371 Y132.381 E.05289
G1 X99.371 Y131.875 E.01503
G1 X100.629 Y130.617 E.05289
G1 X100.629 Y130.111 E.01504
G1 X99.371 Y131.369 E.0529
G1 X99.371 Y130.864 E.01503
G1 X100.629 Y129.606 E.0529
G1 X100.629 Y129.1 E.01504
G1 X99.371 Y130.358 E.05291
G1 X99.371 Y129.852 E.01503
G1 X100.629 Y128.594 E.05291
G1 X100.629 Y128.088 E.01504
G1 X99.371 Y129.347 E.05291
G1 X99.371 Y128.841 E.01503
G1 X100.629 Y127.583 E.05292
G1 X100.629 Y127.077 E.01504
G1 X99.371 Y128.336 E.05292
G1 X99.371 Y127.83 E.01503
G1 X100.629 Y126.571 E.05293
G1 X100.629 Y126.065 E.01504
G1 X99.371 Y127.324 E.05293
G1 X99.371 Y126.819 E.01503
G1 X100.629 Y125.56 E.05294
G1 X100.63 Y125.054 E.01504
G1 X99.371 Y126.313 E.05294
G1 X99.37 Y125.807 E.01503
G1 X100.63 Y124.548 E.05294
G1 X100.63 Y124.042 E.01504
G1 X99.37 Y125.302 E.05295
G1 X99.37 Y124.796 E.01503
G1 X100.63 Y123.537 E.05295
G1 X100.63 Y123.031 E.01504
G1 X99.37 Y124.29 E.05296
G1 X99.37 Y123.785 E.01503
G1 X100.63 Y122.525 E.05296
G1 X100.63 Y122.019 E.01504
G1 X99.37 Y123.279 E.05297
G1 X99.37 Y122.773 E.01503
G1 X100.63 Y121.514 E.05297
G1 X100.63 Y121.008 E.01504
G1 X99.37 Y122.268 E.05297
G1 X99.37 Y121.762 E.01503
G1 X100.63 Y120.502 E.05298
G1 X100.63 Y119.996 E.01504
G1 X99.37 Y121.256 E.05298
G1 X99.37 Y120.751 E.01503
G1 X100.63 Y119.491 E.05299
G1 X100.63 Y118.985 E.01504
G1 X99.37 Y120.245 E.05299
G1 X99.37 Y119.74 E.01503
G1 X100.63 Y118.479 E.05299
G1 X100.63 Y117.973 E.01504
G1 X99.37 Y119.234 E.053
G1 X99.37 Y118.728 E.01503
G1 X100.63 Y117.468 E.053
G1 X100.63 Y116.962 E.01504
G1 X99.37 Y118.223 E.05301
G1 X99.37 Y117.717 E.01503
G1 X100.63 Y116.456 E.05301
G1 X100.63 Y115.951 E.01504
G1 X99.37 Y117.211 E.05302
G1 X99.37 Y116.706 E.01503
G1 X100.63 Y115.445 E.05302
G1 X100.631 Y114.939 E.01504
G1 X99.37 Y116.2 E.05302
G1 X99.369 Y115.694 E.01503
G1 X100.631 Y114.433 E.05303
G1 X100.631 Y113.928 E.01504
G1 X99.369 Y115.189 E.05303
G1 X99.369 Y114.683 E.01503
G1 X100.631 Y113.422 E.05304
G1 X100.631 Y112.916 E.01504
G1 X99.369 Y114.177 E.05304
G1 X99.369 Y113.672 E.01503
G1 X100.631 Y112.41 E.05305
G1 X100.631 Y111.905 E.01504
G1 X99.369 Y113.166 E.05305
G1 X99.369 Y112.661 E.01503
G1 X100.631 Y111.399 E.05305
G1 X100.631 Y110.893 E.01504
G1 X99.369 Y112.155 E.05306
G1 X99.369 Y111.649 E.01503
G1 X100.631 Y110.387 E.05306
G1 X100.631 Y109.882 E.01504
G1 X99.369 Y111.144 E.05307
G1 X99.369 Y110.638 E.01503
G1 X100.631 Y109.376 E.05307
G1 X100.631 Y108.87 E.01504
G1 X99.369 Y110.132 E.05308
G1 X99.369 Y109.627 E.01503
G1 X100.631 Y108.364 E.05308
G1 X100.631 Y107.859 E.01504
G1 X99.369 Y109.121 E.05308
G1 X99.369 Y108.615 E.01503
G1 X100.631 Y107.353 E.05309
G1 X100.631 Y106.847 E.01504
G1 X99.369 Y108.11 E.05309
G1 X99.369 Y107.604 E.01503
G1 X100.631 Y106.341 E.0531
G1 X100.631 Y105.836 E.01504
G1 X99.369 Y107.098 E.0531
G1 X99.369 Y106.593 E.01503
G1 X100.631 Y105.33 E.05311
M73 P96 R1
G1 X100.632 Y104.824 E.01504
G1 X99.368 Y106.087 E.05311
G1 X99.368 Y105.582 E.01503
G1 X100.632 Y104.318 E.05311
G1 X100.632 Y103.813 E.01504
G1 X99.368 Y105.076 E.05312
G1 X99.368 Y104.57 E.01503
G1 X100.632 Y103.307 E.05312
G1 X100.632 Y102.801 E.01504
G1 X99.368 Y104.065 E.05313
G1 X99.368 Y103.559 E.01503
G1 X100.632 Y102.295 E.05313
G1 X100.632 Y101.79 E.01504
G1 X99.368 Y103.053 E.05314
G1 X99.368 Y102.548 E.01503
G1 X100.632 Y101.284 E.05314
G1 X100.632 Y100.778 E.01504
G1 X99.368 Y102.042 E.05314
G1 X99.368 Y101.536 E.01503
G1 X100.632 Y100.272 E.05315
G1 X100.632 Y99.767 E.01504
G1 X99.368 Y101.031 E.05315
G1 X99.368 Y100.525 E.01503
G1 X100.632 Y99.261 E.05316
G1 X100.632 Y98.755 E.01504
G1 X99.368 Y100.019 E.05316
G1 X99.368 Y99.514 E.01503
G1 X100.632 Y98.249 E.05316
G1 X100.632 Y97.744 E.01504
G1 X99.368 Y99.008 E.05317
G1 X99.368 Y98.503 E.01503
G1 X100.632 Y97.238 E.05317
G1 X100.632 Y96.732 E.01504
G1 X99.368 Y97.997 E.05318
G1 X99.368 Y97.491 E.01503
G1 X100.632 Y96.226 E.05318
G1 X100.632 Y95.721 E.01504
G1 X99.368 Y96.986 E.05319
G1 X99.368 Y96.48 E.01503
G1 X100.632 Y95.215 E.05319
G1 X100.633 Y94.709 E.01504
G1 X99.367 Y95.974 E.05319
G1 X99.367 Y95.469 E.01503
G1 X100.633 Y94.204 E.0532
G1 X100.633 Y93.698 E.01504
G1 X99.367 Y94.963 E.0532
G1 X99.367 Y94.457 E.01503
G1 X100.633 Y93.192 E.05321
G1 X100.633 Y92.686 E.01504
G1 X99.367 Y93.952 E.05321
G1 X99.367 Y93.446 E.01503
G1 X100.633 Y92.181 E.05322
G1 X100.633 Y91.675 E.01504
G1 X99.367 Y92.94 E.05322
G1 X99.367 Y92.435 E.01503
G1 X100.633 Y91.169 E.05322
G1 X100.633 Y90.663 E.01504
G1 X99.367 Y91.929 E.05323
G1 X99.367 Y91.424 E.01503
G1 X100.633 Y90.158 E.05323
G1 X100.633 Y89.652 E.01504
G1 X99.367 Y90.918 E.05324
G1 X99.367 Y90.412 E.01503
G1 X100.633 Y89.146 E.05324
G1 X100.633 Y88.64 E.01504
G1 X99.367 Y89.907 E.05325
G1 X99.367 Y89.401 E.01503
G1 X100.633 Y88.135 E.05325
G1 X100.633 Y87.629 E.01504
G1 X99.367 Y88.895 E.05325
G1 X99.367 Y88.39 E.01503
G1 X100.633 Y87.123 E.05326
G1 X100.633 Y86.617 E.01504
G1 X99.367 Y87.884 E.05326
G1 X99.367 Y87.378 E.01503
G1 X100.633 Y86.112 E.05327
G1 X100.633 Y85.606 E.01504
G1 X99.367 Y86.873 E.05327
G1 X99.367 Y86.367 E.01503
G1 X100.633 Y85.1 E.05328
G1 X100.634 Y84.594 E.01504
G1 X99.366 Y85.861 E.05328
G1 X99.366 Y85.356 E.01503
G1 X100.634 Y84.089 E.05328
G1 X100.634 Y83.583 E.01504
G1 X99.366 Y84.85 E.05329
G1 X99.366 Y84.345 E.01503
G1 X100.634 Y83.077 E.05329
G1 X100.634 Y82.571 E.01504
G1 X99.366 Y83.839 E.0533
G1 X99.366 Y83.333 E.01503
G1 X100.634 Y82.066 E.0533
G1 X100.634 Y81.56 E.01504
G1 X99.366 Y82.828 E.0533
G1 X99.366 Y82.322 E.01503
G1 X100.634 Y81.054 E.05331
G1 X100.634 Y80.548 E.01504
G1 X99.366 Y81.816 E.05331
G1 X99.366 Y81.311 E.01503
G1 X100.634 Y80.043 E.05332
G1 X100.634 Y79.537 E.01504
G1 X99.366 Y80.805 E.05332
G1 X99.366 Y80.299 E.01503
G1 X100.634 Y79.031 E.05333
G1 X100.634 Y78.525 E.01504
G1 X99.366 Y79.794 E.05333
G1 X99.366 Y79.288 E.01503
G1 X100.634 Y78.02 E.05333
G1 X100.634 Y77.514 E.01504
G1 X99.366 Y78.782 E.05334
G1 X99.366 Y78.277 E.01503
G1 X100.634 Y77.008 E.05334
G1 X100.634 Y76.502 E.01504
G1 X99.366 Y77.771 E.05335
G1 X99.366 Y77.266 E.01503
G1 X100.634 Y75.997 E.05335
G1 X100.634 Y75.491 E.01504
G1 X99.366 Y76.76 E.05336
G1 X99.365 Y76.254 E.01503
G1 X100.634 Y74.985 E.05336
G1 X100.635 Y74.479 E.01504
G1 X99.365 Y75.749 E.05336
G1 X99.365 Y75.243 E.01503
G1 X100.635 Y73.974 E.05337
G1 X100.635 Y73.468 E.01504
G1 X99.365 Y74.737 E.05337
G1 X99.365 Y74.232 E.01503
G1 X100.635 Y72.962 E.05338
G1 X100.635 Y72.457 E.01504
G1 X99.365 Y73.726 E.05338
G1 X99.365 Y73.22 E.01503
G1 X100.635 Y71.951 E.05339
G1 X100.635 Y71.445 E.01504
G1 X99.365 Y72.715 E.05339
G1 X99.365 Y72.209 E.01503
G1 X100.635 Y70.939 E.05339
G1 X100.635 Y70.434 E.01504
G1 X99.365 Y71.703 E.0534
G1 X99.365 Y71.198 E.01503
G1 X100.635 Y69.928 E.0534
G1 X100.635 Y69.422 E.01504
G1 X99.365 Y70.692 E.05341
G1 X99.365 Y70.187 E.01503
G1 X100.635 Y68.916 E.05341
G1 X100.635 Y68.411 E.01504
G1 X99.365 Y69.681 E.05341
G1 X99.365 Y69.175 E.01503
G1 X100.635 Y67.905 E.05342
G1 X100.635 Y67.399 E.01504
G1 X99.365 Y68.67 E.05342
G1 X99.365 Y68.164 E.01503
G1 X100.635 Y66.893 E.05343
G1 X100.635 Y66.388 E.01504
G1 X99.365 Y67.658 E.05343
G1 X99.365 Y67.153 E.01503
G1 X100.635 Y65.882 E.05344
G1 X100.635 Y65.376 E.01504
G1 X99.365 Y66.647 E.05344
G1 X99.364 Y66.141 E.01503
G1 X100.635 Y64.87 E.05345
G1 X100.636 Y64.365 E.01504
G1 X99.364 Y65.636 E.05345
G1 X99.364 Y65.13 E.01503
G1 X100.636 Y63.859 E.05345
G1 X100.636 Y63.353 E.01504
G1 X99.364 Y64.624 E.05346
G1 X99.364 Y64.119 E.01503
G1 X100.636 Y62.847 E.05346
G1 X100.636 Y62.342 E.01504
G1 X99.364 Y63.613 E.05347
G1 X99.364 Y63.108 E.01503
G1 X100.636 Y61.836 E.05347
G1 X100.636 Y61.33 E.01504
G1 X99.364 Y62.602 E.05347
G1 X99.364 Y62.096 E.01503
G1 X100.636 Y60.824 E.05348
G1 X100.636 Y60.319 E.01504
G1 X99.364 Y61.591 E.05348
G1 X99.364 Y61.085 E.01503
G1 X100.636 Y59.813 E.05349
G1 X100.636 Y59.307 E.01504
G1 X99.364 Y60.579 E.05349
G1 X99.364 Y60.074 E.01503
G1 X100.636 Y58.801 E.0535
G1 X100.636 Y58.296 E.01504
G1 X99.364 Y59.568 E.0535
G1 X99.364 Y59.062 E.01503
G1 X100.636 Y57.79 E.0535
G1 X100.636 Y57.284 E.01504
G1 X99.364 Y58.557 E.05351
G1 X99.364 Y58.051 E.01503
G1 X100.636 Y56.778 E.05351
G1 X100.636 Y56.273 E.01504
G1 X99.364 Y57.545 E.05352
G1 X99.364 Y57.04 E.01503
G1 X100.636 Y55.767 E.05352
G1 X100.636 Y55.261 E.01504
G1 X99.363 Y56.534 E.05353
G1 X99.363 Y56.028 E.01503
G1 X100.636 Y54.755 E.05353
G1 X100.637 Y54.25 E.01504
G1 X99.363 Y55.523 E.05353
G1 X99.363 Y55.017 E.01503
G1 X100.637 Y53.744 E.05354
G1 X100.637 Y53.238 E.01504
G1 X99.363 Y54.512 E.05354
G1 X99.363 Y54.006 E.01503
G1 X100.63 Y52.739 E.05329
G1 X100.125 Y52.739 E.01504
G1 X99.363 Y53.5 E.03202
G1 X99.363 Y52.995 E.01503
G1 X99.78 Y52.578 E.01752
G1 E-.8 F1800
G17
G3 Z8.4 I1.212 J.106 P1  F42000
G1 X100.542 Y43.87 Z8.4
G1 Z8
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.39999
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X100.542 Y52.078 E.24372
G1 X99.513 Y52.078 E.03056
G1 X99.513 Y43.87 E.24372
G1 X100.482 Y43.87 E.02878
; Slow Down End
M204 S500
G1 X100.195 Y44.384 F42000
; Slow Down Start
; LINE_WIDTH: 0.379015
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X100.195 Y51.732 E.20534
G1 X99.859 Y51.732 E.00939
G1 X99.859 Y44.216 E.21003
G1 X100.195 Y44.216 E.00939
G1 X100.195 Y44.324 E.00302
; Slow Down End
G1 E-.8 F1800
M204 S500
G17
G3 Z8.4 I-1.217 J.004 P1  F42000
G1 X100.542 Y152.861 Z8.4
G1 Z8
G1 E.8 F1800
; Slow Down Start
; LINE_WIDTH: 0.39999
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X99.513 Y152.861 E.03056
G1 X99.513 Y144.674 E.24308
G1 X100.542 Y144.674 E.03056
G1 X100.542 Y152.801 E.2413
; Slow Down End
M204 S500
G1 X99.859 Y152.515 F42000
; Slow Down Start
; LINE_WIDTH: 0.37902
G1 F1500;_EXTRUDE_SET_SPEED
M204 S6000
G1 X99.859 Y145.021 E.20943
G1 X100.195 Y145.021 E.00939
G1 X100.195 Y152.515 E.20943
G1 X99.919 Y152.515 E.00772
; Slow Down End
M204 S500
G1 X99.213 Y153.947 F42000
; FEATURE: Top surface
; LINE_WIDTH: 0.406
G1 F1652.528
G1 X99.638 Y153.522 E.01817
G1 X100.152 Y153.522 E.0155
G1 X99.373 Y154.3 E.03323
G1 X99.373 Y154.814 E.0155
G1 X100.665 Y153.522 E.05515
G1 X100.705 Y153.522 E.00119
G1 X100.655 Y153.608 E.003
G1 X100.627 Y153.764 E.0048
G1 X100.627 Y154.074 E.00934
G1 X99.373 Y155.327 E.05351
G1 X99.374 Y155.84 E.0155
G1 X100.627 Y154.587 E.0535
G1 X100.627 Y155.101 E.0155
G1 X99.374 Y156.354 E.05349
G1 X99.374 Y156.541 E.00566
G1 X99.7 Y156.541 E.00984
G1 X100.626 Y155.614 E.03957
G1 X100.626 Y156.128 E.0155
G1 X100.052 Y156.702 E.02451
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 41/45
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
M106 S201.45
; OBJECT_ID: 14
G1 E-.8 F1800
G17
G3 Z8.4 I1.214 J.083 P1  F42000
G1 X100.899 Y144.296 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.899 Y145.167 E.02588
G1 X100.899 Y153.24 E.23968
G1 X99.156 Y153.24 E.05176
G1 X99.156 Y144.296 E.26556
G1 X100.839 Y144.296 E.04998
M204 S500
G1 X101.256 Y143.939 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.256 Y145.167 E.03648
G1 X101.256 Y153.597 E.25028
G1 X98.799 Y153.597 E.07296
G1 X98.799 Y143.939 E.28676
G1 X101.196 Y143.939 E.07118
G1 E-.8 F1800
G17
G3 Z8.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.6
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.6 F4000
            G39.3 S1
            G0 Z8.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X99.513 Y144.653 F42000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X99.513 Y152.883 E.24436
G1 X100.542 Y152.883 E.03056
G1 X100.542 Y144.653 E.24436
G1 X99.573 Y144.653 E.02878
M204 S500
G1 X99.859 Y144.999 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X99.859 Y152.536 E.21063
G1 X100.195 Y152.536 E.00939
G1 X100.195 Y144.999 E.21063
G1 X99.919 Y144.999 E.00772
G1 E-.8 F1800
M204 S500
G17
G3 Z8.6 I1.217 J-.01 P1  F42000
G1 X99.156 Y52.457 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X99.156 Y43.512 E.26556
G1 X100.899 Y43.512 E.05176
G1 X100.899 Y44.384 E.02588
G1 X100.899 Y52.457 E.23968
G1 X99.216 Y52.457 E.04998
M204 S500
G1 X98.799 Y52.814 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X98.859 Y52.814 E.07118
G1 X99.513 Y52.1 F42000
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X100.542 Y52.1 E.03056
G1 X100.542 Y43.87 E.24436
G1 X99.513 Y43.87 E.03056
G1 X99.513 Y52.04 E.24258
M204 S500
G1 X99.859 Y51.753 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X100.195 Y51.753 E.00939
G1 X100.195 Y44.216 E.21062
G1 X99.859 Y44.216 E.00939
G1 X99.859 Y51.693 E.20895
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 42/45
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z8.6 I-1.217 J.014 P1  F42000
G1 X100.899 Y144.296 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.899 Y145.167 E.02588
G1 X100.899 Y153.24 E.23968
G1 X99.156 Y153.24 E.05176
G1 X99.156 Y144.296 E.26556
G1 X100.839 Y144.296 E.04998
M204 S500
G1 X101.256 Y143.939 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.256 Y145.167 E.03648
G1 X101.256 Y153.597 E.25028
G1 X98.799 Y153.597 E.07296
G1 X98.799 Y143.939 E.28676
G1 X101.196 Y143.939 E.07118
G1 E-.8 F1800
G17
G3 Z8.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.8
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.8 F4000
            G39.3 S1
            G0 Z8.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X99.513 Y144.653 F42000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X99.513 Y152.883 E.24436
G1 X100.542 Y152.883 E.03056
G1 X100.542 Y144.653 E.24436
G1 X99.573 Y144.653 E.02878
M204 S500
G1 X99.859 Y144.999 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X99.859 Y152.536 E.21063
G1 X100.195 Y152.536 E.00939
G1 X100.195 Y144.999 E.21063
G1 X99.919 Y144.999 E.00772
G1 E-.8 F1800
M204 S500
G17
G3 Z8.8 I1.217 J-.01 P1  F42000
G1 X99.156 Y52.457 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X99.156 Y43.512 E.26556
G1 X100.899 Y43.512 E.05176
G1 X100.899 Y44.384 E.02588
G1 X100.899 Y52.457 E.23968
G1 X99.216 Y52.457 E.04998
M204 S500
G1 X98.799 Y52.814 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X98.859 Y52.814 E.07118
G1 X99.513 Y52.1 F42000
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
M73 P97 R1
G1 X100.542 Y52.1 E.03056
G1 X100.542 Y43.87 E.24436
G1 X99.513 Y43.87 E.03056
G1 X99.513 Y52.04 E.24258
M204 S500
G1 X99.859 Y51.753 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X100.195 Y51.753 E.00939
G1 X100.195 Y44.216 E.21062
G1 X99.859 Y44.216 E.00939
G1 X99.859 Y51.693 E.20895
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; layer num/total_layer_count: 43/45
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z8.8 I-1.217 J.014 P1  F42000
G1 X100.899 Y144.296 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.899 Y145.167 E.02588
G1 X100.899 Y153.24 E.23968
G1 X99.156 Y153.24 E.05176
G1 X99.156 Y144.296 E.26556
G1 X100.839 Y144.296 E.04998
M204 S500
G1 X101.256 Y143.939 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.256 Y145.167 E.03648
G1 X101.256 Y153.597 E.25028
G1 X98.799 Y153.597 E.07296
G1 X98.799 Y143.939 E.28676
G1 X101.196 Y143.939 E.07118
G1 E-.8 F1800
G17
G3 Z9 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9 F4000
            G39.3 S1
            G0 Z9 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X99.513 Y144.653 F42000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X99.513 Y152.883 E.24436
G1 X100.542 Y152.883 E.03056
G1 X100.542 Y144.653 E.24436
G1 X99.573 Y144.653 E.02878
M204 S500
G1 X99.859 Y144.999 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X99.859 Y152.536 E.21063
G1 X100.195 Y152.536 E.00939
G1 X100.195 Y144.999 E.21063
G1 X99.919 Y144.999 E.00772
G1 E-.8 F1800
M204 S500
G17
G3 Z9 I1.217 J-.01 P1  F42000
G1 X99.156 Y52.457 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X99.156 Y43.512 E.26556
G1 X100.899 Y43.512 E.05176
G1 X100.899 Y44.384 E.02588
G1 X100.899 Y52.457 E.23968
G1 X99.216 Y52.457 E.04998
M204 S500
G1 X98.799 Y52.814 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X98.859 Y52.814 E.07118
G1 X99.513 Y52.1 F42000
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X100.542 Y52.1 E.03056
G1 X100.542 Y43.87 E.24436
M73 P97 R0
G1 X99.513 Y43.87 E.03056
G1 X99.513 Y52.04 E.24258
M204 S500
G1 X99.859 Y51.753 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X100.195 Y51.753 E.00939
G1 X100.195 Y44.216 E.21062
G1 X99.859 Y44.216 E.00939
G1 X99.859 Y51.693 E.20895
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 44/45
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z9 I-1.217 J.014 P1  F42000
G1 X100.899 Y144.296 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X100.899 Y145.167 E.02588
G1 X100.899 Y153.24 E.23968
G1 X99.156 Y153.24 E.05176
G1 X99.156 Y144.296 E.26556
G1 X100.839 Y144.296 E.04998
M204 S500
G1 X101.256 Y143.939 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X101.256 Y145.167 E.03648
G1 X101.256 Y153.597 E.25028
G1 X98.799 Y153.597 E.07296
G1 X98.799 Y143.939 E.28676
G1 X101.196 Y143.939 E.07118
G1 E-.8 F1800
G17
G3 Z9.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9.2
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.2 F4000
            G39.3 S1
            G0 Z9.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X99.513 Y144.653 F42000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X99.513 Y152.883 E.24436
G1 X100.542 Y152.883 E.03056
G1 X100.542 Y144.653 E.24436
G1 X99.573 Y144.653 E.02878
M204 S500
G1 X99.859 Y144.999 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X99.859 Y152.536 E.21063
G1 X100.195 Y152.536 E.00939
G1 X100.195 Y144.999 E.21063
G1 X99.919 Y144.999 E.00772
G1 E-.8 F1800
M204 S500
G17
G3 Z9.2 I1.217 J-.01 P1  F42000
G1 X99.156 Y52.457 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.39999
G1 F1680.343
M204 S6000
G1 X99.156 Y43.512 E.26556
G1 X100.899 Y43.512 E.05176
G1 X100.899 Y44.384 E.02588
G1 X100.899 Y52.457 E.23968
G1 X99.216 Y52.457 E.04998
M204 S500
G1 X98.799 Y52.814 F42000
; FEATURE: Outer wall
G1 F1680.343
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X98.859 Y52.814 E.07118
G1 X99.513 Y52.1 F42000
; FEATURE: Internal solid infill
G1 F1680.343
M204 S6000
G1 X100.542 Y52.1 E.03056
G1 X100.542 Y43.87 E.24436
G1 X99.513 Y43.87 E.03056
M73 P98 R0
G1 X99.513 Y52.04 E.24258
M204 S500
G1 X99.859 Y51.753 F42000
; LINE_WIDTH: 0.379005
G1 F1785.263
M204 S6000
G1 X100.195 Y51.753 E.00939
G1 X100.195 Y44.216 E.21062
G1 X99.859 Y44.216 E.00939
G1 X99.859 Y51.693 E.20895
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 45/45
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
; OBJECT_ID: 14
G1 E-.8 F1800
M204 S500
G17
G3 Z9.2 I-1.217 J.018 P1  F42000
G1 X101.256 Y143.939 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.39999
G1 F1680.343
G1 X101.256 Y145.167 E.03648
G1 X101.256 Y153.597 E.25028
G1 X98.799 Y153.597 E.07296
G1 X98.799 Y143.939 E.28676
G1 X101.196 Y143.939 E.07118
G1 E-.8 F1800
G17
G3 Z9.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9.4
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.4 F4000
            G39.3 S1
            G0 Z9.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X101.113 Y144.803 F42000
G1 Z9
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.40005
G1 F1680.06
G1 X100.552 Y144.242 E.02357
G1 X100.047 Y144.242 E.015
G1 X100.953 Y145.148 E.03803
G1 X100.953 Y145.653 E.015
G1 X99.542 Y144.242 E.05924
G1 X99.102 Y144.242 E.01307
G1 X99.102 Y144.307 E.00193
G1 X100.953 Y146.158 E.07772
G1 X100.953 Y146.663 E.015
G1 X99.102 Y144.812 E.07772
G1 X99.102 Y145.317 E.015
G1 X100.953 Y147.168 E.07772
G1 X100.953 Y147.673 E.015
G1 X99.102 Y145.822 E.07772
G1 X99.102 Y146.327 E.015
G1 X100.953 Y148.178 E.07772
G1 X100.953 Y148.683 E.015
G1 X99.102 Y146.832 E.07772
G1 X99.102 Y147.337 E.015
G1 X100.953 Y149.188 E.07772
G1 X100.953 Y149.693 E.015
G1 X99.102 Y147.842 E.07772
G1 X99.102 Y148.348 E.015
G1 X100.953 Y150.198 E.07772
G1 X100.953 Y150.703 E.015
G1 X99.102 Y148.853 E.07772
G1 X99.102 Y149.358 E.015
G1 X100.953 Y151.208 E.07772
G1 X100.953 Y151.713 E.015
G1 X99.102 Y149.863 E.07772
G1 X99.102 Y150.368 E.015
G1 X100.953 Y152.218 E.07772
G1 X100.953 Y152.724 E.015
G1 X99.102 Y150.873 E.07772
G1 X99.102 Y151.378 E.015
G1 X100.953 Y153.229 E.07772
G1 X100.953 Y153.294 E.00193
G1 X100.513 Y153.294 E.01307
G1 X99.102 Y151.883 E.05924
G1 X99.102 Y152.388 E.015
G1 X100.008 Y153.294 E.03803
G1 X99.502 Y153.294 E.015
G1 X98.941 Y152.732 E.02357
G1 E-.8 F1800
G17
G3 Z9.4 I1.217 J-.002 P1  F42000
G1 X98.799 Y52.814 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.39999
G1 F1680.343
G1 X98.799 Y43.155 E.28676
G1 X101.256 Y43.155 E.07296
G1 X101.256 Y44.384 E.03648
G1 X101.256 Y52.814 E.25028
G1 X98.859 Y52.814 E.07118
G1 X98.941 Y51.949 F42000
; FEATURE: Top surface
; LINE_WIDTH: 0.40005
G1 F1680.06
G1 X99.503 Y52.51 E.02357
G1 X100.008 Y52.51 E.015
G1 X99.102 Y51.605 E.03803
G1 X99.102 Y51.1 E.015
G1 X100.513 Y52.51 E.05924
G1 X100.953 Y52.51 E.01307
G1 X100.953 Y52.445 E.00193
G1 X99.102 Y50.595 E.07772
G1 X99.102 Y50.09 E.015
G1 X100.953 Y51.94 E.07772
G1 X100.953 Y51.435 E.015
G1 X99.102 Y49.585 E.07772
G1 X99.102 Y49.08 E.015
G1 X100.953 Y50.93 E.07772
G1 X100.953 Y50.425 E.015
G1 X99.102 Y48.574 E.07772
G1 X99.102 Y48.069 E.015
G1 X100.953 Y49.92 E.07772
G1 X100.953 Y49.415 E.015
G1 X99.102 Y47.564 E.07772
G1 X99.102 Y47.059 E.015
G1 X100.953 Y48.91 E.07772
G1 X100.953 Y48.405 E.015
G1 X99.102 Y46.554 E.07772
G1 X99.102 Y46.049 E.015
G1 X100.953 Y47.9 E.07772
G1 X100.953 Y47.395 E.015
G1 X99.102 Y45.544 E.07772
G1 X99.102 Y45.039 E.015
G1 X100.953 Y46.89 E.07772
G1 X100.953 Y46.385 E.015
G1 X99.102 Y44.534 E.07772
G1 X99.102 Y44.029 E.015
G1 X100.953 Y45.88 E.07772
G1 X100.953 Y45.375 E.015
G1 X99.102 Y43.524 E.07772
G1 X99.102 Y43.459 E.00193
G1 X99.542 Y43.459 E.01307
G1 X100.953 Y44.87 E.05924
G1 X100.953 Y44.364 E.015
G1 X100.047 Y43.459 E.03803
G1 X100.552 Y43.459 E.015
G1 X101.113 Y44.02 E.02357
; close powerlost recovery
M1003 S0
G1 E-.8 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
;===== date: 20231229 =====================
G392 S0 ;turn off nozzle clog detect

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z9.5 F900 ; lower z a little
G1 X0 Y100.002 F18000 ; move to safe pos
G1 X-13.0 F3000 ; move to safe pos

M1002 judge_flag timelapse_record_flag
M622 J1
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M991 S0 P-1 ;end timelapse at safe pos
M623


M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

;G1 X27 F15000 ; wipe

; pull back filament to AMS
M620 S255
G1 X267 F15000
T255
M73 P99 R0
G1 X-28.5 F18000
G1 X-48.2 F3000
G1 X-28.5 F18000
G1 X-48.2 F3000
M621 S255

M104 S0 ; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z109 F600
    G1 Z107

M400 P100
M17 R ; restore z current

G90
G1 X-48 Y180 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W
;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M400
M18 X Y Z

M73 P100 R0
; EXECUTABLE_BLOCK_END

