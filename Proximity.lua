-- Proximity Hub Library
-- Version 1.0
-- By [Your Name]

local ProximityHub = {}
ProximityHub.__index = ProximityHub

-- Colors
local accentColor = Color3.fromRGB(170, 85, 255)
local darkColor = Color3.fromRGB(30, 20, 40)
local lightColor = Color3.fromRGB(50, 35, 70)
local textColor = Color3.fromRGB(240, 240, 240)

-- Animation settings
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Create rounded corners
local function createRoundCorners(parent, cornerRadius)
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(cornerRadius, 0)
    uicorner.Parent = parent
    return uicorner
end

-- Create shadow
local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

-- Create gradient
local function createGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 60, 210))
    }
    gradient.Rotation = 90
    gradient.Parent = parent
    return gradient
end

-- Loading screen
function ProximityHub:CreateLoadingScreen()
    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "ProximityHubLoading"
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    loadingScreen.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = darkColor
    mainFrame.Parent = loadingScreen
    
    local loadingContainer = Instance.new("Frame")
    loadingContainer.Size = UDim2.new(0, 300, 0, 150)
    loadingContainer.Position = UDim2.new(0.5, -150, 0.5, -75)
    loadingContainer.BackgroundColor3 = lightColor
    loadingContainer.Parent = mainFrame
    
    createRoundCorners(loadingContainer, 0.2)
    createShadow(loadingContainer)
    
    local title = Instance.new("TextLabel")
    title.Text = "Proximity Hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = textColor
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Parent = loadingContainer
    
    local gradient = createGradient(title)
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.8, 0, 0, 10)
    loadingBar.Position = UDim2.new(0.1, 0, 0.7, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
    loadingBar.Parent = loadingContainer
    
    createRoundCorners(loadingBar, 0.5)
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = accentColor
    progressBar.Parent = loadingBar
    
    createRoundCorners(progressBar, 0.5)
    createGradient(progressBar)
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "Loading..."
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 16
    loadingText.TextColor3 = textColor
    loadingText.Size = UDim2.new(1, 0, 0, 20)
    loadingText.Position = UDim2.new(0, 0, 0.5, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Parent = loadingContainer
    
    loadingScreen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Animate loading
    for i = 1, 100 do
        progressBar.Size = UDim2.new(i/100, 0, 1, 0)
        loadingText.Text = "Loading... " .. i .. "%"
        task.wait(0.03)
    end
    
    task.wait(0.5)
    loadingScreen:Destroy()
end

-- Create window
function ProximityHub:CreateWindow(titleText)
    local window = {}
    
    -- Main GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProximityHub"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainFrame.BackgroundColor3 = lightColor
    mainFrame.Parent = screenGui
    
    createRoundCorners(mainFrame, 0.1)
    createShadow(mainFrame)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = darkColor
    titleBar.Parent = mainFrame
    
    createRoundCorners(titleBar, 0.1)
    
    local title = Instance.new("TextLabel")
    title.Text = titleText or "Proximity Hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = textColor
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = textColor
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Parent = titleBar
    
    -- Make draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 30)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -20, 1, -90)
    contentContainer.Position = UDim2.new(0, 10, 0, 90)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame
    
    -- Tab functions
    local tabs = {}
    local currentTab
    
    function window:CreateTab(tabName)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tabName
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.TextColor3 = textColor
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Position = UDim2.new(0, (#tabs * 110), 0, 0)
        tabButton.BackgroundColor3 = darkColor
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer
        
        createRoundCorners(tabButton, 0.1)
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 5
        tabContent.ScrollBarImageColor3 = accentColor
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = tabContent
        
        -- Select first tab by default
        if #tabs == 0 then
            tabButton.BackgroundColor3 = accentColor
            tabContent.Visible = true
            currentTab = tabContent
        end
        
        -- Tab button click
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            
            for _, otherButton in pairs(tabContainer:GetChildren()) do
                if otherButton:IsA("TextButton") then
                    otherButton.BackgroundColor3 = darkColor
                end
            end
            
            tabButton.BackgroundColor3 = accentColor
            tabContent.Visible = true
            currentTab = tabContent
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                tweenService:Create(tabButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 50, 90)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                tweenService:Create(tabButton, tweenInfo, {BackgroundColor3 = darkColor}):Play()
            end
        end)
        
        -- Button functions
        function tab:CreateButton(buttonText, callback)
            local button = Instance.new("TextButton")
            button.Text = buttonText
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.TextColor3 = textColor
            button.Size = UDim2.new(1, -20, 0, 40)
            button.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 50)
            button.BackgroundColor3 = darkColor
            button.AutoButtonColor = false
            button.Parent = tabContent
            
            createRoundCorners(button, 0.1)
            createShadow(button)
            
            -- Hover effects
            button.MouseEnter:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 50, 90)}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = darkColor}):Play()
            end)
            
            -- Click effect
            button.MouseButton1Click:Connect(function()
                tweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 35)}):Play()
                tweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                if callback then
                    callback()
                end
            end)
            
            return button
        end
        
        function tab:CreateToggle(toggleText, defaultState, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 40)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Text = toggleText
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextSize = 14
            toggleLabel.TextColor3 = textColor
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 50, 0, 25)
            toggleButton.Position = UDim2.new(0.7, 0, 0.5, -12.5)
            toggleButton.BackgroundColor3 = defaultState and accentColor or darkColor
            toggleButton.AutoButtonColor = false
            toggleButton.Parent = toggleFrame
            
            createRoundCorners(toggleButton, 0.5)
            
            local toggleState = defaultState or false
            
            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                if toggleState then
                    tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = accentColor}):Play()
                else
                    tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = darkColor}):Play()
                end
                if callback then
                    callback(toggleState)
                end
            end)
            
            return {
                Set = function(self, state)
                    toggleState = state
                    if toggleState then
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = accentColor}):Play()
                    else
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = darkColor}):Play()
                    end
                end,
                Get = function(self)
                    return toggleState
                end
            }
        end
        
        function tab:CreateSlider(sliderText, minValue, maxValue, defaultValue, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 60)
            sliderFrame.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 60)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Text = sliderText
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextSize = 14
            sliderLabel.TextColor3 = textColor
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Text = tostring(defaultValue or minValue)
            sliderValue.Font = Enum.Font.Gotham
            sliderValue.TextSize = 14
            sliderValue.TextColor3 = textColor
            sliderValue.Size = UDim2.new(0, 50, 0, 20)
            sliderValue.Position = UDim2.new(1, -50, 0, 0)
            sliderValue.BackgroundTransparency = 1
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, 0, 0, 5)
            sliderBar.Position = UDim2.new(0, 0, 0, 30)
            sliderBar.BackgroundColor3 = darkColor
            sliderBar.Parent = sliderFrame
            
            createRoundCorners(sliderBar, 0.5)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
            sliderFill.BackgroundColor3 = accentColor
            sliderFill.Parent = sliderBar
            
            createRoundCorners(sliderFill, 0.5)
            createGradient(sliderFill)
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, 15, 0, 15)
            sliderButton.Position = UDim2.new((defaultValue - minValue)/(maxValue - minValue), -7.5, 0.5, -7.5)
            sliderButton.BackgroundColor3 = textColor
            sliderButton.AutoButtonColor = false
            sliderButton.Text = ""
            sliderButton.Parent = sliderBar
            
            createRoundCorners(sliderButton, 0.5)
            createShadow(sliderButton)
            
            local dragging = false
            
            local function updateSlider(input)
                local xScale = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                xScale = math.clamp(xScale, 0, 1)
                
                local value = math.floor(minValue + (maxValue - minValue) * xScale)
                sliderValue.Text = tostring(value)
                sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                sliderButton.Position = UDim2.new(xScale, -7.5, 0.5, -7.5)
                
                if callback then
                    callback(value)
                end
            end
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            sliderBar.MouseButton1Down:Connect(function(x, y)
                updateSlider({Position = Vector2.new(x, y)})
            end)
            
            return {
                Set = function(self, value)
                    value = math.clamp(value, minValue, maxValue)
                    local xScale = (value - minValue)/(maxValue - minValue)
                    sliderValue.Text = tostring(value)
                    sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                    sliderButton.Position = UDim2.new(xScale, -7.5, 0.5, -7.5)
                end,
                Get = function(self)
                    return tonumber(sliderValue.Text)
                end
            }
        end
        
        function tab:CreateLabel(labelText)
            local label = Instance.new("TextLabel")
            label.Text = labelText
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = textColor
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 30)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tabContent
            
            return label
        end
        
        tabs[#tabs + 1] = tab
        return tab
    end
    
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    return window
end

return ProximityHub
