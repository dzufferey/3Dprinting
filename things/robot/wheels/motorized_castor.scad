$fa=4;
$fs=0.5;

//for a wheel of radius 30mm and axle 5mm diameter

tolerance = 0.1;

thickness = 3;
wheel_width = 10;
wheel_gap = 0.1;
fork_lip = 1;
axle_radius = 2.5;
fork_thickness = 2;


//servo size
sWidth = 12;
sHeight= 22;
sAxisOffset = 6;
sMountSize = 4;
sMountZ = 1.2;

//derived
cor = max(30/2 + 2, sHeight - sAxisOffset); //center of rotation
width = wheel_width + 2*wheel_gap + 2*fork_lip;

//objects

translate([27,0,0]) passive_half();
translate([0,0,0]) support_beam();
translate([0,-18,0]) active_half();
translate([5,25,0]) servo_connector();

//trapeze(thickness,10,7,5);


////////////////
////////////////
////////////////

module support_beam() {
	length=50;
	offset1=28;
	offset2=20;
	union(){
		trapeze(3,length,7,5);
		translate([0,offset1,0]){
			difference(){
				cylinder(r=axle_radius-0.2, h=10);
				translate([-0.5,-5,9]) cube([1,10,2]);
			}
		}
		translate([0,offset2,0]){
			translate([0,-3,0]) difference(){
				cube([20,6,thickness]);
				for(i = [0 : 4]) {
					translate([6+i*3,3,-0.5]) cylinder(r=0.8,h=thickness+1);
				}
			}
		}
	}
}

module servo_connector() {
	union() {
		difference() {
			cube([17,6,thickness]);
			for(i = [1,2,3,6,7,8]) {
				translate([i*3,3,-0.5]) cylinder(r=0.8,h=thickness+1);
			}
			translate([27/2,3,thickness - 2]) cylinder(r=2.5,h=3);
		}
		translate([27/2-(1-tolerance)/2, 0, thickness - 2]) cube([1-tolerance,6,1]);
	}
}

module active_half() {
	dx = cor - (sHeight - sAxisOffset);
	difference(){
		union(){
			cube([thickness+2*sMountSize+sHeight+dx,sWidth+thickness,15]);
			cube([sMountSize,sWidth+thickness,15+sMountZ+thickness/2]);
		}
		translate([sMountSize,thickness/2,0]) bigger() cube([sHeight,sWidth,15]);
		translate([0,thickness/2+sWidth/2-2,0]) bigger() cube([sMountSize,4,20]);
		translate([0,thickness/2+2,15]) bigger() cube([sMountSize,sWidth-4,20]);
		translate([0,thickness/2,15]) bigger() cube([sMountSize,sWidth,sMountZ]);
		translate([2*sMountSize+sHeight+dx,thickness/2+sWidth/2])
			rotate([0,90,0])
				rotate([0,0,90])
					bigger()
						trapeze(3,15,7,5);
	}
}

module passive_half() {
	difference() {
		union(){
			hull(){
				cube([thickness,width,thickness]);
				translate([-cor,width/2,0])
					cylinder(r=axle_radius+fork_thickness, h=thickness);
			}
			cube([2*thickness,width,width]);
			translate([-cor,width/2,0])
				cylinder(r=axle_radius+fork_thickness, h=thickness+fork_lip);
			translate([-cor,width/2,0])
				cylinder(r=axle_radius-0.2, h=thickness+fork_lip+5);
		}
		translate([thickness,width/2,0])
			rotate([0,90,0])
				rotate([0,0,90])
					bigger()
						trapeze(3,15,7,5);
	}
}

module trapeze(h, w, r1, r2, center = false) {
	rotate([-90,0,0]) linear_extrude(height = w) projection(false) rotate([90,0,0]) cylinder(h, r1/2, r2/2, center);
}

module bigger(t = tolerance) {
	minkowski() {
		children(0);
		cube(t, true);
	}
}


