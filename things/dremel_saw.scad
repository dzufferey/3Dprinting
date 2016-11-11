$fn=30;

module dremel_adapter() {
    //from http://www.thingiverse.com/thing:1232949 (CC-BY-SA)
    import("Dremel_Gewindeadapter.STL");
}

h = 5;
l = 70;
w = 50;

module dremel_mount() {
    union() {
        translate([-12.5,0,h-2.5]) dremel_adapter();
        difference() {
            translate([-w/2,0,h]) cube([w, 12, 7]);
            translate([0,0,h + 9]) rotate([-90,0,0]) cylinder(r = 10, h = 12);
            translate([5-w/2, 6, 4]) cylinder(r=1, h = 10);
            translate([w/2-5, 6, 4]) cylinder(r=1, h = 10);
        }
    }
}

module dremel_saw() {
    difference() {
        translate([-w/2,0,0]) cube([w, l, h]);
        translate([0,50,h + 9]) rotate([90,0,0]) cylinder(r = 20, h = 2);
        for(i = [-3 : 1 : 3]) {
            translate([5*i,20,h+2]) rotate([0,45,00]) translate([-h/2,0,-h/2]) cube([h, l, h]);
        }
        translate([-12.5,0,h-2.6]) dremel_adapter();
        translate([5-w/2, 6, 0]) cylinder(r=1, h = 10);
        translate([w/2-5, 6, 0]) cylinder(r=1, h = 10);
    }
}

module length_stop() {
    tolerance = 1;
    difference () {
        cube([w + 4, 6, h+6+2]);
        translate([2-tolerance/2,0, 2-tolerance/2]) cube([w + tolerance, 6, h + tolerance]);
        //M3 screws
        translate([7, 3, 4]) cylinder(r=1.6, h = 10);
        translate([w-3, 3, 4]) cylinder(r=1.6, h = 10);
        //M3 nuts
        translate([7, 3, 8.25]) cube([5.6, 6, 2.5], true);
        translate([w-3, 3, 8.25]) cube([5.6, 6, 2.5], true);
        //make space for the dremel shaft
        translate([w/2, 0, 21]) rotate([-90,0,0]) cylinder(r=12, h = 10);
    }
}

dremel_saw();
translate([0,l+30,0]) rotate([90,0,0]) dremel_mount();
translate([-w/2,-10,0]) rotate([90,0,0]) length_stop();