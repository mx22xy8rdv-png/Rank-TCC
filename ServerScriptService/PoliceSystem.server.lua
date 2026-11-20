local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local policeSpawned = false

RS:WaitForChild("PanicEvent").Event:Connect(function()
    if policeSpawned then return end
    policeSpawned = true
    
    task.wait(600) -- 10 минут (600 секунд)
    
    -- Спавн полиции
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local police = Instance.new("Model")
        police.Name = "Police"
        
        local pHrp = Instance.new("Part")
        pHrp.Name = "HumanoidRootPart"
        pHrp.Size = Vector3.new(2, 2, 1)
        pHrp.Transparency = 1
        pHrp.CanCollide = false
        pHrp.Parent = police
        
        local pTorso = Instance.new("Part")
        pTorso.Name = "Torso"
        pTorso.Size = Vector3.new(2, 2, 1)
        pTorso.Color = Color3.fromRGB(0, 0, 150) -- Синяя форма
        pTorso.Parent = police
        
        local pHead = Instance.new("Part")
        pHead.Name = "Head"
        pHead.Shape = Enum.PartType.Ball
        pHead.Size = Vector3.new(1, 1, 1)
        pHead.Color = Color3.fromRGB(255, 220, 180)
        pHead.Parent = police

        local weld = Instance.new("Weld")
        weld.Part0 = pHrp
        weld.Part1 = pTorso
        weld.Parent = pHrp
        
        local humanoid = Instance.new("Humanoid")
        humanoid.Parent = police
        humanoid.WalkSpeed = 18
        
        police.PrimaryPart = pHrp
        police.Parent = workspace
        
        pHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -50) -- Спавн в 50 стадах от игрока
        
        humanoid:MoveTo(hrp.Position)
        
        -- Логика стрельбы
        task.spawn(function()
            while police.Parent and char.Parent do
                local dist = (hrp.Position - pHrp.Position).Magnitude
                if dist < 20 then
                    humanoid:MoveTo(hrp.Position)
                    task.wait(0.2)
                    if math.random() < 0.5 then
                        -- Попадание
                        char.Humanoid:TakeDamage(100)
                        RS.DeathEvent:FireClient(player)
                        break
                    end
                else
                    humanoid:MoveTo(hrp.Position)
                end
                task.wait(0.5)
            end
        end)
    end
end)
