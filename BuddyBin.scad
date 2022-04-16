//
// Table Catch
// Original Design by Sean Wesenberg
// MIT License 2022
// 
// keywords
// 
//         above (arm)
// h        ___
// e        | table  
// i front  |_______  back
// g        |      /   
// h  angle  \____/  angle
// t          under
//         l e n g t h
// 
// x = height
// y = width
// x = length 
// translate = pos(ition)
// size = dim(ension)
// 

// PARAMS - user adjustable
table_thickness = 44.5; // default 44.75 butcher block
bin_width = 132; // default 132mm which is 16x LEGO studs
bin_arm_height = 20;
bin_arm_length = 80;    // default 90 
bin_front_length = 36;    // default 36 
bin_under_height = 35;   // default 35
bin_under_length = 78;    // default 78

// PARAMS - adjust at your own risk 
bin_wall_thickness = 1.6; // default 1.2mm - 3x 0.40mm nozzle
edge_padding = 3.6; // default 2.4
bin_front_extra_height = 30; // below the table height

// CALCULATIONS based on params
bin_front_height_without_extra = bin_arm_height + table_thickness;
bin_front_height_total = bin_arm_height + table_thickness + bin_front_extra_height;

bin_front_hypotenuse = sqrt(pow(bin_under_height, 2) + pow(bin_under_height, 2));
bin_back_hypotenuse = sqrt(pow(bin_under_height + bin_front_extra_height, 2) + pow(bin_under_height + bin_front_extra_height, 2));

bin_front_angle = 45; // don't do less than 30 degrees
bin_back_angle = 45; // don't do less than 30 degrees

draw_middle();
draw_side(bin_wall_thickness); // right
draw_side(bin_width); // left

module draw_middle() {
  // front face
  cube([bin_front_height_total - 2, bin_width, bin_wall_thickness]);
  // front padding / brace
  rotate(a=[270, 270, 0]) 
    right_triangle(edge_padding, edge_padding * 2, .5, bin_width);

  // front angle
  translate([bin_front_height_total - 1, 0, 0]) 
    rotate(a=[0, -bin_front_angle, 0]) 
      cube([bin_front_hypotenuse, bin_width, bin_wall_thickness]);

  // bottom 
  translate([bin_under_height + bin_front_height_total - 1, 0, bin_under_height]) 
    rotate(a=[0, -90, 0]) 
      cube([bin_under_length, bin_width, bin_wall_thickness]);

  // back angle
  translate([bin_front_height_without_extra + 1, 0, bin_under_height + bin_front_extra_height + bin_under_length + bin_under_height - 4]) 
    rotate(a=[0, bin_back_angle, 0]) 
      cube([bin_back_hypotenuse - 4, bin_width, bin_wall_thickness]);

}

// SIDE FUNCTION
// y_move is the movement along the y_axis to translate the shapes, typically this is just the width of the bin
module draw_side(y_pos) {
  draw_arm(y_pos);
  draw_arm_padding(y_pos);
  draw_front_side(y_pos);
  draw_front_side_padding(y_pos);
  draw_front_extra(y_pos);
  draw_front_angle(y_pos);
  draw_bottom_side(y_pos);
  draw_bottom_side_padding(y_pos);
  draw_back_angle(y_pos);
}

module draw_arm(y_pos) {
  position = [
    bin_arm_height, // x
    y_pos,          // y
    0               // z
  ];
  translate(position)
    rotate(a=[90, -90, 0])
      right_triangle(bin_arm_length, bin_arm_height, 4, bin_wall_thickness);
}
module draw_arm_padding(y_pos) {
  position = [
    bin_arm_height - edge_padding,                      // x
    y_pos - edge_padding / 2 - bin_wall_thickness / 2,  // y
    bin_front_length                                    // z
  ];
  size = [
    edge_padding,                     // height - x
    edge_padding,                     // width - y
    bin_arm_length - bin_front_length // length - z
  ];
  translate(position)
    cube(size);
}

module draw_front_side(y_pos) {
  position = [
    bin_arm_height - 1,         // x
    y_pos - bin_wall_thickness, // y
    0                           // z
  ];
  size = [
    table_thickness,        // height - x
    bin_wall_thickness,     // width - y
    bin_front_length        // length - z
  ];
  translate(position) 
    cube(size);
}

module draw_front_side_padding(y_pos) {
  inner_pad_position = [
    bin_arm_height - edge_padding,  // x
    y_pos - 0.2,                    // y
    bin_front_length                // z
  ];
  translate(inner_pad_position)
    rotate(a=[0, 90, 0]) 
      right_triangle(3, 1.4, 0.1, table_thickness + edge_padding * 2);
  outer_pad_position = [
    bin_arm_height + table_thickness + edge_padding,  // x
    y_pos - bin_wall_thickness + 1.2,                 // y
    bin_front_length                                  // z
  ];
  translate(outer_pad_position)
    rotate(a=[0, 90, 180]) 
      right_triangle(5, 2.4, 0.1, table_thickness + edge_padding * 2);
}

module draw_front_extra(y_pos) {
  position = [
    bin_arm_height + table_thickness - 1, // x
    y_pos - bin_wall_thickness,           // y
    0
  ];
  size = [
    bin_front_extra_height, // height - x
    bin_wall_thickness,     // width - y
    bin_front_length        // length - z
  ];
  translate(position) 
    cube(size);
}

module draw_front_angle(y_pos) {
  position = [
    bin_front_height_total - 1.2,   // x
    y_pos,                        // y
    bin_under_height              // z
  ];
  translate(position) 
    rotate(a=[90, 90, 0]) 
      right_triangle(bin_under_height, bin_under_height, 0.1, bin_wall_thickness);
}

module draw_bottom_side(y_pos) {
  position = [
    bin_front_height_without_extra, // x
    y_pos,                          // y
    bin_front_length - 1.2                // z
  ];
  size = [
    bin_front_extra_height + bin_under_height - 1,  // height
    bin_under_length,                               // length
    bin_wall_thickness                              // width 
  ];
  translate(position) 
    rotate(a=[90, 0, 0]) 
      cube(size);
}

module draw_bottom_side_padding(y_pos) {
  position = [
    bin_front_height_without_extra,     // x
    y_pos - bin_wall_thickness / 2 - 2, // y
    bin_front_length                    // z
  ];
  size = [
    edge_padding, 
    edge_padding,
    bin_under_length + bin_under_height + bin_front_extra_height - 7
  ];
  translate(position)
    cube(size);
}

module draw_back_angle(y_pos) {
  position = [
    bin_front_height_without_extra - 0.2,     // x
    y_pos,                                    // y
    bin_under_height + bin_under_length - 2
  ];
  translate(position)  // z
    rotate(a=[90, 0, 0]) 
      right_triangle(
        bin_under_height + bin_front_extra_height - 2, 
        bin_under_height + bin_front_extra_height - 2, 
        1, bin_wall_thickness);
}

// community module
module right_triangle(side1, side2, corner_radius, triangle_height) {
  translate([corner_radius,corner_radius,0]) {  
    hull(){  
    cylinder(r=corner_radius,h=triangle_height);
      translate([side1 - corner_radius * 2,0,0])cylinder(r=corner_radius,h=triangle_height);
          translate([0,side2 - corner_radius * 2,0])cylinder(r=corner_radius,h=triangle_height);  
    }
  }
}