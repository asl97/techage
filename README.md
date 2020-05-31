# Tech Age [techage] (Minetest 5.0+)

Tech Age, a mod to go through 4 tech ages in search of wealth and power.

**Tech Age (techage) is the successor to TechPack V2, at first glance similar and yet completely different!**

![screenshot](https://github.com/joe7575/techage/blob/master/screenshot.png)



Important facts:
- techage is not backwards compatible and cannot be installed on a server together with TechPack
- techage is significantly more extensive, since additional mods are integrated
- techage represents 4 technological ages:
  - Iron Age (TA1) - simple tools like coal pile, coal burner, gravel sieve, hammer for getting ores and making goods
  - Steam Age (TA2) - Simple machines that are powered by steam engines and drive axles
  - Oil Age (TA3) - More modern machines that are powered by electricity.  
   The electricity is generated by coal & oil power plants. The oil must be explored, extracted and transported.
  - Future Age (TA4) - Electricity from renewable energy sources such as sun and wind.  
   Environmentally friendly electricity storage, intelligent machines and means of transport of the future
- Since the levels build on each other, all ages have to be run through one after the other

In contrast to TechPack, the resources are more limited and it is much more difficult to pass all levels.
(no endless ore generation by means of cobble generators)

[Manuals](https://github.com/joe7575/techage/wiki)


### License
Copyright (C) 2019-2020 Joachim Stolberg  
Code: Licensed under the GNU GPL version 3 or later. See LICENSE.txt  
Textures: CC BY-SA 3.0


### Dependencies  
Required: default, doors, bucket, stairs, screwdriver, basic_materials, tubelib2, minecart, lcdlib, safer_lua  
Recommended: signs_bot, hyperloop, compost, techpack_stairway, autobahn  
Optional: unified_inventory, wielded_light, unifieddyes, lua-mashal, lsqlite3


The mods `default`, `doors`, `bucket`, `stairs`, and `screwdriver` are part of Minetest Game.

`basic_materials` will be found here: https://content.minetest.net/

The following mods in the newest version have to be downloaded directly from GitHub:
* [tubelib2](https://github.com/joe7575/tubelib2)
* [minecart](https://github.com/joe7575/minecart)
* [lcdlib](https://github.com/joe7575/lcdlib)
* [safer_lua](https://github.com/joe7575/safer_lua)

It is highly recommended that you install the following mods, too:

* [signs_bot](https://github.com/joe7575/signs_bot): For many automation tasks in TA3/TA4 like farming, mining, and item transportation
* [hyperloop](https://github.com/joe7575/Minetest-Hyperloop): Used as passenger transportation system in TA4
* [compost](https://github.com/joe7575/compost): The garden soil is needed for the TA4 LED Grow Light based flower bed
* [techpack_stairway](https://github.com/joe7575/techpack_stairway): Ladders, stairways, and bridges for your machines
* [autobahn](https://github.com/joe7575/autobahn): Street blocks and slopes with stripes for faster traveling

For large servers with many player, the following packages are recommended:

* `lua-mashal` for faster serialization/deserialization of data
* `lsqlite3` for storing node and network data

Both packages are installed via [luarocks](https://luarocks.org/):

    luarocks install lua-marshal
    luarocks install lsqlite3

To enable this `unsafe` packages, add 'techage' to the list of trusted mods in minetest.conf:

    secure.trusted_mods = techage

For the installation of 'luarocks' (if not already available), see [luarocks](https://luarocks.org/)

If you enable 'lsqlite3' you also have to enable 'lua-marshal'. Available worlds will be converted
to 'lsqlite3' and 'lua-marshal', but there is no way back, so:

** Never disable 'lsqlite3' and 'lua-marshal' for a world, which it was already used!**


### History  
- 2019-06-16  V0.01  * First upload  
- 2019-09-28  V0.02  * TA3 finished  
- 2020-02-29  V0.04  * TA4 ICTA controller added  
- 2020-03-14  V0.05  * TA4 Lua controller added  
- 2020-04-24  V0.06  * TA4 injector added  
- 2020-04-26  V0.07  * English translation added  
- 2020-05-22  V0.08  * Support for 'lua-marshal' and 'lsqlite3' added  
- 2020-05-31  V0.09  * TA4 tubes upgraded, manuals updated  



