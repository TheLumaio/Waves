local water = {
	waves = {},
	intensity = 100,
	width = (800*1.5)/5,
	init = math.random(100000),
	seed = 0.015
}

function water:remap()
	self.waves = {}
	for i=-self.width/2,self.width do
		local n = (love.math.noise((self.init+i)*self.seed)+1)/2
		table.insert(self.waves, {x=i*5, y=n, dip=false, intensity=0})
	end	
	for i=2,self.width-1 do
		local this = self.waves[i]
		local last = self.waves[i-1]
		local next = self.waves[i+1]
		if this.y < next.y and this.y < last.y then
			self.waves[i].dip = true
			self.waves[i].intensity = last.y - this.y
		end
	end
end

function water:update(dt)
	self.init = self.init - player.speed * dt
	self:remap()
end

function water:draw()
	for i,v in ipairs(self.waves) do
		local h = 600
		lg.setColor(90, 150, 150)
		lg.rectangle("fill", v.x, 500-self.intensity*v.y, 5, h)
		lg.setColor(50, 110, 110)
		lg.rectangle("fill", v.x, 550-self.intensity*v.y, 5, h)
		lg.setColor(10, 70, 70)
		lg.rectangle("fill", v.x, 600-self.intensity*v.y, 5, h)
		lg.setColor(0, 30, 30)
		lg.rectangle("fill", v.x, 650-self.intensity*v.y, 5, h)
		
		if debug then
			if i == player.position-math.floor(player.width/2) or i == player.position+player.width then
				lg.setColor(155, 50, 50)
				lg.rectangle("fill", v.x, 500-self.intensity*v.y, 5, h)
			end
			if i == blackbeard.position-math.floor(blackbeard.width/2) or i == blackbeard.position+blackbeard.width then
				lg.setColor(155, 50, 50)
				lg.rectangle("fill", v.x, 500-self.intensity*v.y, 5, h)
			end
		end
		lg.setColor(150, 190, 200)
		if i > 1 then
			lg.setLineWidth(4)
			lg.line(v.x, 500-self.intensity*v.y, self.waves[i-1].x, 500-self.intensity*self.waves[i-1].y)
		end
	end
	
	if debug then
		for i,v in ipairs(water) do
			local mx, my = love.mouse.getPosition()
			if mx > v.x and mx < v.x+5 then
				lg.setColor(0,0,0)
				lg.print(i, v.x, 500-intensity*v.y)
			end
		end
	end
end

return water
