WINDOW_WIDTH = 1280 --captalize indicates constants
WINDOW_HEIGHT = 720

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, --not fullscreen
        vsync = true, --sincronized with monitor
        resizable = false --can't change the window size
    }) --set the size of the window
end

function love.draw()
    love.graphics.printf("Hello World!", 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, 'center')
end