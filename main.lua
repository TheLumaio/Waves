
lg = love.graphics
math.randomseed(os.time())

lg.setLineStyle("rough")
lg.setLineWidth(4)

lg.setDefaultFilter("nearest", "nearest")

--[[global]] time = 0
--[[global]] debug = false

require "mathutils"
require "splash"
require "projectile"

--[[global]] timeofday = require "timeofday"
--[[global]] encounter = require "encounter"

--[[global]] water = require "water"
--[[global]] blackbeard = require "blackbeard"
--[[global]] player = require "player"

local canvas = lg.newCanvas(lg.getWidth()+40, lg.getHeight()+40)
local shake_duration = 0

function love.load()
	water:remap()
	player:init()
	initSplashQuads()
end

function love.update(dt)
	time = time + dt
	timeofday:update(dt)
	
	water:update(dt)
	encounter:update(dt)
	player:update(dt)
	
	if shake_duration > 0 then
		shake_duration = shake_duration - dt
	end
	
end

function love.draw()
	lg.setCanvas(canvas)
	timeofday:draw()
	
	encounter:draw()
	player:draw()
	updateAndDrawSplashes()
	updateAndDrawProjectiles()
	water:draw()
	
	player:overlay()
	
	lg.setCanvas()
	lg.clear(timeofday.current[1])
	lg.setColor(255, 255, 255)
	
	lg.push()
	if shake_duration > 0 then
		lg.translate(math.random(-20,20)*(shake_duration/0.4), math.random(-20,20)*(shake_duration/0.4))
	else
		lg.translate(0, 0)
	end
	lg.draw(canvas, -20, -20)
	lg.pop()
	
	lg.translate(0, 0)
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
	
end

function love.mousepressed(x, y, b)
	player:mousepressed(x, y, b)
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
	
	if key == "d" then
		debug = not debug
	end
	
	if key == "space" and not encounter.in_encounter then
		encounter:startEncounter(blackbeard)
	end
end

function screenShake()
	shake_duration = 0.4
end
