
/* This is an enclosure to hold two 10 pins 0.100'' (2.54 mm) female headers.
 * The side notch gives space for the electrical wires.
 */

wall=1.5;
inner_y=5;
inner_x=27;
z=12;

pin_enclosure();

module pin_enclosure () {
	difference(){
		cube([inner_x+2*wall,inner_y+2*wall,z]);
		translate([wall,wall,-1]) cube([inner_x,inner_y,z+2]);
		translate([0,-1,7]) cube([wall,inner_y+2*wall+2,5]);
	}
}
