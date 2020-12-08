WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432 
VIRTUAL_HEIGHT = 243

push = require 'push' --import the push.lua file

--runs when the game first starts up, only once, used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') --don't let blur in the zoom

    smallfont = love.graphics.newFont("04B_03__.TTF", 8) --variable to the font in size 8
    love.graphics.setFont(smallfont) --setting the font to that

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, --not fullscreen
        vsync = true, --sincronized with monitor
        resizable = false --can't change the window size
    }) --set the size of the window looks retro in a modrn way
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
    love.graphics.rectangle('fill', 5, 20, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    love.graphics.printf(
        "Hello World!", --text to render
         0, --starting X (0 since we're going to center it based on width)
        20, --startinf Y (start of the screen, 20 pixels)
        VIRTUAL_WIDTH, -- number of pixels to center width (the entire creen here)
        'center') --alignment mode

        push:apply('end')
end