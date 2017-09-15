local Ship = require "ship"
local player = Ship(math.floor(water.width/1.2))

function player:init()
	self:loadCannonMap("assets/player_cm.png")
	self.reload_speed = 0
	self.reload_timer = self.reload_speed
	self.reload = false
	self.center = {
		x = 0,
		y = 0
	}
	self.fireangle = 0
end

function player:update(dt)
	self.rotate = lerp(self.rotate, self.to_rotate+math.cos(3*time)*0.2, self.lerpspeed)
	self.speed = lerp(self.speed, self.to_speed, 0.2)
	self.y = lerp(self.y, self.to_y, 0.3)
	
	if self.reload then
		self.reload_timer = self.reload_timer - dt
		if self.reload_timer <= 0 then
			self.reload = false
			self.reload_timer = self.reload_speed
		end
	end
	
	self.center = {
		x = water.waves[self.position].x,
		y = 500-water.intensity*self.y+2,
		r = self.rotate
	}
	
end

function player:draw()
	lg.setColor(255, 255, 255)
	self.to_rotate = math.atan2(water.waves[self.position-math.floor(self.width/2)].x - water.waves[self.position+self.width].x, water.intensity*water.waves[self.position-math.floor(self.width/2)].y - water.intensity*water.waves[self.position+self.width].y) + math.rad(90)
	local dif = self.to_rotate-self.rotate
	self.to_speed = self.basespeed-((self.rotate-0.5)*25)
	self.to_y = water.waves[self.position].y
	self.x = water.waves[self.position].x
	lg.push()
	lg.translate(water.waves[self.position].x, 500-water.intensity*self.y+2)
	lg.rotate(self.rotate)
	lg.draw(self.image, -math.floor(self.image:getWidth()/2), -self.image:getHeight())
	lg.pop()
	self:drawCannons()
	
	if encounter.in_encounter then
		local mx,my = love.mouse.getPosition()
		self.fireangle = math.atan2(my - self.center.y, mx - self.center.x) + math.rad(90)
		if not self.reload then
			for i,v in ipairs(self.cannons) do
				v.rotation = self.fireangle
			end
		end
	end
	
end

function player:mousepressed(x, y, b)
	if encounter.in_encounter and not self.reload then
		createProjectiles(self.center, self.fireangle-math.rad(90), self.cannons)
		self.reload = true
	end
end

function player:overlay()
	if self.reload then
		lg.setColor(100, 200, 100)
		lg.rectangle("fill", self.center.x-(25*(self.reload_timer/5)), self.center.y-75, math.max(0, 50*(self.reload_timer/5)), 10)
		lg.setColor(0, 0, 0)
		lg.setLineWidth(0.5)
		lg.rectangle("line", self.center.x-(25*(self.reload_timer/5)), self.center.y-75, math.max(0, 50*(self.reload_timer/5)), 10)
	end
	
end

return player
