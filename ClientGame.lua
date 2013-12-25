module("ClientGame", package.seeall)

local socket = require("socket")


function ClientGame:start()
	--[[
	self.time = 0

	local address, port = "localhost", SERVER_PORT
	
	self.udp = socket.udp()

	self.udp:settimeout(3)
	self.udp:setpeername(address, port)
	self.udp:send("register")
	-]]
end

function ClientGame:update(dt)
	--[[
	self.time = 0
	data, msg = self.udp:receive()
	-- Check message and reply
	if data then
		assert(data == "getinput")
		self.udp:send("heresinput")
	else
		print("Network error, msg=" .. (msg or "none"))
		assert(false)
	end
	--]]
end

function ClientGame:stop()
end

function ClientGame:draw()
	love.graphics.print("Client: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)

	love.graphics.push()
	-- Do drawing here
	love.graphics.pop()
end

function ClientGame:key(key, action)

end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end
