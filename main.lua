
lg = love.graphics
math.randomseed(os.time())

lg.setLineStyle("rough")
lg.setLineWidth(4)

lg.setDefaultFilter("nearest", "nearest")

--[[global]] time = 0
--[[global]] debug = false

require "mathutils"
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
	
	encounter:draw()
	player:draw()
	water:draw()
	updateAndDrawProjectiles()
	
	player:overlay()
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
