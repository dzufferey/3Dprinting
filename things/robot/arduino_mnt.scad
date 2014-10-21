$fa=4;
$fs=0.5;

tolerance=0.15;

arduino_mount(peg=20);

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
		translate([52.1,  5.1, t]) support_peg(radius, thickness, height, peg);
		translate([52.1,   33, t]) support_peg(radius, thickness, height, peg);
	}
}

