-- LUNAR HUB Library v2.0 - Recoded
-- Clean destruction of existing GUIs
if game:GetService("CoreGui"):FindFirstChild("LUNAR") then
    game:GetService("CoreGui").LUNAR:Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("NotificationFrame") then
    game:GetService("CoreGui").NotificationFrame:Destroy()
end

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Theme Configuration
local Theme = {
    Primary = Color3.fromRGB(100, 100, 100),
    Dark = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(255, 0, 0),
    Background = Color3.fromRGB(24, 24, 26),
    Secondary = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextDimmed = Color3.fromRGB(150, 150, 150)
}

-- Utility Functions
local function CreateRounded(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function MakeDraggable(handle, frame)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    local function Update(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
        local tween = TweenService:Create(frame, TweenInfo.new(0.15), {Position = position})
        tween:Play()
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

-- Notification System
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "NotificationFrame"
NotificationGui.Parent = CoreGui
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotificationList = {}

local function RemoveNotification(notification)
    for i, notif in ipairs(NotificationList) do
        if notif == notification then
            table.remove(NotificationList, i)
            break
        end
    end
    
    -- Update positions of remaining notifications
    for i, notif in ipairs(NotificationList) do
        local newPos = UDim2.new(1, -20, 0, 20 + (i - 1) * 85)
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = newPos}):Play()
    end
    
    notification:TweenPosition(UDim2.new(1, 50, notification.Position.Y.Scale, notification.Position.Y.Offset), "Out", "Quad", 0.3, true, function()
        notification:Destroy()
    end)
end

-- Main Library
local Library = {}

function Library:Notify(config)
    local title = config.Title or "LUNAR HUB"
    local content = config.Content or "Notification"
    local duration = config.Duration or 5

    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = NotificationGui
    notification.BackgroundColor3 = Theme.Background
    notification.Size = UDim2.new(0, 350, 0, 70)
    notification.Position = UDim2.new(1, 20, 0, 20 + #NotificationList * 85)
    notification.ClipsDescendants = true
    CreateRounded(notification, 8)

    -- Add border
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Parent = notification
    border.BackgroundColor3 = Theme.Accent
    border.Size = UDim2.new(0, 4, 1, 0)
    border.Position = UDim2.new(0, 0, 0, 0)
    CreateRounded(border, 2)

    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = notification
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 15, 0.5, 0)
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Image = "rbxassetid://10723407389"
    icon.ImageColor3 = Theme.Accent

    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 55, 0, 8)
    titleLabel.Size = UDim2.new(1, -70, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Content label
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Parent = notification
    contentLabel.BackgroundTransparency = 1
    contentLabel.Position = UDim2.new(0, 55, 0, 28)
    contentLabel.Size = UDim2.new(1, -70, 0, 35)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Text = content
    contentLabel.TextColor3 = Theme.TextSecondary
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.Parent = notification
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Theme.TextDimmed
    closeButton.TextSize = 16

    closeButton.MouseButton1Click:Connect(function()
        RemoveNotification(notification)
    end)

    -- Add to list and animate in
    table.insert(NotificationList, notification)
    notification:TweenPosition(UDim2.new(1, -370, 0, 20 + (#NotificationList - 1) * 85), "Out", "Quad", 0.4, true)

    -- Auto remove after duration
    spawn(function()
        wait(duration)
        if notification.Parent then
            RemoveNotification(notification)
        end
    end)
end

function Library:CreateWindow(config)
    local windowConfig = {
        Title = config.Title or "LUNAR HUB",
        SubTitle = config.SubTitle or "v2.0",
        Size = config.Size or UDim2.fromOffset(830, 525),
        MinSize = config.MinSize or Vector2.new(470, 380),
        Theme = config.Theme or "Dark",
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    }

    -- Create main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LUNAR"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main window frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.Size = windowConfig.Size
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.ClipsDescendants = true
    CreateRounded(mainFrame, 12)

    -- Window border
    local border = Instance.new("UIStroke")
    border.Parent = mainFrame
    border.Color = Theme.Primary
    border.Thickness = 1
    border.Transparency = 0.5

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0.5, 0)
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Font = Enum.Font.GothamBold
    title.Text = windowConfig.Title
    title.TextColor3 = Theme.Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Calculate title size and position subtitle
    local titleSize = TextService:GetTextSize(title.Text, title.TextSize, title.Font, Vector2.new(math.huge, math.huge))
    title.Size = UDim2.new(0, titleSize.X, 1, 0)

    local subTitle = Instance.new("TextLabel")
    subTitle.Name = "SubTitle"
    subTitle.Parent = titleBar
    subTitle.BackgroundTransparency = 1
    subTitle.Position = UDim2.new(0, 20 + titleSize.X, 0.5, 0)
    subTitle.AnchorPoint = Vector2.new(0, 0.5)
    subTitle.Font = Enum.Font.Gotham
    subTitle.Text = windowConfig.SubTitle
    subTitle.TextColor3 = Theme.TextDimmed
    subTitle.TextSize = 14
    subTitle.TextXAlignment = Enum.TextXAlignment.Left

    local subTitleSize = TextService:GetTextSize(subTitle.Text, subTitle.TextSize, subTitle.Font, Vector2.new(math.huge, math.huge))
    subTitle.Size = UDim2.new(0, subTitleSize.X, 1, 0)

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.BackgroundColor3 = Theme.Secondary
    closeButton.Position = UDim2.new(1, -35, 0.5, 0)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.AnchorPoint = Vector2.new(0, 0.5)
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 16
    closeButton.AutoButtonColor = false
    CreateRounded(closeButton, 4)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = titleBar
    minimizeButton.BackgroundColor3 = Theme.Secondary
    minimizeButton.Position = UDim2.new(1, -65, 0.5, 0)
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    minimizeButton.Text = "—"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextColor3 = Theme.Text
    minimizeButton.TextSize = 16
    minimizeButton.AutoButtonColor = false
    CreateRounded(minimizeButton, 4)

    local minimized = false
    local originalSize = windowConfig.Size

    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, originalSize.X.Offset, 0, 40)}):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        end
    end)

    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.Size = UDim2.new(1, 0, 1, -40)

    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = contentFrame
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 10, 0, 10)
    tabContainer.Size = UDim2.new(0, 150, 1, -20)

    -- Tab scroll frame
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Parent = tabContainer
    tabScroll.BackgroundTransparency = 1
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.ScrollBarThickness = 4
    tabScroll.ScrollBarImageColor3 = Theme.Primary

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabScroll
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)

    -- Page container
    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "PageContainer"
    pageContainer.Parent = contentFrame
    pageContainer.BackgroundTransparency = 1
    pageContainer.Position = UDim2.new(0, 170, 0, 10)
    pageContainer.Size = UDim2.new(1, -180, 1, -20)

    local pageLayout = Instance.new("UIPageLayout")
    pageLayout.Parent = pageContainer
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.EasingDirection = Enum.EasingDirection.InOut
    pageLayout.EasingStyle = Enum.EasingStyle.Quad
    pageLayout.TweenTime = 0.3

    -- Make draggable
    MakeDraggable(titleBar, mainFrame)

    -- Toggle visibility with minimize key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == windowConfig.MinimizeKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    -- Update canvas sizes
    RunService.Heartbeat:Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)

    -- Window object
    local Window = {}
    local tabs = {}

    function Window:CreateTab(config)
        local tabConfig = {
            Title = config.Title or "Tab",
            Icon = config.Icon or "rbxassetid://10734898355"
        }

        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabConfig.Title .. "Tab"
        tabButton.Parent = tabScroll
        tabButton.BackgroundColor3 = Theme.Secondary
        tabButton.BackgroundTransparency = 0.5
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        CreateRounded(tabButton, 6)

        -- Tab icon
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Parent = tabButton
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.Image = tabConfig.Icon
        tabIcon.ImageColor3 = Theme.TextSecondary

        -- Tab title
        local tabTitle = Instance.new("TextLabel")
        tabTitle.Name = "Title"
        tabTitle.Parent = tabButton
        tabTitle.BackgroundTransparency = 1
        tabTitle.Position = UDim2.new(0, 35, 0.5, 0)
        tabTitle.Size = UDim2.new(1, -45, 1, 0)
        tabTitle.AnchorPoint = Vector2.new(0, 0.5)
        tabTitle.Font = Enum.Font.Gotham
        tabTitle.Text = tabConfig.Title
        tabTitle.TextColor3 = Theme.TextSecondary
        tabTitle.TextSize = 13
        tabTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- Tab page
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Name = tabConfig.Title .. "Page"
        tabPage.Parent = pageContainer
        tabPage.BackgroundTransparency = 1
        tabPage.Size = UDim2.new(1, 0, 1, 0)
        tabPage.ScrollBarThickness = 4
        tabPage.ScrollBarImageColor3 = Theme.Primary
        tabPage.LayoutOrder = #tabs + 1

        local pageLayoutList = Instance.new("UIListLayout")
        pageLayoutList.Parent = tabPage
        pageLayoutList.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayoutList.Padding = UDim.new(0, 8)

        local pagePadding = Instance.new("UIPadding")
        pagePadding.Parent = tabPage
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 10)
        pagePadding.PaddingBottom = UDim.new(0, 10)

        -- Tab selection logic
        local function SelectTab()
            -- Deselect all tabs
            for _, tab in pairs(tabs) do
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
                TweenService:Create(tab.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSecondary}):Play()
                TweenService:Create(tab.Title, TweenInfo.new(0.2), {TextColor3 = Theme.TextSecondary}):Play()
            end

            -- Select current tab
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TweenService:Create(tabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Accent}):Play()
            TweenService:Create(tabTitle, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()

            -- Switch to page
            pageLayout:JumpTo(tabPage)
        end

        tabButton.MouseButton1Click:Connect(SelectTab)

        -- Store tab reference
        local tab = {
            Button = tabButton,
            Icon = tabIcon,
            Title = tabTitle,
            Page = tabPage,
            Select = SelectTab
        }
        table.insert(tabs, tab)

        -- Auto-select first tab
        if #tabs == 1 then
            SelectTab()
        end

        -- Update canvas size
        RunService.Heartbeat:Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayoutList.AbsoluteContentSize.Y + 20)
        end)

        -- Create tab object with methods
        local Tab = {}

        function Tab:CreateButton(config)
            local buttonConfig = {
                Title = config.Title or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }

            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "Button"
            buttonFrame.Parent = tabPage
            buttonFrame.BackgroundColor3 = Theme.Primary
            buttonFrame.BackgroundTransparency = 0.8
            buttonFrame.Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 50 or 35)
            CreateRounded(buttonFrame, 6)

            local button = Instance.new("TextButton")
            button.Parent = buttonFrame
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Text = ""
            button.AutoButtonColor = false

            local title = Instance.new("TextLabel")
            title.Parent = button
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0.5, buttonConfig.Description ~= "" and -8 or 0)
            title.Size = UDim2.new(1, -30, 0, 20)
            title.AnchorPoint = Vector2.new(0, 0.5)
            title.Font = Enum.Font.GothamSemibold
            title.Text = buttonConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if buttonConfig.Description ~= "" then
                local description = Instance.new("TextLabel")
                description.Parent = button
                description.BackgroundTransparency = 1
                description.Position = UDim2.new(0, 15, 0.5, 12)
                description.Size = UDim2.new(1, -30, 0, 16)
                description.AnchorPoint = Vector2.new(0, 0.5)
                description.Font = Enum.Font.Gotham
                description.Text = buttonConfig.Description
                description.TextColor3 = Theme.TextDimmed
                description.TextSize = 11
                description.TextXAlignment = Enum.TextXAlignment.Left
            end

            button.MouseButton1Click:Connect(function()
                TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
                wait(0.1)
                TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
                buttonConfig.Callback()
            end)

            return button
        end

        function Tab:CreateToggle(id, config)
            local toggleConfig = {
                Title = config.Title or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "Toggle"
            toggleFrame.Parent = tabPage
            toggleFrame.BackgroundColor3 = Theme.Primary
            toggleFrame.BackgroundTransparency = 0.8
            toggleFrame.Size = UDim2.new(1, 0, 0, toggleConfig.Description ~= "" and 50 or 35)
            CreateRounded(toggleFrame, 6)

            local title = Instance.new("TextLabel")
            title.Parent = toggleFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0.5, toggleConfig.Description ~= "" and -8 or 0)
            title.Size = UDim2.new(1, -60, 0, 20)
            title.AnchorPoint = Vector2.new(0, 0.5)
            title.Font = Enum.Font.GothamSemibold
            title.Text = toggleConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if toggleConfig.Description ~= "" then
                local description = Instance.new("TextLabel")
                description.Parent = toggleFrame
                description.BackgroundTransparency = 1
                description.Position = UDim2.new(0, 15, 0.5, 12)
                description.Size = UDim2.new(1, -60, 0, 16)
                description.AnchorPoint = Vector2.new(0, 0.5)
                description.Font = Enum.Font.Gotham
                description.Text = toggleConfig.Description
                description.TextColor3 = Theme.TextDimmed
                description.TextSize = 11
                description.TextXAlignment = Enum.TextXAlignment.Left
            end

            -- Toggle switch
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.BackgroundColor3 = toggleConfig.Default and Theme.Accent or Theme.Secondary
            toggleButton.Position = UDim2.new(1, -40, 0.5, 0)
            toggleButton.Size = UDim2.new(0, 35, 0, 18)
            toggleButton.AnchorPoint = Vector2.new(0, 0.5)
            toggleButton.Text = ""
            toggleButton.AutoButtonColor = false
            CreateRounded(toggleButton, 9)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleButton
            toggleCircle.BackgroundColor3 = Theme.Text
            toggleCircle.Position = UDim2.new(0, toggleConfig.Default and 19 or 2, 0.5, 0)
            toggleCircle.Size = UDim2.new(0, 14, 0, 14)
            toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
            CreateRounded(toggleCircle, 7)

            local enabled = toggleConfig.Default

            local function UpdateToggle()
                enabled = not enabled
                
                if enabled then
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 19, 0.5, 0)}):Play()
                else
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
                end

                toggleConfig.Callback(enabled)
            end

            toggleButton.MouseButton1Click:Connect(UpdateToggle)

            local Toggle = {}
            function Toggle:SetValue(value)
                if value ~= enabled then
                    UpdateToggle()
                end
            end

            return Toggle
        end

        function Tab:CreateSlider(id, config)
            local sliderConfig = {
                Title = config.Title or "Slider",
                Description = config.Description or "",
                Default = config.Default or 0,
                Min = config.Min or 0,
                Max = config.Max or 100,
                Rounding = config.Rounding or 1,
                Callback = config.Callback or function() end
            }

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "Slider"
            sliderFrame.Parent = tabPage
            sliderFrame.BackgroundColor3 = Theme.Primary
            sliderFrame.BackgroundTransparency = 0.8
            sliderFrame.Size = UDim2.new(1, 0, 0, sliderConfig.Description ~= "" and 60 or 45)
            CreateRounded(sliderFrame, 6)

            local title = Instance.new("TextLabel")
            title.Parent = sliderFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0, 8)
            title.Size = UDim2.new(1, -80, 0, 20)
            title.Font = Enum.Font.GothamSemibold
            title.Text = sliderConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -70, 0, 8)
            valueLabel.Size = UDim2.new(0, 60, 0, 20)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.Text = tostring(sliderConfig.Default)
            valueLabel.TextColor3 = Theme.TextDimmed
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            if sliderConfig.Description ~= "" then
                local description = Instance.new("TextLabel")
                description.Parent = sliderFrame
                description.BackgroundTransparency = 1
                description.Position = UDim2.new(0, 15, 0, 28)
                description.Size = UDim2.new(1, -80, 0, 16)
                description.Font = Enum.Font.Gotham
                description.Text = sliderConfig.Description
                description.TextColor3 = Theme.TextDimmed
                description.TextSize = 11
                description.TextXAlignment = Enum.TextXAlignment.Left
            end

            -- Slider track
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Parent = sliderFrame
            sliderTrack.BackgroundColor3 = Theme.Secondary
            sliderTrack.Position = UDim2.new(0, 15, 1, sliderConfig.Description ~= "" and -18 or -15)
            sliderTrack.Size = UDim2.new(1, -30, 0, 6)
            sliderTrack.AnchorPoint = Vector2.new(0, 1)
            CreateRounded(sliderTrack, 3)

            -- Slider fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderTrack
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            CreateRounded(sliderFill, 3)

            -- Slider handle
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Parent = sliderTrack
            sliderHandle.BackgroundColor3 = Theme.Text
            sliderHandle.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 0.5, 0)
            sliderHandle.Size = UDim2.new(0, 12, 0, 12)
            sliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            CreateRounded(sliderHandle, 6)

            local currentValue = sliderConfig.Default
            local dragging = false

            local function UpdateSlider(value)
                value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                if sliderConfig.Rounding then
                    value = math.floor(value / sliderConfig.Rounding + 0.5) * sliderConfig.Rounding
                end
                
                currentValue = value
                local percentage = (value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                TweenService:Create(sliderHandle, TweenInfo.new(0.1), {Position = UDim2.new(percentage, 0, 0.5, 0)}):Play()
                
                valueLabel.Text = tostring(value)
                sliderConfig.Callback(value)
            end

            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percentage
                    UpdateSlider(value)
                end
            end)

            sliderTrack.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percentage
                    UpdateSlider(value)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            local Slider = {}
            function Slider:SetValue(value)
                UpdateSlider(value)
            end

            function Slider:OnChanged(callback)
                sliderConfig.Callback = callback
            end

            return Slider
        end

        function Tab:CreateDropdown(id, config)
            local dropdownConfig = {
                Title = config.Title or "Dropdown",
                Description = config.Description or "",
                Values = config.Values or {"Option 1", "Option 2"},
                Multi = config.Multi or false,
                Default = config.Default or (config.Multi and {} or 1),
                Callback = config.Callback or function() end
            }

            local dropdownHeight = dropdownConfig.Description ~= "" and 50 or 35
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "Dropdown"
            dropdownFrame.Parent = tabPage
            dropdownFrame.BackgroundColor3 = Theme.Primary
            dropdownFrame.BackgroundTransparency = 0.8
            dropdownFrame.Size = UDim2.new(1, 0, 0, dropdownHeight)
            dropdownFrame.ClipsDescendants = false
            CreateRounded(dropdownFrame, 6)

            local title = Instance.new("TextLabel")
            title.Parent = dropdownFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0.5, dropdownConfig.Description ~= "" and -8 or 0)
            title.Size = UDim2.new(1, -120, 0, 20)
            title.AnchorPoint = Vector2.new(0, 0.5)
            title.Font = Enum.Font.GothamSemibold
            title.Text = dropdownConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if dropdownConfig.Description ~= "" then
                local description = Instance.new("TextLabel")
                description.Parent = dropdownFrame
                description.BackgroundTransparency = 1
                description.Position = UDim2.new(0, 15, 0.5, 12)
                description.Size = UDim2.new(1, -120, 0, 16)
                description.AnchorPoint = Vector2.new(0, 0.5)
                description.Font = Enum.Font.Gotham
                description.Text = dropdownConfig.Description
                description.TextColor3 = Theme.TextDimmed
                description.TextSize = 11
                description.TextXAlignment = Enum.TextXAlignment.Left
            end

            -- Dropdown button
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Parent = dropdownFrame
            dropdownButton.BackgroundColor3 = Theme.Secondary
            dropdownButton.Position = UDim2.new(1, -100, 0.5, 0)
            dropdownButton.Size = UDim2.new(0, 90, 0, 25)
            dropdownButton.AnchorPoint = Vector2.new(0, 0.5)
            dropdownButton.Text = ""
            dropdownButton.AutoButtonColor = false
            CreateRounded(dropdownButton, 4)

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Parent = dropdownButton
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Position = UDim2.new(0, 8, 0.5, 0)
            dropdownLabel.Size = UDim2.new(1, -25, 1, 0)
            dropdownLabel.AnchorPoint = Vector2.new(0, 0.5)
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.Text = dropdownConfig.Multi and "Multiple" or (dropdownConfig.Values[dropdownConfig.Default] or "Select...")
            dropdownLabel.TextColor3 = Theme.Text
            dropdownLabel.TextSize = 11
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local dropdownArrow = Instance.new("ImageLabel")
            dropdownArrow.Parent = dropdownButton
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Position = UDim2.new(1, -18, 0.5, 0)
            dropdownArrow.Size = UDim2.new(0, 12, 0, 12)
            dropdownArrow.AnchorPoint = Vector2.new(0, 0.5)
            dropdownArrow.Image = "rbxassetid://10709790948"
            dropdownArrow.ImageColor3 = Theme.TextSecondary

            -- Dropdown list
            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "DropdownList"
            dropdownList.Parent = dropdownFrame
            dropdownList.BackgroundColor3 = Theme.Background
            dropdownList.Position = UDim2.new(1, -100, 1, 5)
            dropdownList.Size = UDim2.new(0, 90, 0, 0)
            dropdownList.AnchorPoint = Vector2.new(0, 0)
            dropdownList.Visible = false
            dropdownList.ClipsDescendants = true
            dropdownList.ZIndex = 10
            CreateRounded(dropdownList, 4)

            local dropdownBorder = Instance.new("UIStroke")
            dropdownBorder.Parent = dropdownList
            dropdownBorder.Color = Theme.Primary
            dropdownBorder.Thickness = 1
            dropdownBorder.Transparency = 0.5

            local dropdownScroll = Instance.new("ScrollingFrame")
            dropdownScroll.Parent = dropdownList
            dropdownScroll.BackgroundTransparency = 1
            dropdownScroll.Size = UDim2.new(1, 0, 1, 0)
            dropdownScroll.ScrollBarThickness = 3
            dropdownScroll.ScrollBarImageColor3 = Theme.Primary

            local dropdownLayout = Instance.new("UIListLayout")
            dropdownLayout.Parent = dropdownScroll
            dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownLayout.Padding = UDim.new(0, 2)

            local dropdownPadding = Instance.new("UIPadding")
            dropdownPadding.Parent = dropdownScroll
            dropdownPadding.PaddingTop = UDim.new(0, 5)
            dropdownPadding.PaddingBottom = UDim.new(0, 5)
            dropdownPadding.PaddingLeft = UDim.new(0, 5)
            dropdownPadding.PaddingRight = UDim.new(0, 5)

            local isOpen = false
            local selectedValues = dropdownConfig.Multi and (type(dropdownConfig.Default) == "table" and dropdownConfig.Default or {}) or {}

            -- Create dropdown items
            for i, value in ipairs(dropdownConfig.Values) do
                local item = Instance.new("TextButton")
                item.Name = tostring(value)
                item.Parent = dropdownScroll
                item.BackgroundColor3 = Theme.Secondary
                item.BackgroundTransparency = 1
                item.Size = UDim2.new(1, 0, 0, 22)
                item.Text = ""
                item.AutoButtonColor = false
                CreateRounded(item, 3)

                local itemLabel = Instance.new("TextLabel")
                itemLabel.Parent = item
                itemLabel.BackgroundTransparency = 1
                itemLabel.Position = UDim2.new(0, 5, 0.5, 0)
                itemLabel.Size = UDim2.new(1, -10, 1, 0)
                itemLabel.AnchorPoint = Vector2.new(0, 0.5)
                itemLabel.Font = Enum.Font.Gotham
                itemLabel.Text = tostring(value)
                itemLabel.TextColor3 = Theme.TextSecondary
                itemLabel.TextSize = 10
                itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                itemLabel.TextTruncate = Enum.TextTruncate.AtEnd

                -- Selection indicator for multi-select
                if dropdownConfig.Multi then
                    local checkmark = Instance.new("TextLabel")
                    checkmark.Parent = item
                    checkmark.BackgroundTransparency = 1
                    checkmark.Position = UDim2.new(1, -15, 0.5, 0)
                    checkmark.Size = UDim2.new(0, 10, 0, 10)
                    checkmark.AnchorPoint = Vector2.new(0, 0.5)
                    checkmark.Font = Enum.Font.GothamBold
                    checkmark.Text = "✓"
                    checkmark.TextColor3 = Theme.Accent
                    checkmark.TextSize = 8
                    checkmark.Visible = selectedValues[value] == true

                    item.MouseButton1Click:Connect(function()
                        selectedValues[value] = not selectedValues[value]
                        checkmark.Visible = selectedValues[value] == true
                        
                        if selectedValues[value] then
                            TweenService:Create(item, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
                            TweenService:Create(itemLabel, TweenInfo.new(0.1), {TextColor3 = Theme.Text}):Play()
                        else
                            TweenService:Create(item, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(itemLabel, TweenInfo.new(0.1), {TextColor3 = Theme.TextSecondary}):Play()
                        end
                        
                        dropdownConfig.Callback(selectedValues)
                    end)
                else
                    item.MouseButton1Click:Connect(function()
                        dropdownLabel.Text = tostring(value)
                        dropdownConfig.Callback(value)
                        
                        -- Close dropdown
                        isOpen = false
                        TweenService:Create(dropdownList, TweenInfo.new(0.2), {Size = UDim2.new(0, 90, 0, 0)}):Play()
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        wait(0.2)
                        dropdownList.Visible = false
                    end)
                end

                -- Hover effects
                item.MouseEnter:Connect(function()
                    if not (dropdownConfig.Multi and selectedValues[value]) then
                        TweenService:Create(item, TweenInfo.new(0.1), {BackgroundTransparency = 0.9}):Play()
                    end
                end)

                item.MouseLeave:Connect(function()
                    if not (dropdownConfig.Multi and selectedValues[value]) then
                        TweenService:Create(item, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                    end
                end)
            end

            -- Toggle dropdown
            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local itemCount = #dropdownConfig.Values
                    local maxHeight = math.min(itemCount * 24 + 10, 120)
                    
                    dropdownList.Visible = true
                    TweenService:Create(dropdownList, TweenInfo.new(0.2), {Size = UDim2.new(0, 90, 0, maxHeight)}):Play()
                    TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(dropdownList, TweenInfo.new(0.2), {Size = UDim2.new(0, 90, 0, 0)}):Play()
                    TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    wait(0.2)
                    dropdownList.Visible = false
                end
            end)

            -- Update canvas size
            RunService.Heartbeat:Connect(function()
                dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y + 10)
            end)

            local Dropdown = {}
            function Dropdown:SetValue(value)
                if dropdownConfig.Multi then
                    selectedValues = value
                    -- Update checkmarks
                    for _, item in pairs(dropdownScroll:GetChildren()) do
                        if item:IsA("TextButton") then
                            local checkmark = item:FindFirstChild("TextLabel")
                            if checkmark and checkmark.Text == "✓" then
                                checkmark.Visible = selectedValues[item.Name] == true
                            end
                        end
                    end
                else
                    dropdownLabel.Text = tostring(value)
                end
                dropdownConfig.Callback(value)
            end

            function Dropdown:SetValues(values)
                dropdownConfig.Values = values
                -- Rebuild dropdown items (simplified for this example)
            end

            function Dropdown:OnChanged(callback)
                dropdownConfig.Callback = callback
            end

            return Dropdown
        end

        function Tab:CreateInput(id, config)
            local inputConfig = {
                Title = config.Title or "Input",
                Default = config.Default or "",
                Placeholder = config.Placeholder or "Enter text...",
                Numeric = config.Numeric or false,
                Finished = config.Finished or false,
                Callback = config.Callback or function() end
            }

            local inputFrame = Instance.new("Frame")
            inputFrame.Name = "Input"
            inputFrame.Parent = tabPage
            inputFrame.BackgroundColor3 = Theme.Primary
            inputFrame.BackgroundTransparency = 0.8
            inputFrame.Size = UDim2.new(1, 0, 0, 35)
            CreateRounded(inputFrame, 6)

            local title = Instance.new("TextLabel")
            title.Parent = inputFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0.5, 0)
            title.Size = UDim2.new(1, -120, 1, 0)
            title.AnchorPoint = Vector2.new(0, 0.5)
            title.Font = Enum.Font.GothamSemibold
            title.Text = inputConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            local inputBox = Instance.new("TextBox")
            inputBox.Parent = inputFrame
            inputBox.BackgroundColor3 = Theme.Secondary
            inputBox.Position = UDim2.new(1, -100, 0.5, 0)
            inputBox.Size = UDim2.new(0, 90, 0, 25)
            inputBox.AnchorPoint = Vector2.new(0, 0.5)
            inputBox.Font = Enum.Font.Gotham
            inputBox.PlaceholderText = inputConfig.Placeholder
            inputBox.Text = inputConfig.Default
            inputBox.TextColor3 = Theme.Text
            inputBox.TextSize = 11
            inputBox.ClearTextOnFocus = false
            CreateRounded(inputBox, 4)

            local inputBorder = Instance.new("UIStroke")
            inputBorder.Parent = inputBox
            inputBorder.Color = Theme.Primary
            inputBorder.Thickness = 1
            inputBorder.Transparency = 0.7

            -- Focus effects
            inputBox.Focused:Connect(function()
                TweenService:Create(inputBorder, TweenInfo.new(0.2), {Color = Theme.Accent, Transparency = 0}):Play()
            end)

            inputBox.FocusLost:Connect(function()
                TweenService:Create(inputBorder, TweenInfo.new(0.2), {Color = Theme.Primary, Transparency = 0.7}):Play()
                if inputConfig.Finished then
                    inputConfig.Callback(inputBox.Text)
                end
            end)

            if not inputConfig.Finished then
                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if inputConfig.Numeric then
                        local num = tonumber(inputBox.Text)
                        if num then
                            inputConfig.Callback(num)
                        end
                    else
                        inputConfig.Callback(inputBox.Text)
                    end
                end)
            end

            local Input = {}
            Input.Value = inputBox.Text

            function Input:OnChanged(callback)
                inputConfig.Callback = callback
            end

            inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                Input.Value = inputBox.Text
            end)

            return Input
        end

        function Tab:CreateParagraph(id, config)
            local paragraphConfig = {
                Title = config.Title or "Paragraph",
                Content = config.Content or "This is a paragraph.",
                TitleAlignment = config.TitleAlignment or "Left",
                ContentAlignment = config.ContentAlignment or Enum.TextXAlignment.Left
            }

            local contentHeight = 20
            local lines = {}
            for line in paragraphConfig.Content:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end
            contentHeight = math.max(20, #lines * 16)

            local paragraphFrame = Instance.new("Frame")
            paragraphFrame.Name = "Paragraph"
            paragraphFrame.Parent = tabPage
            paragraphFrame.BackgroundColor3 = Theme.Primary
            paragraphFrame.BackgroundTransparency = 0.8
            paragraphFrame.Size = UDim2.new(1, 0, 0, 35 + contentHeight)
            CreateRounded(paragraphFrame, 6)

            local title = Instance.new("TextLabel")
            title.Parent = paragraphFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 15, 0, 8)
            title.Size = UDim2.new(1, -30, 0, 20)
            title.Font = Enum.Font.GothamBold
            title.Text = paragraphConfig.Title
            title.TextColor3 = Theme.Text
            title.TextSize = 14
            title.TextXAlignment = paragraphConfig.TitleAlignment == "Middle" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left

            local content = Instance.new("TextLabel")
            content.Parent = paragraphFrame
            content.BackgroundTransparency = 1
            content.Position = UDim2.new(0, 15, 0, 30)
            content.Size = UDim2.new(1, -30, 0, contentHeight)
            content.Font = Enum.Font.Gotham
            content.Text = paragraphConfig.Content
            content.TextColor3 = Theme.TextSecondary
            content.TextSize = 12
            content.TextXAlignment = paragraphConfig.ContentAlignment
            content.TextWrapped = true
            content.TextYAlignment = Enum.TextYAlignment.Top

            local Paragraph = {}
            Paragraph.Value = paragraphConfig.Content

            function Paragraph:SetValue(newContent)
                content.Text = newContent
                Paragraph.Value = newContent
                
                -- Recalculate height
                local newLines = {}
                for line in newContent:gmatch("[^\r\n]+") do
                    table.insert(newLines, line)
                end
                local newHeight = math.max(20, #newLines * 16)
                
                paragraphFrame.Size = UDim2.new(1, 0, 0, 35 + newHeight)
                content.Size = UDim2.new(1, -30, 0, newHeight)
            end

            return Paragraph
        end

        return Tab
    end

    function Window:Dialog(config)
        local dialogConfig = {
            Title = config.Title or "Dialog",
            Content = config.Content or "This is a dialog.",
            Buttons = config.Buttons or {
                {
                    Title = "OK",
                    Callback = function() end
                }
            }
        }

        -- Dialog background
        local dialogBg = Instance.new("Frame")
        dialogBg.Name = "DialogBackground"
        dialogBg.Parent = screenGui
        dialogBg.BackgroundColor3 = Color3.new(0, 0, 0)
        dialogBg.BackgroundTransparency = 0.5
        dialogBg.Size = UDim2.new(1, 0, 1, 0)
        dialogBg.ZIndex = 100

        -- Dialog frame
        local dialogFrame = Instance.new("Frame")
        dialogFrame.Name = "Dialog"
        dialogFrame.Parent = dialogBg
        dialogFrame.BackgroundColor3 = Theme.Background
        dialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        dialogFrame.Size = UDim2.new(0, 400, 0, 200)
        dialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        CreateRounded(dialogFrame, 8)

        local dialogBorder = Instance.new("UIStroke")
        dialogBorder.Parent = dialogFrame
        dialogBorder.Color = Theme.Primary
        dialogBorder.Thickness = 1
        dialogBorder.Transparency = 0.5

        -- Dialog title
        local dialogTitle = Instance.new("TextLabel")
        dialogTitle.Parent = dialogFrame
        dialogTitle.BackgroundTransparency = 1
        dialogTitle.Position = UDim2.new(0, 20, 0, 15)
        dialogTitle.Size = UDim2.new(1, -40, 0, 25)
        dialogTitle.Font = Enum.Font.GothamBold
        dialogTitle.Text = dialogConfig.Title
        dialogTitle.TextColor3 = Theme.Text
        dialogTitle.TextSize = 16
        dialogTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- Dialog content
        local dialogContent = Instance.new("TextLabel")
        dialogContent.Parent = dialogFrame
        dialogContent.BackgroundTransparency = 1
        dialogContent.Position = UDim2.new(0, 20, 0, 50)
        dialogContent.Size = UDim2.new(1, -40, 1, -120)
        dialogContent.Font = Enum.Font.Gotham
        dialogContent.Text = dialogConfig.Content
        dialogContent.TextColor3 = Theme.TextSecondary
        dialogContent.TextSize = 13
        dialogContent.TextXAlignment = Enum.TextXAlignment.Left
        dialogContent.TextYAlignment = Enum.TextYAlignment.Top
        dialogContent.TextWrapped = true

        -- Dialog buttons
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Parent = dialogFrame
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Position = UDim2.new(0, 20, 1, -50)
        buttonContainer.Size = UDim2.new(1, -40, 0, 30)

        local buttonLayout = Instance.new("UIListLayout")
        buttonLayout.Parent = buttonContainer
        buttonLayout.FillDirection = Enum.FillDirection.Horizontal
        buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
        buttonLayout.Padding = UDim.new(0, 10)

        for i, buttonConfig in ipairs(dialogConfig.Buttons) do
            local button = Instance.new("TextButton")
            button.Name = buttonConfig.Title
            button.Parent = buttonContainer
            button.BackgroundColor3 = i == 1 and Theme.Accent or Theme.Secondary
            button.Size = UDim2.new(0, 80, 1, 0)
            button.Font = Enum.Font.GothamSemibold
            button.Text = buttonConfig.Title
            button.TextColor3 = Theme.Text
            button.TextSize = 12
            button.AutoButtonColor = false
            button.LayoutOrder = i
            CreateRounded(button, 4)

            button.MouseButton1Click:Connect(function()
                buttonConfig.Callback()
                dialogBg:Destroy()
            end)

            -- Button hover effect
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = i == 1 and Color3.fromRGB(math.min(255, Theme.Accent.R * 255 + 20), math.min(255, Theme.Accent.G * 255 + 20), math.min(255, Theme.Accent.B * 255 + 20)) or Color3.fromRGB(60, 60, 60)
                }):Play()
            end)

            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = i == 1 and Theme.Accent or Theme.Secondary
                }):Play()
            end)
        end

        -- Animate dialog in
        dialogFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(dialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 400, 0, 200)}):Play()
    end

    return Window
end

return Library
