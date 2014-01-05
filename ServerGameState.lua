
local ServerGameState = {}

local ServerGame =			require("ServerGame")


function ServerGameState:start()
	ServerGame:start()
end

function ServerGameState:stop()
	ServerGame:stop()
end

function ServerGameState:update(dt)
	ServerGame:update(dt)
end

function ServerGameState:draw()
	ServerGame:draw()
end

function ServerGameState:key(key, action)
	ServerGame:key(key, action)
end

function ServerGameState:mousePos(x,y)
	ServerGame:mousePos(x,y)
end

function ServerGameState:mouse(key, action)
	ServerGame:mouse(key, action)
end


return ServerGameState