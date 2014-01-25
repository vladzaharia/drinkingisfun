
local World = {}
local Map = require("Map")

-- Size of players
local PSIZE = Vector(GRID_SIZE, GRID_SIZE)


function World:start(width, height)
	print(width, height)
	self.width = width;
	self.height = height
	self.players = {}
	self.platforms = {}
	self.world = Map.getExampleWorld()

	self.players[99] = {}
	self.players[99].pos = Vector(9,9)
end

function World:stop()
	self.width = nil
	self.height = nil
	self.players = nil
end

function World:update(dt)
end

function World:draw()
	-- Draw the world
	for y, row in pairs(self.world) do
		for x, item in pairs(row) do
			if item then
				if item == "W" then
					love.graphics.setColor(0, 0, 255, 255)
				end

				love.graphics.rectangle("fill", x*GRID_SIZE-GRID_SIZE, y*GRID_SIZE-GRID_SIZE, GRID_SIZE, GRID_SIZE)
			end
		end
	end

	-- Players
	love.graphics.setColor(255, 0, 0, 255)
	for id, player in pairs(self.players) do
		local pos = player.pos
		love.graphics.rectangle("fill", pos.x*GRID_SIZE-GRID_SIZE, pos.y*GRID_SIZE-GRID_SIZE, PSIZE.x, PSIZE.y)
	end
end

function World:setPlayer(id, pos)
	-- TODO: Check if colliding into something locally
	local can_move = true

	if not self.players[id] then
		self.players[id] = {}
	end

	for _, player in pairs(self.players) do
		if pos == player.pos then
			can_move = false
			break
		end
	end

	if can_move then
		self.players[id].pos = pos or self.players[id].pos or Vector(0,0)
	end

	return self.players[id].pos
end

function World:getPlayerPosition(id)
	return self.players[id].pos
end

return World