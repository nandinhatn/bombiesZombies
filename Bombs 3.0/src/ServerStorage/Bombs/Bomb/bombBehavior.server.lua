
-- constants

local EXPLOSION_TIME = 2

-- members

local bomb = script.Parent
local owner = bomb:GetAttribute("Owner")
local power = bomb:GetAttribute("Power")
local bombExplodSound = game:GetService("SoundService").Explosion


delay(EXPLOSION_TIME, function()
	local explosion = Instance.new("Explosion")
	explosion.Position = bomb.Position
	
	local random = Random.new()
	local value = random:NextNumber(0.5,2)
	bombExplodSound.Pitch = value
	bombExplodSound:Play()
	explosion.BlastPressure =0
	--explosion.BlastRadius =4
	explosion.Parent = workspace
	local collider = bomb.collider
	collider.Touched:Connect(function()
		
	end)
	
	local parts =collider:GetTouchingParts()
	
	
	local humanoids ={}
	
	for _, part in parts do
		
		local sucess,message = pcall(function()
			local character = part.Parent
			if character then

				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					
					if not humanoids[humanoid] then
						humanoids[humanoid]= true
						humanoid.Health -=power;
						humanoid:SetAttribute("LastDamagedBy", owner)
					end
				end
				
				
				
			end
		end)
		if not sucess then
			warn(message)
		end
		
	end
	bomb:Destroy()
end)