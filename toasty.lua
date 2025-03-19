---@class Color: table
---@field r number The red component of the color
---@field g number The green component of the color
---@field b number The blue component of the color
---@field a? number The alpha component of the color

---@class Toast
---@field text string The text to display on the toast
---@field duration number The duration of the toast in seconds
---@field clock number The current time elapsed on the toast
---@field pump fun(self: Toast, dt: number)


local toasty = {}
local toastQueue = {}

---@type Toast
local defaultToast = {
	text = "Mmmm... Toast!",
	duration = 3,
	clock = 0,
	pump = function() end
}

local config = {
	outlineWidth = 2,
	font = love.graphics.getFont(),
	backgroundColor = { 0, 0, 0, 0.7 },
	outlineColor = { 1, 1, 1, 1 },
	foregroundColor = { 1, 1, 1, 1 }
}

-- Helper Functions --

---Checks if a given value is a valid color table
---@param color table? The object to check
---@return boolean valid Whether it's safe to use as a color value
---@return string|nil msg? When a color is invalid this says why, nil otherwise
local function checkColor(color)
	local valid = false
	---@type string?
	local msg
	if type(color) == "table" then
		if #color == 3 or #color == 4 then
			for i, v in ipairs(color) do
				if type(v) ~= "number" then
					valid = false
					msg = "Item #" .. i .. " is not a number it is a " .. type
					return valid, msg
				end
			end
			valid = true
			return valid, nil
		else
			valid = false
			msg = "Incorrect table length. Expected 3 or 4 got" .. #color
			return valid, msg
		end
	end

	return valid, nil
end

-- Internal Functions --

---Updates the internal state of a toast
---@param self Toast
---@param dt number
function toasty.pump(self, dt)
	local toastQueueIndex = -1

	for i, v in ipairs(toastQueue) do
		if v == self then
			toastQueueIndex = i
			break
		end
	end

	if toastQueueIndex == 1 then
		self.clock = math.min(self.duration - dt, self.duration)
	end

	if self.clock == self.duration then
		table.remove(toastQueue, toastQueueIndex)
	end

	if toastQueueIndex == -1 then
		error("This toast is not on the toaster!")
	end
end

-- Toasty related API --

---Clears the toaster of any toast.
function toasty.clear()
	for i, v in ipairs(toastQueue) do
		table.remove(toastQueue, i)
	end
end

---Adds a new Toast to the toaster queue.
---@param text string The text to display on the toast
---@param duration number The duration of the toast in seconds
---@param prioritize boolean Whether to prioritize this toast over others
function toasty.notify(text, duration, prioritize)
	local toast = {
		text = text or defaultToast.text,
		duration = duration or defaultToast.duration,
		clock = 0,
		pump = toasty.pump
	}
	table.insert(toastQueue, prioritize and 1 or #toastQueue + 1, toast)
end

-- Setters/Getters --

---Returns the default text shown when no user text is provided.
---@return string The default text
function toasty.getDefaultText() return defaultToast.text end

---Sets the default text shown when no user text is provided
---The default is `Mmmm... Toast!`
---@param text string The new default text
function toasty.setDefaultText(text)
	if type(text) ~= "string" then
		error("Expected string, got " .. type(text))
	end
	defaultToast.text = text
end

---Returns the given color name (Generic).
---@param varname string The name of the color to get.
---@return Color? The default background color name.
function toasty.getColorName(varname)
	---@diagnostic disable-next-line: param-type-mismatch
	local valid, msg = checkColor(config[varname])
	if not valid then
		error(msg)
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return valid and config[varname] or nil
end

---Sets the color of a given name (Generic).
---@param varname string The name of the color to set.
---@param color Color? The new default background color.
function toasty.setColor(color, varname)
	local valid, msg = checkColor(color)

	if not valid then
		error(msg)
	end

	config[varname] = color
end

---Returns the default background color.
---@return Color? color The default background color.
function toasty.getDefaultBackgroundColor() return toasty.getColorName("backgroundColor") end

---Sets the default background color.
---@param color Color? The new default background color.
---@return nil
function toasty.setDefaultBackgroundColor(color)
	return toasty.setColor(color, "backgroundColor")
end

---Returns the default foreground color.
---@return Color? color The default foreground color.
function toasty.getDefaultForegroundColor() return toasty.getColorName("foregroundColor") end

---Sets the default foreground color.
---@param color Color? The new default foreground color.
---@return nil
function toasty.setDefaultForegroundColor(color)
	return toasty.setColor(color, "foregroundColor")
end

---Returns the default outline color.
---@return Color? color The default outline color.
function toasty.getDefaultOutlineColor() return toasty.getColorName("outlineColor") end

---Sets the default outline color.
---@param color Color? The new default outline color.
---@return nil
function toasty.setDefaultOutlineColor(color)
	return toasty.setColor(color, "outlineColor")
end

---Returns the default outline width.
---@return number? width The default outline width.
function toasty.getDefaultOutlineWidth() return config.outlineWidth end

---Sets the default outline width.
---@param width number? The new default outline width.
---@return nil
function toasty.setDefaultOutlineWidth(width)
	if type(width) == "number" then
		if width < 0 then
			error("Outline width cannot be negative")
		end
		config.outlineWidth = width
	else
		error("Outline width is not a number, got: " .. type(width))
	end
end

-- LÖVE-Related Functions --

---Updates the internal state of all toasts on the toaster
---@param dt number
function toasty.update(dt)
	for i, v in ipairs(toastQueue) do
		v:pump(dt)
	end
end

---Draws the toast to the screen if there's any active toast
function toasty.draw()
	---@type Toast?
	local firstToast = toastQueue[1]
	if firstToast then
		-- Save the user graphics settings
		love.graphics.push("all")

		---@type integer
		local windowWidth = love.graphics.getWidth()
		---@type integer
		local windowHeight = love.graphics.getHeight()

		---@type string
		local text = firstToast.text
		---@type integer
		local textPadding = 20

		---@type number
		local size = 1

		---@type integer
		local textWidth = config.font:getWidth(text)
		---@type integer
		local textHeight = config.font:getHeight()

		---@type number
		local x = windowWidth / 2 - (textWidth * size / 2)
		---@type number
		local y = windowHeight - textHeight - textPadding

		---@type integer
		local limit = textWidth
		---@type "left"|"right"|"center"
		local align = "left"
		---@type number
		local recX = (x - textPadding / 2)
		---@type number
		local recY = (y - textPadding / 2)
		---@type number
		local recWidth = (textWidth * size) + textPadding
		---@type number
		local recHeight = (textHeight + textPadding)
		---@type number
		local radiusX = 20
		---@type number
		local radiusY = 20

		-- Background Box
		love.graphics.setColor(config.backgroundColor)
		love.graphics.rectangle("fill", recX, recY, recWidth, recHeight, radiusX, radiusY)

		-- Outline Box
		local lastLineWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(config.outlineWidth)
		love.graphics.setColor(config.outlineColor)
		love.graphics.rectangle("line", recX, recY, recWidth, recHeight, radiusX, radiusY)
		love.graphics.setLineWidth(lastLineWidth)

		-- Text
		local lastFont = love.graphics.getFont()
		love.graphics.setFont(config.font)
		love.graphics.setColor(config.foregroundColor)
		love.graphics.printf(text, x, y, limit, align, 0, size, size)
		love.graphics.setFont(lastFont)

		-- Revert user graphics settings to normal
		love.graphics.pop()
	end
end

return toasty
