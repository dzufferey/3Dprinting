$fa=4;
$fs=0.5;

include<../my_lib.scad>

// AA battery: diameter = 14.5, height = 50.5
//AAA battery: diameter = 10.5, height = 44.5

AAA_box(k=4);

module AA_box(
	k=8,
	bat_d = 0.5,
	bat_h = 0,
	thickness = 2,
	spring_h = 2,
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
	spring_h = 2,
	spring_r = 5,
	wire_groove = 2)
{
	battery_box(k, 10.5+bat_d, 44.5+bat_h, thickness, spring_h, spring_r, wire_groove);
}

module battery_box(
	k=8,
	bat_d = 15, // 14.5 + 0.5
	bat_h = 50.5,
	thickness = 2,
	spring_h = 2,
	spring_r = 7,
	wire_groove = 2)
{
	total_x = k * bat_d + 2 * thickness;
	total_y = bat_h + 2 * thickness;
	total_z = bat_d + thickness;
	difference(){
		cube([total_x,total_y,total_z]);
		for(i = [1 : k]){
			translate([thickness+(i-1)*bat_d,thickness,thickness+bat_d/4]) cube([bat_d+0.01,bat_h,bat_d]);
			translate([thickness-bat_d/2+i*bat_d,thickness,thickness+bat_d/4]) rotate([-90,0,0]) scale([1,1/2,1]) cylinder(r=bat_d/2, h=bat_h);
			translate([thickness-bat_d/2+i*bat_d,-1,thickness+bat_d/2]) rotate([-90,0,0]) cylinder(r=0.7,h=total_y+2);
			translate([thickness-bat_d/2+i*bat_d,thickness-1,thickness+bat_d/2]) rotate([-90,0,0]) cylinder(r=spring_r,h=bat_h+spring_h*3/4);
		}
		for(i = [1 : k-1]) {
			translate([thickness+i*bat_d-wire_groove/2,-1,-1]) cube([wire_groove,total_y+2,wire_groove+1]);
		}
	}
}
