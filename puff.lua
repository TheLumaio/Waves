
local puff_image = lg.newImage("assets/puff.png")
local quads = {}

function initPuffQuads()
	for i=0,6 do
		table.insert(quads, lg.newQuad(i*11, 0, 11, 8, puff_image:getWidth(), puff_image:getHeight()))
	end
end

local puff = {}
puff.__index = puff
setmetatable(puff, {
	__call = function(cls, ...)
		return cls.new(...)
	end
})
function puff.new(x, y, angle)
	local self = setmetatable({}, puff)
	self.x = x
	self.y = y
	self.angle = angle
	self.timer = 0
	self.index = 1
	return self
end

function puff:updateAndDraw()
	self.timer = self.timer + love.timer.getDelta()
	if self.timer*1000 > 10 then
		if self.index < 7 then
			self.index = self.index + 1
			self.timer = 0
		end
	end
	
	lg.setColor(0, 0, 0)
	lg.draw(puff_image, quads[self.index], self.x, self.y, self.angle, 1, 1, 5, 4)
	
end

function puff:isDone()
	return self.index == 7
end

local puffs = {}

function createPuff(x, y, angle)
	table.insert(puffs, puff(x, y, angle))
end

function updateAndDrawPuffs()
	for i=#puffs,1,-1 do
		local v = puffs[i]
		v:updateAndDraw()
		if v:isDone() then
			table.remove(puffs, i)
		end
	end
end
