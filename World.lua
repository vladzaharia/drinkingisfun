
local World = {}


-- Size of players
local PSIZE = Vector(GRID_SIZE, GRID_SIZE)


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
		love.graphics.print("Player" .. id .. " P" .. Vector.tostring(player.pos), pos.x + 50, pos.y + 10)
	end
end

function World:setPlayer(id, pos)
	if not self.players[id] then
		self.players[id] = {}
	end
	self.players[id].pos = pos or self.players[id].pos or Vector(0,0)
end

function World:getPlayerPosition(id)
	return self.players[id].pos
end

return World