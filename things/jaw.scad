// vice jaws to hold tubes
module jaw() {
    difference(){
        union(){
            difference(){
                cube([20, 10, 19]);
                translate([10, 11, 10]) rotate([0,0,45]) cube([8, 8, 20], true);
            }
            cube([20, 6, 19]);
        }
        translate([0, -5, -2]) cube([20, 10, 19]);
    }
}

jaw();
//translate([10,11,0]) cylinder(r=4,h=20);
//translate([10,12.5,0]) cylinder(r=5,h=20);