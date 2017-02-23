$fa = 4;
$fs = 0.5;

include <../../my_lib.scad>
use <nikkor_mirco_60mm_lens_hood_adapter.scad>

on_lens();

module on_lens(k = 4, thickness = 2, support = 12)
{
	inner = 40;
	union(){
		adapter(6);
		tube(inner + thickness, inner, 12);
		for(i = [1:k]) {
			rotate([0,0,i*360/k])
				union() {
					translate([0,40+thickness,7.5])
						rotate([-90,0,0])
							ball();
					if (support > 0) {
						translate([0,50+thickness,0])
							union() {
								cylinder(r=7, h=0.3);
								for (i = [1 : support])
									rotate([0,0,i*360/support])
										translate([3,0,0])
											cube([4,0.3,5]);
							}
					}
				}
		}
	}
}

module ball() {
	difference(){
		translate([0,-22,0])
			import("external/ball_and_socket_chain_links_with_hole_through/only_ball.stl");
		translate([-2,-5,-0.5]) cube([4,5,3]);
	}
}
