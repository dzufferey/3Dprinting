//$fn=60;
$fa=4;
$fs=1.5;

module screw() {
    union(){
        cylinder(r=1.6, h=5, $fn=30);
        translate([0,0,5]) cylinder(r1=1.75,r2=3.25, h=1.5, $fn=30);
        translate([0,0,6.5]) cylinder(r=3.25, h=20, $fn=30);
    }
}

module screws() {
    union() {
        translate([11,7.5,0]) screw();
        translate([11,40-7.5,0]) screw();
    }
}

module shape(h) {
    hull() {
        cube([40,40,h]);
        translate([0,0,h]) rotate([0,-30,0]) translate([0,0,-h]) cube([40,40,h]);
    }
}

module slice(i, total, thickness) {
    translate([0,0,10.5 * i / total + thickness])
        rotate([0,-30 * i / total, 0])
            translate([0,0,-thickness])
                cube([40,40,thickness]);
}

module rCubeH(x, y, z, r) {
    intersection() {
        minkowski(){
            translate([r, r, 0]) cube([x - 2*r, y - 2*r, z]);
            sphere(r);
        }
        cube([x, y, z]);
    }
}

module hull_serie() {
    for(c = [0:$children-2]) {
        hull() {
            children(c);
            children(c+1);
        }
    }
}

module inner() {
    hull_serie(){
        translate([0,0,10.6]) rotate([0,-30, 0]) translate([20.3,20,-0.1]) cylinder(r=19,h=0.1);
        translate([28,9,3]) rCubeH(7,22,0.2,1);
        translate([31.95,9.98,0]) rCubeH(3.5,20.05,0.2,0.5);
    }
}

module outer() {
    difference() {
        shape(10.5);
        inner();
    }
}

module sliced2(i, total, thickness) {
    intersection(){
        outer();
        slice(i, total, thickness);
    }
}

module sl2(r, i, total, thickness) {
    difference(){
        slice(i, total, thickness);
        minkowski(){
            sliced2(i, total, thickness);
            sphere(r);
        }
    }
}

module cone(minR = 2, maxR = 9, slices = 20) {
    hull_serie(){
        for (i = [0:slices-1]) {
            sl2(minR + (maxR - minR) * i / slices, i, slices, 0.1);
        }
        sl2(9, 999, 1000, 0.1);
    }
}

module newFanDuct() {
    difference(){
        union() {
            cone();
            outer(); //TODO nicer with rounded corners ?
            translate([0,0,10.5]) rotate([0,-30, 0]) {
                translate([0,19.85,-10]) cube([40,0.3,10]);
                translate([19.85,0,-2]) cube([0.3,40,2]);
            }
        }
        screws();
        translate([0,0,10.5]) rotate([0,-30, 0]) {
            translate([4.3,4,-8]) cylinder(r=1.5, h=10, $fn=30);
            translate([4.3,36,-8]) cylinder(r=1.5, h=10, $fn=30);
            translate([36.3,4,-6]) cylinder(r=1.5, h=10, $fn=30);
            translate([36.3,36,-6]) cylinder(r=1.5, h=10, $fn=30);
        }
        //cut the sides
        translate([36,0,0]) cube([40,40,40]);
        translate([9,-36.5,-13.8]) rotate([20,0,14]) cube(40);
        translate([0,40,0]) rotate([-20,0,-14]) cube(40);
    }

}

translate([0,0,9.1])
    rotate([0,-150,0])
        newFanDuct();
