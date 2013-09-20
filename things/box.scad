$fa = 4;
$fs = 1;

tolerance = 0.15; //extra space between the parts

scale([1,20/15,1]) {
	translate([50,0,0]) cap();
	body();
}


//round version

module cap() {
	difference() {
		union() {
			cylinder(r=18, h=15);
			cylinder(r=16.3, h=20);
		}
		translate([0,0,3]) cylinder(r=15, h=20);
	}
}

module body() {
	difference () {
		cylinder(r=18, h=60);
		translate([0,0,3]) cylinder(r=15, h=58);
		bigger() translate([0,0,60]) rotate([180,0,0]) cap();
	}
}

module bigger(t = tolerance) {
    if (t > 0) {
        minkowski() {
            child(0);
            cube(t, true);
        }
    } else {
        child(0);
    }
}
