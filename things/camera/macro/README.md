# Modular LEDs macro "ring"

The goal of this project is to build a modular "ring" for macro lens where one can put LEDs modules of different colors and orient them in various directions.
Furthermore, the LEDs can be mounted on gorillapod-like arms to provide side and/or back lighting to the scene.

## Parts

* `led_holder.scad`
  This file contains the module that holds the LEDs, with a back cover to protect the wires, and a snoot.
  The models has support to ease the printing, they can easily be removed after print with an hobby knife.
* `nikkor_mirco_60mm_lens_hood_adapter.scad`
  The model for a ring that hook to a nikkor micro 60mm lens in the place of the lens hood
* `on_lens.scad`
  The part that goes on the lens where the led modules can be mounted.
  The models has support to ease the printing, they can easily be removed after print with an hobby knife.
* `hotshoe.scad`
  A box for the electronic.
  It mounts in the camera hotshoe.
  The box is designed to receive a 4xAAA battery module found in `../../robot/battery.scad`.
* `pin_enclosure.scad`
  An enclosure to hold together two 10 pins 0.100'' (2.54 mm) female headers.

It is possible to add ball-sockets joint between the ring and the LEDs modules.
The model for the joint is `external/ball_and_socket_chain_links_with_hole_through/BallSocket.stl`.

## Electronic

* 1 potentiometer and 2 resistors to create a voltage divider (typically 10K Ω or the potentiometer and 8k Ω for the resistors)
* 1 mosfet
* 1 on-off switch
* 1 small prototyping board to hold the elements together
* a set of resistors for the LEDs (more details below)

The idea is to build a voltage divider using a potentiometer and 2 resistors.
Then connect the output of the voltage divider to the gate of the mosfet.
Varying the voltage will let more of less current flow through the mosfet and change the brightness of the LEDs.

Finally, the LEDS needs to be protected using resistors.
In my tests, I'm embedding a resistor in the wire that goes to each LEDS module.
The typical value of such resistor is 15 Ω, assuming using 4x NiMH batteries (4.8V), 5 LEDs with a current of 20 ma per LED and a voltage drop of 3.3V.

## Acknowledgement
[ball and socket chain links with hole through](http://www.thingiverse.com/thing:5578) from StefanHH under CC-BY license
