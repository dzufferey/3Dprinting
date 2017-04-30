# Vise for the FR4 CNC Mill

## Models

* in the [vise.scad](vise.scad) file
    - [`fixed_jaw`](fixed_jaw.stl)
    - [`movable_jaw`](movable_jaw.stl)
    - [`back_guide`](back_guide.stl)
    - `parallel` (optional, come in different heights)
* for the [M6 knob](M6_knob.stl) I used http://www.thingiverse.com/thing:664192 to generate the model.

The file [`all_parts.stl`](all_parts.stl) contains all the parts

## Bill of materials

* 2x 6mm ∅ steel rods (length ~123mm)
* 4x 3mm ∅ dowel pins of length 15mm (3.2mm pins should provide a better fit but I'm in a metric country...)
* 1x M6 threaded rod (length ~123mm)
* 5x M6 nuts
* 1x M6 washer
* 2x M4 screws
* 2x M4 washers

## Instructions

1. Preparing the printed parts:
    * Print a copy of `fixed_jaw`, `movable_jaw`, and `back_guide`. The models print well without support.
    * Clean the part and make sure the holes have the right size (ream them using 6/4/3mm drill bits)
2. Preparing the non-printed parts
    * Take 2 M6 nuts and grind two opposite corners to make the nuts _squarish_. These nuts will go into the movable jaw and making them square keeps them from rotating.
    * Take 2 M6 nuts and grind them until the exterior is round and has a diameter of 9mm. These nuts will go into the fixed jaw and hold the threaded rod. These nuts will keep the threaded rod from sliding in the fixed jaw.
3. Assembly
    * Put the dowel pins in the holes of the fixed jaw and back guide and secure them with glue.
    * Slide the two 6mm rods in the fixed jaw and secure them with glue.
    * At one end of the threaded rod, put an rounded nut, a washer, a nut, and the knob over the nut. Secure everything with threadlocker.
    * Slide the threaded rod in the fixed jaw, put the rounded nut, and secure with threadlocker.
    * Insert the square nuts in the movable jaw and slide/screw the movable jaw on the rods.
    * Slide the guides on the rods, check the fit on the FR4 bed, and glue if needed.
