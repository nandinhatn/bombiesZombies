-- acessa o serverStorage
-- services
local ServerStorage = game:GetService("ServerStorage");


--constants 

 local 	ENEMY_POPULACTION = 3
-- members 
local enemies:Folder= ServerStorage.Enemies

local zombie:Model = enemies:FindFirstChild("Zombie")
local spanwnEnemies:folder = workspace.spawnEnemies


-- move o zombie para o workspace
-- deixa na pasta como um template

local function spawnZombie()
	-- Clona o Zombie
	local zombieClone:Model = zombie:Clone()
	-- move o zombie

	zombieClone.Parent = spanwnEnemies
end

-- adiciona os primeiros inimigos no mundo
for count =1, ENEMY_POPULACTION do
	spawnZombie()
end

-- controle populacional  - inicia a verificação para controlar a po

while true do
	wait(1)
	print(#spanwnEnemies:GetChildren())
	local population = #spanwnEnemies:GetChildren()
	
	if population < ENEMY_POPULACTION then
		spawnZombie()
	end
end