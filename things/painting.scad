//TODO for long surface do not forget to add corner pad to make it stick to the bed

h1 = 5; //for paint
h2 = 10; //for water
h3 = 1.5; //for border
thickness = 1;
length = 20;
tolerance = 0.2;

//for (t = [ [0,0,0],
//			[length + 2, 0, 0],
//			[0, length + 2, 0],
//			[length + 2, length + 2, 0] ])
//	translate(t) paint_bucket();
//water_bucket();
base();

module paint_bucket(l = length, h = h1, t = thickness)
{
	lm2t = l - 2*t;
    r = lm2t * 0.707;
	union() {
		difference(){ //curved bottom
			cube([l,l,h]);
			translate([l/2,l/2,h]) scale([1,1,(h-t)/r]) sphere(r);
		}
		difference(){ //walls
			cube([l,l,h]);
			translate([t,t,t]) cube([lm2t, lm2t, h]);
		}
	}
}

module water_bucket(l = 2*length+thickness, h = h2, t = thickness)
{
	lm2t = l - 2*t;
	union(){
		difference(){
			cube([l,l,h]);
			translate([t,t,t]) cube([lm2t, lm2t, h]);
		}
	}
}

module base()
{
	t = thickness;
	l = length;

	x = 2*l + 3 * t + 3 * l;
	y = 4*l + 5 * t;

	offset = t + tolerance;
	st = t - 2 * tolerance;
	sl = l - 2 * offset;

	union() {
		cube([x, y, t]);
		//border
		translate([0,0,t]) cube([x,t,h3]);
		translate([0,0,t]) cube([t,y,h3]);
		translate([x-t,0,t]) cube([t,y,h3]);
		translate([0,y-t,t]) cube([x,t,h3]);
		//separations
		for (i = [1:2], j = [0:3]) {
			if (i > 1 || j < 2) translate([i*(l+t) + tolerance, t + j*(l+t) + offset, t]) cube([st,sl,h3]);
		}
		for (i = [0:1], j = [1:2]) {
			translate([t + i*(l+t) + offset, j*(l+t) + tolerance, t]) cube([sl,st,h3]);
		}
		//border for brushes
		for(i=[0:360]) translate([x-t,l+i/6,h3+t]) cube([t,1,(1+cos(180+i*4))*h3]);
		//corner pad
		for (a = [0,x], b = [0,y]) translate([a,b,0]) cylinder(r = 5, h = 0.5);
	}

}
