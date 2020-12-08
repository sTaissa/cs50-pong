Paddle = Class{}

function Paddle:init(x, y, width, height) --constructor
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0
end

function Paddle:update(dt) --moviment player paddle
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt) --add a paddle speed to current Y scaled by dt, where the maximum is 0 to don't pass the limit of the window
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height) 
end