require("AnAL")

local jukeboxAnimation = {}

function jukeboxAnimation:new()
	local M = {}
	M.init = jukeboxAnimation.init
	M.update = jukeboxAnimation.update
	M.draw = jukeboxAnimation.draw
	--M.animation 
	return M
end

function jukeboxAnimation:init()
	local jukebox = love.graphics.newImage("Assets/World/HomeDecor/jukebox.png")
	self.animation = newAnimation(jukebox, 57, 57, 0.5, 0)
	self.animation:setMode("loop")
end

function jukeboxAnimation:update(dt)
	self.animation:update(dt)
end

function jukeboxAnimation:draw(x,y)
	self.animation:draw(x,y)
end

return jukeboxAnimation