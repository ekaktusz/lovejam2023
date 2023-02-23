local Checkpoint = Object:extend()
local activeCheckpoints = {}

function Checkpoint:new(x, y)
    

end

function Checkpoint:draw()

end

function Checkpoint.spawnCheckpoints()
    for i,a in ipairs(Game.map.layers.checkpoints.objects) do
		local amphora = Checkpoint(a.x, a.y)
        table.insert(Checkpoint, amphora)
	end
end

return Checkpoint