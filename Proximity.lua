-- Proximity Hub Library
-- Version 2.0 (WindUI Style)
local ProximityHub = {}
ProximityHub.__index = ProximityHub

-- Dependencies
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Theme Configuration
local Themes = {
    Dark = {
        Primary = Color3.fromHex("#2A1A3A"),
        Secondary = Color3.fromHex("#1E1125"),
        Tertiary = Color3.fromHex("#3A2452"),
        Accent = Color3.fromHex("#8A4FFF"),
        Text = Color3.fromHex("#FFFFFF"),
        SubText = Color3.fromHex("#B8B8B8"),
        Outline = Color3.fromHex("#4A3A5A"),
        Shadow = Color3.fromHex("#0A0A12")
    },
    Light = {
        Primary = Color3.fromHex("#F5F0FF"),
        Secondary = Color3.fromHex("#E8E0F5"),
        Tertiary = Color3.fromHex("#D8C8FF"),
        Accent = Color3.fromHex("#8A4FFF"),
        Text = Color3.fromHex("#2A1A3A"),
        SubText = Color3.fromHex("#5A4A6A"),
        Outline = Color3.fromHex("#D0C0E8"),
        Shadow = Color3.fromHex("#C0B0D8")
    }
}

-- Animation Settings
local TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Utility Functions
local function Create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = val
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Gradient(parent, colors, rotation)
    local gradient = Create("UIGradient", {
        Parent = parent,
        Color = ColorSequence.new(colors),
        Rotation = rotation or 90
    })
    return gradient
end

local function RoundCorners(parent, radius)
    local corner = Create("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(radius, 0)
    })
    return corner
end

local function Shadow(parent)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = parent,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        ZIndex = parent.ZIndex - 1
    })
    return shadow
end

-- Loading Screen
function ProximityHub:CreateLoadingScreen()
    local loadingGui = Create("ScreenGui", {
        Name = "ProximityHubLoading",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local mainFrame = Create("Frame", {
        Parent = loadingGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Themes.Dark.Primary
    })

    local container = Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(0, 350, 0, 180),
        Position = UDim2.new(0.5, -175, 0.5, -90),
        BackgroundColor3 = Themes.Dark.Secondary,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    RoundCorners(container, 0.15)
    Shadow(container)

    local title = Create("TextLabel", {
        Parent = container,
        Text = "PROXIMITY HUB",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Themes.Dark.Text,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10)
    })

    Gradient(title, {Themes.Dark.Accent, Color3.fromHex("#B87AFF")})

    local loadingBar = Create("Frame", {
        Parent = container,
        Size = UDim2.new(0.8, 0, 0, 8),
        Position = UDim2.new(0.1, 0, 0.7, 0),
        BackgroundColor3 = Themes.Dark.Tertiary,
        AnchorPoint = Vector2.new(0, 0.5)
    })

    RoundCorners(loadingBar, 1)

    local progressBar = Create("Frame", {
        Parent = loadingBar,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Themes.Dark.Accent,
        AnchorPoint = Vector2.new(0, 0)
    })

    RoundCorners(progressBar, 1)
    Gradient(progressBar, {Themes.Dark.Accent, Color3.fromHex("#B87AFF")})

    local loadingText = Create("TextLabel", {
        Parent = container,
        Text = "Initializing...",
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = Themes.Dark.SubText,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.8, 0),
        BackgroundTransparency = 1
    })

    loadingGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Animate loading
    for i = 1, 100 do
        progressBar.Size = UDim2.new(i/100, 0, 1, 0)
        loadingText.Text = string.format("Loading... %d%%", i)
        RunService.Heartbeat:Wait()
    end

    task.wait(0.5)
    loadingGui:Destroy()
end

-- Main Window Creation
function ProximityHub:CreateWindow(config)
    config = config or {}
    local window = {}
    local currentTheme = config.Theme or "Dark"
    local theme = Themes[currentTheme]

    -- Main GUI
    local screenGui = Create("ScreenGui", {
        Name = "ProximityHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local mainFrame = Create("Frame", {
        Parent = screenGui,
        Size = config.Size or UDim2.new(0, 500, 0, 550),
        Position = UDim2.new(0.5, -250, 0.5, -275),
        BackgroundColor3 = theme.Primary,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })

    RoundCorners(mainFrame, 0.1)
    Shadow(mainFrame)

    -- Title Bar
    local titleBar = Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Secondary
    })

    RoundCorners(titleBar, 0.1)

    local title = Create("TextLabel", {
        Parent = titleBar,
        Text = config.Title or "Proximity Hub",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.Text,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local closeButton = Create("TextButton", {
        Parent = titleBar,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = theme.Text,
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1
    })

    -- Draggable Window
    local dragging, dragInput, dragStart, startPos
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Close Button
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if window.OnClose then
            window.OnClose()
        end
    end)

    -- Sidebar
    local sidebar = Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(0, 180, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = theme.Secondary
    })

    local sidebarList = Create("UIListLayout", {
        Parent = sidebar,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Content Area
    local contentFrame = Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -180, 1, -40),
        Position = UDim2.new(0, 180, 0, 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    -- Tab System
    local tabs = {}
    local currentTab

    function window:Tab(config)
        local tab = {}
        local tabConfig = typeof(config) == "table" and config or {Title = config}
        
        local tabButton = Create("TextButton", {
            Parent = sidebar,
            Text = tabConfig.Title or "Tab",
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = theme.SubText,
            Size = UDim2.new(1, -20, 0, 35),
            Position = UDim2.new(0, 10, 0, #tabs * 40),
            BackgroundColor3 = theme.Tertiary,
            AutoButtonColor = false,
            LayoutOrder = #tabs + 1
        })

        RoundCorners(tabButton, 0.1)

        local tabContent = Create("ScrollingFrame", {
            Parent = contentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = theme.Accent,
            Visible = false
        })

        local contentList = Create("UIListLayout", {
            Parent = tabContent,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Select first tab by default
        if #tabs == 0 then
            tabButton.TextColor3 = theme.Text
            tabButton.BackgroundColor3 = theme.Accent
            tabContent.Visible = true
            currentTab = tabContent
        end

        -- Tab button click
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            
            for _, otherButton in pairs(sidebar:GetChildren()) do
                if otherButton:IsA("TextButton") then
                    otherButton.TextColor3 = theme.SubText
                    otherButton.BackgroundColor3 = theme.Tertiary
                end
            end
            
            tabButton.TextColor3 = theme.Text
            tabButton.BackgroundColor3 = theme.Accent
            tabContent.Visible = true
            currentTab = tabContent
        end)

        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(
                        math.floor(theme.Tertiary.R * 255 + 20),
                        math.floor(theme.Tertiary.G * 255 + 20),
                        math.floor(theme.Tertiary.B * 255 + 20)
                    )
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = theme.Tertiary
                }):Play()
            end
        end)

        -- Tab functions
        function tab:Button(config)
            local buttonConfig = typeof(config) == "table" and config or {Title = config}
            
            local button = Create("TextButton", {
                Parent = tabContent,
                Text = buttonConfig.Title or "Button",
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = theme.Text,
                Size = UDim2.new(1, -20, 0, 40),
                Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 50),
                BackgroundColor3 = theme.Secondary,
                AutoButtonColor = false
            })

            RoundCorners(button, 0.1)
            Shadow(button)

            -- Hover effects
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.15), {
                    BackgroundColor3 = theme.Tertiary
                }):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.15), {
                    BackgroundColor3 = theme.Secondary
                }):Play()
            end)

            -- Click effect
            button.MouseButton1Click:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 35)}):Play()
                TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                if buttonConfig.Callback then
                    buttonConfig.Callback()
                end
            end)

            return {
                Destroy = function()
                    button:Destroy()
                end
            }
        end

        function tab:Toggle(config)
            local toggleConfig = typeof(config) == "table" and config or {Title = config}
            
            local toggleFrame = Create("Frame", {
                Parent = tabContent,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 40),
                BackgroundTransparency = 1
            })

            local toggleLabel = Create("TextLabel", {
                Parent = toggleFrame,
                Text = toggleConfig.Title or "Toggle",
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = theme.Text,
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local toggleButton = Create("TextButton", {
                Parent = toggleFrame,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(0.7, 0, 0.5, -12.5),
                BackgroundColor3 = (toggleConfig.Value and theme.Accent or theme.Tertiary),
                AutoButtonColor = false
            })

            RoundCorners(toggleButton, 0.5)

            local toggleState = toggleConfig.Value or false

            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                if toggleState then
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = theme.Accent
                    }):Play()
                else
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = theme.Tertiary
                    }):Play()
                end
                if toggleConfig.Callback then
                    callback(toggleState)
                end
            end)

            return {
                Set = function(self, state)
                    toggleState = state
                    if toggleState then
                        toggleButton.BackgroundColor3 = theme.Accent
                    else
                        toggleButton.BackgroundColor3 = theme.Tertiary
                    end
                end,
                Get = function(self)
                    return toggleState
                end
            }
        end

        function tab:Slider(config)
            local sliderConfig = typeof(config) == "table" and config or {Title = config}
            
            local sliderFrame = Create("Frame", {
                Parent = tabContent,
                Size = UDim2.new(1, -20, 0, 60),
                Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 60),
                BackgroundTransparency = 1
            })

            local sliderLabel = Create("TextLabel", {
                Parent = sliderFrame,
                Text = sliderConfig.Title or "Slider",
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = theme.Text,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local sliderValue = Create("TextLabel", {
                Parent = sliderFrame,
                Text = tostring(sliderConfig.Default or sliderConfig.Min or 0),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = theme.SubText,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -50, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local sliderBar = Create("Frame", {
                Parent = sliderFrame,
                Size = UDim2.new(1, 0, 0, 5),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundColor3 = theme.Tertiary
            })

            RoundCorners(sliderBar, 0.5)

            local sliderFill = Create("Frame", {
                Parent = sliderBar,
                Size = UDim2.new((sliderConfig.Default - sliderConfig.Min)/(sliderConfig.Max - sliderConfig.Min), 0, 1, 0),
                BackgroundColor3 = theme.Accent
            })

            RoundCorners(sliderFill, 0.5)
            Gradient(sliderFill, {theme.Accent, Color3.fromHex("#B87AFF")})

            local sliderButton = Create("TextButton", {
                Parent = sliderBar,
                Size = UDim2.new(0, 15, 0, 15),
                Position = UDim2.new((sliderConfig.Default - sliderConfig.Min)/(sliderConfig.Max - sliderConfig.Min), -7.5, 0.5, -7.5),
                BackgroundColor3 = theme.Text,
                AutoButtonColor = false,
                Text = ""
            })

            RoundCorners(sliderButton, 0.5)
            Shadow(sliderButton)

            local dragging = false

            local function updateSlider(input)
                local xScale = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                xScale = math.clamp(xScale, 0, 1)
                
                local value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * xScale)
                sliderValue.Text = tostring(value)
                sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                sliderButton.Position = UDim2.new(xScale, -7.5, 0.5, -7.5)
                
                if sliderConfig.Callback then
                    sliderConfig.Callback(value)
                end
            end

            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            sliderBar.MouseButton1Down:Connect(function(x, y)
                updateSlider({Position = Vector2.new(x, y)})
            end)

            return {
                Set = function(self, value)
                    value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                    local xScale = (value - sliderConfig.Min)/(sliderConfig.Max - sliderConfig.Min)
                    sliderValue.Text = tostring(value)
                    sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                    sliderButton.Position = UDim2.new(xScale, -7.5, 0.5, -7.5)
                end,
                Get = function(self)
                    return tonumber(sliderValue.Text)
                end
            }
        end

        function tab:Label(text)
            local label = Create("TextLabel", {
                Parent = tabContent,
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = theme.Text,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 30),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            return label
        end

        tabs[#tabs + 1] = tab
        return tab
    end

    -- Set parent at the end to avoid flickering
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    return window
end

-- Popup Function
function ProximityHub:Popup(config)
    local popupGui = Create("ScreenGui", {
        Name = "ProximityHubPopup",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local overlay = Create("Frame", {
        Parent = popupGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5
    })

    local popupFrame = Create("Frame", {
        Parent = popupGui,
        Size = UDim2.new(0, 350, 0, 200),
        Position = UDim2.new(0.5, -175, 0.5, -100),
        BackgroundColor3 = Themes.Dark.Primary,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    RoundCorners(popupFrame, 0.15)
    Shadow(popupFrame)

    local title = Create("TextLabel", {
        Parent = popupFrame,
        Text = config.Title or "Alert",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Themes.Dark.Text,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1
    })

    local content = Create("TextLabel", {
        Parent = popupFrame,
        Text = config.Content or "Message",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Themes.Dark.SubText,
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        TextWrapped = true
    })

    local buttonContainer = Create("Frame", {
        Parent = popupFrame,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 1, -50),
        BackgroundTransparency = 1
    })

    local buttonList = Create("UIListLayout", {
        Parent = buttonContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    for i, btnConfig in ipairs(config.Buttons or {}) do
        local button = Create("TextButton", {
            Parent = buttonContainer,
            Text = btnConfig.Title or "Button",
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Themes.Dark.Text,
            Size = UDim2.new(0, 80, 1, 0),
            BackgroundColor3 = btnConfig.Variant == "Primary" and Themes.Dark.Accent or Themes.Dark.Tertiary,
            AutoButtonColor = false,
            LayoutOrder = i
        })

        RoundCorners(button, 0.1)

        button.MouseButton1Click:Connect(function()
            if btnConfig.Callback then
                btnConfig.Callback()
            end
            popupGui:Destroy()
        end)

        -- Hover effects
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(
                    math.floor(button.BackgroundColor3.R * 255 + 20),
                    math.floor(button.BackgroundColor3.G * 255 + 20),
                    math.floor(button.BackgroundColor3.B * 255 + 20)
                )
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = btnConfig.Variant == "Primary" and Themes.Dark.Accent or Themes.Dark.Tertiary
            }):Play()
        end)
    end

    popupGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

return ProximityHub
