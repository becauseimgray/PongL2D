--Pong Created in LOVE2D
--By Becauseimgray
--https://github.com/becauseimgray

require("AnAL")
require("TEsound")
function love.load()
  --loading gamestates
  gamestate = "NoPlay" --title screen
   -- Create animation.
   local img  = love.graphics.newImage("title_4x10.png") --loading animation
   anim = newAnimation(img, 250, 98, 0.1, 0) -- animation loaded
   anim:setMode("loop") --loop mode animation


                                      --Refer to Conf.lua for more information
  screen_width = love.window.getWidth()
  screen_height = love.window.getHeight()

  soundlist = { -- table of pong sounds
    "pong1.mp3",
    "pong2.mp3",
    "pong3.mp3",
    "pong4.mp3",
    "pong5.mp3",
    "pongbad.mp3",
    "pong7.mp3",
    "pong8.mp3",
    "pong9.mp3",
    "pong10.mp3",
  }

    --create bg
    background = love.graphics.newImage('bg.png')
                                        --Create Player
    PadHeight = 70
    PadWidth = 10
    PadX = 40
    PadY = (screen_width / 2) - (PadHeight / 2)
    PadSpeed = 400

    --Create Scores
    PadScore = 10
    EnemyScore = 10


                                        --Create Enemy
    EnemyWidth = 10
    EnemyHeight = 70
    EnemyPadX = (screen_width - 40)
    EnemyPadY = (screen_width) / (EnemyHeight / 2)
    EnemySpeed = 150

                                        --Create Ball
    ballh = 8
    ballw = 8
    ballx = (screen_width / 2)
    bally = (screen_height / 2)
    ballSpeed = 200
    ballSpeedx = -ballSpeed
    ballSpeedy = ballSpeed
     -- reset the game
    reset = false

    highscore = 0




end

function love.draw()
if gamestate == "NoPlay" then
    love.graphics.setNewFont("Digital_tech.otf", 15)
    love.graphics.print('Press ENTER to begin.', 180, 200)
    anim:draw(screen_width / 4, 100)
  end
if gamestate == "Play" then
  love.graphics.draw(background, rectangle)
  love.graphics.print(PadScore, 2,2)
  love.graphics.print(EnemyScore, screen_width - 20, 2)
  love.graphics.rectangle('fill', PadX, PadY, PadWidth, PadHeight)
  love.graphics.rectangle('fill', ballx, bally, ballw, ballh)
  love.graphics.rectangle('fill', EnemyPadX, EnemyPadY, EnemyWidth, EnemyHeight)
end

                                        --Losing/Winning/Tie Gamestate menus
  if gamestate == "PlayerWin" then
    love.graphics.print('You win. Press Del or Backspace to try again.', 80, screen_height / 2)
  end

  if gamestate == "PlayerLose" then
    love.graphics.print('You lost. Press Del or Backspace to try again.', 80, screen_height / 2)
  end

  if gamestate == "tie" then
    love.graphics.print('Tie. Press Del or Backspace to try again.', 80, screen_height / 2)
  end

end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2) -- Creating Collision Function for later usage
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.update(dt)

  TEsound.cleanup() --Gets rid of sounds not needed

  if reset == true then
    ballx = (screen_width / 2)
    bally = (screen_height / 2)
    ballSpeed = 200
    PadScore = 10
    EnemyScore = 10
    reset = false
  end

  if gamestate == "NoPlay" then
      anim:update(dt)
      if love.keyboard.isDown('enter','return') then
        gamestate = "Play"
      end
  end
  --back to menu
if love.keyboard.isDown('delete','backspace') then
    gamestate = "NoPlay"
    reset = true
end
                                      --Player Loses
if PadScore == highscore then
  gamestate = 'PlayerLose'
  reset = true
  if love.keyboard.isDown('delete','backspace') then
    gamestate = "NoPlay"
  end
end
                                      --Player wins
if EnemyScore == highscore then
    reset = true
    gamestate = "PlayerWin"
  if love.keyboard.isDown('delete','backspace') then
    gamestate = "NoPlay"
  end
end
                                      --Tie
if EnemyScore == highscore and PadScore == highscore then
    gamestate = "tie"
    reset = true
  if love.keyboard.isDown('delete','backspace') then
    gamestate = "NoPlay"
  end
end



if gamestate == "Play" then

                                        --Controls Player(Paddle 1)'s Movement
  if love.keyboard.isDown('w') then
    PadY = PadY - (PadSpeed * dt)
  end
  if love.keyboard.isDown('s') then
    PadY = PadY + (PadSpeed * dt)
  end
                                        --Controls Enemy AI
  if bally >= EnemyPadY then
    EnemyPadY = EnemyPadY + (EnemySpeed * dt)
  end

  if bally <= EnemyPadY then
    EnemyPadY = EnemyPadY - (EnemySpeed * dt)
  end

                                          --Player stays on-screen
  if PadY < 0 then
      PadY = 0
  elseif (PadY + PadHeight) > screen_height then
      PadY = screen_height - PadHeight
  end
                                          --Enemy stays on-screen
  if EnemyPadY < 0 then
      EnemyPadY = 0
  elseif (EnemyPadY + EnemyHeight) > screen_height then
      EnemyPadY = screen_height - PadHeight
  end

                                        --Ball mechanics
  ballx = ballx + (ballSpeedx * dt)
  bally = bally + (ballSpeedy * dt)

                                        --Ball bounces on top/bottom of screen
  if bally < 0 then
      ballSpeedy = math.abs(ballSpeedy)
  elseif (bally + ballh) > screen_height then
      ballSpeedy = -math.abs(ballSpeedy)
  end

                                        --Ball bounces on sides of screen
  if ballx < 0 then
      ballSpeedx = math.abs(ballSpeedx)
      PadScore = PadScore -1
      TEsound.play(soundlist)
  elseif (ballx + ballw) > screen_width  then
      ballSpeedx = -math.abs(ballSpeedx)
      EnemyScore = EnemyScore - 1
      TEsound.play(soundlist)
  end
                                        --Check if ball collides with player
  if CheckCollision(ballx,bally,ballw,ballh,
  PadX, PadY, PadWidth, PadHeight) then
  ballSpeedx = math.abs(ballSpeedx)
  ballSpeed = ballSpeed + 10
  TEsound.play(soundlist)
  end
                                          --Check if ball collides with enemy
  if CheckCollision(ballx,bally,ballw,ballh,
  EnemyPadX, EnemyPadY, EnemyWidth, EnemyHeight) then
  ballSpeedx = -math.abs(ballSpeedx)
  ballSpeed = ballSpeed + 10
  TEsound.play(soundlist)
  end
end
end
