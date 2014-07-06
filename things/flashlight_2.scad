$fa = 4;
$fs = 0.5;

include <my_lib.scad>

//TODO support for the base

//translate([ 0, 0, 0]) schtroumpf(height = h);
//translate([ 6, 6, 0]) schtroumpf(angle = 90 - da, height = h/2);
//translate([12,12, 0]) schtroumpf(angle = 90 - da, height = h/2);
//translate([50,  0, 0])schtroumpf(angle = 180 - da, height = h);
//translate([52, 15, 0])schtroumpf(angle = 180 - da, height = h);

//translate([ 30, 0, 0]) rotate([90,0,0]) base();
baseWithSupport();

////////////////
// parameters //
////////////////

//general
filament = 1.8; //filament diameter
tolerance = 0.15; //extra space between the parts
thickness = 1.5;
flashlight_diameter = 30;
inner_radius = flashlight_diameter / 2;
da = 20;
h = 7.5;
nozzle = 0.3;
gaps = 0.5;

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
						inner_radius = inner_radius,
						height = h,
						thickness = thickness,
						tolerance = tolerance) {

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
module base(inner_radius = inner_radius, thickness = thickness) {
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
					schtroumpf(180, 15, depth, thickness, tolerance);
					bigger(0.2) translate([middle, 0, 2.5]) cylinder(r=wall, h);
					bigger(0.2) translate([-middle, 0, 2.5+2*gaps+1.5*h]) cylinder(r=wall, h);
					bigger(0.2) translate([middle, 0, 2.5+4*gaps+3*h]) cylinder(r=wall, h);
				}
			}
		}
		translate([2,-5,0]) holder();
	}
}

module baseWithSupport(inner_radius = inner_radius, thickness = thickness) {
	inner = inner_radius;
	outer = inner + 2*thickness + filament;
	middle = (inner+outer)/2;
	union(){
		rotate([90,0,0]) base(inner_radius, thickness);
		translate([11,-outer-6,0]) {
			translate([middle,0,0]) support();
			translate([-middle,0,0]) support();
		}
	}
}

module support(thickness = thickness) {
	depth = 5 + 4*h + 4*gaps;

	for ( i = [0 : 3] )
	{
		rotate( (i+3) * 360 / 6, [0, 0, 1])
		translate([filament/2+2*tolerance, 0, 0])
		cube([1.2*thickness,nozzle,depth]);
	}
}