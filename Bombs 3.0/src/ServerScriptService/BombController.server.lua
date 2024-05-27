local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

-- Members 

local bombFolder:Folder = game:GetService("ServerStorage").Bombs

local bombTemplate:Model = bombFolder.Bomb



dropBombRemoteEvent.OnServerEvent:Connect( function(player:Player)
	
	local bomb = bombTemplate:Clone()
	bomb.CFrame = player.Character.PrimaryPart.CFrame * CFrame.new(0,-1,0)
	bomb.collider.CFrame = bomb.CFrame 
	bomb:SetAttribute("Owner", player.UserId)
	print("atributo power",player:GetAttribute("Power"))
	bomb:SetAttribute("Power", player:GetAttribute("Power"))
	bomb.Parent = workspace.Bombs
	
end)