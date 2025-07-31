local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 130)
frame.Position = UDim2.new(0.4, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Drag Logic
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RS.RenderStepped:Connect(function()
	if dragging and dragInput then
		update(dragInput)
	end
end)

-- Fly Button
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "🚀 Fly!"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 24
flyButton.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)

local buttonCorner = Instance.new("UICorner", flyButton)
buttonCorner.CornerRadius = UDim.new(0, 8)

-- Speed Label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 10, 0, 60)
speedLabel.Size = UDim2.new(0, 100, 0, 25)
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Speed Slider
local sliderBack = Instance.new("Frame", frame)
sliderBack.Size = UDim2.new(1, -20, 0, 6)
sliderBack.Position = UDim2.new(0, 10, 0, 95)
sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
sliderBack.BorderSizePixel = 0

local fill = Instance.new("Frame", sliderBack)
fill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
fill.BorderSizePixel = 0
fill.Size = UDim2.new(0.5, 0, 1, 0)

local fillCorner = Instance.new("UICorner", fill)
fillCorner.CornerRadius = UDim.new(0, 3)

local sliderButton = Instance.new("TextButton", sliderBack)
sliderButton.Size = UDim2.new(0, 12, 0, 20)
sliderButton.Position = UDim2.new(0.5, -6, -0.8, 0)
sliderButton.Text = ""
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.AutoButtonColor = false

local sliderCorner = Instance.new("UICorner", sliderButton)
sliderCorner.CornerRadius = UDim.new(1, 0)

-- Drag slider logic
local sliderDragging = false
local speedValue = 50 -- default

sliderButton.MouseButton1Down:Connect(function()
	sliderDragging = true
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliderDragging = false
	end
end)

RS.RenderStepped:Connect(function()
	if sliderDragging then
		local mouse = UIS:GetMouseLocation().X
		local minX = sliderBack.AbsolutePosition.X
		local maxX = minX + sliderBack.AbsoluteSize.X
		local percent = math.clamp((mouse - minX) / (maxX - minX), 0, 1)

		fill.Size = UDim2.new(percent, 0, 1, 0)
		sliderButton.Position = UDim2.new(percent, -6, -0.8, 0)

		speedValue = math.floor(percent * 100)
		speedLabel.Text = "Speed: " .. speedValue
	end
end)

-- Fly Logic
local flying = false
local bodyGyro
local bodyVelocity

local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	print("🛑 Full fall: Flying stopped")
end

local function startFlying()
	if flying then return end
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	flying = true

	-- Stage 1: Fly
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, speedValue, 0)
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = hrp

	print("✅ Flying at speed:", speedValue)

	task.wait(math.random(3, 5))

	if flying then
		-- Stage 2: Slow fall
		print("⚠️ Losing power...")
		bodyVelocity.Velocity = Vector3.new(0, -15, 0)
		task.wait(2)
	end

	if flying then
		-- Stage 3: Full fall
		print("⛔ Full fall now!")
		bodyVelocity.Velocity = Vector3.new(0, -100, 0)
		task.wait(1.5)
		stopFlying()
	end
end

-- Button click
flyButton.MouseButton1Click:Connect(function()
	startFlying()
end)

