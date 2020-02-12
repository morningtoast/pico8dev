# Pico-8 Development Tools
This repo includes snippets, demo carts and libraries to help make Pico-8 games.

Some of the code is my own, a lot of it is taken from the Pico-8 Community and
tweaked a bit my me so I could understand it...or just make a nice wrapper for it.

All the code here is intended to be a *starting point* for your own development.
Change, tweak and reuse code as you need.

* [Follow @morningtoast on Twitter](http://twitter.com/morningtoast)
* [Find me on the Pico-8 BBS](http://www.lexaloffle.com/pico-8.php)
* [Play some of my Pico-8 games](http://morningtoast.itch.io/)

---

## Contents
* `boilerplate.p8` - Ready to go cart with basic structure and helpers
* `blankcart.p8` - Barebones for cart
* `mousetouch.p8` - Functions for mouse/touch detection
* `explosion_lib.p8` - Explosion particle library
* `fadetext.p8` - Fading text screens. For game startup.
* `glitchfx.p8` - Scanline glitch effect


## My approach
I approach most of my games with the same process and structure, as you'll find
in the boilerplate. I'll do my best to explain myself a bit.

### Defining a scene
I think about each major type of content as a scene. So the title screen
is a scene. The tutorial is a scene. The game over is a scene. And the main
gameplay is a scene. Every time the game content and/or interaction changes, that's
when I define a new scene.

Each scene has its own init, update and draw functions.

Inside each of those functions exists calls to the specific item/object functions,
like moving the player, enemy movement, backgrounds, UI...whatever.

You'll see that the boilerplate comes with 3 predefined scenes: title, game over,
and gameplay. And specifically, the gameplay scene calls the player functions.

### Keep the main loop lean
The main system loops - _update() and _draw() - I try to keep as lean
as possible. I define an global cart update and cart draw function that is
called within the system loop all the time. I then assign these cart functions
to appropriate scene update/draw functions. Then when I need to switch scenes, I just 
reassign and go from there.

This lets me not only chain together a bunch of scenes to make a complete game,
it lets me run any given scene individually at any time during development,
which makes for much easier debugging and building.


### Getting better at saving tokens
Token count is the only real risk in Pico-8 as far as I'm concerned. However, for
most games, that count will never be reached. I've only had one game reach the
limit and that was because of my quasi-poor coding and not because my game was
big or anything fancy. But out of that, I learned a lot.

I tried to bring my existing programming knowledge to Pico-8 and while it helped me
think of how to solve a problem, it didn't help me in code. Bringing forward
modern coding practices into Pico-8 will kill your token count. 

Check out this article for token-saving techniques. Good stuff.
[https://github.com/seleb/PICO-8-Token-Optimizations](https://github.com/seleb/PICO-8-Token-Optimizations)

I've found it saves more to be *feel* less efficient with your code. Once you start
adding complexity while trying to be smart about things, that's when you'll start
to burn tokens. Don't bring modern worries to this "old school" language.

## Code quality rarely matters
I see a lot of people on the Pico-8 forum talking about how bad their code is
and saying it could be better...well, of course it could. It can always be
better, but here's the thing - the quality of your code doesn't matter.

Remember, you're making a game for people to play. You're not making something
to be able to tout your coding skill. The person playing your game doesn't care
about your code. As long as they can play your game, they're happy.

Which should go to say code quality *does* matter if starts to impact
how your players experience the game. Otherwise, it doesn't matter one lick.

As long as you get your game working and doing what you want, your code is
great. Don't worry about it. You'll get judged on **game quality** before you get
judged on code quality. Don't lose sleep over well-formed code or too many variables
or whatever. If your game works, it works...move along.

[This article](http://www.gameinformer.com/b/news/archive/2014/03/20/robotron-2084-creator-eugene-jarvis-breaks-down-the-arcade-classic.aspx) talks about Eugene Jarvis's game development and there's a great quote that I try
to remember when making Pico-8 games.

> ...creating classic arcade games meant that they had to focus all on gameplay, challenge, difficulty ramping, and more, since relying on realism was out of the question

Rolled inside that list is quality of code. Do battle with your game ideas and
player experience, don't do battle with your code.
