$fa=4;
$fs=0.5;

include <../../my_lib.scad>

//adapter that can mimic an hb-42 lens hood

adapter();

outer = 69/2;
inner = 66/2;
bump = 0.5;

module adapter(wall = 4){
	union(){
		tube(outer+wall,outer,1.2);
		for (i = [0, 1]) {
			rotate([0,0,180*i]){
				pie_slice(outer + 0.1,inner,75,1.2);
				pie_slice(outer + 0.1,inner-bump,7,1.2);
				rotate([0,0,68]) pie_slice(outer + 0.1,inner-bump,7,1.2);
				rotate([0,0,-4])
					translate([inner+0.3,0,0])
						rotate([0,0,-60])
							cube([4,3,1.2]);
			rotate([0,0,77])
					translate([inner+2.6,0,0])
						rotate([0,0,60])
							cube([4,3,1.2]);
			}
		}
	}
}
