
tolerance = 0.15; 

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

rounding = 1;
module round(r = rounding) {
	minkowski() {
		child(0);
		sphere(r);
	}
}

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

module torus (r1 = 2, r2 = 1, a = 360) {
	intersection() {
		rotate_extrude(convexity = 10, $fn = 50)
			translate([r1, 0, 0])
				circle(r = r2, $fn = 20);
		translate([0, 0, -r2 -0.5])
			pie_slice(r1 + r2 + 1, r1 - r2 - 1, a, 2*r2 + 1);
	}
}

module trapeze(h, w, r1, r2, center = false) {
    rotate([-90,0,0]) linear_extrude(height = w) projection(false) rotate([90,0,0]) cylinder(h, r1/2, r2/2, center);
}

