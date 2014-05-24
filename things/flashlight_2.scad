$fa = 4;
$fs = 0.5;

include <my_lib.scad>


translate([ 0, 0, 0]) schtroumpf(height = h);
translate([ 6, 6, 0]) schtroumpf(angle = 90 - da, height = h/2);
translate([12,12, 0]) schtroumpf(angle = 90 - da, height = h/2);
translate([50,  0, 0])schtroumpf(angle = 180 - da, height = h);
translate([52, 15, 0])schtroumpf(angle = 180 - da, height = h);

translate([ 30, 0, 0]) rotate([90,0,0]) base();

////////////////
// parameters //
////////////////

//general
filament = 1.8; //filament diameter
tolerance = 0.15; //extra space between the parts
knob_height = 5; //the height of the dovetails


flashlight_diameter = 30;

da = 20;
h = 7.5;

////////////////
////////////////

//to be used as a negative (difference in the support)
module holder() {
	length = 42;
	width = 18;
	depth = 41;
	gap = 2.5;

	bigger(tolerance){
		union() {
			translate([ gap, 0, 0]) cube(size = [ width - 2*gap, depth, 2.6]);
			translate([ 0, 0, 2.5]) cube(size = [ width, depth, 2.8]);
			translate([ width/2.0 - 2.5, 34, 5.3]) cube(size = [ 5, 3.5, 1]);
			translate([ 0, depth, ]) cube(size = [ width, 10, 5.3]);
		}
	}
}

//find a better name ...
module schtroumpf(	angle = 90,
						inner_radius = 15,
						height = 5,
						thickness = 1.2,
						tolerance = 0) {

	inner = inner_radius;
	outer = inner + 2*thickness + filament;
	middle = (inner+outer)/2;

	difference() {
		union() {
			pie_slice(outer, inner, angle, height);
			translate([middle,0,0]) cylinder(r=(outer-inner)/2, height);
			translate([cos(angle)*middle,sin(angle)*middle,0]) cylinder(r=(outer-inner)/2, height);
		}
		translate([middle,0,-1]) cylinder(r=filament/2+tolerance, height + 2);
		translate([cos(angle)*middle,sin(angle)*middle,-1]) cylinder(r=filament/2+tolerance, height + 2);
	}

}

//base: 4*h + 4*gaps
module base(inner_radius = 15, thickness = 1.2) {
	gaps = 0.5;
	depth = 5 + 4*h + 4*gaps;

	inner = inner_radius;
	outer = inner + 2*thickness + filament;
	middle = (inner+outer)/2;
	wall = (outer-inner)/2;

	difference(){
		union(){
			cube([22, depth, 10]);
			translate([11,0,outer+6]) rotate([-90,0,0]) {
				difference() {
					schtroumpf(180, 15, depth, thickness, 0);
					bigger(0.2) translate([middle, 0, 2.5]) cylinder(r=wall, h);
					bigger(0.2) translate([-middle, 0, 2.5+2*gaps+1.5*h]) cylinder(r=wall, h);
					bigger(0.2) translate([middle, 0, 2.5+4*gaps+3*h]) cylinder(r=wall, h);
				}
			}
		}
		translate([2,-5,0]) holder();
	}
}