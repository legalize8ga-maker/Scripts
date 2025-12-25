local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local iBTools = {}
iBTools.State = {
	IsActive = false,
	UI = nil,
	Highlight = nil,
	Connections = {},
	History = {},
	SaveHistory = {},
	CurrentPart = nil,
	CurrentMode = "delete"
}

local THEME = {
	Background = Color3.fromRGB(34, 32, 38),
	Accent = Color3.fromRGB(255, 105, 180),
	Title = Color3.fromRGB(255, 182, 193),
	Text = Color3.fromRGB(240, 240, 240),
	Interactive = Color3.fromRGB(20, 20, 25),
	InteractiveHover = Color3.fromRGB(45, 42, 50),
	InteractiveActive = Color3.fromRGB(80, 120, 255),
	Destructive = Color3.fromRGB(200, 70, 90)
}

local function DoNotif(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 3 })
	end)
end

local function formatVectorString(vec: Vector3): string
	return string.format("Vector3.new(%.3f, %.3f, %.3f)", vec.X, vec.Y, vec.Z)
end

local function updateStatus(part: BasePart?)
	if not iBTools.State.UI then return end
	local statusLabel = iBTools.State.UI.StatusLabel
	if not statusLabel then return end
	local targetText = "none"
	if part then
		targetText = part:GetFullName()
	end
	statusLabel.Text = string.format("Mode: %s | Target: %s", iBTools.State.CurrentMode:upper(), targetText)
end

local function setTarget(part: BasePart?)
	if part and not part:IsA("BasePart") then
		part = nil
	end
	iBTools.State.CurrentPart = part
	if iBTools.State.Highlight then
		iBTools.State.Highlight.Adornee = part
	end
	updateStatus(part)
end

local modeHandlers = {
	delete = function(part: BasePart)
		if part:IsDescendantOf(Players.LocalPlayer.Character) then
			return DoNotif("iBTools", "Cannot delete character parts.", 2)
		end
		table.insert(iBTools.State.History, { part = part, parent = part.Parent, cframe = part.CFrame })
		table.insert(iBTools.State.SaveHistory, { name = part.Name, position = part.Position })
		part.Parent = nil
		setTarget(nil)
		DoNotif("iBTools", "Deleted '" .. part.Name .. "'", 2)
	end,
	anchor = function(part: BasePart)
		part.Anchored = not part.Anchored
		updateStatus(part)
		DoNotif("iBTools", string.format("'%s' anchor set to %s", part.Name, tostring(part.Anchored)), 2)
	end,
	collide = function(part: BasePart)
		part.CanCollide = not part.CanCollide
		updateStatus(part)
		DoNotif("iBTools", string.format("'%s' CanCollide set to %s", part.Name, tostring(part.CanCollide)), 2)
	end
}

local uiActions = {
	setMode = function(mode: string)
		iBTools.State.CurrentMode = mode
		updateStatus(iBTools.State.CurrentPart)
	end,
	undo = function()
		local lastAction = table.remove(iBTools.State.History)
		if lastAction then
			lastAction.part.Parent = lastAction.parent
			pcall(function() lastAction.part.CFrame = lastAction.cframe end)
			setTarget(lastAction.part)
			DoNotif("iBTools", "Restored '" .. lastAction.part.Name .. "'", 2)
		else
			DoNotif("iBTools", "Nothing to undo.", 2)
		end
	end,
	copy = function()
		if #iBTools.State.SaveHistory == 0 then
			return DoNotif("iBTools", "No deleted parts to export.", 3)
		end
		local lines = {}
		for _, data in ipairs(iBTools.State.SaveHistory) do
			local line = string.format(
				"for _,v in ipairs(workspace:FindPartsInRegion3(Region3.new(%s, %s), nil, math.huge)) do if v.Name == %q then v:Destroy() end end",
				formatVectorString(data.position - Vector3.new(0.1, 0.1, 0.1)),
				formatVectorString(data.position + Vector3.new(0.1, 0.1, 0.1)),
				data.name
			)
			table.insert(lines, line)
		end
		if setclipboard then
			setclipboard(table.concat(lines, "\n"))
			DoNotif("iBTools", "Copied delete script to clipboard.", 3)
		else
			DoNotif("iBTools", "setclipboard function not available.", 3)
		end
	end
}

function iBTools:Disable()
	if not self.State.IsActive then return end
	if self.State.UI then
		self.State.UI.ScreenGui:Destroy()
	end
	if self.State.Highlight then
		self.State.Highlight:Destroy()
	end
	for _, conn in ipairs(self.State.Connections) do
		conn:Disconnect()
	end
	self.State.IsActive = false
	self.State.UI = nil
	self.State.Highlight = nil
	self.State.CurrentPart = nil
	table.clear(self.State.Connections)
	table.clear(self.State.History)
	table.clear(self.State.SaveHistory)
	DoNotif("iBTools", "Deactivated.", 3)
end

function iBTools:CreateMainPanel()
	local ui = {}
	self.State.UI = ui
	ui.ScreenGui = Instance.new("ScreenGui")
	ui.ScreenGui.Name = "iBToolsUI_Radiant"
	ui.ScreenGui.ResetOnSpawn = false
	ui.ScreenGui.Parent = CoreGui

	local panel = Instance.new("Frame", ui.ScreenGui)
	panel.Name = "Panel"
	panel.Size = UDim2.fromOffset(260, 300)
	panel.Position = UDim2.new(0.05, 0, 0.4, 0)
	panel.BackgroundColor3 = THEME.Background
	panel.BackgroundTransparency = 0.1
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

	local uiStroke = Instance.new("UIStroke", panel)
	uiStroke.Color = THEME.Accent
	uiStroke.Thickness = 2
	RunService.RenderStepped:Connect(function()
		if not uiStroke.Parent then return end
		uiStroke.Thickness = 2 + (math.sin(os.clock() * 4) * 0.5)
		uiStroke.Transparency = 0.3 + (math.sin(os.clock() * 4) * 0.2)
	end)

	local header = Instance.new("Frame", panel)
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 40)
	header.BackgroundTransparency = 1
	header.Active = true

	local title = Instance.new("TextLabel", header)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamSemibold
	title.Text = "iBTools"
	title.Size = UDim2.new(1, 0, 1, 0)
	title.TextColor3 = THEME.Title
	title.TextSize = 20

	ui.StatusLabel = Instance.new("TextLabel", panel)
	ui.StatusLabel.Name = "Status"
	ui.StatusLabel.BackgroundTransparency = 1
	ui.StatusLabel.Size = UDim2.new(1, -24, 0, 20)
	ui.StatusLabel.Position = UDim2.new(0, 12, 0, 45)
	ui.StatusLabel.Font = Enum.Font.Gotham
	ui.StatusLabel.TextColor3 = THEME.Text
	ui.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	ui.StatusLabel.Text = "Mode: DELETE | Target: none"

	local buttonHolder = Instance.new("Frame", panel)
	buttonHolder.BackgroundTransparency = 1
	buttonHolder.Size = UDim2.new(1, -24, 1, -80)
	buttonHolder.Position = UDim2.new(0, 12, 0, 75)
	
	local layout = Instance.new("UIListLayout", buttonHolder)
	layout.Padding = UDim.new(0, 8)

	local modeButtons = {}
	local function createButton(text)
		local button = Instance.new("TextButton")
		button.Name = text
		button.Parent = buttonHolder
		button.Size = UDim2.new(1, 0, 0, 36)
		button.Font = Enum.Font.GothamSemibold
		button.Text = text
		button.TextColor3 = THEME.Text
		button.TextSize = 15
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
		return button
	end
	
	local function refreshModeButtons()
		for mode, button in pairs(modeButtons) do
			local isActive = self.State.CurrentMode == mode
			button.BackgroundColor3 = isActive and THEME.Accent or THEME.Interactive
			button.TextColor3 = isActive and THEME.Background or THEME.Text
		end
	end

	for mode, label in pairs({ delete = "Delete", anchor = "Toggle Anchor", collide = "Toggle CanCollide" }) do
		local button = createButton(label)
		modeButtons[mode] = button
		button.MouseButton1Click:Connect(function()
			uiActions.setMode(mode)
			refreshModeButtons()
		end)
	end
	
	local undoButton = createButton("Undo Last Action")
	undoButton.BackgroundColor3 = THEME.Interactive
	undoButton.MouseButton1Click:Connect(uiActions.undo)
	
	local copyButton = createButton("Copy Delete Script")
	copyButton.BackgroundColor3 = THEME.Interactive
	copyButton.MouseButton1Click:Connect(uiActions.copy)

	local function makeDraggable(frame, dragPart)
		local dragging, dragStart, frameStart
		dragPart.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging, dragStart, frameStart = true, input.Position, frame.Position
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
			end
		end)
	end
	
	makeDraggable(panel, header)
	refreshModeButtons()
end

function iBTools:Enable()
	if self.State.IsActive then return end
	self.State.IsActive = true
	self:CreateMainPanel()
	
	self.State.Highlight = Instance.new("SelectionBox")
	self.State.Highlight.Name = "iBToolsSelection"
	self.State.Highlight.LineThickness = 0.04
	self.State.Highlight.Color3 = THEME.Accent
	self.State.Highlight.Parent = CoreGui

	table.insert(self.State.Connections, RunService.RenderStepped:Connect(function()
		setTarget(Players.LocalPlayer:GetMouse().Target) 
	end))
	
	table.insert(self.State.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if self.State.CurrentPart then
				local handler = modeHandlers[self.State.CurrentMode]
				if handler then handler(self.State.CurrentPart) end
			end
		end
	end))
	DoNotif("iBTools", "Activated.", 3)
end

function iBTools:Toggle()
	if self.State.IsActive then
		self:Disable()
	else
		self:Enable()
	end
end

function iBTools:Initialize()
	local toggleGui = CoreGui:FindFirstChild("iBToolsToggle_Radiant")
	if toggleGui then toggleGui:Destroy() end

	local toggleButtonGui = Instance.new("ScreenGui")
	toggleButtonGui.Name = "iBToolsToggle_Radiant"
	toggleButtonGui.ResetOnSpawn = false
	toggleButtonGui.Parent = CoreGui
	
	local textButton = Instance.new("TextButton", toggleButtonGui)
	textButton.Size = UDim2.fromOffset(60, 60)
	textButton.Position = UDim2.new(0, 20, 0.5, -30)
	textButton.Text = "B"
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 28
	textButton.TextColor3 = THEME.Title
	textButton.BackgroundColor3 = THEME.Background
	Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke", textButton)
	stroke.Thickness = 2
	stroke.Color = THEME.Accent
	stroke.Transparency = 0.3

	local isDragging = false
	local dragStart, startPosition
	local DRAG_THRESHOLD = 10

	textButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragStart, startPosition, isDragging = input.Position, textButton.Position, false
		end
	end)

	textButton.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
			local delta = input.Position - dragStart
			if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
				isDragging = true
			end
			if isDragging then
				textButton.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			end
		end
	end)

	textButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragStart, startPosition = nil, nil
		end
	end)

	textButton.Activated:Connect(function()
		if not isDragging then self:Toggle() end
		isDragging = false
	end)
end

iBTools:Initialize()
