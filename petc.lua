--[[
Script version 1.5
Works on game version 1.01a

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
      BuyCooldown = 5,      -- Cooldown period after buying all items
      CheckCooldown = 1     -- Cooldown for checking if the actions should be performed
  }
}

-- Services
local version = "version 1.5"
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

-- Function to buy an item from the Black Market
local function BuyItem(itemIndex)
  local success, RemoteEvent = pcall(function()
      return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event")
  end)
  if success then
      RemoteEvent:FireServer("BuyShopItem", "the-blackmarket", itemIndex)
      print("Bought Item " .. itemIndex)
  else
      warn("Failed to find RemoteEvent for buying items from Black Market.")
  end
end

-- Notify script loading and initial settings
print("Loaded script " .. version)
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

-- Loop to repeatedly buy items from the Black Market
while true do
    if Settings.BuyBlackMarket then
        for i = 1, 3 do
            BuyItem(i)
            wait(Settings.Timers.BuyDelay)
        end
        wait(Settings.Timers.BuyCooldown)
    else
        wait(Settings.Timers.CheckCooldown)
    end
end
