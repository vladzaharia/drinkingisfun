
local ClientGame = {}


local socket 			= require("socket")
local World 			= require("World")


function ClientGame:start(args)
	self.id = args.id
	self.udp = args.udp
	self.moving = false
	
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
	local pos = World:getPlayerPosition(self.id)
	local dir = World:getPlayerDirection(self.id)
	local msg = "upd " .. self.id .. " " .. pos .. " " .. dir
	local result, err = self.udp:send(msg)
	assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
		(err or "none"))
end

function ClientGame:draw()
	World:draw(World:getPlayerPosition(self.id), self.id)

	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Client: " .. socket.dns.toip(socket.dns.gethostname()),
		400, 580)
	love.graphics.print("Player" .. self.id .. " P" .. Vector.tostring(World:getPlayerPosition(self.id)), 100, 580)
end

function ClientGame:key(key, action)
	
	if action == "p" and not self.moving then
		self.moving = true
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
		end

		-- move this to the receive
		self.moving = false
	end
end

function ClientGame:updatePos(newPos, dir, action)
	-- TODO: This function should send a message to server to update it
	World:setPlayer(self.id, newPos, dir, action)
end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end

function ClientGame:handleMessage(data)
	if data:match("upd ") then
		for str in data:sub(5,-1):gmatch("[^;]+") do
			local id, pos, dir = str:match("(%w+) (%S+,%S+) (%a+)")
			id = tonumber(id)
			pos = Vector.fromstring(pos)
			assert(id ~= self.id, "got update for self which is nonsense")
			local newPos = World:setPlayer(id, pos, dir)
			assert(newPos == pos, "failed updated position")
		end
	elseif data:match("dis ") then
		local id = data:match("dis (%w+)")
		id = tonumber(id)
		assert(id ~= self.id, "got message to remove self from world")
		World:removePlayer(id)
	else
		assert(false, "Bad message: " .. data)
	end
end


return ClientGame