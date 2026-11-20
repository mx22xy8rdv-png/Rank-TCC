local player = game.Players.LocalPlayer
local gui = script.Parent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BackgroundTransparency = 1
frame.Parent = gui

local function bind(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(function(hp)
        if hp < humanoid.MaxHealth then
            frame.BackgroundTransparency = 0.4
            task.wait(0.15)
            frame.BackgroundTransparency = 1
        end
    end)
end

if player.Character then bind(player.Character) end
player.CharacterAdded:Connect(bind)
