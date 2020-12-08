WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 --pixels per second 

Class = require 'class' --any variable without local firts are global, can be acces in anywhere, include other files like Paddle
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load() --basical love function to initialize the game
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest') --using the nearest neighbor function to zoom the image(letters) without bluring it

    smallFont = love.graphics.newFont('04B_03__.TTF', 8) --add the font as an object
    scoreFont = love.graphics.newFont('04B_03__.TTF', 32) -- add a larger font

    player1score = 0
    player2score = 0

    --initial value of player1 and player2
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT -30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / -2, 5, 5)

    ball:reset()

    gameState = 'start'

    --initialize the window with a virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, --no fullscreen, just a window
        vsync = true, --syncronyze with the monitor
        resizable = false --can't resize the window
    })
end

--function to move the rectangles(while is pressed or 'down')
function love.update(dt) --dt = delta time, to standardize speed and frames

    paddle1:update(dt)
    paddle2:update(dt)

    --player 1 moviment
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    --player 2 moviment
    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    --ball moviment
    if gameState == 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key) --function to quit when esc pressed(once its execute)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ball:reset()
        end
    end
end

function love.draw() --draw something in the screen, after it was updated 

    push:apply('start') --like a flag to indicate that until the 'end' flag thing will goint to be draw in push way

    --set the background to another color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) --notice that is divided by 255 because the newrest versions of love takes color from 0 to 1, not 0 to 255

    --set the fonts to their right places
    love.graphics.setFont(smallFont) 
    if gameState == 'start' then
        love.graphics.printf('Hello Start State', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf('Hello Play State', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --draw the ball in the middle
    ball:render()

    --draw the paddles(rectangles), left and right respectively
    paddle1:render()
    paddle2:render()

    push:apply('end')
end