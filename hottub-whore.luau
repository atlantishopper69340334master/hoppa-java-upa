--be careful this is gamebreaking
--ik skid you fucking found it kys
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService('UserInputService')

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaySoundOthers")
local soundID = 154157386
local running = false

local dragToggle = nil
local dragSpeed = 0.25
local dragStart = nil
local startPos = nil

local function updateInput(frame, input)
	local delta = input.Position - dragStart
	local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiGradient = Instance.new("UIGradient")
uiGradient.Rotation = 45
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)), 
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 100))
}
uiGradient.Parent = frame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Transparency = 0.5
uiStroke.Color = Color3.fromRGB(0, 200, 255)
uiStroke.Parent = frame

local function animateStroke()
	while true do
		local tween = TweenService:Create(uiStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1})
		tween:Play()
		tween.Completed:Wait()
		local tween2 = TweenService:Create(uiStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.5})
		tween2:Play()
		tween2.Completed:Wait()
	end
end
task.spawn(animateStroke)

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Hide & Seek Extreme Killer by ramingcactus"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.Parent = frame

local textBox = Instance.new("TextBox")
textBox.PlaceholderText = "Enter Username"
textBox.Text = "Enter Username"
textBox.Size = UDim2.new(1, -20, 0, 35)
textBox.Position = UDim2.new(0, 10, 0, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0.1, 0)
uiCorner2.Parent = textBox

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Start"
toggleButton.Size = UDim2.new(1, -20, 0, 45)
toggleButton.Position = UDim2.new(0, 10, 0, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = frame

local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(0.1, 0)
uiCorner3.Parent = toggleButton

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Rotation = 90
buttonGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 180)), 
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
}
buttonGradient.Parent = toggleButton

local function buttonHover(state)
	local targetSize = state and UDim2.new(1, -10, 0, 50) or UDim2.new(1, -20, 0, 45)
	local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = targetSize})
	tween:Play()
end

toggleButton.MouseEnter:Connect(function() buttonHover(true) end)
toggleButton.MouseLeave:Connect(function() buttonHover(false) end)

frame.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
		dragToggle = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragToggle then
			updateInput(frame, input)
		end
	end
end)

local function annoyTarget()
	if running then return end
	running = true
	toggleButton.Text = "Stop"

	while running do
		local target = Players:FindFirstChild(textBox.Text)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = target.Character.HumanoidRootPart.CFrame
			remote:FireServer(soundID, {Parent = hrp, Pitch = 0.8, Volume = 100})
		end
		task.wait(0.002)
	end
end

toggleButton.MouseButton1Click:Connect(function()
	if running then
		running = false
		toggleButton.Text = "Start"
	else
		annoyTarget()
	end
end)
