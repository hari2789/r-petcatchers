-- V1.08

-- Function to send notifications
local function KrakenRespawnNotification(title, text)
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = tostring(title),
      Text = tostring(text),
      Duration = 1
  })
end

-- Notify when the script is loaded
KrakenRespawnNotification("Status", "Script Has Been Loaded")
KrakenRespawnNotification("Kraken Auto Respawn", "Default: Disabled")

-- Script settings
getgenv().Settings = {
  KrakenRespawn = false,
  Keybinds = {
      KrakenToggle = Enum.KeyCode.R
  }
}

local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Listen for key presses
UIS.InputBegan:Connect(function(input)
  -- Check if the pressed key is the toggle key
  if input.KeyCode == Settings.Keybinds.KrakenToggle then
      -- Toggle the script state
      Settings.KrakenRespawn = not Settings.KrakenRespawn
      -- Notify the user about the script state change
      if Settings.KrakenRespawn then
          KrakenRespawnNotification("Kraken Auto Respawn", "Enabled")
      else
          KrakenRespawnNotification("Kraken Auto Respawn", "Disabled")
      end
  end
end)

-- Continuous loop to perform action if script is enabled
while true do
  if Settings.KrakenRespawn then
      -- Fire the server event to respawn the boss
      ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
      task.wait(4)
  else
      task.wait(1)
  end
end
