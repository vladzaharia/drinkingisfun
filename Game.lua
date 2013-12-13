
local socket = require("socket")

local Game = {}


function Game:start(isServer)
	self.isServer = isServer
	self.mouseX = 0
	self.mouseY = 0
	self.camX = 0
	self.camY = 0
	self.time = 0
end

function Game:update(dt)

end

function Game:draw()
	love.graphics.print(self.isServer and "Server" or "Client", 10, 10)
	love.graphics.print("Delay: " .. self.time, 10, 30)

	love.graphics.push()
	love.graphics.translate(-self.camX,-self.camY)

	love.graphics.pop()
end

function Game:key(key, action)

end

function Game:mousePos(x,y)
	self.mouseX = x
	self.mouseY = y
end

function Game:mouse(key, action)
	
end

return Game