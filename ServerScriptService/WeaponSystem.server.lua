local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")

local reloadEvent = Instance.new("RemoteEvent")
reloadEvent.Name = "ReloadEvent"
reloadEvent.Parent = RS

local fireEvent = Instance.new("RemoteEvent")
fireEvent.Name = "FireEvent"
fireEvent.Parent = RS

local WEAPONS = {
    {Name = "Пистолет", Damage = 35, FireRate = 0.3, Reload = 1.5, MaxAmmo = 10},
    {Name = "Автомат", Damage = 20, FireRate = 0.1, Reload = 2, MaxAmmo = 10},
    {Name = "Дробовик", Damage = 80, FireRate = 0.8, Reload = 2.5, MaxAmmo = 10},
    {Name = "Снайперка", Damage = 150, FireRate = 1.5, Reload = 3, MaxAmmo = 10},
    {Name = "Нож", Damage = 60, FireRate = 0.5, Reload = 0, MaxAmmo = math.huge, IsMelee = true}
}

local function giveWeapon(player, data)
    local tool = Instance.new("Tool")
    tool.Name = data.Name
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Parent = player.Backpack

    local ammo = Instance.new("IntValue")
    ammo.Name = "Ammo"
    ammo.Value = data.MaxAmmo
    ammo.Parent = tool
    
    local reloading = Instance.new("BoolValue")
    reloading.Name = "Reloading"
    reloading.Value = false
    reloading.Parent = tool
    
    reloadEvent.OnServerEvent:Connect(function(plr, toolName)
        if plr == player and toolName == tool.Name and not reloading.Value and not data.IsMelee then
            reloading.Value = true
            task.wait(data.Reload)
            ammo.Value = data.MaxAmmo
            reloading.Value = false
        end
    end)

    fireEvent.OnServerEvent:Connect(function(plr, toolName)
        if plr ~= player or toolName ~= tool.Name then return end
        if reloading.Value then return end
        if tool.Parent ~= player.Character then return end

        if not data.IsMelee then
            if ammo.Value <= 0 then return end
            ammo.Value -= 1
        end
        
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        RS.PanicEvent:Fire()
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 150, rayParams)
        
        if result then
            local hitPart = result.Instance
            local hitModel = hitPart:FindFirstAncestorOfClass("Model")
            if hitModel and hitModel:FindFirstChild("Humanoid") then
                hitModel.Humanoid:TakeDamage(data.Damage)
                
                local blood = Instance.new("Part")
                blood.Size = Vector3.new(0.3, 0.3, 0.3)
                blood.Color = Color3.fromRGB(120, 0, 0)
                blood.Material = Enum.Material.Neon
                blood.Position = result.Position
                blood.CanCollide = false
                blood.Parent = workspace
                Debris:AddItem(blood, 2)
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        for _, w in ipairs(WEAPONS) do
            giveWeapon(player, w)
        end
    end)
end)
