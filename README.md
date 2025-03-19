# *Toasty*
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Falejandro-alzate%2Ftoasty&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visits&edge_flat=false)](https://hits.seeyoufarm.com)

Just a simple toast notification "library" for LÖVE.

## To do:
- Soft fade in/out
- Extend api

## Features
- Easy to use.
- Lightweight.
- Contains intellisense comments.

## Flaws
- Probably way too simple.
- The box might break with funny characters.

## Getting Started
1. 📡 Get a copy of srt.lua from the [Official Repository](https://github.com/alejandro-alzate/toasty).
2. 💾 Copy `toasty.lua` where you like to use it, or just on the root directory of the project.
3. 🔧 Add it to your project like this:
	```lua
	local toasty = require("path/to/toasty")
	```
4. ⏳ Allow toasty to track time.
	```lua
	function love.update(dt)
		toasty.update(dt)
	end
	```
5. 🎨 Allow toasty to draw on the screen.
	```lua
	function love.draw()
		toasty.draw()
	end
	```
4. 💬 Start pushing notifications.
	```lua
	local message = "Mmm... toasty toast!"
	local duration = 2
	local prioritize = true
	toasty.notify(message, duration, prioritize)
	```
5. 💎 Profit.

## Short API description:
- `toasty.update(dt)`: Updates the internal state of toasty.
- `toasty.notify(message, duration, prioritize)`: Pushes a notification with the given message, duration, and priority.
- `toasty.draw()`: Draws all notifications on the screen one by one.
- `toasty.clear()`: Clears all notifications.
- `toasty.getDefaultText()`: Returns the default text used for notifications.
- `toasty.setDefaultText(text)`: Sets the default text used for notifications.
- `toasty.getColorName(name)`: Returns the default color used for notifications (Generic function).
- `toasty.setColorName(color, name)`: Sets the default color used for notifications (Generic function).
- `toasty.getDefaultBackgroundColor()`: Returns the default background color used for notifications.
- `toasty.setDefaultBackgroundColor(color)`: Sets the default background color used for notifications.
- `toasty.getDefaultOutlineColor()`: Returns the default outline color used for notifications.
- `toasty.setDefaultOutlineColor(color)`: Sets the default outline color used for notifications.
- `toasty.getDefaultForeground()`: Returns the default foreground color used for notifications.
- `toasty.setDefaultForeground(color)`: Sets the default foreground color used for notifications.
- `toasty.getDefaultOutlineWidth()`: Returns the default outline width used for notifications.
- `toasty.setDefaultOutlineWidth(width)`: Sets the default outline width used for notifications.
- `toasty.getDefaultFont()`: Returns the default font used for notifications.
- `toasty.setDefaultFont(font)`: Sets the default font used for notifications.
