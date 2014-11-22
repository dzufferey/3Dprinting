$fa=4;
$fs=0.5;

tolerance=0.15;

arm_width = 8;
arm_height = 9;

sensor_w = 35;
sensor_d = 2;
sensor_h1 = 3;
sensor_h2 = 7;

angle = 10;

ir_sensor_mnt_servo();

module ir_sensor_mnt_servo() {
	union() {
		rotate([0,0,90]) mnt();
		translate([3,-3,0]) cube([6,6,2]);
		translate([10,-3,0]) rotate([0,-90,0]) difference(){
			cube([10,6,2]);
			translate([3,3,-0.5]) cylinder(r=0.8,h=3);
			translate([5.5,3,-0.5]) cylinder(r=0.8,h=3);
			translate([8,3,-0.5]) cylinder(r=0.8,h=3);
		}
	}
}

module mnt_servo() {
	union(){
		difference() {
			translate([-17,-6,0]) cube([15,12,2]);
			translate([-15,-4,-1]) cube([13,8,4]);
		}
		translate([-17,0,0.8]) rotate([0,-90,0]) cylinder(r=0.8,h=3);
		translate([-17,-7/2,0.8]) rotate([0,-90,0]) cylinder(r=0.8,h=3);
		translate([-17,7/2,0.8]) rotate([0,-90,0]) cylinder(r=0.8,h=3);
		//grip
		translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,2);
		translate([-2,-arm_width/2-2,0]) cube([2,arm_width+4,2]);
		mirror([0,1,0]) translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,2);
	}
}

module ir_sensor_mnt() {
	union() {
		translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,2);
		translate([-2,-arm_width/2-2,0]) cube([2,arm_width+4,2]);
		mirror([0,1,0]) translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,2);
		translate([-6,0,0]) rotate([0,0,90]) mnt();
	}
}

module mnt() {
	union() {
		translate([-3,-4,0]) cube([6,37+2*4,2]);
		translate([0,0,0]) cylinder(r=1.5,h=2+4);
		translate([0,37,0]) cylinder(r=1.5,h=2+4);
	}
}

module grip(w1, w2, length, height) {
	union() {
		cube([length-w2,w1,height]);
		translate([length-w2,0,0]) intersection() {
			cylinder(r=w2, h=height);
			cube([w2,w2,height]);
		}
	}
}
