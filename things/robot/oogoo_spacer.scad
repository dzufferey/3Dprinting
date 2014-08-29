$fa=4;
$fs=0.5;

include<../my_lib.scad>

/////////////////////////////////////////
// mold for 'spacer' made out of oogoo //
// used to hold the batteries in place //
/////////////////////////////////////////

//spacer_mold();
spacer_mold(2,2,5,1.5,1.5,1,8);

module oogoo_spacer( outer_radius = 7, inner_radius = 2, groove = 1.5, base = 1, n = 8)
{
	a1 = 360 / n;
	a2 = a1 / 2;
	difference(){
		union(){
			cylinder(r = outer_radius, h = base);
			for(i = [1 : n]) {
				rotate([0,0,i*a1])
					pie_slice(outer_radius, inner_radius, a2, base + groove);
			}
		}
		cylinder(r = inner_radius, h = base + groove);
	}
}

module spacer_mold(i = 3, j = 3, outer_radius = 7, inner_radius = 2, groove = 1.5, base = 1, n = 8)
{
	d = outer_radius*2 + 1;
	difference(){
		cube([1+i*d, 1+j*d, groove+base+0.5]);
		for(k = [1 : i]) {
			for(l = [1 : j]){
				translate([k*d - d/2+0.5, l*d -d/2+0.5, 0.5+groove+base+0.001])
					rotate([0,180,0])
						oogoo_spacer(outer_radius, inner_radius, groove, base, n);
			}
		}
	}
}