
local ClientGame = {}


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
	if action == "p" then
		curPos = World:getPlayerPosition(self.id)

		if key == Keys.Up then
			World:setPlayer(self.id, curPos - Vector(0, GRID_SIZE))
		elseif key == Keys.Down then
			World:setPlayer(self.id, curPos - Vector(0, -GRID_SIZE))
		elseif key == Keys.Left then
			World:setPlayer(self.id, curPos - Vector(GRID_SIZE, 0))
		elseif key == Keys.Right then
			World:setPlayer(self.id, curPos - Vector(-GRID_SIZE, 0))
		end
	end
end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end


return ClientGame