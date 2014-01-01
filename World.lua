module("World", package.seeall)

-- Size of players
local PSIZE = Vector(40,20)


function World:start(width, height)
	print(width, height)
	self.width = width;
	self.height = height
	self.players = {}
	self.platforms = {}
	
	-- Set up some default platforms
	self.platforms[1] = {
		pos = Vector(width/2,height/2),
		size = Vector(width/2,height/2)
	}
end

function World:stop()
	self.width = nil
	self.height = nil
	self.players = nil
	self.platforms = nil
end

function World:update(dt)
	
end

function World:draw()
	-- Players
	love.graphics.setColor(255, 0, 0, 255)
	for id, player in pairs(self.players) do
		local pos = player.pos - PSIZE/2
		love.graphics.rectangle("fill", pos.x, pos.y, PSIZE.x, PSIZE.y)
	end
	
	-- Platforms
	love.graphics.setColor(0, 255, 0, 255)
	for _, plat in pairs(self.platforms) do
		local pos = plat.pos - (plat.size/2)
		love.graphics.rectangle("fill", pos.x, pos.y, PSIZE.x, PSIZE.y)
	end
end

function World:setPlayer(id, pos, vel)
	if not self.players[id] then
		self.players[id] = {}
	end
	self.players[id].pos = pos
	self.players[id].vel = vel
end