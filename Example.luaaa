local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunarXhvb/Library/refs/heads/main/Library.luaa"))()



-- Start loading animation (optional)
if Library:LoadAnimation() then
    Library:StartLoad()
end

-- Create Window
local Window = Library:Window({
    SubTitle = "v2.0",
    Size = UDim2.new(0, 400, 0, 400),
    TabWidth = 150
})

-- Create Tab
local Tab = Window:Tab("Main", "rbxassetid://10734898355")

-- Button
Tab:Button("Click Me", function()
    print("Button clicked!")
    Library:Notify("Button was clicked!")
end)

-- Toggle
Tab:Toggle("Enable Feature", false, "Toggle this feature", function(state)
    print("Toggle:", state)
end)

-- Dropdown
Tab:Dropdown("Select Option", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(selected)
    print("Selected:", selected)
end)

-- Slider
Tab:Slider("Speed", 0, 100, 50, function(value)
    print("Speed:", value)
end)

-- Textbox
Tab:Textbox("Enter Text", "placeholder", function(text)
    print("Input:", text)
end)

-- Label
local MyLabel = Tab:Label("This is a label")

-- Separator
Tab:Seperator("Settings")

-- Line
Tab:Line()

-- Show notification when loaded
if Library:LoadAnimation() then
    Library:Loaded()
end

Library:Notify("Script loaded successfully!")
