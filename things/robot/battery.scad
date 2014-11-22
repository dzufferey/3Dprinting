$fa=4;
$fs=0.5;

include<../my_lib.scad>


//to hold the batteries in place: oogoo_spacer.scad
//for the electric connections, I use thumb tacks.

// AA battery: diameter = 14.5, height = 50.5
//AAA battery: diameter = 10.5, height = 44.5

//AAA_box(k=4);
AA_box(k=8);

module AA_box(
	k=8,
	bat_d = 0.5,
	bat_h = 0,
	thickness = 2,
	spring_h = 2.5,
	spring_r = 7,
	wire_groove = 2)
{
	battery_box(k, 14.5+bat_d, 50.5+bat_h, thickness, spring_h, spring_r, wire_groove);
}

module AAA_box(
	k=8,
	bat_d = 0.5,
	bat_h = 0,
	thickness = 2,
	spring_h = 2.5,
	spring_r = 5,
	wire_groove = 2)
{
	battery_box(k, 10.5+bat_d, 44.5+bat_h, thickness, spring_h, spring_r, wire_groove);
}

module battery_box( k, bat_d, bat_h, thickness, spring_h, spring_r, wire_groove)
{
	total_x = k * bat_d + 2 * thickness;
	total_y = bat_h + spring_h -1 + 2 * thickness;
	inner_y = total_y - 2*thickness;
	total_z = bat_d + thickness;
	sx = bat_d - 2*spring_r;
	sy = spring_h-1.5;
	union(){
		difference(){
			cube([total_x,total_y,total_z]);
			for(i = [1 : k]){
				translate([thickness+(i-1)*bat_d,thickness,thickness+bat_d/4-0.5]) cube([bat_d+0.01,inner_y,bat_d]);
				translate([thickness-bat_d/2+i*bat_d,thickness,thickness+bat_d/2/1.5]) rotate([-90,0,0]) scale([1,1/1.5,1]) cylinder(r=bat_d/2, h=inner_y);
				translate([thickness-bat_d/2+i*bat_d,-1,thickness+bat_d/2]) rotate([-90,0,0]) cylinder(r=0.7,h=total_y+2);
				translate([thickness-bat_d/2+i*bat_d,thickness-0.5,thickness+bat_d/2]) rotate([-90,0,0]) cylinder(r=spring_r,h=inner_y+1.5);
			}
			for(i = [1 : k-1]) {
				translate([thickness+i*bat_d-wire_groove/2,-1,-1]) cube([wire_groove,total_y+2,wire_groove+1]);
			}
		}
		for(i = [1 : k-1]) {
			translate([thickness+i*bat_d-sx/2,inner_y+thickness-sy,wire_groove]) cube([sx,sy+0.1,total_z-wire_groove]);
		}
	}
}
