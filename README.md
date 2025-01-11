AdvancedParticleSystem

Check out wiki page! https://github.com/Limekys/AdvancedParticleSystem/wiki/Main

# Advanced Particle System wiki

## Compare
![Simple particle code example](https://github.com/user-attachments/assets/d06d8bba-82be-47f7-9167-0b78c4bf5d27)


## Simple example
All functions looks like standart gms particle system. We are create particle system, emitter and particle type.
![Simple example init](https://github.com/user-attachments/assets/2d13835b-b327-43b5-9d95-3e7124fb8cc5)

For our particle system to work, we need to add a step function to the step event. And of course to create our particles need to run burst function almost like the standard system, all functions look identical, except that at the beginning ascribed to "advanced_".

![Step and Burst function](https://github.com/user-attachments/assets/8ba6af9e-546e-46ea-bf9f-4bda6689ff86)

But in order for our particles to be visible, they need to be drawn on the screen, for this you just need to run the draw function in the "draw" event.

![Draw function](https://github.com/user-attachments/assets/84f9643d-bc13-42cf-8aab-bf5638979d9d)

Done!

![Simple particle example](https://i.ibb.co/QQD1JPN/v-V1-G786meb-1.gif)

***

## Why advanced?

### Point gravity

Because, as first, we have **part_point_gravity** function!

![Point gravity function](https://i.ibb.co/qg1Qcc5/image.png)

![Point gravity particles](https://i.ibb.co/TtW5DrV/n-XPf-Hhjg-SD.gif)

### Delta time

And, as second, we have delta time! Which give us a huge control with particles speed! At low and high FPS we have the same speed of particles.
To turn on delta time just put **enabledelta()** function to create event after creating particle system.
With delta enabled you should remember to setup right speed, gravity amount and life values! For example without deltatime we should setup life 60 for 1 second life for this particle with room speed 60 and with deltatime we should setup life to 1 for 1 second life regardless room speed. For burst particles with **advanced_part_emitter_burst** function without deltatime 1 for 60 particles each second with room speed 60 and with deltatime 60 to burst 60 particle within a second!

![Deltatime fucntion](https://i.ibb.co/JyvKTsX/image.png)

Example with 15 FPS: left particles is standart GMS2 particle system, middle is advanced particle system without deltatime and right with deltatime.

![Deltatime example](https://i.ibb.co/68Bs97D/z-CI07t-WEi9-1.gif)

### Collisions

For collisions we have _**part_step_function**_. With which we can add what you want including collisions!

For example collisions with objects:

![Code](https://i.ibb.co/cTbXXMz/Game-Maker-Studio-dl-Akxnr-OAw.png)

And result is:

![Collision with objects](https://i.ibb.co/Cwnc1yD/c9g3ajc-BSe.gif)

Distance to mouse:

![Code](https://i.ibb.co/1K97pFB/Game-Maker-Studio-qwyd-Z07-ZQM.png)
![Result](https://i.ibb.co/PzNQCJT/rf4-Ff-DALt8.gif)

Or just a rain:

![Code](https://i.ibb.co/wQrLGZG/Game-Maker-BYy7-A8dt-Dm.png)
![Rain drops](https://github.com/user-attachments/assets/7d82bd21-85cf-400a-b98c-e9ab50f0cf08)


***

## Fireworks!
Code

![Firework code](https://i.ibb.co/6XyWDCc/Game-Maker-Studio-Skz-Vef-EPds.png)

One part burst and thats all

![burst functions](https://i.ibb.co/8gFYW4b/Game-Maker-Studio-WNMJU8-YYQW.png)

And how it looks!

![Firework](https://i.ibb.co/H4hzVxh/1zx-QERzp-Tx.gif)

***

## Conclusion

_**We have a very interesting particle system with functions that are not in the standard particle system, but not the most productive! I try to do my best to optimize it. If you like, you can help develop this project!**_
