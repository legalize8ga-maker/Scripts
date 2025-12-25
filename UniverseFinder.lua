local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local AssetService = game:GetService("AssetService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local THEME = {
	Background = Color3.fromRGB(34, 32, 38),
	Accent = Color3.fromRGB(255, 105, 180),
	Title = Color3.fromRGB(255, 182, 193),
	Text = Color3.fromRGB(240, 240, 240),
	Interactive = Color3.fromRGB(20, 20, 25),
	InteractiveHover = Color3.fromRGB(45, 42, 50),
	Destructive = Color3.fromRGB(200, 70, 90)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniverseViewer_Radiant"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = THEME.Background
mainFrame.BackgroundTransparency = 0.1
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.fromOffset(600, 500)
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = THEME.Accent
mainStroke.Transparency = 0.3

RunService.RenderStepped:Connect(function()
	if not mainStroke.Parent then return end
	local sine = math.sin(os.clock() * 4)
	mainStroke.Thickness = 2 + (sine * 0.5)
	mainStroke.Transparency = 0.3 + (sine * 0.2)
end)

local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = THEME.Background
titleBar.BackgroundTransparency = 1
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Font = Enum.Font.GothamSemibold
titleBar.Text = "Universe Viewer"
titleBar.TextColor3 = THEME.Title
titleBar.TextSize = 20
titleBar.ZIndex = 2

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.Size = UDim2.fromOffset(25, 25)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.Position = UDim2.new(1, -10, 0.5, 0)
closeButton.BackgroundTransparency = 1
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = THEME.Text
closeButton.TextSize = 20

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Parent = mainFrame
searchBox.BackgroundColor3 = THEME.Interactive
searchBox.Position = UDim2.new(0, 12, 0, 50)
searchBox.Size = UDim2.new(1, -24, 0, 36)
searchBox.Font = Enum.Font.Gotham
searchBox.PlaceholderText = "Search by Name or ID"
searchBox.Text = ""
searchBox.TextColor3 = THEME.Text
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
local searchPadding = Instance.new("UIPadding", searchBox)
searchPadding.PaddingLeft = UDim.new(0, 12)
searchPadding.PaddingRight = UDim.new(0, 12)
local searchCorner = Instance.new("UICorner", searchBox)
searchCorner.CornerRadius = UDim.new(0, 8)

local listContainer = Instance.new("Frame")
listContainer.Name = "ListContainer"
listContainer.Parent = mainFrame
listContainer.BackgroundColor3 = THEME.Interactive
listContainer.Position = UDim2.new(0, 12, 0, 98)
listContainer.Size = UDim2.new(1, -24, 1, -110)
listContainer.BackgroundTransparency = 0.8
local listContainerCorner = Instance.new("UICorner", listContainer)
listContainerCorner.CornerRadius = UDim.new(0, 10)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "List"
scrollingFrame.Parent = listContainer
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Position = UDim2.fromOffset(8, 8)
scrollingFrame.Size = UDim2.new(1, -16, 1, -16)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = THEME.Accent
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local listLayout = Instance.new("UIListLayout", scrollingFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = listContainer
statusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.fromScale(1, 1)
statusLabel.Position = UDim2.fromScale(0.5, 0.5)
statusLabel.Text = ""
statusLabel.TextColor3 = THEME.Text
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 22
statusLabel.Visible = false

local rowTemplate: Frame = Instance.new("Frame")
rowTemplate.Name = "RowTemplate"
rowTemplate.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
rowTemplate.Size = UDim2.new(1, 0, 0, 58)
rowTemplate.ClipsDescendants = true
local rowCorner = Instance.new("UICorner", rowTemplate)
rowCorner.CornerRadius = UDim.new(0, 8)
local rowText = Instance.new("TextLabel", rowTemplate)
rowText.Name = "PlaceName"
rowText.BackgroundTransparency = 1
rowText.Position = UDim2.new(0, 10, 0, 0)
rowText.Size = UDim2.new(0.5, -10, 1, 0)
rowText.Font = Enum.Font.Gotham
rowText.Text = "Name (ID)"
rowText.TextColor3 = THEME.Text
rowText.TextSize = 16
rowText.TextXAlignment = Enum.TextXAlignment.Left
rowText.TextTruncate = Enum.TextTruncate.AtEnd
local buttonContainer = Instance.new("Frame", rowTemplate)
buttonContainer.Name = "ButtonContainer"
buttonContainer.BackgroundTransparency = 1
buttonContainer.Position = UDim2.new(0.5, 0, 0, 0)
buttonContainer.Size = UDim2.new(0.5, -8, 1, 0)
local buttonLayout = Instance.new("UIListLayout", buttonContainer)
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 8)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local teleportButton = Instance.new("TextButton", buttonContainer)
teleportButton.Name = "TeleportButton"
teleportButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
teleportButton.Size = UDim2.fromOffset(100, 26)
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextSize = 15
local tpCorner = Instance.new("UICorner", teleportButton)
tpCorner.CornerRadius = UDim.new(0, 6)
local copyIdButton = teleportButton:Clone()
copyIdButton.Name = "CopyIdButton"
copyIdButton.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
copyIdButton.Text = "Copy ID"
copyIdButton.Parent = buttonContainer

local allRows = {}
local isFetching = false

local function drag(uiObject: GuiObject, dragHandle: GuiObject)
	local isDragging = false
	local dragStart, startPosition
	dragHandle.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStart = input.Position
			startPosition = uiObject.Position
			local inputEndedConn
			inputEndedConn = UserInputService.InputEnded:Connect(function(endInput: InputObject)
				if endInput.UserInputType == input.UserInputType then
					isDragging = false
					inputEndedConn:Disconnect()
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input: InputObject)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
			local delta = input.Position - dragStart
			uiObject.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end)
	uiObject.Active = true
end

local function notify(text: string, duration: number)
	statusLabel.Text = text
	statusLabel.Visible = true
	task.delay(duration or 2, function()
		if statusLabel.Text == text then
			statusLabel.Visible = false
		end
	end)
end

local function clearList()
	for _, row in ipairs(allRows) do
		row.RowFrame:Destroy()
	end
	table.clear(allRows)
end

local function filterAndSortList()
	local query = searchBox.Text:lower()
	local visibleRowCount = 0
	for _, rowData in ipairs(allRows) do
		local nameMatch = rowData.Name:lower():find(query, 1, true)
		local idMatch = tostring(rowData.Id):find(query, 1, true)
		local isVisible = (query == "" or nameMatch or idMatch)
		rowData.RowFrame.Visible = isVisible
		if isVisible then
			visibleRowCount += 1
		end
	end
	statusLabel.Text = "No places found."
	statusLabel.Visible = (visibleRowCount == 0)
end

local function createRow(placeData: any)
	local rowFrame = rowTemplate:Clone()
	rowFrame.Parent = scrollingFrame

	local data = {
		RowFrame = rowFrame,
		Name = placeData.Name,
		Id = placeData.PlaceId
	}
	table.insert(allRows, data)

	rowFrame.PlaceName.Text = string.format("%s (%d)", placeData.Name, placeData.PlaceId)

	local tpBtn = rowFrame.ButtonContainer.TeleportButton
	local cpBtn = rowFrame.ButtonContainer.CopyIdButton

	if placeData.PlaceId == game.PlaceId then
		tpBtn.Text = "Rejoin"
		tpBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
		tpBtn.TextColor3 = THEME.Background
	end

	tpBtn.MouseButton1Click:Connect(function()
		local success, err = pcall(TeleportService.Teleport, TeleportService, placeData.PlaceId, LocalPlayer)
		if not success then
			notify("Teleport failed: " .. tostring(err), 4)
		end
	end)
	cpBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(tostring(placeData.PlaceId))
			notify("Copied ID: " .. placeData.PlaceId, 2)
		else
			notify("Clipboard not available.", 3)
		end
	end)
end

local function fetchUniverses()
	if isFetching then return end
	isFetching = true
	clearList()
	statusLabel.Text = "Loading..."
	statusLabel.Visible = true

	task.spawn(function()
		local success, assetPage
		local retries = 0
		repeat
			success, assetPage = pcall(AssetService.GetGamePlacesAsync, AssetService)
			if not success then
				retries += 1
				task.wait(0.5)
			end
		until success or retries > 5

		if not success then
			statusLabel.Text = "Failed to load places."
			isFetching = false
			return
		end

		local places = {}
		while true do
			for _, place in ipairs(assetPage:GetCurrentPage()) do
				table.insert(places, place)
			end
			if assetPage.IsFinished then break end
			assetPage:AdvanceToNextPageAsync()
		end

		statusLabel.Visible = false

		for _, placeData in ipairs(places) do
			createRow(placeData)
		end

		filterAndSortList()
		isFetching = false
	end)
end

drag(mainFrame, titleBar)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
searchBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then filterAndSortList() end
end)
searchBox:GetPropertyChangedSignal("Text"):Connect(filterAndSortList)

fetchUniverses()
