carabiner();

/**
 * @param a1 angle of the big part (< 90)
 * @param r1 radius of the big part
 * @param a2 angle of the small part (< 90)
 * @param r2 radius of the small part
 * @param r radius of the body
 * @param m ~length of the middle part
 */
a1 = 78;
r1 = 5;
a2 = 80;
r2 = 3;
r = 1.2;
m = 2;
tolerance = 0.15; //extra space between the parts


//derived constants

//angle of the middle part
b = 180 - a1 - a2;
c = 90 - a1;

// heights (from central axis)
h1 = r1 * sin( a1 );
h2 = r2 * sin( a2 );
hm = h2 + m * (sin( a2 ) - sin( a1 ));

//length of the straight part
l = (h1 - hm) / cos( a1 );

//some positions along the X axis
x1 = 0;
xl = x1 + r1 * cos( a1 ) + l * cos( c );
xm = xl + m * sin( c );
x2 = xm + m * sin( c );

//some positions along the Y axis
ym = (r2 + m) * sin( a2 );
yl = hm;

//how much the thing should be opened
delta = atan((h1 - h2 + r/sin(a1)) / (x2 - x1 + r1 * cos(a1)) * cos(c)) + 1;
echo("delta = ", delta);
xmd = x2 - (r2+m) * cos(a2 + delta) - m * sin( c - delta );
ymd = (r2 + m) * sin( a2 + delta );
xld = xmd - m * cos( a2 - delta );
hld = ymd - m * sin( a1 - delta) -0.08;
 
module carabiner() {
	union() {
		//big end
		translate([x1,0,0]) rotate([0,0, a1]) torus(r1, r, 360 - 2*a1);
		//small end
		translate([x2,0,0]) rotate([0,0, 180 + a2]) torus(r2, r, 360 - 2*a2 - delta);
		//curved middle 1
		translate([xmd,ymd,0]) rotate([0,0, -180 + a1 - delta]) torus(m, r, b);
		//curved middle 2
		translate([xm,-ym,0]) rotate([0,0, 10 + a1]) torus(m, r, b);
		//full side
		translate([r1 * sin(c),-h1,0])
			rotate([0,0, c])
				rotate([0,90,0])
					cylinder(r=r,h=l,$fn=20);
		//opened side
		translate([xld,hld,0])
			rotate([0,0, -c - delta])
				rotate([0,-90,0])
					rotate([0,0,90])
						keylock_male();
		translate([xl,yl,0])
			rotate([0,0, -c])
				rotate([0,-90,0])
					rotate([0,0,90])
						keylock_female();
	}
}

m_l = l * 3 / 4;
f_l = l / 4;

module keylock_male() {
	//neck
	n_x = r * 4 / 3;
	n_y = r / 3*2;
	n_z = l * 3 / 16;
	//head
	h_x = n_x;
	h_y = r * 4 / 3;
	h_z = l / 12;
	intersection() {
		union() {
			cylinder(r=r, h=m_l, $fn=20);
			translate([ -r, -n_y/2, m_l]) cube([n_x, n_y, n_z]);
			translate([ -r, -h_y/2, m_l + n_z - h_z]) cube([h_x, h_y, h_z]);
		}
		cylinder(r=r, h=2*m_l, $fn=20);
	}
}

module keylock_female() {
	difference() {
		translate([0, 0, m_l]) cylinder(r=r, h=f_l, $fn=20);
		bigger() keylock_male();
	}
}


///////////////////////////////////////

module torus (r1 = 2, r2 = 1, a = 360) {
	intersection() {
		rotate_extrude(convexity = 10, $fn = 50)
			translate([r1, 0, 0])
				circle(r = r2, $fn = 20);
		translate([0, 0, -r2 -0.5])
			pie_slice(r1 + r2 + 1, r1 - r2 - 1, a, 2*r2 + 1);
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
