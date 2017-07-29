# Lantern Engine

A 2D game engine in Forth built on [Bubble.](https://github.com/RogerLevy/bubble)

Lantern is designed to be simple to use and modular.  With its modular design, it should be easy to swap out implementations and add enhancements and any needed capabilities or platform support.  

Lantern is powered by the Allegro 5 library, leveraging hardware graphics acceleration, allowing you to animate thousands of sprites.

## Features

- Currently runs on SwiftForth / Windows 7 and up
- Designed for 2D games
- Integrated interactive REPL (part of Bubble)
- Idiom-based object system (like OOP but simpler)
- Multitasking, enabling more complex game objects scripts with less effort
- Automatic static asset loading - no need to declare assets in source
- Basic sound support with samples and background music streaming (powered by FMOD or Allegro)
- Fast depth sorting
- Basic TMX ([Tiled](http://www.mapeditor.org/)) file support (just objects and rectangles)

## Planned for 1.0
- Tilemap support with collision detection
- Full TMX ([Tiled](http://www.mapeditor.org/)) file support
- Intersection tests powered by [tinyc2](https://github.com/RandyGaul/tinyheaders)

## Shelved features (probably in 2018 or 2019)
- Fast ABAB / "Early Phase" collision detection
- [Spriter](https://brashmonkey.com/) support
- Mappable joystick support
- Physics
- Shader support
- GUI system for tool-building based on new "Workspaces" paradigm
- Object parenting / multiple object list management
- Adaptive display resolution

