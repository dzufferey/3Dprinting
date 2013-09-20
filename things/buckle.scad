$fa = 4;
$fs = 0.5;

tolerance = 0.25;
height = 8;
radius = height/2;
r2 = radius/2;
width = 50;
thickness = 5;
t = thickness;
t2 = thickness / 2;
length = 55;
rounding = 1;
middle = 15;
pin_ring = 1.8;
pin_tolerance = 0.3;
pin_space = 0.5;

buckle();

//translate([0, -25, 0]) ring_full();

module ring() {
	l = 20;
	union() {
		scale([0.5,1,1]) {
			translate([0,-radius,0]) cyl();
			translate([l,-radius,0]) cyl();
			rotate([90,0,0]) border(l, height);
			translate([0,0,width - t]) rotate([90,0,0]) border(l, height);
		}
	}
}

module half_ring() {
	difference() {
		union() {
			intersection() {
				ring();
				cube([width, width, width], true);
			}
			translate([0,-radius,width/2]) scale([0.5,1,1]) cylinder(h = 5, r = radius / 2);
		}
		translate([middle,-radius,width/2 -5 ]) bigger(tolerance/2) scale([0.5,1,1]) cylinder(h = 5, r = radius / 2); //tight fit
	}
}

module ring_full() {
	rotate([-90,0,0]) {
		half_ring();
		translate([15, 0, 0]) half_ring();
	}
}


module pin() {
	union() {
		translate([middle,0,0]) tube(radius, radius - pin_ring, t);
		hull(){
			translate([length - r2, -r2, 0]) intersection() {
				translate([0,0,t2]) sphere(r = t2);
				translate([0,-t,0]) cube(t);
			}
			translate([length - r2,0,t2]) rotate([90,0,0]) cylinder(h = r2, r = t2);
			translate([middle + radius -pin_ring, (t - height)*2/3, 0]) cube([pin_ring, t, t]);
		}
	}
}

module border(l = length, h = height) {
	round() union() {
		translate([rounding, rounding, rounding]) cube([l - 2*rounding, t- 2*rounding, h - 2*rounding]);
		translate([0,rounding,radius]) rotate([-90,0,0]) {
			cylinder(h = t- 2*rounding, r = radius - rounding);
			translate([l,0,0]) cylinder(h = t - 2*rounding, r = radius - rounding);
		}
	}
}

module cyl(h = width -t , r = radius) {
	translate([0,0,t2]) cylinder(h = h , r = r);
}

module frame() {
	union(){
		translate([0,0,radius]) rotate([-90,0,0]) {
			//first cylinder
			scale([1,0.5,1]) cyl();
			//second cylinder
			translate([middle,0,0]) {
				union(){
					cyl(h = width/2 -t - pin_space);
					translate([0,0, width/2 + pin_space]) cyl(h = width/2 -t - pin_space);
					cyl(r = radius - pin_tolerance - pin_ring);
				}
			}
			//third cylinder
			translate([length,0,0]) difference() {
				cyl();
				translate([-t2 +0.25, pin_space, width/2]) //TODO what is the 0.25 ???
					rotate([90,0,0])
						hull() {
							cylinder(h = radius + 5,  r = t2 + pin_space);
							translate([-t, 0, 0])cylinder(h = radius + 5,  r = t2 + pin_space);
						}
			}
		}
		border();
		translate([0,width - t,0]) border();
	}
}

module buckle(){
	frame();
	translate([0, (width - t)/2, radius]) rotate([-90, 0, 0]) pin();
}

/////////////
//lib stuff//
/////////////

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

module round(r = rounding) {
	minkowski() {
		child(0);
		sphere(r);
	}
}

module torus(r1 = 2, r2 = 1)
{
	rotate_extrude(convexity = 4)
	translate([r1, 0, 0])
	circle(r = r2);
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