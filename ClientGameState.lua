module("ClientGameState", package.seeall)

local ClientGame 			= require("ClientGame")



function ClientGameState:start(args)
	ClientGame:start(args)
end

function ClientGameState:stop()
	ClientGame:stop()
end

function ClientGameState:update(dt)
	ClientGame:update(dt)
end

function ClientGameState:draw()
	ClientGame:draw()
end

function ClientGameState:key(key, action)
	ClientGame:key(key, action)
end

function ClientGameState:mousePos(x,y)
	ClientGame:mousePos(x,y)
end

function ClientGameState:mouse(key, action)
	ClientGame:mouse(key, action)
end
