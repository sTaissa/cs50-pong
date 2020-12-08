Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --ball direction and speed in x and y
    self.dx = math.random(2) == 1 and -100 or 100 --random right or left and speed of 100
    self.dy = math.random(-50, 50) --random between it gives us many angles
end

function Ball:reset()
    --initial value of ball
    self.x = VIRTUAL_WIDTH / 2 - 2 --its '-2' because it is on middle, but projected to right and the half of the ball size solve this
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50) 
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt --the ball place + his speed an direction
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, 4, 4) 
end