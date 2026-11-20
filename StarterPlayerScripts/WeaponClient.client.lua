local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local fireEvent = RS:WaitForChild("FireEvent")
local reloadEvent = RS:WaitForChild("ReloadEvent")

-- Перезарядка на ПК по кнопке R
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                reloadEvent:FireServer(tool.Name)
            end
        end
    end
end)

local lastFire = 0
local function onToolActivated(tool)
    local char = player.Character
    if not char then return end
    
    local ammo = tool:FindFirstChild("Ammo")
    local reloading = tool:FindFirstChild("Reloading")
    
    if ammo and reloading then
        if ammo.Value <= 0 and not reloading.Value then
            reloadEvent:FireServer(tool.Name)
            return
        end
    end
    
    if not reloading or not reloading.Value then
        fireEvent:FireServer(tool.Name)
    end
end

local function setupTool(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            onToolActivated(tool)
        end)
    end
end

local function setupCharacter(char)
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            setupTool(item)
        end
        backpack.ChildAdded:Connect(setupTool)
    end
    
    for _, item in ipairs(char:GetChildren()) do
        setupTool(item)
    end
    char.ChildAdded:Connect(setupTool)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)
