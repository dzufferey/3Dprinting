$fa=4;
$fs=0.5;

use <../external/NewPin.scad>
include <../wheels/motorized_castor.scad>


//translate([-10,-20,0])
rotate([0,0,-90])
frame();


module frame() {
	frontW = 25;
	frontH = cor+5+5+2*thickness+2.03;
	frontA = 2 + 33;
	servoClearance = 10-1-2.5+5;
	union(){
		arduino_mount(height=15);
		translate([-2,54+13,2.03]) rotate([0,0,-90]) hPin();
		translate([-2,-19,2.03]) rotate([0,0,90]) hPin();
		translate([20,54+13,2.03]) rotate([0,0,-90]) base();
		translate([20,-19,2.03]) rotate([0,0,90]) base();
		translate([40,54+13,2.03]) rotate([0,0,-90]) base();
		translate([40,-19,2.03]) rotate([0,0,90]) base();
		//front
		translate([55,51/2-frontW/2,0]) {
			difference(){
				union(){
					cube([3,frontW,frontH+2]);
					translate([0,0,frontH]) cube([frontA,frontW,2]);
					translate([frontA,frontW/2,frontH]) cylinder(r=frontW/2,h=2);
					difference(){
						translate([15,(frontW/2-sWidth/2)-2,frontH+2]) cube([20,4+sWidth,20]);
						translate([15,(frontW/2-sWidth/2),frontH+2+servoClearance]) bigger() cube([sHeight,sWidth,30]);
					}
					translate([frontA,frontW/2,frontH-7]) cylinder(r=axle_radius+2,h=9);
				}
				translate([frontA,frontW/2,frontH-10]) cylinder(r=axle_radius,h=15);
				translate([frontA,frontW/2,frontH+2]) cylinder(r=frontW/2+3,h=servoClearance);
			}
		}
	}
}


module support_peg(radius, thickness, height, peg) {
        union() {
                cylinder(r= radius + thickness, h = height);    
                cylinder(r= radius, h = height + peg);
                translate([0,0,height + peg]) sphere(r = radius);
        }
}


module arduino_mount(height = 3, peg = 5, t = 2) {
        //http://www.adafruit.com/datasheets/arduino_hole_dimensions.pdf
        //PCB (without connector): 54 x 70mm
        radius = 2.8 / 2; //hole is 3.2
        thickness = 1.5;
        union(){
                translate([  -3,    -3, 0]) cube([58, 54, t]);
                translate([   0,    0, t]) support_peg(radius, thickness, height, peg);
                translate([ 1.3, 48.2, t]) support_peg(radius, thickness, height, peg);
                //translate([52.1,  5.1, t]) support_peg(radius, thickness, height, peg);
                //translate([52.1,   33, t]) support_peg(radius, thickness, height, peg);
        }
}



module base() {
	translate([10+4,-2,-2.03]) {
		union() {
			cube([2,4,4.06]);
			translate([0,0,2.03]) rotate([0,90,0]) cylinder(r=2.03,h=2);
			translate([0,4,2.03]) rotate([0,90,0]) cylinder(r=2.03,h=2);
		}
	}
}

module hPin() {
	union(){
		intersection() {
			pin();
			translate([0,-5,-2.03]) cube([10 + 2 + 4,10,5]);
		}
		base();
	}
}
