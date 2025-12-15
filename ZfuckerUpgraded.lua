--[[
remade the zfucker to support xeno, lololol this version is a downgrade but hey it works.
--]]
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeamsService = game:GetService("Teams")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lplr = Players.LocalPlayer
local char = lplr.Character
lplr.CharacterAdded:Connect(function(newChar) char = newChar end)

--//============================================================================--
--// RE-ENGINEERED & HELPER FUNCTIONS
--//============================================================================--

local function _teleportAndClick(detector)
    if not (detector and detector:IsA("ClickDetector")) then return end
    
    local character = lplr.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local originalCFrame = hrp.CFrame
    local detectorParent = detector.Parent
    
    if detectorParent and detectorParent:IsA("BasePart") then
        hrp.CFrame = detectorParent.CFrame * CFrame.new(0, 3, 0)
        task.wait() 
        detector:FireClick()
        task.wait()
        hrp.CFrame = originalCFrame
    end
end

--//============================================================================--
--// NEW UNIVERSAL GUI
--//============================================================================--
local GUI = { UI = {} }

function GUI:CreateButton(text, parentFrame, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Text = text
    button.Parent = parentFrame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
    button.MouseButton1Click:Connect(callback)
    return button
end

function GUI:CreateToggle(text, parentFrame, callback)
    local toggle = self:CreateButton(text, parentFrame, function() end)
    toggle.Enabled = false
    
    local originalColor = toggle.BackgroundColor3
    local activeColor = Color3.fromRGB(80, 110, 255)

    toggle.MouseButton1Click:Connect(function()
        toggle.Enabled = not toggle.Enabled
        toggle.BackgroundColor3 = toggle.Enabled and activeColor or originalColor
        pcall(callback, toggle.Enabled)
    end)
    return toggle
end

-- [RE-ARCHITECTED] This function now creates a self-contained component, avoiding UIListLayout conflicts.
function GUI:CreateInputButton(buttonText, placeholderText, parentFrame, callback)
    -- This container holds the textbox and button. The parent's UIListLayout will position this single frame.
    local container = Instance.new("Frame")
    container.Name = buttonText .. "Container"
    container.Size = UDim2.new(1, -10, 0, 70) -- Height for textbox, button, and padding.
    container.BackgroundTransparency = 1
    
    -- Create the TextBox and position it at the top of the container.
    local inputField = Instance.new("TextBox")
    inputField.Name = "InputField"
    inputField.Size = UDim2.new(1, 0, 0, 30)
    inputField.Position = UDim2.fromOffset(0, 0)
    inputField.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    inputField.TextColor3 = Color3.fromRGB(220, 220, 220)
    inputField.Font = Enum.Font.Gotham
    inputField.TextSize = 14
    inputField.PlaceholderText = placeholderText
    inputField.Parent = container
    Instance.new("UICorner", inputField).CornerRadius = UDim.new(0, 4)

    -- Create the action Button and position it below the textbox.
    local button = Instance.new("TextButton")
    button.Name = "ActionButton"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.fromOffset(0, 35) -- 30px for textbox + 5px padding
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Text = buttonText
    button.Parent = container
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
    
    button.MouseButton1Click:Connect(function()
        pcall(callback, inputField.Text) -- Pass the input text to the assigned function
    end)
    
    -- Parent the fully constructed container at the end to ensure layout atomicity.
    container.Parent = parentFrame
    return container
end

function GUI:Notify(text)
    StarterGui:SetCore("SendNotification", {
        Title = "Notification",
        Text = text,
        Duration = 3
    })
end

function GUI:Initialize()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UniversalUI_Callum"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(500, 350)
    mainFrame.Position = UDim2.fromScale(0.1, 0.2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)

    local pageContainer = Instance.new("Frame", mainFrame)
    pageContainer.Size = UDim2.new(1, 0, 1, -30)
    pageContainer.Position = UDim2.fromOffset(0, 30)
    pageContainer.BackgroundTransparency = 1

    local isMinimized = false
    local originalSize = mainFrame.Size
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.fromOffset(20, 20)
    minimizeButton.Position = UDim2.new(1, -25, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 18
    minimizeButton.Parent = mainFrame
    Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 4)

    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        pageContainer.Visible = not isMinimized
        if isMinimized then
            mainFrame.Size = UDim2.fromOffset(originalSize.X.Offset, 30)
            minimizeButton.Text = "+"
        else
            mainFrame.Size = originalSize
            minimizeButton.Text = "-"
        end
    end)

    local tabNames = {"Teams", "Items", "Weapons", "Client", "Server"}
    self.UI.Tabs = {}

    for i, name in ipairs(tabNames) do
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Page"
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.Visible = (i == 1)
        page.Parent = pageContainer
        
        local listLayout = Instance.new("UIListLayout", page)
        listLayout.Padding = UDim.new(0, 5)
        local padding = Instance.new("UIPadding", page)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)

        self.UI.Tabs[name] = page

        local tabButton = Instance.new("TextButton", tabContainer)
        tabButton.Name = name
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Text = name
        tabButton.BackgroundColor3 = (i == 1) and Color3.fromRGB(80, 110, 255) or Color3.fromRGB(45, 45, 55)
        tabButton.TextColor3 = Color3.new(1,1,1)
        tabButton.Font = Enum.Font.Gotham
        
        tabButton.MouseButton1Click:Connect(function()
            for _, otherPage in ipairs(pageContainer:GetChildren()) do otherPage.Visible = false end
            for _, otherButton in ipairs(tabContainer:GetChildren()) do
                 if otherButton:IsA("TextButton") then otherButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end
            end
            page.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(80, 110, 255)
        end)
    end

    screenGui.Parent = CoreGui
    return self
end

local gui = GUI:Initialize()

--//============================================================================--
--// SCRIPT LOGIC
--//============================================================================--

-- Teams Tab
gui:CreateButton("Become Human", gui.UI.Tabs.Teams, function()
    if lplr.Character and lplr.Character:FindFirstChildOfClass("Humanoid") then
        lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
    end
end)
gui:CreateButton("Become Zombie", gui.UI.Tabs.Teams, function()
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(";zombie")
end)

-- Items Tab
gui:CreateButton("Minigun Sniper", gui.UI.Tabs.Items, function()
    ReplicatedStorage.Remotes.Shop.EquipWeapon:InvokeServer("Sniper")
    task.wait(0.1)
    local Sniper = lplr.Character and lplr.Character:FindFirstChild("Sniper") or lplr.Backpack:FindFirstChild("Sniper")
    if not Sniper then return gui:Notify("Sniper tool not found.") end
    local success, scr = pcall(function() return getsenv(Sniper.LocalScript) end)
    if not success or not scr then return gui:Notify("Failed to access sniper script environment.") end
    pcall(function()
        local shoot = debug.getupvalue(scr.FireGun, 5)
        local calc = debug.getupvalue(scr.FireGun, 6)
        local sound = Sniper.Handle["Sniper fire sound"]
        scr.FireGun = function(...)
            local sc = sound:Clone()
            sc.Playing = true
            sc.Parent = Sniper.Handle
            task.delay(sc.TimeLength, function() sc:Destroy() end)
            shoot(Sniper.Flash2.Position, calc(...))
        end
        local buttonDown = false
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not buttonDown and Sniper.Parent == lplr.Character then
                buttonDown = true
                while buttonDown do
                    coroutine.wrap(scr.FireGun)(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    task.wait()
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then buttonDown = false end
        end)
        gui:Notify("Minigun Sniper enabled.")
    end)
end)
gui:CreateButton("Give Antidote", gui.UI.Tabs.Items, function() _teleportAndClick(Workspace.Interaction.ToolGivers.Antidote.ClickDetector) end)
gui:CreateButton("Give Rainbow Potion", gui.UI.Tabs.Items, function() _teleportAndClick(Workspace.Interaction.ToolGivers["Rainbow Potion"].ClickDetector) end)
gui:CreateButton("Give all Signs", gui.UI.Tabs.Items, function()
    _teleportAndClick(Workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector)
    _teleportAndClick(Workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector)
    _teleportAndClick(Workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector)
    _teleportAndClick(Workspace.Interaction.ZombieSign.ClickDetector)
    local specialSign = Workspace.Interaction:GetChildren()[15]
    if specialSign and specialSign.ClickDetector then _teleportAndClick(specialSign.ClickDetector) end
end)

-- Weapons Tab
do
    local ShopRemote = ReplicatedStorage.Remotes.Shop.EquipWeapon
    for _, v in ipairs(ReplicatedStorage.Assets.Weapons:GetChildren()) do
        if v:IsA("Tool") then
            gui:CreateButton("Give " .. v.Name, gui.UI.Tabs.Weapons, function() ShopRemote:InvokeServer(v.Name) end)
        end
    end
end

-- Client Tab
do
    local highlights = {}
    local espConnection = nil
    local function updateHighlight(player)
        if not player.Character then return end
        if highlights[player] and highlights[player].Parent then
            highlights[player].FillColor = player.TeamColor.Color
        else
            local h = Instance.new("Highlight")
            h.Adornee, h.DepthMode, h.FillColor, h.OutlineColor, h.FillTransparency, h.Parent = player.Character, Enum.HighlightDepthMode.AlwaysOnTop, player.TeamColor.Color, Color3.fromRGB(235, 235, 235), 0.3, player.Character
            highlights[player] = h
        end
    end
    local function removeHighlight(player)
        if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
    end
    gui:CreateToggle("ESP", gui.UI.Tabs.Client, function(enabled)
        if enabled then
            for _, player in ipairs(Players:GetPlayers()) do if player ~= lplr then updateHighlight(player) end end
            espConnection = RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do if player ~= lplr then updateHighlight(player) end end
            end)
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for player, _ in pairs(highlights) do removeHighlight(player) end
        end
    end)
end
gui:CreateButton("Remove Team Barriers", gui.UI.Tabs.Client, function()
    for _, v in ipairs({"ZombieSIGN", "ZombieDoor", "ZombieDoor2", "ZombieDoor3", "NoZombie"}) do
        local barrier = Workspace:FindFirstChild(v, true)
        if barrier then barrier:Destroy() end
    end
end)
gui:CreateToggle("Unload Entities", gui.UI.Tabs.Client, function(enabled)
    local living = Workspace:FindFirstChild("LivingThings")
    if not living then return end
    if enabled then
        if lplr.Character then lplr.Character.Parent = Workspace end
        living.Parent = nil
    else
        living.Parent = Workspace
        if lplr.Character then lplr.Character.Parent = living end
    end
end)

-- Server Tab
local function rejoin() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end
local function lagServer(event, ...)
    for _ = 1, 24 do
        coroutine.wrap(function(...)
            for _ = 1, (24 * 1000) do event:FireServer(...) end
        end)(...)
    end
end
gui:CreateToggle("Lag Server (Landmine)", gui.UI.Tabs.Server, function(enabled)
    if enabled then lagServer(ReplicatedStorage.NetworkEvents.RemoteEvent, "PLACE_LANDMINE") else rejoin() end
end)
gui:CreateToggle("Lag Server (Necro)", gui.UI.Tabs.Server, function(enabled)
    if enabled then lagServer(ReplicatedStorage.Remotes.ZombieRelated.Necro.AbilityPlayer) else rejoin() end
end)
do
    local killAuraConnection = nil
    gui:CreateToggle("Kill Aura", gui.UI.Tabs.Server, function(enabled)
        if enabled then
            killAuraConnection = RunService.Heartbeat:Connect(function()
                local event = (lplr.Team == TeamsService.Zombie) and ReplicatedStorage.Remotes.ZombieRelated.PlayerAttack or ReplicatedStorage.Remotes.Melee.Damage
                local myHRP = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, v in ipairs(Workspace.LivingThings:GetChildren()) do
                    if v:GetAttribute("Team") and v:GetAttribute("Team") ~= lplr.Character:GetAttribute("Team") then
                        local root, hum = v:FindFirstChild("HumanoidRootPart"), v:FindFirstChildWhichIsA("Humanoid")
                        if hum and hum.Health > 0 and root and (root.Position - myHRP.Position).Magnitude <= 15 then event:InvokeServer(root) end
                    end
                end
            end)
        else
            if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
        end
    end)
end
do
    local killZombiesConnection = nil
    gui:CreateToggle("Kill Zombies (Auto-Sniper)", gui.UI.Tabs.Server, function(enabled)
        if enabled then
            killZombiesConnection = RunService.Heartbeat:Connect(function()
                if lplr.Team ~= TeamsService.Human then return end
                if not (lplr.Character and lplr.Character:FindFirstChild("Sniper")) then
                    ReplicatedStorage.Remotes.Shop.EquipWeapon:InvokeServer("Sniper")
                    return
                end
                local event, living = ReplicatedStorage.NetworkEvents.RemoteEvent, Workspace:FindFirstChild("LivingThings")
                if not living then return end
                for _, v in ipairs(living:GetChildren()) do
                    if v and v:FindFirstChild("Humanoid") and v:GetAttribute("Team") ~= lplr.Team and v.Humanoid.Health > 0 then
                        event:FireServer("GUN_DAMAGE", v)
                    end
                end
            end)
        else
            if killZombiesConnection then killZombiesConnection:Disconnect(); killZombiesConnection = nil end
        end
    end)
end

--//===[ Summon Landmines on Target | ADDED HERE ]===//--
gui:CreateInputButton("Summon Landmine", "Enter Target Name...", gui.UI.Tabs.Server, function(targetName)
    if not targetName or targetName == "" then return gui:Notify("Please enter a target name.") end
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then return gui:Notify("Target player not found.") end
    if targetPlayer == lplr then return gui:Notify("You cannot target yourself.") end

    local myHRP = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (myHRP and targetHRP) then return gui:Notify("Could not find character root part for you or the target.") end

    local originalCFrame = myHRP.CFrame
    myHRP.CFrame = targetHRP.CFrame
    task.wait()
    ReplicatedStorage.NetworkEvents.RemoteEvent:FireServer("PLACE_LANDMINE")
    task.wait()
    myHRP.CFrame = originalCFrame
    gui:Notify("Summoned landmine on " .. targetPlayer.Name)
end)

gui:Notify("zfucker upgraded loaded.")
