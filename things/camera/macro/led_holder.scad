$fa = 4;
$fs = 0.5;

include <../../my_lib.scad>

//5mm led dimensions (http://pages.physics.cornell.edu/p510/w/images/p510/9/95/E10_LEDDatasheets.pdf)
diameter = 5;
height = 8.7;
base_diameter = 5.8;
base_height = 1;
pin_diameter = 0.5;
pin_spacing = 2.5; //center of wire, 1.25 from center of diode

depth = 3;
height = 21;

tolerance = 0.12;

//TODO
// - factor the nozzle size

print_all();
//back_cover(5);
//translate([0,0,20]) rotate([180,0,0]) snoot(5);

module print_all(k=5, support=12){
	union() {
		rotate([0,0,180]) {
			holder_print(k);
			if (support > 0) {
				translate([(1+k*(base_diameter+1))/2,10,0]) {
					for (i = [1:support]) {
						rotate([0,0,i*360/support])
							translate([0,4.5,base_diameter+1.9])
								cube([0.3,4.5,7]);
					}
				}
			}
		}
	}
	translate([-(2+k*(base_diameter+1)),3,0]) back_cover(k);
	translate([-(2+k*(base_diameter+1)),25,20]) rotate([180,0,0]) snoot(k);
}

module led_base() {
	union() {
		cylinder(r = base_diameter/2 + tolerance, h = height);
		translate([0, pin_spacing/2,-29]) cylinder(r = pin_diameter/2 + 2*tolerance, h = 30);
		translate([0,-pin_spacing/2,-29]) cylinder(r = pin_diameter/2 + 2*tolerance, h = 30);
	}
}

module holder_print(k=5) {
	translate([0,0,base_diameter+2])
		rotate([-90,0,0])
			holder(k);
}

module holder(k = 5) {
	total_x = 1+k*(base_diameter+1);
	difference(){
		union() {
			cube([total_x,base_diameter+2, height+depth]);
			translate([total_x/2,-17.5,10])
				rotate([-90,0,0])
					import("external/ball_and_socket_chain_links_with_hole_through/only_socket.stl");
		}
		for(i = [0 : k-1]) {
			translate([base_diameter/2+1+i*(base_diameter+1),base_diameter/2+1,height]) led_base();
		}
		//gap for wires
		translate([total_x/2-2.5,-3,5]) cube([5,3,5]);
	}
}

module back_cover(k = 5) {
	inner_x = 1+k*(base_diameter+1) + 2*tolerance;
	inner_y = base_diameter + 2 + 2*tolerance;
	total_x = inner_x+2;
	total_y = inner_y+2;
	union() {
		difference(){
			cube([total_x,total_y,15]);
			translate([1,1,1]) cube([inner_x,inner_y,15]);
			translate([4,3,1]) cube([inner_x-6,inner_y,15]);
		}
		translate([1,1+inner_y/2,1]) cube([inner_x - 3, 0.6, 3]);
	}
}

module snoot(k = 5, length = 20) {
	inner_x = 1+k*(base_diameter+1);
	inner_y = base_diameter+2;
	space = 0.5 + tolerance;
	total_x = inner_x+space+2;
	total_y = inner_y+space+2;
	union() {
		difference() {
			cube([total_x, total_y, length]);
			translate([1,1,-1]) cube([inner_x+space, inner_y+space, length+2]);
			translate([total_x/3-2,-1,-1]) cube([4,total_y+2,9]);
			translate([total_x*2/3-2,-1,-1]) cube([4,total_y+2,9]);
		}
		translate([total_x/3+0.5-2,0,0]) {
			translate([0,1,2]) rotate([0,90,0]) scale([1,0.4,1]) cylinder(r=2,h=3);
			cube([3,1,9]);
		}
		translate([total_x/3+0.5-2,total_y-1,0]) {
			translate([0,0,2]) rotate([0,90,0]) scale([1,0.4,1]) cylinder(r=2,h=3);
			cube([3,1,9]);
		}
		translate([total_x*2/3+0.5-2,0,0]) {
			translate([0,1,2]) rotate([0,90,0]) scale([1,0.4,1]) cylinder(r=2,h=3);
			cube([3,1,9]);
		}
		translate([total_x*2/3+0.5-2,total_y-1,0]) {
			translate([0,0,2]) rotate([0,90,0]) scale([1,0.4,1]) cylinder(r=2,h=3);
			cube([3,1,9]);
		}
		for(i = [1 : k-1]) {
			translate([1+space+i*(base_diameter+1),0,10]) cube([0.5,total_y,length-10]);
		}
	}
}
