local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // Constants
local ATTRIBUTE_OG_SIZE = "Callum_OriginalSize"
local SELECTION_BOX_NAME = "Callum_ReachSelectionBox"
local LocalPlayer = Players.LocalPlayer

-- // State Variables
local connections = {}
local activeTool: Tool? = nil
local modifiedPart: BasePart? = nil
local persistentToolName: string? = nil
local persistentPartName: string? = nil
local currentReachSize: number = 20
local currentReachType: "directional" | "box" = "directional"
local uiElements = {}

-- // Core Functions

--- Updates a part's size and visuals or reverts it to its original state.
--- @param part BasePart The part to modify.
--- @param newSize number? The new size to apply. If nil, reverts the part.
--- @param reachType "directional" | "box"? The type of modification.
local function updatePartModification(part: BasePart, newSize: number?, reachType: string?)
	if not part or not part.Parent then return end

	local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)

	-- Revert logic
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

	-- Apply logic
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
	
	selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
	
	if reachType == "box" then
		part.Size = Vector3.one * newSize
	else -- Directional
		part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize)
	end
	part.Massless = true
end

--- Clears and repopulates the part selection UI with parts from the active tool.
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
	
	-- Add a UIListLayout for clean organization
	local listLayout = Instance.new("UIListLayout", scroll)
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	for _, part in ipairs(parts) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Position = UDim2.fromScale(0.5, 0)
		btn.AnchorPoint = Vector2.new(0.5, 0)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
		btn.TextColor3 = Color3.fromRGB(220, 220, 230)
		btn.Font = Enum.Font.Code
		btn.Text = part.Name
		btn.TextSize = 14
		btn.Parent = scroll
		
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

		btn.MouseButton1Click:Connect(function()
			if not part or not part.Parent or not activeTool then
				print("Reach Error: The selected part or tool no longer exists.")
				return
			end
			
			-- Set persistence
			persistentToolName = activeTool.Name
			persistentPartName = part.Name
			
			-- Revert old part if a different one was already modified
			if modifiedPart and modifiedPart ~= part then
				updatePartModification(modifiedPart, nil, nil)
			end
			
			modifiedPart = part
			updatePartModification(part, currentReachSize, currentReachType)
			print(string.format("Reach set for '%s' on tool '%s'.", part.Name, activeTool.Name))
		end)
	end
end

--- Resets all reach modifications and clears persistent settings.
local function resetReach()
	if not modifiedPart and not persistentToolName then
		print("Reach is not active and no part is set.")
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
	print("Tool reach has been fully reset.")
end

--- Handles the logic when a tool is equipped.
--- @param tool Tool The tool that was equipped.
local function onToolEquipped(tool: Tool)
	activeTool = tool
	populatePartSelector()
	
	if connections.Unequipped then connections.Unequipped:Disconnect() end
	connections.Unequipped = tool.Unequipped:Connect(function()
		activeTool = nil
		populatePartSelector() -- Clear the list
	end)
end

--- Handles character setup on spawn/respawn.
--- @param character Model The player's character model.
local function onCharacterAdded(character: Model)
	-- Re-apply persistent reach if it exists
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

		reapplyModification(character:FindFirstChild(persistentToolName)) -- Check if already equipped
		character.ChildAdded:Connect(function(child) -- Check when equipped later
			if child:IsA("Tool") then reapplyModification(child) end
		end)
	end
	
	-- Listen for new tool equips
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then onToolEquipped(child) end
	end)
	
	-- Check for a tool that might already be equipped on spawn
	local firstEquippedTool = character:FindFirstChildOfClass("Tool")
	if firstEquippedTool then onToolEquipped(firstEquippedTool) end
end

--- Creates and manages the user interface.
local function createInterface()
	local ui = Instance.new("ScreenGui")
	ui.Name = "ReachController_Callum"
	ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ui.ResetOnSpawn = false
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(250, 320)
	mainFrame.Position = UDim2.fromScale(0, 0) -- Top-left corner
	mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = ui
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
	
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	
	local title = Instance.new("TextLabel", titleBar)
	title.Size = UDim2.new(1, -30, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamSemibold
	title.Text = "Reach Controller"
	title.TextColor3 = Color3.fromRGB(200, 220, 255)
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, 0, 1, -30)
	contentFrame.Position = UDim2.new(0, 0, 0, 30)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame
	
	-- Toggle/Minimize Button
	local toggleButton = Instance.new("TextButton", titleBar)
	toggleButton.Size = UDim2.fromOffset(20, 20)
	toggleButton.Position = UDim2.new(1, -10, 0.5, 0)
	toggleButton.AnchorPoint = Vector2.new(1, 0.5)
	toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
	toggleButton.Text = "-"
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)
	
	-- Drag functionality
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local dragStart = input.Position
			local startPos = mainFrame.Position
			local moveConn = UserInputService.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = moveInput.Position - dragStart
					mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end)
			local endConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConn:Disconnect()
					endConn:Disconnect()
				end
			end)
		end
	end)

	-- Input section
	local sizeLabel = Instance.new("TextLabel", contentFrame)
	sizeLabel.Size = UDim2.fromOffset(80, 20)
	sizeLabel.Position = UDim2.fromOffset(10, 10)
	sizeLabel.BackgroundTransparency = 1
	sizeLabel.Font = Enum.Font.Gotham
	sizeLabel.Text = "Reach Size:"
	sizeLabel.TextColor3 = Color3.new(1, 1, 1)
	sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local sizeInput = Instance.new("TextBox", contentFrame)
	sizeInput.Size = UDim2.fromOffset(130, 30)
	sizeInput.Position = UDim2.fromOffset(110, 5)
	sizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	sizeInput.Font = Enum.Font.Code
	sizeInput.Text = tostring(currentReachSize)
	sizeInput.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 4)
	
	local directionalBtn = Instance.new("TextButton", contentFrame)
	directionalBtn.Size = UDim2.fromOffset(110, 30)
	directionalBtn.Position = UDim2.fromOffset(10, 40)
	directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100) -- Active color
	directionalBtn.Font = Enum.Font.GothamSemibold
	directionalBtn.Text = "Directional"
	directionalBtn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", directionalBtn).CornerRadius = UDim.new(0, 4)
	
	local boxBtn = Instance.new("TextButton", contentFrame)
	boxBtn.Size = UDim2.fromOffset(110, 30)
	boxBtn.Position = UDim2.fromOffset(130, 40)
	boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) -- Inactive color
	boxBtn.Font = Enum.Font.GothamSemibold
	boxBtn.Text = "Box"
	boxBtn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", boxBtn).CornerRadius = UDim.new(0, 4)

	local partsLabel = Instance.new("TextLabel", contentFrame)
	partsLabel.Size = UDim2.fromOffset(80, 20)
	partsLabel.Position = UDim2.fromOffset(10, 75)
	partsLabel.BackgroundTransparency = 1
	partsLabel.Font = Enum.Font.Gotham
	partsLabel.Text = "Tool Parts:"
	partsLabel.TextColor3 = Color3.new(1, 1, 1)
	partsLabel.TextXAlignment = Enum.TextXAlignment.Left

	local scroll = Instance.new("ScrollingFrame", contentFrame)
	scroll.Size = UDim2.new(1, -20, 1, -140)
	scroll.Position = UDim2.fromOffset(10, 100)
	scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	uiElements.ScrollingFrame = scroll
	
	local resetBtn = Instance.new("TextButton", contentFrame)
	resetBtn.Size = UDim2.new(1, -20, 0, 30)
	resetBtn.Position = UDim2.new(0.5, 0, 1, -10)
	resetBtn.AnchorPoint = Vector2.new(0.5, 1)
	resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.Text = "Reset Reach"
	resetBtn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 4)

	-- UI Logic
	sizeInput.FocusLost:Connect(function(enterPressed)
		local num = tonumber(sizeInput.Text)
		if num and num > 0 then
			currentReachSize = num
		else
			sizeInput.Text = tostring(currentReachSize) -- Revert if invalid
		end
	end)

	directionalBtn.MouseButton1Click:Connect(function()
		currentReachType = "directional"
		directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
		boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	end)
	
	boxBtn.MouseButton1Click:Connect(function()
		currentReachType = "box"
		boxBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
		directionalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	end)
	
	resetBtn.MouseButton1Click:Connect(resetReach)
	
	toggleButton.MouseButton1Click:Connect(function()
		contentFrame.Visible = not contentFrame.Visible
		toggleButton.Text = contentFrame.Visible and "-" or "+"
		mainFrame.Size = contentFrame.Visible and UDim2.fromOffset(250, 320) or UDim2.fromOffset(250, 30)
	end)
	
	ui.Parent = CoreGui
end

-- // Main Execution Thread
createInterface()

if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end
connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

print("Callum's Standalone Reach Controller has been initialized.")
