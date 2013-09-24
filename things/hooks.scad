$fa=4;
$fs=0.5;

include <my_lib.scad>

inner = 2.5;
tolerance = 0.1;
length = 14;
thickness = 1.5;

translate([0,0,inner/2 + thickness]) rotate([0,90,0]) hook();
translate([0,8,inner/2 + thickness]) rotate([0,90,0]) hook();

module hook() {
	it = inner/2 + tolerance;
	union() {
		tube(inner/2 + thickness, it, 8);
		translate([-thickness/2,it,9.5]) rotate([0,90,0]) pie_slice(3, 1.5, 180, thickness);
	}
}

