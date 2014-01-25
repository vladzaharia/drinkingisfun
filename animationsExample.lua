require("AnAL")

local animations = {}
local index = 1

function  love.load(  )
	-- Walk Animations
	local uWalk = love.graphics.newImage("playerUWalk.png")
	anim1 = newAnimation(uWalk, 57, 57, 0.1, 0)
	anim1:setMode("loop")

	local dWalk = love.graphics.newImage("playerDWalk.png")
	anim2 = newAnimation(dWalk, 57, 57, 0.1, 0)
	anim2:setMode("loop")
	

	local lWalk = love.graphics.newImage("playerLWalk.png")
	anim3 = newAnimation(lWalk, 57, 57, 0.1, 0)
	anim3:setMode("loop")
	

	local rWalk = love.graphics.newImage("playerRWalk.png")
	anim4 = newAnimation(rWalk, 57, 57, 0.1, 0)
	anim4:setMode("loop")

	-- Drink Animations
	local rDrink = love.graphics.newImage("playerDrinkRight.png")
	anim5 = newAnimation(rDrink, 57, 57, 0.3, 0)
	anim5:setMode("bounce")

	local lDrink = love.graphics.newImage("playerDrinkLeft.png")
	anim6 = newAnimation(lDrink, 57, 57, 0.3, 0)
	anim6:setMode("bounce")

	-- Add them into the animation table
	table.insert(animations,anim1)
	table.insert(animations,anim2)
	table.insert(animations,anim3)
	table.insert(animations,anim4)
	table.insert(animations,anim5)
	table.insert(animations,anim6)

end

function love.update(dt)
	-- Check keyboard input
	if love.keyboard.isDown("w") then
		index = 1
	end
	if love.keyboard.isDown("s") then
		index = 2
	end
	if love.keyboard.isDown("a") then
		index = 3
	end
	if love.keyboard.isDown("d") then
		index = 4
	end
	if love.keyboard.isDown(" ") then
		index = 5
	end

	-- Updates the animation (Enables frame changes)
	animations[index]:update(dt)
end

function love.draw()
	-- Draw the animation at (100,100)
	animations[index]:draw(200,200)
end

