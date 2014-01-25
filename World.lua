
local World = {}
local Map = require("Map")

-- Size of players
local PSIZE = Vector(GRID_SIZE, GRID_SIZE)

-- Types of drinks
local DRINK_TYPE = {'cider', 'water', 'coffee'}
local DRINK_TYPE_SIZE = 3

function World:start(width, height)
	print(width, height)
	self.width = width;
	self.height = height
	self.players = {}
	self.platforms = {}
	self.world = Map.getExampleWorld()
	self.drinks = {}

	---test making drinks
	for i=1, 3 do
		World:spawnDrink()
	end
end

function World:stop()
	self.width = nil
	self.height = nil
	self.players = nil
	self.drinks = nil
end

function World:update(dt)
	-- check for item to pickup, item currently goes into the abyss
	for id, player in pairs(self.players) do
		World:pickUp(id, self.players[id].pos)
	end

	--spawn drink
	local drink_count = World:tableSize(self.drinks)
	if drink_count < 3 then
		World:spawnDrink()
	end
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
		if pos then
			love.graphics.rectangle("fill", pos.x*GRID_SIZE-GRID_SIZE, pos.y*GRID_SIZE-GRID_SIZE, PSIZE.x, PSIZE.y)
		end
	end

	-- Drinks
	love.graphics.setColor(0, 255, 0, 255)
	for id, drink in pairs(self.drinks) do
		local pos = drink.pos
		love.graphics.rectangle("fill", pos.x*GRID_SIZE-GRID_SIZE, pos.y*GRID_SIZE-GRID_SIZE, PSIZE.x, PSIZE.y)
		--love.graphics.print("Drink" .. id .. " P" .. Vector.tostring(drink.pos), pos.x + 50, pos.y + 10)
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

	for y, row in pairs(self.world) do
		for x, item in pairs(row) do
			if item then
				if item == "W" then
					if pos == Vector(x,y) then
						can_move = false
						break
					end
				end
			end
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

function World:spawnDrink()
	local newX = math.random(0, World:tableSize(self.world))
	local newY = math.random(0, World:tableSize(self.world[1]))
	local drinkType = DRINK_TYPE[math.random(1, DRINK_TYPE_SIZE)]
	
	local d = {}
	d.pos = Vector(newX, newY)
	d.type = drinkType

	table.insert(self.drinks, d)
end

function World:pickUp(pid, ppos)
	for id, drink in pairs(self.drinks) do
		if ppos == drink.pos then
			-- put drink in inventory, doesn't exist yet
			table.remove(self.drinks, id)
		end
	end
end

function World:tableSize(tabl)
	local count = 0
	for _ in pairs(tabl) do
		count = count + 1
	end
	return count
end

return World