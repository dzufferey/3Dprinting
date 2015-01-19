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
spokes_nbr = 6;
spokes_width = 5;
rim_thickness = 2;
hub_thickness = 3;

//mold
thread_depth = 0.5;
thread_width = 1;
thread_angle = 15;
mold_wall = 2;

//shaft
shaft_length = 50;
shaft_diameter = 5.3; //0.3 of tolerance
shaft_flat = 0.45;

rW = wheel_diameters / 2;
rR = rW - tire_thickness;
rI = rR - tire_thickness;
rI2 = rI - rim_thickness;
rH = shaft_diameter / 2 + hub_thickness;

module rim() {
	difference() {
		union() {
			difference() {
				union() {
					cylinder(r1=rR,r2=rI,h=4);
					translate([0,0,wheel_width-4]) cylinder(r1=rI,r2=rR,h=4);
					cylinder(r=rI,h=wheel_width);
				}
				cylinder(r=rI2,h=wheel_width);
			}
			cylinder(r=rH,h=wheel_width);
			for (i = [0 : spokes_nbr]) {
				rotate([0,0,360/spokes_nbr*i]){
					translate([-spokes_width/2,shaft_diameter/2,0])
						cube([spokes_width,rI2 - shaft_diameter/2,wheel_width]);
				}
			}
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
	thingy_width = 2;
	thingy_height = 2;
	tolerance = 0.3;
	union() {
		difference(){
			cylinder(r=rW+mold_wall, h=height);
			translate([0,0,2*mold_wall]) tire();
			translate([0,0, -0.1]) {
				intersection(){
					tire();
					cylinder(r1 = rW-thread_depth, r2 = rW+thread_depth, h = 2*mold_wall + 0.2);
				}
			}
			for (i = [0 : spokes_nbr/2]) {
				rotate([0,0,720/spokes_nbr*i+360/spokes_nbr]){
					translate([0,rW+mold_wall/2,height]) sphere(1);
				}
			}
		}
		for (i = [0 : spokes_nbr]) {
			rotate([0,0,360/spokes_nbr*i]){
				translate([0,rI2-tolerance-thingy_width/2,0])
					union() {
						translate([-thingy_width/2,0,0]) cube([thingy_width,rW-rI2+thingy_width,mold_wall]);
						cylinder(r=thingy_width/2,h=mold_wall+thingy_height);
				}
			}
		}
		for (i = [0 : spokes_nbr/2]) {
			rotate([0,0,720/spokes_nbr*i]){
				translate([0,rW+mold_wall/2,height]) sphere(0.9);
			}
		}
	}
}

//placeholder for the shaft of an electric motor
//(designed after the shaft of a NEMA 17 stepper motor)
module shaft(length = shaft_length, diameter = shaft_diameter, flat = shaft_flat) {
	difference() {
		cylinder(r=diameter/2,h=length);
		translate([diameter/2 - flat,-diameter/2-1,-1]) cube([diameter,diameter+2,length+2]);
	}
}
