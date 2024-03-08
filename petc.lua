-- V1.06
-- Function to send notifications
local function KrakenRespawnNotification(title, text)
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = tostring(title),
      Text = tostring(text),
      Duration = 1 -- Adjust the duration as needed
  })
end

-- Script settings
getgenv().Settings = {
  KrakenRespawn = false,
  Keybinds = {
      KrakenToggle = Enum.KeyCode.R
  }
}

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

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
      RS:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
      task.wait(4) -- Wait for 4 seconds before next respawn
  else
      task.wait(1) -- If script is disabled, wait for 1 second before checking again
  end
end
