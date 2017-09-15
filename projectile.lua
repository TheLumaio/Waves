
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
	
end

local projectiles = {}

function updateAndDrawProjectiles()
	for i=#projectiles,1,-1 do
		local v = projectiles[i]
		
		v:updateAndDraw(love.timer.getDelta())
		
		for j,k in ipairs(water.waves) do
			if v.x > k.x and v.x < k.x + 5 and v.y > 500-water.intensity*k.y then
				table.remove(projectiles, i)
				createSplash(k.x+3, 500-water.intensity*k.y, j)
			end
		end
		
	end
end

function createProjectiles(offset, angle, cannons)
	for i,v in ipairs(cannons) do
		local tip = v:getTip(offset.r)
		table.insert(projectiles, projectile(offset.x+tip.x, offset.y+tip.y, angle, math.random(450,500), 20))
	end
end
