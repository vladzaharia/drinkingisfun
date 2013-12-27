module("ClientGame", package.seeall)

local socket = require("socket")


function ClientGame:start(args)
	self.pos = args.pos
	self.udp = args.udp
end

function ClientGame:stop()
	--send disconnect to server
	local result, err = self.udp:send("dis")
	assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
		(err or "none"))
	
	self.pos = nil
	self.udp = nil
end

function ClientGame:update(dt)

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
