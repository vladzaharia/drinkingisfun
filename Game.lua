
local Game = {}
Game.mouseX = 0
Game.mouseY = 0
Game.camX = 0
Game.camY = 0


function Game:start()

end

function Game:update(dt)

end

function Game:draw()
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