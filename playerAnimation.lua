require("AnAL")

local playerAnimation = {}
local COLORS = {"Red", "Green", "Blue"}
local NUM_COLORS = 3

function playerAnimation:new(player_color)
	local M = {}
	M.init = playerAnimation.init
	M.update = playerAnimation.update
	M.draw = playerAnimation.draw
	M.index = 1
	M.animations = {}
	M.color = player_color
	return M
end

function playerAnimation:init() 
	-- Walk Animations
	local uWalk = love.graphics.newImage("Assets/".. self.color .."/playerUWalk.png")
	local anim1 = newAnimation(uWalk, 57, 57, 0.1, 0)
	anim1:setMode("loop")

	local dWalk = love.graphics.newImage("Assets/".. self.color .."/playerDWalk.png")
	local anim2 = newAnimation(dWalk, 57, 57, 0.1, 0)
	anim2:setMode("loop")	

	local lWalk = love.graphics.newImage("Assets/".. self.color .."/playerLWalk.png")
	local anim3 = newAnimation(lWalk, 57, 57, 0.1, 0)
	anim3:setMode("loop")

	local rWalk = love.graphics.newImage("Assets/".. self.color .."/playerRWalk.png")
	local anim4 = newAnimation(rWalk, 57, 57, 0.1, 0)
	anim4:setMode("loop")

	-- Stand Animations
	local uStand = love.graphics.newImage("Assets/".. self.color .."/playerstandup.png")
	local anim5 = newAnimation(uStand, 57,57,0.1,0)
	anim5:setMode("once")

	local uStand = love.graphics.newImage("Assets/".. self.color .."/playerstanddown.png")
	local anim6 = newAnimation(uStand, 57,57,0.1,0)
	anim6:setMode("once")

	local uStand = love.graphics.newImage("Assets/".. self.color .."/playerstandleft.png")
	local anim7 = newAnimation(uStand, 57,57,0.1,0)
	anim7:setMode("once")

	local uStand = love.graphics.newImage("Assets/".. self.color .."/playerstandright.png")
	local anim8 = newAnimation(uStand, 57,57,0.1,0)
	anim8:setMode("once")

	-- Drink Animations
	local rDrink = love.graphics.newImage("Assets/".. self.color .."/playerDrinkRight.png")
	local anim9 = newAnimation(rDrink, 57, 57, 0.1, 0)
	anim9:setMode("bounce")

	local lDrink = love.graphics.newImage("Assets/".. self.color .."/playerDrinkLeft.png")
	local anim10 = newAnimation(lDrink, 57, 57, 0.1, 0)
	anim10:setMode("bounce")

	-- Swim Animations
	local uSwim = love.graphics.newImage("Assets/".. self.color .."/playerUSwim.png")
	local anim11 = newAnimation(uSwim, 57, 57, 0.1, 0)
	anim11:setMode("loop")

	local dSwim = love.graphics.newImage("Assets/".. self.color .."/playerDSwim.png")
	local anim12 = newAnimation(dSwim, 57, 57, 0.1, 0)
	anim12:setMode("loop")

	local lSwim = love.graphics.newImage("Assets/".. self.color .."/playerLSwim.png")
	local anim13 = newAnimation(lSwim, 57, 57, 0.1, 0)
	anim13:setMode("loop")

	local rSwim = love.graphics.newImage("Assets/".. self.color .."/playerRSwim.png")
	local anim14 = newAnimation(rSwim, 57, 57, 0.1, 0)
	anim14:setMode("loop")

	-- Add them into the animation table
	table.insert(self.animations,anim1)
	table.insert(self.animations,anim2)
	table.insert(self.animations,anim3)
	table.insert(self.animations,anim4)
	table.insert(self.animations,anim5)
	table.insert(self.animations,anim6)
	table.insert(self.animations,anim7)
	table.insert(self.animations,anim8)
	table.insert(self.animations,anim9)
	table.insert(self.animations,anim10)
	table.insert(self.animations,anim11)
	table.insert(self.animations,anim12)
	table.insert(self.animations,anim13)
	table.insert(self.animations,anim14)

end

-- direction: left right up down
-- action: drink stand walk
function playerAnimation:update(direction, action, dt)
	if action == 'drink' then
		if direction =='right' then
			self.index = 9
		else
			self.index = 10
		end
	elseif action == 'walk' or action == 'move' then
		if direction == 'up' then
			self.index = 1
		elseif direction == 'down' then
			self.index = 2
		elseif direction == 'left' then
			self.index = 3
		elseif direction == 'right' then
			self.index = 4
		end
	elseif action == 'stand' then
		if direction == 'up' then
			self.index = 5
		elseif direction == 'down' then
			self.index = 6
		elseif direction == 'left' then
			self.index = 7
		elseif direction == 'right' then
			self.index = 8
		end
	elseif action == 'swim' then
		if direction == 'up' then
			self.index = 11
		elseif direction == 'down' then
			self.index = 12
		elseif direction == 'left' then
			self.index = 13
		elseif direction == 'right' then
			self.index = 14
		end
	end 
	self.animations[self.index]:update(dt)
end

function playerAnimation:draw(x,y)
	self.animations[self.index]:draw(x,y)
end

function playerAnimation:getColor(id)
	return COLORS[(id%NUM_COLORS)+1]
end

return playerAnimation