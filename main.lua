WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432 
VIRTUAL_HEIGHT = 243

push = require 'push' --import the push.lua file

--runs when the game first starts up, only once, used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') --don't let blur in the zoom

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

    love.graphics.printf(
        "Hello World!", --text to render
         0, --starting X (0 since we're going to center it based on width)
        VIRTUAL_HEIGHT / 2 - 6, --startinf Y (halfway down the screen)
        VIRTUAL_WIDTH, -- number of pixels to center width (the entire creen here)
        'center') --alignment mode

        push:apply('end')
end