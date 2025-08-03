--// SETTINGS
local expectedKey = "9867456297"

--// Get player
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeySystem"
gui.ResetOnSpawn = false

--// Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 220)
frame.Position = UDim2.new(0.5, -175, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

--// Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🔐 Futuristic Key System"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

--// Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -30, 0, 6)
close.Text = "✖"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--// Key TextBox
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 40)
box.Position = UDim2.new(0.1, 0, 0.4, 0)
box.PlaceholderText = "Enter Access Key..."
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
box.BorderSizePixel = 0
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

--// Unlock Button
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.5, 0, 0, 35)
button.Position = UDim2.new(0.25, 0, 0.65, 0)
button.Text = "UNLOCK"
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

--// Get Key Button
local getKey = Instance.new("TextButton", frame)
getKey.Size = UDim2.new(0.5, 0, 0, 30)
getKey.Position = UDim2.new(0.25, 0, 0.85, 0)
getKey.Text = "🔑 Get Key"
getKey.Font = Enum.Font.GothamSemibold
getKey.TextColor3 = Color3.fromRGB(255, 255, 255)
getKey.TextScaled = true
getKey.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", getKey).CornerRadius = UDim.new(0, 8)

--// Anti Monitor Script Function
local function loadAntiMonitorScript()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local ScreenGui = Instance.new("ScreenGui", PlayerGui)
	ScreenGui.Name = "AutoQuitStatusGUI"

	local Indicator = Instance.new("Frame", ScreenGui)
	Indicator.Size = UDim2.new(0, 150, 0, 30)
	Indicator.Position = UDim2.new(0, 10, 0, 10)
	Indicator.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
	Indicator.BorderSizePixel = 0

	local StatusLabel = Instance.new("TextLabel", Indicator)
	StatusLabel.Size = UDim2.new(1, -40, 1, 0)
	StatusLabel.Position = UDim2.new(0, 40, 0, 0)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = "SAFE"
	StatusLabel.TextColor3 = Color3.new(0, 0, 0)
	StatusLabel.Font = Enum.Font.SourceSansBold
	StatusLabel.TextScaled = true
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

	local StatusLight = Instance.new("Frame", Indicator)
	StatusLight.Size = UDim2.new(0, 20, 0, 20)
	StatusLight.Position = UDim2.new(0, 10, 0, 5)
	StatusLight.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	StatusLight.BorderSizePixel = 0
	Instance.new("UICorner", StatusLight).CornerRadius = UDim.new(1, 0)

	local function autoQuit(reason)
		StatusLabel.Text = "DANGER"
		StatusLight.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		Indicator.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
		wait(1)
		LocalPlayer:Kick("[AUTO-QUIT] " .. reason)
	end

	Players.PlayerChatted:Connect(function(player, message)
		local msg = message:lower()
		if player ~= LocalPlayer and (msg:find(LocalPlayer.Name:lower()) or msg:find("report")) then
			autoQuit("Suspicious chat message detected")
		end
	end)

	local suspiciousKeywords = { "mod", "admin", "camera", "record", "staff", "monitor", "log" }

	local function isSuspiciousName(name)
		local lname = name:lower()
		for _, keyword in pairs(suspiciousKeywords) do
			if lname:find(keyword) then
				return true
			end
		end
		return false
	end

	local function scanPlayer(player)
		if player == LocalPlayer then return end
		if isSuspiciousName(player.Name) or isSuspiciousName(player.DisplayName) then
			autoQuit("Suspicious player name detected: " .. player.Name)
		end

		player.CharacterAdded:Connect(function(char)
			wait(2)
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp or (hrp.Transparency >= 2) then
				autoQuit("Invisible player character (monitor bot?) detected.")
			end
		end)
	end

	for _, player in pairs(Players:GetPlayers()) do
		scanPlayer(player)
	end
	Players.PlayerAdded:Connect(scanPlayer)
end

--// Get Key Button Logic
getKey.MouseButton1Click:Connect(function()
	local success = pcall(function()
		setclipboard("https://lootdest.org/s?DqH3tKqM")
	end)
	box.PlaceholderText = success and "Key copied URL 📋" or "Manual Key URL"
end)

--// Unlock Button Logic
button.MouseButton1Click:Connect(function()
	if box.Text == expectedKey then
		gui:Destroy()
		loadAntiMonitorScript()
	else
		box.Text = "❌ Invalid Key"
		wait(1)
		box.Text = ""
	end
end)
