-- services

local Players = game:GetService("Players")

-- members
local zombie = script.Parent
local humanoid:Humanoid = zombie.Humanoid
local EnemyDefeatedBindableEvent= game:GetService("ServerStorage").Network.EnemieDefeat

local connection:RBXScriptSignal


connection = humanoid.Died:Connect(function()
	
	local playerId = humanoid:GetAttribute("LastDamagedBy")

	local player = Players:GetPlayerByUserId(playerId)

	
	EnemyDefeatedBindableEvent:Fire(playerId)
	connection:Disconnect()
end)


