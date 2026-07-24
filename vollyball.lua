-- [[ MILKY HUB - PROTECTED LUAU SCRIPT ]]
local _0x1 = loadstring
local _0x2 = game:HttpGet
local _0x3 = string.char

-- Encoded Rayfield Loader
local _0x4 = _0x1(_0x2(game, _0x3(104,116,116,112,115,58,47,47,115,105,114,105,117,115,46,109,101,110,117,47,114,101,121,102,105,101,108,100)))()

-- Encoded Endpoints & HWID Data
local _0x5 = "https://milkykey.onrender.com"
local _0x6 = _0x5 .. "/keys.txt"
local _0x7 = game:GetService("HttpService")
local _0x8 = game:GetService("RbxAnalyticsService"):GetClientId()

-- UI Window Init
local _0x9 = _0x4:CreateWindow({
   Name = "🥛 Milky Hub",
   Icon = 0,
   LoadingTitle = "Milky Hub",
   LoadingSubtitle = "by Milky",
   Theme = "Default", 
   ConfigurationSaving = { Enabled = true, FolderName = "MilkyHubConfig", FileName = "Settings" },
   KeySystem = true,
   KeySettings = {
      Title = "🥛 Milky Hub | Key System",
      Subtitle = "Authentication Required",
      Note = "HWID Locked Key System. Get a key from the owner!",
      FileName = "MilkyHubKey", 
      SaveKey = true,
      GrabKeyFromSite = true, 
      Key = { _0x6 } 
   }
})

-- HWID Verification Layer
local _0xA = syn and syn.request or http and http.request or http_request or request
if _0xA then
    local _0xB = ""
    if readfile and isfile and isfile("MilkyHubConfig/MilkyHubKey") then
        pcall(function() _0xB = readfile("MilkyHubConfig/MilkyHubKey") end)
    end
    if _0xB ~= "" then
        local _0xC = _0xA({
            Url = _0x5 .. "/verify-hwid",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = _0x7:JSONEncode({ key = _0xB, hwid = _0x8 })
        })
        if _0xC.StatusCode == 200 then
            _0x4:Notify({ Title = "Device Verified", Content = "HWID verified successfully!", Duration = 4 })
        else
            game.Players.LocalPlayer:Kick("[MILKY HUB] HWID Error: This key is bound to another device!")
            return
        end
    end
end

-- Automations Setup
local _0xD = _0x9:CreateTab("Automations", 4483362458)
local _0xE = game:GetService("ReplicatedStorage")
local _0xF, _0x10 = pcall(function()  
    return _0xE:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SeasonService"):WaitForChild("RF"):WaitForChild("RequestRankedReward")  
end)

_0xD:CreateToggle({
   Name = "🎰 Lucky Spins",
   CurrentValue = false,
   Flag = "Toggle_Spins",
   Callback = function(_0x11)
      _G.L = _0x11
      task.spawn(function()
         while _G.L do
            if _0xF and _0x10 then pcall(function() _0x10:InvokeServer(1) end) end
            task.wait(0.5)
         end
      end)
   end,
})

_0xD:CreateToggle({
   Name = "💰 Auto Yen",
   CurrentValue = false,
   Flag = "Toggle_Yen",
   Callback = function(_0x11)
      _G.Y = _0x11
      task.spawn(function()
         while _G.Y do
            if _0xF and _0x10 then pcall(function() _0x10:InvokeServer(2) end) end
            task.wait(0.6)
         end
      end)
   end,
})

_0xD:CreateToggle({
   Name = "⚡ Auto Habilidades",
   CurrentValue = false,
   Flag = "Toggle_Skills",
   Callback = function(_0x11)
      _G.H = _0x11
      task.spawn(function()
         while _G.H do
            if _0xF and _0x10 then pcall(function() _0x10:InvokeServer(4) end) end
            task.wait(1.5)
         end
      end)
   end,
})

_0x4:Notify({ Title = "Milky Hub Loaded", Content = "Welcome to Milky Hub!", Duration = 5 })
