-- [[ Build a Bridge to Brainrots | Premium Teleport & Automation Suite ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ Configuration & Coordinates ]] --
local Locations = {
    Secret = Vector3.new(-128, 38, 629),
    God    = Vector3.new(-131, 36, 837),
    OG     = Vector3.new(-128, 12, 1091),
    Base   = Vector3.new(-128, 12, -144),
    RebirthPad = Vector3.new(20, 5, 20) -- Confirmed working
}

local Window = Rayfield:CreateWindow({
   Name = "🧠 Brainrot Bridge | Multi-Tool 🧠",
   LoadingTitle = "Securing Script Connection...",
   LoadingSubtitle = "Milky Scrips",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "Discord Exclusive Key",
      Subtitle = "Get the key from our Discord Server!",
      Note = "Join the link in the description to copy the daily key.",
      FileName = "BrainrotKeyConfig", 
      SaveKey = true, 
      GrabKeyFromUrl = false, 
      Key = {"MILKYWAY"}
   }
})

-- [[ Core Teleport Function ]] --
local function TeleportTo(coords)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        rootPart.CFrame = CFrame.new(coords + Vector3.new(0, 3, 0))
    end
end

-- [[ Smart Upgrade Location Finder ]] --
local function findUpgradeStation()
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") or object:IsA("Model") then
            local name = object.Name:lower()
            if name:find("upgrade") or name:find("shop") or name:find("storage") then
                return object:IsA("Model") and object:GetPivot().Position or object.Position
            end
        end
    end
    return nil
end

-- [[ TAB 1: INSTANT WARPS ]] --
local MainTab = Window:CreateTab("Instant Warps", 4483362458)

MainTab:CreateSection("Select Rarity Level")

MainTab:CreateButton({
   Name = "✨ Teleport to Secret Level",
   Callback = function() TeleportTo(Locations.Secret) end,
})

MainTab:CreateButton({
   Name = "⚡ Teleport to God Level",
   Callback = function() TeleportTo(Locations.God) end,
})

MainTab:CreateButton({
   Name = "🔥 Teleport to OG Level",
   Callback = function() TeleportTo(Locations.OG) end,
})

MainTab:CreateSection("Server Return System")

MainTab:CreateButton({
   Name = "🏠 GO TO BASE (Instant Cash In & Warp)",
   Callback = function()
       pcall(function()
           game:GetService("ReplicatedStorage").Remotes.BridgeClearedEvent:FireServer()
       end)
       task.wait(0.05)
       TeleportTo(Locations.Base)
   end,
})

-- [[ TAB 2: PROGRESSION & UPGRADES ]] --
local UpgradeTab = Window:CreateTab("Progression", 4483362458)

UpgradeTab:CreateSection("Manual Upgrades")

UpgradeTab:CreateButton({
   Name = "🎒 Buy Logs Storage (Single Upgrade)",
   Callback = function()
       local player = game:GetService("Players").LocalPlayer
       local character = player.Character
       local rootPart = character and character:FindFirstChild("HumanoidRootPart")
       
       if rootPart then
           local upgradePos = findUpgradeStation()
           
           if upgradePos then
               local oldCFrame = rootPart.CFrame
               
               -- Quick bypass teleport sequence
               rootPart.CFrame = CFrame.new(upgradePos + Vector3.new(0, 2, 0))
               task.wait(0.1)
               
               pcall(function()
                   game:GetService("ReplicatedStorage").Remotes.BuyUpgradeEvent:FireServer()
               end)
               
               task.wait(0.1)
               rootPart.CFrame = oldCFrame
               
               Rayfield:Notify({
                  Title = "Upgrade Purchased",
                  Content = "Sent single storage upgrade request.",
                  Duration = 2,
                  Image = 4483362458,
               })
           else
               -- Fallback: fire it anyway if the map finder doesn't see the vendor model names
               pcall(function()
                   game:GetService("ReplicatedStorage").Remotes.BuyUpgradeEvent:FireServer()
               end)
           end
       end
   end,
})

UpgradeTab:CreateSection("Prestige System")

UpgradeTab:CreateButton({
   Name = "🌟 Instant Rebirth",
   Callback = function()
       local player = game:GetService("Players").LocalPlayer
       local character = player.Character
       local rootPart = character and character:FindFirstChild("HumanoidRootPart")
       
       if rootPart then
           local oldCFrame = rootPart.CFrame
           
           rootPart.CFrame = CFrame.new(Locations.RebirthPad)
           task.wait(0.1)
           pcall(function()
               game:GetService("ReplicatedStorage").Remotes.RebirthEvent:FireServer()
           end)
           task.wait(0.1)
           rootPart.CFrame = oldCFrame
           
           Rayfield:Notify({
              Title = "Rebirth Triggered",
              Content = "Completed location check and fired remote.",
              Duration = 2.5,
              Image = 4483362458,
           })
       end
   end,
})
