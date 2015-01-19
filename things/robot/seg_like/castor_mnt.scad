$fa=4;
$fs=0.5;

tolerance=0.15;

arm();
//translate([0,0,45]) rotate([180,0,0]) castor_mount();

cmw = 20; //castor mount width

//what are the dimension of the wheels
castor_top = 15 + 20 + 3 + 1; //from ground
peg_radius = 2.5;
peg_height = 10; //without the pin lip
horizontal_space = 15 + 5 + 7; //tire to pin + 5

//////////////////////////////

module castor_frame_mount(thickness = 3, height = 30) {
	translate([-cmw/2,0,0]) {
		difference() {
			cube([cmw,thickness,height]);
			//TODO some holes/peg to attache the other part ??
		}
	}
}

module castor_mount(thickness = 3, height = 30) {
	
	t = thickness;
	ground_clearance = 30 - 21 - thickness;
	h1 = castor_top - ground_clearance;
	h = h1 + peg_height - 1 + t;
	p = peg_radius+t/2-3+2+tolerance;

	union() {
		difference(){
			translate([-t,0,0]) cube([cmw+2*t,3*t,h]);
			translate([-tolerance,t-tolerance,-0.5]) cube([cmw+2*tolerance, t+2*tolerance, height+1]);
			translate([0,-t/2,-1]) cube([1,2*t,height+1]);
			translate([cmw-1,-t/2,-1]) cube([1,2*t,height+1]);
			translate([-t-1,2*t-tolerance,-1]) cube([cmw+2*t+2,t+2,t+1+tolerance]);
			translate([cmw/2-p,-1,h1]) cube([2*p,3*t+2,peg_height-1+tolerance]);
		}
		//lip
		translate([-t,0,-tolerance])
		rotate([0,90,0])
		intersection(){
			translate([0,t*3/4,0]) scale([1,-.75,1]) cylinder(r=t,h=cmw+2*t);
			cube([t,2*t,cmw+2*t]);
		}
		translate([1,0,-2*tolerance]) cube([cmw-2,t,3*tolerance]);
		//top platform
		//...
	}
}

module arm(t=3) {
	union(){
		arm_half(t);
		mirror([1,0,0]) arm_half(t);
	}
}

module arm_half(t = 3) {
   ro = peg_radius+t/2;
	h = peg_height-1;
	difference() {
		union(){
			translate([0,-horizontal_space-tolerance,0]) cube([ro,horizontal_space,h]);
			translate([0,-horizontal_space,0]) cylinder(r=ro+0.5,h=h);
			translate([ro-3,-tolerance,0]) cube([2,3*t+2*tolerance,h]);
			translate([ro-3,3*t+tolerance,0]) intersection() {
				cylinder(r=3, h=h);
				cube([3,3,h]);
			}
		}
		translate([0,-horizontal_space,-1]) cylinder(r=peg_radius+tolerance+0.5,h=peg_height+2);
	}
}
