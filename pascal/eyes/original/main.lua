---EYE STUFF
eye = {}
local em = {__index = eye}

local function angle(x1, y1, x2, y2)
	return math.atan2(y2-y1, x2-x1)
end

local function distance(x1, y1, x2, y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5
end

local function normal(val, min, max)
	return (val - min) / (max - min)
end

function eye.new(x, y, radius, irisRadius, irisColor, pupilDilation)
	local e = {
		x = x,
		y = y,
		dx = x,
		dy = y,
		ix = x,
		iy = y,
		dix = x,
		diy = y,
		radius = radius,
		irisRadius = irisRadius,
		irisColor = irisColor,
		pupilDilation = pupilDilation,
		blinkProgress = 1
	}
	return setmetatable(e, em)
end

function eye:update(dt)
	self.dix = self.dix + (self.ix - self.dix) * 16 * dt
	self.diy = self.diy + (self.iy - self.diy) * 16 * dt
end

function eye:blink()
	self.blinkProgress = 0
end

function eye:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", self.x, self.y, self.radius)

	love.graphics.setColor(self.irisColor)
	love.graphics.circle("fill", self.dix, self.diy, self.irisRadius)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.circle("fill", self.dix, self.diy, self.irisRadius * self.pupilDilation)
end

function eye:look(x, y)
	local a = angle(self.x, self.y, x, y)
	local d = distance(self.x, self.y, x, y)
	if d > self.radius then d = self.radius end

	self.ix = self.x + (self.radius - self.irisRadius) * (normal(d, 0, self.radius)) * math.cos(a)
	self.iy = self.y + (self.radius - self.irisRadius) * (normal(d, 0, self.radius)) * math.sin(a)
end

--Rest of the shit
function love.load()
	love.window.setMode(800, 600, {msaa = 8} )
	screen = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}
	math.randomseed(os.time() + love.mouse.getX())
	love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
	love.mouse.setVisible(false)
	space = 50
	radius = 32
	color = {math.random(), math.random(), math.random()}
	e = {
		eye.new( (screen.width / 2) - space, (screen.height / 2), radius, radius / 2, color, 0.4 ),
		eye.new( (screen.width / 2) + space, (screen.height / 2), radius, radius / 2, color, 0.4 )
	}
	mx = 0
	my = 0
	h = 0

	blink = 0
	blinkTick = 0
	blinkFrequency = {2, 10}
	nBlink = math.random(blinkFrequency[1], blinkFrequency[2])

	mood = "happy" --happy, concerned, sad

	dist = 0
end

function love.update(dt)
	h = h + 100 * dt
	if h > 255 then h = 0 end
	
	dist = distance(love.mouse.getX(), love.mouse.getY(), screen.width / 2, screen.height / 2)

	if dist > radius * 8 then
		mood = "happy"
	elseif dist > radius * 4 then
		mood = "concerned"
	else
		mood = "sad"
	end

	blinkTick = blinkTick + dt
	if blinkTick > nBlink then
		blinkTick = 0
		nBlink = math.random(blinkFrequency[1], blinkFrequency[2])
		blink = 1
	end

	blink = blink + (0 - blink) * 16 * dt

	mx = mx + (love.mouse.getX() - mx) * 16 * dt
	my = my + (love.mouse.getY() - my) * 16 * dt

	for i,v in ipairs(e) do
		v:update(dt)
		v:look(love.mouse.getX(), love.mouse.getY())
	end
end

function love.draw()
	love.graphics.setColor(232 / 255, 209 / 255, 171 / 255)
	love.graphics.circle("fill", screen.width / 2, screen.height / 2, radius * 4)

	love.graphics.setColor(0, 0, 0)
	if mood == "happy" then
		love.graphics.arc("fill", screen.width / 2, screen.height * 0.58, radius * 1.5, 0, math.pi )
	elseif mood == "concerned" then
		love.graphics.ellipse("fill", screen.width / 2, screen.height * 0.62, radius, radius / 2)
	elseif mood == "sad" then
		love.graphics.arc("fill", screen.width / 2, screen.height * 0.65, radius * 1.5, math.pi, math.pi * 2)
	end

	for i,v in ipairs(e) do
		v:draw()
	end

	--Eyelid
	love.graphics.setColor(232 / 255, 209 / 255, 171 / 255)
	love.graphics.rectangle("fill", (screen.width / 2) - space - radius, screen.height / 2 - radius, (radius * 2) + (space * 2), (radius * 3) * blink)

	love.graphics.setColor(hsl(h, 255, 126))
	love.graphics.circle("fill", mx, my, 8)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
	for i,v in ipairs(e) do
		v:update(dt)
		v:look(x, y)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == "space" then love.load() end
	if key == "f1" then
		love.graphics.captureScreenshot(os.time()..".png")
	end
	if key == "b" then blink = 1 end
end

function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m),(g+m),(b+m),a
end
