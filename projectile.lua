
local cannonball = lg.newImage("assets/cannonball.png")

local projectile = {}
projectile.__index = projectile
setmetatable(projectile, {
	__call = function(cls, ...)
		return cls.new(...)
	end
})
function projectile.new(x, y, angle, velocity, downforce)
	local self = setmetatable({}, projectile)
	self.x = x
	self.y = y
	self.angle = angle
	self.dx = math.cos(angle)
	self.dy = math.sin(angle)
	self.velocity = velocity
	self.curdown = 0
	self.maxdown = downforce
	return self
end

function projectile:updateAndDraw(dt)
	self.x = self.x + self.dx * self.velocity * dt
	self.y = self.y + self.dy * self.velocity * dt
	self.y = self.y + self.curdown
	
	if self.curdown < self.maxdown then
		self.curdown = self.curdown + 15*dt
	end
	
	lg.setColor(255, 255, 255)
	lg.draw(cannonball, self.x, self.y, self.angle*time, 1, 1, 5, 5)
	--lg.circle("fill", self.x, self.y, 3)
	
end

local projectiles = {}

function updateAndDrawProjectiles()
	for i,v in ipairs(projectiles) do
		v:updateAndDraw(love.timer.getDelta())
	end
end

function createProjectiles(offset, angle, cannons)
	for i,v in ipairs(cannons) do
		local tip = v:getTip(offset.r)
		table.insert(projectiles, projectile(offset.x+tip.x, offset.y+tip.y, angle, math.random(450,500), 20))
	end
end
