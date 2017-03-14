
climb = true; //climb or conventional
cutter_radius = 1.6;
cutter_length = 12;
cutter_offset = 22; //length between threaded adapter and start of cutting flute
cutting_depth = 1.6; // <= 2 * cutter_radius
length = 100;
width = 40; // + 15 for dremel adapter
corner_chamfer = 2;

//////////////

module planer() {
    h = 12 + cutter_offset;
    o1 = cutter_radius - (climb ? cutting_depth : 0);
    o2 = cutter_radius - (climb ? 0 : cutting_depth);
    cc = 18 / sqrt(2) + corner_chamfer;
    difference() {
        union() {
            difference(){
                translate([-length/2,-15,0])cube([length, width + 15,h]);
                cylinder(r = 8, h = h+1);
                // imperial 3/4-12 internal thread generated using:
                //   http://dkprojects.net/openscad-threads/threads.scad
                import("dremel_accessory_internal.stl");
            }
            translate([9,-15,h]) cube([length/2 - 9, 15 + o1, cutter_length]);
            translate([-length/2,-15,h]) cube([length/2 - 9, 15 + o2, cutter_length]);
        }
        translate([15,0,0]) cube([length/2 - 20,width, cutter_offset]);
        translate([-length/2+5,0,0]) cube([length/2 - 20,width, cutter_offset]);
        translate([-10,15,0]) cube([20, width, cutter_offset]);
        translate([0,cutter_radius,0]) rotate([0,0,45]) translate([-cc/2,-cc/2,h]) cube([cc,cc,cutter_length]);
        translate([length/2,o1,0]) rotate([0,0,45]) translate([-corner_chamfer/2,-corner_chamfer/2,h]) cube([corner_chamfer,corner_chamfer,cutter_length]);
        translate([-length/2,o2,0]) rotate([0,0,45]) translate([-corner_chamfer/2,-corner_chamfer/2,h]) cube([corner_chamfer,corner_chamfer,cutter_length]);
    }
}

planer();