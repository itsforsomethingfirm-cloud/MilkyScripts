-- ============================================
-- 🥛 MILKY HUB - RIVALS (FULL + VERIFICATION UI)
-- ============================================

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ============================================
-- CONFIGURATION (same bot as Volleyball)
-- ============================================
local RENDER_URL = "https://milkykey.onrender.com"
local DISCORD_INVITE = "https://discord.gg/gFGtBmcAWQ"

-- ============================================
-- SAFE HTTP GET
-- ============================================
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function safeGet(url)
    if HttpRequest then
        local success, response = pcall(function()
            return HttpRequest({ Url = url, Method = "GET" })
        end)
        if success and response and response.Body then
            return response.Body
        end
    end
    return game:HttpGet(url)
end

-- ============================================
-- WHITELIST CHECK
-- ============================================
local function checkWhitelistStatus()
    local checkUrl = RENDER_URL .. "/check?user=" .. HttpService:UrlEncode(LocalPlayer.Name)
    local successCheck, rawData = pcall(function()
        return safeGet(checkUrl)
    end)
    if successCheck and rawData then
        local decodeSuccess, responseData = pcall(function()
            return HttpService:JSONDecode(rawData)
        end)
        if decodeSuccess and type(responseData) == "table" then
            if responseData.allowed == true or responseData.verified == true then
                return true, "verified"
            elseif responseData.maintenance == true then
                return false, "maintenance"
            end
        end
    end
    return false, "pending"
end

-- Wake up Render
task.spawn(function()
    pcall(function() safeGet(RENDER_URL) end)
end)

-- ============================================
-- RIVALS FEATURE SETTINGS
-- ============================================
_G.Settings = {
    Aimbot = false,
    SilentAim = false,
    Triggerbot = false,
    AntiKatana = false,
    HitboxExpander = false,
    HitboxSize = 5,
    HeadshotAccuracy = 50,
    SkinChanger = false,
    Orbit = false,
    Fly = false,
    OrbitRadius = 20,
    OrbitSpeed = 1,
    FlySpeed = 50,
    AimSmoothness = 0.3,
    AimFOV = 200,
}

-- ============================================
-- GAME UTILITIES (Rivals)
-- ============================================
local function GetClosestPlayer()
    local closest, closestDist = nil, _G.Settings.AimFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

local function GetTargetPosition(player)
    if not player or not player.Character then return nil end
    local head = player.Character:FindFirstChild("Head")
    if head then return head.Position end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then return root.Position end
    return nil
end

local function IsUsingKatana()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("katana") then
        return true
    end
    if char:FindFirstChild("UsingKatana") and char.UsingKatana.Value == true then
        return true
    end
    return false
end

-- ============================================
-- FEATURE FUNCTIONS
-- ============================================

-- Aimbot
local function Aimbot()
    if not _G.Settings.Aimbot then return end
    local target = GetClosestPlayer()
    if not target then return end
    local targetPos = GetTargetPosition(target)
    if not targetPos then return end
    if _G.Settings.HeadshotAccuracy < 100 and math.random(1, 100) > _G.Settings.HeadshotAccuracy then
        local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
        if torso then targetPos = torso.Position end
    end
    local currentPos = Camera.CFrame.Position
    local direction = (targetPos - currentPos).Unit
    local targetCFrame = CFrame.lookAt(currentPos, currentPos + direction)
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.Settings.AimSmoothness)
end

-- Triggerbot
local function Triggerbot()
    if not _G.Settings.Triggerbot then return end
    if _G.Settings.AntiKatana and IsUsingKatana() then return end
    local target = GetClosestPlayer()
    if not target then return end
    local targetPos = GetTargetPosition(target)
    if not targetPos then return end
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if not onScreen then return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
    if dist < 50 then
        pcall(mouse1click)
    end
end

-- Hitbox Expander
local expanded = {}
local function ExpandHitboxes()
    if not _G.Settings.HitboxExpander then
        for part, origSize in pairs(expanded) do
            if part and part.Parent then part.Size = origSize end
        end
        expanded = {}
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, partName in ipairs({"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
                local part = player.Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    if not expanded[part] then expanded[part] = part.Size end
                    local expansion = _G.Settings.HitboxSize / 10
                    part.Size = expanded[part] * (1 + expansion)
                end
            end
        end
    end
end

-- Orbit
local orbitAngle = 0
local function OrbitAround()
    if not _G.Settings.Orbit then return end
    local target = GetClosestPlayer()
    if not target or not target.Character then return end
    local center = target.Character:FindFirstChild("HumanoidRootPart")
    if not center then return end
    orbitAngle = orbitAngle + (_G.Settings.OrbitSpeed * 0.02)
    local radius = _G.Settings.OrbitRadius
    local x = center.Position.X + radius * math.cos(orbitAngle)
    local z = center.Position.Z + radius * math.sin(orbitAngle)
    local y = center.Position.Y + 5
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(Vector3.new(x, y, z), center.Position)
        end
    end
end

-- Fly
local flying = false
local flyBV = nil
local function ToggleFly()
    _G.Settings.Fly = not _G.Settings.Fly
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if _G.Settings.Fly then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = true end
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1,1,1) * 4000
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.Parent = root
        flying = true
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
        flying = false
    end
end
local function UpdateFly()
    if not flying or not flyBV then return end
    local move = Vector3.new(0,0,0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * Vector3.new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * Vector3.new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
    if move.Magnitude > 0 then move = move.Unit * _G.Settings.FlySpeed end
    flyBV.Velocity = move
end

-- Skin Changer (placeholder – adjust to Rivals weapon structure)
local function ChangeSkin(skinId)
    if not _G.Settings.SkinChanger then return end
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    for _, child in ipairs(tool:GetDescendants()) do
        if child:IsA("Part") or child:IsA("MeshPart") then
            if child:FindFirstChild("Texture") then
                child.Texture.Texture = skinId
            end
            if child:FindFirstChild("Mesh") then
                child.Mesh.MeshId = skinId
            end
        end
    end
end

-- ============================================
-- MAIN LOOP
-- ============================================
RunService.Heartbeat:Connect(function()
    if _G.Settings.Aimbot then Aimbot() end
    if _G.Settings.Triggerbot then Triggerbot() end
    if _G.Settings.Orbit then OrbitAround() end
    if _G.Settings.Fly then UpdateFly() end
    ExpandHitboxes() -- handles both enable and disable
end)

-- ============================================
-- VERIFICATION UI (SAME AS VOLLEYBALL)
-- ============================================
local function startVerificationProcess()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "MilkyVerifyUI" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    local Header = Instance.new("TextLabel")
    local SubHeader = Instance.new("TextLabel")
    local UserCard = Instance.new("Frame")
    local UserCardCorner = Instance.new("UICorner")
    local UserLabel = Instance.new("TextLabel")
    
    local Instructions = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local CopyButton = Instance.new("TextButton")
    local ButtonCorner = Instance.new("UICorner")

    ScreenGui.Name = "MilkyVerifyUI"
    ScreenGui.Parent = CoreGui

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -145)
    MainFrame.Size = UDim2.new(0, 400, 0, 290)
    MainFrame.Active = true
    MainFrame.Draggable = true

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Rainbow border
    task.spawn(function()
        local hue = 0
        while MainFrame and MainFrame.Parent do
            hue = (hue + 0.005) % 1
            UIStroke.Color = Color3.fromHSV(hue, 0.8, 1)
            task.wait(0.03)
        end
    end)

    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Position = UDim2.new(0, 0, 0, 15)
    Header.Size = UDim2.new(1, 0, 0, 25)
    Header.Font = Enum.Font.GothamBold
    Header.Text = "🥛 MILKY HUB - RIVALS"
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextSize = 20

    SubHeader.Parent = MainFrame
    SubHeader.BackgroundTransparency = 1
    SubHeader.Position = UDim2.new(0, 0, 0, 40)
    SubHeader.Size = UDim2.new(1, 0, 0, 18)
    SubHeader.Font = Enum.Font.GothamMedium
    SubHeader.Text = "6-Hour Verification Required"
    SubHeader.TextColor3 = Color3.fromRGB(150, 150, 160)
    SubHeader.TextSize = 12

    UserCard.Parent = MainFrame
    UserCard.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    UserCard.Position = UDim2.new(0.08, 0, 0.28, 0)
    UserCard.Size = UDim2.new(0.84, 0, 0, 35)

    UserCardCorner.CornerRadius = UDim.new(0, 8)
    UserCardCorner.Parent = UserCard

    UserLabel.Parent = UserCard
    UserLabel.BackgroundTransparency = 1
    UserLabel.Size = UDim2.new(1, 0, 1, 0)
    UserLabel.Font = Enum.Font.GothamBold
    UserLabel.Text = "👤 Roblox Account: " .. LocalPlayer.Name
    UserLabel.TextColor3 = Color3.fromRGB(0, 230, 180)
    UserLabel.TextSize = 13

    Instructions.Parent = MainFrame
    Instructions.BackgroundTransparency = 1
    Instructions.Position = UDim2.new(0.08, 0, 0.44, 0)
    Instructions.Size = UDim2.new(0.84, 0, 0, 35)
    Instructions.Font = Enum.Font.Gotham
    Instructions.Text = "Join Discord & run: /v " .. LocalPlayer.Name .. "\nYour pass will unlock Rayfield Hub automatically!"
    Instructions.TextColor3 = Color3.fromRGB(200, 200, 210)
    Instructions.TextSize = 12
    Instructions.TextWrapped = true

    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0.60, 0)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = "🔄 Waiting for Discord verification (/v)..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
    StatusLabel.TextSize = 12

    CopyButton.Parent = MainFrame
    CopyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    CopyButton.Position = UDim2.new(0.08, 0, 0.74, 0)
    CopyButton.Size = UDim2.new(0.84, 0, 0, 42)
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.Text = "📋 COPY DISCORD LINK"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 13

    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = CopyButton

    CopyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            CopyButton.Text = "✅ LINK COPIED!"
            CopyButton.TextColor3 = Color3.fromRGB(0, 255, 150)
            task.wait(2)
            CopyButton.Text = "📋 COPY DISCORD LINK"
            CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    -- Polling Loop
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            local isVerified, state = checkWhitelistStatus()
            
            if state == "maintenance" then
                StatusLabel.Text = "🛠️ System Under Maintenance!"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            elseif isVerified then
                StatusLabel.Text = "⚡ Verification Detected! Loading Rayfield..."
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                task.wait(1)
                ScreenGui:Destroy()
                loadRivalsHub()
                break
            else
                StatusLabel.Text = "🔄 Waiting for Discord verification (/v)..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
            end
            task.wait(3)
        end
    end)
end

-- ============================================
-- RAYFIELD UI (RIVALS)
-- ============================================
local function loadRivalsHub()
    print("✅ Verified! Launching Rivals Rayfield Hub...")

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "🥛 Milky Hub | Rivals",
        Icon = 0,
        LoadingTitle = "Rivals Engine",
        LoadingSubtitle = "by Milky Scripts",
        Theme = "Default",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "MilkyRivalsConfig",
            FileName = "Settings"
        },
        KeySystem = false
    })

    -- ===== TAB 1: COMBAT =====
    local CombatTab = Window:CreateTab("Combat", 4483362458)

    CombatTab:CreateToggle({
        Name = "🎯 Aimbot (Smooth)",
        CurrentValue = false,
        Flag = "AimbotToggle",
        Callback = function(Value) _G.Settings.Aimbot = Value end
    })

    CombatTab:CreateToggle({
        Name = "🔫 Silent Aim",
        CurrentValue = false,
        Flag = "SilentAimToggle",
        Callback = function(Value) _G.Settings.SilentAim = Value end
    })

    CombatTab:CreateToggle({
        Name = "🤖 Triggerbot",
        CurrentValue = false,
        Flag = "TriggerbotToggle",
        Callback = function(Value) _G.Settings.Triggerbot = Value end
    })

    CombatTab:CreateToggle({
        Name = "⚔️ Anti-Katana (stops triggerbot)",
        CurrentValue = false,
        Flag = "AntiKatanaToggle",
        Callback = function(Value) _G.Settings.AntiKatana = Value end
    })

    CombatTab:CreateSlider({
        Name = "💀 Headshot Accuracy",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "HeadshotSlider",
        Callback = function(Value) _G.Settings.HeadshotAccuracy = Value end
    })

    -- ===== TAB 2: VISUALS =====
    local VisualsTab = Window:CreateTab("Visuals", 4483362458)

    VisualsTab:CreateToggle({
        Name = "📦 Hitbox Expander",
        CurrentValue = false,
        Flag = "HitboxToggle",
        Callback = function(Value) _G.Settings.HitboxExpander = Value end
    })

    VisualsTab:CreateSlider({
        Name = "📏 Hitbox Size Scale",
        Range = {1, 20},
        Increment = 1,
        Suffix = "x",
        CurrentValue = 5,
        Flag = "HitboxSizeSlider",
        Callback = function(Value) _G.Settings.HitboxSize = Value end
    })

    VisualsTab:CreateToggle({
        Name = "🎨 Skin Changer (Visuals)",
        CurrentValue = false,
        Flag = "SkinChangerToggle",
        Callback = function(Value) _G.Settings.SkinChanger = Value end
    })

    -- ===== TAB 3: MOVEMENT =====
    local MoveTab = Window:CreateTab("Movement", 4483362458)

    MoveTab:CreateToggle({
        Name = "🌌 Orbit (around enemy)",
        CurrentValue = false,
        Flag = "OrbitToggle",
        Callback = function(Value) _G.Settings.Orbit = Value end
    })

    MoveTab:CreateSlider({
        Name = "📐 Orbit Radius",
        Range = {5, 50},
        Increment = 1,
        Suffix = " studs",
        CurrentValue = 20,
        Flag = "OrbitRadiusSlider",
        Callback = function(Value) _G.Settings.OrbitRadius = Value end
    })

    MoveTab:CreateSlider({
        Name = "🔄 Orbit Speed",
        Range = {0.5, 5},
        Increment = 0.5,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "OrbitSpeedSlider",
        Callback = function(Value) _G.Settings.OrbitSpeed = Value end
    })

    MoveTab:CreateToggle({
        Name = "🕊️ Fly (WASD + Space/Shift)",
        CurrentValue = false,
        Flag = "FlyToggle",
        Callback = function(Value)
            if Value then
                ToggleFly()
            else
                ToggleFly() -- turns it off
            end
        end
    })

    MoveTab:CreateSlider({
        Name = "💨 Fly Speed",
        Range = {10, 200},
        Increment = 5,
        Suffix = " speed",
        CurrentValue = 50,
        Flag = "FlySpeedSlider",
        Callback = function(Value) _G.Settings.FlySpeed = Value end
    })

    -- Notify
    Rayfield:Notify({
        Title = "🥛 Milky Hub Loaded",
        Content = "Rivals features active! Enjoy.",
        Duration = 5,
    })
end

-- ============================================
-- EXECUTION START
-- ============================================
local verified, state = checkWhitelistStatus()
if verified then
    loadRivalsHub()
else
    startVerificationProcess()
end
