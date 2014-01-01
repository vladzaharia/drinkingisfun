module("ClientConnectState", package.seeall)

local socket			= require("socket")
local ClientGameState	= require("ClientGameState")


function ClientConnectState:start()
	self.udp = socket.udp()
	self.udp:settimeout(0)

	self.enteredText = ""
	self.waiting = false
end

function ClientConnectState:stop()
	self.udp = nil
	self.enteredText = nil
	self.waiting = nil
end

function ClientConnectState:update(dt)
	if self.waiting then
		local data, msg = self.udp:receive()
		if data and data:match("regd ") ~= 1 then
			-- Connection established!
			print("Connected! reponse=" .. data)
			local id, x,y = data:match("regd (%w+) (%S+),(%S+)")
			return ClientGameState, { id = tonumber(id),
				pos = Vector( tonumber(x), tonumber(y) ),
				udp = self.udp }
		else
			assert(msg=="timeout", "Unexpected network error, msg=" .. msg)
		end
	end
end

function ClientConnectState:draw()
	love.graphics.print("Client Connect", 10, 10)
	love.graphics.print("Enter a server address: ", 10, 30)
	love.graphics.print(self.enteredText, 10, 50)
end

function ClientConnectState:key(key, action)
	if key == Keys.Enter and action == 'p' then
		-- send connection request to the entered address
		local ip = self.enteredText
		if ip == "" then
			ip = "127.0.0.1" -- Default if nothing entered
		end
		self.udp:setpeername(ip, SERVER_PORT)
		local result, err = self.udp:send("reg")
		assert(result ~= nil, "Network error: result=" .. result .. " err=" .. 
			(err or "none"))
		self.waiting = true
	elseif action == 're' or action == 'p' then
		if key == Keys.Backspace then
			self.enteredText = self.enteredText:sub(1, self.enteredText:len()-1)
		elseif Keys.tostring(key):len() == 1 then
			self.enteredText = self.enteredText .. Keys.tostring(key)
		end
	end
end

function ClientConnectState:mousePos(x,y)
end

function ClientConnectState:mouse(key, action)
end
