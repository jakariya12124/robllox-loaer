--// SETTINGS
local expectedKey = "9867456297"
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI persists after death
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = playerGui

--// KEY SYSTEM FRAME
local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 350, 0, 220)
frame.Position = UDim2.new(0.5, -175, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local glow = Instance.new("UIStroke", frame)
glow.Thickness = 2
glow.Color = Color3.fromRGB(0, 170, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🔐 Futuristic Key System"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -30, 0, 6)
close.Text = "✖"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.MouseButton1Click:Connect(function()
	keyGui:Destroy()
end)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 40)
box.Position = UDim2.new(0.1, 0, 0.4, 0)
box.PlaceholderText = "Enter Access Key..."
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextScaled = true
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local unlockBtn = Instance.new("TextButton", frame)
unlockBtn.Size = UDim2.new(0.5, 0, 0, 35)
unlockBtn.Position = UDim2.new(0.25, 0, 0.65, 0)
unlockBtn.Text = "UNLOCK"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextScaled = true
unlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unlockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", unlockBtn).CornerRadius = UDim.new(0, 10)

local getKey = Instance.new("TextButton", frame)
getKey.Size = UDim2.new(0.5, 0, 0, 30)
getKey.Position = UDim2.new(0.25, 0, 0.85, 0)
getKey.Text = "🔑 Get Key"
getKey.Font = Enum.Font.GothamSemibold
getKey.TextColor3 = Color3.fromRGB(255, 255, 255)
getKey.TextScaled = true
getKey.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", getKey).CornerRadius = UDim.new(0, 8)

getKey.MouseButton1Click:Connect(function()
	setclipboard("https://lootdest.org/s?DqH3tKqM")
	box.PlaceholderText = "Key copied URL 📋"
end)

unlockBtn.MouseButton1Click:Connect(function()
	if box.Text == expectedKey then
		keyGui:Destroy()
		spawnExecutorGui()
	else
		box.Text = "❌ Invalid Key"
		wait(1)
		box.Text = ""
	end
end)

--// FUNCTION: EXECUTOR GUI
function spawnExecutorGui()
	local gui = Instance.new("ScreenGui", playerGui)
	gui.Name = "ExecutorUI"
	gui.ResetOnSpawn = false

	local executor = Instance.new("Frame", gui)
	executor.Size = UDim2.new(0, 300, 0, 160)
	executor.Position = UDim2.new(0.5, -150, 0.5, -80)
	executor.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	executor.Active = true
	executor.Draggable = true
	executor.BorderSizePixel = 0

	local stroke = Instance.new("UIStroke", executor)
	stroke.Color = Color3.fromRGB(0, 255, 255)
	stroke.Thickness = 2

	Instance.new("UICorner", executor).CornerRadius = UDim.new(0, 10)

	-- Active Button 1
	local b1 = Instance.new("TextButton", executor)
	b1.Size = UDim2.new(0.8, 0, 0, 40)
	b1.Position = UDim2.new(0.1, 0, 0.15, 0)
	b1.Text = "Active 1"
	b1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	b1.TextColor3 = Color3.new(1, 1, 1)
	b1.Font = Enum.Font.GothamBold
	b1.TextScaled = true

	-- Active Button 2
	local b2 = Instance.new("TextButton", executor)
	b2.Size = UDim2.new(0.8, 0, 0, 40)
	b2.Position = UDim2.new(0.1, 0, 0.5, 0)
	b2.Text = "Active 2"
	b2.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	b2.TextColor3 = Color3.new(1, 1, 1)
	b2.Font = Enum.Font.GothamBold
	b2.TextScaled = true

	-- Close/Minimize Button
	local mini = Instance.new("TextButton", executor)
	mini.Size = UDim2.new(0, 24, 0, 24)
	mini.Position = UDim2.new(1, -30, 0, 6)
	mini.Text = "–"
	mini.Font = Enum.Font.GothamBold
	mini.TextScaled = true
	mini.TextColor3 = Color3.fromRGB(255, 255, 255)
	mini.BackgroundTransparency = 1

	-- Mini Widget (hidden by default)
	local miniBox = Instance.new("TextButton", gui)
	miniBox.Size = UDim2.new(0, 120, 0, 35)
	miniBox.Position = UDim2.new(0.5, -60, 1, -50)
	miniBox.Text = "🔄 Open Executor"
	miniBox.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	miniBox.TextColor3 = Color3.new(1, 1, 1)
	miniBox.Font = Enum.Font.GothamBold
	miniBox.TextScaled = true
	miniBox.Visible = false
	Instance.new("UICorner", miniBox).CornerRadius = UDim.new(0, 10)

	mini.MouseButton1Click:Connect(function()
		executor:TweenPosition(
			UDim2.new(0.5, -150, 2, 0),  -- slide out
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine,
			0.4,
			true,
			function()
				executor.Visible = false
				miniBox.Visible = true
			end
		)
	end)

	miniBox.MouseButton1Click:Connect(function()
		executor.Position = UDim2.new(0.5, -150, 2, 0)
		executor.Visible = true
		executor:TweenPosition(
			UDim2.new(0.5, -150, 0.5, -80),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine,
			0.4,
			true
		)
		miniBox.Visible = false
	end)

	-- Your custom script areas
	b1.MouseButton1Click:Connect(function()
		print("loadstring(game:HttpGet("https://raw.githubusercontent.com/jakariya12124/robllox-loaer/main/test"))()
	end)

	b2.MouseButton1Click:Connect(function()
		print("Running Script 2")
		-- Add your second script here if you want
	end)
end

