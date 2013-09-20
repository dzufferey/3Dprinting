$fa = 6;
$fs = 1;

roller_part1();
translate([28, 80, 0]) roller_part2();

translate([56,0,0]){
	roller_part1();
	translate([28, 80, 0]) roller_part2();
}

module roller()
{
	union(){
		minkowski() {
			cube([15, 160, 2], true);
			cylinder(1, 5, 5);
		}
		translate([0, -75, 0]) knob();
		translate([0, -40, 0]) knob();
		translate([0, 75, 0]) knob();
		translate([0, 40, 0]) knob();
	}
}

module roller_part1()
{
	union() {
		intersection() {
			roller();
			translate([-25, 0, 0]) cube([50, 100, 10]);
		}
		rotate([0,0,90]) dovetail();
	}
}

module roller_part2()
{
	difference() {
		intersection() {
			roller();
			translate([-25, -100, 0]) cube([50, 100, 10]);
		}
		rotate([0,0,90]) dovetail(false);
	}
}

module knob()
{
	radius =  2.5;
	union() {
		cylinder(4,radius,radius);
		translate([0,0,4]) cylinder(1,radius,radius-1);
	}
}

tolerance = 0.15; //extra space between the parts
knob_height = 5; //the height of the dovetails

module dovetail(male = true, base = 25, width = 2) {
    t = male ? 0 : tolerance;
    translate([ - knob_height, 0, 0])
        rotate([90,0, 90])
            bigger(t)
                trapeze(knob_height, width, base/2, base/3);
}

module trapeze(h, w, r1, r2, center = false) {
    rotate([-90,0,0]) linear_extrude(height = w) projection(false) rotate([90,0,0]) cylinder(h, r1/2, r2/2, center);
}

module bigger(t = tolerance) {
    if (t > 0) {
        minkowski() {
            child(0);
            cube(t, true);
        }
    } else {
        child(0);
    }
}

