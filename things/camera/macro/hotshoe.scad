$fa = 4;
$fs = 0.5;

//hotshoe dimensions
width = 18;
center_width = 12;
length = 16;
height = 2;

//the module for batteries (4xAAA) is in "../../robot/battery.scad".

electr();
translate([30,-2,0]) rotate([0,0,-90]) cover();

module hotshoe(center_height = 3) {
	union() {
		cube([length,width,height]);
		translate([0,(width-center_width)/2,0]) cube([length, center_width, height+center_height]);
		translate([0,0,height/2]) rotate([-90,0,0]) cylinder(r = height/2, h = width);
	}
}

module electr() {
	union(){
		shell();
		translate([80.1,8,1.9]) pcb_vice();
		translate([26,-4.95,0]) rotate([-90,0,0]) rotate([0,0,180]) hotshoe();
		translate([0,5,0]) rotate([0,-90,-90]) grip(2,3.5,18.5,15);
		translate([0,38,0]) rotate([0,-90,-90]) grip(2,3.5,18.5,15);
		translate([53,20,0]) rotate([0,-90,90]) grip(2,3.5,18.5,15);
		translate([53,53,0]) rotate([0,-90,90]) grip(2,3.5,18.5,15);
		translate([57,10,0]) cube([2,40,14]);
	}
}

module cover(){
	difference(){
		cube([31,54,1]);
		//pot
		translate([13,27,-1]) {
			cylinder(r=3,h=3);
			translate([-1.5,-7.5,0]) cube([3,1.5,3]);
		}
		//switch
		translate([5,44,-1]) cube([14,9,3]);
	}
}

module pcb_vice(w = 30) {
	union(){
		translate([0,0,0]) cube([3,2,12]);
		translate([5,0,0]) cube([3,2,12]);
		translate([0,w,0]) cube([3,2,12]);
		translate([5,w,0]) cube([3,2,12]);
	}
}

module shell() {
	difference() {
		cube([90,58,15]);
		translate([-1,2,2]) cube([89,54,14]);
		translate([85,42,5]) cube([10,10,11]);
		translate([0,29,-1]) cylinder(r=8, h=20);
		translate([48+2+1,29,-1]) cylinder(r=8, h=20);
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