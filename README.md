# GODOT_Action_RPG
Action RPG made with Godot Engine following [HeartBeast tutorial](https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a), all artwork, music and sond effects bellong to HeartBeast himself.

This project has been lots of fun, HeartBeast’s tutorial is very well made and gave me a really good initial understanding of the tools of the Godot engine. I had made some experiments with other game making tools like Löve, Pygame and Unity, compared to Löve and Pygame, Godot has a lot more features to use, making the development quite a bit quicker and streamlined, compared to Unity, Godot seem to have a more intuitive design and a dedicated 2d engine, making it quite easy to get started, I also had some trouble with Unity being a bit to heavy and costly for my machine, it took long to open projects and it used to crash or get stuck quite often, witch was quite frustrating.

Godot on the other hand seems to be the perfect engine for my work style, computer limitations and for the types of games I'm interested in making, I'm excited to make future projects with the engine.

#  Changes and Additions:

I made some changes to the original project in the tutorial and added a few things of my own. I plan to add more features as time goes on.

## Enemy Health:
> I added an enemy health node to draw a heath bar above the enemies, the health bar changes color based on how much health the enemy has left compared to its total health, changing from full green to full red.

## Enemy arrival behaviour:
> In the original tutorial enemies during the wander state enemies would pick a location and move straight to it and when it got close enough to the target position it would just stop accelerating. I did not like this solution because it seemed a bit clunky and inelegant and sometimes the enemy would overshoot and pass the target position, needing to accelerate back to it, resulting in a very unnatural looking zigzag motion. so I read and followed the article [Understanding Steering Behaviors: Flee and Arrival](https://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-flee-and-arrival--gamedev-1303) by [Fernando Bevilacqua](https://tutsplus.com/authors/fernando-bevilacqua?_ga=2.101637000.887685130.1633697238-1486835485.1633264038). This resulted in a smoother movement during the wander state.

## Enemy Aggro:
> Enemies now have two player detection areas, a smaller one is used to trigger the chase behaviour, while a bigger one is used during the chase behaviour, this way enemies will have a smaller detection area, but when they detect the player they will be able to chase him for longer.

## Shaders changes:
> The blink animation is twice as fast and the Shader has 75% of the original alpha instead of 100%, making it a bit less visually jarring.

## Player Attack and Roll:
> Player now has two timers to control attack and roll cooldowns, the attack animation now is twice as fast as originally and the roll state now has a few frames of invulnerability.

# Plans for the future:
> I still want to attempt to add a few other features, like z axis for the wall tile set so that the player can walk on top of it and pathfinding for the enemies so that they don't get easily stuck on walls and other collision objects.
>
> I also want to add one other enemy type of my own.
>
> There is also a small bug that I haven't been able to figure out yet, very rarely when doing a roll the AnimationPlayer seems to not trigger the invulnerability nor the sound effect, this only happens sometimes but enough to need fixing.
>
> After that, I think I’ll start working on a project of my own, a more complete short game with levels and everything.
