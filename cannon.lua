
local cannon_base_img = lg.newImage("assets/cannon_base.png")
local cannon_pipe_img = lg.newImage("assets/cannon_pipe.png")

local cannon = {}
cannon.__index = cannon
setmetatable(cannon, {
	__call = function(cls, ...)
		return cls.new(...)
	end
})
function cannon.new(x, y)
	local self = setmetatable({}, cannon)
	self.x = x
	self.y = y
	self.rotation = math.rad(-45)
	self.topmap = nil
	return self
end

function cannon:draw(topmap)
	if not self.topmap then self.topmap = topmap end
	lg.draw(cannon_base_img, self.x-cannon_base_img:getWidth()/2-topmap:getWidth()/2, self.y-cannon_base_img:getHeight()-topmap:getHeight()+2)
	lg.draw(cannon_pipe_img, self.x-topmap:getWidth()/2, self.y-topmap:getHeight(), self.rotation, 1, 1, cannon_pipe_img:getWidth()/2, cannon_pipe_img:getHeight()-2)
end

function cannon:getTip(shipangle)
	local tip = {}
	tip.x = self.x-self.topmap:getWidth()/2+math.cos(self.rotation-math.rad(90))*cannon_pipe_img:getHeight()
	tip.y = self.y-self.topmap:getHeight()+math.sin(self.rotation-math.rad(90))*cannon_pipe_img:getHeight()
	tip = rotatepoint(0, 0, tip.x, tip.y, shipangle)
	return tip
end

return cannon
