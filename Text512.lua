local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Toggle por ejecución
if getgenv().AutoAll then
    getgenv().AutoAll = false
    print("Auto All: OFF")
    return
end

getgenv().AutoAll = true
print("Auto All: ON")

local function findKnife()
    local char = LocalPlayer.Character
    if not char then return nil end

    if char:FindFirstChild("Knife") then
        return char.Knife
    end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        local knife = bp:FindFirstChild("Knife")
        if knife then
            return knife
        end
    end
    return nil
end

local function getAllTargets()
    local targets = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("RightLowerArm") then
            table.insert(targets, plr)
        end
    end
    return targets
end

local function attack()
    local knife = findKnife()
    if not knife then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool \~= knife then
            char.Humanoid:UnequipTools()
        end
    end

    char.Humanoid:EquipTool(knife)
    task.wait(0.15)
    knife:Activate()

    local targets = getAllTargets()
    for _, plr in ipairs(targets) do
        if knife.Events and knife.Events:FindFirstChild("HandleTouched") and plr.Character and plr.Character:FindFirstChild("RightLowerArm") then
            knife.Events.HandleTouched:FireServer(plr.Character.RightLowerArm)
        end
    end
end

-- Loop
task.spawn(function()
    while getgenv().AutoAll do
        pcall(attack)
        task.wait(0.35)
    end
end)
