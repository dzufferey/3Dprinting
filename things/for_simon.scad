$fa = 4;
$fs = 1;

include <my_lib.scad>

lens_diameter = 49.8;
lens_height = 14;
thickness = 1.8;
angle = 45;
thingy = 5;
thing_size = 3;
thing_angle = 10;
hole_radius = 2;
hole_radius2 = hole_radius + thickness;
hole_thickness = 3;

radius = lens_diameter / 2;
radius2 = radius + thickness;
ta = thing_angle;

union() {
    difference() {
        base();
        part_2();
    }
    part_1();
}

module part_1() {
	for ( i = [0 : thingy-1] )
	{
		rotate([0,0,i * 360/thingy])
		translate([0,0, 3.5 + thickness])
		union() {
			rotate([0,0,-5]) pie_slice(radius2, radius, ta, lens_height);
			translate([radius,sin(ta)*radius/2,lens_height])
                rotate([90,0,0])
                scale([thing_size / (5*2), 1, 1])
                intersection() {
                    cylinder(r = 5, h = sin(ta)*radius);
                    translate([-5, -10, 0]) cube([ 10, 10, radius]);
                }
		}
	}
}

module part_2() {
	gap = 1;
	for ( i = [0 : thingy-1] )
	{
		rotate([0,0,i * 360/thingy])
		translate([0,0,lens_height/2 + thickness]) {
			rotate([0,0,ta/2]) pie_slice(radius2 + 1, radius -1 , gap, lens_height + 4);
			rotate([0,0,-ta/2 -gap]) pie_slice(radius2 + 1, radius - 1, gap, lens_height + 4);
		}
	}
}

module base() {
	union() {
		translate([0,0, thickness]) tube(radius2, radius, lens_height + 3.5);
		cylinder(h = thickness, r1 = radius2 - thickness * sin(angle), r2 = radius2);
		translate([-radius2 - (hole_radius2 + hole_radius)/2,hole_thickness/2,lens_height/2 + thickness]) rotate([90,0,0]) for_wire();
	}
}

module for_wire() {
	difference(){
		hull() {
			cylinder(h=hole_thickness, r=hole_radius2);
			translate([(hole_radius2 + hole_radius)/2,-lens_height/2,0]) cube([thickness, lens_height, hole_thickness]);
		}
		translate([0,0,-0.5]) cylinder(h=hole_thickness+1, r=hole_radius);
	}
}
