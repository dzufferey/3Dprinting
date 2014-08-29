$fa = 4;
$fs = 0.5;

//hotshoe dimensions
width = 18;
center_width = 13;
length = 16;
height = 1.65;

//AAA battery (need 4 of them)
AAA_radius = 10.5 / 2;
AAA_height = 44.5;

//space for the electronic ...
//-MOSFET: (16+14) x 10 x 5
//-pot: ∅ = 17, part below is 13 from center (+4 for pins), depth = 9.5, shaft ∅ = 7
//-switch: (10+4)x13x8, pin ∅ = 6, spacer ∅ = 12

hotshoe();

module hotshoe(center_height = 2) {
	union() {
		cube([length,width,height]);
		translate([0,(width-center_width)/2,0]) cube([length, center_width, height+center_height]);
		translate([0,0,height/2]) rotate([-90,0,0]) cylinder(r = height/2, h = width);
	}
}
