local Ship = require "ship"

local blackbeard = Ship(100)

function blackbeard:encounter()
	self.width = 11
	self.position_timer = 0
	self.startx = water.waves[self.position].x
	self.x = water.waves[self.position].x
	self.image = lg.newImage("assets/blackbeard.png")
	
	self:loadCannonMap("assets/blackbeard_cm.png")
	
	return {
		text = {{255, 255, 255}, "The dread pirate", {20, 20, 20}, " Black Beard"}
	}
end

function blackbeard:update(dt)
	self.position_timer = self.position_timer + dt/5
	if self.position_timer > 1 then self.position_timer = 1 end
	
	self.x = lerp(self.startx, water.waves[145].x, self.position_timer)
	self.position = math.floor(lerp(100, 145, self.position_timer))
	
	self.rotate = lerp(self.rotate, self.to_rotate+math.cos(3*time)*0.05, self.lerpspeed)
	self.speed = lerp(self.speed, self.to_speed, 0.2)
	self.y = lerp(self.y, self.to_y, 0.3)
end

function blackbeard:draw()
	lg.setColor(255, 255, 255)
	self.to_rotate = math.atan2(water.waves[self.position-math.floor(self.width/2)].x - water.waves[self.position+self.width].x, water.intensity*water.waves[self.position-math.floor(self.width/2)].y - water.intensity*water.waves[self.position+self.width].y) + math.rad(90)
	local dif = self.to_rotate-self.rotate
	self.to_speed = self.basespeed-((self.rotate-0.5)*25)
	self.to_y = water.waves[self.position].y
	lg.push()
	lg.translate(self.x, 500-water.intensity*self.y+2)
	lg.rotate(self.rotate)
	lg.draw(self.image, -math.floor(self.image:getWidth()/2), -self.image:getHeight())
	lg.pop()
	
	self:drawCannons()
end

return blackbeard
