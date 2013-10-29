$fa = 4;
$fs = 1;

include <my_lib.scad>

//parameters
tolerance = 0.15; //extra space between the parts
height = 35 + 1; //inner
radius = 65 / 2; //inner
thickness = 3;
overlap = 5;
holes = 8;

//derived cst
or = radius + thickness; //outer radius
mr = radius + thickness / 2; //middle radius
ir = radius;	//inner radius

h2 = height / 2;

ha = 360 / holes / 2;
hi = ir * 1 / 3;
ho = ir * 4 / 5 ;

////
translate([5 + (or * 2),0,0]) cap();
body();
//cap();


//round version

module cap() {
	union() {
		difference() {
			union() {
				cylinder(r=or, h=h2-overlap+thickness);
				cylinder(r=mr, h=h2+thickness);
			}
			translate([0,0,thickness]) cylinder(r=ir, h=h2+1);
			bigger() tube(or, mr, overlap / 2);
		   for (i = [0:holes-1]) {
				bigger() rotate([0,0,(i*2+0.5)*ha]) pie_slice(ho, hi, ha, thickness);
			}
		}
		for (i = [0:holes-1]) {
			rotate([0,0,i*2*ha])
				translate([0,mr,thickness])
					rotate([90,0,0])
						scale([1,2*thickness/mr,1])
							cylinder(r2=0,r1=sin(ha)*mr/2 - tolerance, mr - tolerance);
		}
	}
}

module body() {
	difference () {
		cylinder(r=or, h=h2+thickness+overlap);
		translate([0,0,thickness]) cylinder(r=ir, h=h2+overlap+1);
		bigger() translate([0,0,height+2*thickness]) rotate([180,0,0]) union() {
				cylinder(r=or, h=h2-overlap+thickness);
				cylinder(r=mr, h=h2+thickness);
			}
	}
}
