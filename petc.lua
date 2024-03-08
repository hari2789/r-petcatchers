getgenv().Settings = {
  Enabled = false,
  Keybinds = {
      Toggle = Enum.KeyCode.R
  }
}

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input)
  if input.KeyCode == Settings.Keybinds.Toggle then
      Settings.Enabled = not Settings.Enabled
  end
end)

while true do
  if Settings.Enabled then
      game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
      task.wait(5)
  else
      task.wait(1)
  end
end