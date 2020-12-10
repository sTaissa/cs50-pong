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
    math.randomseed(os.time()) --using the count of time to random things

    love.graphics.setDefaultFilter('nearest', 'nearest') --using the nearest neighbor function to zoom the image(letters) without bluring it

    love.window.setTitle("Pong") --title of the window

    smallFont = love.graphics.newFont('04B_03__.TTF', 8) --add the font as an object
    scoreFont = love.graphics.newFont('04B_03__.TTF', 32) -- add a larger font
    victoryFont = love.graphics.newFont('04B_03__.TTF', 24)

    sounds = {
        ['paddleHit'] = love.audio.newSource('paddleHit.wav', 'static'),
        ['pointScored'] = love.audio.newSource('pointScored.wav', 'static'),
        ['wallHit'] = love.audio.newSource('wallHit.wav', 'static')
    }

    player1score = 0
    player2score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2 --random pointing to some player 
    winningPlayer = 0 --no one has already won

    --initial value of player1 and player2
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT -30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / -2, 5, 5)

    ball:reset()

    if servingPlayer == 1 then --making sure the velocity is te right side(the side of the player that scores)
        ball.dx = 100
    else 
        ball.dx = -100
    end

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
    if gameState == 'play' then 

        --updating the score
        if ball.x <= 0 then --player2 points
            player2score = player2score + 1
            servingPlayer = 1
            sounds['pointScored']:play()
            ball:reset()
            
            if player2score >= 2 then
                gameState = 'victory'
                winningPlayer = 2
            else 
                gameState = 'serve'
            end
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then --player1 points
            player1score = player1score + 1
            servingPlayer = 2
            sounds['pointScored']:play()
            ball:reset()
            
            if player1score >= 2 then
                gameState = 'victory'
                winningPlayer = 1
            else 
                gameState = 'serve'
            end
        end

        --ball reflection
        if ball:collides(paddle1) then
            ball.dx = -ball.dx --deflect ball to the right
            ball.x = paddle1.x + 5

            sounds['paddleHit']:play() --sound when ball colides with the paddle
        end
        if ball:collides(paddle2) then
            ball.dx = -ball.dx --deflect ball to the left
            ball.x = paddle2.x - 4

            sounds['paddleHit']:play()
        end

        --detect upper and lower screen boundary collision and reverse if collised
        if ball.y <= 0 then
            ball.dy = -ball.dy --deflect the ball down
            ball.y = 0 --solve bug of being y above 0 in slow pc

            sounds['wallHit']:play()
        end
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.dy = -ball.dy --deflect the ball up
            ball.y = VIRTUAL_HEIGHT - 4

            sounds['wallHit']:play()
        end

        --player 1 movement
        if love.keyboard.isDown('w') then
            paddle1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        --player 2 movement
        if love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end

        ball:update(dt) --ball movement
        paddle1:update(dt) --paddle1 movement
        paddle2:update(dt) --paddle2movement
    end
end

function love.keypressed(key) --function to quit when esc pressed(once its execute)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1score = 0
            player2score = 0
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

function love.draw() --draw something in the screen, after it was updated 

    push:apply('start') --like a flag to indicate that until the 'end' flag thing will goint to be draw in push way

    --set the background to another color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) --notice that is divided by 255 because the newrest versions of love takes color from 0 to 1, not 0 to 255

    --set the fonts to their right places
    love.graphics.setFont(smallFont) 

    --draw the state messages 
    if gameState == 'start' then 
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to begin!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to serve!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press enter to restart!", 0, 42, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --draw the ball in the middle
    ball:render()

    --draw the paddles(rectangles), left and right respectively
    paddle1:render()
    paddle2:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20) --.. is concatenating string
    love.graphics.setColor(1, 1, 1, 1)
end