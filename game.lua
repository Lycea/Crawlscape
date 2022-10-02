
class_base= require("components.helper.classic")

timer = require("components.helper.timer")
require("components.helper.vector")

require("others.globals")

require("others.game_states")
require("others.keyhandler")

require("components.collision_checker")
require("components.game_objects.static_block")

level_handler = require("components.level_handler")()


assets = require("components.helper.cargo").init("assets")



states = {
	[GameStates.PLAYER_ALIVE] = require("states.playing")(),
	--[GameStates.EDITOR] = require("states.editor"),
	[20] = require("states.menue"),
	--[30] = require("states.roomer")
}



local game = {}


------------------------------------------------
------------------------------------------------






function ini_player()
    --player.pos = vector(0)
    --player.vel = vector(0)
    --player.acc = vector(0)
    player.dim = {width = 16*2,height = 32*2}

    --player.is_crawling = false
    
    --player.vel:add(gravity)
end
function slow_player()
    local slow_perc = 0.01
    table.insert(string_list_distances,"Player speed x: "..player.vel.x)
    table.insert(string_list_distances,"Player speed_vec: "..player.vel:length())
    
    if math.floor( math.abs(player.vel.x*slow_perc)) == 0 then
        player.vel.x = 0
    else
        player.vel.x = math.floor(player.vel.x*slow_perc)
    end
end

function update_player()
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
    --print("Pos y:"..player.pos.y)
    
    --print(player.vel:length())
    if dash_used == true then
		print(dash_timer + dash_time,love.timer.getTime())
      if dash_timer + dash_time <= love.timer.getTime() then
        dash_lines[#dash_lines].stop ={x=player.pos.x,y=player.pos.y}
        no_gravity = false
        dash_used = false
        function dash_stop()
			print("?")
        end
        
        dash_stop()
      end
    end
    
    
end


function init_quads()
  quads.player = {}
  quads.player.stand ={}
  quads.player.stand.left = love.graphics.newQuad(0,0,16,32, assets.player_normal)
  quads.player.stand.right =love.graphics.newQuad(16,0,16,32, assets.player_normal)
  quads.player.jump = love.graphics.newQuad(32,0,16,32, assets.player_normal)



  quads.player.crawl = {}
  quads.player.crawl.left =  love.graphics.newQuad(64,0,32,16, assets.player_crawl)
  quads.player.crawl.right = love.graphics.newQuad(0,0,32,16, assets.player_crawl)
end



function game.load()
  gravity = vector(0,0.5)
  jump = vector(0,-7)
  right = vector(0.3,0)
  left = vector(-0.3,0)
  
  --debug.sethook(hook_start,"cl")
  init_quads()
  ini_player()
  scr_width,scr_height = love.graphics.getDimensions()
  print(scr_width, scr_height)
  
  --init a test object for now
  --testmap...
  if test then
    table.insert(objects,StaticBlock(32*5,scr_height-100,100,100)) -- ground block
    table.insert(objects,StaticBlock(32*5,scr_height-200,50,50)) -- head bonk block
    table.insert(objects,StaticBlock(0,scr_height,scr_width,10* player.dim.height))
    table.insert(objects,StaticBlock(0, scr_height- 70 ,50 , 100))
    table.insert(objects,StaticBlock(100, scr_height- 70 ,50 , 100))

    table.insert(objects,DangerBlock(300, scr_height- 20 ,50 , 100))
  end

  --level_handler:switch_level("start_level")
  level_handler:switch_level("start_level")
  
end




function game.update()
  --check key actions
  string_list_distances ={}
  
  for key,v in pairs(key_list) do
    local action=handle_keys(key)--get key callbacks
    
	  states[game_state]:handle_action(action)
  end

  states[game_state]:update()
  states[game_state]:mouse()
  
  
  
  mouse_event = nil
end


function game.draw()
	states[game_state]:draw()
	
    
  

  
  
  --debug prints 
  love.graphics.print(table.concat(string_list_distances,"\n"),0,0)
  
  
  
  
  if no_gravity == true then
    
    love.graphics.setColor(0.5,0.0,0)
    love.graphics.rectangle("fill",player.pos.x,player.pos.y,32,32)
  
	love.graphics.setColor(1,1.0,1)
  end
  

  
  
end


function game.keyHandle(key,code,r,pressed_)
    --real handling...
    if pressed_ == true then
        key_list[key] = true
        last_key=key
    else
        key_list[key] = nil
    end
end


function game.MouseHandle(x,y,key,t)
    mouse_event = {x=x,y=y,key=key,t=t}
end

function game.MouseMoved(x,y)
    
end


return game