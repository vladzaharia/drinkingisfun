
local ClientConnectState = {}

local socket			= require("socket")
local ClientGameState	= require("ClientGameState")


function ClientConnectState:start()
	self.udp = socket.udp()
	self.udp:settimeout(0)

	self.enteredText = ""
	self.waiting = false
	self.background = love.graphics.newImage("Assets/Screens/StartScreen _Background.png")
	self.drinking = love.graphics.newImage("Assets/Screens/StartWords_Regrets.png")
	self.space = love.graphics.newImage("Assets/Screens/StartWords_Spacebar.png")
	self.arrows = love.graphics.newImage("Assets/Screens/StartWords_DirectionalArrows.png")
	self.enter = love.graphics.newImage("Assets/Screens/StartWords_EnterKey.png")
	self.equals = love.graphics.newImage("Assets/Screens/StartWords_Equals.png")
	self.begin = love.graphics.newImage("Assets/Screens/StartWords_Start.png")
	self.time = 0
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
	self.time = self.time + dt
end

function ClientConnectState:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.background, 0, 0)
	love.graphics.draw(self.enter, 550, 450, nil, 0.5, 0.5)
	love.graphics.draw(self.equals, 600, 450, nil, 0.5, 0.5)
	love.graphics.draw(self.begin, 650, 450, nil, 0.5, 0.5)
	love.graphics.draw(self.drinking, 90, 100 + 20*math.sin(self.time*3))
	love.graphics.draw(self.space, 550, 550, nil, 0.5, 0.5)
	love.graphics.draw(self.arrows, 700, 525, nil, 0.5, 0.5)
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 225, 525, 300, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.enteredText, 387, 550)
	love.graphics.print("Client Connect", 235, 535)
	love.graphics.print("Enter a server address: ", 235, 550)
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


return ClientConnectState