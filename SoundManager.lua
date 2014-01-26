local soundManager = {}

function soundManager:new( )
	local sm = {}
	sm.init = soundManager.init
	sm.swallow = love.audio.newSource("Assets/SoundEffects/swallow.wav", "static")
	sm.drink = soundManager.drink
	sm.steps = love.audio.newSource("Assets/SoundEffects/steps.wav", "static")
	sm.walk = soundManager.walk
	sm.music = love.audio.newSource("Music/faitaccompli.wav")
	sm.startMusic = soundManager.startMusic
	return sm
end

--function soundManager:init()
--	local swallow = love.audio.newSource("Assets/SoundEffects/swallow.wav", "static")
	--swallow:setVolume(1.0)

--	music = love.audio.newSource("Music/faitaccompli.wav")
	--music.play()
--end

function soundManager:walk()
	self.steps:play()
end

function soundManager:drink()
	self.swallow:play()
end

function soundManager:startMusic()
	self.music:setVolume(0.7)
	self.music:play()
end

return soundManager