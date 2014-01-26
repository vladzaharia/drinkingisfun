local Assets = {}

local LEFT_HAND_FILE_NAME = {'Assets/Profile/left_hand_empty_noback.png',
							'Assets/Profile/left_hand_beer_brown_noback.png',
							'Assets/Profile/left_hand_beer_green_noback.png',
							'Assets/Profile/left_hand_ice_noback.png',
							'Assets/Profile/left_hand_purple_shot_noback.png',
							'Assets/Profile/left_hand_tequila_shot_noback.png',
							'Assets/Profile/left_hand_wine_noback.png'}

local RIGHT_HAND_FILE_NAME = {'Assets/Profile/right_hand_empty_noback.png',
							'Assets/Profile/right_hand_beer_brown_noback.png',
							'Assets/Profile/right_hand_beer_green_noback.png',
							'Assets/Profile/right_hand_ice_noback.png',
							'Assets/Profile/right_hand_purple_shot_noback.png',
							'Assets/Profile/right_hand_tequila_shot_noback.png',
							'Assets/Profile/right_hand_wine_noback.png'}

local DRINK_FILE_NAME = {'Assets/drinks/beerBrown.png',
						 'Assets/drinks/beerGreen.png',
						 'Assets/drinks/ice.png',
						 'Assets/drinks/shotJello.png',
						 'Assets/drinks/shotTequila.png',
						 'Assets/drinks/wine.png'}

-- Types of profiles
local PROFILE_FILE_NAME = {	'Assets/Profile/portraitSober.png',
							'Assets/Profile/portraitTipsy.png',
							'Assets/Profile/portraitDrunk.png'}

local GAME_OVER_SCREEN = 'Assets/Screens/GameOver.png'

Assets.gameOverImage = love.graphics.newImage(GAME_OVER_SCREEN)
Assets.leftHandImage = {
	love.graphics.newImage(LEFT_HAND_FILE_NAME[1]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[2]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[3]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[4]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[5]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[6]),
	love.graphics.newImage(LEFT_HAND_FILE_NAME[7]),
}
Assets.rightHandImage = {
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[1]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[2]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[3]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[4]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[5]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[6]),
	love.graphics.newImage(RIGHT_HAND_FILE_NAME[7]),
}
Assets.drinkImage = {
	love.graphics.newImage(DRINK_FILE_NAME[1]),
	love.graphics.newImage(DRINK_FILE_NAME[2]),
	love.graphics.newImage(DRINK_FILE_NAME[3]),
	love.graphics.newImage(DRINK_FILE_NAME[4]),
	love.graphics.newImage(DRINK_FILE_NAME[5]),
	love.graphics.newImage(DRINK_FILE_NAME[6]),
}
Assets.profileImage = {
	love.graphics.newImage(PROFILE_FILE_NAME[1]),
	love.graphics.newImage(PROFILE_FILE_NAME[2]),
	love.graphics.newImage(PROFILE_FILE_NAME[3]),
}

function Assets:getGameOverImage()
	return self.gameOverImage
end

function Assets:getLeftHandImage(index)
	return self.leftHandImage[index]
end

function Assets:getRightHandImage(index)
	return self.rightHandImage[index]
end

function Assets:getDrinkImage(index)
	return self.drinkImage[index]
end

function Assets:getProfileImage(index)
	return self.profileImage[index]
end

return Assets