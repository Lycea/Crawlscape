StaticBlock =class_base:extend()


function StaticBlock:new(x,y,width,height)
	self.type = "static"
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = true
    self.collides = true
end

function StaticBlock:draw()
    love.graphics.setColor(87/255, 81/255, 97/255)
    love.graphics.rectangle("fill",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.setColor(100/255, 100/255, 100/255)
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.setColor(1,1,1)
end



DangerBlock =class_base:extend()


function DangerBlock:new(x,y,width,height)
	self.type = "kill"
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = true
    self.collides = true
end

function DangerBlock:draw()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.setColor(1,1,1)
end




GhostBlock =StaticBlock:extend()
function GhostBlock:new(x,y,width,height)
	self.type = "ghost"
	
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
	
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = false
end

function GhostBlock:draw()
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
end






PortBlock =GhostBlock:extend()
function PortBlock:new(x,y,width,height,port_id)
    self.id = port_id
	self.type = "port"
	
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
	
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = false
end

function PortBlock:draw()
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.print(self.id,self.pos.x+ self.dim.width/2,self.pos.y+ self.dim.height/2) 
end



SpawnBlock =GhostBlock:extend()
function SpawnBlock:new(x,y,width,height,id)
	self.id = id
    self.type = "spawn"
	
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
	
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = false
end

function SpawnBlock:draw()
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.print(self.id,self.pos.x + self.dim.width/2,self.pos.y + self.dim.height/2) 
end



CollectibleBlock =GhostBlock:extend()
function CollectibleBlock:new(x,y,width,height,name)
	self.name = name
    self.type = "collectible"
	
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
	
    self.dim = {}
    self.dim.width  = width
    self.dim.height = height
    
    self.moves = false
    self.blocks = false
end

function CollectibleBlock:draw()
    love.graphics.rectangle("line",self.pos.x,self.pos.y,self.dim.width,self.dim.height)
    love.graphics.print(self.name,self.pos.x + self.dim.width/2,self.pos.y + self.dim.height/2) 
end

