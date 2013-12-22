module("AttractState", package.seeall)

local ClientConnectState		= require("ClientConnectState")
local ServerGameState			= require("ServerGameState")


function AttractState:start()
end

function AttractState:stop()
	self.newState = nil
end

function AttractState:update(dt)
	if self.newState then
		return self.newState
	end
end

function AttractState:draw()
	love.graphics.print("'S' for Server\n'C' for Client", 10, 10)
end

function AttractState:key(key, action)
	if key == "s" then
		self.newState = ServerGameState
	elseif key == "c" then
		self.newState = ClientConnectState
	end
end

function AttractState:mousePos(x,y)
end

function AttractState:mouse(key, action)
end
