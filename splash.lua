
local splash_image = lg.newImage("assets/splash.png")
local quads = {}

function initSplashQuads()
	for i=0,7 do
		table.insert(quads, lg.newQuad(i*32, 0, 32, 32, splash_image:getWidth(), splash_image:getHeight()))
	end
end

local splash = {}
splash.__index = splash
setmetatable(splash, {
	__call = function(cls, ...)
		return cls.new(...)
	end
})
function splash.new(x, y, wave)
	local self = setmetatable({}, splash)
	self.x = x
	self.y = y
	self.index = 1
	self.timer = 0
	self.wave = wave
	return self
end

function splash:updateAndDraw()
	self.timer = self.timer + love.timer.getDelta()
	if self.timer*1000 > 50 then
		if self.index < 8 then
			self.index = self.index + 1
			self.timer = 0
		end
	end
	
	self.x = water.waves[self.wave].x+3
	self.y = 500-water.intensity*water.waves[self.wave].y
	
	lg.setColor(150, 190, 200)
	lg.draw(splash_image, quads[self.index], self.x-32/2, self.y-splash_image:getHeight())
	
end

function splash:isDone()
	return self.index == 8
end

local splashes = {}

function createSplash(x, y, wave)
	table.insert(splashes, splash(x, y, wave))
end

function updateAndDrawSplashes()
	for i=#splashes,1,-1 do
		local v = splashes[i]
		v:updateAndDraw()
		if v:isDone() then
			table.remove(splashes, i)
		end
	end
end
