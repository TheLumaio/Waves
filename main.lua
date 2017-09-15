
lg = love.graphics
math.randomseed(os.time())

lg.setLineStyle("rough")
lg.setLineWidth(4)

lg.setDefaultFilter("nearest", "nearest")

function lerp(a,b,t) return (1-t)*a + t*b end
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end

--[[global]] time = 0
--[[global]] debug = false

require "projectile"

--[[global]] timeofday = require "timeofday"
--[[global]] encounter = require "encounter"

--[[global]] water = require "water"
--[[global]] blackbeard = require "blackbeard"
--[[global]] player = require "player"

function love.load()
	water:remap()
	player:init()
end

function love.update(dt)
	time = time + dt
	timeofday:update(dt)
	
	water:update(dt)
	encounter:update(dt)
	player:update(dt)
	
end

function love.draw()
	timeofday:draw()
	
	if debug then
		lg.setColor(0, 0, 0)
		lg.print("seed: " .. water.seed)
		lg.print("init: " .. water.init, 0, 12)
		lg.print("player.position: " .. player.position, 0, 24)
		lg.print("player.to_rotate: " .. player.to_rotate, 0, 36)
		lg.print("player.speed: " .. player.speed, 0, 48)
		lg.print("player.basespeed: " .. player.basespeed, 0, 60)
		lg.print("fps: " .. love.timer.getFPS(), 0, 72)
		lg.print("wave_intensity: " .. water.intensity, 0, 84)
	end
	
	water:draw()
	encounter:draw()
	player:draw()
	updateAndDrawProjectiles()
	
	player:overlay()
	
	-- lg.setColor(255, 255, 255)
	-- lg.setLineWidth(1)
	-- local shipcenter = {
	-- 	x = water[ship.position+1].x,
	-- 	y = 500-wave_intensity*ship.y
	-- }
	-- local mx, my = love.mouse.getPosition()
	-- local fireangle = math.atan2(my - shipcenter.y, mx - shipcenter.x)
	-- if math.deg(fireangle) > -10 and math.deg(fireangle) < 90 then fireangle = math.rad(-10)
	-- elseif math.deg(fireangle) < -170 or math.deg(fireangle) > 90 then fireangle = math.rad(-170) end
	-- if math.deg(fireangle) == 90 then fireangle = math.rad(-10) end
	-- local firedx = math.cos(fireangle)
	-- local firedy = math.sin(fireangle)
	-- local length = math.min(125, math.dist(shipcenter.x, shipcenter.y, mx, my)-50)
	-- if length < 25 then length = 25 end
	-- lg.line(shipcenter.x+firedx*50, shipcenter.y+firedy*50, shipcenter.x+firedx*length+firedx*50, shipcenter.y+firedy*length+firedy*50)s
end

function love.mousepressed(x, y, b)
	player:mousepressed(x, y, b)
end

function love.keypressed(key)
	if key == "d" then
		debug = not debug
	end
	
	if key == "space" and not encounter.in_encounter then
		encounter:startEncounter(blackbeard)
	end
end
