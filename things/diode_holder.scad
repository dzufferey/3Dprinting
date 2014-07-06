$fa=4;
$fs=1;

// to hold a laser diode. a replacement part for my micoslice v2.0

union(){
	difference() {
		cylinder(r=8, h = 2.5);
		translate([0,0,-0.1]) cylinder(r=6, h = 2.7);
	}
	translate([-7.5/2,6,0]) cube([7.5,6,2.5]);
}
