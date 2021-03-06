# History

## 4.0.0

 * use the timestamp parameter of requestAnimationFrame instead of new Date()
   - results in smoother and faster gamess
 * depend on pend instead of deprecated batch2
   - chem.resources.on('progress', handler) - handler takes complete, total
     instead of an object.

## 3.2.0

 * ability to build with an asset prefix to make deployment easier

## 3.1.0

 * sound: `play` always returns an audio object. restarts old sounds
   if necessary.
 * capture mouse up events even if they go outside the canvas.
 * key up event handler on window instead of canvas.

## 3.0.0

 * Sprite constructor takes an animation instead of a string.
 * expose Animation. You can construct Animations at runtime now and assign
   them to sprites.
 * remove `chem.resources.getImage`. Use
   `chem.resources.animations[name].getImage` instead.
 * remove `sprite.setAnimationName`. Use `sprite.setAnimation` instead.
 * remove `sprite.animationName`. Use `sprite.animation` instead.

## 2.1.0

 * add Batch::clear()

## 2.0.1

 * Sprite: fix memory leak
 * Batch: allow empty zOrder layers

## 2.0.0

 * remove label.id and sprite.id
 * Batch is faster
 * chem.button was missing Key5 - Key9. Fixed.
 * sound.maxPoolSize now defaults to 10 instead of 1000

## 1.0.2

 * update vec2d dependency. adds `reflect` and `reflectAboutLine` methods

## 1.0.1

 * update vec2d dependency. fixes `rotate` method.

## 1.0.0

 * fix compilation error regarding window being defined
 * start using semver correctly

## 0.6.0

 * ability to get/set playbackRate on Sound
 * ability to stop() a Sound
 * Sound emits "progress" and "ready" event
 * remove chem.onReady in favor of chem.resources.on('ready')
 * resoures is a normal EventEmitter just like everything else
 * resources has a "progress" event
 * resources.bootstrap() called by auto generated code instead of chem library
 * add automatic text and image resource loading via public/text/ and public/img/
   available on resources.images and resources.text
 * add engine.showLoadProgressBar()

## 0.5.0

 * add chem.Label e.g. "text sprite"
 * `batch.sprites` renamed to `batch.layers`
 * `batch.layers` contains both `Sprite` and `Label`
 * `engine.draw(batch)` replaced with `batch.draw(context)`
 * `engine.drawFps()` replaced with `engine.createFpsLabel()`
 * add `sprite.draw(context)`

## 0.4.5

 * sound: ability to set preload and volume properties
 * focus canvas on mouse down - fixes focus problem

## 0.4.4

 * add Sprite::hitTest(vec2d)
 * fix not respecting `loop` property in chemfile

## 0.4.3

 * proper bubbling of events for mouse events. (fixes hiding the cursor
   when mouse down if you have `canvas.style.cursor = 'none'`)

## 0.4.2

 * support `buttonJustReleased`
 * ability to add button capture exceptions

## 0.4.1

 * `chem.getImage` moved to `chem.resources.getImage`
 * `chem.animations` moved to `chem.resources.animations`
 * `chem.spritesheet` moved to `chem.resources.spritesheet`
 * fix double bootstrap bug

## 0.4.0

 * use browserify for packaging instead of jspackage
 * `snake_case` api changed to `camelCase`
 * `chem.Button` changed to `chem.button`
 * `chem.Vec2d` changed to `chem.vec2d`
 * `"animation_end"` changed to `"animationend"`

## 0.3.0

 * rewrite chem to be faster and less error prone
 * support node.js v0.10

## 0.2.7

 * update jspackage - fixes dependencies rendered out of order sometimes

## 0.2.6

 * add sprite.alpha property

## 0.2.5

 * add `div` and `divBy` to `Vec2d`

## 0.2.4

 * correctly expose animations and spritesheet

## 0.2.3

(recalled)

## 0.2.2

 * expose animations, spritesheet, and getImage
 * throw error objects, not strings

## 0.2.1

 * add top, bottom, left, right anchor shortcuts
 * Vec2d: add ceil and ceiled
 * drawFps: text align left
