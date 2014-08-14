$fa=4;
$fs=0.5;

//for a pin
include <external/NewPin.scad>

//for a wheel of radius 30mm and axle 5mm diameter

thickness = 3;
wheel_width = 10;
wheel_gap = 0.1;
fork_lip = 1;
axle_radius = 2.5;
fork_thickness = 2;
delta_x = 7;
delta_z = 20;

pin_radius = 3;

width = wheel_width + 2*wheel_gap + 2*fork_lip;

//rotate to print
print_rotation = atan2(delta_z, delta_x + width/2 -axle_radius +fork_thickness +1);
rotate([0,print_rotation,0]) castor_wheel();


module castor_half() {
	translate([-width/2,-width/2,-thickness]) cube([width,width,thickness]);
	difference() {
		union() {
			hull(){
				translate([-width/2,width/2,-thickness])
					cube([width,thickness,thickness]);
				translate([-width/2-delta_x,width/2,-thickness-delta_z])
					rotate([-90,0,0])
						cylinder(r=axle_radius+fork_thickness, h=thickness);
			}
			translate([-width/2-delta_x,width/2-fork_lip,-thickness-delta_z])
					rotate([-90,0,0])
						cylinder(r=axle_radius+fork_thickness, h=thickness+fork_lip);
		}
		translate([-width/2-delta_x,width/2-fork_lip-0.5,-thickness-delta_z])
			rotate([-90,0,0])
				cylinder(r=axle_radius, h=thickness+fork_lip+1);
	}
}

module castor_wheel() {
	union(){
		castor_half();
		mirror( [0, 1, 0] ) castor_half();	
		translate([0,0,fork_lip]) half_pin();
		cylinder(r=pin_radius+fork_thickness,h=fork_lip);
	}
}

//half_pin();
module half_pin() {
	rotate([0,90,0]) translate([-pin_length/2,0,0]) intersection() {
		pin();
		rotate([0,90,0]) cylinder(r= total_pin_radius+1, h= pin_length/2);
	}
}
