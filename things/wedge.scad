union () {
	hull () {
		cube([20,100,0.5]);
		cube([1,100,3]);
	}
	//to avoid wrap
	translate([0,0,0]) cylinder(r = 3, h = 0.2);
	translate([20,0,0]) cylinder(r = 3, h = 0.2);
	translate([0,100,0]) cylinder(r = 3, h = 0.2);
	translate([20,100,0]) cylinder(r = 3, h = 0.2);
}