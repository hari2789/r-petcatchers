--[[

    Made by Av & Hari
    Version: v1.8
    Game Version: v1.1.2

    Press J to toggle Kraken respawn
    Press K to toggle Black Market auto buy
    Press U to toggle the script on/off

]] local function Script()
    -- Settings and default configurations
    local Settings = {
        Toggles = {
            ScriptEnabled = true, -- Toggle for enabling/disabling the script
            KrakenRespawn = false, -- Toggle for Kraken respawn
            BuyBlackMarket = false -- Toggle for Black Market auto buy
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
        Versions = {
            ScriptVersion = "v1.8", -- Script Version
            StableGameVersion = "v1.1.2" -- Game Version
        }
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
                    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network")
                        :WaitForChild("Remote"):WaitForChild("Event"):FireServer("RespawnBoss", "the-kraken")
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
    local function BuyItem(shop, itemIndex)
        local success, RemoteEvent = pcall(function()
            return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network")
                :WaitForChild("Remote"):WaitForChild("Event")
        end)
        if success then
            local result = RemoteEvent:FireServer("BuyShopItem", shop, itemIndex)
        else
            warn("Failed to find RemoteEvent for buying items from Black Market.")
        end
    end

    -- Function to automatically buy items from the Black Market
    local function BuyBlackMarket()
        while true do
            if Settings.Toggles.BuyBlackMarket and Settings.Toggles.ScriptEnabled then
                for i = 1, 3 do
                    BuyItem("the-blackmarket", i)
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
            ConsoleNotification("Enabled", "Script is enabled. Press U to toggle the script off")
            ActivityNotification("Enabled", "Script is enabled. Press U to toggle the script off")
        else
            Settings.Toggles.ScriptEnabled = not Settings.Toggles.ScriptEnabled
            ConsoleNotification("Disabled", "Script is disabled. Press U to toggle the script on")
            ActivityNotification("Disabled", "Script is disabled. Press U to toggle the script on")
            Settings.Toggles.ScriptEnabled = not Settings.Toggles.ScriptEnabled
        end
    end

    -- Notify script loading and initial Settings
    warn("Made by Av & Hari")
    warn("Loaded script Version " .. tostring(Settings.Versions.ScriptVersion))
    warn("Works on game Version " .. tostring(Settings.Versions.StableGameVersion))
    ConsoleNotification("Kraken Auto Respawn", "Default: " .. tostring(Settings.Toggles.KrakenRespawn))
    ConsoleNotification("Black Market Auto Buy", "Default: " .. tostring(Settings.Toggles.BuyBlackMarket))
    ConsoleNotification("Script Enabled", "Default: " .. tostring(Settings.Toggles.ScriptEnabled))
    ActivityNotification("Script Enabled", "Script is enabled.")

    -- Check if the Mouse object is available
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    if not mouse then
        warn("Mouse object is not available.")
        return
    end

    -- Function to check if the user is typing
    local function isTyping()
        return game:GetService("UserInputService"):GetFocusedTextBox()
    end

    -- Listen for key presses to toggle Settings and enable/disable script
    local keybinds = {Settings.Keybinds.KrakenToggle, Settings.Keybinds.BlackMarketToggle, Settings.Keybinds.ToggleScript}
    -- Listen for key presses to toggle Settings and enable/disable script
    UIS.InputBegan:Connect(function(input, isProcessed)
        if not isProcessed then
            -- Check if the input matches any of the keybinds
            for _, keybind in ipairs(keybinds) do
                if input.KeyCode == keybind then
                    -- Process key press if the user is not typing
                    if keybind == Settings.Keybinds.KrakenToggle and Settings.Toggles.ScriptEnabled then
                        Settings.Toggles.KrakenRespawn = not Settings.Toggles.KrakenRespawn
                        ConsoleNotification("Kraken Auto Respawn is now", Settings.Toggles.KrakenRespawn)
                        ActivityNotification("Kraken Auto Respawn",
                            "Status: " .. tostring(Settings.Toggles.KrakenRespawn))
                    elseif keybind == Settings.Keybinds.BlackMarketToggle and Settings.Toggles.ScriptEnabled then
                        Settings.Toggles.BuyBlackMarket = not Settings.Toggles.BuyBlackMarket
                        ConsoleNotification("Black Market Auto Buy is now", Settings.Toggles.BuyBlackMarket)
                        ActivityNotification("Black Market Auto Buy",
                            "Status: " .. tostring(Settings.Toggles.BuyBlackMarket))
                    elseif keybind == Settings.Keybinds.ToggleScript then
                        ToggleScript()
                    end
                end
            end
        end
    end)

    -- Start the functions as coroutines
    coroutine.wrap(BuyBlackMarket)()
    coroutine.wrap(RespawnKraken)()
end

Script() -- Call the encapsulated script function to execute the code
