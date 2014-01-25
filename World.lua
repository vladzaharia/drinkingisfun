
local World = {}


-- Size of players
local PSIZE = Vector(40,20)


function World:start(width, height)
	print(width, height)
	self.width = width;
	self.height = height
	self.players = {}
	self.platforms = {}
end

function World:stop()
	self.width = nil
	self.height = nil
	self.players = nil
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
end

function World:setPlayer(id, pos, vel)
	if not self.players[id] then
		self.players[id] = {}
	end
	self.players[id].pos = pos
	self.players[id].vel = vel
end


return World