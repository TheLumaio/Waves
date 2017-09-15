local Ship = require "ship"
local player = Ship(math.floor(water.width/1.2))

function player:init()
	player:loadCannonMap("assets/player_cm.png")
end

function player:update(dt)
	self.rotate = lerp(self.rotate, self.to_rotate+math.cos(3*time)*0.2, self.lerpspeed)
	self.speed = lerp(self.speed, self.to_speed, 0.2)
	self.y = lerp(self.y, self.to_y, 0.3)
	
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
		
	end
	
end

function player:overlay()
	-- FIXME: i shouldn't need this but just in case
end

return player
