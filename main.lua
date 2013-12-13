
local Game			= require("Game")


function love.load(args)
	local config = args[2]
	assert(config == 'server' or config == 'client')
	Game:start(config == 'server')
end

function love.update(dt)
	Game:mousePos(love.mouse.getX(), love.mouse.getY())
	Game:update(dt)
end

function love.draw()
	Game:draw()
end

function love.keypressed(key, unicode)
	Game:key(key, 'p')
end

function love.keyreleased(key, unicode)
	Game:key(key, 'r')
end

function love.mousepressed(x, y, button)
	Game:mousePos(x,y)
	Game:mouse(button, 'p')
end

function love.mousereleased(x, y, button)
	Game:mousePos(x,y)
	Game:mouse(button, 'r')
end