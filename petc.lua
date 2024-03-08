--[[
Toggle Kraken Respawn is J
Toggle Black Market Auto Buy is K
--]]

-- Settings and default configurations
local Settings = getgenv().Settings or {
  KrakenRespawn = false,  -- Toggle for Kraken respawn
  BuyBlackMarket = false, -- Toggle for Black Market auto buy
  Keybinds = {
      KrakenToggle = Enum.KeyCode.J,       -- Keybind for toggling Kraken respawn
      BlackMarketToggle = Enum.KeyCode.K   -- Keybind for toggling Black Market auto buy
  },
  Timers = {
      RespawnCooldown = 4,  -- Wait time between Kraken respawns
      BuyDelay = 0.1,       -- Delay between buying each item
      BuyCooldown = 1,      -- Cooldown period after buying all items
      CheckCooldown = 1     -- Cooldown for checking if the actions should be performed
  },
  Versions = {
    ScriptVersion = "1.6",       -- Script version
    GameVersion = "1.01a"      -- Game version
  }
}

-- Services
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to display notifications
local function ActivityNotification(title, text)
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = tostring(title),
      Text = tostring(text),
      Duration = 1
  })  
end

-- Function to respawn the Kraken
local function RespawnKraken()
    while true do
        if Settings.KrakenRespawn then
            local success, RemoteEvent = pcall(function()
                return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event")
            end)
            if success then
                RemoteEvent:FireServer("RespawnBoss", "the-kraken")
                print("Respawned Kraken")
                task.wait(Settings.Timers.RespawnCooldown)
            else
                warn("Failed to find RemoteEvent for Kraken respawn.")
            end
        else
            task.wait(Settings.Timers.CheckCooldown)
            break  -- Exit the loop when KrakenRespawn is set to false
        end
    end
end

-- Function to buy an item from the Black Market
local function BuyItem(itemIndex)
    local success, RemoteEvent = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event")
    end)
    if success then
        local result = RemoteEvent:FireServer("BuyShopItem", "the-blackmarket", itemIndex)
    else
        warn("Failed to find RemoteEvent for buying items from Black Market.")
    end
end

-- Function to automatically buy items from the Black Market
local function BuyBlackMarket()
    while true do 
        if Settings.BuyBlackMarket then
            for i = 1, 3 do
                BuyItem(i)
                task.wait(Settings.Timers.BuyDelay)
            end
            task.wait(Settings.Timers.BuyCooldown)
        else
            task.wait(Settings.Timers.CheckCooldown)
        end
    end
end

-- Notify script loading and initial settings
print("Loaded script version " .. Settings.Versions.ScriptVersion)
print("Works on game version " .. Settings.Versions.GameVersion)
ActivityNotification("Status", "Script Has Been Loaded")
ActivityNotification("Kraken Auto Respawn", "Default: " .. tostring(Settings.KrakenRespawn))
ActivityNotification("Black Market Auto Buy", "Default: " .. tostring(Settings.BuyBlackMarket))

-- Listen for key presses to toggle settings
UIS.InputBegan:Connect(function(input)
  if input.KeyCode == Settings.Keybinds.KrakenToggle then
      Settings.KrakenRespawn = not Settings.KrakenRespawn
      print("Kraken Auto Respawn is now:", Settings.KrakenRespawn)
      ActivityNotification("Kraken Auto Respawn", "Status: " .. tostring(Settings.KrakenRespawn))
  elseif input.KeyCode == Settings.Keybinds.BlackMarketToggle then
      Settings.BuyBlackMarket = not Settings.BuyBlackMarket
      print("Black Market Auto Buy is now: ", Settings.BuyBlackMarket)
      ActivityNotification("Black Market Auto Buy", "Status: " .. tostring(Settings.BuyBlackMarket))
  end
end)

-- Start the functions
RespawnKraken()
BuyBlackMarket()
