// dimensions
box_width               = 45.5;
half_box_width          = box_width/2;
box_height              = 33;
hook_offset             = 11;
loop_offset             = hook_offset;
square_hole_width       = 25;
square_hole_height      = 3.5;
square_hole_offset      = 2;
triangle_corner_size    = 3;

triangle_vertices = [
[0,0,0],                                        // 0
[triangle_corner_size,0,0],                     // 1
[0,triangle_corner_size,0],                     // 2
[0,0,square_hole_height],                       // 3
[triangle_corner_size,0,square_hole_height],    // 4
[0,triangle_corner_size,square_hole_height]];   // 5

triangle_faces = [
[0,1,2],
[0,2,5,3],
[2,1,4,5],
[1,0,3,4],
[3,5,4]];

module hole()
{
    // dimensions
    num_circle_faces        = 72;
    center_hole_diameter    = 13.5;
    main_hole_diameter      = 32.5;
    main_hole_height        = 27.5;
    wash_hole_diameter      = 37;
    wash_hole_height        = 18;
    
    // center hole
    cylinder(box_height,d1=center_hole_diameter,d2=center_hole_diameter, $fn=num_circle_faces);  
    
    // square hole 
    difference() {
        // square hole
        translate([-(square_hole_width/2),-(square_hole_width/2),square_hole_offset]) 
        cube([square_hole_width,square_hole_width,square_hole_height]);
        // cut corner 0
        translate([(square_hole_width/2),(square_hole_width/2),square_hole_offset]) 
        rotate([0,0,180]) 
        polyhedron(triangle_vertices,triangle_faces);
        // cut corner 1
        translate([-(square_hole_width/2),-(square_hole_width/2),square_hole_offset]) 
        rotate([0,0,0]) 
        polyhedron(triangle_vertices,triangle_faces);
        // cut corner 2
        translate([(square_hole_width/2),-(square_hole_width/2),square_hole_offset]) 
        rotate([0,0,90]) 
        polyhedron(triangle_vertices,triangle_faces);
        // cut corner 3
        translate([-(square_hole_width/2),(square_hole_width/2),square_hole_offset]) 
        rotate([0,0,-90]) 
        polyhedron(triangle_vertices,triangle_faces);
    }  
    
    // main paint hole
    translate([0,0,box_height - main_hole_height])
    cylinder(main_hole_height,d1=main_hole_diameter,d2=main_hole_diameter, $fn=num_circle_faces);
    
    // wash hole
    translate([0,0,box_height - wash_hole_height])
    cylinder(wash_hole_height,d1=wash_hole_diameter,d2=wash_hole_diameter, $fn=num_circle_faces);
}

module cutout()
{
    top_cutout_height=18;
    top_cutout_width=26;
    bottom_cutout_height=9.5;
    bottom_cutout_width=15.3;
    
    // top cutout
    translate([-half_box_width, -(top_cutout_width/2), box_height - top_cutout_height])
    cube([box_width, top_cutout_width, top_cutout_height]);
    
    // bottom cutout
    translate([-half_box_width, -(bottom_cutout_width/2), box_height - top_cutout_height - bottom_cutout_height])
    cube([box_width, bottom_cutout_width, bottom_cutout_height]);
}

module hook()
{
    width = 3;
    union()
    {
        translate([0, -(width/2), 0])
        cube([width,width,width]);
        translate([width, -(width/2), 0])
        cube([width,width,2*width]);
    }
}

module hooks()
{
    translate([half_box_width, hook_offset, 0])
    hook();
    translate([half_box_width, -hook_offset, 0])
    hook();
    translate([hook_offset, half_box_width, 0])
    rotate(90)
    hook();
    translate([-hook_offset, half_box_width, 0])
    rotate(90)
    hook();
}

module loop()
{
    width = 3.6;
    union()
    {
        translate([0, -(width/2), 0])
        cube([width,width,width]);
        translate([width, -(width/2), 0])
        cube([width,width,2*width]);
    }
}

module loops()
{
    translate([-half_box_width, loop_offset, 0])
    loop();
    translate([-half_box_width, loop_offset, 0])
    loop();
    translate([-loop_offset, -half_box_width, 0])
    rotate(90)
    loop();
    translate([loop_offset, -half_box_width, 0])
    rotate(90)
    loop();
}

module box()
{
    translate([-box_width/2,-box_width/2,0])
    cube([box_width, box_width, box_height]);
}

// ACTUAL DESIGN IMPLEMENTATION
module paint_holder()
{
    difference()
    {
        union()
        {
            box();
            hooks();
        }
        union()
        {
            hole();
            cutout();
            loops();
        }
    }
}

paint_holder();
