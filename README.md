[![Build Status](https://travis-ci.org/borodust/notalone-again.svg)](https://travis-ci.org/borodust/notalone-again) [![Build status](https://ci.appveyor.com/api/projects/status/v4e7h5m0ibdf6k4n?svg=true)](https://ci.appveyor.com/project/borodust/notalone-again)

# NOTALONE: AGAIN

You wake up nowhere in a galactic. Unknown lifeforms surround you, but your ol' pal "SHIPWRECK" is with you.

SHOOT 'EM ALL!

Lisp Game Jam 2019 entry

## Controls
| Action  | Control |
|---------|---------|
| Rotate ship  | D and F |
| Engage thrusters | J |
| Launch torpedoes | Spacebar |

## Installation and running

Binaries available at [releases](https://github.com/borodust/notalone-again/releases) page.

You also can install it via `quicklisp`:

```lisp
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.testing.txt")

(ql:quickload :notalone-again)

(gamekit:start 'notalone-again::notalone-again)
```

## Requirements

* OpenGL 2.1+
* 64-bit (x86_64) Windows, GNU/Linux or macOS
* x86_64 SBCL or CCL


## Credits

* Sound Effects
  * [The Essential Retro Video Game Sound Effects Collection](https://opengameart.org/content/512-sound-effects-8-bit-style), CC0
* Music
  * [Unknown Energy by Dox](https://www.free-stock-music.com/dox-unknown-energy.html), CC BY-ND 3.0
  * [The Anomaly by Tristan Lohengrin](https://www.free-stock-music.com/tristan-lohengrin-the-anomaly.html), CC BY 3.0
* Fonts
  * [Avara](https://fontlibrary.org/en/font/avara), OFL
  * [Space Meatball](https://fontlibrary.org/en/font/space-meatball), Public Domain
