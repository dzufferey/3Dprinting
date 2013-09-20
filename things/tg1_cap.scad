$fa=4;
$fs=0.5;

//ring
r_out = 41/2;
r_thick = 0.9;
r_in = r_out - r_thick;
r_height = 4.5;

//cover
c_out = r_out + 0.5;
c_in = r_out - 3;
c_h1 = 0.5;
c_h2 = 1.5;

//
goes_back = 3.3;

//shapes

rotate([180,0,0]) cap();

module cap() {
	union() {
		tube(r_out, r_in, r_height);
		translate([0,0,r_height]) {
			cylinder(r1 = c_out, r2 = c_out, h = c_h1);
			translate([0,0,c_h1])
				cylinder(r1 = c_out, r2 = c_in, h = c_h2);
		}
		rotate([0,0,230])
			difference () {
				union() {
					pie_slice(r_out, r_out - 2.7, 56, 1);
					rotate([0,0,25]) pie_slice(r_out,r_out - goes_back,6,1);
				}
				translate([0,0,-0.5]) rotate([0,0,10]) pie_slice(r_in, r_in - 0.5, 36, 2);
			}
		rotate([0,0,107]) pie_slice(r_out, r_out - goes_back, 38, 1);
		rotate([0,0,0]) pie_slice(r_out, r_out - goes_back, 38, 1);
		rotate([0,0,0]) translate([0, 0, r_height]) pie_slice(c_out+2, 0, 20, c_h1+c_h2);
		rotate([0,0,120]) translate([0, 0, r_height]) pie_slice(c_out, 0, 20, c_h1+c_h2);
		rotate([0,0,240]) translate([0, 0, r_height]) pie_slice(c_out, 0, 20, c_h1+c_h2);
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