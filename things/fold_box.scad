$fn=60;

// dimension of the box
length = 125;
width = 75;
height = 50;

thickness = 1.5; // of the aluminium sheet
flap = 10;
topFlap = 30;
screwDiameter = 3;
screwDistanceFromBorder = 10;
expectedScrewSpace = 50;
cutWidth = 0.5;

module screw() {
    difference() {
        circle(d = screwDiameter);
        circle(0.1); // to mark the center
    }
}

module screws(n, deltaX, deltaX) {
    for(i = [0 : n-1]) translate([i*deltaX, i*deltaY]) screw();
}

module spreadScrews(n, start, end) {
    if (end - start < 2 * screwDistanceFromBorder + screwDiameter) {
        translate([start + (end - star) / 2, 0]) screw();
    } else {
        actualStart = start + screwDistanceFromBorder;
        actualEnd = end - screwDistanceFromBorder;
        gap = (actualEnd - actualStart) / (n-1);
        for(i = [0 : n-1]) translate([actualStart + i*gap, 0]) screw();
    }
}

module autoSpreadScrews(start, end) {
    n0 = (end - start - 2 * screwDistanceFromBorder) / expectedScrewSpace;
    n = 1 + round(n0);
    spreadScrews(n, start, end);
}

module trapezoid(xTop, xBottom, y, skew = 0.0) {
    skewOffest = y * tan(skew);
    d = (xBottom-xTop)/2;
    pts = [
        [0, 0],
        [xBottom, 0],
        [d + skewOffest, y],
        [xBottom - d + skewOffest, y]
    ];
    paths = [ [0, 1, 3, 2] ];
    polygon(pts, paths);
}

module bottom() {
    difference() {
        translate([-flap,-flap]) square([length + 2 * flap, width + 2 * flap]);
        //square([length, width]); // to represent the box, not a real hole
        translate([0, -flap/2]) autoSpreadScrews(0, length);
        translate([0, width + flap/2]) autoSpreadScrews(0, length);
        translate([-flap/2, 0]) rotate([0,0,90]) autoSpreadScrews(0, width);
        translate([length + flap/2, 0]) rotate([0,0,90]) autoSpreadScrews(0, width);
    }
}

module side(length) {
    difference(){
        union(){
            square([length, height]);
            translate([-flap, thickness]) square([length + 2 * flap, height-thickness]);
            translate([-flap, -flap]) trapezoid(length, length + 2 * flap, flap);
        }
        translate([0, -flap/2]) autoSpreadScrews(0, length);
        translate([-flap/2, 0]) rotate([0,0,90]) autoSpreadScrews(0, height);
        translate([length + flap/2, 0]) rotate([0,0,90]) autoSpreadScrews(0, height);
        //remove material to help folding
        translate([0,thickness - cutWidth]) square([thickness, cutWidth]);
        translate([length - thickness,thickness - cutWidth]) square([thickness, cutWidth]);
    }
}

module top() {
    difference(){
        union(){
            translate([-topFlap, thickness]) square([length + 2 * topFlap, width - 2*thickness]);
            translate([0, -topFlap]) square([length, width + 2 * topFlap]);
        }
        //square([length, width]); // to represent the box, not a real hole
        //remove material to help folding
        translate([0,thickness - cutWidth]) square([thickness, cutWidth]);
        translate([0,width - thickness]) square([thickness, cutWidth]);
        translate([length - thickness,thickness - cutWidth]) square([thickness, cutWidth]);
        translate([length - thickness,width - thickness]) square([thickness, cutWidth]);
    }
}

//bottom();
//side(length);
//side(width);
top();