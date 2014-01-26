
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
	for id, client in pairs(self.clients) do
		local ip, port = self:getClientContact(id)
		local msg = "upd "
		local send = false
		for other_id, other_client in pairs(self.clients) do 
			if other_id ~= id then
				msg = msg .. other_client.id .. " " .. other_client.pos .. ";"
				send = true
			end
		end
		if send then
			self.udp:sendto(msg, ip, tonumber(port))
		end
	end
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
		local client = self.clients[id]
		-- Clear it out of the server's table
		self.clients[ id ] = nil
		-- Notify other clients of the removal of a player
		for other_id, _ in pairs(self.clients) do
			local nip, nport = self:getClientContact(other_id)
			local result, err = self.udp:sendto("dis " .. client.id, nip, nport)
			assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
				(err or "none"))
		end
	elseif data:match("upd ") then
		local id = self:getClientId(ip, port)
		local client = self.clients[id]
		local id,vec = data:match("upd (%w*) (%S*,%S*)")
		assert(tonumber(id) == client.id, "Bad client id for this client")
		client.pos = Vector.fromstring(vec)
	else
		assert(false, "Bad message: " .. data)
	end
end

function ServerGame:getClientId(ip, port)
	return ip .. (":" .. port)
end

function ServerGame:getClientContact(id)
	return id:match("(%S+):(%S+)")
end

function ServerGame:newClient() 
	local client = { id = self.nextClientId, pos = Vector(self.nextClientId+2,2) }
	self.nextClientId = self.nextClientId + 1
	return client
end


return ServerGame