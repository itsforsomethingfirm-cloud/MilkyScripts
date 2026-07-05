-- [[ +1 Health Per Click | Script Suite with Live Stats ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local Toggles = {
    AutoClick = false,
    World1Farm = false,
    World2Farm = false, -- Added World 2 toggle state
    AutoRebirth = false
}

-- 📊 Live Session Counters
local SessionStats = {
    TotalClicks = 0,
    TotalRebirths = 0
}

-- 📋 Precise Gate Starting Positions
local W1_TargetX, W1_TargetY, W1_TargetZ = 4904, 6, 20
local W2_TargetX, W2_TargetY, W2_TargetZ = 4069, 74, -114 -- New World 2 Coordinates

local Window = Rayfield:CreateWindow({
   Name = "❤️ +1 Health | Dashboard Suite ❤️",
   LoadingTitle = "Initializing Dashboard Interface...",
   LoadingSubtitle = "by MilkyScripts",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = "DarkTheme"
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- [[ Live Session Statistics Section ]] --
FarmTab:CreateSection("📊 Session Statistics")

local ClicksLabel = FarmTab:CreateLabel("Total Clicks: 0")
local RebirthsLabel = FarmTab:CreateLabel("Total Rebirths: 0")

-- Standard Automation Controls
FarmTab:CreateSection("Clicking Automation")

FarmTab:CreateToggle({
   Name = "Auto Click / Gain Health",
   CurrentValue = false,
   Flag = "ClickToggle",
   Callback = function(Value) Toggles.AutoClick = Value end
})

FarmTab:CreateToggle({
   Name = "Auto Rebirth Loop",
   CurrentValue = false,
   Flag = "RebirthToggle",
   Callback = function(Value) Toggles.AutoRebirth = Value end
})

-- World 1 Gate Bypass
FarmTab:CreateSection("World 1 Progression")
FarmTab:CreateToggle({
   Name = "Loop World 1 Gate (TP + Backward Step)",
   CurrentValue = false,
   Flag = "W1Toggle",
   Callback = function(Value) Toggles.World1Farm = Value end
})

-- World 2 Gate Bypass
FarmTab:CreateSection("World 2 Progression")
FarmTab:CreateToggle({
   Name = "Loop World 2 Gate (TP + Backward Step)",
   CurrentValue = false,
   Flag = "W2Toggle",
   Callback = function(Value) Toggles.World2Farm = Value end
})

-- [[ Background Execution Loops with Tracker Hooks ]] --

-- Loop 1: Universal Auto-Clicker + Stat Hook
task.spawn(function()
    while true do
        if Toggles.AutoClick then
            local player = Players.LocalPlayer
            local character = player.Character
            
            local success = pcall(function()
                local tool = character and character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
                
                VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
                
                local rep = game:GetService("ReplicatedStorage")
                local remote = rep:FindFirstChild("Click") or rep:FindFirstChild("ClickRemote") or (rep:FindFirstChild("Remotes") and rep.Remotes:FindFirstChild("Click"))
                if remote then
                    remote:FireServer()
                end
            end)
            
            if success then
                SessionStats.TotalClicks = SessionStats.TotalClicks + 1
                ClicksLabel:Set(string.format("Total Clicks: %d", SessionStats.TotalClicks))
            end
            task.wait(0.01)
        else
            task.wait(0.2)
        end
    end
end)

-- Loop 2: Auto-Rebirth Loop + Stat Hook
task.spawn(function()
    while true do
        if Toggles.AutoRebirth then
            local success = pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRemote")
                if remote then
                    remote:FireServer(1)
                end
            end)
            
            if success then
                SessionStats.TotalRebirths = SessionStats.TotalRebirths + 1
                RebirthsLabel:Set(string.format("Total Rebirths: %d", SessionStats.TotalRebirths))
            end
            task.wait(0.4)
        else
            task.wait(0.4)
        end
    end
end)

-- Loop 3: World 1 Teleport + Precise Backward Transformation
task.spawn(function()
    while true do
        if Toggles.World1Farm then
            local player = Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.CFrame = CFrame.new(W1_TargetX, W1_TargetY + 2, W1_TargetZ)
                task.wait(0.5)
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, 3) -- Pulls backward
            end
            task.wait(0.8)
        else
            task.wait(0.2)
        end
    end
end)

-- Loop 4: World 2 Teleport + Precise Backward Transformation
task.spawn(function()
    while true do
        if Toggles.World2Farm then
            local player = Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.CFrame = CFrame.new(W2_TargetX, W2_TargetY + 2, W2_TargetZ)
                task.wait(0.5)
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, 3) -- Exact same backward step method
            end
            task.wait(0.8)
        else
            task.wait(0.2)
        end
    end
end)
