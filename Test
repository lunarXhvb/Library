local Lunar = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunarXhvb/Library/refs/heads/main/Library.luau"))()

Lunar:StartLoad()
wait(2)
Lunar:Loaded()

local Window = Lunar:Window({
    SubTitle = "Example GUI"
})

local MainTab = Window:Tab("Main", "rbxassetid://10723415903")
local SettingsTab = Window:Tab("Settings", "rbxassetid://10734950020")

MainTab:Label("Welcome to Lunar Hub", "This is an example GUI")

MainTab:Button("Test Button", function()
    Lunar:Notify("Button clicked!")
end)

MainTab:Toggle("Enable ESP", false, function(state)
    print("ESP:", state)
end)

MainTab:Dropdown("Select Game Mode", {
    "Normal", 
    "Hard", 
    "Expert"
}, "Normal", function(mode)
    print("Game mode:", mode)
end)

SettingsTab:Slider("Walk Speed", {
    min = 16,
    max = 100,
    def = 16,
    callback = function(speed)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
})

SettingsTab:Textbox("Custom Username", {
    placeholder = "Enter username...",
    clearonfocus = true
}, function(name)
    print("Username set to:", name)
end)

SettingsTab:Keybind("Toggle GUI", {
    def = Enum.KeyCode.RightShift
}, function(key)
    game.CoreGui.LUNAR.Enabled = not game.CoreGui.LUNAR.Enabled
end)
