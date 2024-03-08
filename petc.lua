-- Function to send notifications on the bottom right of the screen
local function SendNotification(message)
    -- Set a system message on the chat with specified properties
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = message, -- Notification message
        Color = Color3.new(1, 1, 0), -- Text color (yellow)
        Font = Enum.Font.SourceSansBold, -- Font style
        FontSize = Enum.FontSize.Size18, -- Font size
        BackgroundColor = Color3.new(0.5, 0.5, 0.5), -- Greyish background color
        BackgroundTransparency = 0.5 -- Transparency of the background
    })
end

-- Script settings
getgenv().Settings = {
    Enabled = false, -- Initially disabled
    Keybinds = {
        Toggle = Enum.KeyCode.R -- Keybind to toggle the script
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
            SendNotification("Auto Respawn Enabled!")
        else
            SendNotification("Auto Respawn Disabled!")
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
