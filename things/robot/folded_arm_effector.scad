$fa=4;
$fs=0.5;

tolerance = 0.15;


difference(){
    cube([20,10,1]);
    translate([0,5,1]) rotate([0,90,0]) cylinder(r = 0.5, h=50);
}
//translate([0,0,30]) rotate([0,180,0]) effector();
//translate([2,0,0]) mold();

module effector() {
    difference() {
        union() {
            cube([5,10,30]);
            translate([0,0,28]) cube([45,10,2]);
        }
        translate([2.5,2.5,0]) cylinder(r1 = 1.2, r2 = 1.8, h=2);
        translate([2.5,7.5,0]) cylinder(r1 = 1.2, r2 = 1.8, h=2);
        translate([0,5,0]) cylinder(r = 0.5, h=50);
    }
}

module mold() {
    difference() {
        cube([7,12,10]);
        translate([1-tolerance,1-tolerance,0.6]) cube([5+2*tolerance,10+2*tolerance,10]);
    }
}