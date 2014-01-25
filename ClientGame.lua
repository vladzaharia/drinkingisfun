
local ClientGame = {}


local socket 			= require("socket")
local World 			= require("World")


function ClientGame:start(args)
	self.id = args.id
	self.udp = args.udp
	self.moving = false
	
	World:start(love.window.getDimensions())
	World:setPlayer(args.id, args.pos, Vector(0,0))
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

	-- TODO: Send update to server
end

function ClientGame:draw()
	World:draw()
	
	love.graphics.print("Client: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)
end

function ClientGame:key(key, action)
	if action == "p" and not self.moving then
		self.moving = true
		curPos = World:getPlayerPosition(self.id)

		if key == Keys.Up then
			ClientGame:updatePos(curPos - Vector(0, GRID_SIZE))
		elseif key == Keys.Down then
			ClientGame:updatePos(curPos - Vector(0, -GRID_SIZE))
		elseif key == Keys.Left then
			ClientGame:updatePos(curPos - Vector(GRID_SIZE, 0))
		elseif key == Keys.Right then
			ClientGame:updatePos(curPos - Vector(-GRID_SIZE, 0))
		end

		-- move this to the receive
		self.moving = false
	end
end

function ClientGame:updatePos(newPos)
	-- TODO: This function should send a message to server to update it
	newPos = World:setPlayer(self.id, newPos)
end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end

function ClientGame:handleMessage(data)

end


return ClientGame