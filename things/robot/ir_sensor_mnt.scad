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

ir_sensor_mnt();

module ir_sensor_mnt() {
	union() {
		translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,5);
		translate([-2,-arm_width/2-2,0]) cube([2,arm_width+4,5]);
		mirror([0,1,0]) translate([0,-arm_width/2-2,0]) grip(2,4,4+arm_height+2*tolerance,5);
		translate([-2,0,0]) rotate([0,-90+angle,0]) mnt();
	}
}

module mnt() {
	translate([0,-sensor_w/2-2,0])
	union() {
		cube([5,sensor_w+4,2]);
		translate([0,0,2]) cube([5,2,sensor_h1]);
		translate([0,sensor_w+2,2]) cube([5,2,sensor_h1]);
		translate([0,0,4])rotate([0,0,-90]) rotate([0,-90,0]) grip(1.5,2,sensor_h2+2,2);
		translate([5,2,4])rotate([0,0,90]) rotate([0,-90,0]) grip(1.5,2,sensor_h2+2,2);
		translate([0,sensor_w+2,4])rotate([0,0,-90]) rotate([0,-90,0]) grip(1.5,2,sensor_h2+2,2);
		translate([5,sensor_w+4,4])rotate([0,0,90]) rotate([0,-90,0]) grip(1.5,2,sensor_h2+2,2);
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