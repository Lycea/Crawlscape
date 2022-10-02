
globals ={}

function globals.default_ini()
    
end

quads = {}


level_handler = nil

objects = {}
player ={}

no_gravity = false

gravity = vector(0,15)
jump = vector(0,-10)
right = vector(4,0)
left = vector(-4,0)

last_dir="right"

kill_player = false

on_window_switch = false

scr_width=0
scr_height=0

game_state = 1

last_keys ={}


crawl_timer=timer(0.1)


---debug stuff
string_list_distances ={}




