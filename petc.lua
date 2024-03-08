-- Settings and default configurations
local Settings = getgenv().Settings or {
    Versions = {
        ScriptVersion = "1.7", -- Script version
        GameVersion = "1.01a" -- Game version
    },
    Toggles = { 
        KrakenRespawn = false, -- Toggle for Kraken respawn
        BuyBlackMarket = false, -- Toggle for Black Market auto buy
        ScriptEnabled = true -- Toggle for enabling/disabling the script
    },
    Keybinds = {
        KrakenToggle = Enum.KeyCode.J, -- Keybind for toggling Kraken respawn
        BlackMarketToggle = Enum.KeyCode.K, -- Keybind for toggling Black Market auto buy
        ToggleScript = Enum.KeyCode.U -- Keybind for enabling/disabling the script
    },
    Timers = {
        RespawnCooldown = 4, -- Wait time between Kraken respawns
        BuyDelay = 0.1, -- Delay between buying each item
        BuyCooldown = 1, -- Cooldown period after buying all items
        CheckCooldown = 1, -- Cooldown for checking if the actions should be performed
        NotificationDuration = 1 -- Duration of the notification
    },
}

-- Services
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to display notifications
local function ActivityNotification(title, text)
    if Settings.Toggles.ScriptEnabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tostring(title),
            Text = tostring(text),
            Duration = Settings.Timers.NotificationDuration
        })
    end
end

-- Function to print notifications to the console
local function ConsoleNotification(title, text)
    if Settings.Toggles.ScriptEnabled then
        print(tostring(title) .. " : " .. tostring(text))
    end
end

-- Function to respawn the Kraken
local function RespawnKraken()
    while true do
        if Settings.Toggles.KrakenRespawn and Settings.Toggles.ScriptEnabled then
            local success, errorMessage = pcall(function()
                ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild(
                    "Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
                wait(Settings.Timers.RespawnCooldown)
            end)

            if not success then
                warn("Error while respawning Kraken:", errorMessage)
            end
        else
            wait(Settings.Timers.CheckCooldown)
        end
    end
end

-- Function to buy an item from the Black Market
local function BuyItem(itemIndex)
    local success, RemoteEvent = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild(
            "Remote"):WaitForChild("Event")
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
        if Settings.Toggles.BuyBlackMarket and Settings.Toggles.ScriptEnabled then
            for i = 1, 3 do
                BuyItem(i)
                wait(Settings.Timers.BuyDelay)
            end
            wait(Settings.Timers.BuyCooldown)
        else
            wait(Settings.Timers.CheckCooldown)
        end
    end
end

-- Function to toggle script enable/disable
local function ToggleScript()
    Settings.Toggles.ScriptEnabled = not Settings.Toggles.ScriptEnabled
    if Settings.Toggles.ScriptEnabled then
        ActivityNotification("Script Enabled", "Press U to toggle the script off")
    else
        ActivityNotification("Script Disabled", "Press U to toggle the script on")
    end
end

-- Notify script loading and initial settings
print("av / hari")
print("Loaded script version " .. Settings.Versions.ScriptVersion)
print("Works on game version " .. Settings.Versions.GameVersion)
ActivityNotification("Status", "Script Has Been Loaded")
ActivityNotification("Kraken Auto Respawn", "Default: " .. tostring(Settings.Toggles.KrakenRespawn))
ActivityNotification("Black Market Auto Buy", "Default: " .. tostring(Settings.Toggles.BuyBlackMarket))
ActivityNotification("Script Enabled", "Script functionality is enabled.")

-- Listen for key presses to toggle settings and enable/disable script
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Settings.Keybinds.KrakenToggle and Settings.Toggles.ScriptEnabled then
        Settings.Toggles.KrakenRespawn = not Settings.Toggles.KrakenRespawn
        ConsoleNotification("Kraken Auto Respawn is now:", Settings.Toggles.KrakenRespawn)
        ActivityNotification("Kraken Auto Respawn", "Status: " .. tostring(Settings.Toggles.KrakenRespawn))
    elseif input.KeyCode == Settings.Keybinds.BlackMarketToggle and Settings.Toggles.ScriptEnabled then
        Settings.Toggles.BuyBlackMarket = not Settings.Toggles.BuyBlackMarket
        ConsoleNotification("Black Market Auto Buy is now: ", Settings.Toggles.BuyBlackMarket)
        ActivityNotification("Black Market Auto Buy", "Status: " .. tostring(Settings.Toggles.BuyBlackMarket))
    elseif input.KeyCode == Settings.Keybinds.ToggleScript then
        ToggleScript()
    end
end)

-- Start the functions as coroutines
coroutine.wrap(BuyBlackMarket)()
coroutine.wrap(RespawnKraken)()
