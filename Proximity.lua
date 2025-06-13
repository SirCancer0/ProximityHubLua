-- ProximityHub Library
-- A modern, reactive UI library for Roblox with animations, gradients, and shadows

local ProximityHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Core UI Setup
local function createScreenGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ProximityHub"
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false
	return screenGui
end

-- Loading Screen
local function createLoadingScreen(screenGui)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	frame.Parent = screenGui

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 150)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 25, 75))
	}
	gradient.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0.25, 0, 0.45, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "ProximityHub Loading..."
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 36
	textLabel.Parent = frame

	-- Loading Animation
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0.5})
	tween:Play()

	-- Simulate Loading
	wait(2)
	local fadeTween = TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
	fadeTween:Play()
	for _, obj in pairs(frame:GetDescendants()) do
		if obj:IsA("GuiObject") then
			TweenService:Create(obj, TweenInfo.new(0.5), {Transparency = 1}):Play()
		end
	end
	wait(0.5)
	frame:Destroy()
end

-- Create Window
function ProximityHub:CreateWindow(title)
	local screenGui = createScreenGui()
	createLoadingScreen(screenGui)

	local window = Instance.new("Frame")
	window.Size = UDim2.new(0.4, 0, 0.6, 0)
	window.Position = UDim2.new(0.3, 0, 0.2, 0)
	window.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	window.BorderSizePixel = 0
	window.Parent = screenGui
	window.ClipsDescendants = true

	-- UI Corner
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = window

	-- UI Gradient
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 60, 180)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 90))
	}
	uiGradient.Parent = window

	-- Shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 20, 1, 20)
	shadow.Position = UDim2.new(0, -10, 0, -10)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Parent = window
	shadow.ZIndex = -1

	-- Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0.1, 0)
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = window

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
	titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "ProximityHub"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 24
	titleLabel.Parent = titleBar

	-- Dragging
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = window.Position
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
			update(input)
		end
	end)

	-- Content Frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Size = UDim2.new(1, -20, 0.9, -20)
	contentFrame.Position = UDim2.new(0, 10, 0.1, 10)
	contentFrame.BackgroundTransparency = 1
	contentFrame.ScrollBarThickness = 6
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Parent = window

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = contentFrame

	-- Window API
	local windowAPI = {}

	function windowAPI:AddButton(text, callback)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -20, 0, 50)
		button.Position = UDim2.new(0, 10, 0, 10)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		button.Text = text or "Button"
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Font = Enum.Font.Gotham
		button.TextSize = 20
		button.Parent = contentFrame
		button.ZIndex = 2

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = button

		local btnGradient = Instance.new("UIGradient")
		btnGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 70, 200)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 35, 100))
		}
		btnGradient.Parent = button

		-- Button Animation
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
		end)

		button.MouseButton1Click:Connect(callback or function() end)

		contentFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
	end

	function windowAPI:AddToggle(text, default, callback)
		local toggle = Instance.new("Frame")
		toggle.Size = UDim2.new(1, -20, 0, 50)
		toggle.BackgroundTransparency = 1
		toggle.Parent = contentFrame

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.8, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text or "Toggle"
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.Gotham
		label.TextSize = 20
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = toggle

		local toggleBtn = Instance.new("Frame")
		toggleBtn.Size = UDim2.new(0, 40, 0, 20)
		toggleBtn.Position = UDim2.new(1, -40, 0, 15)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100))
		toggleBtn.Parent = toggle

		local toggleCorner = Instance.new("UICorner")
		toggleCorner.CornerRadius = UDim.new(0, 10)
		toggleCorner.Parent = toggleBtn

		local circle = Instance.new("Frame")
		circle.Size = UDim2.new(0, 16, 0, 16)
		circle.Position = default and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2))
		circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255))
		circle.Parent = toggleBtn

		local circleCorner = Instance.new("UICorner")
		circleCorner.CornerRadius = UDim.new(0, 8)
		circleCorner.Parent = circle

		local state = default or default = false

		toggleBtn.MouseButton1Click:Connect(function()
			state = not state
			local newPos = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
			local newColor = state and Color3.fromRGB(140, 70, 200)) or Color3.fromRGB(3,100, 100, 100))
			TweenService:Create(circle, TweenInfo.new(0.2), {Position = newPos}):Play()
			TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor =3 newColor3}):Play()
			callback(state)
		end)

		contentFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
	end

	-- Animation on Window Open
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	TweenService:Create(window, tweenInfo, {Size = UDim2.new(0.4, 0, 0.6, 0)}):Play()
	TweenService:Create(window, tweenInfo, {BackgroundTransparency = 0}):Play()

	return windowAPI
end

return ProximityHub
