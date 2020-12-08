WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432 
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 --speed to moviment

push = require 'push' --import the push.lua file

--runs when the game first starts up, only once, used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') --don't let blur in the zoom

    --variables to the font in diferents sizes
    smallFont = love.graphics.newFont("04B_03__.TTF", 8) 
    scoreFont = love.graphics.newFont("04B_03__.TTF", 32)

    p1Score = 0
    p2Score = 0

    --inital position of rectangles(players)
    p1Y = 30 
    p2Y = VIRTUAL_HEIGHT - 40

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, --not fullscreen
        vsync = true, --sincronized with monitor
        resizable = false --can't change the window size
    }) --set the size of the window looks retro in a modrn way
end

function love.update(dt)
    if love.keyboard.isDown('w') then --player 1 moviment
        p1Y = p1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        p1Y = p1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then --player 2 moviment
        p2Y = p2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        p2Y = p2Y + PADDLE_SPEED * dt
    end
end

--quits when esc is pressed
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--called after update by LOVE, used to draw anything to the screen
function love.draw()
    push:apply('start') --flag that means from here to the end flag all will be in push way(window in load) 
    
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) --set the background color (just go from 0 to 1, so /255 solve this)

    --draw the ball
    love.graphics.rectangle(
        'fill', --ball is filled(preenchida)
        VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, --in the middle of the screen(divided by half of the size makes right in center)
        4, 4) --size of 5 pixels

    --draw the rectangles left and right respectively
    love.graphics.rectangle('fill', 10, p1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, p2Y, 5, 20)

    --setting the font to smallFont
    love.graphics.setFont(smallFont)
    love.graphics.printf(
        "Hello World!", --text to render
         0, --starting X (0 since we're going to center it based on width)
        20, --startinf Y (start of the screen, 20 pixels)
        VIRTUAL_WIDTH, -- number of pixels to center width (the entire creen here)
        'center') --alignment mode

        --setting the font to scoreFont
        love.graphics.setFont(scoreFont) 
        love.graphics.print(p1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) --score in right place
        love.graphics.print(p2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        push:apply('end')
end