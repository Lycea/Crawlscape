
local Playing = class_base:extend()

local function ini_player()
    --player.pos = vector(0)
    --player.vel = vector(0)
    --player.acc = vector(0)
    --player.dim = {width = 32,height = 32}
    
    player.vel:add(gravity)
end
local function slow_player()
    local slow_perc = 0.01
    table.insert(string_list_distances,"Player speed x: "..player.vel.x)
    table.insert(string_list_distances,"Player speed_vec: "..player.vel:length())
    table.insert(string_list_distances,"Player x:  "..player.pos.x)
    table.insert(string_list_distances,"Player y:  "..player.pos.y)
    
    if math.floor( math.abs(player.vel.x*slow_perc)) == 0 then
        player.vel.x = 0
    else
        player.vel.x = math.floor(player.vel.x*slow_perc)
    end
end



local function test_crawl_collision(obj)
  print("hi")

  local max_x = 10
  local max_y = 10
 
 
  obj.vel.x = math.max(math.min(player.vel.x,10),-10)
   --if player.vel.x > max_x then
   --  player.vel.x = max_x
     --print("Length after adjustation:"..player.vel:length())
   --end
   
   obj.vel.y = math.max(math.min(obj.vel.y,10),-10)
   
   if obj.vel.y > max_y then
    obj.vel.y = max_y
   end


  obj.pos:add(player.vel)
  collisions = handle_collisions(obj)
  if collisions["top"] or collisions["left"] or collisions["right"] then
    return false
  end
  return true
end


local function crawl_player()
  check_obj = {
    dim={width=player.dim.height, height=player.dim.width},
    pos = player.pos:copy(),
    vel = player.vel:copy()
  }

  check_obj.pos.y = check_obj.pos.y -player.dim.height/2
  if test_crawl_collision( check_obj ) == true then

    player.is_crawling = true

    orig_height = player.dim.height
    orig_width = player.dim.width

    player.dim.width = orig_height
    player.dim.height = orig_width

    player.pos.y = player.pos.y + orig_height/2
  end
end

local function uncrawl_player()
  check_obj = {
    dim={width=player.dim.height, height=player.dim.width},
    pos = player.pos:copy(),
    vel = player.vel:copy()
  }

  print("pos",player.pos.x,player.pos.y)
  print(player.is_crawling)
  check_obj.pos.y = check_obj.pos.y -player.dim.width/2
  if test_crawl_collision( check_obj ) == true then
    print("uncrawled player...")
    player.is_crawling = false

    orig_height = player.dim.height
    orig_width = player.dim.width

    player.dim.width = orig_height
    player.dim.height = orig_width

    player.pos.y = player.pos.y - orig_width/2
  end
end

Playing.__uncrawl =uncrawl_player
local function update_player()
   local max_x = 10
   local max_y = 10
  
  
    player.vel.x = math.max(math.min(player.vel.x,10),-10)
    --if player.vel.x > max_x then
    --  player.vel.x = max_x
      --print("Length after adjustation:"..player.vel:length())
    --end
    
    player.vel.y = math.max(math.min(player.vel.y,10),-10)
    
    if player.vel.y > max_y then
      player.vel.y = max_y
    end
    
    
    player.pos:add(player.vel)
    --local location_object =is_on_object(player)
    handle_collisions(player)
    
    if player.vel.y ~=0 or no_gravity == false then
       player.vel:add(gravity)
    end
    if player.vel.x ~= 0 and no_gravity == false then
        slow_player()
    end
end





function Playing:new()
	
end


function Playing:load()
  gravity = vector(0,0.3)
  jump = vector(0,-7)
  right = vector(0.3,0)
  left = vector(-0.3,0)
  
  --debug.sethook(hook_start,"cl")
  
  self:ini_player()
  scr_width,scr_height = love.graphics.getDimensions()
  
  --init a test object for now
  
  table.insert(objects,StaticBlock(32*5,scr_height-100,100,100))
  table.insert(objects,StaticBlock(0,scr_height,scr_width,10* player.dim.height))
  
end


function Playing:handle_action(action)
--check key actions
  string_list_distances ={}
  

    
    
    --editor actions ... don't mind this
    if action["start_edit"] then
        game_state = GameStates.EDITOR
    end
    
    
    
    if action["move"] then
        --print(action["move"])
        player.vel:add(action["move"])

        last_dir = action["move"].x >0 and "right" or "left"
    end

    
    if action["jump"] and is_on_object(player) then
        player.vel:add(action["jump"])
        player.vel:add(vector(10,0))
    end
    
    if action["toggle_crawl"] and crawl_timer:check() then
      print("toogled crawl...")
      if player.is_crawling then
        uncrawl_player()
      else
        crawl_player()
      end
     
    end


  
  
end

function Playing:update()
	update_player()

  if kill_player == true then
    print(kill_player)
    print("kill")

    level_handler:reset_level()
    kill_player = false
    --player.pos.x = 0
    --player.pos.y = 0
  end

      --TODO: remove
      --player.pos.x = 0
      --player.pos.y = 50
end
function Playing:draw()
	for idx,object in pairs(objects) do
        object:draw()
  end
  
  if assets[level_handler.level_name] then
    love.graphics.draw(assets[level_handler.level_name])
  end


	--love.graphics.rectangle("fill",player.pos.x,player.pos.y,player.dim.width,player.dim.height)
  love.graphics.push()
  love.graphics.scale(2,2)
  if not player.is_crawling then
    love.graphics.draw(assets.player_normal,
                       quads.player.stand[last_dir],
                       player.pos.x/2, player.pos.y/2)
  else
    love.graphics.draw(assets.player_crawl,
                       quads.player.crawl[last_dir],
                      player.pos.x /2,player.pos.y/2)
  end
  love.graphics.pop()
end

function Playing:mouse()
	
end


function Playing:unload()
	
end

return Playing
