$fn=20;
$fa=0.1;
wall = 2.5;

//part for gripper
height = 8;
width = 35;
thingW = 12;
thingH = 5;

//part for ...
width2 = 40;
height2 = 24;
rounding = 4;
h1=2.5;
h2=2;
d=5;


d2=5;


merged();



module merged() {
	union(){
		translate([-wall/2+height/2,(width2-width)/2,wall/2]) {
			cube([wall,width,d2]);
		}
		translate([0,(width2-width)/2,0]) {
			part1();
		}
		translate([wall/2+height/2,0,d2]) {
			rotate([0,-90,0])
				part2();
		}
	}
}

module part1() {
	union(){
		cube([height,width,wall]);
		translate([-thingH,(width-thingW)/2,0])
			cube([height+2*thingH,thingW,wall]);
	}
}

module part2() {
	difference() {
		translate([rounding,rounding,0]) {
			minkowski() {
				cube([height2-2*rounding,width2-2*rounding,wall-0.1]);
				cylinder(r=rounding, h=0.1);
			}
		}
		translate([height2/2,width2/2,-0.5]) cylinder(r=h1, h=wall+1);
		translate([d,d,-0.5]) cylinder(r=h2, h=wall+1);
		translate([height2-d,d,-0.5]) cylinder(r=h2, h=wall+1);
		translate([d,width2-d,-0.5]) cylinder(r=h2, h=wall+1);
		translate([height2-d,width2-d,-0.5]) cylinder(r=h2, h=wall+1);
	}
}