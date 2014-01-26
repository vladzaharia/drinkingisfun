
local World = {}
local Map = require("Map")
local playerAnimation = require("playerAnimation")
local Assets = require("Assets")
local SoundManager = require("SoundManager")
local sManager = SoundManager:new()

-- Size of players
local PSIZE = Vector(GRID_SIZE, GRID_SIZE)

-- Types of drinks
local DRINK_TYPE = {1, 2, 3, 4, 5, 6}
local DRINK_CONTENT = {8, 8, 22, 16, 16, 12}
local DRINK_TYPE_SIZE = 6

-- BAC thresholds
local BAC_THRESHOLD = {30, 70}
local BAC_DECAY_RATE = {0.02, 0.03, 0.07}

local SCORE_MULTIPLIER = {0.05, 0.1, 0.15}

-- status colours
local BACKGROUND_GREEN = {154,205,50,255}
local STATUS_YELLOW = {225,225,0,255}
local STATUS_GREEN = {34,139,34,255}
local STATUS_RED = {220,20,60, 255}

-- shaders
local bloomShader = love.graphics.newShader("bloom.fs")

-- timer
local sTime = 0

function World:start(width, height)
	self.width = width;
	self.height = height
	self.players = {}
	self.platforms = {}
	--self.world = Map:getExampleWorld(width, height)
	self.world = Map:getWorld()
	self.drinks = {}
	self.mapImage = love.graphics.newImage("Assets/World/MapF1.png")
	self.bloomStatus = false

	---test making drinks
	for i=1, 4 do
		World:spawnDrink()
	end

	--start the music
	sManager:init()
	sManager:startMusic()
end

function World:stop()
	self.width = nil
	self.height = nil
	self.players = nil
	self.drinks = nil
end

function World:update(dt)
	-- check for item to pickup, item currently goes into the abyss
	-- also stop drinking
	-- also update bac
	-- Game over? End game
	if not self.players then
		return
	end

	for id, player in pairs(self.players) do
		World:pickUp(id, self.players[id].pos)
		local p = self.players[id]
		local pAction = p.action
		if(World:inPool(p.pos)) then
			pAction = 'swim'
		end
		p.pAnim:update(p.dir, pAction, dt)

		World:decayBAC(id)
		

		if player.action == 'drink' then
			if not player.drinkTime then
				player.drinkTime = 0
			elseif player.drinkTime >= 1 then
				player.action = 'stand'
				player.drinkTime = nil
			else
				player.drinkTime = player.drinkTime + 0.03
			end
		end

		if player.action == 'move' then
			-- Play footsteps
			sManager:walk()
			if not player.moveTime then
				player.moveTime = 0
			elseif player.moveTime >= 1 then
				player.action = 'stand'
				player.moveTime = nil
			else
				player.moveTime = player.moveTime + 0.06
			end
		end
	end

	--spawn drink
	local drink_count = World:tableSize(self.drinks)
	if drink_count < 15 then
		World:spawnDrink()
	end

	sTime = sTime + love.timer.getAverageDelta()
end


function World:decayBAC(id)
	local pbac = self.players[id].bac
	local penalty = 0

	--please enjoy responsibly
	if pbac > 100 then
		self.players[id].loser = true
		return
	end

	if pbac > BAC_THRESHOLD[1] then
		if pbac < BAC_THRESHOLD[2] then
			penalty = BAC_DECAY_RATE[2]
		else
			penalty = BAC_DECAY_RATE[3]
		end
	else
		penalty = BAC_DECAY_RATE[1]
	end

	if (pbac - penalty) < 0 then
		self.players[id].bac = 0
		self.players[id].loser = true
	else
		self.players[id].bac = pbac - penalty
	end

end

function World:addScore(id)
	-- rewarded for playing aggressive
	local pbac = self.players[id].bac
	local pscore = self.players[id].score
	local bonus = pbac

	if pbac > BAC_THRESHOLD[1] then
		if pbac < BAC_THRESHOLD[2] then
			bonus = bonus * SCORE_MULTIPLIER[2]
		else
			bonus = bonus * SCORE_MULTIPLIER[3]
		end
	else
		bonus = bonus * SCORE_MULTIPLIER[1]
	end

	self.players[id].score = math.floor(pscore + bonus)
end

function World:getPlayerScore(id)
	return self.players[id].score
end


function World:draw(pid)
	if self.players[pid].loser == true then
		World:drawGameOver()

		return
	end

	World:calculateOffset(pid)
	if self.bloomStatus then
		love.graphics.setShader(bloomShader)
		bloomShader:send("BAC", World:getPlayerBAC(pid))
		bloomShader:send("cScale", World:getPlayerBAC(pid)*0.003)
		bloomShader:send("eTime", sTime)
		bloomShader:send("bloomStatus", self.bloomStatus)
	end

	World:drawBackground()
	love.graphics.reset()
	love.graphics.setShader()
	World:drawDrinks()
	love.graphics.reset()
	World:drawPlayers()
	love.graphics.reset()
	World:drawHUD(pid)
	love.graphics.reset()
end

function World:calculateOffset(pid)
	-- We want to center the player and move everything, so calculate offset
	local player = self.players[pid]
	local playerPos = player.pos
	local yCenter = math.floor(self.height / (GRID_SIZE * 2))
	local xCenter = math.floor(self.width / (GRID_SIZE * 2))
	local centerPos = Vector(xCenter, yCenter)
	offsetPos = (centerPos - playerPos) * Vector(GRID_SIZE, GRID_SIZE)

	if player.action == "move" then
		local posDiff = (player.pos - player.oldPos) * Vector(GRID_SIZE * (1-player.moveTime), GRID_SIZE * (1-player.moveTime))
		offsetPos = offsetPos + posDiff
	end
end

function World:drawBackground()
	-- Draw the world
	love.graphics.draw(self.mapImage, offsetPos.x, offsetPos.y)

	-- for y, row in pairs(self.world) do
	-- 	for x, item in pairs(row) do
	-- 		if item then
	-- 			if item == "W" then
	-- 				love.graphics.setColor(0, 0, 255, 255)
	-- 			end

	-- 			love.graphics.rectangle("fill", x*GRID_SIZE+offsetPos.x-GRID_SIZE, y*GRID_SIZE+offsetPos.y-GRID_SIZE, GRID_SIZE, GRID_SIZE)
	-- 		end
	-- 	end
	-- end
end

function World:drawDrinks()
	-- Drinks
	love.graphics.reset()
	for id, drink in pairs(self.drinks) do
		World:drawDrink(drink.type, drink.pos, offsetPos)
	end
end

function World:drawDrink(type, pos, offset)
	local drinkImage = Assets:getDrinkImage(type)
	love.graphics.draw(drinkImage, pos.x*GRID_SIZE+offsetPos.x-GRID_SIZE, pos.y*GRID_SIZE+offsetPos.y-GRID_SIZE)
end

function World:drawGameOver()
	love.graphics.draw(Assets:getGameOverImage())
	sManager:stopMusic()
	sManager:startGameOverMusic()
end

function World:drawPlayers()
	-- Players
	--love.graphics.setColor(255, 0, 0, 255)
	for id, player in pairs(self.players) do
		local pos = player.pos
		finalPos = Vector(pos.x*GRID_SIZE+offsetPos.x-GRID_SIZE, pos.y*GRID_SIZE+offsetPos.y-GRID_SIZE)

		if player.action == 'move' then
			local posDiff = (player.pos - player.oldPos) * Vector(GRID_SIZE * player.moveTime, GRID_SIZE * player.moveTime)
			finalPos = Vector(player.oldPos.x*GRID_SIZE+offsetPos.x-GRID_SIZE, player.oldPos.y*GRID_SIZE+offsetPos.y-GRID_SIZE)
			finalPos = finalPos + posDiff
		end

		if finalPos then
			--love.graphics.rectangle("fill", pos.x*GRID_SIZE-GRID_SIZE, pos.y*GRID_SIZE-GRID_SIZE, PSIZE.x, PSIZE.y)
			love.graphics.reset()
			self.players[id].pAnim:draw(finalPos.x, finalPos.y)
		end
	end	
end

function World:handleJukeBox()
	sManager:playNext()
	return sManager:getSong()
end

function World:switchSong(id)
	sManager:playSong(id)
end

function World:drawHUD(pid)
	-- Status
	love.graphics.setColor(154,205,50,255)
	love.graphics.rectangle("fill", 0, self.height - 92, self.width , 92)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print("Drunk-o-meter",self.width*5/8, (self.height - 80)+(92/2), 0, 2, 2)

	-- profile place holder
	love.graphics.reset()
	local profileImage = Assets:getProfileImage(1)
	local playerBAC = World:getPlayerBAC(pid)
	if playerBAC > BAC_THRESHOLD[1] then 
		if playerBAC < BAC_THRESHOLD[2] then
			profileImage = Assets:getProfileImage(2)
		else 
			profileImage = Assets:getProfileImage(3)
		end
	end

	love.graphics.draw(profileImage, 4, self.height - 88)

	-- hand HUD
	local leftHand = self.players[pid].leftHand
	local rightHand = self.players[pid].rightHand

	local leftInvImage = Assets:getLeftHandImage(leftHand+1)
	love.graphics.draw(leftInvImage, 100, self.height - 90)

	local rightInvImage = Assets:getRightHandImage(rightHand+1)
	love.graphics.draw(rightInvImage, 155, self.height - 90)

	--Scores! GOOOOAAAALLLLL
	love.graphics.setColor(0,0,0,255)
	local textHeight = self.height - 90
	for id, player in pairs(self.players) do
		local score = World:getPlayerScore(id)
		love.graphics.print("Player" .. id .. ": " .. score, 225, textHeight)
		textHeight = textHeight + 15
	end

	-- Drunk-o-meter
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", self.width/2, self.height - 88, self.width/2-4 , 92/2 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", (self.width/2)+4, self.height - 84, (self.width/2)-8 , (92/2)-8)

	if playerBAC > BAC_THRESHOLD[1] then 
		if playerBAC < BAC_THRESHOLD[2] then
			love.graphics.setColor(STATUS_GREEN)
			love.graphics.rectangle("fill", (self.width/2)+4, self.height - 84, ((self.width/2)-8)*playerBAC/100 , (92/2)-8)
		else 
			love.graphics.setColor(STATUS_RED)
			love.graphics.rectangle("fill", (self.width/2)+4, self.height - 84, ((self.width/2)-8)*playerBAC/100 , (92/2)-8)
		end
	else
		love.graphics.setColor(STATUS_YELLOW)
		love.graphics.rectangle("fill", (self.width/2)+4, self.height - 84, ((self.width/2)-8)*playerBAC/100, (92/2)-8)
	end

end

function World:setPlayer(id, pos, dir, action)
	if not self.players[id] then
		self.players[id] = {leftHand = 0, 
							rightHand = 0, 
							bac = 30, 
							score = 0,
							loser = false}
	end

	World:addScore(id)

	if not self.players[id].pAnim then
		self.players[id].pAnim = playerAnimation:new(playerAnimation:getColor(id))
		self.players[id].pAnim:init()
	end

	-- set direction and action for animations
	self.players[id].dir = dir
	self.players[id].action = action or 'stand'

	if action == 'move' then
		self.players[id].oldPos = self.players[id].pos or pos
	end

	self.players[id].pos = pos or self.players[id].pos or Vector(0,0)

	return self.players[id].pos

end

function World:setPlayerScore(id, scr)
	self.players[id].score = scr
end

function World:checkIfDrowned(id)
	local pos = self.players[id].pos
	if self.world[pos.y][pos.x] == "P" and self.players[id].bac > BAC_THRESHOLD[2] then
		self.players[id].loser = true
	end
end

function World:inPool(pos)
	return self.world[pos.y][pos.x] == "P"
end

function World:isPossibleMove(pos)
	can_move = true

	for _, player in pairs(self.players) do
		if pos == player.pos then
			can_move = false
			break
		end
	end

	if Map:getWorld()[pos.y][pos.x] == "W" then
		can_move = false
	end

	return can_move
end

function World:removePlayer(id)
	self.players[id] = nil
end

function World:getPlayerPosition(id)
	if self.players[id] then
		return self.players[id].pos or Vector(0,0)
	end
end

function World:getPlayerDirection(id)
	return self.players[id].dir
end

function World:getPlayerBAC(id)
	return self.players[id].bac
end

function World:addToPlayerBAC(id, amt)
	self.players[id].bac = self.players[id].bac + amt
end

function World:isPlayerMoving(id)
	return self.players[id].moveTime ~= nil
end

function World:isPlayerLoser(id)
	return self.players[id].loser
end

function World:drawInventory(dtype, x, y)
	if not dtype == 0 then
		local drinkImage = Assets:getDrinkImage(type)
		love.graphics.draw(drinkImage, x, y)
	end
end

function World:consumeDrink(pid)
	local player = self.players[pid]
	if player.rightHand > 0 then
		--do something with bar
		player.bac = player.bac + DRINK_CONTENT[player.rightHand]
		player.rightHand = 0
		sManager:drink()
	elseif player.leftHand > 0 then
		--do something with bar
		player.bac = player.bac + DRINK_CONTENT[player.leftHand]
		player.leftHand = 0
		sManager:drink()
	end
end

function World:spawnDrink()
	local freeSpace = false
	local newPos = World:randomPos()

	while not freeSpace do
		local randPos = self.world[newPos.y][newPos.x]
		if randPos == 'W' or randPos == 'P' or World:collideItem(newPos) then
			newPos = World:randomPos()
		else
			freeSpace = true
		end
	end

	local drinkType = DRINK_TYPE[math.random(1, DRINK_TYPE_SIZE)]
	
	local d = {}
	d.pos = newPos
	d.type = drinkType

	table.insert(self.drinks, d)
end

function World:randomPos()
	local newX = math.random(1, World:tableSize(self.world[1])-1)
	local newY = math.random(1, World:tableSize(self.world)-1)
	return Vector(newX, newY)
end

function World:collideItem(pos)
	for id, drink in pairs(self.drinks) do
		if pos == drink.pos then
			return true
		end
	end
	return false
end

function World:pickUp(pid, ppos)
	for id, drink in pairs(self.drinks) do
		if ppos == drink.pos then
			-- put drink in inventory, doesn't exist yet
			if self.players[pid].leftHand == 0 then
				self.players[pid].leftHand = drink.type
				table.remove(self.drinks, id)
				sManager:stash()
			elseif self.players[pid].rightHand == 0 then
				self.players[pid].rightHand = drink.type
				table.remove(self.drinks, id)
				sManager:stash()
			end
			--two hands only, don't be greedy
			--table.remove(self.drinks, id)
		end
	end
end

function World:tableSize(tabl)
	local count = 0
	for _ in pairs(tabl) do
		count = count + 1
	end
	return count
end

function World:toggleBloom()
	self.bloomStatus = not self.bloomStatus
end

return World