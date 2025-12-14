--// Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Player & Mouse
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse() -- [FIX] Mouse object must be retrieved from the player.

--// Globals / Placeholders from original environment
local function DoNotif(message, duration)
    print(string.format("[iBTools Notification] %s (Duration: %d)", message, duration or 3))
end

-- Protects the UI from being deleted by anti-exploit scripts.
local function NaProtectUI(gui)
    gui.Parent = CoreGui
end

--// State Management
local State = {
    IsActive = false,
    UI = nil,
    Highlight = nil,
    Connections = {},
    History = {},
    SaveHistory = {},
    CurrentPart = nil,
    CurrentMode = "delete" -- Modes: delete, anchor, collide
}

--// Forward Declare Functions
local Disable, CreateMainPanel

--============================================================================--
--// CORE LOGIC
--============================================================================--

-- Formats a Vector3 into a constructor string for exporting.
local function formatVectorString(vec)
    return string.format("Vector3.new(%.3f, %.3f, %.3f)", vec.X, vec.Y, vec.Z)
end

-- Updates the status label on the UI.
local function updateStatus(part)
    if not State.UI then return end
    
    local statusLabel = State.UI:FindFirstChild("Panel", true) and State.UI.Panel:FindFirstChild("Status")
    if not statusLabel then return end
    
    local targetText = "none"
    if part then
        targetText = part:GetFullName()
    end
    statusLabel.Text = string.format("Mode: %s | Target: %s", State.CurrentMode:upper(), targetText)
end

-- Sets the current target part and updates the highlight adornee.
local function setTarget(part)
    if part and not part:IsA("BasePart") then
        part = nil
    end
    
    State.CurrentPart = part
    if State.Highlight then
        State.Highlight.Adornee = part
    end
    updateStatus(part)
end

-- Handlers for each tool mode (Delete, Anchor, Collide).
local modeHandlers = {
    delete = function(part)
        if part:IsDescendantOf(LocalPlayer.Character) then
            DoNotif("Cannot delete character parts.", 2)
            return
        end
        table.insert(State.History, { part = part, parent = part.Parent, cframe = part.CFrame })
        table.insert(State.SaveHistory, { name = part.Name, position = part.Position })
        
        part.Parent = nil 
        
        setTarget(nil)
        DoNotif("Deleted '" .. part.Name .. "'", 2)
    end,
    anchor = function(part)
        part.Anchored = not part.Anchored
        updateStatus(part)
        DoNotif(string.format("'%s' anchor set to %s", part.Name, tostring(part.Anchored)), 2)
    end,
    collide = function(part)
        part.CanCollide = not part.CanCollide
        updateStatus(part)
        DoNotif(string.format("'%s' CanCollide set to %s", part.Name, tostring(part.CanCollide)), 2)
    end
}

-- Handlers for UI actions (changing modes, undoing, exporting).
local uiActions = {
    setMode = function(mode)
        State.CurrentMode = mode
        updateStatus(State.CurrentPart)
    end,
    undo = function()
        local lastAction = table.remove(State.History)
        if lastAction then
            lastAction.part.Parent = lastAction.parent
            pcall(function() lastAction.part.CFrame = lastAction.cframe end)
            setTarget(lastAction.part)
            DoNotif("Restored '" .. lastAction.part.Name .. "'", 2)
        else
            DoNotif("Nothing to undo.", 2)
        end
    end,
    copy = function()
        if #State.SaveHistory == 0 then
            return DoNotif("No deleted parts to export.", 3)
        end
        
        local lines = {}
        for _, data in ipairs(State.SaveHistory) do
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
            DoNotif("Copied delete script to clipboard.", 3)
        else
            DoNotif("setclipboard function not available.", 3)
        end
    end
}

--============================================================================--
--// UI CREATION & MANAGEMENT
--============================================================================--

-- Cleanup function to destroy UI and disconnect events.
function Disable()
    if not State.IsActive then return end

    if State.UI then
        State.UI:Destroy()
    end
    if State.Highlight then
        State.Highlight:Destroy()
    end
    
    for _, conn in ipairs(State.Connections) do
        conn:Disconnect()
    end
    
    State.IsActive = false
    State.UI = nil
    State.Highlight = nil
    State.CurrentPart = nil
    table.clear(State.Connections)
    table.clear(State.History)
    table.clear(State.SaveHistory)
    
    DoNotif("iBTools deactivated.", 3)
end

-- Creates the main draggable UI panel.
function CreateMainPanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = "iBToolsUI"
    gui.ResetOnSpawn = false
    NaProtectUI(gui)
    State.UI = gui

    local panel = Instance.new("Frame", gui)
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, 240, 0, 260)
    panel.Position = UDim2.new(0.05, 0, 0.4, 0)
    panel.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

    local header = Instance.new("Frame", panel)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    header.Active = true
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
    local mask = Instance.new("UIStroke", header)
    mask.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    mask.Color = header.BackgroundColor3
    mask.Thickness = 4

    local title = Instance.new("TextLabel", header)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "iB Tools"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", panel)
    status.Name = "Status"
    status.BackgroundTransparency = 1
    status.Size = UDim2.new(1, -24, 0, 20)
    status.Position = UDim2.new(0, 12, 0, 40)
    status.Font = Enum.Font.Code
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Text = "Mode: DELETE | Target: none"

    local buttonHolder = Instance.new("Frame", panel)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.Size = UDim2.new(1, -24, 1, -72)
    buttonHolder.Position = UDim2.new(0, 12, 0, 68)
    
    local layout = Instance.new("UIListLayout", buttonHolder)
    layout.Padding = UDim.new(0, 6)

    local modeButtons = {}
    local function createButton(text)
        local button = Instance.new("TextButton", buttonHolder)
        button.Name = text
        button.Size = UDim2.new(1, 0, 0, 32)
        button.Font = Enum.Font.GothamSemibold
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 14
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
        return button
    end
    
    local function refreshModeButtons()
        for mode, button in pairs(modeButtons) do
            button.BackgroundColor3 = (State.CurrentMode == mode and Color3.fromRGB(80, 110, 255) or Color3.fromRGB(52, 52, 52))
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

    createButton("Undo Last Action").MouseButton1Click:Connect(uiActions.undo)
    createButton("Copy Delete Script").MouseButton1Click:Connect(uiActions.copy)

    local function makeDraggable(frame, dragPart)
        local dragging = false
        local dragStart = Vector2.new(0, 0)
        local frameStart = UDim2.new(0, 0, 0, 0)

        dragPart.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                frameStart = frame.Position
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
                frame.Position = UDim2.new(
                    frameStart.X.Scale,
                    frameStart.X.Offset + delta.X,
                    frameStart.Y.Scale,
                    frameStart.Y.Offset + delta.Y
                )
            end
        end)
    end
    
    makeDraggable(panel, header)
    refreshModeButtons()
end

--============================================================================--
--// INITIALIZATION & TOGGLE
--============================================================================--

function Enable()
    if State.IsActive then return end
    State.IsActive = true
    
    CreateMainPanel()
    
    State.Highlight = Instance.new("SelectionBox")
    State.Highlight.Name = "iBToolsSelection"
    State.Highlight.LineThickness = 0.04
    State.Highlight.Color3 = Color3.fromRGB(0, 170, 255)
    State.Highlight.Parent = CoreGui

    table.insert(State.Connections, RunService.RenderStepped:Connect(function()
        -- [FIX] Correctly get the mouse target from the Mouse object.
        setTarget(Mouse.Target) 
    end))
    
    table.insert(State.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if State.CurrentPart then
                local handler = modeHandlers[State.CurrentMode]
                if handler then
                    handler(State.CurrentPart)
                end
            end
        end
    end))

    DoNotif("iBTools activated.", 3)
end

local function Toggle()
    if State.IsActive then
        Disable()
    else
        Enable()
    end
end

-- Create the initial button to launch the main UI.
do
    local toggleGui = CoreGui:FindFirstChild("iBToolsToggle")
    if toggleGui then toggleGui:Destroy() end

    local toggleButton = Instance.new("ScreenGui")
    toggleButton.Name = "iBToolsToggle"
    toggleButton.ResetOnSpawn = false
    
    local textButton = Instance.new("TextButton", toggleButton)
    textButton.Size = UDim2.new(0, 150, 0, 40)
    textButton.Position = UDim2.new(0, 20, 0, 20)
    textButton.Text = "Toggle iBTools"
    textButton.Font = Enum.Font.GothamSemibold
    textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", textButton)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(80, 110, 255)

    textButton.MouseButton1Click:Connect(Toggle)
    
    NaProtectUI(toggleButton)
    print("iBTools is ready. Click the toggle button to start.")
end
