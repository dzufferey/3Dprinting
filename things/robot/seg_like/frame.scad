$fa=4;
$fs=0.5;

tolerance=0.15;

frame();

//TODO
//-battery compartment:
//		-separate supplies for arduino, motor shield, uarms ?
//		-AA battery: diameter = 14.5, height = 50.5
//		-AAA battery: diameter = 10.5, height = 44.5
//		-configuration:
//			-motor:4x1 AA front+back, or 8x1/4x2 under/above arduino ?
//			-electronic: 4x1 AAA below/above the arduino
//-mount for electronic:
//		-arduino: make it slide vertically (easier to mount/remove)
//		-IMU sensor (above the arduino ?)
//		-bluetooth transmitter
//		-buck for connection power to uarm
//-mount for castor wheels
//should the frame be split into parts for easier printing ?

/////////////////////////

//total width = width + 2*thickness
//motors are 3*32 = 64
//arduino is 54
//2mm on each side: 54 + 4 + 64 = 122
module frame(width = 122, depth = 120, thickness = 3) {
	union(){
		translate([-width/2,-depth/2,-thickness]) base(width, depth, thickness, 0.3);
		translate([-40,-40,0]) uarm_support(height = 50);
		//motors
		translate([-width/2,0,0]) motor_mount(thickness);
		translate([width/2,0,0]) rotate([0,0,180]) motor_mount(thickness);
		//to mount the castor wheels
		translate([0,-depth/2-thickness,-thickness]) castor_frame_mount(thickness, 30);
		translate([0, depth/2,-thickness]) castor_frame_mount(thickness, 30);
		//electronic
		//translate([27-2.5,-15,0]) rotate([0,0,90]) arduino_mount(peg = 20);
	}
}

module base(width, depth, thickness = 3, rounding = 0.1) {
	eps = 0.1;
	rad = width * rounding;
	cx = width-2*rad;
	cy = depth-2*rad;
	cz = thickness - eps;
	minkowski(){
		translate([rad, rad, 0]) cube([cx, cy, cz]);
		cylinder(r=rad, h=eps);
	}
}

/////////////////////////

cmw = 20; //castor mount width

module castor_frame_mount(thickness = 3, height = 30) {
	translate([-cmw/2,0,0]) {
		difference() {
			cube([cmw,thickness,height]);
			//TODO some holes/peg to attache the other part ??
		}
	}
}

/////////////////////////

module motor_mount_half(thickness = 3) {
	//screws are M3
	motor_width = 42;
	screw_width = 31;
	shaft_width = 22; //actually this is the thing around the shaft
	motor_depth = 32; //+2mm for the thing around the shaft
	r1 = (motor_width-shaft_width+1)/2;
	d1 = (motor_width-screw_width)/2;
	difference() {
		union() {
			translate([-thickness,-thickness,-thickness])
				cube([motor_depth+thickness,motor_width+2*thickness,thickness]);
			translate([-thickness,-1,0])
				cube([thickness,motor_width/2-r1+1,motor_width]);
			difference() {
				translate([-thickness,0,0])
					cube([thickness,motor_width/2+1,motor_width/2]);
				translate([1,motor_width/2,motor_width/2])
					rotate([0,-90,0])
						cylinder(r= r1, h=thickness+2);
			}
			hull() {
				translate([-thickness,-thickness,motor_width-thickness])
					cube([thickness,thickness-tolerance,thickness]);
				translate([-thickness,-thickness,-thickness])
					cube([motor_depth+thickness,thickness-tolerance,thickness]);
			}
		}
		translate([1,d1,d1]) rotate([0,-90,0]) cylinder(r=3.3/2, h=thickness+2);
		translate([1,d1,motor_width-d1]) rotate([0,-90,0]) cylinder(r=3.3/2, h=thickness+2);
	}
}

module motor_mount(thickness = 3) {
	motor_width = 42;
	translate([0,-motor_width/2,0]) {
		union(){
			motor_mount_half(thickness);
			translate([0,motor_width,0])
				mirror([0,1,0])
					motor_mount_half(thickness);
		}
	}
}


/////////////////////////

module support_peg(radius, thickness, height, peg) {
	union() {
		cylinder(r= radius + thickness, h = height);
		cylinder(r= radius, h = height + peg);
		translate([0,0,height + peg]) sphere(r = radius);
	}
}

module uarm_leg(height, peg_over) {
	peg_radius = (7-2*tolerance)/2;
	support_peg(peg_radius, 3, height, 10 + peg_over);
}

module uarm_support(height = 50, peg_over = 5) {
	translate([ 0, 0, 0]) uarm_leg(height, peg_over);
	translate([ 0,80, 0]) uarm_leg(height, peg_over);
	translate([80, 0, 0]) uarm_leg(height, peg_over);
	translate([80,80, 0]) uarm_leg(height, peg_over);
}
