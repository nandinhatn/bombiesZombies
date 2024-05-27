-- escuta os botões pressionados pelo jogador e executa uma ação


--so roda para o client só para o jogador


local UserInputService = game:GetService("UserInputService")

local drobBomRemoveEvent = game:GetService("ReplicatedStorage").DropBomb

local ContextActionService = game:GetService("ContextActionService")

local ACTION_KEY = Enum.KeyCode.F
local GAMEPAG_ACTION_KEY = Enum.KeyCode.ButtonR1

local function verifyBombs()
	local bombsQuantity = #workspace.Bombs:GetChildren()
	if bombsQuantity > 0 then
		print("tem bombas ", bombsQuantity)
		 return false
		 
	else 
		print("nao tem bombas",bombsQuantity)
		return true
		
	end
end
local function drobBomb()
	
	
	
	print(verifyBombs())
	if  verifyBombs() then
		drobBomRemoveEvent:FireServer()
	end

	
	
	
end

UserInputService.InputBegan:Connect(function(input:InputObject, gameProcess:boolean)
	
	if input.KeyCode == ACTION_KEY then
		 drobBomb()
	end
end)

--ContextActionService:BindAction("dropBomb", nil, true, ACTION_KEY, GAMEPAG_ACTION_KEY )
--ContextActionService:SetPosition("Interact", UDim2.new(1,-70,0,10))
--ContextActionService:SetTitle()