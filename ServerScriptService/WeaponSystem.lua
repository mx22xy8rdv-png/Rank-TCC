local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local WEAPONS = {
    {Name = "Пистолет", Type = "Gun", Damage = 35, FireRate = 0.3, Reload = 1.5, MaxAmmo = 10, Color = Color3.fromRGB(50, 50, 50)},
    {Name = "Автомат", Type = "Gun", Damage = 20, FireRate = 0.1, Reload = 2, MaxAmmo = 10, Color = Color3.fromRGB(30, 30, 30)},
    {Name = "Дробовик", Type = "Gun", Damage = 80, FireRate = 0.8, Reload = 2.5, MaxAmmo = 10, Color = Color3.fromRGB(80, 50, 20)},
    {Name = "Снайперка", Type = "Gun", Damage = 150, FireRate = 1.5, Reload = 3, MaxAmmo = 10, Color = Color3.fromRGB(20, 60, 20)},
    {Name = "Нож", Type = "Melee", Damage = 60, FireRate = 0.5, Reload = 0, MaxAmmo = math.huge, Color = Color3.fromRGB(200, 200, 200)}
}

local function giveWeapon(player, weaponData)
    local tool = Instance.new("Tool")
    tool.Name = weaponData.Name
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Parent = player.Backpack

    local ammo = Instance.new("IntValue")
    ammo.Name = "Ammo"
    ammo.Value = weaponData.MaxAmmo
    ammo.Parent = tool

    local reloading = Instance.new("BoolValue")
    reloading.Name = "Reloading"
    reloading.Value = false
    reloading.Parent = tool
    
    local lastFire = 0

    tool.Activated:Connect(function()
        if reloading.Value then return end
        if tick() - lastFire < weaponData.FireRate then return end
        lastFire = tick()

        if weaponData.Type == "Gun" then
            if ammo.Value <= 0 then
                reloading.Value = true
                task.wait(weaponData.Reload)
                ammo.Value = weaponData.MaxAmmo
                reloading.Value = false
                return
            end
            ammo.Value -= 1
            
            -- Оповещаем NPC о выстреле (шлем сигнал в GameManager)
            game.ReplicatedStorage:FindFirstChild("GunshotEvent"):Fire()
        end
        
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 150, rayParams)
        
        if result then
            local hitPart = result.Instance
            local hitModel = hitPart:FindFirstAncestorOfClass("Model")
            if hitModel and hitModel:FindFirstChild("Humanoid") then
                hitModel.Humanoid:TakeDamage(weaponData.Damage)
                
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
