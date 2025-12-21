local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local isFlingEnabled = false
local flingStrength = 1.0
local oscillationValue = 0.1
local flingGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local strengthInputBox = Instance.new("TextBox")
local authorLabel = Instance.new("TextLabel")
flingGui.Name = "FlingGui_Callum"
flingGui.Parent = localPlayer:WaitForChild("PlayerGui")
flingGui.ResetOnSpawn = false
mainFrame.Parent = flingGui
mainFrame.Active = true
mainFrame.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Draggable = true
mainFrame.Position = UDim2.new(0.5, -101, 0.5, -73)
mainFrame.Size = UDim2.new(0, 202, 0, 147)
strengthInputBox.Parent = mainFrame
strengthInputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
strengthInputBox.BackgroundTransparency = 0.7
strengthInputBox.Position = UDim2.new(0.5, -48, 0, 30) 
strengthInputBox.Size = UDim2.new(0, 97, 0, 35)
strengthInputBox.ClearTextOnFocus = false
strengthInputBox.PlaceholderText = "Enter Strength"
strengthInputBox.Text = tostring(flingStrength)
strengthInputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Parent = mainFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.Position = UDim2.new(0.5, -48, 0, 75) 
toggleButton.Size = UDim2.new(0, 96, 0, 34)
toggleButton.Text = "Toggle OFF"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
authorLabel.Parent = mainFrame
authorLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
authorLabel.BackgroundTransparency = 1.000
authorLabel.Position = UDim2.new(0, 5, 0, 0)
authorLabel.Size = UDim2.new(0, 61, 0, 16)
authorLabel.Font = Enum.Font.SourceSans
authorLabel.Text = "By Zuka"
authorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
authorLabel.TextScaled = true
local function updateStrengthDisplay()
    strengthInputBox.Text = tostring(flingStrength)
end
local function executeFlingBurst()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local originalVelocity = rootPart.Velocity
        local flingVelocity = (originalVelocity * flingStrength * 100) + Vector3.new(0, flingStrength * 100, 0)
        rootPart.Velocity = flingVelocity
        RunService.RenderStepped:Wait()
        oscillationValue = -oscillationValue
        rootPart.Velocity = originalVelocity + Vector3.new(0, oscillationValue, 0)
    end
end
local function onHeartbeatUpdate()
    if isFlingEnabled then
        executeFlingBurst()
    end
end
toggleButton.MouseButton1Click:Connect(function()
    isFlingEnabled = not isFlingEnabled
    toggleButton.Text = isFlingEnabled and "Toggle ON" or "Toggle OFF"
end)
strengthInputBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        updateStrengthDisplay()
        return
    end
    local newStrength = tonumber(strengthInputBox.Text)
    if newStrength and newStrength > 0 then
        flingStrength = newStrength
    end
    updateStrengthDisplay()
end)
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Size = isMinimized and UDim2.new(0, 202, 0, 40) or UDim2.new(0, 202, 0, 147)
end)
closeButton.MouseButton1Click:Connect(function()
    flingGui:Destroy()
end)
RunService.Heartbeat:Connect(onHeartbeatUpdate)
