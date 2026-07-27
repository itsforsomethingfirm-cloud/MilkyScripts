-- ============================================
-- 🥛 MILKY HUB - VOLLEYBALL AUTOMATIONS
-- Whitelisted via Discord 24h Gate
-- ============================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RENDER_URL = "https://milkykey.onrender.com"
local DISCORD_INVITE = "https://discord.gg/YOUR_DISCORD_CODE" -- 👈 Replace with your Discord link!

-- Function to display Verification Instructions UI if not whitelisted
local function showVerificationUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local UserInfo = Instance.new("TextLabel")
    local InstructionLabel = Instance.new("TextLabel")
    local CopyButton = Instance.new("TextButton")
    local ButtonCorner = Instance.new("UICorner")

    ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "MilkyVerifyUI"

    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
    MainFrame.Size = UDim2.new(0, 360, 0, 240)
    MainFrame.Active = true
    MainFrame.Draggable = true

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    Title.Parent = MainFrame
    Title.Text = "🥛 Milky Hub - Verification Required"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.Size = UDim2.new(1, 0, 0, 40)

    UserInfo.Parent = MainFrame
    UserInfo.Text = "Your Roblox Username: " .. LocalPlayer.Name
    UserInfo.TextColor3 = Color3.fromRGB(100, 200, 255)
    UserInfo.TextSize = 14
    UserInfo.Font = Enum.Font.SourceSansSemibold
    UserInfo.Position = UDim2.new(0, 0, 0, 40)
    UserInfo.Size = UDim2.new(1, 0, 0, 25)

    InstructionLabel.Parent = MainFrame
    InstructionLabel.Text = "To unlock access for 24 hours:\n1. Join our Discord server.\n2. Run this command: /verify " .. LocalPlayer.Name
    InstructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InstructionLabel.TextSize = 14
    InstructionLabel.Font = Enum.Font.SourceSans
    InstructionLabel.Position = UDim2.new(0, 20, 0, 75)
    InstructionLabel.Size = UDim2.new(1, -40, 0, 80)
    InstructionLabel.TextWrapped = true

    CopyButton.Parent = MainFrame
    CopyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    CopyButton.Position = UDim2.new(0.1, 0, 0.75, 0)
    CopyButton.Size = UDim2.new(0.8, 0, 0, 40)
    CopyButton.Text = "📋 Copy Discord Invite Link"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.Font = Enum.Font.SourceSansBold
    CopyButton.TextSize = 15

    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = CopyButton

    CopyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            CopyButton.Text = "✅ Discord Link Copied!"
            task.wait(2)
            CopyButton.Text = "📋 Copy Discord Invite Link"
        else
            CopyButton.Text = "Copy manually: " .. DISCORD_INVITE
        end
    end)
end

-- ============================================
-- 🔒 WHITELIST CHECK
-- ============================================
local checkUrl = RENDER_URL .. "/check?user=" .. HttpService:UrlEncode(LocalPlayer.Name)
local successCheck, response = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(checkUrl))
end)

-- If whitelist check fails, show Verification UI and don't load script
if not (successCheck and response and response.allowed) then
    showVerificationUI()
    return
end

print("✅ Whitelist verified for " .. LocalPlayer.Name .. "! Loading Milky Hub...")

-- ============================================
-- 🚀 MAIN SCRIPT - RAYFIELD VBL AUTOMATIONS
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🥛 Milky Hub",
   Icon = 0,
   LoadingTitle = "Milky Hub",
   LoadingSubtitle = "by Milky",
   Theme = "Default",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MilkyHubConfig",
      FileName = "Settings"
   },

   KeySystem = false
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local success, remote = pcall(function()  
    return ReplicatedStorage:WaitForChild("Packages")
                            :WaitForChild("_Index")
                            :WaitForChild("sleitnick_knit@1.7.0")
                            :WaitForChild("knit")
                            :WaitForChild("Services")
                            :WaitForChild("SeasonService")
                            :WaitForChild("RF")
                            :WaitForChild("RequestRankedReward")  
end)

local MainTab = Window:CreateTab("Automations", 4483362458)

MainTab:CreateToggle({
   Name = "🎰 Lucky Spins",
   CurrentValue = false,
   Flag = "Toggle_Spins",
   Callback = function(Value)
      _G.L = Value
      task.spawn(function()
         while _G.L do
            if success and remote then
               pcall(function() remote:InvokeServer(1) end)
            end
            task.wait(0.5)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "💰 Auto Yen",
   CurrentValue = false,
   Flag = "Toggle_Yen",
   Callback = function(Value)
      _G.Y = Value
      task.spawn(function()
         while _G.Y do
            if success and remote then
               pcall(function() remote:InvokeServer(2) end)
            end
            task.wait(0.6)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "⚡ Auto Habilidades",
   CurrentValue = false,
   Flag = "Toggle_Skills",
   Callback = function(Value)
      _G.H = Value
      task.spawn(function()
         while _G.H do
            if success and remote then
               pcall(function() remote:InvokeServer(4) end)
            end
            task.wait(1.5)
         end
      end)
   end,
})

Rayfield:Notify({
   Title = "Milky Hub Loaded",
   Content = "Welcome to Milky Hub! 24h Pass Active.",
   Duration = 5,
})
