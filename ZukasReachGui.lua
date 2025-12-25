local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local ATTRIBUTE_OG_SIZE = "Zuka_OriginalSize"
local SELECTION_BOX_NAME = "Zuka_ReachSelectionBox"
local LocalPlayer = Players.LocalPlayer

local connections = {}
local activeTool: Tool? = nil
local modifiedPart: BasePart? = nil
local persistentToolName: string? = nil
local persistentPartName: string? = nil
local currentReachSize: number = 20
local currentReachType: "directional" | "box" = "directional"
local uiElements = {}

local function updatePartModification(part: BasePart, newSize: number?, reachType: string?)
	if not part or not part.Parent then return end

	local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)

	if not newSize then
		if originalSize then
			part.Size = originalSize
			part:SetAttribute(ATTRIBUTE_OG_SIZE, nil)
		end
		local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
		if selectionBox then
			selectionBox:Destroy()
		end
		return
	end

	if not originalSize then
		part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size)
	end

	local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
	if not selectionBox then
		selectionBox = Instance.new("SelectionBox")
		selectionBox.Name = SELECTION_BOX_NAME
		selectionBox.Adornee = part
		selectionBox.LineThickness = 0.02
		selectionBox.Parent = part
	end
	
	selectionBox.Color3 = reachType == "box" and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(255, 105, 180)
	
	if reachType == "box" then
		part.Size = Vector3.one * newSize
	else
		part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize)
	end
	part.Massless = true
end

local function populatePartSelector()
	local scroll = uiElements.ScrollingFrame
	if not scroll then return end
	
	scroll:ClearAllChildren()
	
	if not activeTool then return end

	local parts: {BasePart} = {}
	for _, descendant in ipairs(activeTool:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(parts, descendant)
		end
	end

	if #parts == 0 then return end
	
	local listLayout = Instance.new("UIListLayout", scroll)
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	for _, part in ipairs(parts) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Position = UDim2.fromScale(0.5, 0)
		btn.AnchorPoint = Vector2.new(0.5, 0)
		btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		btn.Font = Enum.Font.Gotham
		btn.Text = part.Name
		btn.TextSize = 14
		btn.Parent = scroll
		
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

		btn.MouseButton1Click:Connect(function()
			if not part or not part.Parent or not activeTool then
				return
			end
			
			persistentToolName = activeTool.Name
			persistentPartName = part.Name
			
			if modifiedPart and modifiedPart ~= part then
				updatePartModification(modifiedPart, nil, nil)
			end
			
			modifiedPart = part
			updatePartModification(part, currentReachSize, currentReachType)
		end)
	end
end

local function resetReach()
	if not modifiedPart and not persistentToolName then
		return
	end

	local tool
	if persistentToolName then
		tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(persistentToolName)
		if not tool then
			tool = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(persistentToolName)
		end
	end
	
	local partToReset = modifiedPart
	if not partToReset and tool and persistentPartName then
		partToReset = tool:FindFirstChild(persistentPartName, true)
	end

	if partToReset then
		updatePartModification(partToReset, nil, nil)
	end
	
	modifiedPart = nil
	persistentToolName = nil
	persistentPartName = nil
end

local function onToolEquipped(tool: Tool)
	activeTool = tool
	populatePartSelector()
	
	if connections.Unequipped then connections.Unequipped:Disconnect() end
	connections.Unequipped = tool.Unequipped:Connect(function()
		activeTool = nil
		populatePartSelector()
	end)
end

local function onCharacterAdded(character: Model)
	if persistentToolName and persistentPartName then
		local function reapplyModification(tool: Tool?)
			if tool and tool.Name == persistentToolName then
				local part = tool:WaitForChild(persistentPartName, 2)
				if part and part:IsA("BasePart") then
					updatePartModification(part, currentReachSize, currentReachType)
					modifiedPart = part
				end
			end
		end

		reapplyModification(character:FindFirstChild(persistentToolName))
		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then reapplyModification(child) end
		end)
	end
	
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then onToolEquipped(child) end
	end)
	
	local firstEquippedTool = character:FindFirstChildOfClass("Tool")
	if firstEquippedTool then onToolEquipped(firstEquippedTool) end
end

local function createInterface()
	if CoreGui:FindFirstChild("ReachController_Zuka_Radiant") then
		CoreGui.ReachController_Zuka_Radiant:Destroy()
	end
	
	local ui = Instance.new("ScreenGui")
	ui.Name = "ReachController_Zuka_Radiant"
	ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ui.ResetOnSpawn = false
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(250, 320)
	mainFrame.Position = UDim2.fromScale(0, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(34, 32, 38)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = ui
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
	
	local uiStroke = Instance.new("UIStroke", mainFrame)
	uiStroke.Color = Color3.fromRGB(255, 105, 180)
	uiStroke.Thickness = 2
	
	local glowConnection
	glowConnection = RunService.RenderStepped:Connect(function()
		if not (uiStroke and uiStroke.Parent) then
			glowConnection:Disconnect()
			return
		end
		local sine = math.sin(os.clock() * 4)
		uiStroke.Thickness = 2 + (sine * 0.5)
		uiStroke.Transparency = 0.3 + (sine * 0.2)
	end)
	
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundTransparency = 1
	titleBar.Parent = mainFrame
	
	local title = Instance.new("TextLabel", titleBar)
	title.Size = UDim2.new(1, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamSemibold
	title.Text = "Reach Controller"
	title.TextColor3 = Color3.fromRGB(255, 182, 193)
	title.TextSize = 20
	title.TextXAlignment = Enum.TextXAlignment.Center

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, 0, 1, -40)
	contentFrame.Position = UDim2.new(0, 0, 0, 40)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame
	
	local toggleButton = Instance.new("TextButton", titleBar)
	toggleButton.Size = UDim2.fromOffset(25, 25)
	toggleButton.Position = UDim2.new(1, -10, 0.5, 0)
	toggleButton.AnchorPoint = Vector2.new(1, 0.5)
	toggleButton.BackgroundTransparency = 1
	toggleButton.Text = "-"
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.TextSize = 24
	
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local dragStart = input.Position
			local startPos = mainFrame.Position
			local moveConn, endConn
			moveConn = UserInputService.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = moveInput.Position - dragStart
					mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end)
			endConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					if moveConn then moveConn:Disconnect() end
					if endConn then endConn:Disconnect() end
				end
			end)
		end
	end)

	local sizeLabel = Instance.new("TextLabel", contentFrame)
	sizeLabel.Size = UDim2.fromOffset(80, 20)
	sizeLabel.Position = UDim2.fromOffset(10, 10)
	sizeLabel.BackgroundTransparency = 1
	sizeLabel.Font = Enum.Font.Gotham
	sizeLabel.Text = "Reach Size:"
	sizeLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local sizeInput = Instance.new("TextBox", contentFrame)
	sizeInput.Size = UDim2.fromOffset(130, 30)
	sizeInput.Position = UDim2.fromOffset(110, 5)
	sizeInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	sizeInput.Font = Enum.Font.Gotham
	sizeInput.Text = tostring(currentReachSize)
	sizeInput.TextColor3 = Color3.fromRGB(240, 240, 240)
	Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 4)
	
	local directionalBtn = Instance.new("TextButton", contentFrame)
	directionalBtn.Size = UDim2.fromOffset(110, 30)
	directionalBtn.Position = UDim2.fromOffset(10, 40)
	directionalBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 50)
	directionalBtn.Font = Enum.Font.GothamSemibold
	directionalBtn.Text = "Directional"
	directionalBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	Instance.new("UICorner", directionalBtn).CornerRadius = UDim.new(0, 4)
	
	local boxBtn = Instance.new("TextButton", contentFrame)
	boxBtn.Size = UDim2.fromOffset(110, 30)
	boxBtn.Position = UDim2.fromOffset(130, 40)
	boxBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	boxBtn.Font = Enum.Font.GothamSemibold
	boxBtn.Text = "Box"
	boxBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	Instance.new("UICorner", boxBtn).CornerRadius = UDim.new(0, 4)

	local partsLabel = Instance.new("TextLabel", contentFrame)
	partsLabel.Size = UDim2.fromOffset(80, 20)
	partsLabel.Position = UDim2.fromOffset(10, 75)
	partsLabel.BackgroundTransparency = 1
	partsLabel.Font = Enum.Font.Gotham
	partsLabel.Text = "Tool Parts:"
	partsLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	partsLabel.TextXAlignment = Enum.TextXAlignment.Left

	local scroll = Instance.new("ScrollingFrame", contentFrame)
	scroll.Size = UDim2.new(1, -20, 1, -140)
	scroll.Position = UDim2.fromOffset(10, 100)
	scroll.BackgroundColor3 = Color3.fromRGB(20, 18, 22)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
	uiElements.ScrollingFrame = scroll
	
	local resetBtn = Instance.new("TextButton", contentFrame)
	resetBtn.Size = UDim2.new(1, -20, 0, 30)
	resetBtn.Position = UDim2.new(0.5, 0, 1, -10)
	resetBtn.AnchorPoint = Vector2.new(0.5, 1)
	resetBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 90)
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.Text = "Reset Reach"
	resetBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 4)

	sizeInput.FocusLost:Connect(function(enterPressed)
		local num = tonumber(sizeInput.Text)
		if num and num > 0 then
			currentReachSize = num
		else
			sizeInput.Text = tostring(currentReachSize)
		end
	end)

	directionalBtn.MouseButton1Click:Connect(function()
		currentReachType = "directional"
		directionalBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 50)
		boxBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	end)
	
	boxBtn.MouseButton1Click:Connect(function()
		currentReachType = "box"
		boxBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 50)
		directionalBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	end)
	
	resetBtn.MouseButton1Click:Connect(resetReach)
	
	toggleButton.MouseButton1Click:Connect(function()
		local isVisible = not contentFrame.Visible
		contentFrame.Visible = isVisible
		toggleButton.Text = isVisible and "-" or "+"
		local goalSize = isVisible and UDim2.fromOffset(250, 320) or UDim2.fromOffset(250, 40)
		TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = goalSize}):Play()
	end)
	
	ui.Parent = CoreGui
end

createInterface()

if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end
connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
