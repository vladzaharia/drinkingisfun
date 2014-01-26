
local DisconnectManager = { peers = {} }

local TIMEOUT_DELAY = 5


function DisconnectManager:update(dt)
	for client_desc, time in pairs(self.peers) do
		self.peers[client_desc] = time+dt
	end
end

function DisconnectManager:reachedPeer(client_desc)
	self.peers[client_desc] = 0
end

function DisconnectManager:disconnectedPeer(client_desc)
	self.peers[client_desc] = nil
end

function DisconnectManager:timedOutPeers()
	local key = nil
	return function()
		key = next(self.peers, key)
		while key and self.peers[key] < TIMEOUT_DELAY do
			key = next(self.peers, key)
		end
		return key
	end
end

function DisconnectManager:disconnectedTimedOutPeers()
	for desc, time in pairs(self.peers) do
		if time > TIMEOUT_DELAY then
			self.peers[desc] = nil
		end
	end
end


return DisconnectManager