local encounter = {
	in_encounter = false,
	boss = nil,
	timer = 0,
	y = -100,
	todo = "in",
	font = lg.newFont("assets/poe.ttf", 32),
	text = "",
	fulltext = "",
	width = 0
}

function encounter:startEncounter(enemy)
	self.in_encounter = true
	self.boss = enemy
	
	local info = self.boss:encounter()
	self.text = info.text
	
	if type(self.text) == "table" then
		for i,v in ipairs(self.text) do
			if type(v) == "string" then
				self.width = self.width + self.font:getWidth(v)
				self.fulltext = self.fulltext .. v
			end
		end
	elseif type(self.text) == "string" then
		self.width = self.font:getWidth(self.text)
	end
end

function encounter:update(dt)
	if not self.in_encounter then return end
	self.boss:update(dt)
	
	if self.todo == "in" then
		if self.timer < 1 then self.timer = self.timer + dt/3 end
		if self.timer > 1 then
			self.todo = "wait"
			self.timer = 0
		end
	elseif self.todo == "wait" then
		self.timer = self.timer + dt/3
		if self.timer > 1 then
			self.todo = "out"
			self.timer = 0
		end
	elseif self.todo == "out" then
		if self.timer < 1 then self.timer = self.timer + dt/3 end
		if self.timer > 1 then self.timer = 1 end
	end
	
	if self.todo == "in" then
		self.y = lerp(-100, 100, self.timer)
	elseif self.todo == "out" then
		self.y = lerp(100, -100, self.timer)
	end
	
end

function encounter:draw()
	if not self.in_encounter then return end
	self.boss:draw()
	
	lg.setColor(255, 255, 255)
	local f = lg.getFont()
	lg.setFont(self.font)
	lg.print({{0, 0, 0}, "You have encountered"}, 400-self.font:getWidth("You have encountered")/2+1, self.y+1)
	lg.print({{0, 0, 0}, self.fulltext}, 400-self.width/2+1, self.y+50+1)
	
	lg.print({{255, 0, 0}, "You have encountered"}, 400-self.font:getWidth("You have encountered")/2, self.y)
	lg.print(self.text, 400-self.width/2, self.y+50)
	
	lg.setFont(f)
	
end

return encounter
