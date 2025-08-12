local Library = loadstring(game:HttpGet("your-script-url"))()

-- Create Window
local Window = Library:CreateWindow({
    Title = "LUNAR HUB",
    SubTitle = "v2.0",
    Size = UDim2.fromOffset(830, 525)
})

-- Create Tab
local Tab = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://10734898355"
})

-- Button
Tab:CreateButton({
    Title = "Click Me",
    Description = "This is a button",
    Callback = function()
        print("Button clicked!")
    end
})

-- Toggle
Tab:CreateToggle("toggle1", {
    Title = "Enable Feature",
    Description = "Toggle this feature on/off",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Slider
Tab:CreateSlider("slider1", {
    Title = "Speed",
    Description = "Adjust speed value",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})

-- Dropdown
Tab:CreateDropdown("dropdown1", {
    Title = "Select Option",
    Description = "Choose an option",
    Values = {"Option 1", "Option 2", "Option 3"},
    Default = 1,
    Callback = function(value)
        print("Dropdown:", value)
    end
})

-- Input
Tab:CreateInput("input1", {
    Title = "Username",
    Default = "",
    Placeholder = "Enter username...",
    Callback = function(value)
        print("Input:", value)
    end
})

-- Paragraph
Tab:CreateParagraph("paragraph1", {
    Title = "Information",
    Content = "This is some information text that can span multiple lines."
})

-- Notification
Library:Notify({
    Title = "Success",
    Content = "Script loaded successfully!",
    Duration = 5
})

-- Dialog
Window:Dialog({
    Title = "Confirm Action",
    Content = "Are you sure you want to continue?",
    Buttons = {
        {
            Title = "Yes",
            Callback = function()
                print("Confirmed")
            end
        },
        {
            Title = "No", 
            Callback = function()
                print("Cancelled")
            end
        }
    }
})
