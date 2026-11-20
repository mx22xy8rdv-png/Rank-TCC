local RS = game:GetService("ReplicatedStorage")
local gui = script.Parent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 1
frame.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, 0, 0.2, 0)
text.Position = UDim2.new(0, 0, 0.4, 0)
text.BackgroundTransparency = 1
text.Text = "СМЕРТЬ НЕИЗБЕЖНА"
text.TextColor3 = Color3.fromRGB(255, 0, 0)
text.TextScaled = true
text.Font = Enum.Font.FredokaOne
text.Visible = false
text.Parent = frame

RS:WaitForChild("DeathEvent").OnClientEvent:Connect(function()
    frame.BackgroundTransparency = 0
    text.Visible = true
    task.wait(5)
    game.Players.LocalPlayer:LoadCharacter()
    frame.BackgroundTransparency = 1
    text.Visible = false
end)
