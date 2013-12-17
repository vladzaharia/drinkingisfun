module("ServerGame", package.seeall)

local socket = require("socket")


function ServerGame:start()
	self.time = 0

	self.udp = socket.udp()
	udp:settimeout(10) -- make udp operations blocking
	udp:setsockname('*', GAME_PORT)

	local data
	data, self.ip, self.port = udp:receivefrom()
	if data then
		assert(data == "register")
		print("Got message from client, IP=" .. self.ip .. ", port=" .. self.port)
	else
		print("Network error, msg=" .. (self.ip or "none"))
		assert(false)
	end
end

function ServerGame:update(dt)
	local time = love.timer.getTime()
	self.udp:sendto("getinput", self.ip, self.port)
	
	local data, ip, port
	data, ip, port = self.udp:receivefrom()

	-- Check reply and measure the time difference
	if data then
		assert(data == "heresinput")
	else
		print("Network error, msg=" .. (self.ip or "none"))
		assert(false)
	end

	self.time = self.time * 0.9 + (love.timer.getTime() - time) * 0.1
end

function ServerGame:draw()
	love.graphics.print("Server: " .. socket.dns.toip(socket.dns.gethostname()), 10, 10)
	love.graphics.print("Delay: " .. self.time, 10, 30)

	love.graphics.push()
	-- Do drawing here
	love.graphics.pop()
end

function ServerGame:key(key, action)

end

function ServerGame:mousePos(x,y)
	self.mouseX = x
	self.mouseY = y
end

function ServerGame:mouse(key, action)
	
end
