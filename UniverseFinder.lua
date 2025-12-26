-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- UI Theme
local THEME = {
	Background = Color3.fromRGB(34, 32, 38),
	Accent = Color3.fromRGB(255, 105, 180),
	Title = Color3.fromRGB(255, 182, 193),
	Text = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(180, 180, 190),
	Interactive = Color3.fromRGB(28, 26, 32),
	Destructive = Color3.fromRGB(200, 70, 90)
}

-- Main UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerBrowser_Radiant"
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
mainFrame.Size = UDim2.fromOffset(600, 400)
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = THEME.Accent
mainStroke.Transparency = 0.3

local glowConnection = RunService.RenderStepped:Connect(function()
	if not mainStroke.Parent then glowConnection:Disconnect() return end
	local sine = math.sin(os.clock() * 4)
	mainStroke.Thickness = 2 + (sine * 0.5)
	mainStroke.Transparency = 0.3 + (sine * 0.2)
end)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = THEME.Interactive
titleBar.Size = UDim2.new(1, 0, 0, 35)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.fromOffset(15, 0)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.Text = "Active Server Browser"
titleLabel.TextColor3 = THEME.Title
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(35, 35)
closeButton.Position = UDim2.new(1, 0, 0, 0)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = THEME.Destructive
closeButton.BackgroundTransparency = 0.4
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = THEME.Text
closeButton.TextSize = 20

local listContainer = Instance.new("Frame")
listContainer.Name = "ListContainer"
listContainer.Parent = mainFrame
listContainer.BackgroundColor3 = THEME.Interactive
listContainer.Position = UDim2.new(0.5, 0, 0, 45)
listContainer.AnchorPoint = Vector2.new(0.5, 0)
listContainer.Size = UDim2.new(1, -20, 1, -55)
Instance.new("UICorner", listContainer).CornerRadius = UDim.new(0, 8)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "List"
scrollingFrame.Parent = listContainer
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Size = UDim2.fromScale(1, 1)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = THEME.Accent
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", scrollingFrame).Padding = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout", scrollingFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

local statusLabel = Instance.new("TextLabel", listContainer)
statusLabel.Name = "StatusLabel"
statusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.fromScale(1, 1)
statusLabel.Position = UDim2.fromScale(0.5, 0.5)
statusLabel.Text = "Fetching servers..."
statusLabel.TextColor3 = THEME.TextSecondary
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 20
statusLabel.Visible = false

local rowTemplate: Frame = Instance.new("Frame")
rowTemplate.Name = "RowTemplate"
rowTemplate.BackgroundColor3 = THEME.Background
rowTemplate.Size = UDim2.new(1, 0, 0, 40)
rowTemplate.ClipsDescendants = true
Instance.new("UICorner", rowTemplate).CornerRadius = UDim.new(0, 6)

local playerInfo = Instance.new("TextLabel", rowTemplate); playerInfo.Name = "PlayerInfo"; playerInfo.BackgroundTransparency = 1; playerInfo.Position = UDim2.new(0, 10, 0, 0); playerInfo.Size = UDim2.new(0.4, 0, 1, 0); playerInfo.Font = Enum.Font.GothamSemibold; playerInfo.Text = "Players: 0/0"; playerInfo.TextColor3 = THEME.Text; playerInfo.TextSize = 16; playerInfo.TextXAlignment = Enum.TextXAlignment.Left
local pingInfo = Instance.new("TextLabel", rowTemplate); pingInfo.Name = "PingInfo"; pingInfo.BackgroundTransparency = 1; pingInfo.Position = UDim2.new(0.4, 10, 0, 0); pingInfo.Size = UDim2.new(0.3, 0, 1, 0); pingInfo.Font = Enum.Font.Code; pingInfo.Text = "Ping: 0ms"; pingInfo.TextColor3 = THEME.TextSecondary; pingInfo.TextSize = 15; pingInfo.TextXAlignment = Enum.TextXAlignment.Left

local buttonContainer = Instance.new("Frame", rowTemplate); buttonContainer.Name = "ButtonContainer"; buttonContainer.BackgroundTransparency = 1; buttonContainer.Position = UDim2.new(1, -125, 0.5, 0); buttonContainer.AnchorPoint = Vector2.new(1, 0.5); buttonContainer.Size = UDim2.fromOffset(120, 40)
local buttonLayout = Instance.new("UIListLayout", buttonContainer); buttonLayout.FillDirection = Enum.FillDirection.Horizontal; buttonLayout.Padding = UDim.new(0, 8); buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local teleportButton = Instance.new("TextButton", buttonContainer); teleportButton.Name = "TeleportButton"; teleportButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255); teleportButton.Size = UDim2.fromOffset(120, 28); teleportButton.Font = Enum.Font.GothamSemibold; teleportButton.Text = "Join Server"; teleportButton.TextColor3 = THEME.Text; teleportButton.TextSize = 14
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 6)

local allServers = {}

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

local function clearList()
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	table.clear(allServers)
end

local function createRow(serverData: {})
	local rowFrame = rowTemplate:Clone()
	
	rowFrame.PlayerInfo.Text = string.format("Players: %d/%d", serverData.playing, serverData.maxPlayers)
	rowFrame.PingInfo.Text = string.format("Ping: %dms", serverData.ping)

	local tpBtn = rowFrame.ButtonContainer.TeleportButton
	if serverData.id == game.JobId then
		tpBtn.Text = "Current"
		tpBtn.BackgroundColor3 = THEME.Accent
		tpBtn.TextColor3 = THEME.Background
		tpBtn.AutoButtonColor = false
	else
		tpBtn.MouseButton1Click:Connect(function()
			local success, err = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, serverData.id, LocalPlayer)
			if not success then
				statusLabel.Text = "Teleport failed: " .. tostring(err)
                statusLabel.Visible = true
			end
		end)
	end
    
    rowFrame.Parent = scrollingFrame
	table.insert(allServers, {
		Frame = rowFrame,
		Data = serverData
	})
end

local function fetchServerList()
	if isFetching then return end
	isFetching = true
	clearList()
	statusLabel.Text = "Fetching servers..."
	statusLabel.Visible = true

	task.spawn(function()
		local allServerData = {}
		local nextPageCursor = ""
		local attempts = 0
		
		repeat
			local requestUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=100&cursor=%s", game.PlaceId, nextPageCursor)
			
			local success, response = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(requestUrl))
			end)

			if success and response and response.data then
				for _, server in ipairs(response.data) do
					table.insert(allServerData, server)
				end
				nextPageCursor = response.nextPageCursor
			else
				attempts += 1
				task.wait(0.5)
			end
		until not nextPageCursor or attempts >= 5
        
        statusLabel.Visible = false

		if #allServerData == 0 then
			statusLabel.Text = "No active servers found."
			statusLabel.Visible = true
		else
            table.sort(allServerData, function(a, b) return a.playing > b.playing end)
			for _, serverData in ipairs(allServerData) do
				createRow(serverData)
			end
		end

		isFetching = false
	end)
end

drag(mainFrame, titleBar)
closeButton.MouseButton1Click:Connect(function() 
    glowConnection:Disconnect()
    screenGui:Destroy() 
end)

fetchServerList()
