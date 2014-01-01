module("ClientGame", package.seeall)

local socket 			= require("socket")
local World 			= require("World")


function ClientGame:start(args)
	self.id = args.id
	self.udp = args.udp
	
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
	World:update(dt)
end

function ClientGame:draw()
	World:draw()
	
	love.graphics.print("Client: " .. socket.dns.toip(socket.dns.gethostname()),
		10, 10)
end

function ClientGame:key(key, action)

end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end
