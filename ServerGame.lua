
local ServerGame = {}

local socket 			= require("socket")
local DisconnectManager	= require("DisconnectManager")
local Map 				= require("Map")

-- Types of drinks
-- Duplicated in World
local DRINK_TYPE = {1, 2, 3, 4, 5, 6}
local DRINK_CONTENT = {8, 8, 22, 16, 16, 12}
local DRINK_TYPE_SIZE = 6


function ServerGame:start()
	-- Set up our socket
	self.udp = socket.udp()
	self.udp:settimeout(0) -- We don't want to block at all
	self.udp:setsockname("*", SERVER_PORT)

	-- Where we will store our mapping of clients to game objects
	self.clients = {}
	self.drinks = {}
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

	-- Server checks number of active drinks and adds more
	local drink_count = self:tableSize(self.drinks)
	if drink_count < 15 then
		self:spawnDrink()
	end
	
	-- Server now needs to send out world updates to clients
	for desc, client in pairs(self.clients) do
		local ip, port = self:getClientContact(desc)
		local msg = "upd "
		local send = false
		for other_desc, other_client in pairs(self.clients) do 
			if other_desc ~= desc then
				msg = msg .. other_client.id .. " " .. other_client.pos .. " " .. other_client.dir .. " " .. other_client.score .. ";"
				send = true
			end
		end
		if send then
			self.udp:sendto(msg, ip, tonumber(port))
		end
	end

	-- Check if any of our clients have timed out and remove them from the game
	DisconnectManager:update(dt)
	for client_desc in DisconnectManager:timedOutPeers() do
		self:removePlayer(client_desc)
	end
	DisconnectManager:disconnectedTimedOutPeers()
end

function ServerGame:draw()
	love.graphics.print("Server: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)

	-- Print a list of clients
	love.graphics.print("Client list:", 10, 30)
	local y = 50
	for desc,client in pairs(self.clients) do
		love.graphics.print(desc .. " - Position (" .. client.pos .. ")", 10, y)
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
	local desc = self:getClientDesc(ip, port)
	-- Track that we received a message from a client
	DisconnectManager:reachedPeer(desc)

	if data == "reg" then
		print("Connected ip=" .. ip .. " port=" .. port)
		assert(self.clients[desc] == nil, "Already connected: " .. desc)
		local client = self:newClient()
		self.clients[ desc ] = client
		-- Send response
		local result, err = self.udp:sendto("regd " .. client.id .. " " .. 
			client.pos, ip, port)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
		self:sendAllDrinks(desc)
	elseif data == "dis" then
		print("Disconnected ip=" .. ip .. " port=" .. port)
		assert(self.clients[desc], "Not a valid client: " .. desc)
		self:removePlayer(desc)
	elseif data:match("upd ") then
		local client = self.clients[desc]
		local id,vec,dir,scr = data:match("upd (%w+) (%S+,%S+) (%a*) (%S+)")
		assert(tonumber(id) == client.id, "Bad client id for this client")
		client.pos = Vector.fromstring(vec)
		client.dir = dir
		client.score = scr
	elseif data:match("req ") then
		local client = self.clients[desc]
		local id,vec,dir = data:match("req (%w+) (%S+,%S+) (%a*)")
		assert(tonumber(id) == client.id, "Bad client id for this client")
		local newPos = Vector.fromstring(vec)
		if self:isPossibleMove(newPos) then
			client.pos = newPos
		end		
		client.dir = dir
		local result, err = self.udp:sendto("acc " .. client.pos .. " " .. client.dir, ip, port)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. (err or "none"))
	elseif data:match("juke ") then
		local client = self.clients[desc]
		local id,song = data:match("juke (%w+) (%d)")
		assert(tonumber(id) == client.id, "Bad client id for this client")

		-- Send update to all other clients
		for other_desc, other_client in pairs(self.clients) do 
			if desc ~= other_desc then
				local ip, port = self:getClientContact(other_desc)
				msg = "juke " .. song
				self.udp:sendto(msg, ip, tonumber(port))
			end
		end
	elseif data:match("drk ") then
		local client = self.clients[desc]
		local pos = data:match("drk (%S+,%S+)")
		pos = Vector.fromstring(pos)
		self:removeDrink(pos, desc)
	elseif data:match("hrt") then
		-- This is just the heartbeat for the client connection, do nothing
	elseif data:match("iceReq ") then
		local client = self.clients[desc]
		local id, tid, vec, bac = data:match("iceReq (%w+) (%w+) (%S+,%S+) (%d+)")
		vec = Vector.fromstring(vec)
		for cid, client in pairs(self.clients) do
			if Vector.eq(client.pos , vec) then
				self:sendIceNote(cid, bac)
				self:sendIceRes(ip, port)
			end
		end
	else
		assert(false, "Bad message: " .. data)
	end
end

function ServerGame:sendIceRes(ip, port)
	local result, err = self.udp:sendto("iceRes", ip, port)
	assert(result ~= nil, "Network error: result=" .. result .. " err=" .. (err or "none"))
end

function ServerGame:sendIceNote(tid, bac)
	local msg = "iceNote " .. bac
	print(msg)
	for cid, client in pairs(self.clients) do
		if cid == tid then
			print("iceNote sent")
			local ip,port = self:getClientContact( cid )
			local result, err = self.udp:sendto(msg, ip, port)
			assert(result ~= nil, "Network error: result=" .. result .. " err=" .. (err or "none"))
		end
	end
end

function ServerGame:getClientDesc(ip, port)
	return ip .. (":" .. port)
end

function ServerGame:getClientContact(desc)
	return desc:match("(%S+):(%S+)")
end

function ServerGame:newClient() 
	local freeSpace = false
	local newPos = ServerGame:randomPos()

	while not freeSpace do
		if not ServerGame:isPossibleMove(newPos) then
			newPos = ServerGame:randomPos()
		else
			freeSpace = true
		end
	end

	local client = { id = self.nextClientId, pos = newPos, dir = "down", score = 0 }
	self.nextClientId = self.nextClientId + 1
	return client
end

function ServerGame:randomPos()
	local newX = math.random(1, ServerGame:tableSize(Map:getWorld()[1])-1)
	local newY = math.random(1, ServerGame:tableSize(Map:getWorld())-1)
	return Vector(newX, newY)
end

function ServerGame:isPossibleMove(pos)
	can_move = true

	for _, client in pairs(self.clients) do
		if pos == client.pos then
			can_move = false
			break
		end
	end

	if Map:getWorld()[pos.y][pos.x] == "W" then
		can_move = false
	end

	return can_move
end

function ServerGame:tableSize(tabl)
	local count = 0
	for _ in pairs(tabl) do
		count = count + 1
	end
	return count
end

function ServerGame:removePlayer(desc)
	DisconnectManager:disconnectedPeer(desc)
	local client = self.clients[desc]
	-- Clear it out of the server's table
	self.clients[ desc ] = nil
	-- Notify other clients of the removal of a player
	for other_desc, _ in pairs(self.clients) do
		local nip, nport = self:getClientContact(other_desc)
		local result, err = self.udp:sendto("dis " .. client.id, nip, nport)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	end
end

function ServerGame:spawnDrink()
	local freeSpace = false
	local newPos = self:randomPos()

	while not freeSpace do
		local randPos = Map:getWorld()[newPos.y][newPos.x]
		if randPos == 'W' or randPos == 'P' or self:collideItem(newPos) then
			newPos = self:randomPos()
		else
			freeSpace = true
		end
	end

	local drinkType = DRINK_TYPE[math.random(1, DRINK_TYPE_SIZE)]
	
	local d = {}
	d.pos = newPos
	d.type = drinkType

	table.insert(self.drinks, d)

	-- Send all clients update about new drink
	for desc, client in pairs(self.clients) do
		local ip, port = self:getClientContact(desc)
		self.udp:sendto("drk " .. d.type .. " " .. d.pos, ip, port)
	end
end

function ServerGame:sendAllDrinks(desc)
	local ip, port = self:getClientContact(desc)
	-- Send all clients update about new drink
	for _, drink in pairs(self.drinks) do
		self.udp:sendto("drk " .. drink.type .. " " .. drink.pos, ip, port)
	end
end

function ServerGame:collideItem(pos)
	for id, drink in pairs(self.drinks) do
		if pos == drink.pos then
			return true
		end
	end
	return false
end

function ServerGame:removeDrink(pos, sender_desc)
	local d = nil
	print(inspect(self.drinks))
	print(pos, type(pos))
	for id, drink in pairs(self.drinks) do
		if pos == drink.pos then
			d = drink
			self.drinks[id] = nil
			break;
		end
	end
	if not d then
		assert(false, "could not find the drink to remove")
	end
end

return ServerGame