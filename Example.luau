local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunarXhvb/Library/refs/heads/main/Library.luau"))()

local Window = Library:CreateWindow({
    Title = "LUNAR HUB",
    SubTitle = "v2.0",
    Size = UDim2.fromOffset(830, 525),
    MinSize = Vector2.new(470, 380),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tab = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://10734898355"
})
Tab:CreateButton({
    Title = "Execute Script",
    Description = "Run the main script functionality",
    Callback = function()
        print("Button executed")
    end
})

Tab:CreateButton({
    Title = "Simple Button",
    Callback = function()
        print("Simple button clicked")
    end
})
local Toggle1 = Tab:CreateToggle("toggle1", {
    Title = "Auto Farm",
    Description = "Automatically farm resources",
    Default = false,
    Callback = function(enabled)
        if enabled then
            print("Auto farm enabled")
        else
            print("Auto farm disabled")
        end
    end
})

local Toggle2 = Tab:CreateToggle("toggle2", {
    Title = "God Mode",
    Default = true,
    Callback = function(enabled)
        print("God mode:", enabled)
    end
})

Toggle1:SetValue(true)

local Slider1 = Tab:CreateSlider("slider1", {
    Title = "Walk Speed",
    Description = "Adjust character movement speed",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

local Slider2 = Tab:CreateSlider("slider2", {
    Title = "Jump Power",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 5,
    Callback = function(value)
        print("Jump power set to:", value)
    end
})

local Slider3 = Tab:CreateSlider("slider3", {
    Title = "FOV",
    Description = "Field of view adjustment",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0.1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

Slider1:SetValue(25)
Slider2:OnChanged(function(value)
    print("New jump power:", value)
end)

local Dropdown1 = Tab:CreateDropdown("dropdown1", {
    Title = "Weapon Selection",
    Description = "Choose your primary weapon",
    Values = {"Sword", "Bow", "Staff", "Dagger"},
    Default = 1,
    Multi = false,
    Callback = function(selected)
        print("Selected weapon:", selected)
    end
})

local Dropdown2 = Tab:CreateDropdown("dropdown2", {
    Title = "ESP Features",
    Values = {"Player ESP", "Item ESP", "Mob ESP", "Chest ESP"},
    Multi = true,
    Default = {["Player ESP"] = true, ["Item ESP"] = false},
    Callback = function(selected)
        for feature, enabled in pairs(selected) do
            print(feature .. ":", enabled)
        end
    end
})

local Dropdown3 = Tab:CreateDropdown("dropdown3", {
    Title = "Teleport Location",
    Values = {"Spawn", "Shop", "Boss Arena", "Secret Area"},
    Default = 2,
    Callback = function(selected)
        print("Teleporting to:", selected)
    end
})

Dropdown1:SetValue("Staff")
Dropdown2:SetValue({["Player ESP"] = true, ["Chest ESP"] = true})
Dropdown3:SetValues({"New Location 1", "New Location 2"})

local Input1 = Tab:CreateInput("input1", {
    Title = "Player Name",
    Default = "",
    Placeholder = "Enter player name...",
    Numeric = false,
    Finished = true,
    Callback = function(text)
        print("Player name entered:", text)
    end
})

local Input2 = Tab:CreateInput("input2", {
    Title = "Amount",
    Default = "100",
    Placeholder = "Enter number...",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        print("Amount changed:", value)
    end
})

local Input3 = Tab:CreateInput("input3", {
    Title = "Chat Message",
    Placeholder = "Type message...",
    Callback = function(text)
        game.Players:Chat(text)
    end
})

print("Current player name:", Input1.Value)
Input2:OnChanged(function(value)
    print("Real-time amount:", value)
end)

local Paragraph1 = Tab:CreateParagraph("paragraph1", {
    Title = "Welcome",
    Content = "Welcome to LUNAR HUB v2.0! This is the most advanced script hub available.",
    TitleAlignment = "Left",
    ContentAlignment = Enum.TextXAlignment.Left
})

local Paragraph2 = Tab:CreateParagraph("paragraph2", {
    Title = "Instructions",
    Content = "1. Select your desired features from the tabs above\n2. Configure settings using sliders and dropdowns\n3. Enable toggles to activate features\n4. Use the minimize key to hide/show the GUI",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local Paragraph3 = Tab:CreateParagraph("paragraph3", {
    Title = "Status",
    Content = "All systems operational.",
    ContentAlignment = Enum.TextXAlignment.Right
})

Paragraph1:SetValue("Updated welcome message with new information!")
print("Current paragraph content:", Paragraph2.Value)

Library:Notify({
    Title = "LUNAR HUB",
    Content = "Script loaded successfully!",
    Duration = 3
})

Library:Notify({
    Title = "Warning",
    Content = "Low health detected",
    Duration = 5
})

Library:Notify({
    Title = "Achievement",
    Content = "Level up! You are now level 50"
})

Window:Dialog({
    Title = "Confirm Purchase",
    Content = "Are you sure you want to purchase this item for 1000 coins?",
    Buttons = {
        {
            Title = "Purchase",
            Callback = function()
                print("Item purchased")
                Library:Notify({
                    Title = "Success",
                    Content = "Item purchased successfully!"
                })
            end
        },
        {
            Title = "Cancel",
            Callback = function()
                print("Purchase cancelled")
            end
        }
    }
})

Window:Dialog({
    Title = "Error",
    Content = "An unexpected error occurred. Please restart the script.",
    Buttons = {
        {
            Title = "OK",
            Callback = function()
                print("Error acknowledged")
            end
        }
    }
})

Window:Dialog({
    Title = "Choose Action",
    Content = "What would you like to do next?",
    Buttons = {
        {
            Title = "Continue",
            Callback = function()
                print("Continue selected")
            end
        },
        {
            Title = "Save & Exit",
            Callback = function()
                print("Save and exit selected")
            end
        },
        {
            Title = "Cancel",
            Callback = function()
                print("Action cancelled")
            end
        }
    }
})

