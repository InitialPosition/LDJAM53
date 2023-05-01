/// @description 

part = part_type_create();
part_type_alpha3(part, 0, 1, 0);
part_type_color1(part, c_white);
part_type_blend(part, false);
part_type_direction(part, 0, 360, 0, 0);
part_type_size(part, 1, 2, 0, 0);
part_type_speed(part, 0.2, 0.4, 0, 0);

part_sys = part_system_create();
part_emit = part_emitter_create(part_sys);
part_emitter_region(part_sys, part_emit, -30, room_width, -30, room_height, ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(part_sys, part_emit, part, 1);