$fn=60;

tolerance = 0.1;

h = 10; // height
d = 5;  // depth
k = 10; // #blades
g = 0.3;  // thickness of the blades
gap = g + 2*tolerance;
width = 2; // space between the blades
s = 4; // space between the left and right part

translate([0, 1 * (h + 2), 0]) heatsink_blade_forms_1();
translate([0, 2 * (h + 2), 0]) heatsink_blade_forms_1();
heatsink_blade_forms_2();

module heatsink_blade_forms_1() {
    union() {
        cube([k*(width+gap)+width,h,1]);
        for ( i = [0 : k] )
        {
            translate([i*(width+gap),0,1]) cube([width,h,d]);
        }
    }
}

module heatsink_blade_forms_2() {
    difference() {
        union() {
            cube([k*(width+gap)+width,1,s]);
            for ( i = [0 : k] )
            {
                translate([i*(width+gap),0,0]) cube([width,h,s]);
            }
        }
        for ( i = [0 : k] )
        {
            translate([i*(width+gap)-gap/2,1,0]) rotate([-90,0,0]) {
                cylinder(r=gap,h);
                translate([0,-s,0]) cylinder(r=gap,h);
            }
        }
    }
}