local shipimage = lg.newImage("assets/ship.png")

local Cannon = require "cannon"

local ship = {}
ship.__index = ship
setmetatable(ship, {
	__call = function(cls, ...)
		return cls.new(...)
	end
})
function ship.new(position)
	local self = setmetatable({}, ship)
	self.position = position
	self.width = 5
	self.to_rotate = 0
	self.rotate = 0
	self.image = shipimage
	self.basespeed = 50
	self.speed = 50
	self.to_speed = 50
	self.lerpspeed = 0.04
	self.to_x = 0
	self.to_y = 0
	self.x = 0
	self.y = 0
	self.cannons = {}
	return self
end

function ship:loadCannonMap(map)
	local data = love.image.newImageData(map)
	for i=0,data:getWidth()-1 do
		for j=0,data:getHeight()-1 do
			local r,g,b,a = data:getPixel(i, j)
			if a > 0 then
				table.insert(self.cannons, Cannon(i, j))
			end
		end
	end
end

function ship:drawCannons(map)
	lg.push()
	lg.translate(self.x, 500-water.intensity*self.y+2)
	lg.rotate(self.rotate)
	for i,v in ipairs(self.cannons) do
		v:draw(self.image)
	end
	lg.pop()
end

return ship
