
local AttractState = {}

local ClientConnectState		= require("ClientConnectState")
local ServerGameState			= require("ServerGameState")


function AttractState:start()
end

function AttractState:stop()
end

function AttractState:update(dt)
end

function AttractState:draw()
	love.graphics.print("'S' for Server\n'C' for Client", 10, 10)
end

function AttractState:key(key, action)
	if key == "s" then
		return ServerGameState
	elseif key == "c" then
		return ClientConnectState
	end
end

function AttractState:mousePos(x,y)
end

function AttractState:mouse(key, action)
end


return AttractState