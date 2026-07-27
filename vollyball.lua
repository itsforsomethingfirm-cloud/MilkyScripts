-- ============================================
-- 🥛 MILKY HUB - VOLLEYBALL AUTOMATIONS
-- Integrated 24-Hour Discord Whitelist System
-- ============================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔗 YOUR RENDER BACKEND URL (No trailing slash)
local RENDER_URL = "https://milkykey.onrender.com/"

-- ============================================
-- 🔒 24-HOUR DISCORD WHITELIST GATE
-- ============================================
local checkUrl = RENDER_URL .. "/check?user=" .. LocalPlayer.Name
local successCheck, response = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(checkUrl))
end)

-- If whitelist check fails or expired, kick player immediately
if not (successCheck and response and response.allowed) then
    LocalPlayer:Kick("\n❌ ACCESS DENIED\n\nPlease run '/verify " .. LocalPlayer.Name .. "' on Discord to activate your 24-hour pass!")
    return
end

print("✅ Whitelist verified for " .. LocalPlayer.Name .. "! Loading Milky Hub...")

-- ============================================
-- 🚀 MAIN SCRIPT - RAYFIELD VBL AUTOMATIONS
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ CREATE MAIN WINDOW ]]
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

   KeySystem = false -- Managed via Discord /verify
})

-- Remote Detection (Knit Framework)
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

-- Tab
local MainTab = Window:CreateTab("Automations", 4483362458)

-- Toggles
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
