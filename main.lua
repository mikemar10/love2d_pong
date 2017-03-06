paddle_width = 24
paddle_height = 64
x_1 = 0
x_2 = love.graphics.getWidth() - paddle_width;
y_1 = (love.graphics.getHeight() / 2) - (paddle_height / 2)
y_2 = (love.graphics.getHeight() / 2) - (paddle_height / 2)
score_1 = 0
score_2 = 0

ball_width = 16
ball_height = 16
ball_x = (love.graphics.getWidth() / 2) - (ball_width / 2)
ball_y = (love.graphics.getHeight() / 2) - (ball_height / 2)
ball_vel_x = 0
ball_vel_y = 0
max_ball_vel = paddle_width - 1

paused = false
started = false

function clamp(min, val, max)
    return math.max(min, math.min(val, max))
end

function collides(a_x, a_y, a_w, a_h, b_x, b_y, b_w, b_h)
    return a_x < b_x + b_w and
           b_x < a_x + a_w and
           a_y < b_y + b_h and
           b_y < a_y + a_h
end

function love.load()
    love.window.setTitle("PONG")
    hit_snd = love.audio.newSource("hit.ogg", "static")
    score_snd = love.audio.newSource("score.ogg", "static")
    ball_reset()
end

function ball_reset()
    ball_x = (love.graphics.getWidth() / 2) - (ball_width / 2)
    ball_y = (love.graphics.getHeight() / 2) - (ball_height / 2)
    if math.random() > 0.5 then
        ball_vel_x = 5
    else
        ball_vel_x = -5
    end

    if math.random() > 0.5 then
        ball_vel_y = 5
    else
        ball_vel_y = -5
    end
end

function love.update(dt)
    if not paused and started then
        if love.keyboard.isDown("w") then
            y_1 = y_1 - 10
        elseif love.keyboard.isDown("s") then
            y_1 = y_1 + 10
        end

        if love.keyboard.isDown("up") then
            y_2 = y_2 - 10
        elseif love.keyboard.isDown("down") then
            y_2 = y_2 + 10
        end

        ball_x = ball_x + ball_vel_x
        ball_y = ball_y + ball_vel_y
        y_1 = clamp(0, y_1, love.graphics.getHeight() - paddle_height)
        y_2 = clamp(0, y_2, love.graphics.getHeight() - paddle_height)
        ball_y = clamp(0, ball_y, love.graphics.getHeight() - ball_height)
        
        if ball_x >= (love.graphics.getWidth() - ball_width) then
            score_1 = score_1 + 1
            ball_reset()
            score_snd:play()
        elseif ball_x <= 0 then
            score_2 = score_2 + 1
            ball_reset()
            score_snd:play()
        end

        if ball_y == (love.graphics.getHeight() - ball_height) or ball_y == 0 then
            ball_vel_y = -ball_vel_y
        end

        if collides(x_1, y_1, paddle_width, paddle_height, ball_x, ball_y, ball_width, ball_height) or
        collides(x_2, y_2, paddle_width, paddle_height, ball_x, ball_y, ball_width, ball_height) then
            if ball_vel_x < 0 then
                ball_vel_x = ball_vel_x - 1
            else
                ball_vel_x = ball_vel_x + 1
            end

            if ball_vel_y < 0 then
                ball_vel_y = ball_vel_y - 1
            else
                ball_vel_y = ball_vel_y + 1
            end
            ball_vel_x = -ball_vel_x
            hit_snd:play()
        end
        ball_vel_x = clamp(-max_ball_vel, ball_vel_x, max_ball_vel)
        ball_vel_y = clamp(-max_ball_vel, ball_vel_y, max_ball_vel)
    end
end

function love.draw()
    love.graphics.print(score_1, 0, 0)
    love.graphics.print(score_2, love.graphics.getWidth() - 10)
    love.graphics.rectangle("fill", x_1, y_1, paddle_width, paddle_height)
    love.graphics.rectangle("fill", x_2, y_2, paddle_width, paddle_height)
    love.graphics.rectangle("fill", ball_x, ball_y, ball_width, ball_height)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit(0)
    else
        started = true
    end
end

function love.focus(f)
    if not f then
        paused = true
    else
        paused = false
    end
end