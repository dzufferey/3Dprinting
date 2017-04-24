$fn = 60;


module face(height = 15,
            base_height = 0.1,
            width = 55,
            depth_base = 20,
            depth_top = 5,
            notch = 2,
            notch_dist_from_side = 8) {
    difference() {
        hull() {
            cube([width, depth_top, height]);
            cube([width, depth_base, base_height]);
        }
        translate([0,0,height/2]) rotate([45,0,0]) rotate([0,90,0]) translate([-notch/2,-notch/2,0]) cube([notch,notch,width]);
        translate([notch_dist_from_side,0,0]) rotate([0,0,45]) translate([-notch/2,-notch/2,0]) cube([notch,notch,height]);
        translate([width - notch_dist_from_side, 0, 0]) rotate([0,0,45]) translate([-notch/2,-notch/2,0]) cube([notch,notch,height]);
    }
}

module carriage(height = 10,
                width = 55,
                depth = 20,
                rod = 3,
                center_rod = 3,
                rod_offset = 0,
                center_rod_offset = 0,
                rod_from_side = 6) {
    difference() {
        cube([width, depth, height]);
        translate([rod_from_side, 0, height / 2 + rod_offset]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth);
        translate([width - rod_from_side, 0, height / 2 + rod_offset]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth);
        translate([width/2, 0, height / 2 + center_rod_offset]) rotate([-90, 0, 0]) cylinder(r = center_rod, h = depth);
    }
}

module movable_jaw() {
    difference() {
        union() {
            carriage();
            translate([0,0,10]) face();
        }
        // take M6 nut and grind the side and make them square
        // the square shape hold the nuts in place
        translate([22.5, 3, 0]) cube([10, 5.5, 10]);
        translate([22.5,11.5, 0]) cube([10, 5.5, 10]);
    }
}

module fixed_jaw() {
    difference() {
        union() {
            carriage();
            translate([0,0,10]) face();
            difference() {
                translate([0,10,0]) cylinder(r = 5, h = 10); // for the top dowel pin
                hull() carriage();
            }
        }
        // To get something with diameter 9 and height 5: grind M6 nut
        // hold with thread locker or glue
        translate([27.5, 0, 5]) rotate([-90, 0, 0]) cylinder(r = 4.5, h = 5);
        translate([27.5, 20, 5]) rotate([90, 0, 0]) cylinder(r = 4.5, h = 5);
        // holes for the pins
        translate([18,10,0]) union() {
            pins();
            translate([  0, 0, 10]) cylinder(r = 5, h = 50);
        }
    }
}

module back_guide() {
    difference() {
        union() {
            carriage(depth = 10);
            difference() {
                translate([0,5,0]) cylinder(r = 5, h = 10); // for the top dowel pin
                hull() carriage();
            }
        }
        // holes for the pins
        translate([18,5,0]) pins();
    }
}

module pins() {
    union() {
        translate([-20, 0,-10]) cylinder(r = 1.5, h = 20);
        translate([  0, 0,-10]) cylinder(r = 2, h = 50);
        translate([ 24, 0,-10]) cylinder(r = 1.5, h = 20);
    }
}

module parallel(extra_height = 2,
                height = 10,
                width = 55,
                depth = 5,
                rod = 3.5,
                center_rod = 3,
                rod_offset = 0,
                center_rod_offset = 0,
                rod_from_side = 6) {
    difference() {
        cube([width, depth, height+ extra_height]);
        hull() {
            translate([rod_from_side, 0, height / 2 + rod_offset]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth+1);
            translate([rod_from_side, 0, -height]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth+1);
        }
        hull() {
            translate([width - rod_from_side, 0, height / 2 + rod_offset]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth+1);
            translate([width - rod_from_side, 0, -height]) rotate([-90, 0, 0]) cylinder(r = rod, h = depth+1);
        }
        hull(){
            translate([width/2, 0, height / 2 + center_rod_offset]) rotate([-90, 0, 0]) cylinder(r = center_rod, h = depth+1);
            translate([width/2, 0, -height]) rotate([-90, 0, 0]) cylinder(r = center_rod, h = depth+1);
        }
    }
}

module all_parts(){
    /// all the parts for the vise
    translate([0, 0,0]) fixed_jaw();
    translate([55, -10,0]) rotate([0,0,180]) movable_jaw();
    translate([0, -50, 0]) back_guide();
    
    // Some parallels of different height
    // Rotated upside-down for easier printing
    translate([-10, -50, 0]) {
        translate([0, 10, 12]) rotate([0,180,0]) parallel(extra_height = 2);
        translate([0, 20, 12]) rotate([0,180,0]) parallel(extra_height = 2);
        translate([0, 30, 15]) rotate([0,180,0]) parallel(extra_height = 5);
        translate([0, 40, 15]) rotate([0,180,0]) parallel(extra_height = 5);
        translate([0, 50, 18]) rotate([0,180,0]) parallel(extra_height = 8);
        translate([0, 60, 18]) rotate([0,180,0]) parallel(extra_height = 8);
    }
}

all_parts();
//fixed_jaw();
//movable_jaw();
//back_guide();
//translate([0, 10, 12]) rotate([0,180,0]) parallel(extra_height = 2);
//translate([0, 10, 15]) rotate([0,180,0]) parallel(extra_height = 5);
//translate([0, 10, 18]) rotate([0,180,0]) parallel(extra_height = 8);