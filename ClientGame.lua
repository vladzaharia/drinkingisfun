
local ClientGame = {}


local socket 			= require("socket")
local World 			= require("World")

local HEARTBEAT_DELAY = 1

function ClientGame:start(args)
	self.id = args.id
	self.udp = args.udp
	self.moving = false
	self.timeSinceLastHeartbeat = 0
	
	World:start(love.window.getWidth(), love.window.getHeight())
	World:setPlayer(args.id, args.pos, 'down')
end

function ClientGame:stop()
	World:stop()
	
	--send disconnect to server
	local result, err = self.udp:send("dis")
	assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
		(err or "none"))
	
	self.id = nil
	self.pos = nil
	self.udp = nil
end

function ClientGame:update(dt)
	-- Receive client updates
	local data, msg = self.udp:receive()
	while data ~= nil do
		self:handleMessage(data)
		-- Grab next message
		data, msg = self.udp:receive()
	end
	-- Last receive should always be a timeout
	assert(msg=="timeout", "Unexpected network error, msg=" .. msg)

	-- Perform local update
	World:update(dt)

	-- Send client update to server
	if not self.moving then
		local pos = World:getPlayerPosition(self.id)
		local dir = World:getPlayerDirection(self.id)
		local msg = "upd " .. self.id .. " " .. pos .. " " .. dir
		local result, err = self.udp:send(msg)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	end

	-- Track how long it's been since our last heartbeat and send one if it has passed some threshold
	self.timeSinceLastHeartbeat = self.timeSinceLastHeartbeat + dt
	if self.timeSinceLastHeartbeat > HEARTBEAT_DELAY then
		local result, err = self.udp:send("hrt")
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	end
end

function ClientGame:draw()
	World:draw(self.id)
	bac = tonumber(string.format("%.2f", World:getPlayerBAC(self.id)))
	love.graphics.print("Regret: " .. bac, 100, 580)

end

function ClientGame:key(key, action)
	if (action == "p" or action == "re") and not self.moving and not World:isPlayerMoving(self.id) then
		local curPos = World:getPlayerPosition(self.id)
		local curDir = World:getPlayerDirection(self.id)

		if key == Keys.Up then
			ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
		elseif key == Keys.Down then
			ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
		elseif key == Keys.Left then
			ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
		elseif key == Keys.Right then
			ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
		elseif key == Keys.Space then
			ClientGame:updatePos(curPos, curDir,'drink')
			World:consumeDrink(self.id)
		end
	end

	-- NOTE: This is for testing purposes 
	if key == "r" then
		assert(false, "This is an intentional crash you get by hitting 'R'")
	end
end

function ClientGame:updatePos(newPos, dir, action)
	if action ~= "drink" then
		-- request the move from the server
		self.moving = true
		local msg = "req " .. self.id .. " " .. newPos .. " " .. dir
		local result, err = self.udp:send(msg)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))

		-- same position, but walking now
		World:setPlayer(self.id, World:getPlayerPosition(self.id), dir, "walk")
	else 
		World:setPlayer(self.id, newPos, dir, "drink")
	end
end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end

function ClientGame:handleMessage(data)
	if data:match("upd ") then
		-- move all the other players
		-- we'll need to smooth them out and make them "walk"
		for str in data:sub(5,-1):gmatch("[^;]+") do
			local id, pos, dir = str:match("(%w+) (%S+,%S+) (%a+)")
			id = tonumber(id)
			pos = Vector.fromstring(pos)
			assert(id ~= self.id, "got update for self which is nonsense")
			local newPos = World:setPlayer(id, pos, dir)
			assert(newPos == pos, "failed updated position")
		end
	elseif data:match("dis ") then
		-- remove a player from the game
		local id = data:match("dis (%w+)")
		id = tonumber(id)
		assert(id ~= self.id, "got message to remove self from world")
		World:removePlayer(id)
	elseif data:match("acc ") then
		-- server has accepted our position, actually move the player
		-- we'll need to smooth this out somehow
		local pos, dir = data:match("acc (%S+,%S+) (%a+)")
		pos = Vector.fromstring(pos)
		World:setPlayer(self.id, pos, dir, "move")
		self.moving = false
	else
		assert(false, "Bad message: " .. data)
	end
end


return ClientGame