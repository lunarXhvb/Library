if game:GetService("CoreGui"):FindFirstChild("LUNAR") and game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
    game:GetService("CoreGui").LUNAR:Destroy()
    game:GetService("CoreGui").ScreenGui:Destroy()
end

local Themes = {
    Default = {
        Primary = Color3.fromRGB(100, 100, 100),
        Dark = Color3.fromRGB(22, 22, 26),
        Accent = Color3.fromRGB(255, 0, 0)
    },
    Ocean = {
        Primary = Color3.fromRGB(80, 120, 150),
        Dark = Color3.fromRGB(15, 25, 35),
        Accent = Color3.fromRGB(0, 150, 255)
    },
    Forest = {
        Primary = Color3.fromRGB(90, 120, 80),
        Dark = Color3.fromRGB(20, 30, 18),
        Accent = Color3.fromRGB(50, 200, 50)
    },
    Sunset = {
        Primary = Color3.fromRGB(150, 90, 60),
        Dark = Color3.fromRGB(35, 20, 15),
        Accent = Color3.fromRGB(255, 140, 0)
    },
    Purple = {
        Primary = Color3.fromRGB(120, 80, 150),
        Dark = Color3.fromRGB(25, 15, 35),
        Accent = Color3.fromRGB(180, 100, 255)
    },
    Rose = {
        Primary = Color3.fromRGB(150, 90, 120),
        Dark = Color3.fromRGB(35, 20, 30),
        Accent = Color3.fromRGB(255, 100, 150)
    }
}

local CurrentTheme = Themes.Default
_G.Primary = CurrentTheme.Primary
_G.Dark = CurrentTheme.Dark
_G.Third = CurrentTheme.Accent

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function CreateRounded(Parent, Size)
    local Rounded = Instance.new("UICorner")
    Rounded.Name = "Rounded"
    Rounded.Parent = Parent
    Rounded.CornerRadius = UDim.new(0, Size)
    return Rounded
end

function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true,
    Theme = "Default"
}

getgenv().LoadConfig = function()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("LUNAR") then
            makefolder("LUNAR")
        end
        if not isfolder("LUNAR/Library/") then
            makefolder("LUNAR/Library/")
        end

        local configPath = "LUNAR/Library/" .. game.Players.LocalPlayer.Name .. ".json"
        if not isfile(configPath) then
            writefile(configPath, game:GetService("HttpService"):JSONEncode(SettingsLib))
        else
            local success, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(configPath))
            end)

            if success then
                for i, v in pairs(decoded) do
                    SettingsLib[i] = v
                end
            end
        end
        print("Lunar Hub Library Loaded!")
    else
        warn("Status: Undetected Executor")
    end
end

getgenv().SaveConfig = function()
    if readfile and writefile and isfile and isfolder then
        local configPath = "LUNAR/Library/" .. game.Players.LocalPlayer.Name .. ".json"
        if not isfile(configPath) then
            getgenv().LoadConfig()
        else
            local Array = {}
            for i, v in pairs(SettingsLib) do
                Array[i] = v
            end
            writefile(configPath, game:GetService("HttpService"):JSONEncode(Array))
        end
    else
        warn("Status: Undetected Executor")
    end
end

getgenv().LoadConfig()

local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1)
        removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
            removed[1]:Destroy()
        end)
    end
end

spawn(function()
    while wait(3) do
        if #NotificationList > 0 then
            RemoveOldestNotification()
        end
    end
end)

local Lunar = {}

function Lunar:Notify(desc)
    local OutlineFrame = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local Image = Instance.new("ImageLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")

    OutlineFrame.Name = "OutlineFrame"
    OutlineFrame.Parent = NotificationFrame
    OutlineFrame.ClipsDescendants = true
    OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 1)
    OutlineFrame.BackgroundTransparency = 0.4
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
    OutlineFrame.Size = UDim2.new(0, 412, 0, 72)

    Frame.Name = "Frame"
    Frame.Parent = OutlineFrame
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = _G.Dark
    Frame.BackgroundTransparency = 0.1
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 400, 0, 60)

    Image.Name = "Icon"
    Image.Parent = Frame
    Image.BackgroundTransparency = 1
    Image.Position = UDim2.new(0, 8, 0, 8)
    Image.Size = UDim2.new(0, 45, 0, 45)
    Image.Image = "rbxassetid://105059922903197"

    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 55, 0, 14)
    Title.Size = UDim2.new(0, 200, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "LUNAR HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Parent = Frame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 55, 0, 33)
    Desc.Size = UDim2.new(0, 300, 0, 15)
    Desc.Font = Enum.Font.GothamSemibold
    Desc.TextTransparency = 0.3
    Desc.Text = desc
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    CreateRounded(Frame, 10)
    CreateRounded(OutlineFrame, 12)

    OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.1, 0), "Out", "Quad", 0.4, true)
    table.insert(NotificationList, {OutlineFrame})
end

function Lunar:StartLoad()
    local Loader = Instance.new("ScreenGui")
    Loader.Parent = game.CoreGui
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Loader.DisplayOrder = 1000

    local LoaderFrame = Instance.new("Frame")
    LoaderFrame.Name = "LoaderFrame"
    LoaderFrame.Parent = Loader
    LoaderFrame.ClipsDescendants = true
    LoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0)
    LoaderFrame.BorderSizePixel = 0

    local MainLoaderFrame = Instance.new("Frame")
    MainLoaderFrame.Name = "MainLoaderFrame"
    MainLoaderFrame.Parent = LoaderFrame
    MainLoaderFrame.ClipsDescendants = true
    MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainLoaderFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    MainLoaderFrame.BorderSizePixel = 0

    local TitleLoader = Instance.new("TextLabel")
    TitleLoader.Parent = MainLoaderFrame
    TitleLoader.Text = "LUNAR HUB"
    TitleLoader.Font = Enum.Font.FredokaOne
    TitleLoader.TextSize = 50
    TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLoader.BackgroundTransparency = 1
    TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0)
    TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0)

    local DescriptionLoader = Instance.new("TextLabel")
    DescriptionLoader.Parent = MainLoaderFrame
    DescriptionLoader.Text = "Loading.."
    DescriptionLoader.Font = Enum.Font.Gotham
    DescriptionLoader.TextSize = 15
    DescriptionLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
    DescriptionLoader.BackgroundTransparency = 1
    DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    DescriptionLoader.Position = UDim2.new(0.5, 0, 0.6, 0)
    DescriptionLoader.Size = UDim2.new(0.8, 0, 0.2, 0)

    local LoadingBarBackground = Instance.new("Frame")
    LoadingBarBackground.Parent = MainLoaderFrame
    LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
    LoadingBarBackground.Size = UDim2.new(0.7, 0, 0.05, 0)
    LoadingBarBackground.ClipsDescendants = true
    LoadingBarBackground.BorderSizePixel = 0

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Parent = LoadingBarBackground
    LoadingBar.BackgroundColor3 = _G.Third
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)

    CreateRounded(LoadingBarBackground, 20)
    CreateRounded(LoadingBar, 20)

    local running = true
    local barTweenPart1 = TweenService:Create(LoadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0.25, 0, 1, 0)
    })
    local barTweenPart2 = TweenService:Create(LoadingBar, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 1, 0)
    })

    barTweenPart1:Play()

    function Lunar:Loaded()
        barTweenPart2:Play()
    end

    barTweenPart1.Completed:Connect(function()
        barTweenPart2.Completed:Connect(function()
            wait(1)
            running = false
            DescriptionLoader.Text = "Loaded!"
            wait(0.5)
            Loader:Destroy()
        end)
    end)

    spawn(function()
        local dotCount = 0
        while running do
            dotCount = (dotCount + 1) % 4
            local dots = string.rep(".", dotCount)
            DescriptionLoader.Text = "Please wait" .. dots
            wait(0.5)
        end
    end)
end

function Lunar:SaveSettings()
    return SettingsLib.SaveSettings
end

function Lunar:LoadAnimation()
    return SettingsLib.LoadAnimation
end

function ChangeTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        _G.Primary = CurrentTheme.Primary
        _G.Dark = CurrentTheme.Dark
        _G.Third = CurrentTheme.Accent

        SettingsLib.Theme = themeName
        getgenv().SaveConfig()

        Lunar:Notify("Theme changed to " .. themeName)

        if game.CoreGui:FindFirstChild("LUNAR") then
            local ui = game.CoreGui.LUNAR

        end
    end
end

if SettingsLib.Theme and Themes[SettingsLib.Theme] then
    ChangeTheme(SettingsLib.Theme)
end

function Lunar:Window(Config)
    assert(Config.SubTitle, "v2.0")

    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 600, 0, 400),
        TabWidth = Config.TabWidth or 150
    }

    local currentpage = ""
    local uihide = false
    local abc = false

    local LUNAR = Instance.new("ScreenGui")
    LUNAR.Name = "LUNAR"
    LUNAR.Parent = game.CoreGui
    LUNAR.DisplayOrder = 999

    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.Parent = LUNAR
    OutlineMain.ClipsDescendants = true
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OutlineMain.BackgroundTransparency = 0.4
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
    OutlineMain.Size = UDim2.new(0, 0, 0, 0)
    CreateRounded(OutlineMain, 15)

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = OutlineMain
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = WindowConfig.Size
    CreateRounded(Main, 12)

    OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true)

    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 40)

    local NameHub = Instance.new("TextLabel")
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 15, 0.5, 0)
    NameHub.AnchorPoint = Vector2.new(0, 0.5)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = "LUNAR HUB"
    NameHub.TextSize = 20
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    local nameHubSize = game:GetService("TextService"):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge))
    NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25)

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = NameHub
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, nameHubSize.X + 8, 0.5, 0)
    SubTitle.AnchorPoint = Vector2.new(0, 0.5)
    SubTitle.Font = Enum.Font.Cartoon
    SubTitle.Text = Config.SubTitle
    SubTitle.TextSize = 15
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)

    local SubTitleSize = game:GetService("TextService"):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge))
    SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25)

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top
    CloseButton.BackgroundTransparency = 1
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Image = "rbxassetid://7743878857"
    CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseButton, 3)

    CloseButton.MouseButton1Click:Connect(function()
        game.CoreGui:FindFirstChild("LUNAR").Enabled = not game.CoreGui:FindFirstChild("LUNAR").Enabled
    end)

    local BackgroundSettings = Instance.new("Frame")
    BackgroundSettings.Name = "BackgroundSettings"
    BackgroundSettings.Parent = OutlineMain
    BackgroundSettings.ClipsDescendants = true
    BackgroundSettings.Active = true
    BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    BackgroundSettings.BackgroundTransparency = 0.3
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSettings.Visible = false
    CreateRounded(BackgroundSettings, 15)

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = BackgroundSettings
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsFrame.Size = UDim2.new(0.7, 0, 0.7, 0)
    CreateRounded(SettingsFrame, 15)

    local CloseSettings = Instance.new("ImageButton")
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundTransparency = 1
    CloseSettings.AnchorPoint = Vector2.new(1, 0)
    CloseSettings.Position = UDim2.new(1, -20, 0, 15)
    CloseSettings.Size = UDim2.new(0, 20, 0, 20)
    CloseSettings.Image = "rbxassetid://10747384394"
    CloseSettings.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseSettings, 3)

    CloseSettings.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = false
    end)

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = Top
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
    SettingsButton.Position = UDim2.new(1, -45, 0.5, 0)
    SettingsButton.Size = UDim2.new(0, 20, 0, 20)
    SettingsButton.Image = "rbxassetid://10734950020"
    SettingsButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(SettingsButton, 3)

    SettingsButton.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = true
    end)

    local TitleSettings = Instance.new("TextLabel")
    TitleSettings.Name = "TitleSettings"
    TitleSettings.Parent = SettingsFrame
    TitleSettings.BackgroundTransparency = 1
    TitleSettings.Position = UDim2.new(0, 20, 0, 15)
    TitleSettings.Size = UDim2.new(1, 0, 0, 20)
    TitleSettings.Font = Enum.Font.GothamBold
    TitleSettings.Text = "Lunar Hub Settings"
    TitleSettings.TextSize = 20
    TitleSettings.TextColor3 = Color3.fromRGB(245, 245, 245)
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left

    local ScrollSettings = Instance.new("ScrollingFrame")
    ScrollSettings.Name = "ScrollSettings"
    ScrollSettings.Parent = SettingsFrame
    ScrollSettings.Active = true
    ScrollSettings.BackgroundTransparency = 1
    ScrollSettings.Position = UDim2.new(0, 20, 0, 50)
    ScrollSettings.Size = UDim2.new(1, -40, 1, -70)
    ScrollSettings.ScrollBarThickness = 3

    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.Parent = ScrollSettings
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 8)

    function CreateCheckbox(title, state, callback)
        local checked = state or false
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 25)

        local Checkbox = Instance.new("ImageButton")
        Checkbox.Name = "Checkbox"
        Checkbox.Parent = Background
        Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        Checkbox.AnchorPoint = Vector2.new(0, 0.5)
        Checkbox.Position = UDim2.new(0, 0, 0.5, 0)
        Checkbox.Size = UDim2.new(0, 20, 0, 20)
        Checkbox.Image = "rbxassetid://10709790644"
        Checkbox.ImageTransparency = checked and 0 or 1
        Checkbox.ImageColor3 = Color3.fromRGB(245, 245, 245)
        CreateRounded(Checkbox, 5)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Background
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 30, 0.5, 0)
        Title.Size = UDim2.new(1, -30, 0, 20)
        Title.Font = Enum.Font.Code
        Title.Text = title or ""
        Title.TextSize = 15
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.AnchorPoint = Vector2.new(0, 0.5)

        if checked then
            Checkbox.BackgroundColor3 = _G.Third
        end

        Checkbox.MouseButton1Click:Connect(function()
            checked = not checked
            if checked then
                Checkbox.ImageTransparency = 0
                Checkbox.BackgroundColor3 = _G.Third
            else
                Checkbox.ImageTransparency = 1
                Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
            pcall(callback, checked)
        end)

        pcall(callback, checked)
    end

    function CreateButton(title, callback)
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 35)

        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = Background
        Button.BackgroundColor3 = _G.Third
        Button.Size = UDim2.new(0.8, 0, 0, 30)
        Button.Font = Enum.Font.Code
        Button.Text = title or "Button"
        Button.AnchorPoint = Vector2.new(0.5, 0)
        Button.Position = UDim2.new(0.5, 0, 0, 0)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 15
        Button.AutoButtonColor = false
        CreateRounded(Button, 5)

        Button.MouseButton1Click:Connect(callback)
    end

    function CreateThemeDropdown(title, callback)
        local isdropping = false
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 40)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Background
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 0, 0, 5)
        Title.Size = UDim2.new(1, 0, 0, 20)
        Title.Font = Enum.Font.Code
        Title.Text = title
        Title.TextSize = 15
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local SelectItems = Instance.new("TextButton")
        SelectItems.Name = "SelectItems"
        SelectItems.Parent = Background
        SelectItems.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        SelectItems.Position = UDim2.new(1, -120, 0, 5)
        SelectItems.Size = UDim2.new(0, 115, 0, 30)
        SelectItems.AnchorPoint = Vector2.new(1, 0)
        SelectItems.Font = Enum.Font.GothamMedium
        SelectItems.AutoButtonColor = false
        SelectItems.TextSize = 12
        SelectItems.TextColor3 = Color3.fromRGB(255, 255, 255)
        SelectItems.Text = "  " .. (SettingsLib.Theme or "Default")
        SelectItems.TextXAlignment = Enum.TextXAlignment.Left
        CreateRounded(SelectItems, 5)

        local ArrowDown = Instance.new("ImageLabel")
        ArrowDown.Parent = SelectItems
        ArrowDown.BackgroundTransparency = 1
        ArrowDown.AnchorPoint = Vector2.new(1, 0.5)
        ArrowDown.Position = UDim2.new(1, -5, 0.5, 0)
        ArrowDown.Size = UDim2.new(0, 15, 0, 15)
        ArrowDown.Image = "rbxassetid://10709790948"
        ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255)

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = Background
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        DropdownFrame.Position = UDim2.new(1, -120, 0, 40)
        DropdownFrame.Size = UDim2.new(0, 115, 0, 0)
        DropdownFrame.AnchorPoint = Vector2.new(1, 0)
        DropdownFrame.Visible = false
        DropdownFrame.ClipsDescendants = true
        CreateRounded(DropdownFrame, 5)

        local DropScroll = Instance.new("ScrollingFrame")
        DropScroll.Parent = DropdownFrame
        DropScroll.BackgroundTransparency = 1
        DropScroll.Size = UDim2.new(1, 0, 1, 0)
        DropScroll.ScrollBarThickness = 2

        local DropLayout = Instance.new("UIListLayout")
        DropLayout.Parent = DropScroll
        DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
        DropLayout.Padding = UDim.new(0, 2)

        local DropPadding = Instance.new("UIPadding")
        DropPadding.Parent = DropScroll
        DropPadding.PaddingTop = UDim.new(0, 5)
        DropPadding.PaddingBottom = UDim.new(0, 5)
        DropPadding.PaddingLeft = UDim.new(0, 5)
        DropPadding.PaddingRight = UDim.new(0, 5)

        for themeName, _ in pairs(Themes) do
            local Item = Instance.new("TextButton")
            Item.Name = themeName
            Item.Parent = DropScroll
            Item.BackgroundTransparency = 1
            Item.Size = UDim2.new(1, 0, 0, 25)
            Item.Font = Enum.Font.Nunito
            Item.Text = themeName
            Item.TextColor3 = Color3.fromRGB(200, 200, 200)
            Item.TextSize = 12
            Item.TextXAlignment = Enum.TextXAlignment.Left
            CreateRounded(Item, 3)

            if themeName == (SettingsLib.Theme or "Default") then
                Item.BackgroundColor3 = _G.Third
                Item.BackgroundTransparency = 0.8
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            Item.MouseButton1Click:Connect(function()
                SelectItems.Text = "  " .. themeName
                callback(themeName)

                for _, child in pairs(DropScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Name == themeName then
                            child.BackgroundColor3 = _G.Third
                            child.BackgroundTransparency = 0.8
                            child.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            child.BackgroundTransparency = 1
                            child.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end
                end

                isdropping = false
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 115, 0, 0), Visible = false}):Play()
                TweenService:Create(Background, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end)
        end

        SelectItems.MouseButton1Click:Connect(function()
            if not isdropping then
                isdropping = true
                local itemCount = #DropScroll:GetChildren() - 2 
                local dropHeight = math.min(itemCount * 27 + 10, 120)

                TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 115, 0, dropHeight), Visible = true}):Play()
                TweenService:Create(Background, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40 + dropHeight)}):Play()
                TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                isdropping = false
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 115, 0, 0), Visible = false}):Play()
                TweenService:Create(Background, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end
        end)

        DropScroll.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
        DropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DropScroll.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
        end)
    end

    CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
        SettingsLib.SaveSettings = state
        getgenv().SaveConfig()
    end)

    CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state
        getgenv().SaveConfig()
    end)

    CreateThemeDropdown("Theme Selection", function(themeName)
        ChangeTheme(themeName)
    end)

    CreateButton("Reset Config", function()
        if isfolder("LUNAR") then
            delfolder("LUNAR")
        end
        Lunar:Notify("Config has been reset!")
    end)

    local Tab = Instance.new("Frame")
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.BackgroundTransparency = 1
    Tab.Position = UDim2.new(0, 8, 0, 40)
    Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, WindowConfig.Size.Y.Offset - 48)

    local ScrollTab = Instance.new("ScrollingFrame")
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = Tab
    ScrollTab.Active = true
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    ScrollTab.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = ScrollTab
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 2)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = ScrollTab

    local Page = Instance.new("Frame")
    Page.Name = "Page"
    Page.Parent = Main
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, WindowConfig.TabWidth + 18, 0, 40)
    Page.Size = UDim2.new(0, WindowConfig.Size.X.Offset - WindowConfig.TabWidth - 25, 0, WindowConfig.Size.Y.Offset - 48)

    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Parent = Page
    MainPage.ClipsDescendants = true
    MainPage.BackgroundTransparency = 1
    MainPage.Size = UDim2.new(1, 0, 1, 0)

    local PageList = Instance.new("Folder")
    PageList.Name = "PageList"
    PageList.Parent = MainPage

    local UIPageLayout = Instance.new("UIPageLayout")
    UIPageLayout.Parent = PageList
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
    UIPageLayout.TweenTime = 0.3
    UIPageLayout.GamepadInputEnabled = false
    UIPageLayout.ScrollWheelInputEnabled = false
    UIPageLayout.TouchInputEnabled = false

    MakeDraggable(Top, OutlineMain)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            game.CoreGui:FindFirstChild("LUNAR").Enabled = not game.CoreGui:FindFirstChild("LUNAR").Enabled
        end
    end)

    local uitab = {}

    function uitab:Tab(text, img)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = ScrollTab
        TabButton.Name = text .. "Unique"
        TabButton.Text = ""
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.AutoButtonColor = false
        CreateRounded(TabButton, 6)

        local SelectedTab = Instance.new("Frame")
        SelectedTab.Name = "SelectedTab"
        SelectedTab.Parent = TabButton
        SelectedTab.BackgroundColor3 = _G.Third
        SelectedTab.Size = UDim2.new(0, 3, 0, 0)
        SelectedTab.Position = UDim2.new(0, 0, 0.5, 0)
        SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
        CreateRounded(SelectedTab, 100)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = TabButton
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 30, 0.5, 0)
        Title.Size = UDim2.new(0, 100, 0, 30)
        Title.Font = Enum.Font.Roboto
        Title.Text = text
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextTransparency = 0.4
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Parent = TabButton
        Icon.BackgroundTransparency = 1
        Icon.ImageTransparency = 0.3
        Icon.Position = UDim2.new(0, 7, 0.5, 0)
        Icon.Size = UDim2.new(0, 15, 0, 15)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.Image = img or "rbxassetid://10723415903"
        Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)

        local MainFramePage = Instance.new("ScrollingFrame")
        MainFramePage.Name = text .. "_Page"
        MainFramePage.Parent = PageList
        MainFramePage.Active = true
        MainFramePage.BackgroundTransparency = 1
        MainFramePage.Size = UDim2.new(1, 0, 1, 0)
        MainFramePage.ScrollBarThickness = 3
        MainFramePage.ScrollBarImageColor3 = _G.Primary

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = MainFramePage
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.PaddingRight = UDim.new(0, 5)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = MainFramePage
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ScrollTab:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                    TweenService:Create(v.Icon, TweenInfo.new(0.3), {ImageTransparency = 0.4}):Play()
                    TweenService:Create(v.Title, TweenInfo.new(0.3), {TextTransparency = 0.4}):Play()
                end
            end

            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 15)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
            TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

            currentpage = text .. "_Page"
            for _, v in pairs(PageList:GetChildren()) do
                if v.Name == currentpage then
                    UIPageLayout:JumpTo(v)
                end
            end
        end)

        if not abc then
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 15)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
            TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            UIPageLayout:JumpToIndex(1)
            abc = true
        end

        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                MainFramePage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
                ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
                ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y)
            end)
        end)

        local main = {}

        function main:Button(text, callback)
            local Button = Instance.new("Frame")
            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Primary
            Button.BackgroundTransparency = 0.8
            Button.Size = UDim2.new(1, 0, 0, 36)
            CreateRounded(Button, 5)

            local TextButton = Instance.new("TextButton")
            TextButton.Parent = Button
            TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            TextButton.BackgroundTransparency = 0.8
            TextButton.AnchorPoint = Vector2.new(1, 0.5)
            TextButton.Position = UDim2.new(1, -5, 0.5, 0)
            TextButton.Size = UDim2.new(0, 30, 0, 26)
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            CreateRounded(TextButton, 4)

            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Parent = TextButton
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            ButtonIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            ButtonIcon.Size = UDim2.new(0, 15, 0, 15)
            ButtonIcon.Image = "rbxassetid://10734898355"
            ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Button
            TextLabel.BackgroundTransparency = 1
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.Position = UDim2.new(0, 15, 0.5, 0)
            TextLabel.Size = UDim2.new(1, -50, 1, 0)
            TextLabel.Font = Enum.Font.Cartoon
            TextLabel.Text = text
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 15

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Parent = Button
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Position = UDim2.new(0, 0, 0.5, 0)
            ArrowIcon.Size = UDim2.new(0, 15, 0, 15)
            ArrowIcon.AnchorPoint = Vector2.new(0, 0.5)
            ArrowIcon.Image = "rbxassetid://10709768347"
            ArrowIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

            TextButton.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function main:Toggle(text, config, desc, callback)
            config = config or false
            local toggled = config

            local Button = Instance.new("TextButton")
            Button.Name = "Toggle"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Primary
            Button.BackgroundTransparency = 0.8
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.Size = UDim2.new(1, 0, 0, desc and 46 or 36)
            CreateRounded(Button, 5)

            local Title = Instance.new("TextLabel")
            Title.Parent = Button
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0.5, desc and -8 or 0)
            Title.Size = UDim2.new(1, -100, 0, 20)
            Title.Font = Enum.Font.Cartoon
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.AnchorPoint = Vector2.new(0, 0.5)

            if desc then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = Title
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 22)
                Desc.Size = UDim2.new(0, 280, 0, 16)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = desc
                Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                Desc.TextSize = 10
                Desc.TextXAlignment = Enum.TextXAlignment.Left
            end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Button
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Position = UDim2.new(1, -45, 0.5, 0)
            ToggleFrame.Size = UDim2.new(0, 35, 0, 20)
            ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleButton.BackgroundTransparency = 0.8
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            CreateRounded(ToggleButton, 10)

            local Circle = Instance.new("Frame")
            Circle.Parent = ToggleButton
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(0, 3, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            CreateRounded(Circle, 10)

            local function UpdateToggle()
                if toggled then
                    Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Sine", 0.2, true)
                    TweenService:Create(ToggleButton, TweenInfo.new(0.4), {
                        BackgroundColor3 = _G.Third,
                        BackgroundTransparency = 0
                    }):Play()
                else
                    Circle:TweenPosition(UDim2.new(0, 4, 0.5, 0), "Out", "Sine", 0.2, true)
                    TweenService:Create(ToggleButton, TweenInfo.new(0.4), {
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                        BackgroundTransparency = 0.8
                    }):Play()
                end
                pcall(callback, toggled)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)

            if config then
                UpdateToggle()
            end
        end

        function main:Dropdown(text, options, default, callback)
            local isdropping = false
            local currentValue = default or "Select Item"

            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = MainFramePage
            Dropdown.BackgroundColor3 = _G.Primary
            Dropdown.BackgroundTransparency = 0.8
            Dropdown.ClipsDescendants = false
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Dropdown, 5)

            local DropTitle = Instance.new("TextLabel")
            DropTitle.Parent = Dropdown
            DropTitle.BackgroundTransparency = 1
            DropTitle.Position = UDim2.new(0, 15, 0, 5)
            DropTitle.Size = UDim2.new(1, -120, 0, 30)
            DropTitle.Font = Enum.Font.Cartoon
            DropTitle.Text = text
            DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropTitle.TextSize = 15
            DropTitle.TextXAlignment = Enum.TextXAlignment.Left

            local SelectButton = Instance.new("TextButton")
            SelectButton.Parent = Dropdown
            SelectButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SelectButton.Position = UDim2.new(1, -5, 0, 5)
            SelectButton.Size = UDim2.new(0, 100, 0, 30)
            SelectButton.AnchorPoint = Vector2.new(1, 0)
            SelectButton.Font = Enum.Font.GothamMedium
            SelectButton.AutoButtonColor = false
            SelectButton.TextSize = 11
            SelectButton.Text = "  " .. currentValue
            SelectButton.TextXAlignment = Enum.TextXAlignment.Left
            SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CreateRounded(SelectButton, 5)

            local ArrowDown = Instance.new("ImageLabel")
            ArrowDown.Parent = SelectButton
            ArrowDown.BackgroundTransparency = 1
            ArrowDown.AnchorPoint = Vector2.new(1, 0.5)
            ArrowDown.Position = UDim2.new(1, -5, 0.5, 0)
            ArrowDown.Size = UDim2.new(0, 15, 0, 15)
            ArrowDown.Image = "rbxassetid://10709790948"
            ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255)

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Dropdown
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownFrame.Position = UDim2.new(1, -5, 0, 40)
            DropdownFrame.Size = UDim2.new(0, 100, 0, 0)
            DropdownFrame.AnchorPoint = Vector2.new(1, 0)
            DropdownFrame.Visible = false
            DropdownFrame.ClipsDescendants = true
            CreateRounded(DropdownFrame, 5)

            local DropScroll = Instance.new("ScrollingFrame")
            DropScroll.Parent = DropdownFrame
            DropScroll.BackgroundTransparency = 1
            DropScroll.Size = UDim2.new(1, 0, 1, 0)
                        DropScroll.ScrollBarThickness = 2

            local DropLayout = Instance.new("UIListLayout")
            DropLayout.Parent = DropScroll
            DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropLayout.Padding = UDim.new(0, 2)

            local DropPadding = Instance.new("UIPadding")
            DropPadding.Parent = DropScroll
            DropPadding.PaddingTop = UDim.new(0, 5)
            DropPadding.PaddingBottom = UDim.new(0, 5)
            DropPadding.PaddingLeft = UDim.new(0, 5)
            DropPadding.PaddingRight = UDim.new(0, 5)

            for i, option in pairs(options) do
                local Item = Instance.new("TextButton")
                Item.Name = option
                Item.Parent = DropScroll
                Item.BackgroundTransparency = 1
                Item.Size = UDim2.new(1, 0, 0, 25)
                Item.Font = Enum.Font.Nunito
                Item.Text = option
                Item.TextColor3 = Color3.fromRGB(200, 200, 200)
                Item.TextSize = 12
                Item.TextXAlignment = Enum.TextXAlignment.Left
                CreateRounded(Item, 3)

                if option == currentValue then
                    Item.BackgroundColor3 = _G.Third
                    Item.BackgroundTransparency = 0.8
                    Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                end

                Item.MouseButton1Click:Connect(function()
                    currentValue = option
                    SelectButton.Text = "  " .. currentValue
                    callback(currentValue)

                    for _, child in pairs(DropScroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            if child.Name == option then
                                child.BackgroundColor3 = _G.Third
                                child.BackgroundTransparency = 0.8
                                child.TextColor3 = Color3.fromRGB(255, 255, 255)
                            else
                                child.BackgroundTransparency = 1
                                child.TextColor3 = Color3.fromRGB(200, 200, 200)
                            end
                        end
                    end

                    isdropping = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 100, 0, 0), Visible = false}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end)
            end

            SelectButton.MouseButton1Click:Connect(function()
                if not isdropping then
                    isdropping = true
                    local itemCount = #options
                    local dropHeight = math.min(itemCount * 27 + 10, 120)

                    DropdownFrame.Visible = true
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 100, 0, dropHeight)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40 + dropHeight)}):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    isdropping = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 100, 0, 0)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    wait(0.3)
                    DropdownFrame.Visible = false
                end
            end)

            DropScroll.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
            DropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropScroll.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
            end)
        end

        function main:Slider(text, config)
            local min = config.min or 0
            local max = config.max or 100
            local def = config.def or min
            local callback = config.callback or function() end

            local currentValue = def

            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
            Slider.Parent = MainFramePage
            Slider.BackgroundColor3 = _G.Primary
            Slider.BackgroundTransparency = 0.8
            Slider.Size = UDim2.new(1, 0, 0, 46)
            CreateRounded(Slider, 5)

            local Title = Instance.new("TextLabel")
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 5)
            Title.Size = UDim2.new(1, -120, 0, 20)
            Title.Font = Enum.Font.Cartoon
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Value = Instance.new("TextLabel")
            Value.Parent = Title
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(1, -5, 0, 0)
            Value.Size = UDim2.new(0, 100, 0, 20)
            Value.AnchorPoint = Vector2.new(1, 0)
            Value.Font = Enum.Font.GothamMedium
            Value.Text = tostring(currentValue)
            Value.TextColor3 = Color3.fromRGB(150, 150, 150)
            Value.TextSize = 14
            Value.TextXAlignment = Enum.TextXAlignment.Right

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Slider
            SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderFrame.Position = UDim2.new(0, 15, 0, 30)
            SliderFrame.Size = UDim2.new(1, -30, 0, 8)
            CreateRounded(SliderFrame, 4)

            local SliderButton = Instance.new("TextButton")
            SliderButton.Parent = SliderFrame
            SliderButton.BackgroundColor3 = _G.Third
            SliderButton.Size = UDim2.new(0, 0, 1, 0)
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            CreateRounded(SliderButton, 4)

            local Circle = Instance.new("Frame")
            Circle.Parent = SliderFrame
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(0, 0, 0.5, 0)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            CreateRounded(Circle, 8)

            local function UpdateSlider(value)
                local percent = (value - min) / (max - min)
                percent = math.clamp(percent, 0, 1)

                SliderButton.Size = UDim2.new(percent, 0, 1, 0)
                Circle.Position = UDim2.new(percent, 0, 0.5, 0)
                Value.Text = tostring(value)
                currentValue = value
                pcall(callback, value)
            end

            local dragging = false

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local percent = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    UpdateSlider(value)
                end
            end)

            SliderFrame.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    UpdateSlider(value)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UpdateSlider(def)
        end

        function main:Textbox(text, config, callback)
            local placeholder = config.placeholder or "Enter text..."
            local clearonfocus = config.clearonfocus or false

            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox"
            Textbox.Parent = MainFramePage
            Textbox.BackgroundColor3 = _G.Primary
            Textbox.BackgroundTransparency = 0.8
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Textbox, 5)

            local Title = Instance.new("TextLabel")
            Title.Parent = Textbox
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 5)
            Title.Size = UDim2.new(1, -120, 0, 30)
            Title.Font = Enum.Font.Cartoon
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local TextboxFrame = Instance.new("TextBox")
            TextboxFrame.Parent = Textbox
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TextboxFrame.Position = UDim2.new(1, -5, 0, 5)
            TextboxFrame.Size = UDim2.new(0, 100, 0, 30)
            TextboxFrame.AnchorPoint = Vector2.new(1, 0)
            TextboxFrame.Font = Enum.Font.GothamMedium
            TextboxFrame.PlaceholderText = placeholder
            TextboxFrame.Text = ""
            TextboxFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxFrame.TextSize = 11
            TextboxFrame.ClearTextOnFocus = clearonfocus
            CreateRounded(TextboxFrame, 5)

            TextboxFrame.FocusLost:Connect(function()
                callback(TextboxFrame.Text)
            end)
        end

        function main:Label(text, desc)
            local Label = Instance.new("Frame")
            Label.Name = "Label"
            Label.Parent = MainFramePage
            Label.BackgroundColor3 = _G.Primary
            Label.BackgroundTransparency = 0.8
            Label.Size = UDim2.new(1, 0, 0, desc and 46 or 36)
            CreateRounded(Label, 5)

            local Title = Instance.new("TextLabel")
            Title.Parent = Label
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0.5, desc and -8 or 0)
            Title.Size = UDim2.new(1, -30, 0, 20)
            Title.Font = Enum.Font.Cartoon
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.AnchorPoint = Vector2.new(0, 0.5)

            if desc then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = Title
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 22)
                Desc.Size = UDim2.new(0, 280, 0, 16)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = desc
                Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                Desc.TextSize = 10
                Desc.TextXAlignment = Enum.TextXAlignment.Left
            end
        end

        function main:Keybind(text, config, callback)
            local def = config.def or Enum.KeyCode.F
            local currentKey = def
            local binding = false

            local Keybind = Instance.new("Frame")
            Keybind.Name = "Keybind"
            Keybind.Parent = MainFramePage
            Keybind.BackgroundColor3 = _G.Primary
            Keybind.BackgroundTransparency = 0.8
            Keybind.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Keybind, 5)

            local Title = Instance.new("TextLabel")
            Title.Parent = Keybind
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 5)
            Title.Size = UDim2.new(1, -120, 0, 30)
            Title.Font = Enum.Font.Cartoon
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Parent = Keybind
            KeybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            KeybindButton.Position = UDim2.new(1, -5, 0, 5)
            KeybindButton.Size = UDim2.new(0, 100, 0, 30)
            KeybindButton.AnchorPoint = Vector2.new(1, 0)
            KeybindButton.Font = Enum.Font.GothamMedium
            KeybindButton.Text = currentKey.Name
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 11
            KeybindButton.AutoButtonColor = false
            CreateRounded(KeybindButton, 5)

            KeybindButton.MouseButton1Click:Connect(function()
                binding = true
                KeybindButton.Text = "Press a key..."
                KeybindButton.TextColor3 = _G.Third
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = currentKey.Name
                    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    binding = false
                    pcall(callback, currentKey)
                elseif not gameProcessed and input.KeyCode == currentKey then
                    pcall(callback, currentKey)
                end
            end)
        end

        return main
    end

    return uitab
end

return Lunar
