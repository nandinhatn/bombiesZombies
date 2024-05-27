local PlayerLoadedRemoteEvent = game:GetService("ReplicatedStorage").PlayerLoaded

local RequestSpeed = game:GetService("ReplicatedStorage").RequestSpeed
local RequestPower = game:GetService("ReplicatedStorage").RequestPower

local Players = game:GetService("Players")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("Hud").Frame
print(hud)
local addPowerButton:TextButton = hud:WaitForChild("addPower")
local addSpeedButton:TextButton = hud:WaitForChild("addSpeed")

local gold:TextLabel = hud:WaitForChild("goldValue")
print(gold)
local  powerTag:TextLabel = hud:WaitForChild("power")
local speedTag:TextLabel = hud:WaitForChild("speed")

PlayerLoadedRemoteEvent.OnClientEvent:Connect(function(data)
print("chamou", data)
print(speedTag)
	gold.Text= data.gold
	--powerTag.text = data.power
	--speedTag.Text = data.speed
	powerTag.Text = data.power
	speedTag.Text = data.speed
	
	
end)

addPowerButton.MouseButton1Click:Connect(function()
	print("upgrade power")
	RequestPower:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	print("upgrade speed")
	RequestSpeed:FireServer()
end)