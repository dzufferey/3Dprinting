

//b();
//translate([0, -23, 0]) s1();
//translate([0, -46, 0]) s1();

// 3 segments with joint separated by 100mm (the longest for my printer)
translate([0, 23, 0]) s2();
translate([0, 46, 0]) s2();
s3();


//base with holes for horn on each side
module b(l=100,w=22,e0=0,e1=0) {
    difference(){
        union() {
            translate([-e0,-w/2,0]) cube([l+e0+e1,w,3]);
            translate([-e0,0,0]) cylinder(r=w/2, h=3);
            translate([l+e1,0,0]) cylinder(r=w/2, h=3);
        }
        holes();
        translate([l,0,0]) holes();
    }
}

//module with holes for a mini servo
module s2() {
    difference(){
        b(e0=3);
        translate([-6.5,-12/2,0]) cube([22,12,3]);
    }
}

//module with pen holder
module s3() {
    difference(){
        union(){
            b();
            translate([5,-5,0]) cube([10,10,40]);
        }
        cylinder(r=7, h=40);
    }
}

//holes for servo horn
module holes() {
    union() {
        cylinder(r=3, h=3);
        rotate([0,0,45]) for( i = [5,7,9] ) {
            translate([-i, 0,0]) cylinder(r=0.7, h=3);
            translate([ i, 0,0]) cylinder(r=0.7, h=3);
            translate([ 0, i,0]) cylinder(r=0.7, h=3);
            translate([ 0,-i,0]) cylinder(r=0.7, h=3);
        }
    }
}

module s1() {
    difference(){
        b(e0=4);
        translate([-8,-13/2,0]) cube([24,13,3]);
    }
}