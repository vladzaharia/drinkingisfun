local soundManager = {}

function soundManager:new( )
	local sm = {}
	sm.playlist = {}
	sm.init = soundManager.init
	sm.swallow = love.audio.newSource("Assets/SoundEffects/swallow.wav", "static")
	sm.drink = soundManager.drink
	sm.steps = love.audio.newSource("Assets/SoundEffects/steps.wav", "static")
	sm.walk = soundManager.walk
	sm.pickup = love.audio.newSource("Assets/SoundEffects/pickup.wav", "static")
	sm.stash = soundManager.stash

	sm.startMusic = soundManager.startMusic
	sm.stopMusic = soundManager.stopMusic
	sm.startGameOverMusic = soundManager.startGameOverMusic
	sm.smeagle = love.audio.newSource("Music/Smeagle.wav")

	sm.playNext = soundManager.playNext
	sm.getSong = soundManager.getSong
	sm.playSong = soundManager.playSong

	sm.index = 1
	return sm
end

function soundManager:init()
	-- Load the music files
	local music1 = love.audio.newSource("Music/faitaccompli.wav")
	music1:setLooping(true)
	local music2 = love.audio.newSource("Music/rock.wav")
	music2:setLooping(true)
	music2:setVolume(0.5)
	local music3 = love.audio.newSource("Music/smoothjazz.wav")
	music3:setLooping(true)
	local music4 = love.audio.newSource("Music/smeagle.wav")
	music4:setLooping(true)
	music4:setVolume(0.2)
	local music5 = love.audio.newSource("Music/sunshine.wav")
	music5:setLooping(true)

	table.insert(self.playlist,music1)
	table.insert(self.playlist,music2)
	table.insert(self.playlist,music3)
	table.insert(self.playlist,music4)
	table.insert(self.playlist,music5)
end

function soundManager:playNext()
	-- Stop current song
	self.playlist[self.index]:stop()

	-- Increment index
	if self.index == 5 then
		self.index = 1
	else
		self.index = self.index + 1
	end

	-- Play next song
	self.playlist[self.index]:play()
end

function soundManager:playSong(id)
	local id = tonumber(id)

	if id <= 5 then
		-- Play next song
		self.playlist[self.index]:stop()
		self.index = id
		self.playlist[self.index]:play()
	end
end

function soundManager:getSong()
	return self.index
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
	self.playlist[self.index]:play()
	--self.music:setVolume(0.7)
	--self.music:play()
end

function soundManager:stopMusic()
	--self.music:pause()
	self.playlist[self.index]:pause()
end

function soundManager:startGameOverMusic()
	self.smeagle:setVolume(0.2)
	self.smeagle:play()
end

return soundManager