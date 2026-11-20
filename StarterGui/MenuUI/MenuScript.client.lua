local player = game.Players.LocalPlayer
local gui = script.Parent

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.4
bg.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.Text = "ТОРГОВЫЙ ЦЕНТР"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.FredokaOne
title.Parent = bg

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.3, 0, 0.1, 0)
btn.Position = UDim2.new(0.35, 0, 0.6, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0.7
btn.Text = "ИГРАТЬ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextScaled = true
btn.Font = Enum.Font.FredokaOne
btn.Parent = bg

btn.MouseButton1Click:Connect(function()
    bg:Destroy()
end)
