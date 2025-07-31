local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === GUI setup ===
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 130)
frame.Position = UDim2.new(0.4, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Drag logic for GUI window
local dragging, dragInput, dragStart, startPos
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
speedLabel.TextColor3 = Color3.new(1, 1, 1)
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

-- Slider dragging logic
local sliderDragging = false
local speedValue = 50 -- default speed

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
		local mouseX = UIS:GetMouseLocation().X
		local minX = sliderBack.AbsolutePosition.X
		local maxX = minX + sliderBack.AbsoluteSize.X
		local percent = math.clamp((mouseX - minX) / (maxX - minX), 0, 1)

		fill.Size = UDim2.new(percent, 0, 1, 0)
		sliderButton.Position = UDim2.new(percent, -6, -0.8, 0)

		speedValue = math.floor(percent * 100)
		speedLabel.Text = "Speed: " .. speedValue
	end
end)

-- Movement tracking
local flying = false
local bodyGyro
local bodyVelocity

-- Track pressed keys for movement
local moveKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false,
	LeftShift = false,
}

local function getMoveVector()
	local char = LocalPlayer.Character
	if not char then return Vector3.new() end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return Vector3.new() end

	local camCFrame = workspace.CurrentCamera.CFrame
	local forward = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z).Unit
	local right = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z).Unit
	local up = Vector3.new(0,1,0)

	local moveDirection = Vector3.new()

	if moveKeys.W then moveDirection += forward end
	if moveKeys.S then moveDirection -= forward end
	if moveKeys.A then moveDirection -= right end
	if moveKeys.D then moveDirection += right end
	if moveKeys.Space then moveDirection += up end
	if moveKeys.LeftShift then moveDirection -= up end

	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit * speedValue
	end

	return moveDirection
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local key = input.KeyCode.Name
	if moveKeys[key] ~= nil then
		moveKeys[key] = true
	end
end)

UIS.InputEnded:Connect(function(input)
	local key = input.KeyCode.Name
	if moveKeys[key] ~= nil then
		moveKeys[key] = false
	end
end)

local flyConnection

local function stopFlying()
	flying = false
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	print("🛑 Flying stopped")
end

local function startFlying()
	if flying then return end
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	flying = true

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = hrp

	print("✅ Flying started")

	flyConnection = RS.Heartbeat:Connect(function()
		if not flying then
			flyConnection:Disconnect()
			return
		end
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		bodyVelocity.Velocity = getMoveVector()
	end)

	-- Fly for random time before slow fall
	task.wait(math.random(3,5))

	if flying then
		print("⚠️ Losing power, slow fall...")
		bodyVelocity.Velocity = Vector3
