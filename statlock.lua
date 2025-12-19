--[[
    made by zuka
    
]]

--======================================================================================
-- Services & Framework Initialization
--======================================================================================

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    CoreGui = game:GetService("CoreGui"),
    TweenService = game:GetService("TweenService")
}

local LocalPlayer = Services.Players.LocalPlayer

local Editor = {
    State = {
        UI = nil,
        IsMinimized = false,
        ActiveOverrides = {},
        HeartbeatConnection = nil,
        ToolConnections = {}
    },
    -- [STYLISTIC REFACTOR] - Theme updated to match ZukasAdmin
    Config = {
        WindowTitle = "Zuka's Prop Editor",
        AccentColor = Color3.fromRGB(0, 255, 255),       -- Cyan Accent
        BackgroundColor = Color3.fromRGB(34, 32, 38),   -- Main Background
        HeaderColor = Color3.fromRGB(25, 25, 35),       -- Title Bar Background
        ItemColor = Color3.fromRGB(48, 48, 58),         -- List Item Background
        TextColor = Color3.fromRGB(240, 240, 240),      -- Primary Text
        Font = Enum.Font.Gotham,
        BoldFont = Enum.Font.GothamSemibold,
        MainSize = UDim2.new(0, 340, 0, 450)
    }
}

--======================================================================================
-- Core Override Logic
--======================================================================================

function Editor:ForceProperties()
    if not next(self.State.ActiveOverrides) then
        if self.State.HeartbeatConnection then
            self.State.HeartbeatConnection:Disconnect()
            self.State.HeartbeatConnection = nil
        end
        return
    end

    for name, data in pairs(self.State.ActiveOverrides) do
        if not data.ParentObject or not data.ParentObject.Parent then
            self.State.ActiveOverrides[name] = nil
            continue
        end

        local success, err
        if data.IsAttribute then
            success, err = pcall(function()
                if data.ParentObject:GetAttribute(name) ~= data.Value then
                    data.ParentObject:SetAttribute(name, data.Value)
                end
            end)
        else
            success, err = pcall(function()
                if data.ParentObject[name] ~= data.Value then
                    data.ParentObject[name] = data.Value
                end
            end)
        end

        if not success then
            warn(("[Editor] Failed to force property '%s': %s"):format(name, tostring(err)))
            self.State.ActiveOverrides[name] = nil
        end
    end
end

--======================================================================================
-- UI Population & Management
--======================================================================================

function Editor:Populate()
    local mainFrame = self.State.UI and self.State.UI:FindFirstChild("MainFrame")
    if not mainFrame then return end
    local propertyList = mainFrame:FindFirstChild("PropertyList")
    if not propertyList then return end

    for _, child in ipairs(propertyList:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local layoutCounter = 0

    -- [STYLISTIC REFACTOR] - Updated header styling
    local function addHeader(text)
        layoutCounter += 1
        local header = Instance.new("TextLabel", propertyList)
        header.Name = text .. "Header"
        header.Size = UDim2.new(1, 0, 0, 24)
        header.Text = ("- %s -"):format(text)
        header.TextColor3 = self.Config.AccentColor
        header.Font = self.Config.BoldFont
        header.TextSize = 16
        header.BackgroundTransparency = 1
        header.LayoutOrder = layoutCounter
        return header
    end

    -- 1. Humanoid Properties (Static List)
    addHeader("Humanoid")
    local humanoidProps = {"WalkSpeed", "JumpPower", "JumpHeight", "HipHeight", "MaxHealth", "Health"}
    for _, propName in ipairs(humanoidProps) do
        local success, value = pcall(function() return humanoid[propName] end)
        if success and typeof(value) == "number" then
            layoutCounter += 1
            self:CreateNumberRow(propName, value, false, humanoid, layoutCounter)
        end
    end

    local objectsToScan = {}
    if character then
        objectsToScan["Character"] = character
        objectsToScan["Humanoid"] = humanoid
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then objectsToScan["HumanoidRootPart"] = rootPart end

        for _, descendant in ipairs(character:GetDescendants()) do
            local uniqueName = ("%s (%s)"):format(descendant.Name, descendant.ClassName)
            if not objectsToScan[uniqueName] and (descendant:IsA("BasePart") or descendant:IsA("Tool")) then
                objectsToScan[uniqueName] = descendant
            end
        end
    end
    
    -- 3. Populate Attributes by Object
    for objectName, parentObject in pairs(objectsToScan) do
        if not parentObject or not parentObject.Parent then continue end
        
        local attributes = parentObject:GetAttributes()
        if not next(attributes) then continue end

        local numericAttributes, booleanAttributes = {}, {}
        for name, value in pairs(attributes) do
            if typeof(value) == "number" then
                table.insert(numericAttributes, {Name = name, Value = value})
            elseif typeof(value) == "boolean" then
                table.insert(booleanAttributes, {Name = name, Value = value})
            end
        end

        table.sort(numericAttributes, function(a, b) return a.Name < b.Name end)
        table.sort(booleanAttributes, function(a, b) return a.Name < b.Name end)
        
        addHeader(objectName .. " Attributes")

        for _, data in ipairs(numericAttributes) do
            layoutCounter += 1
            self:CreateNumberRow(data.Name, data.Value, true, parentObject, layoutCounter)
        end
        for _, data in ipairs(booleanAttributes) do
            layoutCounter += 1
            self:CreateBooleanRow(data.Name, data.Value, true, parentObject, layoutCounter)
        end
    end
end

--======================================================================================
-- UI Element Creation & Toggling
--======================================================================================

-- [STYLISTIC REFACTOR] - Reworked row creation to match new theme
function Editor:CreateNumberRow(name, value, isAttribute, parentObject, layoutOrder)
    local C, S = self.Config, self.State
    local propertyList = S.UI.MainFrame.PropertyList
    
    local frame = Instance.new("Frame", propertyList)
    frame.Name, frame.Size, frame.BackgroundColor3, frame.LayoutOrder = name .. "Row", UDim2.new(1, 0, 0, 30), C.ItemColor, layoutOrder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Size, nameLabel.Text, nameLabel.Font, nameLabel.TextSize, nameLabel.TextColor3, nameLabel.TextXAlignment = UDim2.new(0.4, 0, 1, 0), "  " .. name, C.Font, 14, C.TextColor, Enum.TextXAlignment.Left
    
    local valueBox = Instance.new("TextBox", frame)
    valueBox.Size, valueBox.Position, valueBox.BackgroundColor3, valueBox.Font, valueBox.TextSize, valueBox.TextColor3, valueBox.Text, valueBox.ClearTextOnFocus = UDim2.new(0.4, -5, 1, -6), UDim2.new(0.4, 5, 0.5, 0), C.HeaderColor, C.Font, 14, Color3.new(1, 1, 1), tostring(value), false
    valueBox.AnchorPoint = Vector2.new(0, 0.5)
    Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 4)

    local lockButton = Instance.new("TextButton", frame)
    lockButton.Name, lockButton.Size, lockButton.Position, lockButton.Font, lockButton.TextSize, lockButton.TextColor3 = "LockButton", UDim2.new(0.2, -5, 1, -6), UDim2.new(0.8, 5, 0.5, 0), C.BoldFont, 14, Color3.new(1, 1, 1)
    lockButton.AnchorPoint = Vector2.new(0, 0.5)
    Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 4)

    if S.ActiveOverrides[name] then
        lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(40, 140, 80), "LOCKED"
    else
        lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(160, 50, 60), "LOCK"
    end

    lockButton.MouseButton1Click:Connect(function()
        local numValue = tonumber(valueBox.Text)
        if not numValue then return end
        if S.ActiveOverrides[name] then
            S.ActiveOverrides[name] = nil
            lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(160, 50, 60), "LOCK"
        else
            S.ActiveOverrides[name] = { Value = numValue, IsAttribute = isAttribute, ParentObject = parentObject }
            lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(40, 140, 80), "LOCKED"
            if not S.HeartbeatConnection then
                S.HeartbeatConnection = Services.RunService.Heartbeat:Connect(function() self:ForceProperties() end)
            end
        end
    end)
    valueBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newValue = tonumber(valueBox.Text)
            if not newValue then return end
            if isAttribute then parentObject:SetAttribute(name, newValue) else parentObject[name] = newValue end
            if S.ActiveOverrides[name] then S.ActiveOverrides[name].Value = newValue end
            valueBox.Text = tostring(isAttribute and parentObject:GetAttribute(name) or parentObject[name])
        end
    end)
end

function Editor:CreateBooleanRow(name, value, isAttribute, parentObject, layoutOrder)
    local C, S = self.Config, self.State
    local propertyList = S.UI.MainFrame.PropertyList

    local frame = Instance.new("Frame", propertyList)
    frame.Name, frame.Size, frame.BackgroundColor3, frame.LayoutOrder = name .. "Row", UDim2.new(1, 0, 0, 30), C.ItemColor, layoutOrder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Size, nameLabel.Text, nameLabel.Font, nameLabel.TextSize, nameLabel.TextColor3, nameLabel.TextXAlignment = UDim2.new(0.4, 0, 1, 0), "  " .. name, C.Font, 14, C.TextColor, Enum.TextXAlignment.Left

    local valueButton = Instance.new("TextButton", frame)
    valueButton.Size, valueButton.Position, valueButton.Font, valueButton.TextSize, valueButton.TextColor3 = UDim2.new(0.4, -5, 1, -6), UDim2.new(0.4, 5, 0.5, 0), C.BoldFont, 14, Color3.new(1, 1, 1)
    valueButton.AnchorPoint = Vector2.new(0, 0.5)
    Instance.new("UICorner", valueButton).CornerRadius = UDim.new(0, 4)
    
    local lockButton = Instance.new("TextButton", frame)
    lockButton.Name, lockButton.Size, lockButton.Position, lockButton.Font, lockButton.TextSize, lockButton.TextColor3 = "LockButton", UDim2.new(0.2, -5, 1, -6), UDim2.new(0.8, 5, 0.5, 0), C.BoldFont, 14, Color3.new(1, 1, 1)
    lockButton.AnchorPoint = Vector2.new(0, 0.5)
    Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 4)
    
    local currentValue = value
    local function updateValueButton()
        valueButton.Text = tostring(currentValue):upper()
        valueButton.BackgroundColor3 = currentValue and Color3.fromRGB(70, 120, 90) or Color3.fromRGB(120, 70, 70)
        if isAttribute then parentObject:SetAttribute(name, currentValue) end
        if S.ActiveOverrides[name] then S.ActiveOverrides[name].Value = currentValue end
    end
    updateValueButton()
    
    if S.ActiveOverrides[name] then lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(40, 140, 80), "LOCKED"
    else lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(160, 50, 60), "LOCK" end
    
    valueButton.MouseButton1Click:Connect(function() currentValue = not currentValue; updateValueButton() end)
    lockButton.MouseButton1Click:Connect(function()
        if S.ActiveOverrides[name] then
            S.ActiveOverrides[name] = nil; lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(160, 50, 60), "LOCK"
        else
            S.ActiveOverrides[name] = { Value = currentValue, IsAttribute = isAttribute, ParentObject = parentObject }
            lockButton.BackgroundColor3, lockButton.Text = Color3.fromRGB(40, 140, 80), "LOCKED"
            if not S.HeartbeatConnection then S.HeartbeatConnection = Services.RunService.Heartbeat:Connect(function() self:ForceProperties() end) end
        end
    end)
end

function Editor:ToggleMinimize()
    local S, C = self.State, self.Config
    S.IsMinimized = not S.IsMinimized
    
    local mainFrame = S.UI.MainFrame
    local propertyList = mainFrame.PropertyList
    local minimizeButton = mainFrame.TitleLabel.MinimizeButton

    local targetSize = S.IsMinimized and UDim2.new(C.MainSize.X.Scale, C.MainSize.X.Offset, 0, 30) or C.MainSize
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    Services.TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
    propertyList.Visible = not S.IsMinimized
    minimizeButton.Text = S.IsMinimized and "+" or "_"
end

function Editor:CreateUI()
    if self.State.UI then return end
    local C, S = self.Config, self.State

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name, screenGui.ResetOnSpawn, screenGui.ZIndexBehavior, screenGui.Parent = "CallumHumanoidEditor", false, Enum.ZIndexBehavior.Global, Services.CoreGui
    S.UI = screenGui

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name, mainFrame.Size, mainFrame.Position, mainFrame.BackgroundColor3, mainFrame.Draggable, mainFrame.Active = "MainFrame", C.MainSize, UDim2.new(0.5, -C.MainSize.X.Offset / 2, 0.5, -C.MainSize.Y.Offset / 2), C.BackgroundColor, true, true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    -- [STYLISTIC ADDITION] - Add pulsating glowing border
    local uiStroke = Instance.new("UIStroke", mainFrame)
    uiStroke.Color = C.AccentColor
    uiStroke.Thickness = 1.5
    uiStroke.Transparency = 0.4
    
    local glowConnection = Services.RunService.RenderStepped:Connect(function()
        if not (uiStroke and uiStroke.Parent) then
            glowConnection:Disconnect()
            return
        end
        local sine = math.sin(os.clock() * 5)
        uiStroke.Thickness = 1.5 + (sine * 0.5)
        uiStroke.Transparency = 0.4 + (sine * 0.2)
    end)
    screenGui.Destroying:Connect(function() glowConnection:Disconnect() end)

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Name, titleLabel.Size, titleLabel.BackgroundColor3, titleLabel.Text, titleLabel.Font, titleLabel.TextSize, titleLabel.TextColor3 = "TitleLabel", UDim2.new(1, 0, 0, 30), C.HeaderColor, "  " .. C.WindowTitle, C.BoldFont, 16, C.TextColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local propertyList = Instance.new("ScrollingFrame", mainFrame)
    propertyList.Name, propertyList.Size, propertyList.Position, propertyList.BackgroundTransparency, propertyList.AutomaticCanvasSize, propertyList.ScrollBarImageColor3, propertyList.BorderSizePixel, propertyList.ScrollBarThickness = "PropertyList", UDim2.new(1, -10, 1, -35), UDim2.new(0.5, 0, 0, 30), 1, Enum.AutomaticSize.Y, C.AccentColor, 0, 6
    propertyList.AnchorPoint = Vector2.new(0.5, 0)
    
    local listLayout = Instance.new("UIListLayout", propertyList)
    listLayout.Padding, listLayout.SortOrder, listLayout.HorizontalAlignment = UDim.new(0, 5), Enum.SortOrder.LayoutOrder, Enum.HorizontalAlignment.Center

    local function createTitleButton(name, text, position, onClick)
        local button = Instance.new("TextButton", titleLabel)
        button.Name, button.Size, button.Position, button.BackgroundTransparency, button.Text, button.Font, button.TextSize, button.TextColor3 = name, UDim2.new(0, 24, 0, 24), UDim2.new(1, position, 0.5, 0), 1, text, C.BoldFont, 20, C.TextColor
        button.AnchorPoint = Vector2.new(1, 0.5)
        button.MouseButton1Click:Connect(onClick)
        return button
    end

    createTitleButton("CloseButton", "X", -15, function() screenGui.Enabled = false end)
    createTitleButton("UnlockAllButton", "U", -45, function() S.ActiveOverrides = {}; self:Populate() end)
    createTitleButton("RefreshButton", "R", -75, function() self:Populate() end)
    createTitleButton("MinimizeButton", "_", -105, function() self:ToggleMinimize() end)
end

--======================================================================================
-- Event Connections & Initialization
--======================================================================================

function Editor:OnCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    for _, conn in pairs(self.State.ToolConnections) do conn:Disconnect() end
    self.State.ToolConnections = {}
    if self.State.UI and self.State.UI.Enabled then
        task.wait(0.5); self:Populate()
    end
    self.State.ToolConnections.ChildAdded = character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and self.State.UI and self.State.UI.Enabled then
            task.wait(0.1); self:Populate()
        end
    end)
    self.State.ToolConnections.ChildRemoved = character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and self.State.UI and self.State.UI.Enabled then
            self:Populate()
        end
    end)
end

function Editor:ToggleUI()
    if not self.State.UI then return end
    self.State.UI.Enabled = not self.State.UI.Enabled
    print(("[Editor] UI Toggled: " .. (self.State.UI.Enabled and "Visible" or "Hidden")))
    if self.State.UI.Enabled then self:Populate() end
end

function Editor:Init()
    self:CreateUI()
    self.State.UI.Enabled = false
    LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
    if LocalPlayer.Character then self:OnCharacterAdded(LocalPlayer.Character) end
    LocalPlayer.Chatted:Connect(function(msg)
        local lowerMsg = msg:lower()
        if lowerMsg == "/stats" or lowerMsg == "/editstats" then self:ToggleUI() end
    end)
    self:ToggleUI()
end

xpcall(function() Editor:Init() end, function(err) warn("An unexpected error occurred in the Editor script:", err) end)
