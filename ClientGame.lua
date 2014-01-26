
local ClientGame = {}


local socket 			= require("socket")
local World 			= require("World")

local HEARTBEAT_DELAY = 1

function ClientGame:start(args)
	self.id = args.id
	self.udp = args.udp
	self.moving = false
	self.timeSinceLastHeartbeat = 0
	
	World:start(love.window.getWidth(), love.window.getHeight())
	World:setPlayer(args.id, args.pos, 'down')
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
	-- Check whether we just drowned
	World:checkIfDrowned(self.id)

	-- Receive client updates
	local data, msg = self.udp:receive()
	while data ~= nil do
		self:handleMessage(data)
		-- Grab next message
		data, msg = self.udp:receive()
	end
	-- Last receive should always be a timeout
	assert(msg=="timeout", "Unexpected network error, msg=" .. msg)

	-- Perform local update
	World:update(dt)

	-- Send client update to server
	if not self.moving then
		local pos = World:getPlayerPosition(self.id)
		local dir = World:getPlayerDirection(self.id)
		local scr = World:getPlayerScore(self.id)
		local msg = "upd " .. self.id .. " " .. pos .. " " .. dir .. " " .. scr
		local result, err = self.udp:send(msg)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	end

	-- Track how long it's been since our last heartbeat and send one if it has passed some threshold
	self.timeSinceLastHeartbeat = self.timeSinceLastHeartbeat + dt
	if self.timeSinceLastHeartbeat > HEARTBEAT_DELAY then
		local result, err = self.udp:send("hrt")
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
	end

	-- HACK to remove the delay between movements while holding the key down
	local isDown = love.keyboard.isDown
	local key = isDown(Keys.Up) and Keys.Up or nil
	key = isDown(Keys.Left) and Keys.Left or key
	key = isDown(Keys.Down) and Keys.Down or key
	key = isDown(Keys.Right) and Keys.Right or key
	if not self.moving and not World:isPlayerMoving(self.id) and key ~= nil then
		ClientGame:key(key, "re")
	end
	-- END HACK
end

function ClientGame:draw()
	World:draw(self.id)
	--local bac = tonumber(string.format("%.2f", World:getPlayerBAC(self.id)))
	local score = tonumber(string.format("%.1f", World:getPlayerScore(self.id)))
	love.graphics.setColor(0,0,0,255)
	love.graphics.print("Points: " .. score, 100, 580)
	love.graphics.reset()

end

function ClientGame:key(key, action)
	if (action == "p" or action == "re") and not self.moving and not World:isPlayerMoving(self.id) then
		local curPos = World:getPlayerPosition(self.id)
		local curDir = World:getPlayerDirection(self.id)
		local bac = World:getPlayerBAC(self.id)
		-- stumble walking
		local bac = World:getPlayerBAC(self.id)
		if bac >= 75 then	
			if key == Keys.Up then
				if ((math.random() >= 0.7) and (math.random() <= 0.8)) then
					ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
				elseif ((math.random() > 0.8) and (math.random() <= 0.9)) then
					ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
				elseif ((math.random() > 0.9) and (math.random() <= 1.0)) then
					ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
				else
					ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
				end
			elseif key == Keys.Down then
				if ((math.random() >= 0.7) and (math.random() <= 0.8)) then
					ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
				elseif ((math.random() > 0.8) and (math.random() <= 0.9)) then
					ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
				elseif ((math.random() > 0.9) and (math.random() <= 1.0)) then
					ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
				else
					ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
				end
			elseif key == Keys.Left then
				if ((math.random() >= 0.7) and (math.random() <= 0.8)) then
					ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
				elseif ((math.random() > 0.8) and (math.random() <= 0.9)) then
					ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
				elseif ((math.random() > 0.9) and (math.random() <= 1.0)) then
					ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
				else
					ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
				end
			elseif key == Keys.Right then
				if ((math.random() >= 0.7) and (math.random() <= 0.8)) then
					ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
				elseif ((math.random() > 0.8) and (math.random() <= 0.9)) then
					ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
				elseif ((math.random() > 0.9) and (math.random() <= 1.0)) then
					ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
				else
					ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
				end
			elseif key == "b" then
				World:toggleBloom()
			elseif key == Keys.Space then
				ClientGame:updatePos(curPos, curDir,'drink')
				World:consumeDrink(self.id)
			end
		-- normal walking
		else	
			if key == Keys.Up then
				ClientGame:updatePos(curPos - Vector(0, 1), 'up','walk')
			elseif key == Keys.Down then
				ClientGame:updatePos(curPos - Vector(0, -1), 'down','walk')
			elseif key == Keys.Left then
				ClientGame:updatePos(curPos - Vector(1, 0), 'left','walk')
			elseif key == Keys.Right then
				ClientGame:updatePos(curPos - Vector(-1, 0), 'right','walk')
			elseif key == "b" then
				World:toggleBloom()
			elseif key == Keys.Space then
				if ClientGame:isNextToJukeBox(curPos, curDir) then 
					World:handleJukeBox()
				else 
					ClientGame:updatePos(curPos, curDir,'drink')
					World:consumeDrink(self.id)
				end
			end
		end
	end

	--[[ NOTE: This is for testing purposes 
	if key == "r" then
		assert(false, "This is an intentional crash you get by hitting 'R'")
	end
	--]]
	---[[ NOTE: This is also for testing
	if key == "p" and action == "p" then
		World:addToPlayerBAC(self.id, 10)
	end
	--]]
end

function ClientGame:isNextToJukeBox(pos, dir)
	-- JukeBox is at (14, 14)

	local doIt = (pos.x == 13 and pos.y == 14 and dir == 'right')
	doIt = doIt or (pos.x == 15 and pos.y == 14 and dir == 'left')
	doIt = doIt or (pos.y == 15 and pos.x==14 and dir == 'up')
	return doIt
end

function ClientGame:updatePos(newPos, dir, action)
	if action ~= "drink" then
		-- request the move from the server
		self.moving = true
		local msg = "req " .. self.id .. " " .. newPos .. " " .. dir
		local result, err = self.udp:send(msg)
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))

		-- same position, but walking now
		World:setPlayer(self.id, World:getPlayerPosition(self.id), dir, "walk")
	else 
		World:setPlayer(self.id, newPos, dir, "drink")
	end
end

function ClientGame:mousePos(x,y)
end

function ClientGame:mouse(key, action)
	
end

function ClientGame:handleMessage(data)
	if data:match("upd ") then
		-- move all the other players
		-- we'll need to smooth them out and make them "walk"
		for str in data:sub(5,-1):gmatch("[^;]+") do
			local id, pos, dir, scr = str:match("(%w+) (%S+,%S+) (%a+) (%S+)")
			id = tonumber(id)
			scr = tonumber(scr)
			pos = Vector.fromstring(pos)
			assert(id ~= self.id, "got update for self which is nonsense")
			local oldPos = World:getPlayerPosition(id)
			if oldPos ~= pos then
				newPos = World:setPlayer(id, pos, dir, "move")
			end
			World:setPlayerScore(id, scr)
				
			--assert(newPos == pos, "failed updated position")
		end
	elseif data:match("dis ") then
		-- remove a player from the game
		local id = data:match("dis (%w+)")
		id = tonumber(id)
		assert(id ~= self.id, "got message to remove self from world")
		World:removePlayer(id)
	elseif data:match("acc ") then
		-- server has accepted our position, actually move the player
		-- we'll need to smooth this out somehow
		local pos, dir = data:match("acc (%S+,%S+) (%a+)")
		pos = Vector.fromstring(pos)
		World:setPlayer(self.id, pos, dir, "move")
		self.moving = false
	else
		assert(false, "Bad message: " .. data)
	end
end


return ClientGame