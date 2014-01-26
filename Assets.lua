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

function Assets:getGameOverImage()
	return love.graphics.newImage(GAME_OVER_SCREEN)
end

function Assets:getLeftHandImage(index)
	return love.graphics.newImage(LEFT_HAND_FILE_NAME[index])
end

function Assets:getRightHandImage(index)
	return love.graphics.newImage(RIGHT_HAND_FILE_NAME[index])
end

function Assets:getDrinkImage(index)
	return love.graphics.newImage(DRINK_FILE_NAME[index])
end

function Assets:getProfileImage(index)
	return love.graphics.newImage(PROFILE_FILE_NAME[index])
end

return Assets