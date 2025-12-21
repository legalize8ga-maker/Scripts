--[[
	Callum's Forensic Teleporter Scanner (v1.1)

	Analysis:
	This tool is designed for universal game analysis, identifying parts that function
	as teleporters based on common architectural patterns.

	Architectural Principles:
	- Forensic Analysis: The core logic is based on identifying behavioral patterns.
	- Asynchronous Operation: The workspace scan is run in a coroutine.
	- Non-Invasive Highlighting: Uses the modern `Highlight` instance.
	- Interactive Reporting: Provides a draggable GUI with a clickable list of results.

    Changelog v1.1:
    - Fixed a critical runtime error where the script attempted to call the non-existent
      :Fire() method on the MouseButton1Click event.
    - Re-architected the button logic by abstracting the cleanup process into a dedicated
      `clearResults()` function, which is now correctly called by both the Scan and
      Clear buttons. This resolves the non-functional button issue.
--]]

-- =================================================================================
-- Services
-- =================================================================================
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- =================================================================================
-- Configuration
-- =================================================================================
local CONFIDENCE_THRESHOLDS = {
	SCRIPT = 0.4,
	NAME = 0.6,
	DATA_PAYLOAD = 1.0,
}
local SUSPICIOUS_KEYWORDS = {
	"teleport", "portal", "warp", "door", "secret", "game", "placeid", "gameid", "condo", "hangout"
}

-- =================================================================================
-- State Management
-- =================================================================================
local highlights = {}
local isScanning = false

-- =================================================================================
-- GUI & Core Logic
-- =================================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleporterScannerGui"; screenGui.ResetOnSpawn = false; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"; mainFrame.Size = UDim2.new(0, 350, 0, 450); mainFrame.Position = UDim2.new(0, 10, 0.5, -225); mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 125); mainFrame.ClipsDescendants = true; mainFrame.Parent = screenGui
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 0, 30); titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55); titleLabel.Text = "Forensic Teleporter Scanner"; titleLabel.Font = Enum.Font.SourceSansBold; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.Parent = mainFrame
local scanButton = Instance.new("TextButton")
scanButton.Name = "ScanButton"; scanButton.Size = UDim2.new(1, -10, 0, 30); scanButton.Position = UDim2.new(0.5, 0, 0, 35); scanButton.AnchorPoint = Vector2.new(0.5, 0); scanButton.BackgroundColor3 = Color3.fromRGB(80, 60, 200); scanButton.Font = Enum.Font.SourceSansBold; scanButton.TextColor3 = Color3.fromRGB(255, 255, 255); scanButton.Text = "Begin Workspace Scan"; scanButton.Parent = mainFrame
local clearButton = Instance.new("TextButton")
clearButton.Name = "ClearButton"; clearButton.Size = UDim2.new(1, -10, 0, 20); clearButton.Position = UDim2.new(0.5, 0, 0, 70); clearButton.AnchorPoint = Vector2.new(0.5, 0); clearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60); clearButton.Font = Enum.Font.SourceSans; clearButton.TextColor3 = Color3.fromRGB(255, 255, 255); clearButton.Text = "Clear Highlights & Results"; clearButton.Parent = mainFrame
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Name = "ResultsFrame"; resultsFrame.Size = UDim2.new(1, -10, 1, -95); resultsFrame.Position = UDim2.new(0, 5, 0, 90); resultsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); resultsFrame.Parent = mainFrame
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 3); listLayout.Parent = resultsFrame

-- Helper to create a highlight
local function highlightPart(part, confidence)
	if highlights[part] then return end
	local highlight = Instance.new("Highlight")
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; highlight.FillColor = Color3.fromHSV(0.66 - (confidence * 0.66), 0.8, 1); highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.FillTransparency = 0.5; highlight.Parent = part
	highlights[part] = highlight
end

-- Helper to add a result to the list
local function addResultToList(part, confidence, reason)
	local resultButton = Instance.new("TextButton")
	resultButton.Name = part.Name; resultButton.Text = `[{string.format("%.0f", confidence * 100)}%] {part:GetFullName()} ({reason})`; resultButton.Size = UDim2.new(1, 0, 0, 25); resultButton.BackgroundColor3 = Color3.fromHSV(0.66 - (confidence * 0.66), 0.5, 0.5); resultButton.Font = Enum.Font.SourceSans; resultButton.TextXAlignment = Enum.TextXAlignment.Left; resultButton.TextColor3 = Color3.fromRGB(225, 225, 225); resultButton.LayoutOrder = -confidence; resultButton.Parent = resultsFrame
	resultButton.MouseButton1Click:Connect(function()
		local camera = Workspace.CurrentCamera; camera.CameraType = Enum.CameraType.Scriptable
		local targetCFrame = CFrame.new(part.Position + part.CFrame.LookVector * 10, part.Position)
		local tween = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = targetCFrame})
		tween:Play(); tween.Completed:Wait(); camera.CameraType = Enum.CameraType.Custom
	end)
end

-- [FIX] Abstracted the cleanup logic into its own function.
local function clearResults()
	for _, highlight in pairs(highlights) do
		if highlight and highlight.Parent then highlight:Destroy() end
	end
	highlights = {}
	for _, child in ipairs(resultsFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	scanButton.Text = "Begin Workspace Scan"
	scanButton.Active = true
end

-- Core Scan Function
local function scanWorkspace()
	isScanning = true
	scanButton.Text = "Scanning... (This may take a moment)"; scanButton.Active = false
	local partsFound = 0
	local descendants = Workspace:GetDescendants()
	for i, descendant in ipairs(descendants) do
		if i % 500 == 0 then task.wait() end
		if descendant:IsA("BasePart") then
			local confidence = 0; local reason = ""
			if descendant:FindFirstChildWhichIsA("Script") or descendant:FindFirstChildWhichIsA("LocalScript") then
				confidence = math.max(confidence, CONFIDENCE_THRESHOLDS.SCRIPT); reason = "Has Script"
			end
			for _, child in ipairs(descendant:GetChildren()) do
				for _, keyword in ipairs(SUSPICIOUS_KEYWORDS) do
					if string.find(string.lower(child.Name), keyword) then
						confidence = math.max(confidence, CONFIDENCE_THRESHOLDS.DATA_PAYLOAD); reason = `Data: "{child.Name}"`; break
					end
				end
			end
			for _, keyword in ipairs(SUSPICIOUS_KEYWORDS) do
				if string.find(string.lower(descendant.Name), keyword) then
					confidence = math.max(confidence, CONFIDENCE_THRESHOLDS.NAME); reason = reason == "" and "Suspicious Name" or reason; break
				end
			end
			if confidence > 0 then
				partsFound += 1; highlightPart(descendant, confidence); addResultToList(descendant, confidence, reason)
			end
		end
	end
	scanButton.Text = `Scan Complete! Found {partsFound} potential teleporters.`
	isScanning = false
end

-- [REVISED] Button Connections now use the abstracted function.
scanButton.MouseButton1Click:Connect(function()
	if isScanning then return end
	clearResults() -- Correctly call the cleanup function.
	task.spawn(scanWorkspace)
end)

clearButton.MouseButton1Click:Connect(clearResults) -- Connect the button directly to the cleanup function.

-- Make GUI Draggable
local isDragging, dragStart, startPosition = false, nil, nil
titleLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true; dragStart = input.Position; startPosition = mainFrame.Position; end end)
titleLabel.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end)

-- Finalize
screenGui.Parent = CoreGui
print("Callum's Log: Forensic Teleporter Scanner (v1.1) loaded. Buttons are now operational.")