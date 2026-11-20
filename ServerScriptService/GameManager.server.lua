local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")

local NPC_COUNT = 100
local EXIT_POSITION = Vector3.new(0, 5, 150) -- УКАЖИ КООРДИНАТЫ ВЫХОДА
local npcs = {}

-- Лица (Decals)
local FACE_NORMAL = "rbxassetid://1234567" -- Сюда вставь ID обычного лица
local FACE_CRYING = "rbxassetid://7654321" -- Сюда вставь ID плачущего лица

local function spawnNPC(index)
    local model = Instance.new("Model")
    model.Name = "NPC_" .. index
    
    local hrp = Instance.new("Part")
    hrp.Name = "HumanoidRootPart"
    hrp.Size = Vector3.new(2, 2, 1)
    hrp.Position = Vector3.new(math.random(-100, 100), 5, math.random(-100, 100))
    hrp.Transparency = 1
    hrp.Parent = model

    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Color = Color3.fromRGB(math.random(50, 200), math.random(50, 200), math.random(50, 200)) -- Рандомная одежда
    torso.Parent = model

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(1, 1, 1)
    head.Color = Color3.fromRGB(255, 220, 180)
    head.Parent = model

    -- Лицо (Decal)
    local face = Instance.new("Decal")
    face.Name = "Face"
    face.Texture = FACE_NORMAL
    face.Face = Enum.NormalId.Front
    face.Parent = head

    local leftArm = Instance.new("Part")
    leftArm.Name = "LeftArm"
    leftArm.Size = Vector3.new(1, 2, 1)
    leftArm.Color = Color3.fromRGB(200, 200, 200)
    leftArm.Parent = model

    local rightArm = Instance.new("Part")
    rightArm.Name = "RightArm"
    rightArm.Size = Vector3.new(1, 2, 1)
    rightArm.Color = Color3.fromRGB(200, 200, 200)
    rightArm.Parent = model

    local leftLeg = Instance.new("Part")
    leftLeg.Name = "LeftLeg"
    leftLeg.Size = Vector3.new(1, 2, 1)
    leftLeg.Color = Color3.fromRGB(50, 50, 150)
    leftLeg.Parent = model

    local rightLeg = Instance.new("Part")
    rightLeg.Name = "RightLeg"
    rightLeg.Size = Vector3.new(1, 2, 1)
    rightLeg.Color = Color3.fromRGB(50, 50, 150)
    rightLeg.Parent = model

    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = torso
    weld.Parent = hrp

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model
    humanoid.WalkSpeed = 8

    model.PrimaryPart = hrp
    model.Parent = workspace
    table.insert(npcs, model)

    local function makeMotor(name, part0, part1, c0)
        local motor = Instance.new("Motor6D")
        motor.Name = name
        motor.Part0 = part0
        motor.Part1 = part1
        motor.C0 = c0
        motor.Parent = part0
        return motor
    end

    makeMotor("Neck", torso, head, CFrame.new(0, 1.5, 0))
    makeMotor("LeftShoulder", torso, leftArm, CFrame.new(-1.5, 0.5, 0))
    makeMotor("RightShoulder", torso, rightArm, CFrame.new(1.5, 0.5, 0))
    makeMotor("LeftHip", hrp, leftLeg, CFrame.new(-0.5, -1, 0))
    makeMotor("RightHip", hrp, rightLeg, CFrame.new(0.5, -1, 0))

    -- Логика паники
    local isPanicking = false
    RS:WaitForChild("PanicEvent").Event:Connect(function()
        if not isPanicking and humanoid.Health > 0 then
            isPanicking = true
            face.Texture = FACE_CRYING
            humanoid.WalkSpeed = 22 -- Бег
            humanoid:MoveTo(EXIT_POSITION)
        end
    end)

    -- Обычная ходьба
    task.spawn(function()
        while model.Parent and humanoid.Health > 0 do
            if not isPanicking then
                humanoid:MoveTo(hrp.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
            end
            task.wait(3)
        end
    end)

    -- Расчлененка
    humanoid.Died:Connect(function()
        task.wait(0.1)
        local parts = {"Head", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
        for _, name in ipairs(parts) do
            local p = model:FindFirstChild(name)
            if p then
                p.CanCollide = true
                p.Anchored = false
                p.Color = Color3.fromRGB(80, 0, 0)
                p.AssemblyLinearVelocity = Vector3.new(math.random(-20, 20), math.random(10, 30), math.random(-20, 20))
                Debris:AddItem(p, 5)
            end
        end
        hrp:Destroy()
        torso:Destroy()
        humanoid:Destroy()
        Debris:AddItem(model, 5)
    end)
end

-- Создаем RemoteEvent для сигнала паники
local panicEvent = Instance.new("RemoteEvent")
panicEvent.Name = "PanicEvent"
panicEvent.Parent = RS

for i = 1, NPC_COUNT do
    spawnNPC(i)
end
