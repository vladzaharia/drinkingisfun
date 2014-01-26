local soundManager = {}

function soundManager:new( )
	local sm = {}
	sm.init = soundManager.init
	sm.swallow = love.audio.newSource("Assets/SoundEffects/swallow.wav", "static")
	sm.drink = soundManager.drink
	sm.steps = love.audio.newSource("Assets/SoundEffects/steps.wav", "static")
	sm.walk = soundManager.walk
	sm.pickup = love.audio.newSource("Assets/SoundEffects/pickup.wav", "static")
	sm.stash = soundManager.stash
	sm.music = love.audio.newSource("Music/faitaccompli.wav")
	sm.music:setLooping(true)
	sm.startMusic = soundManager.startMusic
	sm.smeagle = love.audio.newSource("Music/Smeagle.wav")
	return sm
end

function soundManager:walk()
	self.steps:play()
end

function soundManager:drink()
	self.swallow:play()
end

function soundManager:stash()
	self.pickup:play()
end

function soundManager:startMusic()
	self.music:setVolume(0.7)
	self.music:play()
end

function soundManager:stopMusic()
	self.music:stop()
end

function soundManager:gameOver()
	self.smeagle:setVolume(0.7)
	self.smeagle:play()
end

return soundManager