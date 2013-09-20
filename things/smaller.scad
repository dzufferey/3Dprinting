
tolerance = 0.25;

module bigger(t = tolerance) {
    if (t > 0) {
        minkowski() {
            child(0);
            cube(t, true);
        }
    } else {
        child(0);
    }
}

module negative( bounding_box = [-10, 10, -10, 10, -10, 10]) {
    difference() {
        translate([bounding_box[0], bounding_box[2], bounding_box[4]])
            cube([bounding_box[1] - bounding_box[0],
                  bounding_box[3] - bounding_box[2],
                  bounding_box[5] - bounding_box[4]]);
        child(0);
    }
}

module negative1(size) {
    negative([-size, size, -size, size, -size, size]) child(0);
}

module smaller(t = tolerance, bounding_box = [-10, 10, -10, 10, -10, 10]) {
    difference(){
        translate([bounding_box[0], bounding_box[2], bounding_box[4]])
          cube([bounding_box[1], bounding_box[3], bounding_box[5]]);
        bigger(t) negative() child(0);
    }
}