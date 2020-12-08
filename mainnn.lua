WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432 
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 --speed to moviment

--global variables because there is no 'local' in start
Class = require 'Class' --import class
push = require 'push' --import the push.lua file

require 'Ball'
require 'Paddle'

--runs when the game first starts up, only once, used to initialize the game
function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest') --don't let blur in the zoom

    --variables to the font in diferents sizes
    smallFont = love.graphics.newFont("04B_03__.TTF", 8) 
    scoreFont = love.graphics.newFont("04B_03__.TTF", 32)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, --not fullscreen
        vsync = true, --sincronized with monitor
        resizable = false --can't change the window size
    }) --set the size of the window looks retro in a modrn way

    --score variables
    p1Score = 0
    p2Score = 0

    --inital position of rectangles(players) and ball respectively
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20) 
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    ball:reset()

    gameState = 'start'
end

function love.update(dt) --dt = delta time, to standartize speed and frames
    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then --player 1 moviment
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then --player 2 moviment
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else 
        paddle2.dy = 0
    end

    --ball moviment when play
    if gameState == 'play' then 
        ball:update(dt)
    end
end

--when user press some key
function love.keypressed(key)
    if key == "escape" then --quits when esc is pressed
        love.event.quit()
    elseif key == 'enter' or 'return' then --start game whem enter is pressed(return in mac)
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            Ball:reset()
        end
    end
end

--called after update by LOVE, used to draw anything to the screen
function love.draw()
    push:apply('start') --flag that means from here to the end flag all will be in push way(window in load) 
    
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) --set the background color (just go from 0 to 1, so /255 solve this)

    --draw the ball
    ball:render()

    --draw the rectangles left and right respectively
    paddle1.render()
    paddle2.render()

    --setting the font to smallFont
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf(
            "Hello Start State!", --text to render
            0, --starting X (0 since we're going to center it based on width)
            20, --startinf Y (start of the screen, 20 pixels)
            VIRTUAL_WIDTH, -- number of pixels to center width (the entire creen here)
            'center') --alignment mode
    elseif gameState == 'play' then
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, 'center') 
    end
        --setting the font to scoreFont
        love.graphics.setFont(scoreFont) 
        love.graphics.print(p1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) --score in right place
        love.graphics.print(p2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        push:apply('end')
end