$fa = 4;
$fs = 0.5;

//http://www.instructables.com/id/How-To-Make-Your-Own-Sugru-Substitute/?ALLSTEPS

a=70;
rim();
translate([cos(0)*wheel_diameters,sin(0)*wheel_diameters,0]) half_mold();
translate([cos(a)*wheel_diameters,sin(a)*wheel_diameters,0]) half_mold();


//rim
wheel_diameters = 60;
tire_thickness = 3;
wheel_width = 10;

//mold
thread_depth = 0.5;
thread_width = 1;
thread_angle = 15;
mold_wall = 2;

//shaft
length = 50;
diameter = 5;
flat = 0.45;

rW = wheel_diameters / 2;
rR = rW - tire_thickness;

module rim() {
	rI = rR - tire_thickness;
	difference() {
		union() {
			cylinder(r1=rR,r2=rI,h=4);
			translate([0,0,wheel_width-4]) cylinder(r1=rI,r2=rR,h=4);
			cylinder(r=rI,h=wheel_width);
			for (i = [0 : 5]) {
				rotate([0,0,60*i]){
					translate([0,rR-tire_thickness/2,0]) cylinder(r=1,h=wheel_width);
				}
			}
		}
		translate([0,0,-1]) shaft();
	}
}

module tire() {
	difference(){
		cylinder(r=rW, h=wheel_width);
		for (i = [0 : (360/thread_angle)]) {
			rotate([0,0,thread_angle*i]){
				translate([0,rW,-1])
					scale([thread_width,thread_depth,1])
						cylinder(r=1,h=wheel_width+2);
			}
		}
	}
}

module half_mold() {
	height = wheel_width/2+mold_wall;
	union(){
		difference(){
			cylinder(r=rW+mold_wall, h=height);
			translate([0,0,2]) tire();
			for (i = [0 : 1]) {
				rotate([0,0,180*i+90]){
					translate([0,rW+mold_wall/2,height]) sphere(1);
				}
			}
		}
		for (i = [0 : 3]) {
			rotate([0,0,90*i]){
				translate([-0.5,rR+0.2,0]) cube([1,1,mold_wall+0.5]);
			}
		}
		for (i = [0 : 1]) {
			rotate([0,0,180*i]){
				translate([0,rW+mold_wall/2,height]) sphere(0.9);
			}
		}
	}
}

//placeholder for the shaft of an electric motor
//(designed after the shaft of a NEMA 17 stepper motor)
module shaft() {
	difference() {
		cylinder(r=diameter/2,h=length);
		translate([diameter/2 - flat,-diameter/2-1,-1]) cube([diameter,diameter+2,length+2]);
	}
}
