$fa = 4;
$fs = 0.5;

include <../../my_lib.scad>
use <nikkor_mirco_60mm_lens_hood_adapter.scad>

on_lens();

module on_lens(k = 4, thickness = 2)
{
	inner = 40;
	union(){
		adapter(6);
		tube(inner + thickness, inner, 12);
		for(i = [1:k]) {
			rotate([0,0,i*360/k])
				translate([0,40+thickness,7.5])
					rotate([-90,0,0])
						ball();
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