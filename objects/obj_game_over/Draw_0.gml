
draw_set_alpha(current_a_rect);
draw_set_color(c_black)
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_alpha(current_a_text);
draw_set_font(fnt_gui);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(room_width / 2, room_height / 2 - 20, caption);
draw_text(room_width / 2, room_height / 2 + 20, text);
draw_text(room_width / 2, room_height - 120, "Press R to try again");
