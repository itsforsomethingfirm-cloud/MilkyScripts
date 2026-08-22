-- =================================================================
-- MILKY HUB | VOLLEYBALL LEGENDS (PERMANENT KEY SYSTEM + ULTRA FANCY UI)
-- =================================================================

local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local DISCORD_INVITE = "https://discord.gg/gFGtBmcAWQ"
local PERMANENT_KEY = "blackmilk" -- Case-insensitive master key

-- Mascot Asset Loader
local MASCOT_URL = "https://files.catbox.moe/61pr3v.png"
local function GetMascotAsset()
    local fileName = "milky_mascot_61pr3v.png"
    if isfile and getcustomasset then
        if not isfile(fileName) then
            pcall(function() writefile(fileName, game:HttpGet(MASCOT_URL)) end)
        end
        return getcustomasset(fileName)
    else
        return MASCOT_URL
    end
end
local MascotTexture = GetMascotAsset()

-- Knit Remote Hook for Volleyball Legends
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

-- Global Automations State
_G.MILKY_SPINS = false
_G.MILKY_YEN = false
_G.MILKY_ABILITIES = false

-- =================================================================
-- MAIN MILKY HUB UI
-- =================================================================
local function loadMilkyHub()
    if CoreGui:FindFirstChild("MilkyVolleyballUI") then 
        CoreGui.MilkyVolleyballUI:Destroy() 
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MilkyVolleyballUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = isMobile and UDim2.new(0.92, 0, 0.85, 0) or UDim2.new(0, 580, 0, 380)
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

    -- Header
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
    TitleLabel.Text = 'MILKY <font color="rgb(255, 180, 210)">HUB</font> | Volleyball Legends'
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 52, 0, 10)
    TitleLabel.Size = UDim2.new(0, 300, 0, 28)
    TitleLabel.Parent = Header

    -- Floating Logo Toggle Button
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

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 16, 0, 50)
    TabBar.Size = UDim2.new(1, -32, 0, 32)
    TabBar.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabBar

    local TabPages = {}

    local function CreateTab(name, isMain)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = isMain and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 135, 155)
        TabBtn.BackgroundColor3 = isMain and Color3.fromRGB(40, 34, 48) or Color3.fromRGB(28, 25, 34)
        TabBtn.BackgroundTransparency = isMain and 0.2 or 0.6
        TabBtn.Size = UDim2.new(0, 110, 1, 0)
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
        PageFrame.Size = isMobile and UDim2.new(1, -32, 0.72, 0) or UDim2.new(1, -32, 0, 270)
        PageFrame.ScrollBarThickness = 2
        PageFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 210)
        PageFrame.Visible = isMain
        PageFrame.Parent = MainFrame

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 12)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = PageFrame

        TabBtn.MouseButton1Click:Connect(function()
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
        end)

        table.insert(TabPages, {Btn = TabBtn, Page = PageFrame, ActiveLine = ActiveLine})
        return PageFrame
    end

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
        CardTitle.TextSize = 13
        CardTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.BackgroundTransparency = 1
        CardTitle.Position = UDim2.new(0, 12, 0, 8)
        CardTitle.Size = UDim2.new(1, -24, 0, 20)
        CardTitle.Parent = Card

        return Card
    end

    local function AddToggle(parent, name, pos, defaultState, callback)
        local ToggleContainer = Instance.new("Frame")
        ToggleContainer.BackgroundTransparency = 1
        ToggleContainer.Position = pos
        ToggleContainer.Size = UDim2.new(0.9, 0, 0, 26)
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
        Label.TextSize = 12
        Label.TextColor3 = Color3.fromRGB(200, 195, 210)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 44, 0, 0)
        Label.Size = UDim2.new(1, -44, 1, 0)
        Label.Parent = ToggleContainer

        local state = defaultState
        SwitchBg.MouseButton1Click:Connect(function()
            state = not state
            Knob:TweenPosition(state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), "Out", "Quad", 0.12, true)
            SwitchBg.BackgroundColor3 = state and Color3.fromRGB(255, 180, 210) or Color3.fromRGB(55, 50, 65)
            callback(state)
        end)
    end

    -- Create Pages
    local AutoPage = CreateTab("Automations", true)
    local InfoPage = CreateTab("Status", false)

    -- TAB 1: Ranked Rewards Automations
    local AutoCard = CreateSectionCard(AutoPage, "Ranked Rewards & Farm", 145)

    -- Auto Spins
    AddToggle(AutoCard, "Auto Spins (Reward 1)", UDim2.new(0, 12, 0, 36), false, function(v)
        _G.MILKY_SPINS = v
        task.spawn(function()
            while _G.MILKY_SPINS do
                if successRemote and remote then 
                    pcall(function() remote:InvokeServer(1) end) 
                end
                task.wait(0.5)
            end
        end)
    end)

    -- Auto Yen
    AddToggle(AutoCard, "Auto Yen (Reward 2)", UDim2.new(0, 12, 0, 70), false, function(v)
        _G.MILKY_YEN = v
        task.spawn(function()
            while _G.MILKY_YEN do
                if successRemote and remote then 
                    pcall(function() remote:InvokeServer(2) end) 
                end
                task.wait(0.6)
            end
        end)
    end)

    -- Auto Abilities
    AddToggle(AutoCard, "Auto Abilities (Reward 4)", UDim2.new(0, 12, 0, 104), false, function(v)
        _G.MILKY_ABILITIES = v
        task.spawn(function()
            while _G.MILKY_ABILITIES do
                if successRemote and remote then 
                    pcall(function() remote:InvokeServer(4) end) 
                end
                task.wait(1.5)
            end
        end)
    end)

    -- TAB 2: Status Page
    local InfoCard = CreateSectionCard(InfoPage, "Authentication Status", 130)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Text = "Player: " .. LocalPlayer.Name .. "\nKey Status: Lifetime Access (Permanent)\nAuth Code: BlackMilk\n\nAll Volleyball Legends automations unlocked."
    InfoLabel.Font = Enum.Font.GothamMedium
    InfoLabel.TextSize = 11
    InfoLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0, 12, 0, 36)
    InfoLabel.Size = UDim2.new(1, -24, 0, 80)
    InfoLabel.Parent = InfoCard
end

-- =================================================================
-- ULTRA FANCY GLASS/NEON KEY AUTHENTICATION GUI
-- =================================================================
local function startVerificationProcess()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "MilkyVerifyUI" then v:Destroy() end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MilkyVerifyUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Parent = gui
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.Size = isMobile and UDim2.new(0.9, 0, 0, 360) or UDim2.new(0, 460, 0, 370)
    main.BackgroundColor3 = Color3.fromRGB(15, 13, 20)
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(160, 120, 220)
    stroke.Transparency = 0.55
    stroke.Thickness = 1.6

    -- Neon Glow Accent Line on Top
    local glowBar = Instance.new("Frame", main)
    glowBar.Position = UDim2.new(0.1, 0, 0, 0)
    glowBar.Size = UDim2.new(0.8, 0, 0, 3)
    glowBar.BackgroundColor3 = Color3.fromRGB(255, 160, 210)
    glowBar.BorderSizePixel = 0
    Instance.new("UICorner", glowBar).CornerRadius = UDim.new(1, 0)

    -- Avatar / Mascot Box
    local avatarImg = Instance.new("ImageLabel", main)
    avatarImg.Image = MascotTexture
    avatarImg.BackgroundTransparency = 1
    avatarImg.Position = UDim2.new(0.5, -30, 0, 18)
    avatarImg.Size = UDim2.new(0, 60, 0, 60)
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

    local function label(text, pos, size, font, color, textSize, isRich)
        local x = Instance.new("TextLabel", main)
        x.BackgroundTransparency = 1
        x.Text = text
        x.RichText = isRich or false
        x.Position = pos
        x.Size = size
        x.Font = font
        x.TextColor3 = color
        x.TextSize = textSize
        x.TextWrapped = true
        return x
    end

    label('MILKY <font color="rgb(255, 180, 210)">HUB</font>', UDim2.new(0, 0, 0, 84), UDim2.new(1, 0, 0, 24), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), 20, true)
    label("Enter the key from Discord to activate", UDim2.new(0, 0, 0, 108), UDim2.new(1, 0, 0, 16), Enum.Font.GothamMedium, Color3.fromRGB(160, 150, 175), 12)

    -- User Badge Card
    local userCard = Instance.new("Frame", main)
    userCard.Position = UDim2.new(0.08, 0, 0, 134)
    userCard.Size = UDim2.new(0.84, 0, 0, 32)
    userCard.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
    userCard.BackgroundTransparency = 0.4
    userCard.BorderSizePixel = 0
    Instance.new("UICorner", userCard).CornerRadius = UDim.new(0, 8)
    
    local userDot = Instance.new("Frame", userCard)
    userDot.Position = UDim2.new(0, 12, 0.5, -4)
    userDot.Size = UDim2.new(0, 8, 0, 8)
    userDot.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
    userDot.BorderSizePixel = 0
    Instance.new("UICorner", userDot).CornerRadius = UDim.new(1, 0)

    local userLbl = Instance.new("TextLabel", userCard)
    userLbl.BackgroundTransparency = 1
    userLbl.Position = UDim2.new(0, 28, 0, 0)
    userLbl.Size = UDim2.new(1, -36, 1, 0)
    userLbl.Font = Enum.Font.GothamMedium
    userLbl.Text = "Player: " .. LocalPlayer.Name
    userLbl.TextColor3 = Color3.fromRGB(220, 215, 235)
    userLbl.TextSize = 12
    userLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Key Input Box Frame
    local inputCard = Instance.new("Frame", main)
    inputCard.Position = UDim2.new(0.08, 0, 0, 176)
    inputCard.Size = UDim2.new(0.84, 0, 0, 44)
    inputCard.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
    inputCard.BorderSizePixel = 0
    Instance.new("UICorner", inputCard).CornerRadius = UDim.new(0, 10)
    local inputStroke = Instance.new("UIStroke", inputCard)
    inputStroke.Color = Color3.fromRGB(75, 65, 95)
    inputStroke.Thickness = 1.2

    local textBox = Instance.new("TextBox", inputCard)
    textBox.BackgroundTransparency = 1
    textBox.Position = UDim2.new(0, 14, 0, 0)
    textBox.Size = UDim2.new(1, -28, 1, 0)
    textBox.Font = Enum.Font.GothamBold
    textBox.PlaceholderText = "Enter key here..."
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 100, 130)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 220, 240)
    textBox.TextSize = 13
    textBox.ClearTextOnFocus = false

    local status = label("Status: Awaiting key...", UDim2.new(0, 0, 0, 226), UDim2.new(1, 0, 0, 18), Enum.Font.GothamMedium, Color3.fromRGB(255, 180, 210), 11)

    -- Glow Submit Button
    local submitBtn = Instance.new("TextButton", main)
    submitBtn.Position = UDim2.new(0.08, 0, 0, 252)
    submitBtn.Size = UDim2.new(0.84, 0, 0, 42)
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 195)
    submitBtn.BorderSizePixel = 0
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Text = "AUTHENTICATE KEY"
    submitBtn.TextColor3 = Color3.fromRGB(20, 15, 25)
    submitBtn.TextSize = 13
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 10)

    -- Case-Insensitive Validation Logic
    submitBtn.MouseButton1Click:Connect(function()
        local input = textBox.Text:gsub("%s+", ""):lower()
        
        if input == PERMANENT_KEY then
            status.Text = "Key Accepted! Unlocking Milky Hub..."
            status.TextColor3 = Color3.fromRGB(120, 255, 160)
            submitBtn.Text = "VERIFIED"
            submitBtn.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(120, 255, 160)}):Play()
            task.wait(0.6)
            gui:Destroy()
            loadMilkyHub()
        else
            status.Text = "Incorrect key! Get key from Discord."
            status.TextColor3 = Color3.fromRGB(255, 90, 110)
            TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 90, 110)}):Play()
            task.wait(1)
            TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(75, 65, 95)}):Play()
        end
    end)

    -- Discord Copy Button
    local copy = Instance.new("TextButton", main)
    copy.Position = UDim2.new(0.08, 0, 0, 304)
    copy.Size = UDim2.new(0.84, 0, 0, 36)
    copy.BackgroundColor3 = Color3.fromRGB(28, 24, 38)
    copy.BorderSizePixel = 0
    copy.Font = Enum.Font.GothamBold
    copy.Text = "COPY DISCORD INVITE"
    copy.TextColor3 = Color3.fromRGB(200, 195, 215)
    copy.TextSize = 11
    Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 8)
    
    copy.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            copy.Text = "COPIED INVITE LINK"
            copy.TextColor3 = Color3.fromRGB(120, 255, 160)
            task.wait(1.5)
            if copy.Parent then 
                copy.Text = "COPY DISCORD INVITE"
                copy.TextColor3 = Color3.fromRGB(200, 195, 215) 
            end
        end
    end)

    -- Close Window Button
    local close = Instance.new("TextButton", main)
    close.Position = UDim2.new(1, -34, 0, 10)
    close.Size = UDim2.new(0, 24, 0, 24)
    close.BackgroundTransparency = 1
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(140, 130, 155)
    close.TextSize = 15
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Entrance Animation
    main.BackgroundTransparency = 1
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.08}):Play()
end

startVerificationProcess()
