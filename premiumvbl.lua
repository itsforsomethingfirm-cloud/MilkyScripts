-- =================================================================
-- MILKY HUB | LIVE API-DRIVEN KEY SYSTEM & UI
-- =================================================================

local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Live Server API Endpoint
local API_VERIFY_URL = "https://stealers-1.onrender.com/api/verify"

-- Helper to fetch standard Executor HWID
local function GetHWID()
    if gethwid then return gethwid() end
    if get_hwid then return get_hwid() end
    if syn and syn.get_hwid then return syn.get_hwid() end
    return tostring(LocalPlayer.UserId) .. "_" .. game:GetService("RbxAnalyticsService"):GetClientId()
end

local ClientHWID = GetHWID()

-- Asset Loader
local MASCOT_URL = "https://files.catbox.moe/61pr3v.png"
local function GetMascotAsset()
    local fileName = "milky_mascot_61pr3v.png"
    if isfile and getcustomasset then
        if not isfile(fileName) then
            local success, response = pcall(function()
                return game:HttpGet(MASCOT_URL)
            end)
            if success then writefile(fileName, response) end
        end
        return getcustomasset(fileName)
    else
        return MASCOT_URL
    end
end

local MascotTexture = GetMascotAsset()

local Limits = {
    MaxSpins = 900, MaxAbilities = 800, MaxYen = 300000,
    CurrentSpins = 0, CurrentAbilities = 0, CurrentYen = 0
}

local successRemote, remote = pcall(function()
    return ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.7.0")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("SeasonService")
        :WaitForChild("RF")
        :WaitForChild("RequestRankedReward")
end)

-- // MAIN HUB INTERFACE // --
local function loadMilkyHub()
    if CoreGui:FindFirstChild("MilkyHubUI") then CoreGui.MilkyHubUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MilkyHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = isMobile and UDim2.new(0.92, 0, 0.85, 0) or UDim2.new(0, 680, 0, 480)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(80, 70, 90)
    MainStroke.Transparency = 0.5
    MainStroke.Thickness = 1.2
    MainStroke.Parent = MainFrame

    local Header = Instance.new("Frame")
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.Parent = MainFrame

    local HeaderAvatar = Instance.new("ImageLabel")
    HeaderAvatar.Image = MascotTexture
    HeaderAvatar.BackgroundTransparency = 1
    HeaderAvatar.Position = UDim2.new(0, 16, 0, 10)
    HeaderAvatar.Size = UDim2.new(0, 28, 0, 28)
    HeaderAvatar.Parent = Header

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = HeaderAvatar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "MILKY <font color=\"rgb(255, 180, 210)\">HUB</font>"
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 52, 0, 10)
    TitleLabel.Size = UDim2.new(0, 200, 0, 28)
    TitleLabel.Parent = Header

    local OpenLogoBtn = Instance.new("ImageButton")
    OpenLogoBtn.Name = "MilkyFloatingLogo"
    OpenLogoBtn.Image = MascotTexture
    OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 38)
    OpenLogoBtn.BackgroundTransparency = 0.2
    OpenLogoBtn.Size = UDim2.new(0, 54, 0, 54)
    OpenLogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    OpenLogoBtn.Visible = false
    OpenLogoBtn.Active = true
    OpenLogoBtn.Draggable = true
    OpenLogoBtn.Parent = ScreenGui

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = OpenLogoBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextColor3 = Color3.fromRGB(200, 190, 210)
    CloseBtn.TextSize = 14
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -30, 0, 12)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Text = "—"
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 190, 210)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -55, 0, 12)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Parent = Header

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenLogoBtn.Visible = true
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    OpenLogoBtn.MouseButton1Click:Connect(function()
        OpenLogoBtn.Visible = false
        MainFrame.Visible = true
    end)

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 16, 0, 50)
    TabBar.Size = UDim2.new(0, 420, 0, 32)
    TabBar.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabBar

    local TabPages = {}

    local function CreateTab(name, isMain)
        if #TabPages >= 4 then return end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = isMain and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 135, 155)
        TabBtn.BackgroundColor3 = isMain and Color3.fromRGB(40, 34, 48) or Color3.fromRGB(28, 25, 34)
        TabBtn.BackgroundTransparency = isMain and 0.2 or 0.6
        TabBtn.Size = UDim2.new(0, 95, 1, 0)
        TabBtn.Parent = TabBar

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = TabBtn

        local ActiveLine = Instance.new("Frame")
        ActiveLine.BackgroundColor3 = Color3.fromRGB(255, 180, 210)
        ActiveLine.Position = UDim2.new(0.2, 0, 1, -2)
        ActiveLine.Size = UDim2.new(0.6, 0, 0, 2)
        ActiveLine.Visible = isMain
        ActiveLine.Parent = TabBtn

        local PageFrame = Instance.new("ScrollingFrame")
        PageFrame.Name = name .. "Page"
        PageFrame.BackgroundTransparency = 1
        PageFrame.Position = UDim2.new(0, 16, 0, 92)
        PageFrame.Size = isMobile and UDim2.new(0.6, 0, 0.78, 0) or UDim2.new(0, 420, 0, 370)
        PageFrame.ScrollBarThickness = 2
        PageFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 210)
        PageFrame.Visible = isMain
        PageFrame.Parent = MainFrame

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 12)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = PageFrame

        local function SelectTab()
            for _, tab in ipairs(TabPages) do
                tab.Btn.TextColor3 = Color3.fromRGB(140, 135, 155)
                tab.Btn.BackgroundColor3 = Color3.fromRGB(28, 25, 34)
                tab.Btn.BackgroundTransparency = 0.6
                tab.ActiveLine.Visible = false
                tab.Page.Visible = false
            end
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 34, 48)
            TabBtn.BackgroundTransparency = 0.2
            ActiveLine.Visible = true
            PageFrame.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        table.insert(TabPages, {Btn = TabBtn, Page = PageFrame, Select = SelectTab, ActiveLine = ActiveLine})

        if not isMain then
            local Card = Instance.new("Frame")
            Card.BackgroundColor3 = Color3.fromRGB(16, 14, 20)
            Card.BackgroundTransparency = 0.4
            Card.Size = UDim2.new(0.98, 0, 0, 100)
            Card.Parent = PageFrame

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 10)
            CardCorner.Parent = Card

            local CardTitle = Instance.new("TextLabel")
            CardTitle.Text = "Coming Soon"
            CardTitle.Font = Enum.Font.GothamBold
            CardTitle.TextSize = 14
            CardTitle.TextColor3 = Color3.fromRGB(180, 175, 195)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Size = UDim2.new(1, 0, 1, 0)
            CardTitle.Parent = Card
        end

        return PageFrame
    end

    local MainPage = CreateTab("Main", true)
    CreateTab("Visuals", false)
    CreateTab("Misc", false)
    CreateTab("Config", false)

    local function CreateSectionCard(parent, title, height)
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Color3.fromRGB(16, 14, 20)
        Card.BackgroundTransparency = 0.4
        Card.Size = UDim2.new(0.98, 0, 0, height)
        Card.Parent = parent

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 10)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = Color3.fromRGB(50, 45, 60)
        CardStroke.Transparency = 0.5
        CardStroke.Parent = Card

        local CardTitle = Instance.new("TextLabel")
        CardTitle.Text = title
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.TextSize = 14
        CardTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.BackgroundTransparency = 1
        CardTitle.Position = UDim2.new(0, 12, 0, 8)
        CardTitle.Size = UDim2.new(1, -24, 0, 20)
        CardTitle.Parent = Card

        return Card
    end

    local TogglesCard = CreateSectionCard(MainPage, "Automations", 125)

    local function AddToggle(parent, name, pos, defaultState, callback)
        local ToggleContainer = Instance.new("Frame")
        ToggleContainer.BackgroundTransparency = 1
        ToggleContainer.Position = pos
        ToggleContainer.Size = UDim2.new(0.48, 0, 0, 26)
        ToggleContainer.Parent = parent

        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Text = ""
        SwitchBg.AutoButtonColor = false
        SwitchBg.BackgroundColor3 = defaultState and Color3.fromRGB(255, 180, 210) or Color3.fromRGB(55, 50, 65)
        SwitchBg.Position = UDim2.new(0, 0, 0.5, -10)
        SwitchBg.Size = UDim2.new(0, 36, 0, 20)
        SwitchBg.Parent = ToggleContainer

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = SwitchBg

        local Knob = Instance.new("Frame")
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        Knob.Size = UDim2.new(0, 14, 0, 14)
        Knob.Parent = SwitchBg

        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob

        local Label = Instance.new("TextLabel")
        Label.Text = name
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Color3.fromRGB(200, 195, 210)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 42, 0, 0)
        Label.Size = UDim2.new(1, -42, 1, 0)
        Label.Parent = ToggleContainer

        local state = defaultState
        SwitchBg.MouseButton1Click:Connect(function()
            state = not state
            Knob:TweenPosition(state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), "Out", "Quad", 0.12, true)
            SwitchBg.BackgroundColor3 = state and Color3.fromRGB(255, 180, 210) or Color3.fromRGB(55, 50, 65)
            callback(state)
        end)
    end

    AddToggle(TogglesCard, "Auto Lucky Spins", UDim2.new(0, 12, 0, 36), false, function(v)
        _G.AutoSpins = v
        task.spawn(function()
            while _G.AutoSpins do
                if Limits.CurrentSpins >= Limits.MaxSpins then break end
                if successRemote and remote then pcall(function() remote:InvokeServer(1) Limits.CurrentSpins = Limits.CurrentSpins + 1 end) end
                task.wait(0.5)
            end
        end)
    end)

    AddToggle(TogglesCard, "Auto Ability Spins", UDim2.new(0.5, 6, 0, 36), false, function(v)
        _G.AutoAbilities = v
        task.spawn(function()
            while _G.AutoAbilities do
                if Limits.CurrentAbilities >= Limits.MaxAbilities then break end
                if successRemote and remote then pcall(function() remote:InvokeServer(4) Limits.CurrentAbilities = Limits.CurrentAbilities + 1 end) end
                task.wait(1.5)
            end
        end)
    end)

    AddToggle(TogglesCard, "Auto Yen Farm", UDim2.new(0, 12, 0, 72), false, function(v)
        _G.AutoYen = v
        task.spawn(function()
            while _G.AutoYen do
                if Limits.CurrentYen >= Limits.MaxYen then break end
                if successRemote and remote then pcall(function() remote:InvokeServer(2) Limits.CurrentYen = Limits.CurrentYen + 1000 end) end
                task.wait(0.6)
            end
        end)
    end)
end

-- // API KEY VERIFICATION // --
local function startKeyVerification()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "MilkyKeyUI" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MilkyKeyUI"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 360, 0, 240)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 180, 210)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = MainFrame

    local KeyAvatar = Instance.new("ImageLabel")
    KeyAvatar.Image = MascotTexture
    KeyAvatar.BackgroundTransparency = 1
    KeyAvatar.Position = UDim2.new(0.5, -24, 0, -24)
    KeyAvatar.Size = UDim2.new(0, 48, 0, 48)
    KeyAvatar.Parent = MainFrame

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = KeyAvatar

    local Header = Instance.new("TextLabel")
    Header.BackgroundTransparency = 1
    Header.Position = UDim2.new(0, 0, 0, 32)
    Header.Size = UDim2.new(1, 0, 0, 24)
    Header.Font = Enum.Font.GothamBold
    Header.Text = "MILKY <font color=\"rgb(255, 180, 210)\">HUB</font>"
    Header.RichText = true
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextSize = 18
    Header.Parent = MainFrame

    local SubHeader = Instance.new("TextLabel")
    SubHeader.BackgroundTransparency = 1
    SubHeader.Position = UDim2.new(0, 0, 0, 56)
    SubHeader.Size = UDim2.new(1, 0, 0, 18)
    SubHeader.Font = Enum.Font.GothamMedium
    SubHeader.Text = "Enter your premium key"
    SubHeader.TextColor3 = Color3.fromRGB(160, 150, 175)
    SubHeader.TextSize = 11
    SubHeader.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.BackgroundColor3 = Color3.fromRGB(16, 14, 20)
    KeyInput.Position = UDim2.new(0.08, 0, 0.42, 0)
    KeyInput.Size = UDim2.new(0.84, 0, 0, 42)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Paste Key Here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(110, 105, 125)
    KeyInput.TextSize = 12
    KeyInput.Parent = MainFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = KeyInput

    local VerifyButton = Instance.new("TextButton")
    VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 180, 210)
    VerifyButton.Position = UDim2.new(0.08, 0, 0.68, 0)
    VerifyButton.Size = UDim2.new(0.84, 0, 0, 42)
    VerifyButton.Font = Enum.Font.GothamBold
    VerifyButton.Text = "VERIFY KEY"
    VerifyButton.TextColor3 = Color3.fromRGB(22, 20, 28)
    VerifyButton.TextSize = 12
    VerifyButton.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = VerifyButton

    VerifyButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text:gsub("%s+", "")
        VerifyButton.Text = "VERIFYING..."
        
        local success, result = pcall(function()
            local payload = HttpService:JSONEncode({ key = enteredKey, hwid = ClientHWID })
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if req then
                local res = req({
                    Url = API_VERIFY_URL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload
                })
                return HttpService:JSONDecode(res.Body)
            else
                return HttpService:JSONDecode(game:HttpPost(API_VERIFY_URL, payload))
            end
        end)

        if success and result and result.valid then
            VerifyButton.Text = "ACCESS GRANTED"
            VerifyButton.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
            task.wait(0.6)
            ScreenGui:Destroy()
            loadMilkyHub()
        else
            VerifyButton.Text = (result and result.message) or "INVALID KEY!"
            VerifyButton.BackgroundColor3 = Color3.fromRGB(240, 80, 100)
            VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(1.2)
            VerifyButton.Text = "VERIFY KEY"
            VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 180, 210)
            VerifyButton.TextColor3 = Color3.fromRGB(22, 20, 28)
        end
    end)
end

startKeyVerification()
