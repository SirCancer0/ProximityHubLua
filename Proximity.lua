local ProximityHub = {}

-- GameSense-style animation functions
local function Tween(obj, props, duration, easing)
    game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(duration, easing or Enum.EasingStyle.Quad),
        props
    ):Play()
end

-- GameSense-inspired loading screen
function ProximityHub:CreateLoadingScreen()
    local loadingUI = Instance.new("ScreenGui")
    loadingUI.Name = "ProximityHubLoader"
    loadingUI.IgnoreGuiInset = true
    loadingUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Dark overlay (GameSense-style backdrop)
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    overlay.BackgroundTransparency = 0.3
    overlay.BorderSizePixel = 0
    overlay.Parent = loadingUI

    -- Main loader container
    local loaderFrame = Instance.new("Frame")
    loaderFrame.Name = "LoaderFrame"
    loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    loaderFrame.Size = UDim2.new(0, 400, 0, 200)
    loaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    loaderFrame.BackgroundTransparency = 1
    loaderFrame.Parent = overlay

    -- GameSense-style header
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 10)
    header.BackgroundTransparency = 1
    header.Text = "PROXIMITY HUB"
    header.TextColor3 = Color3.fromRGB(170, 0, 255)
    header.Font = Enum.Font.GothamBlack
    header.TextSize = 28
    header.TextTransparency = 1
    header.Parent = loaderFrame

    -- Loading bar (GameSense-style thin line)
    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Name = "LoadingBarBG"
    loadingBarBg.Size = UDim2.new(0.8, 0, 0, 4)
    loadingBarBg.Position = UDim2.new(0.1, 0, 0.7, 0)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    loadingBarBg.BorderSizePixel = 0
    loadingBarBg.Parent = loaderFrame

    local loadingBar = Instance.new("Frame")
    loadingBar.Name = "LoadingBar"
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingBarBg

    -- Loading text (GameSense minimal)
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0.8, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "INITIALIZING GAMESENSE..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.GothamMedium
    loadingText.TextSize = 16
    loadingText.TextTransparency = 1
    loadingText.Parent = loaderFrame

    loadingUI.Parent = game:GetService("CoreGui")

    -- Animate like GameSense (smooth fade + progress)
    spawn(function()
        -- Fade in header and text
        Tween(header, {TextTransparency = 0}, 0.8, Enum.EasingStyle.Quint)
        Tween(loadingText, {TextTransparency = 0}, 0.8, Enum.EasingStyle.Quint)
        wait(0.5)

        -- Animate loading bar (0% -> 100%)
        for i = 1, 100 do
            loadingBar.Size = UDim2.new(i/100, 0, 1, 0)
            loadingText.Text = string.upper("LOADING " .. i .. "%")
            if i % 3 == 0 then
                Tween(loadingBar, {BackgroundTransparency = 0.2}, 0.2)
                Tween(loadingBar, {BackgroundTransparency = 0}, 0.2)
            end
            wait(0.03)
        end

        -- Finish animation
        loadingText.Text = "READY"
        Tween(loadingBar, {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}, 0.3)
        wait(0.5)

        -- Fade out
        Tween(loaderFrame, {Position = UDim2.new(0.5, 0, 0.4, 0)}, 0.5, Enum.EasingStyle.Back)
        Tween(loaderFrame, {BackgroundTransparency = 1}, 0.5)
        Tween(header, {TextTransparency = 1}, 0.5)
        Tween(loadingText, {TextTransparency = 1}, 0.5)
        Tween(loadingBarBg, {BackgroundTransparency = 1}, 0.5)
        wait(0.6)

        loadingUI:Destroy()
        self:CreateMainUI()
    end)
end

-- Original Main UI function
function ProximityHub:CreateMainUI()
    local mainUI = Instance.new("ScreenGui")
    mainUI.Name = "ProximityHub"
    mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 650, 0, 450)
    mainContainer.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = mainUI

    -- Main frame animation (slide up)
    mainContainer.Position = UDim2.new(0.5, -325, 1.5, -225)
    Tween(mainContainer, {Position = UDim2.new(0.5, -325, 0.5, -225)}, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 120, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainContainer
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = sidebar
    
    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = Color3.fromRGB(60, 60, 60)
    sidebarStroke.Thickness = 2
    sidebarStroke.Parent = sidebar

    -- Sidebar header
    local sidebarHeader = Instance.new("Frame")
    sidebarHeader.Name = "Header"
    sidebarHeader.Size = UDim2.new(1, 0, 0, 50)
    sidebarHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sidebarHeader.BackgroundTransparency = 0.3
    sidebarHeader.BorderSizePixel = 0
    sidebarHeader.Parent = sidebar
    
    local sidebarTitle = Instance.new("TextLabel")
    sidebarTitle.Name = "Title"
    sidebarTitle.Size = UDim2.new(1, -10, 1, 0)
    sidebarTitle.Position = UDim2.new(0, 10, 0, 0)
    sidebarTitle.BackgroundTransparency = 1
    sidebarTitle.Text = "PROXIMITY"
    sidebarTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
    sidebarTitle.Font = Enum.Font.GothamBlack
    sidebarTitle.TextSize = 18
    sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
    sidebarTitle.Parent = sidebarHeader
    
    local sidebarSubtitle = Instance.new("TextLabel")
    sidebarSubtitle.Name = "Subtitle"
    sidebarSubtitle.Size = UDim2.new(1, -10, 0, 20)
    sidebarSubtitle.Position = UDim2.new(0, 10, 0, 30)
    sidebarSubtitle.BackgroundTransparency = 1
    sidebarSubtitle.Text = "HUB"
    sidebarSubtitle.TextColor3 = Color3.fromRGB(0, 170, 255)
    sidebarSubtitle.Font = Enum.Font.GothamBlack
    sidebarSubtitle.TextSize = 24
    sidebarSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    sidebarSubtitle.Parent = sidebarHeader

    -- Tab buttons
    local tabs = {
        {Name = "Home", Icon = "🏠"},
        {Name = "Scripts", Icon = "📜"},
        {Name = "Player", Icon = "👤"},
        {Name = "Visuals", Icon = "👁"},
        {Name = "Settings", Icon = "⚙️"}
    }

    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, #tabs * 50)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 80)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Parent = sidebar

    local tabButtons = {}
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, (i-1)*50)
        tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(25, 25, 30)
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = tab.Icon .. "  " .. tab.Name
        tabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = tabButtonsFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        tabButtons[tab.Name] = tabButton
    end

    -- Main content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -130, 1, 0)
    contentFrame.Position = UDim2.new(0, 130, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    contentFrame.BackgroundTransparency = 0.2
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainContainer
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(60, 60, 60)
    contentStroke.Thickness = 2
    contentStroke.Parent = contentFrame

    -- Tab contents
    local tabContents = {}
    for _, tab in ipairs(tabs) do
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab.Name
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = tab.Name == "Home"
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 800)
        tabContent.Parent = contentFrame
        
        -- Add sample content to each tab
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -40, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = tab.Name .. " Tab"
        title.TextColor3 = Color3.fromRGB(0, 170, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = tabContent
        
        local sampleText = Instance.new("TextLabel")
        sampleText.Name = "SampleText"
        sampleText.Size = UDim2.new(1, -40, 0, 100)
        sampleText.Position = UDim2.new(0, 20, 0, 70)
        sampleText.BackgroundTransparency = 1
        sampleText.Text = "This is the " .. tab.Name .. " section of ProximityHub. Add your custom content here."
        sampleText.TextColor3 = Color3.fromRGB(200, 200, 200)
        sampleText.Font = Enum.Font.Gotham
        sampleText.TextSize = 14
        sampleText.TextWrapped = true
        sampleText.TextXAlignment = Enum.TextXAlignment.Left
        sampleText.Parent = tabContent
        
        tabContents[tab.Name] = tabContent
    end

    -- Tab switching logic with animations
    for tabName, tabButton in pairs(tabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            -- Animate button selection
            for _, btn in pairs(tabButtons) do
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.2)
            end
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            
            -- Animate tab switch
            for contentName, content in pairs(tabContents) do
                if contentName == tabName then
                    content.Visible = true
                    content.BackgroundTransparency = 1
                    Tween(content, {BackgroundTransparency = 0}, 0.3)
                else
                    content.Visible = false
                end
            end
        end)
    end

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeButton.BackgroundTransparency = 0.5
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.Parent = contentFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        Tween(mainContainer, {Position = UDim2.new(0.5, -325, 1.5, -225)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.5)
        mainUI:Destroy()
    end)

    mainUI.Parent = game:GetService("CoreGui")
end

-- Initialize ProximityHub (optional for direct use)
ProximityHub:CreateLoadingScreen()

return ProximityHub
