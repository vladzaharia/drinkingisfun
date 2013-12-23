module("ServerGame", package.seeall)

local socket 			= require("socket")


function ServerGame:start()
	-- Set up our socket
	self.udp = socket.udp()
	self.udp:settimeout(0) -- We don't want to block at all
	self.udp:setsockname("*", GAME_PORT)

	-- Where we will store our mapping of clients to game objects
	self.clients = {}
end

function ServerGame:stop()
	self.udp = nil
	self.clients = nil
end

function ServerGame:update(dt)
	local data, ip_or_msg, port = self.udp:receivefrom()
	while data ~= nil do
		self:handleMessage(ip_or_msg, data)
		-- Grab next message
		data, ip_or_msg, port = self.udp:receivefrom()
	end
	-- Last receive should always be a timeout
	assert(ip_or_msg=="timeout", "Unexpected network error, msg=" .. ip_or_msg)
end

function ServerGame:draw()
	love.graphics.print("Server: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)

	-- Print a list of clients
	love.graphics.print("Client list:", 10, 30)
	local y = 50
	for ip,client in pairs(self.clients) do
		love.graphics.print(ip, 10, y)
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

function ServerGame:handleMessage(ip, data)
	if data == "reg" then
		print("Connected ip=" .. ip)
		self.clients[ip] = {}
		-- Send response
		local result, err = self.udp:sendto("regd", ip, GAME_PORT)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	elseif data == "dis" then
		print("Disconnected ip=" .. ip)
		self.clients[ip] = nil
	end
end
