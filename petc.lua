-- Version 1.3

-- Script settings
getgenv().Settings = {
  KrakenRespawn = false,
  Keybinds = {
      KrakenToggle = Enum.KeyCode.R
  }
}

-- Defining GetService
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to send notifications
local function KrakenRespawnNotification(title, text)
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = tostring(title),
      Text = tostring(text),
      Duration = 1
  })
end

-- Notify when the script is loaded
print("Loaded")
KrakenRespawnNotification("Status", "Script Has Been Loaded")
KrakenRespawnNotification("Kraken Auto Respawn", "Default: " .. tostring(Settings.KrakenRespawn))

-- Listen for key presses
UIS.InputBegan:Connect(function(input)
  -- Check if the input is the toggle key
  if input.KeyCode == Settings.Keybinds.KrakenToggle then
      -- Toggle the script state
      Settings.KrakenRespawn = not Settings.KrakenRespawn
      -- Log the change
      print("Kraken Auto Respawn is now:", Settings.KrakenRespawn)
      -- Send notification about state
      KrakenRespawnNotification("Kraken Auto Respawn", "Default: " .. tostring(Settings.KrakenRespawn))
  end
end)

-- Loop Kraken respawn
while true do
  if Settings.KrakenRespawn then
      -- Respawn Kraken
      ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
      -- Log Kraken respawn
      print("Respawned")
      task.wait(4)
  else
      task.wait(1)
  end
end
