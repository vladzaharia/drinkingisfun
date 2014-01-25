
-- Fixes console output not appearing until after love is closed
io.stdout:setvbuf("no")

-- Globals - available in all scripts without require
Keys						= require("Keys")
Vector						= require("Vector")
GRID_SIZE = 57
SERVER_PORT = 12345
SYNC_INTERVAL = 0.1

local StateManager			= require("StateManager")
local AttractState			= require("AttractState")


function love.load(args)
	love.keyboard.setKeyRepeat(true)
	StateManager:start(AttractState)
end

function love.quit()
	StateManager:stop()
end

function love.focus(f)
end

function love.update(dt)
	StateManager:mousePos(love.mouse.getX(), love.mouse.getY())
	StateManager:update(dt)
end

function love.draw()
	love.graphics.clear()
	StateManager:draw()
end

function love.keypressed(key, isrepeat)
	if key == Keys.Esc then
		love.event.quit()
	end
	StateManager:key(key, isrepeat and 're' or 'p')
end

function love.keyreleased(key)
	StateManager:key(key, 'r')
end

function love.mousepressed(x, y, button)
	StateManager:mousePos(x,y)
	StateManager:mouse(button, 'p')
end

function love.mousereleased(x, y, button)
	StateManager:mousePos(x,y)
	StateManager:mouse(button, 'r')
end