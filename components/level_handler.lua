local level_handler = class_base:extend()





level_handler.map_config={
    start_level = {
        [1] = {"second_level", 1}
    },
    second_level = {
        [1]= {"start_level",1},
        [2]= {"third_level",2}
    },

    third_level ={
        [2]= {"second_level",2},
        [1]= {"fourth_level",1}
    },

    fourth_level={
        [2]= {"corridor",4},
        [1]= {"third_level",1}
    },

    corridor ={
        [1]= {"fourth_level",2},
        [2]= {"repeat",1},
        [3]= {"gate_room",1},
        [4]= {"repeat",2}
    },

    ["repeat"] ={
        [1]= {"fifth_level",2},
        [2]= {"repeat",1},
        [3]= {"start_level",1},
        [4]= {"repeat",2},
    },

    fifth_level ={
        [1] = {"key_level",1},
        [2] = {"fifth_level", 2}
    },

    
    ["key_level"] ={
        [1]  = {"corridor", 4}
    },

    gate_room={
        [2] ={"corridor", 3},
        [1] ={"TODO SPLIT ROOM", 1}
    }

}



local function load_level(level_name)
    raw_chunk = love.filesystem.load("assets/levels/"..level_name..".txt")
    return raw_chunk()
end



function level_handler:new()
    self.level_name = nil
    self.level_raw  = nil

    self.current_spawn = nil

    self.spawn_pos = vector(0,0)
end


function level_handler:set_player_to_spawn()
    player.dim = {width = 64, height= 32}
    player.pos = vector(self.spawn_pos.x, self.spawn_pos.y)

    player.vel = vector(0) 
    player.acc = vector(0) 

    player.vel:add(gravity)
    player.is_crawling = true    
end


function level_handler:switch_level(level_name,spawn_id)
    on_window_switch = true

    port_ids = 1
    spawn_ids = 1

    objects ={}
    player = {}

    spawn_id = spawn_id or 1

    local spawns_ ={}

    print("-------------------------------")
    self.level_name = level_name
    self.level_raw  = load_level(level_name)

    for _, object in pairs(self.level_raw[1]) do
        if object[1] =="Solid"  then 
            table.insert( objects, StaticBlock(object.x, object.y, object.w,object.h) )
        elseif object[1] == "Spawn" then
            print("found a spawn...")

            --self.spawn_pos = vector(object.x,object.y)

            table.insert( objects,  SpawnBlock(object.x,object.y,object.w,object.h,spawn_ids) )
           
            
            spawns_[spawn_ids] = object
            spawn_ids= spawn_ids+1

            --self:set_player_to_spawn()
        elseif object[1]== "Door" then
            table.insert( objects, PortBlock(object.x, object.y, object.w,object.h,port_ids) ) 
            port_ids = port_ids + 1
        elseif object[1]=="Spike" then
            print("found spike")
            table.insert( objects, DangerBlock(object.x, object.y, object.w,object.h) )
        end
    end


    --finalize spawn setting
    print("Spawn id",spawn_id)
    self.spawn_pos = vector(spawns_[spawn_id].x, spawns_[spawn_id].y)
    self:set_player_to_spawn()

    print("still switching...")
    states[GameStates.PLAYER_ALIVE].__uncrawl()
    on_window_switch = false
    print("switching done")

    love.window.setTitle( level_name )

end


function level_handler:reset_level()
    on_window_switch = true
    self:set_player_to_spawn()
    states[GameStates.PLAYER_ALIVE].__uncrawl()
    on_window_switch = false
end

return level_handler