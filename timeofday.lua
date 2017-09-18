
local timeofday = {
	time = 0,
	day = {
		{255, 255, 200},
		{255, 200, 50},
		{274, 118, 27},
		{255, 255, 25}
	},
	night = {
		{0, 80, 200},
		{0, 60, 160},
		{0, 30, 80},
		{50, 60, 80}
	},
	current = {
		{0, 80, 200},
		{0, 60, 160},
		{0, 30, 80},
		{255, 255, 25}
	},
	sun = {
		{255, 255, 25},
		y = 900
	},
	moon = {
		{200, 230, 255},
		y = 200
	},
	todo = "wait",
	next = "today",
	tod = "night",
	rotation = 0
}

function timeofday:update(dt)
	self.rotation = self.rotation + dt
	if self.todo ~= "wait" then
		if self.time < 1 then self.time = self.time + dt/10 end
		if self.time > 1 then self.time = 1 end
		self.tod = "riseset"
	else
		self.time = self.time + dt/5
		if self.time > 1 then
			self.todo = self.next
			self.time = 0
		end
	end
	--if self.time > 60 then self.time = -60 end
end

function timeofday:draw()
	
	if self.todo == "today" then
		self.sun.y = lerp(900, 200, self.time)
		self.moon.y = lerp(200, -500, self.time)
	elseif self.todo == "tonight" then
		self.sun.y = lerp(200, 900, self.time)
		self.moon.y = lerp(-500, 200, self.time)
	end
	
	for i,v in ipairs(self.current) do
		if self.todo == "today" then
			v[1] = lerp(self.night[i][1], self.day[i][1], self.time)
			v[2] = lerp(self.night[i][2], self.day[i][2], self.time)
			v[3] = lerp(self.night[i][3], self.day[i][3], self.time)
			if  v[1] == self.day[i][1] and
				v[2] == self.day[i][2] and
				v[3] == self.day[i][3] then
					self.todo = "wait"
					self.next = "tonight"
					self.tod = "day"
					self.time = 0
			end
		elseif self.todo == "tonight" then
			v[1] = lerp(self.day[i][1], self.night[i][1], self.time)
			v[2] = lerp(self.day[i][2], self.night[i][2], self.time)
			v[3] = lerp(self.day[i][3], self.night[i][3], self.time)
			if  v[1] == self.night[i][1] and
				v[2] == self.night[i][2] and
				v[3] == self.night[i][3] then
					self.todo = "wait"
					self.next = "today"
					self.tod = "night"
					self.time = 0
			end
		end
	end
	
	lg.setColor(self.current[1])
	lg.rectangle("fill", 0, 0, 1000, 600)
	lg.setColor(self.current[2])
	lg.rectangle("fill", 0, 200, 1000, 600)
	lg.setColor(self.current[3])
	lg.rectangle("fill", 0, 350, 1000, 600)
	
	-- sun
	lg.setColor(self.sun[1])
	lg.push()
	lg.translate(400, self.sun.y)
	lg.rotate(self.rotation)
	lg.circle("fill", 0, 0, 100, 7)
	lg.pop()
	
	-- moon
	lg.setColor(self.moon[1])
	lg.push()
	lg.translate(400, self.moon.y)
	lg.rotate(self.rotation)
	lg.circle("fill", 0, 0, 100, 7)
	lg.pop()
	
	lg.setColor(0, 0, 0)
	
end

return timeofday
