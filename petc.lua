-- V1.04
-- Function to send notifications
local function SendNotification(title, text)
  game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = tostring(title),
      Text = tostring(text),
      Duration = 1 -- Adjust the duration as needed
  })
end

-- Script settings
getgenv().Settings = {
  Enabled = false,
  Keybinds = {
      Toggle = Enum.KeyCode.R
  }
}

local UIS = game:GetService("UserInputService")

-- Listen for key presses
UIS.InputBegan:Connect(function(input)
  -- Check if the pressed key is the toggle key
  if input.KeyCode == Settings.Keybinds.Toggle then
      -- Toggle the script state
      Settings.Enabled = not Settings.Enabled
      -- Notify the user about the script state change
      if Settings.Enabled then
          SendNotification("Auto Respawn", "Enabled")
      else
          SendNotification("Auto Respawn", "Disabled")
      end
  end
end)

-- Continuous loop to perform action if script is enabled
while true do
  if Settings.Enabled then
      -- Fire the server event to respawn the boss
      game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
      task.wait(5) -- Wait for 5 seconds before next respawn
  else
      task.wait(1) -- If script is disabled, wait for 1 second before checking again
  end
end
