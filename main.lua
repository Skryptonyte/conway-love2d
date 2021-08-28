board = {}
starsInMotion = {}

push = require 'push'
Timer = require 'knife.timer'
game_width = 50
game_height = 50

starCount = 0
starColours = {
    [1] = {1.0,0.0,0.0},
    [2] = {0.0,1.0,0.0},
    [3] = {0.0,0.0,1.0},
    [4] = {1.0,1.0,0.0},
    [5] = {0.537,0.812,0.914}
  }
  
overpopulation = 4
underpopulation = 1
birth = 3
generation = 0
pause = 0

fonts = {['mario_nes'] = love.graphics.newFont("fonts/mariones.ttf",15),
         ['mario_nes_small'] = love.graphics.newFont("fonts/mariones.ttf",11)}
graphics = {['pause'] = love.graphics.newImage("graphics/pause.png")}
sounds = {['discovery'] = love.audio.newSource("sounds/transition.mp3","static"),
          ['pause'] = love.audio.newSource("sounds/dio_time_stop.mp3","static"),
          ['resume'] = love.audio.newSource("sounds/dio_time_resume.mp3","static")}

sounds['discovery']:setLooping(true)
sounds['discovery']:play()
function love.load()
  
  -- Prepare game board
  for i=1,game_height do
    table.insert(board,{});
    for j = 1,game_width do
      table.insert(board[i],0)
    end
  end
  
  push:setupScreen(1080,720,1080,720,{['resizable'] = true});
  
  Timer.every(0.1,function ()  
      doBoardTick() 
      end)

  love.graphics.setDefaultFilter('nearest','nearest',1)
end

function doBoardTick()
  local newBoard = {}
  for i=1,game_height do
    table.insert(newBoard,{});
    for j = 1,game_width do
      table.insert(newBoard[i],0)
    end
  end
  
  for h=1,game_height do
    for w = 1,game_width do
      local neighbours = 0
      
      -- Calculate neighbours
      neighbours = 0
      for cx=-1,1 do
        for cy = -1,1 do
            local neighbourX = ((w-1 + cx) % game_width) + 1
            local neighbourY = ((h-1 + cy) % game_height) + 1
            if (board[neighbourY][neighbourX] == 1 and not (neighbourY == h and neighbourX == w)) then
                neighbours = neighbours + 1
            end
        end
      end 
      
      -- Compute transition rules
      if neighbours >= overpopulation or neighbours <= underpopulation then
        newBoard[h][w] = 0
      
      elseif neighbours == birth then
        newBoard[h][w] = 1
      else 
        newBoard[h][w] = board[h][w]
      end
      
      
    end
  end
  
  generation = generation + 1
  board = newBoard
  
end

function love.keypressed(key,scancode,isrepeat)
  if key == 'r' then
    local newBoard = {}
    for i=1,game_height do
      table.insert(newBoard,{});
      for j = 1,game_width do
        table.insert(newBoard[i],0)
      end
    end
    board = newBoard
  end
  if key == 'o' then
    overpopulation = (overpopulation) % 8 + 1
  end
  if key == 'p' then
    underpopulation = (underpopulation) % 8 + 1
  end
  if key == 'b' then
    birth = (birth) % 8 + 1
  end
  if key == 'space' then
    if pause == 0 then
      sounds['resume']:stop()
      sounds['discovery']:pause()
      sounds['pause']:play()
      pause = 1
    else 
      pause = 0
      sounds['pause']:stop()
      sounds['resume']:play()
      sounds['discovery']:play()
    end
  end
end
function love.update(dt)
  if pause == 1 then
    return
  end
  
  if starCount <= 10000 then
    local star = {x = push:getWidth()+100,y = math.random(0,push:getHeight()),time = math.random(10,20), colour = math.random(1,5)}
    Timer.tween(star['time'],{[star] = {x = -100}})
    table.insert(starsInMotion,star)
    starCount = starCount + 1
  end
  
  
  
  Timer.update(dt)
end
function love.mousepressed(x,y,button,istouch,presses)
  gameX, gameY = push:toGame(x,y)
  
  if (gameX ~= nil and gameY ~= nil) then
    gridX = gameX - 20
    gridY = gameY - 20
    
    gridX = math.floor(gridX / 12) + 1
    gridY = math.floor(gridY / 12) + 1
    
    if (gridX >= 1 and gridX <= game_width and gridY >= 1 and gridY <= game_height) then
      if (board[gridY][gridX] == 0) then
        board[gridY][gridX] = 1
      else
        board[gridY][gridX] = 0
      end
    end
  end
end
function love.resize(w,h)
  push:resize(w,h)
end
function love.draw()
  push:start()
 
  for i,star in pairs(starsInMotion) do
    local colourTable = starColours[star['colour']]
    love.graphics.setColor(colourTable[1],colourTable[2],colourTable[3],1.0)
    love.graphics.rectangle('fill', star['x'],star['y'],3,3)
    if (star['x'] < 0) then
      starsInMotion[i] = nil
      starCount = starCount - 1
    end
  end
  local x = 20
  local y = 20
  for i=1,game_height do
    for j = 1, game_width do
      local dx = (j-1)*12
      local dy = (i-1)*12
      
      if (board[i][j] == 1) then
        love.graphics.setColor(1.0,0.0,0.0,1.0)
        love.graphics.rectangle('fill',x+dx,y+dy,10,10)
      else
        love.graphics.setColor(0.0,0.2314,0.649,1.0)
        love.graphics.rectangle('fill',x+dx,y+dy,10,10)
      end
      love.graphics.setLineWidth(2)
      
      love.graphics.setColor(0.678,0.847,0.902,1.0)
      love.graphics.rectangle('line',x+dx,y+dy,10,10)
    end
  end

  love.graphics.setColor(1.0,1.0,1.0,1.0)
  
  love.graphics.setFont(fonts['mario_nes'])
  love.graphics.printf("Generation: "..tostring(generation),400,20,push:getWidth() - 100,'center')
  
  love.graphics.setFont(fonts['mario_nes_small'])
  love.graphics.printf("Overpopulation [O]: \n"..tostring(overpopulation),push:getWidth()-300,100,300,'center')
  
    love.graphics.setFont(fonts['mario_nes_small'])
  love.graphics.printf("Underpopulation [P]: \n"..tostring(underpopulation),push:getWidth()-300,150,300,'center')
  
  love.graphics.setFont(fonts['mario_nes_small'])
  love.graphics.printf("Reproduction [B]: \n"..tostring(birth),push:getWidth()-300,200,300,'center')
  
  love.graphics.setFont(fonts['mario_nes_small'])
  love.graphics.printf("Pause Game [SPACE]",push:getWidth()-300,400,300,'center')
  love.graphics.setFont(fonts['mario_nes_small'])
  love.graphics.printf("Reset Board [R]",push:getWidth()-300,420,300,'center')
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  if (pause == 1) then
    love.graphics.draw(graphics['pause'],push:getWidth()-300, push:getHeight() - 100,0,0.5,0.5)
  end
  push:finish()
end