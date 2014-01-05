
local ServerGame = {}

local socket 			= require("socket")


function ServerGame:start()
	-- Set up our socket
	self.udp = socket.udp()
	self.udp:settimeout(0) -- We don't want to block at all
	self.udp:setsockname("*", SERVER_PORT)

	-- Where we will store our mapping of clients to game objects
	self.clients = {}
	self.nextClientId = 0
end

function ServerGame:stop()
	self.udp = nil
	self.clients = nil
	self.nextClientId = nil
end

function ServerGame:update(dt)
	local data, ip_or_msg, port = self.udp:receivefrom()
	while data ~= nil do
		self:handleMessage(ip_or_msg, port, data)
		-- Grab next message
		data, ip_or_msg, port = self.udp:receivefrom()
	end
	-- Last receive should always be a timeout
	assert(ip_or_msg=="timeout", "Unexpected network error, msg=" .. ip_or_msg)
	
	-- Server now needs to send out world updates to clients
end

function ServerGame:draw()
	love.graphics.print("Server: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)

	-- Print a list of clients
	love.graphics.print("Client list:", 10, 30)
	local y = 50
	for id,client in pairs(self.clients) do
		love.graphics.print(id, 10, y)
		y = y + 20
	end

	love.graphics.push()
	-- Do drawing here
	love.graphics.pop()
end

function ServerGame:key(key, action)
end

function ServerGame:mousePos(x,y)
end

function ServerGame:mouse(key, action)
end

function ServerGame:handleMessage(ip, port, data)
	if data == "reg" then
		print("Connected ip=" .. ip .. " port=" .. port)
		local id = self:getClientId(ip, port)
		assert(self.clients[id] == nil, "Already connected: " .. id)
		local client = self:newClient()
		self.clients[ id ] = client
		-- Send response
		local result, err = self.udp:sendto("regd " .. client.id .. " " .. 
			client.pos, ip, port)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	elseif data == "dis" then
		print("Disconnected ip=" .. ip .. " port=" .. port)
		local id = self:getClientId(ip, port)
		assert(self.clients[id], "Not a valid client: " .. id)
		-- TODO: The actual logic for this will require removing the player from
		-- the world and notifying other clients of this
		self.clients[ id ] = nil
	else
		assert(false, "Bad message: " .. data)
	end
end

function ServerGame:getClientId(ip, port)
	return ip .. (":" .. port)
end

function ServerGame:newClient() 
	local client = { id = self.nextClientId, pos = Vector(0,0) }
	self.nextClientId = self.nextClientId + 1
	return client
end


return ServerGame