include <my_lib.scad>

inner = 59;
thickness = 3;

length = 30;
outer = inner + 2 * thickness; 

union(){
	half();
	mirror([0,1,0]) half();
}

module half(){	
	translate ([0, -outer/2, 0]) union() {
		translate([0,-1,0]) cube([7,outer+1,thickness]);
		translate([7,thickness,0]) difference () {
			cube([7,7,thickness]);
			translate([7,7,-1]) cylinder(r = 7, h = thickness + 2);
		}
		translate([7,-1,0]) cube([length,thickness+1,thickness]);
		translate([length+7,thickness+2,0]) rotate([0,0,-90]) pie_slice(6, 2, 180, thickness);
		translate([length+7,thickness+4,0]) pie_slice(4, 0, 145, thickness);
		translate([-2*thickness,12,0]) {
			difference() {
				cube([7 + 2*thickness, 10, 2*thickness + 3.5]);
				translate([6,-0.5,thickness]) cube([8,11,3.5]);
				translate([6,-0.5,thickness + 1.75]) rotate([-90,0,0]) cylinder(r = 2, h = 11);
			}
		}
	}
}
