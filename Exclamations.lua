local Exclamation = {}

function Exclamation:new()
	local E = {}
	E.polite = {
		"Nice place!",	"This is lovely", "I'm having fun", "Small talk",
		"I need this",	"Very nice",	"So cool!",	"Need drink", "Got beer?",
		"Good song"
	}
	E.happy = {
		"That's what she said!", "Keep em coming!", "Baha so good!", "No! Yes! No!",
		"Did I say that out loud?", "mhmmmm", "Yea boi!" 
	}
	E.ruined = {
		"F*** me", "*hicup*", "Nononough", "he he hurgh", "Why'd you shleev me!?", "Come back hurr",
		"BROOOO", "Nice Sheos", "Whur urm I??", "DAT ***"
	}

	E.niceQuote = Exclamation.niceQuote
	E.tipsyQuote = Exclamation.tipsyQuote
	E.drunkQuote = Exclamation.drunkQuote

	math.randomseed( os.time() )

	return E
end

function Exclamation:niceQuote()
	return self.polite[math.random(10)]
end

function Exclamation:tipsyQuote()
	return self.happy[math.random(8)]
end

function Exclamation:drunkQuote()
	return self.ruined[math.random(10)]
end
