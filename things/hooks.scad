$fa=4;
$fs=0.5;

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

///////////////////////////

module tube(outer_radius, inner_radius, height) {
    difference() {
        cylinder(h = height, r = outer_radius);
        translate([ 0, 0, -1]) cylinder(h = height + 2, r = inner_radius);
    }
}

module pie_slice(outer_radius, inner_radius, angle, height) {
    o1 = outer_radius + 1;
    blocking_half = [2* o1, o1, height + 1];
	blocking_quarter = [o1, o1, height + 1];
	if (angle <= 0) {
		//nothing
	} else if (angle <= 90) {
		difference() {
			tube(outer_radius, inner_radius, height);
			translate([-o1, -o1, -0.5]) cube(blocking_half);
			translate([-o1, -0.5, -0.5]) cube(blocking_quarter);
			rotate([0,0,angle]) translate([0, 0, -0.5]) cube(blocking_quarter);
		}
	} else if (angle <= 180) {
		difference() {
			tube(outer_radius, inner_radius, height);
			translate([-o1, -o1, -0.5]) cube(blocking_half);
			rotate([0,0,angle]) translate([0, 0, -0.5]) cube(blocking_quarter);
		}
	} else if (angle <= 270) {
		difference() {
			tube(outer_radius, inner_radius, height);
			translate([0, -o1, -0.5]) cube(blocking_quarter);
			rotate([0,0,angle]) translate([0, 0, -0.5]) cube(blocking_quarter);
		}
	} else if (angle <= 360) {
		difference() {
			tube(outer_radius, inner_radius, height);
			intersection() {
				translate([0, -o1, -0.5]) cube(blocking_quarter);
				rotate([0,0,angle]) translate([0, 0, -0.5]) cube(blocking_quarter);
			}
		}
	} else {
		tube(outer_radius, inner_radius, height);
	}
}
