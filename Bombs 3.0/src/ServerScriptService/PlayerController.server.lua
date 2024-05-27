-- Serviços
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local ProximityPromptService = game:GetService("ProximityPromptService")

-- Eventos e Datastore
local EnemyDefeatBindableEvent = ServerStorage:WaitForChild("Network"):WaitForChild("EnemieDefeat")
local RequestSpeed = ReplicatedStorage:WaitForChild("RequestSpeed")
local RequestPower = ReplicatedStorage:WaitForChild("RequestPower")
local PlayerLoadedRemoteEvent = ReplicatedStorage:WaitForChild("PlayerLoaded")
local database = DataStoreService:GetDataStore("Zombies")

-- Tabela para armazenar dados dos jogadores
local playerData = {}

-- Constantes
local UPGRADE_COST = 10
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0,
	speed = 16,
	power = 25,
}

local function onRequestPowerUpgrade(player)
	local data = playerData[player.UserId]
	if data.gold < UPGRADE_COST then
		print("Dinheiro insuficiente")
		MarketplaceService:PromptProductPurchase(player, 1829727673)
		return
	end
	data.gold -= UPGRADE_COST
	data.power += 1
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

local function onRequestSpeedUpgrade(player)
	local data = playerData[player.UserId]
	if data.gold < UPGRADE_COST then
		print("Dinheiro insuficiente")
		MarketplaceService:PromptProductPurchase(player, 1829727673)
		
		return
	end
	data.gold -= UPGRADE_COST
	data.speed += 1
	local character = player.Character
	if character then
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = data.speed
	end
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

RequestSpeed.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestPower.OnServerEvent:Connect(onRequestPowerUpgrade)

local function onEnemyDefeated(playerId)
	local player = Players:GetPlayerByUserId(playerId)
	if player and playerData[player.UserId] then
		playerData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
		player:SetAttribute("Gold", playerData[player.UserId].gold)
		PlayerLoadedRemoteEvent:FireClient(player, playerData[player.UserId])
	end
end

local function loadPlayerData(player)
	local data = database:GetAsync(player.UserId)
	if not data then
		data = PLAYER_DEFAULT_DATA
	end
	playerData[player.UserId] = data
	player:SetAttribute("Power", data.power)
	player:SetAttribute("Gold", data.gold)
	player:SetAttribute("Speed", data.speed)
end

local function onPlayerAdded(player)
	loadPlayerData(player)
	PlayerLoadedRemoteEvent:FireClient(player, playerData[player.UserId])

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = playerData[player.UserId].speed
		PlayerLoadedRemoteEvent:FireClient(player, playerData[player.UserId])
	end)
end

local function onPlayerRemoving(player)
	database:SetAsync(player.UserId, playerData[player.UserId])
end

local function onPlayerDied(player)
	database:SetAsync(player.UserId, playerData[player.UserId])
	wait(4)  -- Espera alguns segundos para garantir que o jogador ressuscitou
	if player and playerData[player.UserId] then
		loadPlayerData(player)
		PlayerLoadedRemoteEvent:FireClient(player, playerData[player.UserId])
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
EnemyDefeatBindableEvent.Event:Connect(onEnemyDefeated)
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid").Died:Connect(function()
			onPlayerDied(player)
		end)
	end)
end)

MarketplaceService.ProcessReceipt = function (receipt)
	print(receipt)
	
	if receipt.ProductId ==1829727673 then
		 print(receipt.PlayerId)
		 local player = Players:GetPlayerByUserId(receipt.PlayerId)
		playerData[receipt.PlayerId].gold += 1000	
		PlayerLoadedRemoteEvent:FireClient(player, playerData[player.UserId])
	end
end


	

	ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
		print(promptObject)
		print(player)
	MarketplaceService:PromptProductPurchase(player, 1829727673)
		
	end)