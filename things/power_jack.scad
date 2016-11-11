$fn=60;

tolerance = 0.1;

jack();

module jack() {
    
    l = 10;
    pinL = 6;
    pinS = 0.65 +2*tolerance;
    
    difference(){
        translate([1,1,0]) minkowski(){
            cube([l-2, 8, 4]);
            cylinder(r=1,h=1);
        }
        translate([1,5,3]) rotate([0,90,0]) cylinder(r=5.5/2+tolerance, h=9);
        translate([0,5,3]) cube([2*pinL,pinS,pinS], true);
        translate([0,5-6/2,3]) cube([2*pinL,pinS,pinS], true);
        translate([0,5+6/2,3]) cube([2*pinL,pinS,pinS], true);
        translate([pinL-pinS/2,5-6/2-pinS/2,3]) cube([pinS,pinS,pinS], true);
        translate([pinL-pinS/2,5+6/2+pinS/2,3]) cube([pinS,pinS,pinS], true);
    }
}
