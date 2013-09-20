$fa = 4;
$fs = 1;


translate([ -diameter - 5, 0, 0]) rotate([0,0,-90]) supportFull();
translate([diameter/2, -diameter/2 - clamp_thickness -1, 0]) clampFull();
translate([diameter/2, diameter/2 + clamp_thickness + 1, 0]) clampFull();


//supportFull();
//clampFull();
//clamp();
//fastener();
//holder();

////////////////
// parameters //
////////////////

//general
tolerance = 0.15; //extra space between the parts
knob_height = 5; //the height of the dovetails

//clamp
diameter = 30;
clamp_thickness = 3;
clamp_width = 8;
clamp_base = 20;
clamp_gap = 3;

//fastener
fastener_length = 12;
fastener_thickness = 3;
fastener_delta = 0;
fastener_angle = 65;
fastener_angle2 = 10;
fastener_delta_r = 3;
smaller_by = 1; ///middle part


//support
support_length = 50;
support_wall = 2; //between the dovetails

//
pi = 3.1415926;
pi2 = 2 * pi;

//derived values:
fastener_delta_r2 = fastener_delta_r - smaller_by;
fastener_inner_radius = diameter / 2 + clamp_thickness;
fastener_outer_radius = fastener_inner_radius + fastener_delta_r;
fastener_outer_radius2 = fastener_inner_radius + fastener_delta_r2;
fastener_middle = (fastener_outer_radius + fastener_inner_radius) / 2;
fastener_middle2 = (fastener_outer_radius2 + fastener_inner_radius) / 2;
fastener_gap = fastener_length + fastener_delta;
fastener_inner_angle = fastener_angle -fastener_angle2 - fastener_gap / fastener_middle / pi2 * 360;

////////////////
////////////////

//to be used as a negative (difference in the support)
module holder() {
    length = 42;
    width = 18;
    depth = 41;
    gap = 2.5;
    union() {
        translate([ gap, 0, 0]) cube(size = [ width - 2*gap, depth, 2.6]);
        translate([ 0, 0, 2.5]) cube(size = [ width, depth, 2.8]);
        translate([ width/2.0 - 2.5, 34, 5.3]) cube(size = [ 5, 3.5, 1]);
        translate([ 0, depth, ]) cube(size = [ width, 10, 5.3]);
    }
}

///////////
// Clamp //
///////////

module clamp() {
    thickness = clamp_thickness;
    width = clamp_width;
    base = clamp_base;

	//opening on top
    opening = clamp_gap;
	opening_angle = 30; //works if <= 45
	opening_shift = opening * 0.5 + thickness * sin(opening_angle);
	opening_size = [ diameter, opening, 2*width];

    inner_radius  = diameter / 2;
    outer_radius = inner_radius + thickness;
    angle = atan(fastener_length / 2 / outer_radius);
    fastener_x = cos(angle) * outer_radius;

    difference() {
        union() {
             tube(outer_radius, inner_radius, width);
            //shape to hold the fastener
            translate([ fastener_x, -fastener_length / 2, 0]) union() {
                cube(size = [ fastener_thickness*6/4, fastener_length, width]);
                translate([ 5*fastener_thickness/4, 0, 0]) union() {
                    scale([1,0.5,1]) cylinder(h = width, r = fastener_thickness/4);
                    translate([ 0, fastener_length, 0]) scale([1,0.6,1]) cylinder(h = width, r = fastener_thickness/4);
                }
            }
        }
        //opening
        translate([ 0, -opening_shift, width/2]) union(){
            rotate([180 + opening_angle, 0, 0]) translate([ 0, -opening, 0]) cube(opening_size);
            rotate([-opening_angle, 0, 0]) cube(opening_size);
        }
        //for the fastener
        bigger()
            translate([fastener_x + fastener_thickness/2, -fastener_length / 2, 0])
                cylinder( h = clamp_width, r = fastener_thickness / 2);
        bigger()
            translate([fastener_x + fastener_thickness/2 + smaller_by / 2, fastener_length / 2, 0])
                cylinder( h = clamp_width, r = (fastener_thickness - smaller_by) / 2);
    }
    //knob
    translate([ -outer_radius, -base / 2, 0]) cube(size = [ thickness, base, width]);
    translate([ -outer_radius, 0, 0]) dovetail();
}

module fastener_inner() {
	//TODO spring-like on the inside ?
	delta_r = fastener_delta_r2;
    inner_radius = fastener_inner_radius;
	outer_radius = fastener_outer_radius2;
	middle = fastener_middle2;
	height = clamp_width;
	delta_h = 0.3;
	angle = fastener_inner_angle;
	rotate([0,0,-angle]) union() {
		pie_slice(outer_radius, inner_radius, angle, height);
		translate([middle, 0, 0]) cylinder(r = delta_r / 2, h = height);
		rotate([0,0,angle]) translate([middle, 0, -delta_h]) cylinder(r = delta_r / 2, h = height + 2*delta_h);
	}
}

module fastener() {
	delta_r = fastener_delta_r;
    inner_radius = fastener_inner_radius;
	outer_radius = fastener_outer_radius;
	middle = fastener_middle;
	thickness = fastener_thickness;
	height = clamp_width + 2*thickness + 2*tolerance;
	angle1 = fastener_angle;
	angle2 = fastener_angle2;
	angle3 = angle1 - angle2;
	
	difference() {
		union() {
			pie_slice(outer_radius, inner_radius, angle1, thickness);
			rotate([0,0,angle3]) pie_slice(outer_radius, inner_radius, angle2, height);
			translate([0,0, clamp_width + thickness + 2*tolerance]) pie_slice(outer_radius, inner_radius, 60, thickness);
			translate([middle, 0, 0]) cylinder(r = delta_r / 2, h = height);
			rotate([0,0,angle1 -0.01]) translate([inner_radius,0,0]) pie_slice(delta_r, 0, angle1, height);
		}
		rotate([0,0,angle3]) translate([0,0,thickness+tolerance]) bigger() fastener_inner();
	}
	
}

module clampFull() {

	intersection() { //force z >= 0
		translate([diameter + 2*clamp_width + 2,0,-fastener_inner_radius * cos(fastener_inner_angle/2)])
			rotate([-fastener_inner_angle/2,0,0]) rotate([0,-90,0]) fastener_inner();
		translate([diameter + clamp_width -2, -clamp_width, 0]) cube(20);
	}
	intersection() { //force z >= 0
    	translate([diameter + clamp_width, 0, -fastener_inner_radius * cos(fastener_angle/2)])
			rotate([fastener_angle/2,0,0]) rotate([0,-90,0]) fastener();
		translate([diameter -clamp_width -2 , -fastener_middle, 0]) cube(50);
	}
    clamp();
}

/////////////
// Support //
/////////////

module support_bridge(){
    length = support_length - 2 * (knob_height + clamp_width + support_wall) ;
    translate([ clamp_base / 4, 0, 0 ]) rotate([0, 0, 90]) dovetail(width = knob_height);
    translate([ clamp_base / 4, length, 0 ]) rotate([0, 0, -90])dovetail(width = knob_height);
    cube([clamp_base / 2, length, knob_height]);
}

module support_front(){
    length = support_length;
    clampe_z_offset = 7 + knob_height;
    bridge_offset = knob_height + clamp_width + support_wall;
    difference(){
        cube([ 22, bridge_offset, 7 + knob_height]);
        translate([2, 5, -tolerance]) bigger() holder();
        translate([ 11, clamp_width, clampe_z_offset]) rotate([90, -90, 0]) dovetail(false);
        translate([ 11, bridge_offset, clampe_z_offset - knob_height ]) rotate([0, 0, 90]) dovetail(false);
    }
}

module support_back(){
    length = support_length;
    clampe_z_offset = 7 + knob_height;
    bridge_offset = knob_height + clamp_width + support_wall;
    difference(){
        translate([ 0, -bridge_offset, 0]) cube([ 22, bridge_offset, 7 + knob_height]);
        translate([2, 5 -length, -tolerance]) bigger() holder();
        translate([ 11, 0, clampe_z_offset ]) rotate([90, -90, 0]) dovetail(false);
        translate([ 11, -bridge_offset, clampe_z_offset - knob_height ]) rotate([0, 0, -90]) dovetail(false);
    }
}

module supportFull(){
    gap = 3;
    rotate([90, 0, 90]) support_front();
    translate([gap + 2 * (knob_height + 7), 0, 0]) rotate([-90, 0, 90]) support_back();
    translate([-gap -10, 0, 0]) support_bridge();
}

//////////
// Misc //
//////////

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

module dovetail(male = true, base = clamp_base, width = clamp_width) {
    t = male ? 0 : tolerance;
    translate([ - knob_height, 0, 0])
        rotate([90,0, 90])
            bigger(t)
                trapeze(knob_height, width, base/2, base/3);
}

module trapeze(h, w, r1, r2, center = false) {
    rotate([-90,0,0]) linear_extrude(height = w) projection(false) rotate([90,0,0]) cylinder(h, r1/2, r2/2, center);
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

