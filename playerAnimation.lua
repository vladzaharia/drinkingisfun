require("AnAL")

local playerAnimation = {}
local animations = {}
local index = 1

function playerAnimation:init() 
	-- Walk Animations
	local uWalk = love.graphics.newImage("Assets/Red/playerUWalk.png")
	anim1 = newAnimation(uWalk, 57, 57, 0.1, 0)
	anim1:setMode("loop")

	local dWalk = love.graphics.newImage("Assets/Red/playerDWalk.png")
	anim2 = newAnimation(dWalk, 57, 57, 0.1, 0)
	anim2:setMode("loop")	

	local lWalk = love.graphics.newImage("Assets/Red/playerLWalk.png")
	anim3 = newAnimation(lWalk, 57, 57, 0.1, 0)
	anim3:setMode("loop")

	local rWalk = love.graphics.newImage("Assets/Red/playerRWalk.png")
	anim4 = newAnimation(rWalk, 57, 57, 0.1, 0)
	anim4:setMode("loop")

	-- Stand Animations
	local uStand = love.graphics.newImage("Assets/Red/playerstandup.png")
	anim5 = newAnimation(uStand, 57,57,0.1,0)
	anim5:setMode("once")

	local uStand = love.graphics.newImage("Assets/Red/playerstanddown.png")
	anim6 = newAnimation(uStand, 57,57,0.1,0)
	anim6:setMode("once")

	local uStand = love.graphics.newImage("Assets/Red/playerstandleft.png")
	anim7 = newAnimation(uStand, 57,57,0.1,0)
	anim7:setMode("once")

	local uStand = love.graphics.newImage("Assets/Red/playerstandright.png")
	anim8 = newAnimation(uStand, 57,57,0.1,0)
	anim8:setMode("once")

	-- Drink Animations
	local rDrink = love.graphics.newImage("Assets/Red/playerDrinkRight.png")
	anim9 = newAnimation(rDrink, 57, 57, 0.1, 0)
	anim9:setMode("bounce")

	local lDrink = love.graphics.newImage("Assets/Red/playerDrinkLeft.png")
	anim10 = newAnimation(lDrink, 57, 57, 0.1, 0)
	anim10:setMode("bounce")

	-- Add them into the animation table
	table.insert(animations,anim1)
	table.insert(animations,anim2)
	table.insert(animations,anim3)
	table.insert(animations,anim4)
	table.insert(animations,anim5)
	table.insert(animations,anim6)
	table.insert(animations,anim7)
	table.insert(animations,anim8)
	table.insert(animations,anim9)
	table.insert(animations,anim10)

end

-- direction: left right up down
-- action: drink stand walk
function playerAnimation:update(direction, action, dt)
	if action == 'drink' then
		if direction =='right' then
			index = 9
		else
			index = 10
		end
	elseif action == 'walk' then
		if direction == 'up' then
			index = 1
		elseif direction == 'down' then
			index = 2
		elseif direction == 'left' then
			index = 3
		elseif direction == 'right' then
			index = 4
		end
	elseif action == 'stand' then
		if direction == 'up' then
			index = 5
		elseif direction == 'down' then
			index = 6
		elseif direction == 'left' then
			index = 7
		elseif direction == 'right' then
			index = 8
		end
	end 
	animations[index]:update(dt)
end

function playerAnimation:draw(x,y)
	animations[index]:draw(x,y)
end

return playerAnimation