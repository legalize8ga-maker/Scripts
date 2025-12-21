--[[
made by zuka @OverZuka on roblox
v4



--]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
do
    local THEME = {
    Title = "Welcome!",
    Subtitle = "Made by @OverZuka - We're so back...",
    IconAssetId = "rbxassetid://7243158473",
    BackgroundColor = Color3.fromRGB(20, 20, 25),
    AccentColor = Color3.fromRGB(0, 255, 255),
    TextColor = Color3.fromRGB(240, 240, 240),
    FadeInTime = 0.5,
    HoldTime = 2.0,
    FadeOutTime = 0.7
    }
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "SplashScreen_" .. math.random(1000, 9999)
    splashGui.ResetOnSpawn = false
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    local background = Instance.new("Frame", splashGui)
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = THEME.BackgroundColor
    background.BackgroundTransparency = 1
    local centerFrame = Instance.new("Frame", background)
    centerFrame.Size = UDim2.fromOffset(200, 200)
    centerFrame.Position = UDim2.fromScale(0.5, 0.5)
    centerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    centerFrame.BackgroundTransparency = 1
    local icon = Instance.new("ImageLabel", centerFrame)
    icon.Size = UDim2.fromScale(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.35)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = THEME.IconAssetId
    icon.ImageColor3 = THEME.AccentColor
    icon.ImageTransparency = 1
    local title = Instance.new("TextLabel", centerFrame)
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Position = UDim2.fromScale(0.5, 0.65)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = THEME.Title
    title.TextColor3 = THEME.TextColor
    title.TextSize = 24
    title.TextTransparency = 1
    local subtitle = Instance.new("TextLabel", centerFrame)
    subtitle.Size = UDim2.new(1, 0, 0.1, 0)
    subtitle.Position = UDim2.fromScale(0.5, 0.8)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = THEME.Subtitle
    subtitle.TextColor3 = THEME.TextColor
    subtitle.TextSize = 14
    subtitle.TextTransparency = 1
    splashGui.Parent = CoreGui
    local tweenInfoIn = TweenInfo.new(THEME.FadeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInfoOut = TweenInfo.new(THEME.FadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local fadeInTweens = {
    TweenService:Create(background, tweenInfoIn, { BackgroundTransparency = 0.3 }),
    TweenService:Create(icon, tweenInfoIn, { ImageTransparency = 0 }),
    TweenService:Create(title, tweenInfoIn, { TextTransparency = 0 }),
    TweenService:Create(subtitle, tweenInfoIn, { TextTransparency = 0.2 })
    }
    local fadeOutTweens = {
    TweenService:Create(background, tweenInfoOut, { BackgroundTransparency = 1 }),
    TweenService:Create(icon, tweenInfoOut, { ImageTransparency = 1 }),
    TweenService:Create(title, tweenInfoOut, { TextTransparency = 1 }),
    TweenService:Create(subtitle, tweenInfoOut, { TextTransparency = 1 })
    }
    for _, tween in ipairs(fadeInTweens) do
        tween:Play()
    end
    task.wait(THEME.FadeInTime + THEME.HoldTime)
    for _, tween in ipairs(fadeOutTweens) do
        tween:Play()
    end
    fadeOutTweens[1].Completed:Wait()
    splashGui:Destroy()
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Utilities = {}
function Utilities.findPlayer(inputName)
    local input = tostring(inputName):lower()
    if input == "" then return nil end
        local exactMatch = nil
        local partialMatch = nil
        if input == "me" then return Players.LocalPlayer end
            for _, player in ipairs(Players:GetPlayers()) do
                local username = player.Name:lower()
                local displayName = player.DisplayName:lower()
                if username == input or displayName == input then
                    exactMatch = player
                    break
                end
                if not partialMatch then
                    if username:sub(1, #input) == input or displayName:sub(1, #input) == input then
                        partialMatch = player
                    end
                end
            end
            return exactMatch or partialMatch
        end
        local Prefix = "."
        local Commands = {}
        local CommandInfo = {}
        local Modules = {}
        local NotificationManager = {}
        do
            local queue = {}
            local isActive = false
            local tweenService = game:GetService("TweenService")
            local coreGui = game:GetService("CoreGui")
            local textService = game:GetService("TextService")
            local notifGui = Instance.new("ScreenGui", coreGui)
            notifGui.Name = "ZukaNotifGui_v2"
            notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            notifGui.ResetOnSpawn = false
            local function processNext()
            if isActive or #queue == 0 then
                return
            end
            isActive = true
            local data = table.remove(queue, 1)
            local text, duration = data[1], data[2]
            local notif = Instance.new("TextLabel")
            notif.Font = Enum.Font.GothamSemibold
            notif.TextSize = 12
            notif.Text = text
            notif.TextWrapped = true
            notif.Size = UDim2.fromOffset(300, 0)
            local textBounds = textService:GetTextSize(notif.Text, notif.TextSize, notif.Font, Vector2.new(notif.Size.X.Offset, 1000))
            local verticalPadding = 20
            notif.Size = UDim2.fromOffset(300, textBounds.Y + verticalPadding)
            notif.Position = UDim2.new(0.5, -150, 0, -60)
            notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            local corner = Instance.new("UICorner", notif)
            corner.CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", notif)
            stroke.Color = Color3.fromRGB(80, 80, 100)
            notif.Parent = notifGui
            local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local goalIn = { Position = UDim2.new(0.5, -150, 0, 10) }
            local goalOut = { Position = UDim2.new(0.5, -150, 0, -60) }
            local inTween = tweenService:Create(notif, tweenInfoIn, goalIn)
            inTween:Play()
            inTween.Completed:Wait()
            task.wait(duration)
            local outTween = tweenService:Create(notif, tweenInfoOut, goalOut)
            outTween:Play()
            outTween.Completed:Wait()
            notif:Destroy()
            isActive = false
            task.spawn(processNext)
        end
        function NotificationManager.Send(text, duration)
            table.insert(queue, {tostring(text), duration or 1})
            task.spawn(processNext)
        end
    end
    function DoNotif(text, duration)
        NotificationManager.Send(text, duration)
    end
    function RegisterCommand(info, func)
        if not info or not info.Name or not func then
            warn("Command registration failed: Missing info, name, or function.")
            return
        end
        local name = info.Name:lower()
        if Commands[name] then
            warn("Command registration skipped: Command '" .. name .. "' already exists.")
            return
        end
        Commands[name] = func
        if info.Aliases then
            for _, alias in ipairs(info.Aliases) do
                local aliasLower = alias:lower()
                if Commands[aliasLower] then
                    warn("Alias '" .. aliasLower .. "' for command '" .. name .. "' conflicts with an existing command and was not registered.")
                else
                Commands[aliasLower] = func
            end
        end
    end
    table.insert(CommandInfo, info)
end

local function loadAimbotGUI()
	-- This function encapsulates the entire aimbot script.
	-- It's called when the user runs the ';aimbot' command.

	-- Services
	local CoreGui = game:GetService("CoreGui")

	-- Check if the GUI already exists to prevent duplicates
	if CoreGui:FindFirstChild("UTS_CGE_Suite") then
		if DoNotif then
			DoNotif("Aimbot GUI is already open.", 2)
		else
			warn("Aimbot GUI is already open.")
		end
		return
	end
	
	local success, err = pcall(function()
		-- Services
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local Players = game:GetService("Players")
		local Workspace = game:GetService("Workspace")

		local LocalPlayer = Players.LocalPlayer
		local Camera = Workspace.CurrentCamera


        local function SetupSilentAimHook()
            if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then
                warn("Zuka's Analysis: Silent Aim dependencies (e.g., getrawmetatable) not found in this environment. Silent Aim will be disabled.")
                return function() end
            end

            local gameMetatable = getrawmetatable(game)
            local originalNamecall = gameMetatable.__namecall
            
            pcall(function()
                setreadonly(gameMetatable, false)
                gameMetatable.__namecall = newcclosure(function(...)
                    local args = {...}
                    local self = args[1]
                    local method = getnamecallmethod()

                    if getgenv().silentAimEnabled and getgenv().ZukaSilentAimTarget and self == game:GetService("Workspace") then
                        if method == "Raycast" then
                            local origin, direction = args[2], args[3]
                            if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                                local newDirection = (getgenv().ZukaSilentAimTarget - origin).Unit * direction.Magnitude
                                args[3] = newDirection
                                return originalNamecall(unpack(args))
                            end
                        end

                        if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" then
                            local rayArg = args[2]
                            if typeof(rayArg) == "Ray" then
                                local newRay = Ray.new(rayArg.Origin, (getgenv().ZukaSilentAimTarget - rayArg.Origin).Unit * 1000)
                                args[2] = newRay
                                return originalNamecall(unpack(args))
                            end
                        end
                    end
                    
                    return originalNamecall(...)
                end)
                setreadonly(gameMetatable, true)
            end)

            return function()
                pcall(function()
                    setreadonly(gameMetatable, false)
                    gameMetatable.__namecall = originalNamecall
                    setreadonly(gameMetatable, true)
                end)
            end
        end

		local cleanupSilentAimHook = SetupSilentAimHook()

		local function makeUICorner(element, cornerRadius)
			local corner = Instance.new("UICorner");
			corner.CornerRadius = UDim.new(0, cornerRadius or 6);
			corner.Parent = element
		end

		local MainScreenGui = Instance.new("ScreenGui");
		MainScreenGui.Name = "UTS_CGE_Suite";
		MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		MainScreenGui.ResetOnSpawn = false;

		MainScreenGui.Destroying:Connect(function()
			cleanupSilentAimHook()
		end)
		
		MainScreenGui.Parent = CoreGui;

		local explorerWindow = nil
		getgenv().TargetScope = Workspace
		getgenv().TargetIndex = {}
		getgenv().silentAimEnabled = false
		getgenv().ZukaSilentAimTarget = nil
		

		local function createExplorerWindow(statusLabel, indexerUpdateSignal)
			if explorerWindow and explorerWindow.Parent then
				explorerWindow.Visible = not explorerWindow.Visible;
				return explorerWindow
			end
			local explorerFrame = Instance.new("Frame");
			explorerFrame.Name = "ExplorerWindow";
			explorerFrame.Size = UDim2.new(0, 300, 0, 450);
			explorerFrame.Position = UDim2.new(0.5, 305, 0.5, -225);
			explorerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45);
			explorerFrame.BorderSizePixel = 1;
			explorerFrame.BorderColor3 = Color3.fromRGB(80, 80, 80);
			explorerFrame.Draggable = true;
			explorerFrame.Active = true;
			explorerFrame.ClipsDescendants = true;
			explorerFrame.Parent = MainScreenGui;
			makeUICorner(explorerFrame, 8);
			local topBar = Instance.new("Frame", explorerFrame);
			topBar.Name = "TopBar";
			topBar.Size = UDim2.new(1, 0, 0, 30);
			topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35);
			makeUICorner(topBar, 8);
			local title = Instance.new("TextLabel", topBar);
			title.Size = UDim2.new(1, -30, 1, 0);
			title.Position = UDim2.new(0, 10, 0, 0);
			title.BackgroundTransparency = 1;
			title.Font = Enum.Font.Code;
			title.Text = "Game Explorer";
			title.TextColor3 = Color3.fromRGB(200, 220, 255);
			title.TextSize = 16;
			title.TextXAlignment = Enum.TextXAlignment.Left;
			local closeButton = Instance.new("TextButton", topBar);
			closeButton.Size = UDim2.new(0, 24, 0, 24);
			closeButton.Position = UDim2.new(1, -28, 0.5, -12);
			closeButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80);
			closeButton.Font = Enum.Font.Code;
			closeButton.Text = "X";
			closeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
			closeButton.TextSize = 14;
			makeUICorner(closeButton, 6);
			closeButton.MouseButton1Click:Connect(function()
				explorerFrame.Visible = false
			end);
			local treeScrollView = Instance.new("ScrollingFrame", explorerFrame);
			treeScrollView.Position = UDim2.new(0,0,0,30);
			treeScrollView.Size = UDim2.new(1, 0, 1, -30);
			treeScrollView.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
			treeScrollView.BorderSizePixel = 0;
			local uiListLayout = Instance.new("UIListLayout", treeScrollView);
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			uiListLayout.Padding = UDim.new(0, 1);
			local contextMenu = nil;
			local function closeContextMenu()
				if contextMenu and contextMenu.Parent then
					contextMenu:Destroy()
				end
			end;
			UserInputService.InputBegan:Connect(function(input)
				if not (contextMenu and contextMenu:IsAncestorOf(input.UserInputType)) and input.UserInputType ~= Enum.UserInputType.MouseButton2 then
					closeContextMenu()
				end
			end);

			local function createTree(parentInstance, parentUi, indentLevel)
				for _, child in ipairs(parentInstance:GetChildren()) do
					local itemFrame = Instance.new("Frame");
					itemFrame.Name = child.Name;
					itemFrame.Size = UDim2.new(1, 0, 0, 22);
					itemFrame.BackgroundTransparency = 1;
					itemFrame.Parent = parentUi;
					local hasChildren = #child:GetChildren() > 0;
					local toggleButton = Instance.new("TextButton");
					toggleButton.Size = UDim2.new(0, 20, 0, 20);
					toggleButton.Position = UDim2.fromOffset(indentLevel * 12, 1);
					toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100);
					toggleButton.Font = Enum.Font.Code;
					toggleButton.TextSize = 14;
					toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255);
					toggleButton.Text = hasChildren and "[+]" or "[-]";
					toggleButton.Parent = itemFrame;
					local nameButton = Instance.new("TextButton");
					nameButton.Size = UDim2.new(1, -((indentLevel * 12) + 22), 0, 20);
					nameButton.Position = UDim2.fromOffset((indentLevel * 12) + 22, 1);
					nameButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70);
					nameButton.Font = Enum.Font.Code;
					nameButton.TextSize = 14;
					nameButton.TextColor3 = Color3.fromRGB(220, 220, 220);
					nameButton.Text = " " .. child.Name .. " [" .. child.ClassName .. "]";
					nameButton.TextXAlignment = Enum.TextXAlignment.Left;
					nameButton.Parent = itemFrame;
					local childContainer = Instance.new("Frame", itemFrame);
					childContainer.Name = "ChildContainer";
					childContainer.Size = UDim2.new(1, 0, 0, 0);
					childContainer.Position = UDim2.new(0, 0, 1, 0);
					childContainer.BackgroundTransparency = 1;
					childContainer.ClipsDescendants = true;
					local childLayout = Instance.new("UIListLayout", childContainer);
					childLayout.SortOrder = Enum.SortOrder.LayoutOrder;
					itemFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						childContainer.Size = UDim2.new(1, 0, 0, childLayout.AbsoluteContentSize.Y);
						itemFrame.Size = UDim2.new(1, 0, 0, 22 + childContainer.AbsoluteSize.Y)
					end);
					childLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
						childContainer.Size = UDim2.new(1, 0, 0, childLayout.AbsoluteContentSize.Y);
						itemFrame.Size = UDim2.new(1, 0, 0, 22 + childContainer.AbsoluteSize.Y)
					end);
					
					toggleButton.MouseButton1Click:Connect(function()
						local isExpanded = childContainer:FindFirstChildOfClass("Frame") ~= nil;
						if not hasChildren then return end;
						if isExpanded then
							for _, v in ipairs(childContainer:GetChildren()) do
								if v:IsA("Frame") then v:Destroy() end
							end;
							toggleButton.Text = "[+]"
						else
							createTree(child, childContainer, indentLevel + 1);
							toggleButton.Text = "[-]"
						end
					end)
					
					nameButton.MouseButton2Click:Connect(function()
						closeContextMenu();
						if child:IsA("Folder") or child:IsA("Model") or child:IsA("Workspace") then
							contextMenu = Instance.new("Frame");
							contextMenu.Size = UDim2.new(0, 150, 0, 30);
							contextMenu.Position = UDim2.fromOffset(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y);
							contextMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35);
							contextMenu.BorderSizePixel = 1;
							contextMenu.BorderColor3 = Color3.fromRGB(80, 80, 80);
							contextMenu.Parent = MainScreenGui;
							local setScopeBtn = Instance.new("TextButton", contextMenu);
							setScopeBtn.Size = UDim2.new(1, 0, 1, 0);
							setScopeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
							setScopeBtn.TextColor3 = Color3.fromRGB(200, 220, 255);
							setScopeBtn.Font = Enum.Font.Code;
							setScopeBtn.Text = "Set as Target Scope";
							setScopeBtn.MouseButton1Click:Connect(function()
								getgenv().TargetScope = child;
								statusLabel.Text = "Scope set to: " .. child.Name;
								indexerUpdateSignal:Fire();
								closeContextMenu()
							end)
						end
					end)
				end
			end
			createTree(game, treeScrollView, 0);
			explorerWindow = explorerFrame;
			return explorerFrame
		end


		local MainWindow = Instance.new("Frame");
		MainWindow.Name = "MainWindow";
		MainWindow.Size = UDim2.new(0, 520, 0, 420);
		MainWindow.Position = UDim2.new(0.5, -260, 0.5, -210);
		MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 45);
		MainWindow.BorderSizePixel = 0;
		MainWindow.Active = true;
		MainWindow.ClipsDescendants = true;
		MainWindow.Parent = MainScreenGui;
		makeUICorner(MainWindow, 8);

		local isDragging = false;
		local dragStart, startPosition;
		MainWindow.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDragging = true;
				dragStart = input.Position;
				startPosition = MainWindow.Position;
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						isDragging = false
					end
				end)
			end
		end);
		UserInputService.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
				local delta = input.Position - dragStart;
				MainWindow.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			end
		end);

		local TopBar = Instance.new("Frame");
		TopBar.Name = "TopBar";
		TopBar.Size = UDim2.new(1, 0, 0, 30);
		TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35);
		TopBar.BorderSizePixel = 0;
		TopBar.Parent = MainWindow;
		makeUICorner(TopBar, 8);

		local TitleLabel = Instance.new("TextLabel");
		TitleLabel.Name = "TitleLabel";
		TitleLabel.Size = UDim2.new(1, -90, 1, 0);
		TitleLabel.Position = UDim2.new(0, 10, 0, 0);
		TitleLabel.BackgroundTransparency = 1;
		TitleLabel.Font = Enum.Font.Code;
		TitleLabel.Text = "Gaming Chair v2.2";
		TitleLabel.TextColor3 = Color3.fromRGB(200, 220, 255);
		TitleLabel.TextSize = 16;
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
		TitleLabel.Parent = TopBar;

		local CloseButton = Instance.new("TextButton");
		CloseButton.Name = "CloseButton";
		CloseButton.Size = UDim2.new(0, 24, 0, 24);
		CloseButton.Position = UDim2.new(1, -28, 0.5, -12);
		CloseButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80);
		CloseButton.Font = Enum.Font.Code;
		CloseButton.Text = "X";
		CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		CloseButton.TextSize = 14;
		CloseButton.Parent = TopBar;
		makeUICorner(CloseButton, 6);
		CloseButton.MouseButton1Click:Connect(function() MainScreenGui:Destroy() end);

		local MinimizeButton = Instance.new("TextButton");
		MinimizeButton.Name = "MinimizeButton";
		MinimizeButton.Size = UDim2.new(0, 24, 0, 24);
		MinimizeButton.Position = UDim2.new(1, -56, 0.5, -12);
		MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100);
		MinimizeButton.Font = Enum.Font.Code;
		MinimizeButton.Text = "-";
		MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		MinimizeButton.TextSize = 14;
		MinimizeButton.Parent = TopBar;
		makeUICorner(MinimizeButton, 6);

		local ExplorerButton = Instance.new("TextButton");
		ExplorerButton.Name = "ExplorerButton";
		ExplorerButton.Size = UDim2.new(0, 24, 0, 24);
		ExplorerButton.Position = UDim2.new(1, -84, 0.5, -12);
		ExplorerButton.BackgroundColor3 = Color3.fromRGB(80, 120, 180);
		ExplorerButton.Font = Enum.Font.Code;
		ExplorerButton.Text = "E";
		ExplorerButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		ExplorerButton.TextSize = 14;
		ExplorerButton.Parent = TopBar;
		makeUICorner(ExplorerButton, 6)

		local ContentContainer = Instance.new("Frame");
		ContentContainer.Name = "ContentContainer";
		ContentContainer.Size = UDim2.new(1, 0, 1, -30);
		ContentContainer.Position = UDim2.new(0, 0, 0, 30);
		ContentContainer.BackgroundTransparency = 1;
		ContentContainer.Parent = MainWindow;

		local isMinimized = false;
		MinimizeButton.MouseButton1Click:Connect(function()
			isMinimized = not isMinimized;
			ContentContainer.Visible = not isMinimized;
			if isMinimized then
				MainWindow.Size = UDim2.new(0, 200, 0, 30);
				MinimizeButton.Text = "+"
			else
				MainWindow.Size = UDim2.new(0, 520, 0, 420);
				MinimizeButton.Text = "-"
			end
		end);

		do
			local statusLabel, selectLabel;
			
			local AimbotPage = Instance.new("Frame", ContentContainer)
			AimbotPage.Name = "AimbotPage"
			AimbotPage.Size = UDim2.new(1, 0, 1, -50)
			AimbotPage.BackgroundTransparency = 1;
			
			local PagePadding = Instance.new("UIPadding", AimbotPage)
			PagePadding.PaddingTop = UDim.new(0, 10)
			PagePadding.PaddingLeft = UDim.new(0, 10)
			PagePadding.PaddingRight = UDim.new(0, 10)

			local LeftColumn = Instance.new("Frame", AimbotPage)
			LeftColumn.Name = "LeftColumn"
			LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
			LeftColumn.BackgroundTransparency = 1
			local LeftLayout = Instance.new("UIListLayout", LeftColumn)
			LeftLayout.Padding = UDim.new(0, 8)
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local RightColumn = Instance.new("Frame", AimbotPage)
			RightColumn.Name = "RightColumn"
			RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
			RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
			RightColumn.BackgroundTransparency = 1
			local RightLayout = Instance.new("UIListLayout", RightColumn)
			RightLayout.Padding = UDim.new(0, 8)
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			
			local StatusBar = Instance.new("Frame", ContentContainer)
			StatusBar.Name = "StatusBar"
			StatusBar.Size = UDim2.new(1, -20, 0, 40)
			StatusBar.Position = UDim2.new(0, 10, 1, -45)
			StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
			makeUICorner(StatusBar, 6)
			local StatusLayout = Instance.new("UIListLayout", StatusBar)
			StatusLayout.Padding = UDim.new(0, 2)
			local StatusPadding = Instance.new("UIPadding", StatusBar)
			StatusPadding.PaddingLeft = UDim.new(0, 8)
			StatusPadding.PaddingRight = UDim.new(0, 8)

			local function createSectionHeader(parent, text)
				local header = Instance.new("TextLabel", parent)
				header.Size = UDim2.new(1, 0, 0, 24)
				header.BackgroundTransparency = 1
				header.Font = Enum.Font.Code
				header.Text = text
				header.TextColor3 = Color3.fromRGB(200, 220, 255)
				header.TextSize = 16
				header.TextXAlignment = Enum.TextXAlignment.Left
				return header
			end

			local function createSettingRow(parent, labelText)
				local row = Instance.new("Frame", parent)
				row.Size = UDim2.new(1, 0, 0, 24)
				row.BackgroundTransparency = 1
				
				local label = Instance.new("TextLabel", row)
				label.Size = UDim2.new(0.4, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.Code
				label.Text = labelText..":"
				label.TextColor3 = Color3.fromRGB(180, 220, 255)
				label.TextSize = 15
				label.TextXAlignment = Enum.TextXAlignment.Left
				
				return row
			end

			createSectionHeader(LeftColumn, "General Settings")
			
			local toggleKeyRow = createSettingRow(LeftColumn, "Toggle Key")
			local toggleKeyBox = Instance.new("TextBox", toggleKeyRow)
			toggleKeyBox.Size, toggleKeyBox.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			toggleKeyBox.BackgroundColor3, toggleKeyBox.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			toggleKeyBox.Font, toggleKeyBox.TextSize, toggleKeyBox.Text = Enum.Font.Code, 15, "MouseButton2"
			makeUICorner(toggleKeyBox, 6)
			
			local aimPartRow = createSettingRow(LeftColumn, "Aim Part")
			local partDropdown = Instance.new("TextButton", aimPartRow)
			partDropdown.Size, partDropdown.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			partDropdown.BackgroundColor3, partDropdown.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			partDropdown.Font, partDropdown.TextSize, partDropdown.Text = Enum.Font.Code, 15, "Head"
			makeUICorner(partDropdown, 6)
			
			createSectionHeader(LeftColumn, "Field of View")
			
			local fovRow = createSettingRow(LeftColumn, "FOV Radius")
			local fovValueLabel = Instance.new("TextLabel", fovRow)
			fovValueLabel.Size, fovValueLabel.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			fovValueLabel.BackgroundTransparency, fovValueLabel.TextColor3 = 1, Color3.fromRGB(255,255,255)
			fovValueLabel.Font, fovValueLabel.TextSize = Enum.Font.Code, 15
			fovValueLabel.TextXAlignment, fovValueLabel.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Center

			local sliderTrack = Instance.new("Frame", LeftColumn)
			sliderTrack.Size, sliderTrack.BackgroundColor3 = UDim2.new(1, 0, 0, 4), Color3.fromRGB(20,20,30)
			sliderTrack.BorderSizePixel = 0
			makeUICorner(sliderTrack, 2)
			
			local sliderHandle = Instance.new("TextButton", sliderTrack)
			sliderHandle.Size, sliderHandle.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0.5, -6)
			sliderHandle.BackgroundColor3, sliderHandle.BorderSizePixel = Color3.fromRGB(180, 220, 255), 0
			sliderHandle.Text = ""
			makeUICorner(sliderHandle, 6)

			createSectionHeader(LeftColumn, "Smoothing")

			local smoothingToggle = Instance.new("TextButton", LeftColumn)
			smoothingToggle.Size, smoothingToggle.Text = UDim2.new(1, 0, 0, 28), "Smoothing: OFF"
			smoothingToggle.BackgroundColor3, smoothingToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			smoothingToggle.Font, smoothingToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(smoothingToggle, 6)

			local smoothingRow = createSettingRow(LeftColumn, "Smoothness")
			local smoothingValueLabel = Instance.new("TextLabel", smoothingRow)
			smoothingValueLabel.Size, smoothingValueLabel.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			smoothingValueLabel.BackgroundTransparency, smoothingValueLabel.TextColor3 = 1, Color3.fromRGB(255,255,255)
			smoothingValueLabel.Font, smoothingValueLabel.TextSize = Enum.Font.Code, 15
			smoothingValueLabel.TextXAlignment, smoothingValueLabel.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Center

			local smoothingSliderTrack = Instance.new("Frame", LeftColumn)
			smoothingSliderTrack.Size, smoothingSliderTrack.BackgroundColor3 = UDim2.new(1, 0, 0, 4), Color3.fromRGB(20,20,30)
			smoothingSliderTrack.BorderSizePixel = 0
			makeUICorner(smoothingSliderTrack, 2)

			local smoothingSliderHandle = Instance.new("TextButton", smoothingSliderTrack)
			smoothingSliderHandle.Size, smoothingSliderHandle.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0.5, -6)
			smoothingSliderHandle.BackgroundColor3, smoothingSliderHandle.BorderSizePixel = Color3.fromRGB(180, 220, 255), 0
			smoothingSliderHandle.Text = ""
			makeUICorner(smoothingSliderHandle, 6)
			
			createSectionHeader(RightColumn, "Targeting")
			
			local playerRow = createSettingRow(RightColumn, "Target Player")
			local playerDropdown = Instance.new("TextButton", playerRow)
			playerDropdown.Size, playerDropdown.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			playerDropdown.BackgroundColor3, playerDropdown.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			playerDropdown.Font, playerDropdown.TextSize, playerDropdown.Text = Enum.Font.Code, 15, "None"
			makeUICorner(playerDropdown, 6)
			
			local targetPlayerToggle = Instance.new("TextButton", RightColumn)
			targetPlayerToggle.Size = UDim2.new(1, 0, 0, 28)
			targetPlayerToggle.BackgroundColor3, targetPlayerToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			targetPlayerToggle.Font, targetPlayerToggle.TextSize, targetPlayerToggle.Text = Enum.Font.Code, 15, "Target Selected: OFF"
			makeUICorner(targetPlayerToggle, 6)

			createSectionHeader(RightColumn, "Modifiers")
			
			local silentAimToggle = Instance.new("TextButton", RightColumn)
			silentAimToggle.Size, silentAimToggle.Text = UDim2.new(1, 0, 0, 28), "Silent Aim: OFF"
			silentAimToggle.BackgroundColor3, silentAimToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			silentAimToggle.Font, silentAimToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(silentAimToggle, 6)
			
			local ignoreTeamToggle = Instance.new("TextButton", RightColumn)
			ignoreTeamToggle.Size, ignoreTeamToggle.Text = UDim2.new(1, 0, 0, 28), "Ignore Team: OFF"
			ignoreTeamToggle.BackgroundColor3, ignoreTeamToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			ignoreTeamToggle.Font, ignoreTeamToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(ignoreTeamToggle, 6)
			
			local wallCheckToggle = Instance.new("TextButton", RightColumn)
			wallCheckToggle.Size, wallCheckToggle.Text = UDim2.new(1, 0, 0, 28), "Wall Check: ON"
			wallCheckToggle.BackgroundColor3, wallCheckToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			wallCheckToggle.Font, wallCheckToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(wallCheckToggle, 6)
			
			statusLabel = Instance.new("TextLabel", StatusBar)
			statusLabel.Size, statusLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 18), 1
			statusLabel.TextColor3, statusLabel.Font, statusLabel.TextSize = Color3.fromRGB(180,220,180), Enum.Font.Code, 14
			statusLabel.Text = "Aimbot ready. Hold toggle key to aim."
			statusLabel.TextXAlignment = Enum.TextXAlignment.Left

			selectLabel = Instance.new("TextLabel", StatusBar)
			selectLabel.Size, selectLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 18), 1
			selectLabel.TextColor3, selectLabel.Font, selectLabel.TextSize = Color3.fromRGB(220,220,180), Enum.Font.Code, 14
			selectLabel.Text = "Press V to delete any block/model under mouse."
			selectLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			-- ############################
			-- ### AIMBOT LOGIC STARTS HERE ###
			-- ############################
			
			local parts = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"};
			local dropdownOpen, dropdownFrame = false, nil;
			partDropdown.MouseButton1Click:Connect(function()
				if dropdownOpen then
					if dropdownFrame then dropdownFrame:Destroy() end
					dropdownOpen = false;
					return
				end;
				dropdownOpen = true;
				dropdownFrame = Instance.new("Frame", AimbotPage);
				local absolutePos = partDropdown.AbsolutePosition
				local guiPos = MainWindow.AbsolutePosition
				dropdownFrame.Size = UDim2.new(0, partDropdown.AbsoluteSize.X, 0, #parts * 22)
				dropdownFrame.Position = UDim2.new(0, absolutePos.X - guiPos.X, 0, absolutePos.Y - guiPos.Y + 22)
				dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
				dropdownFrame.BackgroundTransparency = 0.2
				dropdownFrame.BorderSizePixel = 0;
				dropdownFrame.ZIndex = 5
				makeUICorner(dropdownFrame, 6);
                local stroke = Instance.new("UIStroke", dropdownFrame)
                stroke.Color = Color3.fromRGB(80, 80, 90)
                stroke.Thickness = 1

				for i, part in ipairs(parts) do
					local btn = Instance.new("TextButton", dropdownFrame);
					btn.Size, btn.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, (i-1)*22);
					btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255);
					btn.Font, btn.TextSize, btn.Text = Enum.Font.Code, 15, part;
					makeUICorner(btn, 6);
					btn.MouseButton1Click:Connect(function()
						partDropdown.Text = part;
						if dropdownFrame then dropdownFrame:Destroy() end;
						dropdownOpen = false
					end)
				end
			end);
			
			local fovRadius = 150;
			local smoothingEnabled = false;
			local smoothingFactor = 0.2;
			local selectedPlayerTarget, selectedPart = nil, nil;
			local playerTargetEnabled = false;
			local aiming = false;
			local ignoreTeamEnabled = false;
			local wallCheckEnabled = true;
			local wallCheckParams = RaycastParams.new();
			wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude;
			local activeESPs = {};

			local FovCircle = nil
			if Drawing and typeof(Drawing.new) == "function" then
				FovCircle = Drawing.new("Circle")
				FovCircle.Visible = false;
				FovCircle.Thickness = 1;
				FovCircle.NumSides = 64;
				FovCircle.Color = Color3.fromRGB(255, 255, 255);
				FovCircle.Transparency = 0.5;
				FovCircle.Filled = false;
			else
				warn("Zuka's Log: 'Drawing' library not found. FOV circle visualization will be disabled.")
			end

			local minFov, maxFov = 50, 500;
			local function updateFovFromHandlePosition()
				local trackWidth = sliderTrack.AbsoluteSize.X;
				local handleX = sliderHandle.Position.X.Offset;
				local ratio = math.clamp(handleX / (trackWidth - sliderHandle.AbsoluteSize.X), 0, 1);
				fovRadius = minFov + (maxFov - minFov) * ratio;
				fovValueLabel.Text = tostring(math.floor(fovRadius)) .. "px";
				if FovCircle then
					FovCircle.Radius = fovRadius
				end
			end;
			local function updateHandleFromFovValue()
				local trackWidth = sliderTrack.AbsoluteSize.X;
				local ratio = (fovRadius - minFov) / (maxFov - minFov);
				local handleX = ratio * (trackWidth - sliderHandle.AbsoluteSize.X);
				sliderHandle.Position = UDim2.new(0, handleX, 0.5, -6)
			end;
			
			local isDraggingSlider = false;
			sliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSlider = true end end);
			UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSlider = false end end);
			UserInputService.InputChanged:Connect(function(input)
				if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mouseX = UserInputService:GetMouseLocation().X;
					local trackStartX = sliderTrack.AbsolutePosition.X;
					local handleWidth = sliderHandle.AbsoluteSize.X;
					local trackWidth = sliderTrack.AbsoluteSize.X;
					local newHandleX = mouseX - trackStartX - (handleWidth / 2);
					local clampedX = math.clamp(newHandleX, 0, trackWidth - handleWidth);
					sliderHandle.Position = UDim2.new(0, clampedX, 0.5, -6);
					updateFovFromHandlePosition()
				end
			end)
			
			smoothingToggle.MouseButton1Click:Connect(function()
				smoothingEnabled = not smoothingEnabled
				smoothingToggle.Text = "Smoothing: " .. (smoothingEnabled and "ON" or "OFF")
			end)
			local minSmooth, maxSmooth = 0.05, 1.0;
			local function updateSmoothFromHandlePosition()
				local trackWidth = smoothingSliderTrack.AbsoluteSize.X;
				local handleX = smoothingSliderHandle.Position.X.Offset;
				local ratio = math.clamp(handleX / (trackWidth - smoothingSliderHandle.AbsoluteSize.X), 0, 1);
				smoothingFactor = minSmooth + (maxSmooth - minSmooth) * ratio;
				smoothingValueLabel.Text = string.format("%.2f", smoothingFactor)
			end;
			local function updateHandleFromSmoothValue()
				local trackWidth = smoothingSliderTrack.AbsoluteSize.X;
				local ratio = (smoothingFactor - minSmooth) / (maxSmooth - minSmooth);
				local handleX = ratio * (trackWidth - smoothingSliderHandle.AbsoluteSize.X);
				smoothingSliderHandle.Position = UDim2.new(0, handleX, 0.5, -6)
			end;

			local isDraggingSmoothSlider = false;
			smoothingSliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSmoothSlider = true end end);
			UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSmoothSlider = false end end);
			UserInputService.InputChanged:Connect(function(input)
				if isDraggingSmoothSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mouseX = UserInputService:GetMouseLocation().X;
					local trackStartX = smoothingSliderTrack.AbsolutePosition.X;
					local handleWidth = smoothingSliderHandle.AbsoluteSize.X;
					local trackWidth = smoothingSliderTrack.AbsoluteSize.X;
					local newHandleX = mouseX - trackStartX - (handleWidth / 2);
					local clampedX = math.clamp(newHandleX, 0, trackWidth - handleWidth);
					smoothingSliderHandle.Position = UDim2.new(0, clampedX, 0.5, -6);
					updateSmoothFromHandlePosition()
				end
			end)

			task.wait();
			updateHandleFromFovValue()
			updateFovFromHandlePosition()
			updateHandleFromSmoothValue()
			updateSmoothFromHandlePosition()
			
			local function isTeammate(player)
				if not ignoreTeamEnabled or not player then return false end;
				if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then return true end;
				if LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then return true end;
				return false
			end
			local function isPartVisible(targetPart)
				if not LocalPlayer.Character or not targetPart or not targetPart.Parent then return false end;
				local targetCharacter = targetPart:FindFirstAncestorOfClass("Model") or targetPart.Parent;
				local origin = Camera.CFrame.Position;
				wallCheckParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter};
				local result = Workspace:Raycast(origin, targetPart.Position - origin, wallCheckParams);
				return not result
			end
			local function manageESP(part, color, name)
				if not part or not part.Parent then return end;
				if activeESPs[part] then
					activeESPs[part].Color3, activeESPs[part].Name, activeESPs[part].Adornee, activeESPs[part].Size = color, name, part, part.Size
				else
					local espBox = Instance.new("BoxHandleAdornment");
					espBox.Name, espBox.Adornee, espBox.AlwaysOnTop = name, part, true;
					espBox.ZIndex, espBox.Size, espBox.Color3 = 10, part.Size, color;
					espBox.Transparency, espBox.Parent = 0.4, part;
					activeESPs[part] = espBox
				end
			end
			local function clearESP(part)
				if part then
					if activeESPs[part] then
						activeESPs[part]:Destroy();
						activeESPs[part] = nil
					end
				else
					for _, espBox in pairs(activeESPs) do espBox:Destroy() end;
					activeESPs = {}
				end
			end
			
			local function getClosestTargetInScope()
				local mousePos = UserInputService:GetMouseLocation();
				local minDist, closestTargetModel = math.huge, nil;
				local aimPartName = partDropdown.Text
				
				for _, model in ipairs(getgenv().TargetIndex) do
					if model and model.Parent then
						local player = Players:GetPlayerFromCharacter(model)
						if player and player == LocalPlayer then continue end
						if not (player and isTeammate(player)) then
							local targetPart = model:FindFirstChild(aimPartName)
							if targetPart and (not wallCheckEnabled or isPartVisible(targetPart)) then
								local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
								if onScreen then
									local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude;
									if dist < minDist and dist <= fovRadius then
										minDist, closestTargetModel = dist, model
									end
								end
							end
						end
					end
				end
				return closestTargetModel
			end
			
			local playerDropdownOpen, playerDropdownFrame = false, nil;
			local function buildPlayerDropdownFrame()
				if playerDropdownFrame then playerDropdownFrame:Destroy() end;
				local playersList = Players:GetPlayers();
				playerDropdownFrame = Instance.new("Frame", AimbotPage);
				local absolutePos = playerDropdown.AbsolutePosition
				local guiPos = MainWindow.AbsolutePosition
				playerDropdownFrame.Size = UDim2.new(0, playerDropdown.AbsoluteSize.X, 0, #playersList * 22)
				playerDropdownFrame.Position = UDim2.new(0, absolutePos.X - guiPos.X, 0, absolutePos.Y - guiPos.Y + 22)
				playerDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
				playerDropdownFrame.BackgroundTransparency = 0.2
				playerDropdownFrame.BorderSizePixel = 0;
				playerDropdownFrame.ZIndex = 5
				makeUICorner(playerDropdownFrame, 6);
                local stroke = Instance.new("UIStroke", playerDropdownFrame)
                stroke.Color = Color3.fromRGB(80, 80, 90)
                stroke.Thickness = 1

				for i, plr in ipairs(playersList) do
					local btn = Instance.new("TextButton", playerDropdownFrame);
					btn.Size, btn.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, (i-1)*22);
					btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255);
					btn.Font, btn.TextSize, btn.Text = Enum.Font.Code, 15, plr.Name;
					makeUICorner(btn, 6);
					btn.MouseButton1Click:Connect(function()
						selectedPlayerTarget, playerDropdown.Text = plr, plr.Name;
						if playerDropdownFrame then playerDropdownFrame:Destroy() end;
						playerDropdownOpen = false;
						if playerTargetEnabled then statusLabel.Text = "Aimbot: Will target " .. plr.Name end
					end)
				end
			end
			
			targetPlayerToggle.MouseButton1Click:Connect(function()
				playerTargetEnabled = not playerTargetEnabled;
				targetPlayerToggle.Text = "Target Selected: " .. (playerTargetEnabled and "ON" or "OFF");
				if not playerTargetEnabled then
					statusLabel.Text = "Aimbot ready. Hold toggle key to aim."
				elseif selectedPlayerTarget then
					statusLabel.Text = "Aimbot: Will target " .. selectedPlayerTarget.Name
				end
			end)
			
			playerDropdown.MouseButton1Click:Connect(function()
				if playerDropdownOpen then
					if playerDropdownFrame then playerDropdownFrame:Destroy() end;
					playerDropdownOpen = false; return
				end;
				playerDropdownOpen = true; buildPlayerDropdownFrame()
			end)
			Players.PlayerAdded:Connect(function() if playerDropdownOpen then buildPlayerDropdownFrame() end end);
			Players.PlayerRemoving:Connect(function(plr)
				if selectedPlayerTarget == plr then
					selectedPlayerTarget, playerDropdown.Text = nil, "None";
					if playerTargetEnabled then
						playerTargetEnabled = false;
						targetPlayerToggle.Text = "Target Selected: OFF"
					end
				end;
				if playerDropdownOpen then buildPlayerDropdownFrame() end
			end)
			
			UserInputService.InputBegan:Connect(function(input, processed)
				if processed or toggleKeyBox:IsFocused() then return end;
				if input.KeyCode == Enum.KeyCode.V then
					local target = LocalPlayer:GetMouse().Target
					if target and target.Parent then
						local modelAncestor = target:FindFirstAncestorOfClass("Model")
						if (modelAncestor and modelAncestor == LocalPlayer.Character) or target:IsDescendantOf(LocalPlayer.Character) then
							statusLabel.Text = "Cannot delete your own character."; return
						end
						if modelAncestor and modelAncestor ~= Workspace then
							local modelName = modelAncestor.Name; modelAncestor:Destroy(); statusLabel.Text = "Deleted model: " .. modelName
						else
							if target.Parent ~= Workspace then
								 local targetName = target.Name; target:Destroy(); statusLabel.Text = "Deleted part: " .. targetName
							else
								 statusLabel.Text = "Cannot delete baseplate or map."
							end
						end
					else
						statusLabel.Text = "No target under mouse to delete."
					end
				end;
				
				local key = toggleKeyBox.Text:upper();
				if (key == "MOUSEBUTTON2" and input.UserInputType == Enum.UserInputType.MouseButton2) or (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name:upper() == key) then
					aiming = true
					if FovCircle then FovCircle.Visible = true end
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				local key = toggleKeyBox.Text:upper();
				if (key == "MOUSEBUTTON2" and input.UserInputType == Enum.UserInputType.MouseButton2) or (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name:upper() == key) then
					aiming = false
					if FovCircle then FovCircle.Visible = false end
					clearESP()
				end
			end)
			
			local currentTarget = nil
			RunService.RenderStepped:Connect(function(deltaTime)
				if FovCircle and FovCircle.Visible then
					FovCircle.Position = UserInputService:GetMouseLocation()
				end

				local isCurrentTargetValid = currentTarget and currentTarget.Parent and currentTarget:FindFirstChildOfClass("Humanoid") and currentTarget:FindFirstChildOfClass("Humanoid").Health > 0
				if aiming and not isCurrentTargetValid then
					currentTarget = getClosestTargetInScope()
				elseif not aiming then
					currentTarget = nil
				end

				local aimPart, targetPlayer, targetModel = nil, nil, nil;
				local partsToDrawESPFor = {}

				if playerTargetEnabled and selectedPlayerTarget and selectedPlayerTarget.Character and selectedPlayerTarget ~= LocalPlayer then
					if not isTeammate(selectedPlayerTarget) then
						targetModel, targetPlayer = selectedPlayerTarget.Character, selectedPlayerTarget
					else 
						targetModel = nil 
					end
				elseif selectedPart and selectedPart.Parent then
					targetModel = selectedPart:FindFirstAncestorOfClass("Model")
					if targetModel then
						local player = Players:GetPlayerFromCharacter(targetModel);
						if not player or not isTeammate(player) then 
							targetPlayer = player 
						else 
							targetModel = nil 
						end
					end
				elseif aiming and currentTarget then
					targetModel = currentTarget;
					targetPlayer = Players:GetPlayerFromCharacter(targetModel)
				end

				if targetModel then 
					aimPart = targetModel:FindFirstChild(partDropdown.Text) 
				end
				if selectedPart and selectedPart.Parent then 
					table.insert(partsToDrawESPFor, {Part = selectedPart, Color = Color3.fromRGB(90, 170, 255), Name = "SelectedESP"}) 
				end
				
				getgenv().ZukaSilentAimTarget = nil

				if aiming and aimPart and targetModel then
					if not wallCheckEnabled or isPartVisible(aimPart) then
						table.insert(partsToDrawESPFor, {Part = aimPart, Color = Color3.fromRGB(255, 80, 80), Name = "AimbotESP"});
						local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude;
						
						local predictionFactor = (distance / 2000) * (1 + (math.random(-50, 50) / 1000))
						local predictedPosition = aimPart.Position + (aimPart.AssemblyLinearVelocity * predictionFactor);

						if getgenv().silentAimEnabled then
							getgenv().ZukaSilentAimTarget = predictedPosition
						elseif smoothingEnabled then
							local goalCFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition)
							local adjustedSmoothFactor = math.clamp(1 - (1 - smoothingFactor) ^ (60 * deltaTime), 0, 1)
							Camera.CFrame = Camera.CFrame:Lerp(goalCFrame, adjustedSmoothFactor)
						else
							Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition)
						end;
						statusLabel.Text = "Aimbot: Targeting " .. (targetPlayer and targetPlayer.Name or targetModel.Name)
					else
						statusLabel.Text = "Aimbot: Target is behind a wall";
						currentTarget = nil
					end
				elseif aiming then
					statusLabel.Text = "Aimbot: No visible target in index"
				elseif not aiming and not selectedPart then
					statusLabel.Text = "Aimbot ready. Hold toggle key to aim."
				end

				for part, espBox in pairs(activeESPs) do
					local found = false;
					for _, data in ipairs(partsToDrawESPFor) do if data.Part == part then found = true; break end end;
					if not found or not part.Parent then clearESP(part) end
				end
				for _, data in ipairs(partsToDrawESPFor) do manageESP(data.Part, data.Color, data.Name) end
			end)
			
			silentAimToggle.MouseButton1Click:Connect(function() 
				getgenv().silentAimEnabled = not getgenv().silentAimEnabled; 
				silentAimToggle.Text = "Silent Aim: " .. (getgenv().silentAimEnabled and "ON" or "OFF") 
			end)
			ignoreTeamToggle.MouseButton1Click:Connect(function() 
				ignoreTeamEnabled = not ignoreTeamEnabled; 
				ignoreTeamToggle.Text = "Ignore Team: " .. (ignoreTeamEnabled and "ON" or "OFF") 
			end)
			wallCheckToggle.MouseButton1Click:Connect(function() 
				wallCheckEnabled = not wallCheckEnabled; 
				wallCheckToggle.Text = "Wall Check: " .. (wallCheckEnabled and "ON" or "OFF") 
			end)
			
			local indexerUpdateSignal = Instance.new("BindableEvent")
			
			ExplorerButton.MouseButton1Click:Connect(function()
				createExplorerWindow(statusLabel, indexerUpdateSignal)
			end)
			task.spawn(function()
				local function RebuildTargetIndex()
					local newIndex = {}
					if not getgenv().TargetScope or not getgenv().TargetScope.Parent then getgenv().TargetScope = Workspace end
					for _, descendant in ipairs(getgenv().TargetScope:GetDescendants()) do
						if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
							table.insert(newIndex, descendant)
						end
					end
					getgenv().TargetIndex = newIndex
				end
				
				indexerUpdateSignal.Event:Connect(RebuildTargetIndex)
				while task.wait(2) and MainScreenGui.Parent do
					RebuildTargetIndex()
				end
			end)
			indexerUpdateSignal:Fire()
		end
	end)

	if not success then
		warn("Failed to load Aimbot GUI:", err)
		if DoNotif then DoNotif("Error loading Aimbot: " .. tostring(err), 5) end
	end
end

RegisterCommand({ Name = "aimbot", Aliases = { "aim", "gamingchair", "a" }, Description = "Loads the advanced aimbot and ESP GUI." }, loadAimbotGUI)


Modules.Performance = {
    State = {
        IsEnabled = false,
        OriginalProperties = {}
    }
}

function Modules.Performance:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    self.State.OriginalProperties = {} -- Reset cache

    -- Services
    local lighting = game:GetService("Lighting")
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local materialService = game:GetService("MaterialService")

    -- Cache and modify Lighting properties
    self.State.OriginalProperties.Lighting = {
        Technology = lighting.Technology,
        GlobalShadows = lighting.GlobalShadows,
        EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = lighting.EnvironmentSpecularScale
    }
    lighting.Technology = Enum.Technology.Compatibility
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0
    lighting.EnvironmentSpecularScale = 0

    -- Cache and modify Terrain properties if it exists
    if terrain then
        self.State.OriginalProperties.Terrain = {
            Decoration = terrain.Decoration
        }
        terrain.Decoration = false
    end

    -- Cache and modify MaterialService properties
    self.State.OriginalProperties.MaterialService = {
        MaterialQuality = materialService.MaterialQuality
    }
    materialService.MaterialQuality = Enum.MaterialQuality.Low
	
	-- Cache and disable atmospheric effects
	self.State.OriginalProperties.LightingEffects = {}
	for _, effect in ipairs(lighting:GetChildren()) do
		if effect:IsA("Atmosphere") or effect:IsA("Clouds") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
			self.State.OriginalProperties.LightingEffects[effect] = {
				Enabled = effect.Enabled
			}
			effect.Enabled = false
		end
	end

    DoNotif("Performance Mode: ENABLED. Shadows and effects disabled.", 2)
end

function Modules.Performance:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Services
    local lighting = game:GetService("Lighting")
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local materialService = game:GetService("MaterialService")

    -- Restore Lighting properties safely
    if self.State.OriginalProperties.Lighting then
        for prop, value in pairs(self.State.OriginalProperties.Lighting) do
            pcall(function() lighting[prop] = value end)
        end
    end

    -- Restore Terrain properties safely
    if terrain and self.State.OriginalProperties.Terrain then
        for prop, value in pairs(self.State.OriginalProperties.Terrain) do
            pcall(function() terrain[prop] = value end)
        end
    end

    -- Restore MaterialService properties safely
    if self.State.OriginalProperties.MaterialService then
        for prop, value in pairs(self.State.OriginalProperties.MaterialService) do
            pcall(function() materialService[prop] = value end)
        end
    end
	
	-- Restore atmospheric effects
	if self.State.OriginalProperties.LightingEffects then
		for effect, props in pairs(self.State.OriginalProperties.LightingEffects) do
			if effect and effect.Parent then -- Check if effect still exists
				pcall(function() effect.Enabled = props.Enabled end)
			end
		end
	end

    self.State.OriginalProperties = {} -- Clear cache
    DoNotif("Performance Mode: DISABLED. Graphics restored.", 2)
end

function Modules.Performance:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "fpsboost", Aliases = { "noshadows", "performance" }, Description = "Toggles performance mode by disabling shadows and other intensive graphical features." }, function()
    Modules.Performance:Toggle()
end)

Modules.AstralProjection = {
    State = {
        isProjecting = false,
        isSpawning = false,
        originalHRP = nil,
        originalParent = nil,
        deathConnection = nil,
        positionMarker = nil
    },
    Config = {
        TOGGLE_KEY = Enum.KeyCode.M,
        SPAWN_PROTECTION_DURATION = 2
    },
    GUI = {},
    Services = {}
}

function Modules.AstralProjection:_applyVisuals(character, isAstral)
    local highlight = character:FindFirstChild("AstralHighlight")
    if isAstral and not highlight then
        highlight = Instance.new("Highlight", character)
        highlight.Name = "AstralHighlight"
        highlight.FillColor = Color3.fromRGB(0, 200, 255)
        highlight.OutlineColor = Color3.fromRGB(200, 255, 255)
        highlight.FillTransparency = 0.5
    elseif not isAstral and highlight then
        highlight:Destroy()
    end
end

function Modules.AstralProjection:_setState(shouldProject)
    if self.State.isSpawning then
        print("Desync: Cannot toggle while spawning.")
        return
    end
    if self.State.isProjecting == shouldProject then return end

    local character = self.Services.LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if shouldProject then
        if not hrp or not humanoid or not hrp.Parent then return end

        --// --- UNIFIED DESYNC METHOD: Un-parent the HRP ---
        -- 1. Store critical references before making changes.
        self.State.originalHRP = hrp
        self.State.originalParent = character
        local originalCFrame = hrp.CFrame -- Capture CFrame before desyncing.

        -- 2. Perform the desync action. This is the only line that causes the desync.
        self.State.originalHRP.Parent = nil

        -- 3. Update internal state and create visuals.
        self.State.isProjecting = true

        if self.State.positionMarker then self.State.positionMarker:Destroy() end
        local marker = Instance.new("Part")
        marker.Name = "PhysicalAnchor"
        marker.Size = Vector3.new(4, 5, 2)
        marker.CFrame = originalCFrame -- Use the captured CFrame for perfect accuracy.
        marker.Anchored = true -- The MARKER is anchored, not the player.
        marker.CanCollide = false
        marker.Transparency = 0.7
        marker.Parent = self.Services.Workspace
        self.State.positionMarker = marker

        local highlight = Instance.new("Highlight", marker)
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6

        humanoid:ChangeState(Enum.HumanoidStateType.Running)

        self:_applyVisuals(character, true)
        self.GUI.statusLabel.Text = "Desync: ENABLED"
        DoNotif("Desync: ENABLED", 1.5)

    else
        -- Check if we have valid data to restore from.
        if not self.State.originalHRP or not self.State.originalParent or not self.State.originalParent.Parent then
            self.State.isProjecting = false -- Force reset state if invalid.
            return
        end

        if self.State.positionMarker then
            self.State.positionMarker:Destroy()
            self.State.positionMarker = nil
        end
        

        self.State.originalHRP.Parent = self.State.originalParent
        
        -- Clean up state variables *after* re-syncing.
        self.State.isProjecting = false
        self.State.originalHRP = nil
        self.State.originalParent = nil

        self:_applyVisuals(character, false)
        self.GUI.statusLabel.Text = "Desync: DISABLED"
        DoNotif("Desync: DISABLED", 1.5)
    end
end

function Modules.AstralProjection:_onDied()
    print("Desync: Death detected. Forcing resynchronization...")
    self:_setState(false)
end

function Modules.AstralProjection:_onCharacterAdded(character)
    self.State.isSpawning = true
    self.GUI.statusLabel.Text = "Desync: RESPAWNING..."

    if self.State.isProjecting then self:_setState(false) end
    if self.State.deathConnection then self.State.deathConnection:Disconnect() end

    local humanoid = character:WaitForChild("Humanoid")
    self.State.deathConnection = humanoid.Died:Connect(function() self:_onDied() end)

    task.wait(self.Config.SPAWN_PROTECTION_DURATION)
    self.State.isSpawning = false
    self.GUI.statusLabel.Text = "Desync: DISABLED"
end

function Modules.AstralProjection:Toggle()
    self:_setState(not self.State.isProjecting)
end

function Modules.AstralProjection:Initialize()
    --// --- SERVICES & CORE VARIABLES ---
    self.Services.Players = game:GetService("Players")
    self.Services.UserInputService = game:GetService("UserInputService")
    self.Services.RunService = game:GetService("RunService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer
    local PLAYER_GUI = self.Services.LocalPlayer:WaitForChild("PlayerGui")

    --// --- GUI ELEMENTS ---
    local screenGui = Instance.new("ScreenGui", PLAYER_GUI)
    screenGui.Name = "AstralStatusGUI"
    screenGui.ResetOnSpawn = false
    self.GUI.screenGui = screenGui

    local statusLabel = Instance.new("TextLabel", screenGui)
    statusLabel.Size = UDim2.new(0, 250, 0, 30)
    statusLabel.Position = UDim2.new(0.5, -125, 0, 150)
    statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statusLabel.BackgroundTransparency = 0.3
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Text = "Astral Projection: DISABLED"
    self.GUI.statusLabel = statusLabel

    --// --- EVENT CONNECTIONS ---
    self.Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or input.KeyCode ~= self.Config.TOGGLE_KEY then return end
        self:Toggle()
    end)

    if self.Services.LocalPlayer.Character then
        self:_onCharacterAdded(self.Services.LocalPlayer.Character)
    end
    self.Services.LocalPlayer.CharacterAdded:Connect(function(character)
        self:_onCharacterAdded(character)
    end)

    print("--- Astral Projection V10 (Anchor Core) Module Initialized ---")
end


RegisterCommand({
    Name = "astral",
    Aliases = {"desync", "unsync"},
    Description = "Toggles astral projection, desyncing yourself remaining invisible to others."
}, function()
    Modules.AstralProjection:Toggle()
end)

Modules.AnchorSelf = {
    State = {
        IsEnabled = false,
        CharacterAddedConnection = nil
    }
}

function Modules.AnchorSelf:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function applyAnchor(character)
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            hrp.Anchored = true
        end
    end

    if LocalPlayer.Character then
        applyAnchor(LocalPlayer.Character)
    end

    self.State.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(applyAnchor)
    DoNotif("Self Anchor: ENABLED.", 2)
end

function Modules.AnchorSelf:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
    end

    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end
    DoNotif("Self Anchor: DISABLED.", 2)
end

function Modules.AnchorSelf:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "anchor", Aliases = { "lock", "lockpos" }, Description = "Toggles anchoring your character in place." }, function()
    Modules.AnchorSelf:Toggle()
end)

Modules.AutoComplete = {};
function Modules.AutoComplete:GetMatches(prefix)
    local matches = {}
    if typeof(prefix) ~= "string" or #prefix == 0 then return matches end
        prefix = prefix:lower()
        for cmdName, _ in pairs(Commands) do
            if cmdName:sub(1, #prefix) == prefix then
                table.insert(matches, cmdName)
            end
        end
        table.sort(matches)
        return matches
    end
Modules.CommandList = {
    State = {
        UI = nil,
        IsEnabled = false,
        IsMinimized = false,
        IsAnimating = false,
    },
}

function Modules.CommandList:Initialize()
    local self = self
    local ui = Instance.new("ScreenGui")
    ui.Name = "CommandListUI_v7_Radiant"
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.Enabled = false
    self.State.UI = ui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(450, 350)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(34, 32, 38)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local uiStroke = Instance.new("UIStroke", mainFrame)
    uiStroke.Color = Color3.fromRGB(255, 105, 180) -- Hot Pink
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
    
    local canvasGroup = Instance.new("CanvasGroup", mainFrame)
    canvasGroup.Name = "Canvas"
    canvasGroup.Size = UDim2.fromScale(1, 1)
    canvasGroup.BackgroundTransparency = 1
    canvasGroup.GroupTransparency = 1

    local title = Instance.new("TextLabel", canvasGroup)
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Command List"
    title.TextColor3 = Color3.fromRGB(255, 182, 193)
    title.TextSize = 20

    local closeButton = Instance.new("TextButton", canvasGroup)
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.fromOffset(25, 25)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -10, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.MouseButton1Click:Connect(function() self:Toggle() end)

    local minimizeButton = Instance.new("TextButton", canvasGroup)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.fromOffset(25, 25)
    minimizeButton.AnchorPoint = Vector2.new(1, 0)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 24

    local scrollingFrame = Instance.new("ScrollingFrame", canvasGroup)
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = UDim2.fromOffset(10, 40)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    -- [FIX] Removed invalid ScrollBarBackgroundColor3 property
    
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 5)

    local function drag(input)
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
                moveConn:Disconnect()
                endConn:Disconnect()
            end
        end)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag(input) end
    end)

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    minimizeButton.MouseButton1Click:Connect(function()
        self.State.IsMinimized = not self.State.IsMinimized
        local goalSize
        if self.State.IsMinimized then
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 40)
            minimizeButton.Text = "+"
            scrollingFrame.Visible = false
        else
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 350)
            minimizeButton.Text = "-"
            scrollingFrame.Visible = true
        end
        TweenService:Create(mainFrame, tweenInfo, { Size = goalSize }):Play()
    end)
    ui.Parent = CoreGui
end

function Modules.CommandList:Populate()
    local scrollingFrame = self.State.UI.MainFrame.Canvas:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return end
    
    scrollingFrame:ClearAllChildren()
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 8)

    -- [FIX] This connection automatically updates the scrollable area to fit all content.
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
    end)

    table.sort(CommandInfo, function(a, b) return a.Name < b.Name end)

    for _, info in ipairs(CommandInfo) do
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = info.Name .. "_Entry"
        entryFrame.BackgroundTransparency = 0.8
        entryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        entryFrame.Size = UDim2.new(1, 0, 0, 0)
        entryFrame.AutomaticSize = Enum.AutomaticSize.Y
        entryFrame.Parent = scrollingFrame
        Instance.new("UICorner", entryFrame).CornerRadius = UDim.new(0, 6)
        local frameLayout = Instance.new("UIListLayout", entryFrame)
        frameLayout.Padding = UDim.new(0, 5)
        local framePadding = Instance.new("UIPadding", entryFrame)
        framePadding.PaddingLeft = UDim.new(0, 10)
        framePadding.PaddingRight = UDim.new(0, 10)
        framePadding.PaddingTop = UDim.new(0, 8)
        framePadding.PaddingBottom = UDim.new(0, 8)

        local entry = Instance.new("TextLabel")
        entry.Name = info.Name
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.BackgroundTransparency = 1
        entry.Font = Enum.Font.Gotham
        entry.TextSize = 15
        entry.RichText = true
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.TextWrapped = true
        entry.Parent = entryFrame

        local aliases = ""
        if info.Aliases and #info.Aliases > 0 then
            aliases = string.format("<font size='12' color='#AAAAAA'><i>(%s)</i></font>", table.concat(info.Aliases, ", "))
        end
        
        local description = info.Description or "No description provided."

        entry.Text = string.format(
            "<font face='GothamBold' color='#FF69B4'>;%s</font> %s\n<font face='Gotham' size='13' color='#E0E0E0'>  %s</font>",
            info.Name,
            aliases,
            description
        )
    end
end

function Modules.CommandList:Toggle()
    if self.State.IsAnimating then return end
    self.State.IsAnimating = true
    self.State.IsEnabled = not self.State.IsEnabled
    
    local mainFrame = self.State.UI.MainFrame
    local canvasGroup = mainFrame.Canvas
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if self.State.IsEnabled then
        self.State.UI.Enabled = true
        if self.State.IsMinimized then
            self.State.IsMinimized = false
            mainFrame.Size = UDim2.fromOffset(450, 350)
            mainFrame.Canvas.ScrollingFrame.Visible = true
            mainFrame.Canvas.MinimizeButton.Text = "-"
        end
        self:Populate()
        mainFrame.Size = UDim2.fromOffset(450, 320)
        canvasGroup.GroupTransparency = 1
        local sizeAnim = TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.fromOffset(450, 350) })
        local fadeAnim = TweenService:Create(canvasGroup, tweenInfo, { GroupTransparency = 0 })
        sizeAnim:Play()
        fadeAnim:Play()
        fadeAnim.Completed:Connect(function() self.State.IsAnimating = false end)
    else
        local sizeAnim = TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.fromOffset(450, 320) })
        local fadeAnim = TweenService:Create(canvasGroup, tweenInfo, { GroupTransparency = 1 })
        sizeAnim:Play()
        fadeAnim:Play()
        fadeAnim.Completed:Connect(function()
            self.State.UI.Enabled = false
            self.State.IsAnimating = false
        end)
    end
end
Modules.CommandBar = {
    State = {
        UI = nil,
        TextBox = nil,
        SuggestionsFrame = nil,
        KeybindConnection = nil,
        PrefixKey = Enum.KeyCode.Comma,
        IsAnimating = false,
        IsEnabled = false
    }
}

function Modules.CommandBar:Toggle()
    if self.State.IsAnimating then return end
    self.State.IsAnimating = true
    self.State.IsEnabled = not self.State.IsEnabled
    local isOpening = self.State.IsEnabled
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    if isOpening then
        self.State.UI.Enabled = true
        self.State.Container.Position = UDim2.fromScale(0.5, 0.82)
        self.State.Container.BackgroundTransparency = 1
        local anim = TweenService:Create(self.State.Container, tweenInfo, {
            Position = UDim2.fromScale(0.5, 0.8),
            BackgroundTransparency = 1
        })
        anim:Play()
        self.State.TextBox:CaptureFocus()
        task.spawn(function()
            task.wait()
            if self.State.IsEnabled then
                self.State.TextBox.Text = ""
            end
        end)
        anim.Completed:Connect(function()
            self.State.IsAnimating = false
        end)
    else
        self.State.TextBox:ReleaseFocus()
        self:_ClearSuggestions()
        local anim = TweenService:Create(self.State.Container, tweenInfo, {
            Position = UDim2.fromScale(0.5, 0.82),
            BackgroundTransparency = 1
        })
        anim:Play()
        anim.Completed:Connect(function()
            self.State.UI.Enabled = false
            self.State.IsAnimating = false
        end)
    end
end

function Modules.CommandBar:_ClearSuggestions()
    if not self.State.SuggestionsFrame then return end
    self.State.SuggestionsFrame.Visible = false
    for _, child in ipairs(self.State.SuggestionsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

function Modules.CommandBar:Initialize()
    local self = self
    -- Services needed for logic
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    -- UI Instances
    local CommandBarUI_Revamped = Instance.new("ScreenGui")
    local Container = Instance.new("Frame")
    local InputFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Input = Instance.new("TextBox")
    local Suggestions = Instance.new("ScrollingFrame")
    local UICorner_2 = Instance.new("UICorner")
    local UIListLayout = Instance.new("UIListLayout")
    local LeftLine = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local RightLine = Instance.new("Frame")
    local UIGradient_2 = Instance.new("UIGradient")
    
    -- Apply properties
    CommandBarUI_Revamped.Name = "CommandBarUI_Revamped"
    CommandBarUI_Revamped.Parent = CoreGui
    CommandBarUI_Revamped.ResetOnSpawn = false
    CommandBarUI_Revamped.Enabled = false
    
    Container.Name = "Container"
    Container.Parent = CommandBarUI_Revamped
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.BackgroundTransparency = 1.500
    Container.Position = UDim2.new(0.5, 0, 0.861910284, 0)
    Container.Size = UDim2.new(1, 0, 0.0838206634, 38)
    
    InputFrame.Name = "InputFrame"
    InputFrame.Parent = Container
    InputFrame.Active = true
    InputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    InputFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    InputFrame.BackgroundTransparency = 0.550
    InputFrame.BorderColor3 = Color3.fromRGB(35, 35, 35) -- Original border
    InputFrame.Position = UDim2.new(0.499780267, 0, 0.512794435, 0)
    InputFrame.Size = UDim2.new(0, 299, 0, 35)
    
    UICorner.Parent = InputFrame
    
    Input.Name = "Input"
    Input.Parent = InputFrame
    Input.AnchorPoint = Vector2.new(0.5, 0.5)
    Input.BackgroundTransparency = 1.000
    Input.Position = UDim2.new(0.5, 0, 0.5, 0)
    Input.Size = UDim2.new(1, -20, 1, -10)
    Input.Font = Enum.Font.GothamBold
    Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    Input.PlaceholderText = " "
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextSize = 15.000
    Input.ClearTextOnFocus = true
    
    Suggestions.Name = "Suggestions"
    Suggestions.Parent = InputFrame
    Suggestions.Visible = false
    Suggestions.AnchorPoint = Vector2.new(0.5, 0)
    Suggestions.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Suggestions.BackgroundTransparency = 0.360
    Suggestions.BorderSizePixel = 0
    Suggestions.Position = UDim2.new(0.5, 0, -3, 10)
    Suggestions.Size = UDim2.new(0, 204, 0, 86)
    Suggestions.ScrollBarThickness = 4
    
    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = Suggestions
    
    UIListLayout.Parent = Suggestions
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)
    
    -- [NEW] Updated Left and Right line colors
    LeftLine.Name = "LeftLine"
    LeftLine.Parent = Container
    LeftLine.AnchorPoint = Vector2.new(1, 0.5)
    LeftLine.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
    LeftLine.BackgroundTransparency = 0.450
    LeftLine.BorderSizePixel = 0
    LeftLine.Position = UDim2.new(0.503833711, -155, 0.500998974, 0)
    LeftLine.Size = UDim2.new(0.192698419, 0, 0.128545433, 2)
    
    UIGradient.Rotation = 180
    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.20), NumberSequenceKeypoint.new(1.00, 1.00)}
    UIGradient.Parent = LeftLine
    
    RightLine.Name = "RightLine"
    RightLine.Parent = Container
    RightLine.AnchorPoint = Vector2.new(0, 0.5)
    RightLine.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
    RightLine.BackgroundTransparency = 0.450
    RightLine.BorderSizePixel = 0
    RightLine.Position = UDim2.new(0.49474448, 155, 0.489924341, 0)
    RightLine.Size = UDim2.new(0.208382994, 0, -0.172840074, 2)
    
    UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.20), NumberSequenceKeypoint.new(1.00, 1.00)}
    UIGradient_2.Parent = RightLine

    -- [NEW] Radiant Glow Effect
    local GlowStroke = Instance.new("UIStroke")
    GlowStroke.Name = "GlowStroke"
    GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    GlowStroke.LineJoinMode = Enum.LineJoinMode.Round
    GlowStroke.Thickness = 2.5
    GlowStroke.Transparency = 0.5
    GlowStroke.Color = Color3.fromRGB(255, 182, 193) -- Light Pink
    GlowStroke.Parent = InputFrame

    -- Animation for the glow effect
    local glowConnection
    glowConnection = RunService.RenderStepped:Connect(function()
        if not GlowStroke or not GlowStroke.Parent then
            glowConnection:Disconnect()
            return
        end
        -- Use a sine wave for a smooth pulsating "breathing" effect
        local sine = math.sin(os.clock() * 5) -- Multiplier controls the speed
        GlowStroke.Transparency = 0.4 + (sine * 0.3) -- Pulsates between 0.1 and 0.7 transparency
        GlowStroke.Thickness = 2.5 + (sine * 0.5) -- Pulsates between 2 and 3 thickness
    end)
    
    -- Assign core components to the module's state
    self.State.UI = CommandBarUI_Revamped
    self.State.Container = Container
    self.State.TextBox = Input
    self.State.SuggestionsFrame = Suggestions
    
    -- Preserved logic from the original script
    local Theme = {
        SuggestionTextColor = Color3.fromRGB(210, 210, 220),
        SuggestionHoverColor = Color3.fromRGB(45, 45, 45),
        MainFont = Enum.Font.Gotham
    }
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Suggestions.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    end)
    
    self.State.IsScriptUpdatingText = false
    local MAX_SUGGESTIONS = 5
    
    local function createSuggestionButton(text)
        local button = Instance.new("TextButton")
        button.Name, button.Text, button.Parent = text, text, self.State.SuggestionsFrame
        button.TextSize, button.Font, button.TextColor3 = 14, Theme.MainFont, Theme.SuggestionTextColor
        button.TextXAlignment, button.BackgroundTransparency = Enum.TextXAlignment.Left, 1
        button.Size = UDim2.new(1, -10, 0, 24)
        local tweenInfo = TweenInfo.new(0.15)
        button.MouseEnter:Connect(function() TweenService:Create(button, tweenInfo, {BackgroundColor3 = Theme.SuggestionHoverColor, BackgroundTransparency = 0 }):Play() end)
        button.MouseLeave:Connect(function() TweenService:Create(button, tweenInfo, {BackgroundTransparency = 1 }):Play() end)
        
        button.MouseButton1Click:Connect(function()
            self.State.IsScriptUpdatingText = true
            self.State.TextBox.Text = text .. " "
            self.State.TextBox.CursorPosition = #self.State.TextBox.Text + 1
            self.State.TextBox:CaptureFocus()
            self.State.IsScriptUpdatingText = false
            self:_ClearSuggestions()
        end)
        return button
    end
    
    local function updateSuggestions()
        if self.State.IsScriptUpdatingText then return end
        self:_ClearSuggestions()
        local inputText = self.State.TextBox.Text:match("^%s*(%S*)")
        if not inputText or #inputText == 0 then return end
        local matches = Modules.AutoComplete:GetMatches(inputText)
        if #matches > 0 then
            self.State.SuggestionsFrame.Visible = true
            for i, match in ipairs(matches) do
                if i > MAX_SUGGESTIONS then break end
                createSuggestionButton(match)
            end
        end
    end
    
    self.State.TextBox.Changed:Connect(function(property) if property == "Text" then updateSuggestions() end end)
    
    local function submitCommand()
        if self.State.TextBox.Text:len() > 0 then
            processCommand(Prefix .. self.State.TextBox.Text)
            self.State.TextBox.Text = ""
            self:Toggle()
        end
    end
    
    self.State.TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitCommand()
        else
            task.wait(0.1)
            if self.State.IsEnabled then self:Toggle() end
        end
    end)
    
    self.State.TextBox.Focused:Connect(updateSuggestions)
    
    self.State.KeybindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.State.PrefixKey then self:Toggle() end
    end)
end
Modules.UnlockMouse = { State = { Enabled = false, Connection = nil } }
RegisterCommand({ Name = "UnlockMouse", Aliases = {"unlockcursor", "freemouse", "um"}, Description = "Toggles a persistent loop to unlock the mouse cursor." }, function()
local State = Modules.UnlockMouse.State
State.Enabled = not State.Enabled
if State.Enabled then
    if State.Connection then State.Connection:Disconnect() end
        State.Connection = RunService.RenderStepped:Connect(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
    DoNotif("Mouse Unlock Enabled", 2)
else
if State.Connection then State.Connection:Disconnect(); State.Connection = nil end
    DoNotif("Mouse Unlock Disabled", 2)
end
end)
Modules.ESP = {
    State = {
        PlayersEnabled = false,
        NpcsEnabled = false,
        Connections = {},
        TrackedPlayers = setmetatable({}, {__mode="k"}),
        TrackedNpcs = setmetatable({}, {__mode="k"})
    }
}

function Modules.ESP:_cleanup()
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    for _, data in pairs(self.State.TrackedPlayers) do pcall(function() data.Highlight:Destroy() end); pcall(function() data.Billboard:Destroy() end) end
    for _, data in pairs(self.State.TrackedNpcs) do pcall(function() data.Highlight:Destroy() end); pcall(function() data.Billboard:Destroy() end) end
    table.clear(self.State.Connections)
    table.clear(self.State.TrackedPlayers)
    table.clear(self.State.TrackedNpcs)
end

function Modules.ESP:_createPlayerEsp(player)
    if player == LocalPlayer or self.State.TrackedPlayers[player] then return end
    local function setupVisuals(character)
        if self.State.TrackedPlayers[player] then self.State.TrackedPlayers[player].Highlight:Destroy(); self.State.TrackedPlayers[player].Billboard:Destroy() end
        local head = character:WaitForChild("Head", 2)
        if not head then return end
        local highlight = Instance.new("Highlight", character)
        highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency, highlight.OutlineTransparency = 0.8, 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        local billboard = Instance.new("BillboardGui", head)
        billboard.Adornee, billboard.AlwaysOnTop, billboard.Size = head, true, UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size, nameLabel.Text, nameLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), player.Name, 1
        nameLabel.Font, nameLabel.TextSize, nameLabel.TextColor3 = Enum.Font.Code, 18, Color3.fromRGB(255, 255, 255)
        local teamLabel = Instance.new("TextLabel", billboard)
        teamLabel.Size, teamLabel.Position, teamLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), 1
        teamLabel.Font, teamLabel.TextSize = Enum.Font.Code, 14
        teamLabel.Text = player.Team and player.Team.Name or "No Team"
        teamLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(200, 200, 200)
        self.State.TrackedPlayers[player] = { Highlight = highlight, Billboard = billboard, CharacterAddedConn = nil }
    end
    if player.Character then setupVisuals(player.Character) end
    local conn = player.CharacterAdded:Connect(setupVisuals)
    if self.State.TrackedPlayers[player] then self.State.TrackedPlayers[player].CharacterAddedConn = conn end
end

function Modules.ESP:_removePlayerEsp(player)
    if not self.State.TrackedPlayers[player] then return end
    pcall(function() self.State.TrackedPlayers[player].Highlight:Destroy() end)
    pcall(function() self.State.TrackedPlayers[player].Billboard:Destroy() end)
    if self.State.TrackedPlayers[player].CharacterAddedConn then self.State.TrackedPlayers[player].CharacterAddedConn:Disconnect() end
    self.State.TrackedPlayers[player] = nil
end

function Modules.ESP:_onHeartbeat()
    if not self.State.NpcsEnabled then return end
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    
    -- Update existing NPCs, remove dead/gone ones
    for model, data in pairs(self.State.TrackedNpcs) do
        if not model.Parent or data.Humanoid.Health <= 0 then
            pcall(function() data.Highlight:Destroy() end)
            pcall(function() data.Billboard:Destroy() end)
            self.State.TrackedNpcs[model] = nil
        elseif myRoot and data.InfoLabel then
            local dist = math.floor((myRoot.Position - data.RootPart.Position).Magnitude)
            data.InfoLabel.Text = string.format("HP: %.0f | Dist: %dm", data.Humanoid.Health, dist)
        end
    end
    
    -- Scan for new NPCs
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and not self.State.TrackedNpcs[model] then
            if not Players:GetPlayerFromCharacter(model) then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart and humanoid.Health > 0 then
                    local highlight = Instance.new("Highlight", model)
                    highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 0, 0)
                    highlight.FillTransparency, highlight.OutlineTransparency = 0.7, 0.4
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    local billboard = Instance.new("BillboardGui", rootPart)
                    billboard.Adornee, billboard.AlwaysOnTop, billboard.Size = rootPart, true, UDim2.fromOffset(150, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    local nameLabel = Instance.new("TextLabel", billboard)
                    nameLabel.Size, nameLabel.Text, nameLabel.Font, nameLabel.TextSize, nameLabel.TextColor3, nameLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), model.Name, Enum.Font.Code, 16, Color3.fromRGB(255, 255, 255), 1
                    local infoLabel = Instance.new("TextLabel", billboard)
                    infoLabel.Size, infoLabel.Position, infoLabel.Font, infoLabel.TextSize, infoLabel.TextColor3, infoLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), Enum.Font.Code, 14, Color3.fromRGB(200, 200, 200), 1
                    self.State.TrackedNpcs[model] = { Highlight = highlight, Billboard = billboard, Humanoid = humanoid, RootPart = rootPart, InfoLabel = infoLabel }
                end
            end
        end
    end
end

function Modules.ESP:Toggle(argument)
    argument = (argument or "players"):lower()

    if argument == "players" or argument == "p" then
        -- This block is for toggling ESP for ALL players (original functionality)
        self.State.PlayersEnabled = not self.State.PlayersEnabled
        DoNotif("Player ESP: " .. (self.State.PlayersEnabled and "ENABLED" or "DISABLED"), 2)
        if self.State.PlayersEnabled then
            for _, player in ipairs(Players:GetPlayers()) do self:_createPlayerEsp(player) end
            self.State.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(p) self:_createPlayerEsp(p) end)
            self.State.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p) self:_removePlayerEsp(p) end)
        else
            if self.State.Connections.PlayerAdded then self.State.Connections.PlayerAdded:Disconnect(); self.State.Connections.PlayerAdded = nil end
            if self.State.Connections.PlayerRemoving then self.State.Connections.PlayerRemoving:Disconnect(); self.State.Connections.PlayerRemoving = nil end
            for player, _ in pairs(self.State.TrackedPlayers) do self:_removePlayerEsp(player) end
        end
    elseif argument == "npcs" or argument == "npc" or argument == "ai" then
        -- This block is for toggling ESP for NPCs (original functionality)
        self.State.NpcsEnabled = not self.State.NpcsEnabled
        DoNotif("NPC ESP: " .. (self.State.NpcsEnabled and "ENABLED" or "DISABLED"), 2)
        if not self.State.NpcsEnabled then
            for model, _ in pairs(self.State.TrackedNpcs) do
                pcall(function() self.State.TrackedNpcs[model].Highlight:Destroy() end)
                pcall(function() self.State.TrackedNpcs[model].Billboard:Destroy() end)
                self.State.TrackedNpcs[model] = nil
            end
        end
    else
        -- [NEW] This block handles targeting a SINGLE player.
        local targetPlayer = Utilities.findPlayer(argument)
        if not targetPlayer then
            return DoNotif("Player '" .. argument .. "' not found.", 3)
        end

        -- Check if we are already tracking this specific player to toggle them off.
        if self.State.TrackedPlayers[targetPlayer] then
            self:_removePlayerEsp(targetPlayer)
            DoNotif("ESP for " .. targetPlayer.Name .. ": DISABLED", 2)
        else
            -- Otherwise, create ESP for just this player.
            self:_createPlayerEsp(targetPlayer)
            DoNotif("ESP for " .. targetPlayer.Name .. ": ENABLED", 2)
        end
    end

    -- Manage the master Heartbeat connection (no changes needed here)
    local isAnyEspActive = self.State.PlayersEnabled or self.State.NpcsEnabled or next(self.State.TrackedPlayers)
    if isAnyEspActive and not self.State.Connections.Heartbeat then
        self.State.Connections.Heartbeat = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    elseif not isAnyEspActive and self.State.Connections.Heartbeat then
        self.State.Connections.Heartbeat:Disconnect()
        self.State.Connections.Heartbeat = nil
    end
end

RegisterCommand({
    Name = "esp",
    Aliases = {},
    Description = "Toggles ESP."
}, function(args)
    Modules.ESP:Toggle(args[1])
end)

        Modules.ClickTP = { State = { IsActive = false, Connection = nil } };
        function Modules.ClickTP:Toggle()
            self.State.IsActive = not self.State.IsActive
            local UserInputService = game:GetService("UserInputService")
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            if self.State.IsActive then
                self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                        local camera = Workspace.CurrentCamera
                        local mousePos = UserInputService:GetMouseLocation()
                        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                        if result and result.Position then
                            hrp.CFrame = CFrame.new(result.Position) + Vector3.new(0, 3, 0)
                        end
                    end
                end)
                DoNotif("Click TP Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Click TP Disabled", 2)
        end
    end
    RegisterCommand({Name = "clicktp", Aliases = {}, Description = "Hold Left CTRL and click to teleport."}, function(args)
    Modules.ClickTP:Toggle(args)
end)
Modules.HighlightPlayer = { State = { TargetPlayer = nil, HighlightInstance = nil, CharacterAddedConnection = nil } }
local function findFirstPlayer(partialName)
local lowerPartialName = string.lower(partialName)
for _, player in ipairs(Players:GetPlayers()) do
    if string.lower(player.Name):sub(1, #lowerPartialName) == lowerPartialName then return player end
    end
    return nil
end
function Modules.HighlightPlayer:ApplyHighlight(character)
    if not character then return end
        if self.State.HighlightInstance then self.State.HighlightInstance:Destroy() end
            local highlight = Instance.new("Highlight", character)
            highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency, highlight.OutlineTransparency = 0.7, 0.2
            self.State.HighlightInstance = highlight
        end
        function Modules.HighlightPlayer:ClearHighlight()
            if self.State.HighlightInstance then self.State.HighlightInstance:Destroy(); self.State.HighlightInstance = nil end
                if self.State.CharacterAddedConnection then self.State.CharacterAddedConnection:Disconnect(); self.State.CharacterAddedConnection = nil end
                    if self.State.TargetPlayer then DoNotif("Highlight cleared from: " .. self.State.TargetPlayer.Name, 2); self.State.TargetPlayer = nil end
                    end
                    RegisterCommand({ Name = "highlight", Aliases = {"find", "findplayer"}, Description = "Highlights a player." }, function(args)
                    local argument = args[1]
                    if not argument then DoNotif("Usage: highlight <PlayerName|clear>", 3); return end
                        if string.lower(argument) == "clear" or string.lower(argument) == "reset" then Modules.HighlightPlayer:ClearHighlight(); return end
                            local targetPlayer = findFirstPlayer(argument)
                            if not targetPlayer then DoNotif("Player '" .. argument .. "' not found.", 3); return end
                                Modules.HighlightPlayer:ClearHighlight()
                                Modules.HighlightPlayer.State.TargetPlayer = targetPlayer
                                DoNotif("Now highlighting: " .. targetPlayer.Name, 2)
                                if targetPlayer.Character then Modules.HighlightPlayer:ApplyHighlight(targetPlayer.Character) end
                                    Modules.HighlightPlayer.State.CharacterAddedConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter) Modules.HighlightPlayer:ApplyHighlight(newCharacter) end)
                                end)
                                Modules.FovChanger = {
                                State = {
                                IsEnabled = false,
                                TargetFov = 70,
                                DefaultFov = 70,
                                Connection = nil
                                }
                                }
                                local function updateFovOnRenderStep()
                                local camera = Workspace.CurrentCamera
                                local state = Modules.FovChanger.State
                                if camera and state.IsEnabled and camera.FieldOfView ~= state.TargetFov then
                                    camera.FieldOfView = state.TargetFov
                                end
                            end
                            local function enableFovLock()
                            local state = Modules.FovChanger.State
                            if not state.Connection then
                                state.Connection = RunService.RenderStepped:Connect(updateFovOnRenderStep)
                            end
                            state.IsEnabled = true
                        end
                        local function disableFovLock()
                        local state = Modules.FovChanger.State
                        state.IsEnabled = false
                        if state.Connection then
                            state.Connection:Disconnect()
                            state.Connection = nil
                        end
                    end
                    pcall(function()
                    Modules.FovChanger.State.DefaultFov = Workspace.CurrentCamera.FieldOfView
                end)
                RegisterCommand({ Name = "fov", Aliases = {"fieldofview", "camfov"}, Description = "Changes and locks FOV." }, function(args)
                local camera = Workspace.CurrentCamera
                if not camera then
                    DoNotif("Could not find camera.", 3)
                    return
                end
                local argument = args[1]
                if not argument then
                    DoNotif("Current FOV is: " .. camera.FieldOfView, 3)
                    return
                end
                if string.lower(argument) == "reset" then
                    disableFovLock()
                    camera.FieldOfView = Modules.FovChanger.State.DefaultFov
                    DoNotif("FOV lock disabled and reset to " .. Modules.FovChanger.State.DefaultFov, 2)
                    return
                end
                local newFov = tonumber(argument)
                if not newFov then
                    DoNotif("Invalid argument. Provide a number or 'reset'.", 3)
                    return
                end
                local clampedFov = math.clamp(newFov, 1, 120)
                Modules.FovChanger.State.TargetFov = clampedFov
                enableFovLock()
                DoNotif("FOV locked to " .. clampedFov, 2)
            end)
            RegisterCommand({ Name = "cmds", Aliases = {"commands", "help"}, Description = "Opens a UI that lists all available commands." }, function()
            Modules.CommandList:Toggle()
        end)
        Modules.Fly = {
        State = {
        IsActive = false,
        Speed = 60,
        SprintMultiplier = 2.5,
        Connections = {},
        BodyMovers = {}
        }
        }
        function Modules.Fly:SetSpeed(s)
            local n = tonumber(s)
            if n and n > 0 then
                self.State.Speed = n
                DoNotif("Fly speed set to: " .. n, 1)
            else
            DoNotif("Invalid speed.", 1)
        end
    end
    function Modules.Fly:Disable()
        if not self.State.IsActive then return end
            self.State.IsActive = false
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.PlatformStand = false end
                for _, mover in pairs(self.State.BodyMovers) do
                    if mover and mover.Parent then
                        mover:Destroy()
                    end
                end
                for _, connection in ipairs(self.State.Connections) do
                    connection:Disconnect()
                end
                table.clear(self.State.BodyMovers)
                table.clear(self.State.Connections)
                DoNotif("Fly disabled.", 1)
            end
            function Modules.Fly:Enable()
                local self = self
                if self.State.IsActive then return end
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if not (hrp and humanoid) then
                        DoNotif("Character required.", 1)
                        return
                    end
                    self.State.IsActive = true
                    DoNotif("Fly Enabled.", 1)
                    humanoid.PlatformStand = true
                    local hrpAttachment = Instance.new("Attachment", hrp)
                    local worldAttachment = Instance.new("Attachment", workspace.Terrain)
                    worldAttachment.WorldCFrame = hrp.CFrame
                    local alignOrientation = Instance.new("AlignOrientation")
                    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    alignOrientation.Attachment0 = hrpAttachment
                    alignOrientation.Responsiveness = 200
                    alignOrientation.MaxTorque = math.huge
                    alignOrientation.Parent = hrp
                    local linearVelocity = Instance.new("LinearVelocity")
                    linearVelocity.Attachment0 = hrpAttachment
                    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                    linearVelocity.MaxForce = math.huge
                    linearVelocity.VectorVelocity = Vector3.zero
                    linearVelocity.Parent = hrp
                    self.State.BodyMovers.HRPAttachment = hrpAttachment
                    self.State.BodyMovers.WorldAttachment = worldAttachment
                    self.State.BodyMovers.AlignOrientation = alignOrientation
                    self.State.BodyMovers.LinearVelocity = linearVelocity
                    local keys = {}
                    local function onInput(input, gameProcessed)
                    if not gameProcessed then
                        keys[input.KeyCode] = (input.UserInputState == Enum.UserInputState.Begin)
                    end
                end
                table.insert(self.State.Connections, UserInputService.InputBegan:Connect(onInput))
                table.insert(self.State.Connections, UserInputService.InputEnded:Connect(onInput))
                local loop = RunService.RenderStepped:Connect(function()
                if not self.State.IsActive or not hrp.Parent then return end
                    local camera = workspace.CurrentCamera
                    alignOrientation.CFrame = camera.CFrame
                    local direction = Vector3.new()
                    if keys[Enum.KeyCode.W] then direction += camera.CFrame.LookVector end
                        if keys[Enum.KeyCode.S] then direction -= camera.CFrame.LookVector end
                            if keys[Enum.KeyCode.D] then direction += camera.CFrame.RightVector end
                                if keys[Enum.KeyCode.A] then direction -= camera.CFrame.RightVector end
                                    if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then direction += Vector3.yAxis end
                                        if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.Q] then direction -= Vector3.yAxis end
                                            local speed = keys[Enum.KeyCode.LeftShift] and self.State.Speed * self.State.SprintMultiplier or self.State.Speed
                                            linearVelocity.VectorVelocity = direction.Magnitude > 0 and direction.Unit * speed or Vector3.zero
                                        end)
                                        table.insert(self.State.Connections, loop)
                                    end
                                    function Modules.Fly:Toggle()
                                        if self.State.IsActive then
                                            self:Disable()
                                        else
                                        self:Enable()
                                    end
                                end
                                RegisterCommand({ Name = "fly", Aliases = {"flight"}, Description = "Toggles smooth flight mode." }, function()
                                Modules.Fly:Toggle()
                            end)
Modules.NoClip = {
    State = {
        IsEnabled = false,
        Connections = {},
        -- A table to keep track of all character parts that need noclip enforced.
        -- Using a dictionary/set is highly efficient for the per-frame loop.
        TrackedParts = setmetatable({}, {__mode = "k"})
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

---
-- [Private] Adds a part to the tracking list and sets its collision to false.
---
function Modules.NoClip:_addPart(part)
    if not part:IsA("BasePart") then return end
    self.State.TrackedParts[part] = true
    part.CanCollide = false
end

---
-- [Private] Scans a character, adds all its parts to the tracking list,
-- and sets up listeners for new parts (like tools) being added.
---
function Modules.NoClip:_processCharacter(character)
    if not character then return end
    
    -- Clean up any existing listeners for this character to prevent duplicates
    if self.State.Connections[character] then
        for _, conn in ipairs(self.State.Connections[character]) do conn:Disconnect() end
    end
    self.State.Connections[character] = {}

    -- Process all parts that already exist in the character
    for _, descendant in ipairs(character:GetDescendants()) do
        self:_addPart(descendant)
    end
    
    -- Listen for parts that are added while noclip is active (e.g., equipping a tool)
    local descAddedConn = character.DescendantAdded:Connect(function(descendant)
        self:_addPart(descendant)
    end)
    
    -- Listen for parts being removed to stop tracking them
    local descRemovingConn = character.DescendantRemoving:Connect(function(descendant)
        if self.State.TrackedParts[descendant] then
            self.State.TrackedParts[descendant] = nil
        end
    end)
    
    table.insert(self.State.Connections[character], descAddedConn)
    table.insert(self.State.Connections[character], descRemovingConn)
end


function Modules.NoClip:_cleanup()
    -- Disconnect all active connections
    for key, conn in pairs(self.State.Connections) do
        if type(conn) == "table" then -- Character-specific connections
            for _, innerConn in ipairs(conn) do innerConn:Disconnect() end
        else -- Main connections (Stepped, CharacterAdded, etc.)
            conn:Disconnect()
        end
    end
    table.clear(self.State.Connections)
    
    -- Restore original collision properties
    for part in pairs(self.State.TrackedParts) do
        if part and part.Parent then

            part.CanCollide = true
        end
    end
    table.clear(self.State.TrackedParts)
end


function Modules.NoClip:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer

    -- Apply to the current character immediately
    if localPlayer.Character then
        self:_processCharacter(localPlayer.Character)
    end

    -- Set up listeners for character respawns
    self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char)
        self:_processCharacter(char)
    end)


    self.State.Connections.Enforcer = self.Services.RunService.Stepped:Connect(function()
        for part in pairs(self.State.TrackedParts) do
            if part and part.Parent and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)

    DoNotif("Persistent NoClip Enabled", 2)
end

---
-- Disables the NoClip module and cleans up all resources.
---
function Modules.NoClip:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    self:_cleanup()
    
    DoNotif("NoClip Disabled", 2)
end

---
-- Toggles the NoClip state.
---
function Modules.NoClip:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- This part remains in your main script to register the command
RegisterCommand({ Name = "noclip", Aliases = {"nc"}, Description = "Allows you to fly through walls and objects." }, function()
    Modules.NoClip:Toggle()
end)

                                    Modules.AnimationFreezer = {
                                    State = {
                                    IsEnabled = false,
                                    CharacterConnection = nil,
                                    Originals = {}
                                    }
                                    }
                                    function Modules.AnimationFreezer:_applyFreeze(character)
                                        if not character or self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
                                                local animator = humanoid:FindFirstChildOfClass("Animator")
                                                if not animator then return end
                                                    self.State.Originals[character] = animator
                                                    local fakeAnimationTrack = {
                                                    IsPlaying = false,
                                                    Length = 0,
                                                    TimePosition = 0,
                                                    Speed = 0,
                                                    Play = function() end,
                                                    Stop = function() end,
                                                    Pause = function() end,
                                                    AdjustSpeed = function() end,
                                                    GetMarkerReachedSignal = function() return { Connect = function() end } end,
                                                    GetTimeOfKeyframe = function() return 0 end,
                                                    Destroy = function() end
                                                    }
                                                    local animatorProxy = {}
                                                    local animatorMetatable = {
                                                    __index = function(t, key)
                                                    if tostring(key):lower() == "loadanimation" then
                                                        return function()
                                                        return fakeAnimationTrack
                                                    end
                                                else
                                                return self.State.Originals[character][key]
                                            end
                                        end
                                        }
                                        setmetatable(animatorProxy, animatorMetatable)
                                        animator.Parent = nil
                                        animatorProxy.Name = "Animator"
                                        animatorProxy.Parent = humanoid
                                    end
                                    function Modules.AnimationFreezer:_removeFreeze(character)
                                        if not character or not self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
                                                local proxy = humanoid:FindFirstChild("Animator")
                                                local original = self.State.Originals[character]
                                                if proxy then proxy:Destroy() end
                                                    if original then original.Parent = humanoid end
                                                        self.State.Originals[character] = nil
                                                    end
                                                    function Modules.AnimationFreezer:Toggle()
                                                        self.State.IsEnabled = not self.State.IsEnabled
                                                        if self.State.IsEnabled then
                                                            DoNotif("Animation Freezer Enabled", 2)
                                                            if LocalPlayer.Character then
                                                                self:_applyFreeze(LocalPlayer.Character)
                                                            end
                                                            self.State.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                                                            task.wait(0.1)
                                                            self:_applyFreeze(character)
                                                        end)
                                                    else
                                                    DoNotif("Animation Freezer Disabled", 2)
                                                    if LocalPlayer.Character then
                                                        self:_removeFreeze(LocalPlayer.Character)
                                                    end
                                                    if self.State.CharacterConnection then
                                                        self.State.CharacterConnection:Disconnect()
                                                        self.State.CharacterConnection = nil
                                                    end
                                                    for char, animator in pairs(self.State.Originals) do
                                                        self:_removeFreeze(char)
                                                    end
                                                end
                                            end
                                            RegisterCommand({
                                            Name = "freezeanim",
                                            Aliases = {"noanim", "fa"},
                                            Description = "Freezes all local character animations to skip delays (e.g., weapon swings)."
                                            }, function()
                                            Modules.AnimationFreezer:Toggle()
                                        end)
                                        Modules.AutoDecompiler = {
                                        State = {
                                        IsEnabled = false,
                                        IsReady = false,
                                        Connections = {},
                                        LastAPICall = 0
                                        },
                                        API_URL = "http://api.plusgiant5.com"
                                        }
                                        function Modules.AutoDecompiler:_prepareDecompiler()
                                            if self.State.IsReady then return true end
                                                if not getscriptbytecode or not request then
                                                    warn("AutoDecompiler Error: 'getscriptbytecode' and/or 'request' are not available in this environment.")
                                                    return false
                                                end
                                                print("AutoDecompiler: Executor dependencies found. Ready.")
                                                self.State.IsReady = true
                                                return true
                                            end
                                            function Modules.AutoDecompiler:_decompileViaAPI(scriptObject)
                                                local success, bytecode = pcall(getscriptbytecode, scriptObject)
                                                if not success then
                                                    warn("AutoDecompiler:", scriptObject:GetFullName(), "- Failed to get bytecode:", tostring(bytecode))
                                                    return nil
                                                end
                                                local timeElapsed = os.clock() - self.State.LastAPICall
                                                if timeElapsed < 0.5 then
                                                    task.wait(0.5 - timeElapsed)
                                                end
                                                local success, httpResult = pcall(request, {
                                                Url = self.API_URL .. "/konstant/decompile",
                                                Body = bytecode,
                                                Method = "POST",
                                                Headers = { ["Content-Type"] = "text/plain" }
                                                })
                                                self.State.LastAPICall = os.clock()
                                                if not success then
                                                    warn("AutoDecompiler: request() function failed:", tostring(httpResult))
                                                    return nil
                                                end
                                                if httpResult and httpResult.StatusCode == 200 then
                                                    return httpResult.Body
                                                else
                                                warn("AutoDecompiler: API returned non-200 status:", httpResult.StatusCode, httpResult.Body)
                                                return nil
                                            end
                                        end
                                        function Modules.AutoDecompiler:Disable()
                                            DoNotif("Auto Decompiler Disabled.", 3)
                                            for _, connection in ipairs(self.State.Connections) do
                                                if connection.Connected then
                                                    connection:Disconnect()
                                                end
                                            end
                                            table.clear(self.State.Connections)
                                        end
                                        function Modules.AutoDecompiler:Enable()
                                            if not self:_prepareDecompiler() then
                                                DoNotif("Decompiler dependencies not met. Check console.", 5)
                                                self.State.Enabled = false
                                                return
                                            end
                                            DoNotif("Auto Decompiler Enabled. Sweeping existing scripts...", 4)
                                            local function processScript(script)
                                            local decompiledSource = self:_decompileViaAPI(script)
                                            if decompiledSource then
                                                local success, err = pcall(function() script.Source = decompiledSource end)
                                                if not success then
                                                    warn("Could not set source for", script:GetFullName(), "- it may be read-only. Error:", err)
                                                end
                                            end
                                        end
                                        task.spawn(function()
                                        for _, descendant in ipairs(game:GetDescendants()) do
                                            if descendant:IsA("LuaSourceContainer") then
                                                processScript(descendant)
                                                task.wait()
                                            end
                                        end
                                        print("Initial script sweep completed.")
                                    end)
                                    local conn = game.DescendantAdded:Connect(function(descendant)
                                    if descendant:IsA("LuaSourceContainer") then
                                        print("New script detected:", descendant:GetFullName())
                                        processScript(descendant)
                                    end
                                end)
                                table.insert(self.State.Connections, conn)
                            end
                            function Modules.AutoDecompiler:Toggle()
                                self.State.Enabled = not self.State.Enabled
                                if self.State.Enabled then
                                    self:Enable()
                                else
                                self:Disable()
                            end
                        end
                        function Modules.AutoDecompiler:Initialize()
                            local module = self
                            RegisterCommand({
                            Name = "autodecompile",
                            Aliases = {"adecompile", "decompile"},
                            Description = "Automatically decompiles scripts using a bytecode API."
                            }, function(args)
                            module:Toggle()
                        end)
                    end
                    local Players = game:GetService("Players")
                    local RunService = game:GetService("RunService")
                    Modules.RespawnAtDeath = {
                    State = {
                    Enabled = false,
                    LastDeathCFrame = nil,
                    DiedConnection = nil,
                    CharacterConnection = nil,
                    }
                    }
                    function Modules.RespawnAtDeath.OnDied()
                        local character = Players.LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then
                            Modules.RespawnAtDeath.State.LastDeathCFrame = root.CFrame
                            print("Death location saved.")
                        end
                    end
                    function Modules.RespawnAtDeath.OnCharacterAdded(character)
                        local humanoid = character:WaitForChild("Humanoid")
                        if Modules.RespawnAtDeath.State.DiedConnection then
                            Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
                        end
                        Modules.RespawnAtDeath.State.DiedConnection = humanoid.Died:Connect(Modules.RespawnAtDeath.OnDied)
                        local deathCFrame = Modules.RespawnAtDeath.State.LastDeathCFrame
                        if deathCFrame then
                            coroutine.wrap(function()
                            print("Teleporting to saved death location...")
                            task.wait(0.1)
                            local root = character:WaitForChild("HumanoidRootPart")
                            if not root then return end
                                local originalAnchored = root.Anchored
                                root.Anchored = true
                                root.CFrame = deathCFrame
                                RunService.Heartbeat:Wait()
                                root.Anchored = originalAnchored
                                Modules.RespawnAtDeath.State.LastDeathCFrame = nil
                                print("Teleport successful.")
                            end)()
                        end
                    end
                    function Modules.RespawnAtDeath.Toggle()
                        local localPlayer = Players.LocalPlayer
                        Modules.RespawnAtDeath.State.Enabled = not Modules.RespawnAtDeath.State.Enabled
                        if Modules.RespawnAtDeath.State.Enabled then
                            print("Respawn at Death: ENABLED")
                            Modules.RespawnAtDeath.State.CharacterConnection = localPlayer.CharacterAdded:Connect(Modules.RespawnAtDeath.OnCharacterAdded)
                            if localPlayer.Character then
                                Modules.RespawnAtDeath.OnCharacterAdded(localPlayer.Character)
                            end
                        else
                        print("Respawn at Death: DISABLED")
                        if Modules.RespawnAtDeath.State.DiedConnection then
                            Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
                            Modules.RespawnAtDeath.State.DiedConnection = nil
                        end
                        if Modules.RespawnAtDeath.State.CharacterConnection then
                            Modules.RespawnAtDeath.State.CharacterConnection:Disconnect()
                            Modules.RespawnAtDeath.State.CharacterConnection = nil
                        end
                        Modules.RespawnAtDeath.State.LastDeathCFrame = nil
                    end
                end
                RegisterCommand({
                Name = "RespawnAtDeath",
                Aliases = {"deathspawn", "spawnondeath"},
                Description = "Toggles respawning at your last death location."
                }, function(args)
                Modules.RespawnAtDeath.Toggle()
            end)
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            Modules.RejoinServer = {
            State = {}
            }
            RegisterCommand({
            Name = "rejoin",
            Aliases = {"rj", "reconnect"},
            Description = "Teleports you back to the current server."
            }, function(args)
            local localPlayer = Players.LocalPlayer
            if not localPlayer then
                print("Error: Could not find LocalPlayer.")
                return
            end
            local placeId = game.PlaceId
            local jobId = game.JobId
            print("Rejoining server... Please wait.")
            local success, errorMessage = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
        end)
        if not success then
            print("Rejoin failed: " .. errorMessage)
        end
    end)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    Modules.AutoAttack = {
    State = {
    Enabled = false,
    ClickDelay = 0.1,
    Connection = nil,
    LastClickTime = 0
    }
    }
    function Modules.AutoAttack:AttackLoop()
        if UserInputService:GetFocusedTextBox() then
            return
        end
        local currentTime = os.clock()
        if currentTime - self.State.LastClickTime > self.State.ClickDelay then
            mouse1press()
            task.wait()
            mouse1release()
            self.State.LastClickTime = currentTime
        end
    end
    function Modules.AutoAttack:Enable()
        local self = self
        self.State.Enabled = true
        self.State.LastClickTime = 0
        self.State.Connection = RunService.Heartbeat:Connect(function()
        self:AttackLoop()
    end)
    DoNotif("Auto-Attack: [Enabled] | Delay: " .. self.State.ClickDelay * 1000 .. "ms", 2)
end
function Modules.AutoAttack:Disable()
    self.State.Enabled = false
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    DoNotif("Auto-Attack: [Disabled]", 2)
end
RegisterCommand({
Name = "autoattack",
Aliases = {"aut", "autoclick"},
Description = "Toggles auto-click."
}, function(args)
local newDelay = tonumber(args[1])
if newDelay and newDelay > 0 then
    Modules.AutoAttack.State.ClickDelay = newDelay / 1000
    if Modules.AutoAttack.State.Enabled then
        DoNotif("Auto-Attack Delay Updated: " .. newDelay .. "ms", 2)
    end
end
if not newDelay then
    if Modules.AutoAttack.State.Enabled then
        Modules.AutoAttack:Disable()
    else
    Modules.AutoAttack:Enable()
end
end
end)
Modules.killbrick = {
State = {
Tracked = setmetatable({}, {__mode="k"}),
Originals = setmetatable({}, {__mode="k"}),
Signals = setmetatable({}, {__mode="k"}),
Connections = {}
}
}
local function cleanupAntiKillbrick()
local state = Modules.killbrick.State
for _, conn in ipairs(state.Connections) do
    if conn and typeof(conn.Disconnect) == "function" then
        conn:Disconnect()
    end
end
table.clear(state.Connections)
for _, signalTable in pairs(state.Signals) do
    if signalTable then
        for _, conn in ipairs(signalTable) do
            if conn and typeof(conn.Disconnect) == "function" then
                conn:Disconnect()
            end
        end
    end
end
for part, originalValue in pairs(state.Originals) do
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        part.CanTouch = (originalValue == nil) or originalValue
    end
end
table.clear(state.Signals)
table.clear(state.Tracked)
table.clear(state.Originals)
end
function Modules.killbrick.Enable()
    cleanupAntiKillbrick()
    local state = Modules.killbrick.State
    local localPlayer = Players.LocalPlayer
    local function applyProtection(part)
    if not (part and part:IsA("BasePart")) then return end
        if state.Originals[part] == nil then
            state.Originals[part] = part.CanTouch
        end
        part.CanTouch = false
        state.Tracked[part] = true
        if not state.Signals[part] then
            local connection = part:GetPropertyChangedSignal("CanTouch"):Connect(function()
            if part.CanTouch ~= false then
                part.CanTouch = false
            end
        end)
        state.Signals[part] = {connection}
    end
end
local function setupCharacter(character)
if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        applyProtection(descendant)
    end
    table.insert(state.Connections, character.DescendantAdded:Connect(applyProtection))
    table.insert(state.Connections, character.DescendantRemoving:Connect(function(descendant)
    if state.Signals[descendant] then
        for _, conn in ipairs(state.Signals[descendant]) do conn:Disconnect() end
            state.Signals[descendant] = nil
        end
        state.Tracked[descendant] = nil
        state.Originals[descendant] = nil
    end))
end
local function onCharacterAdded(character)
cleanupAntiKillbrick()
task.wait()
setupCharacter(character)
end
if localPlayer.Character then
    setupCharacter(localPlayer.Character)
end
table.insert(state.Connections, localPlayer.CharacterAdded:Connect(onCharacterAdded))
table.insert(state.Connections, localPlayer.CharacterRemoving:Connect(cleanupAntiKillbrick))
table.insert(state.Connections, RunService.Stepped:Connect(function()
if not localPlayer.Character then return end
    for part in pairs(state.Tracked) do
        if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent and part.CanTouch ~= false then
            part.CanTouch = false
        end
    end
end))
print("Anti-KillBrick Enabled.")
end
function Modules.killbrick.Disable()
    cleanupAntiKillbrick()
    print("Anti-KillBrick Disabled.")
end
RegisterCommand({
Name = "antikillbrick",
Aliases = {"antikb"},
Description = "Prevents kill bricks from killing you."
}, function(args)
Modules.killbrick.Enable(args)
end)
RegisterCommand({
Name = "unantikillbrick",
Aliases = {"unantikb"},
Description = "Allows kill bricks to kill you again."
}, function(args)
Modules.killbrick.Disable(args)
end)
Modules.FlingProtection = {
State = {
IsEnabled = false,
SteppedConnection = nil,
PlayerConnections = {}
},
Config = {
MAX_VELOCITY_MAGNITUDE = 200,
LOCAL_PLAYER_GROUP = "LocalPlayerCollisionGroup",
OTHER_PLAYERS_GROUP = "OtherPlayersCollisionGroup"
}
}
function Modules.FlingProtection:_setCollisionGroupForCharacter(character, groupName)
    if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CollisionGroup = groupName end)
            end
        end
    end
    function Modules.FlingProtection:_setupPlayerCollisions()
        local PhysicsService = game:GetService("PhysicsService")
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.LOCAL_PLAYER_GROUP) end)
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.OTHER_PLAYERS_GROUP) end)
        PhysicsService:CollisionGroupSetCollidable(self.Config.LOCAL_PLAYER_GROUP, self.Config.OTHER_PLAYERS_GROUP, false)
        for _, player in ipairs(Players:GetPlayers()) do
            local group = (player == LocalPlayer) and self.Config.LOCAL_PLAYER_GROUP or self.Config.OTHER_PLAYERS_GROUP
            if player.Character then
                self:_setCollisionGroupForCharacter(player.Character, group)
            end
            local conn = player.CharacterAdded:Connect(function(character)
            self:_setCollisionGroupForCharacter(character, group)
        end)
        table.insert(self.State.PlayerConnections, conn)
    end
    local conn = Players.PlayerAdded:Connect(function(player)
    local group = self.Config.OTHER_PLAYERS_GROUP
    local charConn = player.CharacterAdded:Connect(function(character)
    self:_setCollisionGroupForCharacter(character, group)
end)
table.insert(self.State.PlayerConnections, charConn)
end)
table.insert(self.State.PlayerConnections, conn)
end
function Modules.FlingProtection:_revertPlayerCollisions()
    for _, conn in ipairs(self.State.PlayerConnections) do
        conn:Disconnect()
    end
    self.State.PlayerConnections = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            self:_setCollisionGroupForCharacter(player.Character, "Default")
        end
    end
end
function Modules.FlingProtection:_enforceStability()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (hrp and not hrp.Anchored) then return end
        if hrp.AssemblyLinearVelocity.Magnitude > self.Config.MAX_VELOCITY_MAGNITUDE then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
    function Modules.FlingProtection:Toggle()
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            DoNotif("Fling & Player Collision Protection: ENABLED", 2)
            self:_setupPlayerCollisions()
            self.State.SteppedConnection = RunService.Stepped:Connect(function() self:_enforceStability() end)
        else
        DoNotif("Fling & Player Collision Protection: DISABLED", 2)
        self:_revertPlayerCollisions()
        if self.State.SteppedConnection then
            self.State.SteppedConnection:Disconnect()
            self.State.SteppedConnection = nil
        end
    end
end

do
	local ATTRIBUTE_OG_SIZE = "Zuka_OriginalSize"
	local SELECTION_BOX_NAME = "Zuka_ReachSelectionBox"

	local activeTool: Tool? = nil
	local modifiedPart: BasePart? = nil
	local persistentToolName: string? = nil
	local persistentPartName: string? = nil
	local currentReachSize: number = 20
	local currentReachType: "directional" | "box" = "directional"
	
	Modules.ReachController = {
		State = {
			IsEnabled = false,
			UI = nil,
			Connections = {}
		}
	}
	
	local function updatePartModification(part: BasePart, newSize: number?, reachType: string?)
		if not part or not part.Parent then return end
		local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)
		if not newSize then
			if originalSize then part.Size = originalSize; part:SetAttribute(ATTRIBUTE_OG_SIZE, nil) end
			local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
			if selectionBox then selectionBox:Destroy() end
			return
		end
		if not originalSize then part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size) end
		local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME) or Instance.new("SelectionBox")
		selectionBox.Name = SELECTION_BOX_NAME; selectionBox.Adornee = part; selectionBox.LineThickness = 0.02; selectionBox.Parent = part
		selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
		if reachType == "box" then part.Size = Vector3.one * newSize else part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize) end
		part.Massless = true
	end

	local function resetReach()
		if not modifiedPart and not persistentToolName then print("Reach is not active."); return end
		local tool; if persistentToolName then tool = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(persistentToolName)) or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(persistentToolName)) end
		local partToReset = modifiedPart or (tool and persistentPartName and tool:FindFirstChild(persistentPartName, true))
		if partToReset then updatePartModification(partToReset, nil, nil) end
		modifiedPart, persistentToolName, persistentPartName = nil, nil, nil
		print("Tool reach has been fully reset.")
	end

	function Modules.ReachController:Enable()
		if self.State.IsEnabled then return end
		self.State.IsEnabled = true
		
		local ui = Instance.new("ScreenGui"); ui.Name = "ReachController_Zuka"; ui.ZIndexBehavior = Enum.ZIndexBehavior.Global; ui.ResetOnSpawn = false
		self.State.UI = ui
		
		local mainFrame = Instance.new("Frame", ui); mainFrame.Size = UDim2.fromOffset(250, 320); mainFrame.Position = UDim2.fromScale(0, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); mainFrame.BorderSizePixel = 0; mainFrame.ClipsDescendants = true
		Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
		
		local titleBar = Instance.new("Frame", mainFrame); titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35); titleBar.BorderSizePixel = 0
		local title = Instance.new("TextLabel", titleBar); title.Size = UDim2.new(1, -30, 1, 0); title.Position = UDim2.fromOffset(10, 0); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamSemibold; title.Text = "Reach Controller"; title.TextColor3 = Color3.fromRGB(200, 220, 255); title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left
		local contentFrame = Instance.new("Frame", mainFrame); contentFrame.Name = "Content"; contentFrame.Size = UDim2.new(1, 0, 1, -30); contentFrame.Position = UDim2.new(0, 0, 0, 30); contentFrame.BackgroundTransparency = 1
		local toggleButton = Instance.new("TextButton", titleBar); toggleButton.Size = UDim2.fromOffset(20, 20); toggleButton.Position = UDim2.new(1, -10, 0.5, 0); toggleButton.AnchorPoint = Vector2.new(1, 0.5); toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100); toggleButton.Text = "-"; toggleButton.Font = Enum.Font.GothamBold; toggleButton.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

		titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then local dragStart, startPos = input.Position, mainFrame.Position; local moveConn, endConn; moveConn = UserInputService.InputChanged:Connect(function(moveInput) if moveInput.UserInputType == Enum.UserInputType.MouseMovement then local delta = moveInput.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end); endConn = UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect(); endConn:Disconnect() end end) end end)
		local sizeLabel = Instance.new("TextLabel", contentFrame); sizeLabel.Size = UDim2.fromOffset(80, 20); sizeLabel.Position = UDim2.fromOffset(10, 10); sizeLabel.BackgroundTransparency = 1; sizeLabel.Font = Enum.Font.Gotham; sizeLabel.Text = "Reach Size:"; sizeLabel.TextColor3 = Color3.new(1, 1, 1); sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
		local sizeInput = Instance.new("TextBox", contentFrame); sizeInput.Size = UDim2.fromOffset(130, 30); sizeInput.Position = UDim2.fromOffset(110, 5); sizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65); sizeInput.Font = Enum.Font.Code; sizeInput.Text = tostring(currentReachSize); sizeInput.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 4)
		local directionalBtn = Instance.new("TextButton", contentFrame); directionalBtn.Size = UDim2.fromOffset(110, 30); directionalBtn.Position = UDim2.fromOffset(10, 40); directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); directionalBtn.Font = Enum.Font.GothamSemibold; directionalBtn.Text = "Directional"; directionalBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", directionalBtn).CornerRadius = UDim.new(0, 4)
		local boxBtn = Instance.new("TextButton", contentFrame); boxBtn.Size = UDim2.fromOffset(110, 30); boxBtn.Position = UDim2.fromOffset(130, 40); boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65); boxBtn.Font = Enum.Font.GothamSemibold; boxBtn.Text = "Box"; boxBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", boxBtn).CornerRadius = UDim.new(0, 4)
		local partsLabel = Instance.new("TextLabel", contentFrame); partsLabel.Size = UDim2.fromOffset(80, 20); partsLabel.Position = UDim2.fromOffset(10, 75); partsLabel.BackgroundTransparency = 1; partsLabel.Font = Enum.Font.Gotham; partsLabel.Text = "Tool Parts:"; partsLabel.TextColor3 = Color3.new(1, 1, 1); partsLabel.TextXAlignment = Enum.TextXAlignment.Left
		local scroll = Instance.new("ScrollingFrame", contentFrame); scroll.Size = UDim2.new(1, -20, 1, -140); scroll.Position = UDim2.fromOffset(10, 100); scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35); scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 6
		local resetBtn = Instance.new("TextButton", contentFrame); resetBtn.Size = UDim2.new(1, -20, 0, 30); resetBtn.Position = UDim2.new(0.5, 0, 1, -10); resetBtn.AnchorPoint = Vector2.new(0.5, 1); resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); resetBtn.Font = Enum.Font.GothamBold; resetBtn.Text = "Reset Reach"; resetBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 4)

		local function populatePartSelector()
			scroll:ClearAllChildren(); if not activeTool then return end
			local parts = {}; for _, d in ipairs(activeTool:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end
			if #parts == 0 then return end
			local listLayout = Instance.new("UIListLayout", scroll); listLayout.Padding = UDim.new(0, 5); listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			for _, part in ipairs(parts) do
				local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1, -10, 0, 30); btn.Position = UDim2.fromScale(0.5, 0); btn.AnchorPoint = Vector2.new(0.5, 0); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65); btn.TextColor3 = Color3.fromRGB(220, 220, 230); btn.Font = Enum.Font.Code; btn.Text = part.Name; btn.TextSize = 14; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
				btn.MouseButton1Click:Connect(function()
					if not part or not part.Parent or not activeTool then print("Reach Error: Part/tool missing."); return end
					persistentToolName, persistentPartName = activeTool.Name, part.Name
					if modifiedPart and modifiedPart ~= part then updatePartModification(modifiedPart, nil, nil) end
					modifiedPart = part; updatePartModification(part, currentReachSize, currentReachType)
					print(string.format("Reach set for '%s' on tool '%s'.", part.Name, activeTool.Name))
				end)
			end
		end

		sizeInput.FocusLost:Connect(function() local num = tonumber(sizeInput.Text); if num and num > 0 then currentReachSize = num else sizeInput.Text = tostring(currentReachSize) end end)
		directionalBtn.MouseButton1Click:Connect(function() currentReachType = "directional"; directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
		boxBtn.MouseButton1Click:Connect(function() currentReachType = "box"; boxBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); directionalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
		resetBtn.MouseButton1Click:Connect(resetReach)
		toggleButton.MouseButton1Click:Connect(function() contentFrame.Visible = not contentFrame.Visible; toggleButton.Text = contentFrame.Visible and "-" or "+"; mainFrame.Size = contentFrame.Visible and UDim2.fromOffset(250, 320) or UDim2.fromOffset(250, 30) end)

		local function onToolEquipped(tool)
			activeTool = tool; populatePartSelector()
			if self.State.Connections.Unequipped then self.State.Connections.Unequipped:Disconnect() end
			self.State.Connections.Unequipped = tool.Unequipped:Connect(function() activeTool = nil; populatePartSelector() end)
		end

		local function onCharacterAdded(character)
			if persistentToolName and persistentPartName then
				local function reapply(tool) if tool and tool.Name == persistentToolName then local part = tool:WaitForChild(persistentPartName, 2); if part and part:IsA("BasePart") then updatePartModification(part, currentReachSize, currentReachType); modifiedPart = part end end end
				reapply(character:FindFirstChild(persistentToolName)); self.State.Connections["Reapply"..character.Name] = character.ChildAdded:Connect(function(child) if child:IsA("Tool") then reapply(child) end end)
			end
			self.State.Connections["ToolListener"..character.Name] = character.ChildAdded:Connect(function(child) if child:IsA("Tool") then onToolEquipped(child) end end)
			local firstTool = character:FindFirstChildOfClass("Tool"); if firstTool then onToolEquipped(firstTool) end
		end

		if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
		self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

		ui.Parent = CoreGui
		DoNotif("Reach Controller: ENABLED.", 2)
	end
	
	function Modules.ReachController:Disable()
		if not self.State.IsEnabled then return end
		self.State.IsEnabled = false
		resetReach()
		if self.State.UI and self.State.UI.Parent then self.State.UI:Destroy() end
		self.State.UI = nil
		for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
		table.clear(self.State.Connections)
		DoNotif("Reach Controller: DISABLED.", 2)
	end

	function Modules.ReachController:Toggle()
		if self.State.IsEnabled then self:Disable() else self:Enable() end
	end
end

RegisterCommand({ Name = "reachgui", Aliases = { "reachcontroller" }, Description = "Toggles a GUI for advanced tool reach modification." }, function() Modules.ReachController:Toggle() end)


RegisterCommand({
Name = "antifling",
Aliases = {"anf"},
Description = "Prevents flinging and disables collision with other players."
}, function()
Modules.FlingProtection:Toggle()
end)
Modules.Reach = {
Connections = {},
State = {
IsEnabled = false,
ActiveTool = nil,
ModifiedPart = nil,
PersistentToolName = nil,
PersistentPartName = nil,
ReachType = nil,
ReachSize = nil,
UI = {
ScreenGui = nil,
Frame = nil,
ScrollingFrame = nil,
CloseButton = nil
}
}
}
local ATTRIBUTE_OG_SIZE = "OriginalSize"
local SELECTION_BOX_NAME = "ReachSelectionBox"
function Modules.Reach:_updatePartModification(part, newSize, reachType)
    if not part or not part.Parent then return end
        local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)
        if not newSize then
            if originalSize then
                part.Size = originalSize
                part:SetAttribute(ATTRIBUTE_OG_SIZE, nil)
            end
            if part:FindFirstChild(SELECTION_BOX_NAME) then
                part[SELECTION_BOX_NAME]:Destroy()
            end
            return
        end
        if not originalSize then
            part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size)
        end
        local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
        if not selectionBox then
            selectionBox = Instance.new("SelectionBox", part)
            selectionBox.Name = SELECTION_BOX_NAME
            selectionBox.Adornee = part
            selectionBox.LineThickness = 0.02
        end
        selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
        if reachType == "box" then
            part.Size = Vector3.one * newSize
        else
        part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize)
    end
    part.Massless = true
end
function Modules.Reach:_populatePartSelector()
    local self = Modules.Reach
    local scroll = self.State.UI.ScrollingFrame
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    if not self.State.ActiveTool then return end
        local parts = {}
        for _, descendant in ipairs(self.State.ActiveTool:GetDescendants()) do
            if descendant:IsA("BasePart") then
                table.insert(parts, descendant)
            end
        end
        if #parts == 0 then
            DoNotif("Equipped tool has no physical parts.", 3)
            return
        end
        for _, part in ipairs(parts) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            btn.Font = Enum.Font.Code
            btn.Text = part.Name
            btn.TextSize = 14
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
            if not part or not part.Parent or not self.State.ActiveTool then
                self.State.UI.ScreenGui.Enabled = false
                return DoNotif("The selected part or tool no longer exists.", 3)
            end
            self.State.PersistentToolName = self.State.ActiveTool.Name
            self.State.PersistentPartName = part.Name
            if self.State.ModifiedPart and self.State.ModifiedPart ~= part then
                self:_updatePartModification(self.State.ModifiedPart)
            end
            self.State.IsEnabled = true
            self.State.ModifiedPart = part
            self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
            self.State.UI.ScreenGui.Enabled = false
            DoNotif("Persistently set reach for " .. part.Name .. " on " .. self.State.PersistentToolName, 3)
        end)
    end
end
function Modules.Reach:_onToolEquipped(tool)
    local self = Modules.Reach
    self.State.ActiveTool = tool
    self:_populatePartSelector()
    if self.Connections.Unequipped then self.Connections.Unequipped:Disconnect() end
        self.Connections.Unequipped = tool.Unequipped:Connect(function()
        self.State.ActiveTool = nil
        self.State.UI.ScreenGui.Enabled = false
    end)
end
function Modules.Reach:_onCharacterAdded(character)
    local self = Modules.Reach
    if self.State.PersistentToolName and self.State.PersistentPartName then
        local function reapplyModification(tool)
        if tool and tool.Name == self.State.PersistentToolName then
            local part = tool:WaitForChild(self.State.PersistentPartName, 5)
            if part then
                self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
                self.State.ModifiedPart = part
                self.State.IsEnabled = true
            end
        end
    end
    local equippedTool = character:FindFirstChild(self.State.PersistentToolName)
    reapplyModification(equippedTool)
    character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        reapplyModification(child)
    end
end)
end
character.ChildAdded:Connect(function(child)
if child:IsA("Tool") then self:_onToolEquipped(child) end
end)
local firstEquippedTool = character:FindFirstChildOfClass("Tool")
if firstEquippedTool then self:_onToolEquipped(firstEquippedTool) end
end
function Modules.Reach:Apply(reachType, size)
    local self = Modules.Reach
    if not self.State.ActiveTool then
        return DoNotif("You must have a tool equipped to select a part.", 3)
    end
    self.State.ReachType = reachType
    self.State.ReachSize = size
    self:_populatePartSelector()
    self.State.UI.ScreenGui.Enabled = true
end
function Modules.Reach:Reset()
    local self = Modules.Reach
    if not self.State.IsEnabled and not self.State.PersistentToolName then
        return DoNotif("Reach is not active and no part is set.", 3)
    end
    local tool
    if self.State.PersistentToolName then
        tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(self.State.PersistentToolName)
        if not tool then
            tool = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(self.State.PersistentToolName)
        end
    end
    if tool and self.State.PersistentPartName then
        local part = tool:FindFirstChild(self.State.PersistentPartName, true)
        if part then
            self:_updatePartModification(part)
        end
    end
    self.State.IsEnabled = false
    self.State.ModifiedPart = nil
    self.State.PersistentToolName = nil
    self.State.PersistentPartName = nil
    self.State.ReachType = nil
    self.State.ReachSize = nil
    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui.Enabled = false
    end
    DoNotif("Tool reach has been fully reset and persistence cleared.", 3)
end
function Modules.Reach:Initialize()
    local self = Modules.Reach
    local ui = Instance.new("ScreenGui")
    ui.Name = "ReachPartSelector_Persistent"
    ui.Parent = CoreGui
    ui.Enabled = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.ResetOnSpawn = false
    self.State.UI.ScreenGui = ui
    local frame = Instance.new("Frame", ui)
    frame.Size = UDim2.fromOffset(250, 220)
    frame.Position = UDim2.new(0.5, -125, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    self.State.UI.Frame = frame
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Code
    title.Text = "Select a Part to Modify"
    title.TextColor3 = Color3.fromRGB(200, 220, 255)
    title.TextSize = 16
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.fromOffset(10, 35)
    scroll.BackgroundColor3 = frame.BackgroundColor3
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    self.State.UI.ScrollingFrame = scroll
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
    closeBtn.MouseButton1Click:Connect(function() ui.Enabled = false end)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
    self.State.UI.CloseButton = closeBtn
    if LocalPlayer.Character then
        self:_onCharacterAdded(LocalPlayer.Character)
    end
    self.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(char)
    self:_onCharacterAdded(char)
end)
RegisterCommand({Name = "reach", Aliases = {"swordreach"}, Description = "Extends sword reach. ;reach [num]"}, function(args)
self:Apply("directional", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "boxreach", Aliases = {}, Description = "Creates a box hitbox. ;boxreach [num]"}, function(args)
self:Apply("box", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "resetreach", Aliases = {"unreach"}, Description = "Resets tool reach and clears persistent setting."}, function()
self:Reset()
end)
end
RegisterCommand({Name = "goto", Aliases = {}, Description = "Teleports to a player. ;goto [player]"}, function(args)
if not args[1] then
    return DoNotif("Specify a player's name.", 3)
end
local targetPlayer = Utilities.findPlayer(args[1])
if targetPlayer then
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if localHRP and targetHRP then
        localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        DoNotif("Teleported to " .. targetPlayer.Name, 3)
    else
    DoNotif("Target player's character could not be found.", 3)
end
else
DoNotif("Player not found.", 3)
end
end)
Modules.AdvancedFling = {
    State = {
        IsFlinging = false
    }
}

-- NOTE: The original findFlingTargets function is retained as it is more comprehensive
-- and already integrated with the command system's argument parsing.
local function findFlingTargets(targetName)
    local targets = {}
    local localPlayer = Players.LocalPlayer
    local lowerTargetName = targetName and targetName:lower() or "nil"

    if not targetName or lowerTargetName == "me" then
        return { localPlayer }
    end
    if lowerTargetName == "all" then
        return Players:GetPlayers()
    end
    if lowerTargetName == "others" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then table.insert(targets, p) end
        end
        return targets
    end
    if lowerTargetName == "random" then
        local allPlayers = Players:GetPlayers()
        if #allPlayers > 1 then
            local potentialTargets = {}
            for _, p in ipairs(allPlayers) do
                if p ~= localPlayer then table.insert(potentialTargets, p) end
            end
            if #potentialTargets > 0 then
                return { potentialTargets[math.random(1, #potentialTargets)] }
            end
        end
        return {}
    end
    if lowerTargetName == "nearest" then
        local nearestPlayer, minDist = nil, math.huge
        local localRoot = localPlayer.Character and localPlayer.Character.PrimaryPart
        if not localRoot then return {} end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character.PrimaryPart then
                local dist = (p.Character.PrimaryPart.Position - localRoot.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPlayer = p
                end
            end
        end
        if nearestPlayer then return { nearestPlayer } end
        return {}
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():match("^"..lowerTargetName) or p.DisplayName:lower():match("^"..lowerTargetName) then
            table.insert(targets, p)
        end
    end
    return targets
end

function Modules.AdvancedFling:Execute(targetPlayer)
    if self.State.IsFlinging then return DoNotif("Fling already in progress.", 2) end

    local localCharacter = LocalPlayer.Character
    local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
    local localRootPart = localHumanoid and localHumanoid.RootPart

    if not (localRootPart and targetPlayer.Character) then
        return DoNotif("Cannot fling: A required character is missing.", 3)
    end
    
    self.State.IsFlinging = true
    
    -- Store original state for restoration
    local originalPosition = localRootPart.CFrame
    local originalCameraSubject = Workspace.CurrentCamera.CameraSubject
    local originalDestroyHeight = Workspace.FallenPartsDestroyHeight

    task.spawn(function()
        local success, err = pcall(function()
            --// --- START: New "SkidFling" Logic Integration ---

            local TCharacter = targetPlayer.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")

            if not (TCharacter and THumanoid) then
                error("Target character or humanoid not found.")
            end

            if THumanoid.Sit then
                return DoNotif("Fling failed: Target is sitting.", 3)
            end

            -- Set camera subject
            if THead then
                Workspace.CurrentCamera.CameraSubject = THead
            elseif Handle then
                Workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid then
                Workspace.CurrentCamera.CameraSubject = THumanoid
            end

            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return -- Target has no parts, abort.
            end

            local function FPos(BasePart, Pos, Ang)
                localRootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                localCharacter:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                localRootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                localRootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            local function SFBasePart(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if localRootPart and THumanoid and BasePart and BasePart.Parent then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500
                    or not BasePart.Parent
                    or BasePart.Parent ~= TCharacter
                    or not targetPlayer.Parent
                    or THumanoid.Sit
                    or localHumanoid.Health <= 0
                    or tick() > Time + TimeToWait
            end

            Workspace.FallenPartsDestroyHeight = 0/0 -- NaN value to disable void
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            local primaryFlingPart
            if TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
                primaryFlingPart = THead
            elseif TRootPart then
                primaryFlingPart = TRootPart
            elseif THead then
                primaryFlingPart = THead
            elseif Handle then
                primaryFlingPart = Handle
            else
                return DoNotif("Fling failed: Target is missing critical parts.", 3)
            end
            
            SFBasePart(primaryFlingPart)

            --// --- END: New "SkidFling" Logic Integration ---
        end)

        -- This unified cleanup block will run regardless of success or failure.
        pcall(function()
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            Workspace.CurrentCamera.CameraSubject = localCharacter
            Workspace.FallenPartsDestroyHeight = originalDestroyHeight

            repeat
                if localRootPart and localRootPart.Parent then
                    localRootPart.CFrame = originalPosition
                    localRootPart.Velocity, localRootPart.RotVelocity = Vector3.new(), Vector3.new()
                end
                task.wait()
            until not self.State.IsFlinging or not localRootPart.Parent or (localRootPart.Position - originalPosition.Position).Magnitude < 25
        end)

        if not success then
            warn("AdvancedFling Error:", err)
            DoNotif("Fling failed. Target may have reset or left.", 3)
        else
            DoNotif("Fling sequence complete.", 2)
        end
        
        self.State.IsFlinging = false
    end)
end

RegisterCommand({ Name = "fling", Aliases = {"fl"}, Description = "Fling a player." }, function(args)
    local targetName = args[1]
    if not targetName then
        return DoNotif("Usage: ;fling <player|all|others|random|nearest>", 3)
    end
    
    local targets = findFlingTargets(targetName)
    if #targets == 0 then
        return DoNotif("No valid target found.", 3)
    end
    
    if #targets > 1 then
        DoNotif("Flinging multiple targets...", 2)
    else
        DoNotif("Target found: " .. targets[1].Name, 2)
    end

    for _, targetPlayer in ipairs(targets) do
        if targetPlayer ~= LocalPlayer then
            Modules.AdvancedFling:Execute(targetPlayer)
            task.wait(0.1) -- Stagger for multiple targets
        end
    end
end)
Modules.SetSpawnPoint = {
State = {
CustomSpawnCFrame = nil,
CharacterAddedConnection = nil
}
}
function Modules.SetSpawnPoint:OnCharacterAdded(newCharacter)
    if not self.State.CustomSpawnCFrame then return end
        local rootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)
        if rootPart then
            task.wait()
            rootPart.CFrame = self.State.CustomSpawnCFrame
        end
    end
    RegisterCommand({
    Name = "setspawnpoint",
    Aliases = {"setspawn", "ssp"},
    Description = "Sets your respawn point to your current location. Use 'clear' to reset."
    }, function(args)
    local localPlayer = Players.LocalPlayer
    local commandArg = args[1] and string.lower(args[1])
    if commandArg == "clear" or commandArg == "reset" then
        if Modules.SetSpawnPoint.State.CustomSpawnCFrame then
            Modules.SetSpawnPoint.State.CustomSpawnCFrame = nil
            print("Custom spawn point cleared. You will now use the default spawn.")
            if Modules.SetSpawnPoint.State.CharacterAddedConnection then
                Modules.SetSpawnPoint.State.CharacterAddedConnection:Disconnect()
                Modules.SetSpawnPoint.State.CharacterAddedConnection = nil
            end
        else
        print("No custom spawn point was set.")
    end
    return
end
local character = localPlayer and localPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
if not rootPart then
    print("Error: Could not set spawn point. Player character not found.")
    return
end
Modules.SetSpawnPoint.State.CustomSpawnCFrame = rootPart.CFrame
print("Custom spawn point set at: " .. tostring(rootPart.Position))
if not Modules.SetSpawnPoint.State.CharacterAddedConnection then
    Modules.SetSpawnPoint.State.CharacterAddedConnection = localPlayer.CharacterAdded:Connect(function(char)
    Modules.SetSpawnPoint:OnCharacterAdded(char)
end)
end
end)
Modules.NoclipStabilizer = {
State = {
Enabled = false,
Connection = nil
}
}
function Modules.NoclipStabilizer:_OnStepped()
    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end
function Modules.NoclipStabilizer:Enable()
    if self.State.Enabled then return end
        self.State.Enabled = true
        self.State.Connection = RunService.Stepped:Connect(function()
        self:_OnStepped()
    end)
    DoNotif("Noclip Stabilizer: [Enabled]", 3)
end
function Modules.NoclipStabilizer:Disable()
    if not self.State.Enabled then return end
        self.State.Enabled = false
        if self.State.Connection then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        DoNotif("Noclip Stabilizer: [Disabled]", 3)
    end
    RegisterCommand({
    Name = "antirubberband",
    Aliases = {"antirb", "arb"},
    Description = "Toggles the Noclip Stabilizer to prevent server-side rubberbanding."
    }, function(args)
    if Modules.NoclipStabilizer.State.Enabled then
        Modules.NoclipStabilizer:Disable()
    else
    Modules.NoclipStabilizer:Enable()
end
end)

Modules.AntiReset = {
    State = {
        IsEnabled = false,
        CharacterConnections = {}
    }
}

--- Enables the anti-reset system.
function Modules.AntiReset:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function applyAntiReset(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 2)
        local hrp = character:WaitForChild("HumanoidRootPart", 2)
        if not (humanoid and hrp) then return end

        for _, connection in pairs(self.State.CharacterConnections) do
            if connection then connection:Disconnect() end
        end
        table.clear(self.State.CharacterConnections)

        local isResetting = false

        -- [VECTOR 1] Health-Based Reset Protection
        self.State.CharacterConnections.HealthChanged = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 and not isResetting then
                isResetting = true
                humanoid.Health = humanoid.MaxHealth
                isResetting = false
            end
        end)

        -- [VECTOR 2] Void Reset Protection
        local lastSafePosition = hrp.Position
        local fallenPartsHeight = Workspace.FallenPartsDestroyHeight

        self.State.CharacterConnections.Heartbeat = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end

            if hrp.Position.Y < fallenPartsHeight then
                hrp.CFrame = CFrame.new(lastSafePosition)
                hrp.Velocity = Vector3.new(0, 0, 0)
            elseif humanoid.FloorMaterial ~= Enum.Material.Air then
                lastSafePosition = hrp.Position
            end
        end)
    end

    if LocalPlayer.Character then
        applyAntiReset(LocalPlayer.Character)
    end

    self.State.CharacterConnections.Added = LocalPlayer.CharacterAdded:Connect(applyAntiReset)
    
    DoNotif("Anti-Reset: ENABLED.", 2)
end

--- Disables the anti-reset system and cleans up all resources.
function Modules.AntiReset:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    for _, connection in pairs(self.State.CharacterConnections) do
        if connection then connection:Disconnect() end
    end
    table.clear(self.State.CharacterConnections)

    DoNotif("Anti-Reset: DISABLED.", 2)
end

--- Toggles the anti-reset state.
function Modules.AntiReset:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end


--[[

READ THIS TO KNOW HOW TO USE THE COMMAND BELOW, THIS WORKS FOR ANY GAME. A BUILT IN REMOTE FIRE AND EQUIPPER

use dex to find the paths,, after you found said path copy and paste it into the commandbar. below is an example

how to: ,setpath "game:GetService("ReplicatedStorage").Remotes.Shop.EquipWeapon" and then ,forceequip Shovel
use .settype "event" or settype "function" for the type you want to fire,

hell yeah this is an example that works for zombie game upd3, this can work for any game with low security, you'd be surprised how easy they can be to come across.

--]]

Modules.ForceEquip = {
    State = {
        IsRemoteFunction = false,
        RemotePath = nil
    },
    Dependencies = {"Players"}
}


function Modules.ForceEquip:_getInstanceFromPath(path)
    local current = game
    for component in string.gmatch(path, "[^%.]+") do
        if string.find(component, ":GetService") then
            local serviceName = component:match("'(.-)'") or component:match('"(.-)"')
            if serviceName then
                current = current:GetService(serviceName)
            else
                return nil
            end
        else
            if current then
                current = current:FindFirstChild(component)
            else
                return nil
            end
        end
    end
    return current
end

-- [Internal] The original execution logic for force equipping a single weapon.
function Modules.ForceEquip:Execute(weaponName)
    if not self.State.RemotePath then
        return DoNotif("Error: Remote path has not been set. Use ;setremotepath first.", 3)
    end
    if not weaponName then
        return DoNotif("Usage: ;forceequip <WeaponName>", 3)
    end

    -- For simplicity, this function now just calls the new generic one.
    self:ExecuteWithArgs({weaponName})
end

--- [NEW] Executes a fire/invoke on the configured remote with a variable number of arguments.
-- @param customArgs <table> An array of arguments to be sent.
function Modules.ForceEquip:ExecuteWithArgs(customArgs)
    if not self.State.RemotePath then
        return DoNotif("Error: Remote path has not been set. Use ;setremotepath first.", 3)
    end

    local remote = self:_getInstanceFromPath(self.State.RemotePath)
    if not remote then
        return DoNotif("Error: Remote not found at path: " .. self.State.RemotePath, 4)
    end

    -- Argument processing: Converts strings to their likely intended types.
    local fireArgs = {}
    for _, argStr in ipairs(customArgs or {}) do
        if tonumber(argStr) then
            table.insert(fireArgs, tonumber(argStr))
        elseif argStr:lower() == "true" then
            table.insert(fireArgs, true)
        elseif argStr:lower() == "false" then
            table.insert(fireArgs, false)
        elseif argStr:lower() == "nil" then
            table.insert(fireArgs, nil)
        else
            table.insert(fireArgs, argStr)
        end
    end

    -- Validate that the found remote matches the configured type.
    if self.State.IsRemoteFunction and not remote:IsA("RemoteFunction") then
        return DoNotif("Config Error: Remote is not a RemoteFunction. Use ;setremotetype.", 3)
    elseif not self.State.IsRemoteFunction and not remote:IsA("RemoteEvent") then
        return DoNotif("Config Error: Remote is not a RemoteEvent. Use ;setremotetype.", 3)
    end

    if self.State.IsRemoteFunction then
        DoNotif(string.format("Invoking with %d custom arguments...", #fireArgs), 2)
        local success, result = pcall(function() return remote:InvokeServer(unpack(fireArgs)) end)
        if not success then
            warn("--> [FireRemote] Invoke FAILED:", tostring(result))
            DoNotif("Invoke failed. See console (F9).", 3)
        else
            print("--> [FireRemote] Invoke SUCCESS. Result:", result)
            DoNotif("Invoke successful. Result printed to console.", 2)
        end
    else
        DoNotif(string.format("Firing with %d custom arguments...", #fireArgs), 2)
        local success, err = pcall(function() remote:FireServer(unpack(fireArgs)) end)
        if not success then
            warn("--> [FireRemote] Fire FAILED:", tostring(err))
            DoNotif("Fire failed. See console (F9).", 3)
        end
    end
end


-- Initializes the module and registers its commands.
function Modules.ForceEquip:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "forceequip",
        Aliases = {"give"},
        Description = "Fires the configured remote to equip a weapon."
    }, function(args)
        module:Execute(args[1])
    end)

    -- [NEW] Command for firing the same remote path with custom arguments.
    RegisterCommand({
        Name = "firepath",
        Aliases = {"fpath", "fire"},
        Description = "Fires the configured remote with custom arguments."
    }, function(args)
        module:ExecuteWithArgs(args)
    end)

    RegisterCommand({
        Name = "setremotepath",
        Aliases = {"setpath"},
        Description = "Sets the path for the ForceEquip module."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;setremotepath <path>", 3)
        end
        module.State.RemotePath = args[1]
        DoNotif("ForceEquip remote path set to: " .. args[1], 3)
    end)

    RegisterCommand({
        Name = "setremotetype",
        Aliases = {"settype"},
        Description = "Sets the remote type for ForceEquip."
    }, function(args)
        local typeStr = args[1] and args[1]:lower()
        if typeStr == "function" then
            module.State.IsRemoteFunction = true
            DoNotif("ForceEquip remote type set to: RemoteFunction", 3)
        elseif typeStr == "event" then
            module.State.IsRemoteFunction = false
            DoNotif("ForceEquip remote type set to: RemoteEvent", 3)
        else
            return DoNotif("Usage: ;setremotetype <event|function>", 3)
        end
    end)
end




Modules.NpcEsp = {
    State = {
        IsEnabled = false,
        Connections = {},
        TrackedNpcs = {} -- Key: Model, Value: {Highlight, Billboard, Humanoid, RootPart}
    },
    Dependencies = {"Players", "RunService", "Workspace"}
}

-- [Internal] Creates and manages the visual elements for a single NPC.
function Modules.NpcEsp:_createEspForNpc(npcModel)
    if self.State.TrackedNpcs[npcModel] then return end -- Already tracking

    local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
    local rootPart = npcModel:FindFirstChild("HumanoidRootPart") or npcModel.PrimaryPart
    
    if not (humanoid and rootPart and humanoid.Health > 0) then return end
    
    -- 1. Create the Highlight
    local highlight = Instance.new("Highlight", npcModel)
    highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for NPCs
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.4
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- 2. Create the Billboard GUI
    local billboard = Instance.new("BillboardGui", rootPart)
    billboard.Name = "NpcEspBillboard"
    billboard.Adornee = rootPart
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(150, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Text = npcModel.Name
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    
    -- Health & Distance Label
    local infoLabel = Instance.new("TextLabel", billboard)
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.Text = "" -- Will be updated by the loop
    infoLabel.Font = Enum.Font.Code
    infoLabel.TextSize = 14
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.BackgroundTransparency = 1

    -- 3. Store the created objects for tracking and cleanup
    self.State.TrackedNpcs[npcModel] = {
        Highlight = highlight,
        Billboard = billboard,
        InfoLabel = infoLabel,
        Humanoid = humanoid,
        RootPart = rootPart
    }
end

-- [Internal] Safely destroys the visual elements for a single NPC.
function Modules.NpcEsp:_removeEspForNpc(npcModel)
    local trackedData = self.State.TrackedNpcs[npcModel]
    if not trackedData then return end
    
    pcall(function() trackedData.Highlight:Destroy() end)
    pcall(function() trackedData.Billboard:Destroy() end)
    
    self.State.TrackedNpcs[npcModel] = nil
end

-- [Internal] The main loop that updates visuals and finds new NPCs.
function Modules.NpcEsp:_onHeartbeat()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    -- Update existing NPCs and clean up dead/removed ones
    for npcModel, data in pairs(self.State.TrackedNpcs) do
        if not (npcModel and npcModel.Parent and data.Humanoid and data.Humanoid.Health > 0) then
            self:_removeEspForNpc(npcModel)
        else
            -- Update distance and health
            local distance = math.floor((myRoot.Position - data.RootPart.Position).Magnitude)
            data.InfoLabel.Text = string.format("HP: %.0f | Dist: %d", data.Humanoid.Health, distance)
        end
    end
    
    -- Scan for new NPCs
    for _, model in ipairs(self.Services.Workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
            -- Check if it's not a player and not already tracked
            if not self.Services.Players:GetPlayerFromCharacter(model) and not self.State.TrackedNpcs[model] then
                self:_createEspForNpc(model)
            end
        end
    end
end

--- Enables the NPC ESP system.
function Modules.NpcEsp:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    
    DoNotif("NPC ESP: ENABLED.", 2)
end

--- Disables the NPC ESP system and cleans up all visuals.
function Modules.NpcEsp:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connections.Heartbeat then
        self.State.Connections.Heartbeat:Disconnect()
        self.State.Connections.Heartbeat = nil
    end
    
    for npcModel, _ in pairs(self.State.TrackedNpcs) do
        self:_removeEspForNpc(npcModel)
    end
    table.clear(self.State.TrackedNpcs)
    
    DoNotif("NPC ESP: DISABLED.", 2)
end

--- Toggles the NPC ESP state.
function Modules.NpcEsp:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module, loads services, and registers the command.
function Modules.NpcEsp:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    
    RegisterCommand({
        Name = "npcesp",
        Aliases = {"aiesp"},
        Description = "Toggles ESP for non-player characters (NPCs) in the workspace."
    }, function()
        module:Toggle()
    end)
end

RegisterCommand({
    Name = "antireset",
    Aliases = {"noreset", "ar"},
    Description = "Toggles a system that prevents your character from resetting."
}, function()
    Modules.AntiReset:Toggle()
end)

Modules.AntiCFrameTeleport = {
MAX_SPEED = 70,
MAX_STEP_DIST = 8,
REPEAT_THRESHOLD = 3,
LOCK_TIME = 0.1,
State = {
Enabled = false,
HeartbeatConnection = nil,
CharacterAddedConnection = nil,
LastCFrame = nil,
LastTimestamp = 0,
DetectionHits = 0
}
}
function Modules.AntiCFrameTeleport:_zeroVelocity(character)
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.zero
            descendant.AssemblyAngularVelocity = Vector3.zero
        end
    end
end
function Modules.AntiCFrameTeleport:_getFlyAllowances(deltaTime)
    local maxSpeed, maxDist = self.MAX_SPEED, self.MAX_STEP_DIST
    if not (getfenv(0).NAmanage and NAmanage._state and getfenv(0).FLYING) then
        return maxSpeed, maxDist
    end
    local mode = NAmanage._state.mode or "none"
    local flyVars = getfenv(0).flyVariables or {}
    if mode == "fly" then
        local speed = tonumber(flyVars.flySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "vfly" then
        local speed = tonumber(flyVars.vFlySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "cfly" then
        local speed = tonumber(flyVars.cFlySpeed) or 1
        local step = speed * 2
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.25)
    elseif mode == "tfly" then
        local speed = tonumber(flyVars.TflySpeed) or 1
        local step = speed * 2.5
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.5)
    end
    return maxSpeed, maxDist
end
function Modules.AntiCFrameTeleport:_onCharacterAdded(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if rootPart then
        self.State.LastCFrame = rootPart.CFrame
        self.State.LastTimestamp = os.clock()
        self.State.DetectionHits = 0
    end
end
function Modules.AntiCFrameTeleport:_onHeartbeat()
    local character = Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
        local now = os.clock()
        local deltaTime = math.max(now - (self.State.LastTimestamp or now), 1/240)
        local currentCFrame = rootPart.CFrame
        if not self.State.LastCFrame then
            self.State.LastCFrame, self.State.LastTimestamp = currentCFrame, now
            return
        end
        local distance = (currentCFrame.Position - self.State.LastCFrame.Position).Magnitude
        local speed = distance / deltaTime
        local maxAllowedSpeed, maxAllowedDistance = self:_getFlyAllowances(deltaTime)
        if distance > maxAllowedDistance or speed > maxAllowedSpeed then
            character:PivotTo(self.State.LastCFrame)
            self:_zeroVelocity(character)
            self.State.DetectionHits += 1
            if self.State.DetectionHits >= self.REPEAT_THRESHOLD then
                task.delay(self.LOCK_TIME, function()
                self.State.DetectionHits = 0
            end)
        end
    else
    self.State.DetectionHits = math.max(self.State.DetectionHits - 1, 0)
    self.State.LastCFrame = currentCFrame
end
self.State.LastTimestamp = now
end
function Modules.AntiCFrameTeleport:Enable()
    if self.State.Enabled then return end
        self.State.Enabled = true
        if Players.LocalPlayer.Character then
            self:_onCharacterAdded(Players.LocalPlayer.Character)
        end
        self.State.CharacterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(function(char)
        self:_onCharacterAdded(char)
    end)
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function()
    self:_onHeartbeat()
end)
DoNotif("Anti-CFrame Teleport: [Enabled]", 3)
end
function Modules.AntiCFrameTeleport:Disable()
    if not self.State.Enabled then return end
        self.State.Enabled = false
        if self.State.HeartbeatConnection then
            self.State.HeartbeatConnection:Disconnect()
            self.State.HeartbeatConnection = nil
        end
        if self.State.CharacterAddedConnection then
            self.State.CharacterAddedConnection:Disconnect()
            self.State.CharacterAddedConnection = nil
        end
        self.State.LastCFrame = nil
        self.State.LastTimestamp = 0
        self.State.DetectionHits = 0
        DoNotif("Anti-CFrame Teleport: [Disabled]", 3)
    end
    RegisterCommand({
    Name = "anticframetp",
    Aliases = {"acftp", "antiteleport"},
    Description = "Toggles a client-side anti-teleport to prevent CFrame changes."
    }, function(args)
    if Modules.AntiCFrameTeleport.State.Enabled then
        Modules.AntiCFrameTeleport:Disable()
    else
    Modules.AntiCFrameTeleport:Enable()
end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
Modules.FireRemotes = {
State = {
Enabled = false,
},
}
function Modules.FireRemotes:Initialize()
    RegisterCommand({
    Name = "fireremotes",
    Aliases = {"fremotes", "frem"},
    Description = "Attempts to fire every discoverable RemoteEvent and RemoteFunction."
    }, function(args)
    local CoreGui = game:GetService("CoreGui")
    local remoteCount = 0
    local failedCount = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not obj:IsDescendantOf(CoreGui) then
            task.spawn(function()
            local success, err
            if obj:IsA("RemoteEvent") then
                success, err = pcall(function()
                obj:FireServer()
            end)
        elseif obj:IsA("RemoteFunction") then
            success, err = pcall(function()
            obj:InvokeServer()
        end)
    end
    if success then
        remoteCount = remoteCount + 1
    else
    failedCount = failedCount + 1
end
end)
end
end
task.delay(2, function()
DoNotif("Fired " .. remoteCount .. " remotes.\nFailed: " .. failedCount .. " remotes.")
end)
end)
end
Modules.RemoveForces = {
State = {},
}
function Modules.RemoveForces:Initialize()
    RegisterCommand({
    Name = "deletevelocity",
    Aliases = {"dv", "removevelocity", "removeforces"},
    Description = "Removes all force/velocity instances from your character to counter flings or fix physics glitches."
    }, function(args)
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local forcesRemoved = 0
    for _, instance in ipairs(character:GetDescendants()) do
        if  instance:isA("BodyVelocity") or
            instance:isA("BodyGyro") or
            instance:isA("RocketPropulsion") or
            instance:isA("BodyAngularVelocity") or
            instance:isA("BodyForce") or
            instance:isA("BodyThrust") or
            instance:isA("VectorForce") or
            instance:isA("LineForce") or
            instance:isA("AngularVelocity")
            then
                instance:Destroy()
                forcesRemoved = forcesRemoved + 1
            end
        end
        DoNotif("Removed " .. forcesRemoved .. " force instances from your character.", 3)
    end)
end
Modules.TeleportToPlace = {
State = {},
}
function Modules.TeleportToPlace:Initialize()
    RegisterCommand({
    Name = "teleporttoplace",
    Aliases = {"toplace", "ttp"},
    Description = "Teleports you to a specific Roblox place using its ID."
    }, function(args)
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    if not args[1] then
        return DoNotif("Usage: teleporttoplace [PlaceId]", 5)
    end
    local placeId = tonumber(args[1])
    if not placeId then
        return DoNotif("Invalid PlaceId. It must be a number.", 5)
    end
    DoNotif("Attempting to teleport to " .. placeId .. "...", 3)
    local success, result = pcall(function()
    TeleportService:Teleport(placeId, localPlayer)
end)
if not success then
    DoNotif("Teleport failed: " .. tostring(result), 5)
end
end)
end
Modules.ToSpawn = {
State = {
Enabled = false,
},
}
function Modules.ToSpawn:Initialize()
    RegisterCommand({
    Name = "tospawn",
    Aliases = {"ts"},
    Description = "Teleports you to the nearest SpawnLocation."
    }, function(args)
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return DoNotif("HumanoidRootPart not found.", 3)
    end
    local closestSpawn = nil
    local shortestDistance = math.huge
    local rootPosition = root.Position
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("SpawnLocation") then
            local distance = (part.Position - rootPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestSpawn = part
            end
        end
    end
    if closestSpawn then
        root.CFrame = closestSpawn.CFrame * CFrame.new(0, 3, 0)
    else
    return DoNotif("No SpawnLocation found in workspace.", 3)
end
end)
end
Modules.TriggerRemoteTouch = {
State = {
IsExecuting = false
}
}
function Modules.TriggerRemoteTouch:_findPartFromPath(path)
    local current = Workspace
    for partName in path:gmatch("([^/]+)") do
        local found = nil
        for _, child in ipairs(current:GetChildren()) do
            if child.Name:lower() == partName:lower() then
                found = child
                break
            end
        end
        if not found then return nil end
            current = found
        end
        return current:IsA("BasePart") and current or nil
    end
    function Modules.TriggerRemoteTouch:Execute(targetPath)
        local self = Modules.TriggerRemoteTouch
        if self.State.IsExecuting then return DoNotif("A remote touch is already in progress.", 1) end
            if not targetPath then return DoNotif("Usage: ;touchpart [path/to/part]", 3) end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return DoNotif("Cannot trigger: Your character's HumanoidRootPart was not found.", 3) end
                    local targetPart = self:_findPartFromPath(targetPath)
                    if not targetPart then return DoNotif("Could not find a valid part at path: " .. targetPath, 3) end
                        self.State.IsExecuting = true
                        DoNotif("Attempting to trigger touch on: " .. targetPart:GetFullName(), 1.5)
                        if firetouchinterest then
                            pcall(function()
                            firetouchinterest(hrp, targetPart, 0)
                            RunService.Heartbeat:Wait()
                            firetouchinterest(hrp, targetPart, 1)
                            DoNotif("Successfully triggered touch via firetouchinterest.", 2)
                        end)
                    else
                    warn("Zuka's Warning: 'firetouchinterest' not found. Using CFrame fallback method for TriggerRemoteTouch.")
                    coroutine.wrap(function()
                    local originalCFrame = hrp.CFrame
                    local success, err = pcall(function()
                    hrp.CFrame = targetPart.CFrame
                    RunService.Heartbeat:Wait()
                    hrp.CFrame = originalCFrame
                end)
                if success then
                    DoNotif("Successfully triggered touch via CFrame method.", 2)
                else
                hrp.CFrame = originalCFrame
                DoNotif("CFrame method failed. The target part may be invalid.", 3)
                warn("TriggerRemoteTouch Error:", err)
            end
        end)()
    end
    task.wait(0.2)
    self.State.IsExecuting = false
end
function Modules.TriggerRemoteTouch:Initialize()
    local module = self
    RegisterCommand({
    Name = "touchpart",
    Aliases = {"trigger", "touch"},
    Description = "Remotely triggers the .Touched event on a part."
    }, function(args)
    local path = table.concat(args, "/")
    module:Execute(path)
end)
end
Modules.ScriptHunter = {
    State = {
        IsScanning = false
    }
}

function Modules.ScriptHunter:Execute(keywords)
    local self = Modules.ScriptHunter
    if self.State.IsScanning then return DoNotif("A script scan is already in progress.", 2) end
    if not keywords or #keywords == 0 then return DoNotif("Usage: ;huntscript <keyword1> [keyword2] ...", 3) end

    self.State.IsScanning = true
    DoNotif("Beginning script hunt for keywords: " .. table.concat(keywords, ", "), 3)

    task.spawn(function()
        local findings = {}
        local scriptsScanned = 0
        for _, script in ipairs(game:GetDescendants()) do
            if script:IsA("LuaSourceContainer") then
                local success, source = pcall(function() return script.Source end)
                if success and source then
                    scriptsScanned = scriptsScanned + 1
                    local lowerSource = source:lower()
                    local allKeywordsFound = true
                    for _, keyword in ipairs(keywords) do
                        if not lowerSource:find(keyword:lower(), 1, true) then
                            allKeywordsFound = false
                            break
                        end
                    end
                    if allKeywordsFound then
                        table.insert(findings, script:GetFullName())
                    end
                end
            end
            if scriptsScanned % 100 == 0 then task.wait() end
        end

        if #findings > 0 then
            DoNotif("Scan complete. Found " .. #findings .. " matching script(s). Results printed to console (F9).", 4)
            -- ARCHITECT'S NOTE: Corrected the malformed multi-line print statements.
            print("--- [Zuka's ScriptHunter Report] ---")
            for _, path in ipairs(findings) do
                print("  [!] Match Found: " .. path)
            end
            print("--------------------------------------")
        else
            DoNotif("Scan complete. No scripts found containing all specified keywords.", 3)
        end
        self.State.IsScanning = false
    end)
end

function Modules.ScriptHunter:Initialize()
    local module = self
    RegisterCommand({
        Name = "huntscript",
        Aliases = {"findscript", "scripthunt"},
        Description = "Scans all client scripts for keywords."
    }, function(args)
        module:Execute(args)
    end)
end

local ContextActionService = game:GetService("ContextActionService")

Modules.AdvancedAirwalk = {
    State = {
        IsEnabled = false,
        AirwalkPart = nil,
        RenderConnection = nil,
        Connections = {},
        GUIs = {},
        -- Input state
        IsTyping = false,
        Increase = false,
        Decrease = false,
        -- Physics state
        Offset = 0
    },
    Config = {
        VerticalSpeed = 1.75,
        Keybinds = {
            Increase = Enum.KeyCode.Space, -- Or Enum.KeyCode.E
            Decrease = Enum.KeyCode.LeftControl -- Or Enum.KeyCode.Q
        }
    },
    -- Forward-declare services for robustness
    Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        CoreGui = game:GetService("CoreGui")
    }
}


function Modules.AdvancedAirwalk:Disable()
    if not self.State.IsEnabled then
        return
    end

    -- Disconnect the main render loop first
    if self.State.RenderConnection then
        self.State.RenderConnection:Disconnect()
        self.State.RenderConnection = nil
    end

    -- Destroy the invisible airwalk part
    if self.State.AirwalkPart and self.State.AirwalkPart.Parent then
        self.State.AirwalkPart:Destroy()
    end
    self.State.AirwalkPart = nil

    -- Disconnect all input and event connections
    for key, conn in pairs(self.State.Connections) do
        if conn then
            conn:Disconnect()
        end
        self.State.Connections[key] = nil
    end

    -- Destroy all GUI elements
    for key, gui in pairs(self.State.GUIs) do
        if gui and gui.Parent then
            gui:Destroy()
        end
        self.State.GUIs[key] = nil
    end

    -- Reset state variables
    self.State.IsEnabled = false
    self.State.IsTyping = false
    self.State.Increase = false
    self.State.Decrease = false
    self.State.Offset = 0

    DoNotif("Advanced Airwalk: OFF", 2)
end


function Modules.AdvancedAirwalk:Enable()
    if self.State.IsEnabled then
        self:Disable()
    end
    self.State.IsEnabled = true

    local localPlayer = self.Services.Players.LocalPlayer
    local uis = self.Services.UserInputService
    local isMobile = uis.TouchEnabled

    DoNotif(isMobile and "Advanced Airwalk: ON" or "Advanced Airwalk: ON (Space & LCtrl)", 2)

    local function createMobileButton(parent, text, position, callbackDown, callbackUp)
        local button = Instance.new("TextButton")
        button.Parent = parent
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Position = position
        button.Size = UDim2.new(0.08, 0, 0.12, 0)
        button.Font = Enum.Font.SourceSansBold
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true

        Instance.new("UICorner", button).CornerRadius = UDim.new(0.2, 0)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5

        -- Event connections for press and release
        button.MouseButton1Down:Connect(callbackDown)
        button.MouseButton1Up:Connect(callbackUp)
        button.TouchTap:Connect(callbackDown) -- Handle quick taps
        button.TouchEnded:Connect(callbackUp)

        return button
    end

    --// Setup Input Handling (Platform-Specific)
    if isMobile then
        local mobileGui = Instance.new("ScreenGui", self.Services.CoreGui)
        mobileGui.Name = "AdvancedAirwalkMobileControls"
        mobileGui.ResetOnSpawn = false
        self.State.GUIs.MobileControls = mobileGui

        -- Create UP and DOWN buttons
        createMobileButton(mobileGui, "UP", UDim2.new(0.9, 0, 0.55, 0),
            function() self.State.Increase = true end,
            function() self.State.Increase = false end)

        createMobileButton(mobileGui, "DOWN", UDim2.new(0.9, 0, 0.7, 0),
            function() self.State.Decrease = true end,
            function() self.State.Decrease = false end)
    else
        -- Desktop input handling
        self.State.Connections.Focused = uis.TextBoxFocused:Connect(function() self.State.IsTyping = true end)
        self.State.Connections.Released = uis.TextBoxFocusReleased:Connect(function() self.State.IsTyping = false end)

        self.State.Connections.InputBegan = uis.InputBegan:Connect(function(input, gpe)
            if gpe or self.State.IsTyping then return end
            if input.KeyCode == self.Config.Keybinds.Increase then self.State.Increase = true end
            if input.KeyCode == self.Config.Keybinds.Decrease then self.State.Decrease = true end
        end)

        self.State.Connections.InputEnded = uis.InputEnded:Connect(function(input)
            if input.KeyCode == self.Config.Keybinds.Increase then self.State.Increase = false end
            if input.KeyCode == self.Config.Keybinds.Decrease then self.State.Decrease = false end
        end)
    end

    --// Create the physical Airwalk Part
    local awPart = Instance.new("Part")
    awPart.Name = "Zuka_AirwalkPart"
    awPart.Size = Vector3.new(8, 1.5, 8) -- Wider base for stability
    awPart.Transparency = 1
    awPart.Anchored = true
    awPart.CanCollide = true
    awPart.CanQuery = false -- Important for performance
    awPart.Parent = self.Services.Workspace
    self.State.AirwalkPart = awPart

    --// Main Render Loop
    self.State.RenderConnection = self.Services.RunService.RenderStepped:Connect(function()
        if not (self.State.IsEnabled and self.State.AirwalkPart and self.State.AirwalkPart.Parent) then
            -- Failsafe in case part is destroyed externally
            self:Disable()
            return
        end

        local success, char, root, hum = pcall(function()
            local c = localPlayer.Character
            return c, c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
        end)

        if not (success and char and root and hum and hum.Health > 0) then
            -- Hide the part if the character is missing or dead
            self.State.AirwalkPart.CanCollide = false
            return
        end
        
        self.State.AirwalkPart.CanCollide = true

        local hrpHalf = root.Size.Y * 0.5
        local feetFromRoot
        if hum.RigType == Enum.HumanoidRigType.R6 then
            feetFromRoot = hrpHalf + (hum.HipHeight > 0 and hum.HipHeight or 2)
        else
            feetFromRoot = hrpHalf + (hum.HipHeight or 2)
        end
        local baseOffset = feetFromRoot + (self.State.AirwalkPart.Size.Y * 0.5)

        -- Determine vertical movement from input state
        local delta = 0
        if self.State.Increase then delta = -self.Config.VerticalSpeed end
        if self.State.Decrease then delta = self.Config.VerticalSpeed end
        
        -- Update the offset smoothly
        self.State.Offset = self.State.Offset + delta
        
        -- Apply the new position to the airwalk part
        local newY = root.Position.Y - baseOffset - self.State.Offset
        self.State.AirwalkPart.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
    end)
end

--// --- Command Registration ---
RegisterCommand({
    Name = "airwalk",
    Aliases = {"float", "aw"},
    Description = "Toggles an advanced airwalk. Use Space/LCtrl or GUI to move."
}, function()
    -- This single command will now toggle the state.
    if Modules.AdvancedAirwalk.State.IsEnabled then
        Modules.AdvancedAirwalk:Disable()
    else
        Modules.AdvancedAirwalk:Enable()
    end
end)

RegisterCommand({
    Name = "unairwalk",
    Aliases = {"unfloat", "unaw"},
    Description = "Explicitly disables the advanced airwalk."
}, function()
    Modules.AdvancedAirwalk:Disable()
end)

Modules.Blackhole = {
    State = {
        IsEnabled = false,
        IsForceActive = false,
        TargetCFrame = CFrame.new(),
        BlackholePart = nil,      -- The invisible anchor part in the workspace
        BlackholeAttachment = nil, -- The specific point movers are attracted to
        Connections = {},
        UI = {}
    },
    Config = {
        ForceResponsiveness = 200,
        TorqueMagnitude = 100000,
        MoveKey = Enum.KeyCode.E,
        -- A unique name to identify physics objects created by this script for easy cleanup.
        MoverName = "Zuka_BlackholeMover"
    },
    Dependencies = {"RunService", "UserInputService", "Players", "Workspace", "CoreGui"},
    Services = {}
}


function Modules.Blackhole:_cleanupForces()
    for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
        if descendant.Name == self.Config.MoverName and descendant:IsA("Instance") then
            -- This also implicitly destroys the AlignPosition and Torque as they are parented to the attachment.
            descendant:Destroy()
        end
        -- Restore collision for parts we might have modified
        if descendant:IsA("BasePart") and not descendant.CanCollide then
            pcall(function() descendant.CanCollide = true end)
        end
    end
end

---
-- [Private] Applies the black hole physics forces to a given part if eligible.
--
function Modules.Blackhole:_applyForce(part)
    -- Only apply forces if the black hole is active and the part is a valid target.
    if not self.State.IsForceActive or not (part and part:IsA("BasePart")) then return end
    if part.Anchored or part:FindFirstAncestorOfClass("Humanoid") then return end
    
    -- Failsafe to prevent movers from being added to our own character parts.
    if part:IsDescendantOf(self.Services.Players.LocalPlayer.Character) then return end

    -- Clean up any existing physics movers to ensure ours takes priority.
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyMover") or child:IsA("RocketPropulsion") then
            child:Destroy()
        end
        if child.Name == self.Config.MoverName then
            child:Destroy()
        end
    end
    
    part.CanCollide = false
    
    -- Create and configure the new physics movers.
    local attachment = Instance.new("Attachment", part)
    attachment.Name = self.Config.MoverName -- Tag our instances for cleanup
    
    local align = Instance.new("AlignPosition", attachment)
    align.Attachment0 = attachment
    align.Attachment1 = self.State.BlackholeAttachment
    align.MaxForce = 1e9
    align.MaxVelocity = math.huge
    align.Responsiveness = self.Config.ForceResponsiveness
    
    local torque = Instance.new("Torque", attachment)
    torque.Attachment0 = attachment
    torque.Torque = Vector3.new(self.Config.TorqueMagnitude, self.Config.TorqueMagnitude, self.Config.TorqueMagnitude)
end


function Modules.Blackhole:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect all event listeners
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Restore simulation radii to default behavior
    pcall(function()
        for _, plr in ipairs(self.Services.Players:GetPlayers()) do
            plr.MaximumSimulationRadius = -1 -- -1 resets to default
        end
    end)
    
    self:_cleanupForces()

    -- Destroy the core black hole part and the UI
    if self.State.BlackholePart and self.State.BlackholePart.Parent then
        self.State.BlackholePart:Destroy()
    end
    if self.State.UI.ScreenGui and self.State.UI.ScreenGui.Parent then
        self.State.UI.ScreenGui:Destroy()
    end

    -- Reset state
    self.State = {
        IsEnabled = false,
        IsForceActive = false,
        TargetCFrame = CFrame.new(),
        Connections = {},
        UI = {}
    }
    DoNotif("Blackhole destroyed.", 2)
end


function Modules.Blackhole:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer

    -- Create the central black hole part and attachment
    local bhPart = Instance.new("Part")
    bhPart.Name = "Zuka_BlackholeCore"
    bhPart.Anchored = true
    bhPart.CanCollide = false
    bhPart.Transparency = 1
    bhPart.Size = Vector3.one
    self.State.BlackholePart = bhPart
    
    self.State.BlackholeAttachment = Instance.new("Attachment", bhPart)
    
    local mouse = localPlayer:GetMouse()
    self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
    bhPart.Parent = self.Services.Workspace


    self.State.Connections.SimRadius = self.Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, plr in ipairs(self.Services.Players:GetPlayers()) do
                if plr ~= localPlayer then plr.MaximumSimulationRadius = 0 end
            end
            localPlayer.MaximumSimulationRadius = 1e9
        end)
    end)

    self.State.Connections.PositionUpdate = self.Services.RunService.RenderStepped:Connect(function()
        if self.State.BlackholeAttachment then
            self.State.BlackholeAttachment.WorldCFrame = self.State.TargetCFrame
        end
    end)

    self.State.Connections.DescendantAdded = self.Services.Workspace.DescendantAdded:Connect(function(desc)
        self:_applyForce(desc)
    end)

    self.State.Connections.Input = self.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Config.MoveKey then
            self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
        end
    end)

    
    local screenGui = Instance.new("ScreenGui", self.Services.CoreGui)
    screenGui.Name = "BlackholeControlGUI"
    screenGui.ResetOnSpawn = false
    self.State.UI.ScreenGui = screenGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Text = "Enable Blackhole"
    toggleBtn.AnchorPoint = Vector2.new(0.5, 1)
    toggleBtn.Size = UDim2.fromOffset(160, 40)
    toggleBtn.Position = UDim2.new(0.5, 0, 0.93, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 18
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.25, 0)

    local moveBtn = toggleBtn:Clone()
    moveBtn.Name = "MoveButton"
    moveBtn.Text = "Move Blackhole (E)"
    moveBtn.Position = UDim2.new(0.5, 0, 0.99, 0)
    moveBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    moveBtn.Parent = screenGui

    -- UI Event Handlers
    toggleBtn.MouseButton1Click:Connect(function()
        self.State.IsForceActive = not self.State.IsForceActive
        toggleBtn.Text = self.State.IsForceActive and "Disable Blackhole" or "Enable Blackhole"
        
        if self.State.IsForceActive then
            DoNotif("Blackhole force enabled", 2)
            for _,v in ipairs(self.Services.Workspace:GetDescendants()) do self:_applyForce(v) end
        else
            self:_cleanupForces()
            DoNotif("Blackhole force disabled", 2)
        end
    end)

    moveBtn.MouseButton1Click:Connect(function()
        self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
    end)
    
    DoNotif("Blackhole created. Tap button or press E to move.", 3)
end


function Modules.Blackhole:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "blackhole",
        Aliases = {"bhole"},
        Description = "Toggles a client-sided black hole that pulls all unanchored parts."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
end


Modules.PathfinderFollow = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        FollowConnection = nil,
        -- Pathfinding state
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        LastSourcePos = Vector3.new(),
        LastTargetPos = Vector3.new()
    },
    Config = {
        -- How often (in seconds) the path is allowed to be recalculated.
        RECALCULATION_INTERVAL = 0.5,
        -- How far the player or target must move to trigger a path recalculation.
        RECALCULATION_DISTANCE = 3,
        -- How close we need to get to a waypoint to advance to the next one.
        WAYPOINT_PROXIMITY = 4,
        -- Parameters for the pathfinding algorithm.
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },
    Dependencies = {"PathfindingService", "RunService", "Players"},
    Services = {}
}


function Modules.PathfinderFollow:_onHeartbeat()
    if not (self.State.IsEnabled and self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        self:Disable()
        return
    end

    -- 1. Get all necessary character components safely.
    local localPlayer = self.Services.Players.LocalPlayer
    local localChar = localPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local localHum = localChar and localChar:FindFirstChildOfClass("Humanoid")
    
    local targetChar = self.State.TargetPlayer.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not (localHrp and localHum and targetHrp and localHum.Health > 0) then
        return -- Do nothing if characters are not in a valid state.
    end

    local sourcePos = localHrp.Position
    local targetPos = targetHrp.Position

    -- 2. Check if the path needs to be recalculated.
    local timeSinceRecalc = os.clock() - self.State.LastPathRecalculation
    local sourceMoved = (sourcePos - self.State.LastSourcePos).Magnitude > self.Config.RECALCULATION_DISTANCE
    local targetMoved = (targetPos - self.State.LastTargetPos).Magnitude > self.Config.RECALCULATION_DISTANCE

    if timeSinceRecalc > self.Config.RECALCULATION_INTERVAL and (sourceMoved or targetMoved) then
        self.State.LastPathRecalculation = os.clock()
        self.State.LastSourcePos = sourcePos
        self.State.LastTargetPos = targetPos
        
        -- Compute the path asynchronously.
        local success = pcall(function() self.State.Path:ComputeAsync(sourcePos, targetPos) end)
        
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 1 -- Reset to the beginning of the new path.
        end
    end

    -- 3. Traverse the current path without blocking.
    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if #waypoints == 0 or self.State.CurrentWaypointIndex > #waypoints then return end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        -- Check if we've reached the current waypoint.
        local distanceToWaypoint = (localHrp.Position - currentWaypoint.Position).Magnitude
        if distanceToWaypoint < self.Config.WAYPOINT_PROXIMITY then
            self.State.CurrentWaypointIndex = self.State.CurrentWaypointIndex + 1
        else
            -- If not close enough, continue moving towards it.
            if currentWaypoint.Action == Enum.PathWaypointAction.Jump then
                localHum.Jump = true
            end
            localHum:MoveTo(currentWaypoint.Position)
        end
    end
end

---
-- Disables the pathfinding loop and cleans up all state.
--
function Modules.PathfinderFollow:Disable()
    if not self.State.IsEnabled then return end

    if self.State.FollowConnection then
        self.State.FollowConnection:Disconnect()
        self.State.FollowConnection = nil
    end

    -- Stop the character's current movement
    pcall(function()
        local char = self.Services.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:MoveTo(hum.RootPart.Position) end
    end)
    
    DoNotif("Pathfinder follow disabled.", 2)
    
    -- Reset state
    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
    self.State.Path = nil
end

---
-- Enables pathfinding to follow a specified target player.
-- @param targetPlayer <Player> The player object to follow.
--
function Modules.PathfinderFollow:Enable(targetPlayer)
    if not targetPlayer or targetPlayer == self.Services.Players.LocalPlayer then
        DoNotif("Invalid target for pathfinding.", 3)
        return
    end

    self:Disable() -- Ensure a clean state before starting a new follow.

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)
    self.State.LastPathRecalculation = 0 -- Force initial calculation.

    -- Connect the main logic loop.
    self.State.FollowConnection = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)

    DoNotif("Pathfinder following: " .. targetPlayer.Name, 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.PathfinderFollow:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "pathfind",
        Aliases = {"follow"},
        Description = "Follow a player using PathfindingService."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            module:Disable()
            return
        end

        local target = Utilities.findPlayer(argument)
        if target then
            module:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.CharacterMorph = {
    State = {
        IsMorphed = false,
        OriginalDescription = nil,
        -- Connection to disconnect CharacterAdded event after reverting
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}


function Modules.CharacterMorph:_resolveDescription(target)
    local targetId = tonumber(target)
    
    -- If the target is not a valid number, assume it's a username and get the ID.
    if not targetId then
        local success, idFromName = pcall(function()
            return self.Services.Players:GetUserIdFromNameAsync(target)
        end)
        if not success or not idFromName then
            DoNotif("Could not find a user with the name: " .. tostring(target), 3)
            return nil
        end
        targetId = idFromName
    end

    -- Now, fetch the HumanoidDescription using the resolved UserId.
    DoNotif("Loading avatar for ID: " .. targetId, 1.5)
    local success, description = pcall(function()
        return self.Services.Players:GetHumanoidDescriptionFromUserId(targetId)
    end)

    if not success or not description then
        DoNotif("Unable to load avatar description for that user.", 3)
        return nil
    end

    return description
end


function Modules.CharacterMorph:_applyAndRespawn(description)
    local localPlayer = self.Services.Players.LocalPlayer
    if not description then return end

    -- Disconnect any previous post-respawn event to prevent conflicts.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end

    -- Connect a one-time event to apply the description as soon as the new character spawns.
    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Once(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- Wrap in a pcall as ApplyDescription can sometimes fail.
            pcall(humanoid.ApplyDescription, humanoid, description)
        end
    end)
    
    -- Trigger the respawn.
    localPlayer:LoadCharacter()
end

---
-- Morphs the player's character into the target's appearance.
-- @param target <string> The username or UserId of the target.
--
function Modules.CharacterMorph:Morph(target)
    if not target then
        DoNotif("Usage: ;char <username/userid>", 3)
        return
    end

    -- Cache the player's original description if we haven't already.
    if not self.State.OriginalDescription then
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then
            self.State.OriginalDescription = originalDesc
        else
            warn("[CharacterMorph] Could not cache original character description.")
        end
    end

    task.spawn(function()
        local newDescription = self:_resolveDescription(target)
        if newDescription then
            self.State.IsMorphed = true
            self:_applyAndRespawn(newDescription)
            DoNotif("Applying character morph...", 2)
        end
    end)
end

---
-- Reverts the player's character to their original appearance.
--
function Modules.CharacterMorph:Revert()
    if not self.State.IsMorphed then
        DoNotif("You are not currently morphed.", 2)
        return
    end

    if not self.State.OriginalDescription then
        DoNotif("Could not find original avatar to revert to. Re-fetching...", 3)
        -- Attempt to re-fetch if the cache was lost.
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then self.State.OriginalDescription = originalDesc end
    end
    
    if self.State.OriginalDescription then
        self:_applyAndRespawn(self.State.OriginalDescription)
        self.State.IsMorphed = false
        DoNotif("Reverting to original character...", 2)
    else
        DoNotif("Failed to revert character: Original description is missing.", 4)
    end
end

---
-- Initializes the module and registers its commands.
--
function Modules.CharacterMorph:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "char",
        Aliases = {"character", "morph"},
        Description = "Change your character's appearance to someone else's."
    }, function(args)
        module:Morph(args[1])
    end)

    RegisterCommand({
        Name = "unchar",
        Aliases = {},
        Description = "Reverts your character's appearance to your own."
    }, function()
        module:Revert()
    end)
end

Modules.StalkerBot = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        HasLineOfSight = false,
        OriginalNeckC0 = nil,
        Connections = {}
    },

    Config = {
        FollowDistance = 25,
        StopDistance = 15,
        RecalculationInterval = 1.0,
        LineOfSightInterval = 0.25,
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },

    Services = {}
}

--// --- Private: Core Logic ---

function Modules.StalkerBot:_onRenderStepped()
    if not (self.State.IsEnabled and self.State.TargetPlayer) then return end
    
    local success, myChar, targetChar = pcall(function()
        return self.Services.LocalPlayer.Character, self.State.TargetPlayer.Character
    end)
    if not (success and myChar and targetChar) then return end

    local myHead = myChar:FindFirstChild("Head")
    local targetHead = targetChar:FindFirstChild("Head")
    local myTorso = myChar:FindFirstChild("HumanoidRootPart")
    local neck = myChar:FindFirstChild("Neck", true) or (myTorso and myTorso:FindFirstChild("Neck", true))

    if not (myHead and targetHead and neck and neck:IsA("Motor6D")) then return end
    
    if not self.State.OriginalNeckC0 then
        self.State.OriginalNeckC0 = neck.C0
    end
    

    local lookAtCFrame = CFrame.lookAt(neck.Part0.Position, targetHead.Position)
    
    local objectSpaceRotation = neck.Part0.CFrame:ToObjectSpace(lookAtCFrame)
    
    neck.C0 = CFrame.new(self.State.OriginalNeckC0.Position) * (objectSpaceRotation - objectSpaceRotation.Position)
end

function Modules.StalkerBot:_onHeartbeat()
    if not self.State.IsEnabled then return end

    if not (self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        return self:Disable()
    end
    
    local myChar = self.Services.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = self.State.TargetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and myHumanoid and targetRoot and myHumanoid.Health > 0) then
        return
    end

    local distanceToTarget = (myRoot.Position - targetRoot.Position).Magnitude

    if distanceToTarget < self.Config.StopDistance then
        myHumanoid:MoveTo(myRoot.Position)
        return
    end

    local now = os.clock()
    if (now - self.State.LastPathRecalculation) > self.Config.RecalculationInterval then
        self.State.LastPathRecalculation = now
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {myChar, targetChar}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = self.Services.Workspace:Raycast(myRoot.Position, (targetRoot.Position - myRoot.Position).Unit * 1000, raycastParams)
        
        self.State.HasLineOfSight = (not raycastResult or raycastResult.Instance:IsDescendantOf(targetChar))

        local success, err = pcall(function()
            self.State.Path:ComputeAsync(myRoot.Position, targetRoot.Position)
        end)
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 2
        else
            myHumanoid:MoveTo(myRoot.Position)
        end
    end

    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if self.State.CurrentWaypointIndex > #waypoints then
            myHumanoid:MoveTo(myRoot.Position)
            return
        end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        if not self.State.HasLineOfSight or distanceToTarget > self.Config.FollowDistance then
            myHumanoid:MoveTo(currentWaypoint.Position)
            if (currentWaypoint.Position - myRoot.Position).Magnitude < 6 then
                self.State.CurrentWaypointIndex += 1
            end
        else
            myHumanoid:MoveTo(targetRoot.Position)
        end
    end
end

--// --- Public: Control Methods ---

function Modules.StalkerBot:Enable(targetPlayer: Player)
    if not targetPlayer or targetPlayer == self.Services.LocalPlayer then
        return DoNotif("Invalid target for StalkerBot.", 3)
    end
    if self.State.IsEnabled then self:Disable() end

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)

    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function() self:_onRenderStepped() end)

    DoNotif("StalkerBot Enabled: Now following " .. targetPlayer.Name, 3)
end

function Modules.StalkerBot:Disable()
    if not self.State.IsEnabled then return end
    
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    table.clear(self.State.Connections)

    if self.State.OriginalNeckC0 then
        pcall(function()
            local myChar = self.Services.LocalPlayer.Character
            local myTorso = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local neck = myChar and (myChar:FindFirstChild("Neck", true) or (myTorso and myTorso:FindFirstChild("Neck", true)))
            if neck and neck:IsA("Motor6D") then
                neck.C0 = self.State.OriginalNeckC0
            end
        end)
    end

    pcall(function()
        local myHumanoid = self.Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHumanoid then myHumanoid:MoveTo(myHumanoid.RootPart.Position) end
    end)
    
    self.State = {
        IsEnabled = false, TargetPlayer = nil, Path = nil, CurrentWaypointIndex = 1,
        LastPathRecalculation = 0, HasLineOfSight = false, OriginalNeckC0 = nil,
        Connections = {}
    }
    
    DoNotif("StalkerBot Disabled.", 2)
end

function Modules.StalkerBot:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.RunService = game:GetService("RunService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.PathfindingService = game:GetService("PathfindingService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "stalk",
        Aliases = {},
        Description = "Follows a player with uncanny pathfinding."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            self:Disable()
            return
        end
        local target = Utilities.findPlayer(argument)
        if target then
            self:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.StalkBot = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        HasLineOfSight = false,
        Connections = {}
    },

    Config = {
        FollowDistance = 80,
        StopDistance = 15,
        RecalculationInterval = 1.0,
        LineOfSightInterval = 0.25,
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },

    Services = {}
}



function Modules.StalkerBot:_onRenderStepped()
    if not (self.State.IsEnabled and self.State.TargetPlayer) then return end
    
    local success, myChar, targetChar = pcall(function()
        return self.Services.LocalPlayer.Character, self.State.TargetPlayer.Character
    end)
    if not (success and myChar and targetChar) then return end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and targetRoot) then return end

    -- Calculate the CFrame that looks at the target's position from our position.
    local lookAtCFrame = CFrame.lookAt(myRoot.Position, targetRoot.Position)
    
    myRoot.CFrame = CFrame.fromMatrix(myRoot.Position, lookAtCFrame.XVector, myRoot.CFrame.YVector)
end

function Modules.StalkerBot:_onHeartbeat()
    if not self.State.IsEnabled then return end

    if not (self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        return self:Disable()
    end
    
    local myChar = self.Services.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = self.State.TargetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and myHumanoid and targetRoot and myHumanoid.Health > 0) then
        return
    end

    local distanceToTarget = (myRoot.Position - targetRoot.Position).Magnitude

    if distanceToTarget < self.Config.StopDistance then
        myHumanoid:MoveTo(myRoot.Position)
        return
    end

    local now = os.clock()
    if (now - self.State.LastPathRecalculation) > self.Config.RecalculationInterval then
        self.State.LastPathRecalculation = now
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {myChar}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = self.Services.Workspace:Raycast(myRoot.Position, (targetRoot.Position - myRoot.Position), raycastParams)
        
        self.State.HasLineOfSight = (not raycastResult or raycastResult.Instance:IsDescendantOf(targetChar))

        local success, err = pcall(function()
            self.State.Path:ComputeAsync(myRoot.Position, targetRoot.Position)
        end)
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 2
        else
            myHumanoid:MoveTo(myRoot.Position)
        end
    end

    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if self.State.CurrentWaypointIndex > #waypoints then
            myHumanoid:MoveTo(myRoot.Position)
            return
        end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        if not self.State.HasLineOfSight or distanceToTarget > self.Config.FollowDistance then
            myHumanoid:MoveTo(currentWaypoint.Position)
            if (currentWaypoint.Position - myRoot.Position).Magnitude < 6 then
                self.State.CurrentWaypointIndex += 1
            end
        else
            myHumanoid:MoveTo(targetRoot.Position)
        end
    end
end


function Modules.StalkerBot:Enable(targetPlayer: Player)
    if not targetPlayer or targetPlayer == self.Services.LocalPlayer then
        return DoNotif("Invalid target for StalkerBot.", 3)
    end
    if self.State.IsEnabled then self:Disable() end

    pcall(function()
        self.Services.LocalPlayer.Character.Humanoid.AutoRotate = false
    end)

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)

    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function() self:_onRenderStepped() end)

    DoNotif("StalkBot Enabled: Now following " .. targetPlayer.Name, 3)
end

function Modules.StalkerBot:Disable()
    if not self.State.IsEnabled then return end
    
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    table.clear(self.State.Connections)

    -- [CRITICAL CHANGE] Give rotation control back to the Humanoid.
    pcall(function()
        local humanoid = self.Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
            humanoid:MoveTo(humanoid.RootPart.Position) -- Stop any movement
        end
    end)
    
    self.State = {
        IsEnabled = false, TargetPlayer = nil, Path = nil, CurrentWaypointIndex = 1,
        LastPathRecalculation = 0, HasLineOfSight = false, Connections = {}
    }
    
    DoNotif("StalkBot Disabled.", 2)
end

function Modules.StalkerBot:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.RunService = game:GetService("RunService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.PathfindingService = game:GetService("PathfindingService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "null",
        Aliases = {},
        Description = "Stalks a player with uncanny pathfinding."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            self:Disable()
            return
        end
        local target = Utilities.findPlayer(argument)
        if target then
            self:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.TimeStop = {
    State = {
        IsEnabled = false,
        Connections = {}
    },
    Dependencies = {"Players"},
    Services = {}
}

---
--
function Modules.TimeStop:_freezeCharacter(character)
    if not character then return end
    task.wait() 
    local success, err = pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
            end
        end
    end)
    if not success then warn("[TimeStop] Failed to freeze character:", err) end
end


function Modules.TimeStop:_unfreezeCharacter(character)
    if not character then return end
    pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = false
            end
        end
    end)
end

---
-- Disables the time stop effect and cleans up all resources.
--
function Modules.TimeStop:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect all event listeners to stop applying the freeze.
    for key, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Iterate through all players and unfreeze them.
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        if player.Character then
            self:_unfreezeCharacter(player.Character)
        end
    end

    self.State.IsEnabled = false
    DoNotif("Time has resumed.", 2)
end

---
-- Enables the time stop effect on all current and future players.
--
function Modules.TimeStop:Enable()
    if self.State.IsEnabled then return end
    -- It's good practice to call Disable first to ensure a clean state.
    self:Disable()
    self.State.IsEnabled = true

    -- [Helper] Sets up the freeze logic for a given player.
    local function setupPlayer(player)
        -- Don't freeze ourselves.
        if player == self.Services.Players.LocalPlayer then return end

        -- Freeze their current character if it exists.
        if player.Character then
            self:_freezeCharacter(player.Character)
        end
        
        -- Connect to their CharacterAdded event for future respawns.
        local conn = player.CharacterAdded:Connect(function(character)
            self:_freezeCharacter(character)
        end)
        
        -- Store the connection so we can disconnect it later.
        self.State.Connections[player.UserId] = conn
    end

    -- Apply to all existing players.
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        setupPlayer(player)
    end

    -- Connect to PlayerAdded to handle players who join while timestop is active.
    self.State.Connections.PlayerAdded = self.Services.Players.PlayerAdded:Connect(setupPlayer)
    
    DoNotif("ZA WARUDO! Time has been stopped.", 3)
end

function Modules.TimeStop:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "timestop",
        Aliases = {"tstop"},
        Description = "Toggles a client-sided freeze for all other players."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
    
    -- Keep the `untimestop` command for convenience, pointing it to the Disable function.
    RegisterCommand({
        Name = "untimestop",
        Aliases = {"untstop"},
        Description = "Explicitly disables the time stop effect."
    }, function()
        module:Disable()
    end)
end


Modules.AnimationSpeed = {
    State = {
        IsEnabled = false,
        TargetSpeed = 1,
        LoopConnection = nil
    },
    Dependencies = {"RunService", "Players"},
    Services = {}
}

---
-- Disables the animation speed override and cleans up resources.
--
function Modules.AnimationSpeed:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect the main loop to stop overriding the speed.
    if self.State.LoopConnection then
        self.State.LoopConnection:Disconnect()
        self.State.LoopConnection = nil
    end

    self.State.IsEnabled = false


    task.spawn(function()
        local char = self.Services.Players.LocalPlayer.Character
        if not char then return end
        
        local animator = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not animator then return end

        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(1)
            end
        end)
    end)
    
    DoNotif("Animation speed control disabled.", 2)
end

---
-- Enables or updates the animation speed override.
-- @param speed <number> The desired playback speed (e.g., 2 for double speed).
--
function Modules.AnimationSpeed:Enable(speed)
    local targetSpeed = tonumber(speed)
    if not targetSpeed or targetSpeed < 0 then
        DoNotif("Invalid speed. Must be a positive number.", 3)
        return
    end

    self.State.TargetSpeed = targetSpeed

    -- If the loop is already running, we just needed to update the speed value.
    if self.State.IsEnabled then
        DoNotif("Animation speed updated to " .. targetSpeed, 2)
        return
    end

    self.State.IsEnabled = true
    
    -- Connect the main loop to RunService.Stepped for physics-related updates.
    self.State.LoopConnection = self.Services.RunService.Stepped:Connect(function()
        local char = self.Services.Players.LocalPlayer.Character
        if not char then return end
        
        -- Find the Humanoid or AnimationController, which manages animations.
        local animator = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not animator then return end

        -- Use a pcall to prevent a single broken animation track from erroring the whole loop.
        local success, err = pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                -- Only adjust speed if it's not already at the target, to be efficient.
                if track.Speed ~= self.State.TargetSpeed then
                    track:AdjustSpeed(self.State.TargetSpeed)
                end
            end
        end)
        
        if not success then
            warn("[AnimationSpeed] Error during loop:", err)
            -- Automatically disable the module if a persistent error occurs.
            self:Disable()
        end
    end)

    DoNotif("Animation speed set to " .. targetSpeed, 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.AnimationSpeed:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "animspeed",
        Aliases = {},
        Description = "Adjusts local animation speed."
    }, function(args)
        local argument = args[1]
        
        if not argument or (argument:lower() == "off" or argument:lower() == "stop" or argument:lower() == "reset") then
            module:Disable()
        else
            module:Enable(argument)
        end
    end)

    -- Registering the "un" command for convenience, which simply calls the Disable function.
    RegisterCommand({
        Name = "unanimspeed",
        Aliases = {"unaspeed", "unanimationspeed"},
        Description = "Stops the animation speed adjustment loop."
    }, function()
        module:Disable()
    end)
end

Modules.ChatTranslator = {
    State = {
        IsEnabled = false,
        IsPersistent = false,   -- Is persistent translation enabled?
        TargetLang = "",        -- The language for persistent translation
        GoogleSession = {      -- State for the HTTP session
            fsid = nil,
            bl = nil,
            rid = math.random(1000, 9999),
            gv = ""
        },
        Connections = {}
    },
    Config = {
        -- The language incoming messages will be translated into.
        YourLanguage = "en",
        -- The prefix for one-off translation commands (e.g., ;tr ru Hello)
        CommandPrefix = ">" 
    },
    Dependencies = {"HttpService", "Players", "TextChatService", "CoreGui"},
    Services = {},
    -- A static lookup table of supported languages.
    LANGS = {
        auto="Automatic",af="Afrikaans",sq="Albanian",am="Amharic",ar="Arabic",hy="Armenian",az="Azerbaijani",eu="Basque",be="Belarusian",bn="Bengali",bs="Bosnian",bg="Bulgarian",ca="Catalan",ceb="Cebuano",ny="Chichewa",
        ["zh-cn"]="Chinese Simplified",["zh-tw"]="Chinese Traditional",co="Corsican",hr="Croatian",cs="Czech",da="Danish",nl="Dutch",en="English",eo="Esperanto",et="Estonian",tl="Filipino",fi="Finnish",fr="French",fy="Frisian",
        gl="Galician",ka="Georgian",de="German",el="Greek",gu="Gujarati",ht="Haitian Creole",ha="Hausa",haw="Hawaiian",iw="Hebrew",hi="Hindi",hmn="Hmong",hu="Hungarian",is="Icelandic",ig="Igbo",id="Indonesian",ga="Irish",it="Italian",
        ja="Japanese",jw="Javanese",kn="Kannada",kk="Kazakh",km="Khmer",ko="Korean",ku="Kurdish (Kurmanji)",ky="Kyrgyz",lo="Lao",la="Latin",lv="Latvian",lt="Lithuanian",lb="Luxembourgish",mk="Macedonian",mg="Malagasy",ms="Malay",
        ml="Malayalam",mt="Maltese",mi="Maori",mr="Marathi",mn="Mongolian",my="Myanmar (Burmese)",ne="Nepali",no="Norwegian",ps="Pashto",fa="Persian",pl="Polish",pt="Portuguese",pa="Punjabi",ro="Romanian",ru="Russian",sm="Samoan",
        gd="Scots Gaelic",sr="Serbian",st="Sesotho",sn="Shona",sd="Sindhi",si="Sinhala",sk="Slovak",sl="Slovenian",so="Somali",es="Spanish",su="Sundanese",sw="Swahili",sv="Swedish",tg="Tajik",ta="Tamil",te="Telugu",th="Thai",tr="Turkish",
        uk="Ukrainian",ur="Urdu",uz="Uzbek",vi="Vietnamese",cy="Welsh",xh="Xhosa",yi="Yiddish",yo="Yoruba",zu="Zulu"
    }
}

---
-- [Private] Sends a system message to the local player's chat.
-- @param message <string> The message to display.
--
function Modules.ChatTranslator:_sys(message)
    local chans = self.Services.TextChatService:WaitForChild("TextChannels")
    local systemChannel = chans:FindFirstChild("RBXSystem") or chans:FindFirstChild("RBXGeneral") or chans:GetChildren()[1]
    if systemChannel and systemChannel.DisplaySystemMessage then
        systemChannel:DisplaySystemMessage(message)
    end
end

---
-- [Private] Performs an HTTP request with Google Consent cookie handling.
--
function Modules.ChatTranslator:_request(url, method, body)
    local session = self.State.GoogleSession
    local success, response = pcall(function()
        return self.Services.HttpService:RequestAsync({
            Url = url,
            Method = method or "GET",
            Headers = {cookie = "CONSENT=YES+" .. (session.gv or "")},
            Body = body
        })
    end)
    
    if not success then warn("[Translator] HTTP Request failed:", response); return nil end

    if response.Body and response.Body:match("https://consent.google.com/s") then
        local consentData = {}
        for tag in response.Body:gmatch('<input type="hidden" name=".-" value=".-">') do
            local k, v = tag:match('<input type="hidden" name="(.-)" value="(.-)">')
            consentData[k] = v
        end
        session.gv = consentData.v or ""
        -- Retry the request with the new consent value
        return self:_request(url, method, body)
    end
    
    return response
end


function Modules.ChatTranslator:_translate(text, targetLang, sourceLang)
    local session = self.State.GoogleSession
    session.rid += 10000
    
    local targetIso = self:_iso(targetLang) or "en"
    local sourceIso = self:_iso(sourceLang) or "auto"
    
    local data = {{text, sourceIso, targetIso, true}, {nil}}
    local freq = {{{"MkEWBc", self.Services.HttpService:JSONEncode(data), nil, "generic"}}}
    
    local queryParams = {
        rpcids = "MkEWBc",
        ["f.sid"] = session.fsid,
        bl = session.bl,
        hl = "en",
        _reqid = session.rid - 10000,
        rt = "c"
    }
    local url = "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute?" .. self.Services.HttpService:UrlEncode(queryParams)
    local body = "f.req=" .. self.Services.HttpService:UrlEncode(self.Services.HttpService:JSONEncode(freq))
    
    local response = self:_request(url, "POST", body)
    if not (response and response.Success and response.Body) then return nil end

    local ok, out = pcall(function()
        local arr = self.Services.HttpService:JSONDecode(response.Body:match("%[.-%]\n"))
        return self.Services.HttpService:JSONDecode(arr[1][3])
    end)
    
    if not ok then return nil end

    return out[2][1][1][6][1][1], out[3]
end

---
-- [Private] Resolves a full language name or code to its ISO code.
--
function Modules.ChatTranslator:_iso(s)
    if not s then return end
    s = tostring(s):lower()
    for k, v in pairs(self.LANGS) do
        if k:lower() == s or v:lower() == s then
            return k
        end
    end
    return nil
end

---
-- [Private] Handles incoming chat messages for translation.
--
function Modules.ChatTranslator:_onIncomingMessage(messageObject)
    if not self.State.IsEnabled then return end
    if not messageObject.TextSource or messageObject.TextSource.UserId == self.Services.Players.LocalPlayer.UserId then return end

    local sourcePlayer = self.Services.Players:GetPlayerByUserId(messageObject.TextSource.UserId)
    if not sourcePlayer then return end

    local displayName = sourcePlayer.DisplayName
    local userName = sourcePlayer.Name
    local nameString = (displayName == userName) and ("@"..userName) or ("%s (@%s)"):format(displayName, userName)

    local translatedText, detectedLang = self:_translate(messageObject.Text, self.Config.YourLanguage, "auto")
    
    if translatedText and translatedText ~= "" and translatedText ~= messageObject.Text then
        local langTag = detectedLang and detectedLang:upper() or "AUTO"
        self:_sys(("(%s) [%s]: %s"):format(langTag, nameString, translatedText))
    end
end

---
-- [Private] Handles outgoing chat messages for translation commands.
--
function Modules.ChatTranslator:_onOutgoingMessage(messageObject)
    if not self.State.IsEnabled then return false end
    
    local text = messageObject.Text
    
    -- Check for one-off translation command (e.g., >ru Hello)
    local code, msg = text:match("^" .. self.Config.CommandPrefix .. "(%S+)%s+(.+)$")
    if code and msg then
        local lang = self:_iso(code)
        if lang then
            local translated = self:_translate(msg, lang, "auto") or msg
            self.Services.TextChatService.TextChannels.RBXGeneral:SendAsync(translated)
            self:_sys("[TR] Sent in " .. lang)
        else
            self:_sys("[TR] Invalid language code: " .. code)
        end
        return true -- Was a command, so we should cancel the original message
    end

    -- Persistent translation logic
    if self.State.IsPersistent and text:sub(1, 1) ~= ";" and text:sub(1, 1) ~= self.Config.CommandPrefix then
        local translated = self:_translate(text, self.State.TargetLang, "auto") or text
        self.Services.TextChatService.TextChannels.RBXGeneral:SendAsync(translated)
        return true -- Cancel original message
    end

    return false -- Not a command we handle
end

---
-- Disables the Chat Translator and cleans up all connections.
--
function Modules.ChatTranslator:Disable()
    if not self.State.IsEnabled then return end
    
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)
    
    self.State.IsEnabled = false
    self.State.IsPersistent = false
    self.State.TargetLang = ""
    
    DoNotif("Chat Translator: DISABLED.", 2)
end

---
-- Enables the Chat Translator, fetches session tokens, and connects to chat events.
--
function Modules.ChatTranslator:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    -- Initialize Google Translate session in the background
    task.spawn(function()
        local response = self:_request("https://translate.google.com/")
        if response and response.Body then
            self.State.GoogleSession.fsid = response.Body:match('"FdrFJe":"(.-)"')
            self.State.GoogleSession.bl = response.Body:match('"cfb2h":"(.-)"')
            if self.State.GoogleSession.fsid then
                self:_sys("[TR] Chat Translator ready.")
            else
                warn("[Translator] Failed to get session tokens from Google Translate.")
                self:_sys("[TR] Error: Could not initialize session.")
            end
        end
    end)

    -- Hook into incoming messages
    self.State.Connections.Incoming = self.Services.TextChatService.MessageReceived:Connect(function(msg)
        self:_onIncomingMessage(msg)
    end)

    -- Hook into outgoing messages
    self.State.Connections.Outgoing = self.Services.TextChatService.SendingMessage:Connect(function(msg)
        if self:_onOutgoingMessage(msg) then
            msg.ShouldSend = false -- Cancel the original message if it was handled
        end
    end)
    
    DoNotif("Chat Translator: ENABLED.", 2)
end

---
-- Initializes the module and registers commands.
--
function Modules.ChatTranslator:Initialize()
    local module = self -- For context inside command functions
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "translator",
        Aliases = {"tr", "translate"},
        Description = "Toggles the chat translator."
    }, function(args)
        if not module.State.IsEnabled then module:Enable() end

        local subCommand = args[1] and args[1]:lower()
        
        if subCommand == "on" then
             if not module.State.IsEnabled then module:Enable() end
             return
        end
        if subCommand == "off" then
            module:Disable()
            return
        end
        if subCommand == "set" then
            local lang = module:_iso(args[2])
            if lang then
                module.State.IsPersistent = true
                module.State.TargetLang = lang
                DoNotif("Translator set to persistently translate to: " .. lang, 3)
            else
                DoNotif("Invalid language code. Use ;trlangs to see a list.", 3)
            end
            return
        end
        if subCommand == "stop" or subCommand == "disable" then
            module.State.IsPersistent = false
            DoNotif("Persistent translation disabled.", 2)
            return
        end
        
        -- One-off translation
        local lang = module:_iso(args[1])
        if lang then
            table.remove(args, 1)
            local message = table.concat(args, " ")
            local translated = module:_translate(message, lang, "auto") or message
            module.Services.TextChatService.TextChannels.RBXGeneral:SendAsync(translated)
            module:_sys("[TR] Sent in " .. lang)
        else
            DoNotif("Usage: ;tr [lang] [message] OR ;tr set [lang]", 4)
        end
    end)

    RegisterCommand({
        Name = "trlangs",
        Description = "Lists all available language codes for the translator."
    }, function()
        local codes = {}
        for code, _ in pairs(module.LANGS) do table.insert(codes, code) end
        table.sort(codes)
        
        local message = "[TR] Languages: " .. table.concat(codes, ", ")
        DoNotif("Printed language list to system chat.", 2)
        module:_sys(message)
    end)
    
    -- Enable by default when the script runs
    self:Enable()
end

Modules.Spider = {
    State = {
        IsEnabled = false,
        ActiveWeld = nil -- Will store the active Weld instance
    }
}

--- Enables the Spider module, welding the character to the ceiling.
function Modules.Spider:Enable()
    if self.State.IsEnabled then return end

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return DoNotif("Spider failed: Character root not found.", 2)
    end

    -- Raycast upward to find a ceiling
    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, 1, 0) * 10 -- Look 10 studs up
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if result and result.Instance then
        local ceilingPart = result.Instance
        DoNotif("Surface found. Engaging spider protocol.", 1.5)

        -- Create and configure the weld
        local weld = Instance.new("Weld")
        weld.Part0 = hrp
        weld.Part1 = ceilingPart
        
        -- ARCHITECT'S NOTE: The C0 CFrame defines the offset from the HRP.
        -- We calculate the position of the hit relative to the HRP's CFrame and add a
        -- small downward offset to prevent clipping into the ceiling.
        local hitCFrame = CFrame.new(result.Position)
        weld.C0 = hrp.CFrame:Inverse() * (hitCFrame * CFrame.new(0, -2.5, 0))
        
        weld.Parent = hrp -- Activating the weld

        self.State.ActiveWeld = weld
        self.State.IsEnabled = true
    else
        DoNotif("No surface found above.", 2)
    end
end

--- Disables the Spider module and restores normal physics.
function Modules.Spider:Disable()
    if not self.State.IsEnabled then return end
    
    -- Safely destroy the weld if it exists
    if self.State.ActiveWeld and self.State.ActiveWeld.Parent then
        self.State.ActiveWeld:Destroy()
    end

    self.State.ActiveWeld = nil
    self.State.IsEnabled = false
    DoNotif("Spider protocol disengaged.", 1.5)
end

--- Toggles the state of the module.
function Modules.Spider:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--// --- COMMAND REGISTRATION ---
RegisterCommand({
    Name = "spider",
    Aliases = {"sp", "cling"},
    Description = "Toggles a weld to the surface directly above your character."
}, function()
    Modules.Spider:Toggle()
end)

Modules.Attacher = {
    State = {
        isGuiBuilt = false,
        followSpeed = 1,
        selectedPlayerName = "Nearest Player",
        isFollowing = false,
        isAttaching = false,
        
        -- UI and Connection Storage
        UI = {},
        Connections = {}
    },
    Services = {}
}

--// Deactivation Logic (Cleanup)
function Modules.Attacher:Deactivate()
    if not self.State.isGuiBuilt then return end

    -- Disconnect all active RunService/input connections
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Destroy all UI elements
    if self.State.UI.window and self.State.UI.window.Parent then
        self.State.UI.window:Destroy()
    end
    if self.State.UI.currentHighlight and self.State.UI.currentHighlight.Parent then
        self.State.UI.currentHighlight:Destroy()
    end
    table.clear(self.State.UI)
    
    self.State.isGuiBuilt = false
    DoNotif("Attacher module deactivated.", 2)
end

--// Activation Logic (Initialization)
function Modules.Attacher:Activate()
    if self.State.isGuiBuilt then return end
    
    -- Localize self for easier access within functions
    local self = self

    --// --- Services & Player Variables ---
    self.Services.Players = self.Services.Players or game:GetService("Players")
    self.Services.RunService = self.Services.RunService or game:GetService("RunService")
    self.Services.StarterGui = self.Services.StarterGui or game:GetService("StarterGui")
    local LocalPlayer = self.Services.Players.LocalPlayer

    --// --- UI and Core Logic ---
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
    local w = library:CreateWindow("Attacher")
    self.State.UI.window = w

    --// --- Internal Functions ---
    local function notify(title, text, duration)
        pcall(function()
            self.Services.StarterGui:SetCore("SendNotification", {
                Title = title; Text = text; Duration = duration or 3;
            })
        end)
    end

    local function clearHighlight()
        if self.State.UI.currentHighlight and self.State.UI.currentHighlight.Parent then
            self.State.UI.currentHighlight:Destroy()
            self.State.UI.currentHighlight = nil
        end
    end

    local function applyHighlight(targetPlayer)
        clearHighlight()
        if targetPlayer and targetPlayer.Character then
            local h = Instance.new("Highlight", targetPlayer.Character)
            h.Name = "TargetHighlight"
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.45
            h.Adornee = targetPlayer.Character
            self.State.UI.currentHighlight = h
        end
    end

    local function findPlayerByPartialName(partialName)
        -- This function remains the same as your previous version
        local localChar = LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos = localChar.HumanoidRootPart.Position
        local lowerPartialName = partialName:lower()
        local matches = {}
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if p.Name:lower():find(lowerPartialName, 1, true) or p.DisplayName:lower():find(lowerPartialName, 1, true) then
                    table.insert(matches, p)
                end
            end
        end
        if #matches == 0 then return nil end
        if #matches == 1 then return matches[1] end
        local closestPlayer, closestDist = nil, math.huge
        for _, matchedPlayer in ipairs(matches) do
            if matchedPlayer.Character and matchedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (matchedPlayer.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist, closestPlayer = dist, matchedPlayer
                end
            end
        end
        return closestPlayer
    end
    
    local function updateNearestPlayerButton()
        if not self.State.UI.nearestPlayerButton then return end
        if self.State.selectedPlayerName == "Nearest Player" then
            self.State.UI.nearestPlayerButton.Name = "-> Nearest Player"
        else
            self.State.UI.nearestPlayerButton.Name = "Nearest Player"
        end
    end

    -- Build the GUI
    local mainFolder = w:CreateFolder("Follow Settings")
    mainFolder:Slider("Speed", {min = 0; max = 5; precise = true;}, function(value)
        self.State.followSpeed = value
    end)
    mainFolder:Box("Enter Username", "string", function(value)
        if value == "" then notify("Input Error", "Please type a valid username.", 3) return end
        local found = findPlayerByPartialName(value)
        if found and found ~= LocalPlayer then
            self.State.selectedPlayerName = found.Name
            applyHighlight(found)
            notify("Player Selected", "Targeting " .. found.Name, 2)
            updateNearestPlayerButton()
        else
            self.State.selectedPlayerName = "Nearest Player"
            updateNearestPlayerButton()
            notify("Player Not Found", "Could not find player: " .. value, 3)
        end
    end)
    self.State.UI.nearestPlayerButton = mainFolder:Button("-> Nearest Player", function()
        self.State.selectedPlayerName = "Nearest Player"
        clearHighlight()
        notify("Player Selected", "Nearest Player", 2)
        updateNearestPlayerButton()
    end)
    mainFolder:Toggle("Enable Following", function(bool)
        self.State.isFollowing = bool
        notify("Following", bool and "Enabled" or "Disabled")
    end)
    mainFolder:Toggle("Attach", function(bool)
        self.State.isAttaching = bool
        notify("Attach", bool and "Enabled" or "Disabled")
    end)

    -- Helper functions for the main loop
    local function getNearestPlayer()
        local localChar = LocalPlayer.Character
        if not (localChar and localChar:FindFirstChild("HumanoidRootPart")) then return nil end
        local myPos = localChar.HumanoidRootPart.Position
        local closest, dist = nil, math.huge
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if d < dist then closest, dist = p, d end
            end
        end
        return closest
    end

    local function getSelectedPlayer()
        if self.State.selectedPlayerName == "Nearest Player" then
            local n = getNearestPlayer()
            if n then applyHighlight(n) else clearHighlight() end
            return n
        elseif self.State.selectedPlayerName and self.Services.Players:FindFirstChild(self.State.selectedPlayerName) then
            local p = self.Services.Players[self.State.selectedPlayerName]
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                return p
            end
        end
        clearHighlight()
        return nil
    end

    --// --- Event Connections ---
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function()
        local target = getSelectedPlayer()
        if (self.State.isFollowing or self.State.isAttaching) and target then
            local localChar, targetChar = LocalPlayer.Character, target.Character
            if localChar and targetChar then
                local part, targetPart = localChar:FindFirstChild("HumanoidRootPart"), targetChar:FindFirstChild("HumanoidRootPart")
                if part and targetPart then
                    local hum = localChar:FindFirstChildOfClass("Humanoid")
                    if hum then hum.AutoRotate = false end

                    if self.State.isAttaching then
                        part.CFrame = part.CFrame:Lerp(targetPart.CFrame, self.State.followSpeed)
                        local thum = targetChar:FindFirstChildOfClass("Humanoid")
                        if thum and thum.Jump then hum.Jump = true end
                    elseif self.State.isFollowing then
                        part.CFrame = part.CFrame:Lerp(CFrame.new(part.Position, targetPart.Position), self.State.followSpeed)
                        hum:MoveTo(targetPart.Position)
                    end
                end
            end
        else
            local c = LocalPlayer.Character
            if c and c:FindFirstChildOfClass("Humanoid") then c:FindFirstChildOfClass("Humanoid").AutoRotate = true end
        end
    end)

    self.State.Connections.KeyDown = LocalPlayer:GetMouse().KeyDown:Connect(function(k)
        k = k:lower()
        if k == "x" then
            self.State.isFollowing = not self.State.isFollowing
            notify("Following", self.State.isFollowing and "Enabled" or "Disabled")
        elseif k == "z" then
            self.State.isAttaching = not self.State.isAttaching
            notify("Attach", self.State.isAttaching and "Enabled" or "Disabled")
        end
    end)
    
    self.State.isGuiBuilt = true
    DoNotif("Attacher module activated.", 2)
end

--// Main Toggle Function
function Modules.Attacher:Toggle()
    if self.State.isGuiBuilt then
        self:Deactivate()
    else
        self:Activate()
    end
end

RegisterCommand({
    Name = "attacher",
    Aliases = {"attachui", "followui"},
    Description = "Toggles the Player Attacher/Follower UI."
}, function()
    -- This ensures the module is initialized before being used
    if not Modules.Attacher.Toggle then
        -- Handle potential script reloads by re-attaching methods if necessary
        -- (This is an advanced robustness check)
        local originalFunctions = loadfile("path/to/your/AttacherModule.lua")()
        Modules.Attacher.Activate = originalFunctions.Activate
        Modules.Attacher.Deactivate = originalFunctions.Deactivate
        Modules.Attacher.Toggle = originalFunctions.Toggle
    end
    Modules.Attacher:Toggle()
end)

Modules.AntiCheatBypass = {
    State = {
        IsEnabled = false,
        HookedHumanoids = setmetatable({}, {__mode = "k"}), 
        Connections = {}
    },
    Config = {
        VANILLA_WALKSPEED = 16,
        VANILLA_JUMPPOWER = 50,
        TRUE_WALKSPEED_KEY = "AntiCheatBypass_TrueWalkSpeed",
        TRUE_JUMPPOWER_KEY = "AntiCheatBypass_TrueJumpPower"
    }
}

--- Applies the metatable hooks to a character's humanoid.
function Modules.AntiCheatBypass:_applyHooks(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or self.State.HookedHumanoids[humanoid] then
        return
    end

    local success, mt = pcall(getrawmetatable, humanoid)
    if not success or typeof(mt) ~= "table" then
        warn("AntiCheatBypass: Failed to get humanoid metatable. Environment may not be supported.")
        return
    end

    local originalIndex = mt.__index
    local originalNewIndex = mt.__newindex
    self.State.HookedHumanoids[humanoid] = { originalIndex, originalNewIndex }

    humanoid[self.Config.TRUE_WALKSPEED_KEY] = humanoid.WalkSpeed
    humanoid[self.Config.TRUE_JUMPPOWER_KEY] = humanoid.JumpPower

    setreadonly(mt, false)

    mt.__index = function(self, key)
        if key == "WalkSpeed" then
            return Modules.AntiCheatBypass.Config.VANILLA_WALKSPEED
        end
        if key == "JumpPower" then
            return Modules.AntiCheatBypass.Config.VANILLA_JUMPPOWER
        end
        return originalIndex(self, key)
    end

    mt.__newindex = function(self, key, value)
        if key == "WalkSpeed" then
            humanoid[Modules.AntiCheatBypass.Config.TRUE_WALKSPEED_KEY] = value
            return
        end
        if key == "JumpPower" then
            humanoid[Modules.AntiCheatBypass.Config.TRUE_JUMPPOWER_KEY] = value
            return
        end
        return originalNewIndex(self, key, value)
    end

    setreadonly(mt, true)
end

--- Removes the metatable hooks and restores original behavior.
function Modules.AntiCheatBypass:_removeHooks(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not self.State.HookedHumanoids[humanoid] then
        return
    end

    local success, mt = pcall(getrawmetatable, humanoid)
    if not success or typeof(mt) ~= "table" then
        return
    end

    local originalMeta = self.State.HookedHumanoids[humanoid]
    setreadonly(mt, false)
    mt.__index = originalMeta[1]
    mt.__newindex = originalMeta[2]
    setreadonly(mt, true)

    if humanoid[self.Config.TRUE_WALKSPEED_KEY] then
        humanoid.WalkSpeed = humanoid[self.Config.TRUE_WALKSPEED_KEY]
    end
    if humanoid[self.Config.TRUE_JUMPPOWER_KEY] then
        humanoid.JumpPower = humanoid[self.Config.TRUE_JUMPPOWER_KEY]
    end

    self.State.HookedHumanoids[humanoid] = nil
end

--- Enables the Anti-Cheat Bypass system.
function Modules.AntiCheatBypass:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    if LocalPlayer.Character then
        self:_applyHooks(LocalPlayer.Character)
    end

    self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
        self:_applyHooks(character)
    end)
    self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
        self:_removeHooks(character)
    end)

    DoNotif("Anti-Cheat Bypass: ENABLED. Humanoid properties sanitized.", 3)
end

--- Disables the Anti-Cheat Bypass system.
function Modules.AntiCheatBypass:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    if LocalPlayer.Character then
        self:_removeHooks(LocalPlayer.Character)
    end

    for humanoid, _ in pairs(self.State.HookedHumanoids) do
        if humanoid.Parent then
            self:_removeHooks(humanoid.Parent)
        end
    end

    DoNotif("Anti-Cheat Bypass: DISABLED. Humanoid properties restored.", 3)
end

--- Toggles the state of the bypass.
function Modules.AntiCheatBypass:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- [FIX]: This entire function call was missing, causing the syntax error on the next module.
RegisterCommand({
    Name = "acbypass",
    Aliases = {"anticheatbypass", "sanitize"},
    Description = "Toggles a bypass that makes your WalkSpeed and JumpPower appear normal to client-side anti-cheats."
}, function()
    Modules.AntiCheatBypass:Toggle()
end)

Modules.AntiVoid = {
    State = {
        IsEnabled = false,
        Connection = nil
    },
    Config = {
        -- How many studs above the void kill-height to trigger the teleport.
        -- A higher value is safer but might trigger on maps with very low areas.
        SafetyBuffer = 15 
    }
}

--- Finds a safe spawn point, with a fallback to a default coordinate.
-- @return CFrame - The CFrame of a safe location to teleport to.
function Modules.AntiVoid:_getSafeSpawnPoint()
    local spawnLocations = {}
    -- Search the entire workspace for any available SpawnLocation
    for _, descendant in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if descendant:IsA("SpawnLocation") then
            table.insert(spawnLocations, descendant)
        end
    end

    if #spawnLocations > 0 then
        -- Return the CFrame of the first valid spawn found, with a vertical offset.
        return spawnLocations[1].CFrame * CFrame.new(0, 3, 0)
    else
        -- Fallback in case no SpawnLocation objects exist in the game.
        return CFrame.new(0, 50, 0)
    end
end

--- Enables the anti-void check.
function Modules.AntiVoid:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    -- Bind the check to Heartbeat, which runs after every physics step.
    self.State.Connection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local voidLevel = Workspace.FallenPartsDestroyHeight
        
        -- Check if the player has fallen below the trigger height
        if hrp.Position.Y < (voidLevel + self.Config.SafetyBuffer) then
            local safeCFrame = self:_getSafeSpawnPoint()
            
            -- Teleport the character and reset their velocity to stabilize them.
            hrp.CFrame = safeCFrame
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end)

    DoNotif("Anti-Void: ENABLED.", 2)
end

--- Disables the anti-void check and cleans up connections.
function Modules.AntiVoid:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect the Heartbeat connection to prevent resource leaks.
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("Anti-Void: DISABLED.", 2)
end

--- Toggles the anti-void state.
function Modules.AntiVoid:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "antivoid", Aliases = { "novoid" }, Description = "Toggles an anti-void system that teleports you to spawn before you die." }, function() Modules.AntiVoid:Toggle() end)

Modules.AdvancedShiftLock = {
    State = {
        IsEnabled = false, 
        IsLocked = false,  
        UI = {},
        Connections = {},
        Originals = {} 
    },
    Config = {
        Icons = {
            On = "rbxasset://textures/ui/mouseLock_on.png",
            Off = "rbxasset://textures/ui/mouseLock_off.png"
        }
    },
    Dependencies = {"Players", "TweenService", "UserInputService", "RunService", "Workspace", "CoreGui"},
    Services = {}
}

---
-- [FIX] Added the missing _makeDraggable helper function.
--
function Modules.AdvancedShiftLock:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.AdvancedShiftLock:_faceCamera(state)
    if self.State.Connections.Rotation then
        self.State.Connections.Rotation:Disconnect()
        self.State.Connections.Rotation = nil
    end

    local char = self.Services.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if state then 
        self.State.Originals.AutoRotate = hum.AutoRotate
        hum.AutoRotate = false
        
        self.State.Connections.Rotation = self.Services.RunService.RenderStepped:Connect(function()
            local hrp = hum.RootPart
            local camera = self.Services.Workspace.CurrentCamera
            if not (hrp and camera) then return end
            
            local lookVector = camera.CFrame.LookVector
            local flatVector = Vector3.new(lookVector.X, 0, lookVector.Z)
            
            if flatVector.Magnitude > 1e-4 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flatVector.Unit)
            end
        end)
    else 
        if self.State.Originals.AutoRotate ~= nil then
            hum.AutoRotate = self.State.Originals.AutoRotate
            self.State.Originals.AutoRotate = nil
        end
    end
end

function Modules.AdvancedShiftLock:_lockMouse(state)
    if self.Services.UserInputService.MouseEnabled then
        self.Services.UserInputService.MouseBehavior = state and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
    end
end

function Modules.AdvancedShiftLock:_setLockState(newState)
    self.State.IsLocked = newState
    
    self:_lockMouse(newState)
    self:_faceCamera(newState)

    local ui = self.State.UI
    if not ui.Button then return end
    
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local targetColor = newState and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 140, 255)
    local targetThickness = newState and 3 or 2
    local targetBg = newState and Color3.fromRGB(38, 48, 60) or Color3.fromRGB(34, 34, 38)
    
    self.Services.TweenService:Create(ui.Stroke, tweenInfo, {Color = targetColor, Thickness = targetThickness}):Play()
    self.Services.TweenService:Create(ui.Button, tweenInfo, {BackgroundColor3 = targetBg}):Play()
    self.Services.TweenService:Create(ui.Icon, tweenInfo, {ImageColor3 = newState and targetColor or Color3.new(1,1,1)}):Play()
    ui.Icon.Image = newState and self.Config.Icons.On or self.Config.Icons.Off
end

function Modules.AdvancedShiftLock:_reapplyState()
    if not self.State.IsEnabled then return end
    task.defer(function()
        self:_setLockState(self.State.IsLocked)
    end)
end

function Modules.AdvancedShiftLock:Disable()
    if not self.State.IsEnabled then return end

    if self.State.IsLocked then self:_setLockState(false) end
    
    if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
    if self.State.Connections.CameraChanged then self.State.Connections.CameraChanged:Disconnect() end
    table.clear(self.State.Connections)

    if self.State.UI.ScreenGui then
        local ui = self.State.UI
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        self.Services.TweenService:Create(ui.Scale, tweenInfo, {Scale = 0}):Play()
        self.Services.TweenService:Create(ui.Button, tweenInfo, {BackgroundTransparency = 1}):Play()
        self.Services.TweenService:Create(ui.Stroke, TweenInfo.new(0.12), {Transparency = 1}):Play()
        task.delay(0.2, function()
            if ui.ScreenGui then ui.ScreenGui:Destroy() end
        end)
    end

    self.State.IsEnabled = false
    self.State.UI = {}
    DoNotif("Advanced Shift Lock disabled.", 2)
end

function Modules.AdvancedShiftLock:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local ui = {}
    self.State.UI = ui
    
    ui.ScreenGui = Instance.new("ScreenGui")
    ui.ScreenGui.Name = "AdvancedShiftLockUI_Module"
    ui.ScreenGui.ResetOnSpawn = false
    ui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.ScreenGui.DisplayOrder = 10000
    
    ui.Button = Instance.new("ImageButton")
    ui.Button.Name = "LockBtn"
    ui.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.Button.Size = UDim2.fromOffset(64, 64)
    ui.Button.Position = UDim2.new(1, -96, 1, -96)
    ui.Button.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
    ui.Button.Parent = ui.ScreenGui
    Instance.new("UICorner", ui.Button).CornerRadius = UDim.new(1, 0)

    ui.Stroke = Instance.new("UIStroke", ui.Button)
    ui.Stroke.Thickness = 2
    ui.Stroke.Color = Color3.fromRGB(0, 140, 255)
    ui.Stroke.Transparency = 0.25

    ui.Icon = Instance.new("ImageLabel", ui.Button)
    ui.Icon.BackgroundTransparency = 1
    ui.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.Icon.Position = UDim2.fromScale(0.5, 0.5)
    ui.Icon.Size = UDim2.fromScale(0.62, 0.62)
    ui.Icon.Image = self.Config.Icons.Off
    
    local closeBtn = Instance.new("TextButton", ui.Button)
    closeBtn.Name = "CloseButton"
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, 6, 0, -6)
    closeBtn.Size = UDim2.fromOffset(22, 22)
    closeBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextScaled = true
    closeBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

    ui.Scale = Instance.new("UIScale", ui.Button)
    ui.Scale.Scale = 0
    self.Services.TweenService:Create(ui.Scale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
    
    self:_makeDraggable(ui.Button, ui.Button)

    ui.Button.Activated:Connect(function() self:_setLockState(not self.State.IsLocked) end)
    closeBtn.Activated:Connect(function() self:Disable() end)
    
    self.State.Connections.CharacterAdded = self.Services.Players.LocalPlayer.CharacterAdded:Connect(function() self:_reapplyState() end)
    self.State.Connections.CameraChanged = self.Services.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() self:_reapplyState() end)

    ui.ScreenGui.Parent = self.Services.CoreGui
    DoNotif("Advanced Shift Lock enabled.", 2)
end

function Modules.AdvancedShiftLock:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end
    
    RegisterCommand({
        Name = "shiftlock",
        Aliases = {"sl", "shiftlockui"},
        Description = "Toggles a custom UI for a client-sided shift lock."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
end

Modules.AntiTrip = {
    State = {
        IsEnabled = false,
        -- Using a weak-keyed table for the cache ensures that if a character/humanoid
        -- is destroyed, its entry in the cache is automatically garbage collected.
        OriginalStateCache = setmetatable({}, {__mode = "k"}),
        -- Tracks all active connections for robust cleanup.
        Connections = {}
    },
    Config = {
        -- The humanoid states that this module will actively block.
        StatesToBlock = {
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.PlatformStanding
        }
    },
    Dependencies = {"Players", "RunService"},
    Services = {}
}

---
-- [Private] Forces a character to recover from a blocked state.
--
function Modules.AntiTrip:_forceRecovery(humanoid)
    if not humanoid then return end
    pcall(function()
        local character = humanoid.Parent
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.zero
        end
        humanoid.PlatformStand = false
        -- GettingUp is often more reliable for breaking out of physics states than Running.
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
end

---
-- [Private] Applies the anti-trip logic to a specific character.
--
function Modules.AntiTrip:_applyToCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    -- Cache the original state of the humanoid properties we are about to change.
    local savedStates = {}
    for _, stateType in ipairs(self.Config.StatesToBlock) do
        local success, isEnabled = pcall(humanoid.GetStateEnabled, humanoid, stateType)
        if success then
            savedStates[stateType] = isEnabled
            pcall(humanoid.SetStateEnabled, humanoid, stateType, false)
        end
    end
    self.State.OriginalStateCache[humanoid] = savedStates

    -- Create a single, efficient loop on Stepped (runs before physics simulation).
    local loopConnection = self.Services.RunService.Stepped:Connect(function()
        local currentState = humanoid:GetState()
        for _, blockedState in ipairs(self.Config.StatesToBlock) do
            if currentState == blockedState then
                self:_forceRecovery(humanoid)
                break -- No need to check other states in this frame
            end
        end
    end)
    
    -- Store the connection for this specific character.
    self.State.Connections[character] = loopConnection
end

---
-- [Private] Reverts all changes made to a specific character.
--
function Modules.AntiTrip:_revertForCharacter(character)
    if not character then return end
    
    -- Disconnect the recovery loop for this character.
    if self.State.Connections[character] then
        self.State.Connections[character]:Disconnect()
        self.State.Connections[character] = nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and self.State.OriginalStateCache[humanoid] then
        -- Restore the original humanoid state settings from our cache.
        for stateType, wasEnabled in pairs(self.State.OriginalStateCache[humanoid]) do
            pcall(humanoid.SetStateEnabled, humanoid, stateType, wasEnabled)
        end
        -- Remove the entry from the cache.
        self.State.OriginalStateCache[humanoid] = nil
    end
end

---
-- Enables the anti-trip module.
--
function Modules.AntiTrip:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local localPlayer = self.Services.Players.LocalPlayer
    
    -- Apply to the current character if it exists.
    if localPlayer.Character then
        self:_applyToCharacter(localPlayer.Character)
    end

    -- Hook into future character spawns and despawns.
    self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char) self:_applyToCharacter(char) end)
    self.State.Connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(char) self:_revertForCharacter(char) end)

    DoNotif("Anti-Trip Enabled", 2)
end

---
-- Disables the anti-trip module and cleans up all resources.
--
function Modules.AntiTrip:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect the main CharacterAdded/Removing hooks.
    if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
    if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
    self.State.Connections.CharacterAdded, self.State.Connections.CharacterRemoving = nil, nil

    -- Revert the effect for the current character.
    if self.Services.Players.LocalPlayer.Character then
        self:_revertForCharacter(self.Services.Players.LocalPlayer.Character)
    end
    
    DoNotif("Anti-Trip Disabled", 2)
end

function Modules.AntiTrip:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

---
-- Initializes the module and registers its commands.
--
function Modules.AntiTrip:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "antitrip",
        Description = "Toggles a system to prevent your character from tripping or ragdolling."
    }, function()
        module:Toggle()
    end)
end

Modules.AdBlock = {
    State = {
        IsEnabled = false,
        -- This connection will listen for new objects being added to the workspace.
        Connection = nil
    },
    Dependencies = {"Workspace"},
    Services = {}
}

---
-- [Private] The core logic to identify and destroy a potential ad object.
-- This function is designed to be called by both the initial scan and the event listener.
--
function Modules.AdBlock:_processObject(obj)
    -- The original script's entry point was checking for PackageLinks, which is a good heuristic.
    if obj:IsA("PackageLink") then
        local parent = obj.Parent
        if not parent then return end

        local success, err = pcall(function()
            if parent:FindFirstChild("ADpart") then
                -- Direct ad structure, destroy the parent model/part.
                parent:Destroy()
            elseif parent:FindFirstChild("AdGuiAdornee") then
                -- Indirect structure, likely where the ad is a child of a child.
                local grandParent = parent.Parent
                if grandParent and grandParent ~= self.Services.Workspace then
                    grandParent:Destroy()
                else
                    parent:Destroy()
                end
            end
        end)

        if not success then
            warn("[AdBlock] Failed to process a potential ad object:", err)
        end
    end
end

---
-- Enables the ad-blocking system.
--
function Modules.AdBlock:Enable()
    if self.State.IsEnabled then 
        DoNotif("AdBlock is already enabled.", 2)
        return 
    end
    self.State.IsEnabled = true
    DoNotif("AdBlock enabled. Performing initial scan...", 2)

    -- 1. Perform a one-time, full scan to clear any existing ads.
    -- This is the only time we run a full GetDescendants() loop.
    task.spawn(function()
        local existingAds = self.Services.Workspace:GetDescendants()
        for i, descendant in ipairs(existingAds) do
            -- Add a small delay every 500 parts to prevent freezing on huge maps.
            if i % 500 == 0 then task.wait() end
            self:_processObject(descendant)
        end
        DoNotif("Initial ad scan complete.", 2)
    end)
    
    -- 2. Connect to the DescendantAdded event. This is the efficient, long-term listener.
    -- From now on, we only check objects as they are added to the game.
    self.State.Connection = self.Services.Workspace.DescendantAdded:Connect(function(descendant)
        self:_processObject(descendant)
    end)
end

---
-- Disables the ad-blocking system and cleans up connections.
--
function Modules.AdBlock:Disable()
    if not self.State.IsEnabled then 
        DoNotif("AdBlock is not active.", 2)
        return 
    end
    self.State.IsEnabled = false

    -- Disconnect the listener to stop processing new objects.
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("AdBlock disabled.", 2)
end

---
-- Toggles the ad-blocking state.
--
function Modules.AdBlock:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

---
-- Initializes the module, loads services, and registers the command.
--
function Modules.AdBlock:Initialize()
    local module = self
    for _, serviceName in ipairs(self.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "adblock",
        Aliases = {"removeads"},
        Description = "Toggles a system to automatically remove billboard advertisements."
    }, function()
        module:Toggle()
    end)
end

Modules.Fakeout = {
    State = {
        IsExecuting = false
    },
    Dependencies = {"Players", "Workspace"},
    Services = {}
}

---
-- Executes the fakeout sequence.
--
function Modules.Fakeout:Execute()
    if self.State.IsExecuting then
        DoNotif("A fakeout is already in progress.", 1.5)
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then
        DoNotif("Fakeout failed: Character root not found.", 2)
        return
    end

    self.State.IsExecuting = true

    -- Safely run the sequence in a new thread to prevent yielding the main script.
    task.spawn(function()
        -- 1. PREPARATION: Save state and temporarily disable conflicting modules.
        local originalCFrame = rootPart.CFrame
        local originalDestroyHeight = self.Services.Workspace.FallenPartsDestroyHeight
        local wasAntiVoidEnabled = false

        -- Decoupled interaction with the AntiVoid module.
        if Modules.AntiVoid and Modules.AntiVoid.State.IsEnabled then
            wasAntiVoidEnabled = true
            Modules.AntiVoid:Disable()
        end

        -- 2. EXECUTION: Perform the fakeout. Use pcall for guaranteed cleanup.
        local success, err = pcall(function()
            -- A large negative number is more explicit than NaN for disabling the void.
            self.Services.Workspace.FallenPartsDestroyHeight = -1e9
            
            -- Teleport just below the original void height.
            rootPart.CFrame = CFrame.new(originalCFrame.Position.X, originalDestroyHeight - 50, originalCFrame.Position.Z)
            
            task.wait(1)
            
            -- If the character still exists, teleport back.
            if rootPart and rootPart.Parent then
                rootPart.CFrame = originalCFrame
            end
        end)

        if not success then
            warn("[Fakeout] Sequence failed:", err)
        end

        -- 3. CLEANUP: Restore all original states. This block runs regardless of success.
        self.Services.Workspace.FallenPartsDestroyHeight = originalDestroyHeight
        
        -- If the AntiVoid module was active before, re-enable it.
        if wasAntiVoidEnabled and Modules.AntiVoid then
            Modules.AntiVoid:Enable()
        end

        self.State.IsExecuting = false
    end)
end

---
-- Initializes the module, loads services, and registers the command.
--
function Modules.Fakeout:Initialize()
    local module = self
    for _, serviceName in ipairs(self.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "fakeout",
        Description = "Teleports you to the void and back"
    }, function()
        module:Execute()
    end)
end

Modules.R6Enforcer = {
    State = {
        IsEnabled = false,
        -- This connection is now the sole component that hooks the respawn process.
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}

--// --- Private Methods ---

---
-- [FIXED] Client-sided function to trigger a respawn by ending the character's life.
--
function Modules.R6Enforcer:_forceRespawn()
    local character = self.Services.Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
    end
end

--// --- Public Methods ---

function Modules.R6Enforcer:Enable()
    if self.State.IsEnabled then return end
    
    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return end

    self.State.IsEnabled = true

    -- Disconnect any previous hook to ensure a clean state.
    if self.State.CharacterAddedConnection then self.State.CharacterAddedConnection:Disconnect() end
    
    -- This is the core of the exploit: when the character respawns,
    -- we intercept it and apply a blank description to force R6.
    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Connect(function(character)
        -- We only apply this logic if the module is still enabled.
        if not self.State.IsEnabled then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- [CRITICAL FIX] Applying a new, empty HumanoidDescription forces
            -- the character to load with the default R6 rig and appearance.
            local r6Description = Instance.new("HumanoidDescription")
            humanoid:ApplyDescription(r6Description)
        end
    end)
    
    DoNotif("R6 Enforcer: ENABLED. Respawning to apply...", 3)
    
    -- Trigger the respawn, which our CharacterAdded connection will catch.
    self:_forceRespawn()
end

function Modules.R6Enforcer:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- [CRITICAL FIX] Disconnect the hook. Now, when the player respawns,
    -- nothing will intercept the process, and their normal avatar will load.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end

    DoNotif("R6 Enforcer: DISABLED. Respawning to revert...", 3)

    -- Trigger a respawn to revert to the default character.
    self:_forceRespawn()
end

function Modules.R6Enforcer:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Modules.R6Enforcer:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "forcer6",
        Aliases = {"r6", "classicavatar"},
        Description = "Forces your character to load as R6 via respawn."
    }, function()
        module:Toggle()
    end)
end

Modules.AntiKick = {
    State = {
        IsEnabled = false,
        OriginalKick = nil,
        OriginalTeleport = nil,
        RenderSteppedConnection = nil
    },
    Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        CoreGui = game:GetService("CoreGui"),
        Players = game:GetService("Players"),
        TeleportService = game:GetService("TeleportService")
    }
}

--// --- Private Methods ---

-- Encapsulates the hooking logic for cleanliness.
function Modules.AntiKick:_createHooks()
    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return false, "LocalPlayer not available." end

    local success, err = pcall(function()
        -- 1. Hook Player:Kick()
        local playerMetatable = getrawmetatable(localPlayer)
        assert(playerMetatable, "Could not get Player metatable.")
        
        self.State.OriginalKick = playerMetatable.__index.Kick
        assert(self.State.OriginalKick, "Could not find original Player:Kick function.")

        -- Create the hook. Using newcclosure is best practice for stealth.
        local kickHook = newcclosure(function(self, ...)
            -- The first argument to a method is always the object itself.
            -- We only block the kick if it's targeting our local player.
            if self == localPlayer then
                warn("--> [AntiKick] Blocked a client-side Player:Kick() request.")
                return -- Discard the call by returning nothing.
            end
            -- For any other player, call the original function to preserve game logic.
            return self.State.OriginalKick(self, ...)
        end)
        
        rawset(playerMetatable.__index, "Kick", kickHook)

        -- 2. Hook TeleportService:Teleport()
        local tsMetatable = getrawmetatable(self.Services.TeleportService)
        assert(tsMetatable, "Could not get TeleportService metatable.")

        self.State.OriginalTeleport = tsMetatable.__index.Teleport
        assert(self.State.OriginalTeleport, "Could not find original TeleportService:Teleport function.")
        
        local teleportHook = newcclosure(function(...)
            warn("--> [AntiKick] Blocked a client-side Teleport request.")
            return -- Always block client-side teleports initiated this way.
        end)

        rawset(tsMetatable.__index, "Teleport", teleportHook)
    end)

    if not success then
        return false, tostring(err)
    end

    return true
end

-- Encapsulates the restoration logic.
function Modules.AntiKick:_removeHooks()
    -- Restore Player:Kick()
    pcall(function()
        local localPlayer = self.Services.Players.LocalPlayer
        if not localPlayer or not self.State.OriginalKick then return end
        local playerMetatable = getrawmetatable(localPlayer)
        rawset(playerMetatable.__index, "Kick", self.State.OriginalKick)
        self.State.OriginalKick = nil
    end)
    
    -- Restore TeleportService:Teleport()
    pcall(function()
        if not self.State.OriginalTeleport then return end
        local tsMetatable = getrawmetatable(self.Services.TeleportService)
        rawset(tsMetatable.__index, "Teleport", self.State.OriginalTeleport)
        self.State.OriginalTeleport = nil
    end)
end

--// --- Public Methods ---

function Modules.AntiKick:Enable()
    if self.State.IsEnabled then return end

    -- Verify the executor supports the required hooking method.
    if not getrawmetatable then
        DoNotif("AntiKick Error: Your executor does not support getrawmetatable.", 5)
        return
    end

    -- Attempt to create the hooks.
    local success, err = self:_createHooks()
    if not success then
        DoNotif("AntiKick hook failed: " .. err, 5)
        self:_removeHooks() -- Clean up any partial hooks
        return
    end

    --// --- Setup RenderStepped Loop for GUI/Modal Lock (This logic was already excellent) ---
    local KICK_GUI_KEYWORDS = {"kick", "ban", "warn", "exploit"}
    self.State.RenderSteppedConnection = self.Services.RunService.RenderStepped:Connect(function()
        -- Persistently fight against input being disabled.
        if self.Services.UserInputService.ModalEnabled then
            self.Services.UserInputService.ModalEnabled = false
        end

        -- Scan and destroy any UI that looks like a kick screen.
        for _, gui in ipairs(self.Services.CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local guiNameLower = gui.Name:lower()
                for _, keyword in ipairs(KICK_GUI_KEYWORDS) do
                    if guiNameLower:find(keyword, 1, true) then
                        warn("--> [AntiKick] Detected and destroyed a potential kick GUI: " .. gui.Name)
                        gui:Destroy()
                        break -- Move to the next GUI
                    end
                end
            end
        end
    end)

    self.State.IsEnabled = true
    DoNotif("Anti-Kick: ENABLED. Client-side kicks will be blocked.", 3)
end

function Modules.AntiKick:Disable()
    if not self.State.IsEnabled then return end

    -- Restore the original functions.
    self:_removeHooks()
    
    -- Disconnect the RenderStepped loop.
    if self.State.RenderSteppedConnection then
        self.State.RenderSteppedConnection:Disconnect()
        self.State.RenderSteppedConnection = nil
    end

    self.State.IsEnabled = false
    DoNotif("Anti-Kick: DISABLED.", 2)
end

function Modules.AntiKick:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--// --- Command Registration (Assuming this function exists elsewhere) ---
RegisterCommand({
    Name = "antikick",
    Aliases = {"nokick"},
    Description = "Toggles a system to block most client-sided kick attempts."
}, function()
    Modules.AntiKick:Toggle()
end)

Modules.AntiPlayerPhysics = {
    State = {
        IsEnabled = false,
        SteppedConnection = nil,
        OriginalProperties = setmetatable({}, {__mode = "k"}) -- Automatically cleans up when a part is destroyed
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

--- [Private] Reverts physics properties for a character to their original state.
function Modules.AntiPlayerPhysics:_revertCharacter(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and self.State.OriginalProperties[part] then
            -- Restore from our cache
            part.CanCollide = self.State.OriginalProperties[part].CanCollide
            part.Massless = self.State.OriginalProperties[part].Massless
            -- Clear the cache entry for this part
            self.State.OriginalProperties[part] = nil
        end
    end
end

--- Enables the anti-physics protection loop.
function Modules.AntiPlayerPhysics:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    self.State.SteppedConnection = self.Services.RunService.Stepped:Connect(function()
        -- This loop must run continuously to fight against the server replicating the original properties back.
        for _, player in ipairs(self.Services.Players:GetPlayers()) do
            if player ~= self.Services.Players.LocalPlayer and player.Character then
                -- pcall to prevent errors if a character part is removed during the loop
                pcall(function()
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            -- Cache the original properties ONCE.
                            if not self.State.OriginalProperties[part] then
                                self.State.OriginalProperties[part] = {
                                    CanCollide = part.CanCollide,
                                    Massless = part.Massless
                                }
                            end

                            -- Apply anti-physics properties
                            part.CanCollide = false
                            if part.Name == "Torso" then -- Still effective on R6
                                part.Massless = true
                            end
                            part.Velocity = Vector3.new()
                            part.RotVelocity = Vector3.new()
                        end
                    end
                end)
            end
        end
    end)
    DoNotif("Anti-Player Physics: ENABLED.", 2)
end

--- Disables the anti-physics protection and cleans up all changes.
function Modules.AntiPlayerPhysics:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if self.State.SteppedConnection then
        self.State.SteppedConnection:Disconnect()
        self.State.SteppedConnection = nil
    end

    -- Restore all modified characters to their original state
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        if player.Character then
            self:_revertCharacter(player.Character)
        end
    end
    table.clear(self.State.OriginalProperties) -- Clear the cache

    DoNotif("Anti-Player Physics: DISABLED.", 2)
end

--- Toggles the state of the system.
function Modules.AntiPlayerPhysics:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module and registers its command.
function Modules.AntiPlayerPhysics:Initialize()
    local module = self
    RegisterCommand({
        Name = "antiphysics",
        Aliases = {"nocol"},
        Description = "Toggles a powerful anti-fling that makes other players non-collidable."
    }, function()
        module:Toggle()
    end)
end

Modules.AntiKill = {
    State = {
        IsEnabled = false,
        RenderConnection = nil,
        CameraConnection = nil
    },
    Services = { -- Pre-loading services is a good pattern.
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Workspace = game:GetService("Workspace")
    }
}

--- Enables the Anti-Kill protection loop.
function Modules.AntiKill:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local Player = self.Services.Players.LocalPlayer
    local Camera = self.Services.Workspace.CurrentCamera

    -- A handler to ensure the Camera variable is always current.
    local function onCameraChanged()
       Camera = self.Services.Workspace.CurrentCamera
    end
    self.State.CameraConnection = self.Services.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCameraChanged)

    -- The core protection logic, connected to RenderStepped for high-frequency execution.
    local function protectionLoop()
        local Character = Player.Character
        if not Character then return end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")

        if not (Humanoid and RootPart) then return end

        -- [DEFENSE 1] If in shift-lock, lock character rotation to camera to prevent forced turning.
        if self.Services.UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            local _, cameraY, _ = Camera.CFrame:ToEulerAnglesYXZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, cameraY, 0)
        end
        
        -- [DEFENSE 2] Forcing the Sit state gives character physics higher network priority,
        -- making it highly resistant to external forces. We then disable the 'Seated'
        -- state so the character doesn't actually perform the sit animation.
        Humanoid.Sit = true
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    end

    self.State.RenderConnection = self.Services.RunService.RenderStepped:Connect(protectionLoop)
    DoNotif("Anti-Kill System: ENABLED.", 2)
end

--- Disables the Anti-Kill protection and cleans up resources.
function Modules.AntiKill:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect connections to prevent memory leaks.
    if self.State.RenderConnection then
        self.State.RenderConnection:Disconnect()
        self.State.RenderConnection = nil
    end
    if self.State.CameraConnection then
        self.State.CameraConnection:Disconnect()
        self.State.CameraConnection = nil
    end

    -- Restore the character to a normal state.
    pcall(function()
        local Humanoid = self.Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Sit = false
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end
    end)

    DoNotif("Anti-Kill System: DISABLED.", 2)
end

--- Toggles the state of the Anti-Kill system.
function Modules.AntiKill:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module and registers its command.
function Modules.AntiKill:Initialize()
    local module = self -- Capture self for the command function.
    RegisterCommand({
        Name = "antikill",
        Aliases = {"ak", "nofling"},
        Description = "Toggles a client-sided system to resist flings and character manipulation."
    }, function()
        module:Toggle()
    end)
end

Modules.AstralHead = {
State = {
IsEnabled = false,
OriginalProperties = {},
Connections = {}
}
}
function Modules.AstralHead:_getCharacterHeadParts(character)
    local parts = {}
    if not character then return parts end
        local head = character:FindFirstChild("Head")
        if head then table.insert(parts, head) end
            for _, accessory in ipairs(character:GetChildren()) do
                if accessory:IsA("Accessory") then
                    local handle = accessory:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        table.insert(parts, handle)
                    end
                end
            end
            return parts
        end
        function Modules.AstralHead:_enableForCharacter(character)
            local self = Modules.AstralHead
            if not character then return end
                local partsToModify = self:_getCharacterHeadParts(character)
                for _, part in ipairs(partsToModify) do
                    if not self.State.OriginalProperties[part] then
                        self.State.OriginalProperties[part] = {
                        Transparency = part.Transparency,
                        CanQuery = part.CanQuery,
                        CanTouch = part.CanTouch
                        }
                    end
                    part.Transparency = 1
                    part.CanQuery = false
                    part.CanTouch = false
                end
            end
            function Modules.AstralHead:_disableForCharacter(character)
                local self = Modules.AstralHead
                for part, properties in pairs(self.State.OriginalProperties) do
                    pcall(function()
                    if part and part.Parent then
                        part.Transparency = properties.Transparency
                        part.CanQuery = properties.CanQuery
                        part.CanTouch = properties.CanTouch
                    end
                end)
            end
            table.clear(self.State.OriginalProperties)
        end
        function Modules.AstralHead:Toggle()
            local self = Modules.AstralHead
            self.State.IsEnabled = not self.State.IsEnabled
            if self.State.IsEnabled then
                DoNotif("Astral Head Enabled. Head is now untargetable.", 2)
                if LocalPlayer.Character then
                    self:_enableForCharacter(LocalPlayer.Character)
                end
            else
            DoNotif("Astral Head Disabled. Head restored.", 2)
            if LocalPlayer.Character then
                self:_disableForCharacter(LocalPlayer.Character)
            else
            table.clear(self.State.OriginalProperties)
        end
    end
end
function Modules.AstralHead:Initialize()
    local module = self
    module.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if module.State.IsEnabled then
        module:_enableForCharacter(character)
    end
end)
module.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
if module.State.IsEnabled then
    module:_disableForCharacter(character)
end
end)
RegisterCommand({
Name = "astralhead",
Aliases = {"hidehead", "nohead"},
Description = "Toggles head invisibility to counter aimbots."
}, function()
module:Toggle()
end)
end
Modules.LocalAntiTeamChange = {
State = {
IsEnabled = false,
OriginalTeam = nil,
PropertyConnection = nil
},
Dependencies = {"Players"}
}
function Modules.LocalAntiTeamChange:Enable()
    if self.State.IsEnabled then return end
        local localPlayer = self.Services.Players.LocalPlayer
        if not localPlayer then
            warn("[LocalAntiTeamChange] Could not find LocalPlayer to monitor.")
            return
        end
        self.State.IsEnabled = true
        self.State.OriginalTeam = localPlayer.Team
        if self.State.PropertyConnection then self.State.PropertyConnection:Disconnect() end
            self.State.PropertyConnection = localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
            if self.State.IsEnabled and localPlayer.Team ~= self.State.OriginalTeam then
                pcall(function()
                localPlayer.Team = self.State.OriginalTeam
                DoNotif("Reverted personal team change.", 2)
            end)
        end
    end)
    DoNotif("Personal Team Lock: [Enabled]", 3)
end
function Modules.LocalAntiTeamChange:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        if self.State.PropertyConnection then
            self.State.PropertyConnection:Disconnect()
            self.State.PropertyConnection = nil
        end
        self.State.OriginalTeam = nil
        DoNotif("Personal Team Lock: [Disabled]", 3)
    end
    function Modules.LocalAntiTeamChange:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.LocalAntiTeamChange:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "lockteam",
    Aliases = {"localantiteamchange", "latc"},
    Description = "Toggles a lock that prevents YOUR team from being changed."
    }, function(args)
    module:Toggle()
end)
end
Modules.HumanoidIntegrity = {
State = {
IsEnabled = false,
Connections = {}
},
Dependencies = {"Players"}
}
function Modules.HumanoidIntegrity:_protectCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
        self:_cleanupCharacter(character)
        local charConnections = { Character = character }
        charConnections.StateChanged = humanoid.StateChanged:Connect(function(old, new)
        if not self.State.IsEnabled then return end
            if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.FallingDown then
                pcall(humanoid.ChangeState, humanoid, Enum.HumanoidStateType.GettingUp)
            end
        end)
        charConnections.JointRemoved = character.DescendantRemoving:Connect(function(descendant)
        if not self.State.IsEnabled then return end
            if descendant:IsA("Motor6D") then
                task.defer(humanoid.BuildRigFromAttachments, humanoid)
            end
        end)
        charConnections.PlatformStand = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not self.State.IsEnabled then return end
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end)
        self.State.Connections[character] = charConnections
    end
    function Modules.HumanoidIntegrity:_cleanupCharacter(character)
        if self.State.Connections[character] then
            for _, conn in pairs(self.State.Connections[character]) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
            self.State.Connections[character] = nil
        end
    end
    function Modules.HumanoidIntegrity:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            if localPlayer.Character then
                self:_protectCharacter(localPlayer.Character)
            end
            self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char)
            self:_protectCharacter(char)
        end)
        self.State.Connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(char)
        self:_cleanupCharacter(char)
    end)
    DoNotif("Humanoid Integrity System: [Enabled]", 3)
end
function Modules.HumanoidIntegrity:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for key, conn in pairs(self.State.Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif type(conn) == "table" then
                self:_cleanupCharacter(key)
            end
        end
        table.clear(self.State.Connections)
        DoNotif("Humanoid Integrity System: [Disabled]", 3)
    end
    function Modules.HumanoidIntegrity:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.HumanoidIntegrity:Initialize()
    local module = self
    module.Services = { Players = game:GetService("Players") }
    RegisterCommand({
    Name = "antiragdoll",
    Aliases = {"noragdoll", "integrity"},
    Description = "Toggles a system to aggressively counter character ragdolling and joint breaking."
    }, function()
    module:Toggle()
end)
end


Modules.GamepassSpoofer = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil
    }
}

--// --- Public Methods ---

function Modules.GamepassSpoofer:Enable()
    if self.State.IsEnabled then return end

    -- This is an advanced technique; verify that the executor supports it.
    if not (getrawmetatable and getnamecallmethod) then
        DoNotif("Error: Your executor does not support __namecall hooking.", 5)
        return
    end

    local gameMetatable = getrawmetatable(game)
    self.State.OriginalNamecall = gameMetatable.__namecall

    setreadonly(gameMetatable, false)
    
    gameMetatable.__namecall = function(...)
        local selfArg = ...
        local method = getnamecallmethod()

        -- Intercept the specific call we want to spoof.
        if method == "UserOwnsGamePassAsync" and typeof(selfArg) == "Instance" and selfArg:IsA("MarketplaceService") then
            -- Lie to the calling script and tell it the user owns the gamepass.
            -- The arguments (player, gamepassId) are ignored; we just return true.
            print("--> [GamepassSpoofer] Intercepted and spoofed UserOwnsGamePassAsync call.")
            return true
        end

        -- If it's not our target, pass the call to the original handler to avoid breaking the game.
        return self.State.OriginalNamecall(...)
    end
    
    setreadonly(gameMetatable, true)

    self.State.IsEnabled = true
    DoNotif("Gamepass Spoofer: ENABLED. Client-side checks will be bypassed.", 3)
end

function Modules.GamepassSpoofer:Disable()
    if not self.State.IsEnabled then return end

    -- Safely attempt to restore the original metatable method.
    pcall(function()
        local gameMetatable = getrawmetatable(game)
        setreadonly(gameMetatable, false)
        gameMetatable.__namecall = self.State.OriginalNamecall
        setreadonly(gameMetatable, true)
    end)
    
    self.State.OriginalNamecall = nil
    self.State.IsEnabled = false
    DoNotif("Gamepass Spoofer: DISABLED. Engine restored.", 2)
end

function Modules.GamepassSpoofer:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--// --- Command Registration ---
RegisterCommand({
    Name = "spoofgamepass",
    Aliases = {"fakepass", "gp"},
    Description = "Toggles a client-side gamepass spoofer to bypass local checks."
}, function()
    Modules.GamepassSpoofer:Toggle()
end)

Modules.TeleporterScanner = {
	State = {
		UI = nil, -- Will hold the ScreenGui instance
		IsScanning = false,
		Highlights = {} -- Module-specific highlight table
	}
}

function Modules.TeleporterScanner:ToggleGUI()
	local self = Modules.TeleporterScanner

	if self.State.UI and self.State.UI.Parent then
		for _, highlight in pairs(self.State.Highlights) do
			if highlight and highlight.Parent then highlight:Destroy() end
		end
		table.clear(self.State.Highlights)
		
		self.State.UI:Destroy()
		self.State.UI = nil
		DoNotif("Teleporter Scanner closed.", 2)
		return
	end

	DoNotif("Forensic Teleporter Scanner opened.", 2)
	
	local Workspace = game:GetService("Workspace")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")

	-- FIXED: Refined keywords for much higher accuracy
	local SCRIPT_KEYWORDS = { "TeleportService", ":Teleport(", ":TeleportToPlaceInstance(", "fireproximityprompt" }
	local NAME_KEYWORDS = { "teleport", "portal", "warp" }
	local DATA_PAYLOAD_NAMES = { "placeid", "gameid", "targetplace" }

	local CONFIDENCE_THRESHOLDS = { SCRIPT = 1.0, DATA_PAYLOAD = 0.8, NAME = 0.5 }

	local screenGui = Instance.new("ScreenGui")
	self.State.UI = screenGui
	screenGui.Name = "TeleporterScannerGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local mainFrame = Instance.new("Frame"); mainFrame.Name = "MainFrame"; mainFrame.Size = UDim2.new(0, 350, 0, 450); mainFrame.Position = UDim2.new(0, 10, 0.5, -225); mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 125); mainFrame.ClipsDescendants = true; mainFrame.Parent = screenGui
	local titleLabel = Instance.new("TextLabel"); titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 0, 30); titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55); titleLabel.Text = "Forensic Teleporter Scanner"; titleLabel.Font = Enum.Font.SourceSansBold; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.Parent = mainFrame
	local scanButton = Instance.new("TextButton"); scanButton.Name = "ScanButton"; scanButton.Size = UDim2.new(1, -10, 0, 30); scanButton.Position = UDim2.new(0.5, 0, 0, 35); scanButton.AnchorPoint = Vector2.new(0.5, 0); scanButton.BackgroundColor3 = Color3.fromRGB(80, 60, 200); scanButton.Font = Enum.Font.SourceSansBold; scanButton.TextColor3 = Color3.fromRGB(255, 255, 255); scanButton.Text = "Begin Workspace Scan"; scanButton.Parent = mainFrame
	local clearButton = Instance.new("TextButton"); clearButton.Name = "ClearButton"; clearButton.Size = UDim2.new(1, -10, 0, 20); clearButton.Position = UDim2.new(0.5, 0, 0, 70); clearButton.AnchorPoint = Vector2.new(0.5, 0); clearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60); clearButton.Font = Enum.Font.SourceSans; clearButton.TextColor3 = Color3.fromRGB(255, 255, 255); clearButton.Text = "Clear Highlights & Results"; clearButton.Parent = mainFrame
	local resultsFrame = Instance.new("ScrollingFrame"); resultsFrame.Name = "ResultsFrame"; resultsFrame.Size = UDim2.new(1, -10, 1, -95); resultsFrame.Position = UDim2.new(0, 5, 0, 90); resultsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); resultsFrame.Parent = mainFrame
	local listLayout = Instance.new("UIListLayout"); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 3); listLayout.Parent = resultsFrame

	local function highlightPart(part, confidence)
		if self.State.Highlights[part] then return end
		local highlight = Instance.new("Highlight")
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; highlight.FillColor = Color3.fromHSV(0.0, 0.8, 1); highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.FillTransparency = 0.5; highlight.Parent = part
		self.State.Highlights[part] = highlight
	end

	local function addResultToList(part, confidence, reason)
		local resultButton = Instance.new("TextButton")
		resultButton.Name = part.Name; resultButton.Text = `[{string.format("%.0f", confidence * 100)}%] {part:GetFullName()} ({reason})`; resultButton.Size = UDim2.new(1, 0, 0, 25); resultButton.BackgroundColor3 = Color3.fromHSV(0, 0.5, 0.5 + (confidence * 0.2)); resultButton.Font = Enum.Font.SourceSans; resultButton.TextXAlignment = Enum.TextXAlignment.Left; resultButton.TextColor3 = Color3.fromRGB(225, 225, 225); resultButton.LayoutOrder = -confidence; resultButton.Parent = resultsFrame
		resultButton.MouseButton1Click:Connect(function()
			local camera = Workspace.CurrentCamera; camera.CameraType = Enum.CameraType.Scriptable
			local targetCFrame = CFrame.new(part.Position + part.CFrame.LookVector * 10, part.Position)
			local tween = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = targetCFrame})
			tween:Play(); tween.Completed:Wait(); camera.CameraType = Enum.CameraType.Custom
		end)
	end

	local function clearResults()
		for _, highlight in pairs(self.State.Highlights) do
			if highlight and highlight.Parent then highlight:Destroy() end
		end
		table.clear(self.State.Highlights)
		for _, child in ipairs(resultsFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		scanButton.Text = "Begin Workspace Scan"; scanButton.Active = true
	end

	-- FIXED: Entirely new scanning logic for precision.
	local function scanWorkspace()
		self.State.IsScanning = true
		scanButton.Text = "Scanning... (This may take a moment)"; scanButton.Active = false
		local findings = {}

		task.spawn(function()
			for i, descendant in ipairs(Workspace:GetDescendants()) do
				if i % 500 == 0 then task.wait() end
				
				local part, confidence, reason = nil, 0, ""

				-- High-confidence check: Script source analysis
				if descendant:IsA("LuaSourceContainer") then
					local success, source = pcall(function() return descendant.Source end)
					if success and source then
						local lowerSource = source:lower()
						for _, keyword in ipairs(SCRIPT_KEYWORDS) do
							if lowerSource:find(keyword:lower(), 1, true) then
								part = descendant:FindFirstAncestorOfClass("Model") or descendant.Parent
								if part and part:IsA("BasePart") or part:IsA("Model") then
									confidence = CONFIDENCE_THRESHOLDS.SCRIPT
									reason = "Script Analysis"
									break
								end
							end
						end
					end
				end

				-- Medium/Low-confidence checks on BaseParts
				if descendant:IsA("BasePart") and not part then
					local currentConfidence, currentReason = 0, ""
					-- Check for data payloads
					for _, child in ipairs(descendant:GetChildren()) do
						if child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue") then
							for _, name in ipairs(DATA_PAYLOAD_NAMES) do
								if child.Name:lower() == name then
									currentConfidence = math.max(currentConfidence, CONFIDENCE_THRESHOLDS.DATA_PAYLOAD)
									currentReason = "Data Payload"
									break
								end
							end
						end
					end
					-- Check part name
					for _, keyword in ipairs(NAME_KEYWORDS) do
						if descendant.Name:lower():find(keyword, 1, true) then
							currentConfidence = math.max(currentConfidence, CONFIDENCE_THRESHOLDS.NAME)
							if currentReason == "" then currentReason = "Suspicious Name" end
							break
						end
					end
					if currentConfidence > 0 then
						part, confidence, reason = descendant, currentConfidence, currentReason
					end
				end

				if part and (not findings[part] or confidence > findings[part].confidence) then
					findings[part] = { confidence = confidence, reason = reason }
				end
			end
			
			-- Process all findings after the scan is complete
			local partsFound = 0
			for part, data in pairs(findings) do
				partsFound += 1
				highlightPart(part, data.confidence)
				addResultToList(part, data.confidence, data.reason)
			end

			scanButton.Text = `Scan Complete! Found {partsFound} potentials.`
			DoNotif(`Scan finished. Found {partsFound} points of interest.`, 3)
			self.State.IsScanning = false
		end)
	end

	scanButton.MouseButton1Click:Connect(function()
		if self.State.IsScanning then return end
		clearResults()
		scanWorkspace() -- No longer needs to be spawned in a new thread here
	end)
	clearButton.MouseButton1Click:Connect(clearResults)

	local isDragging, dragStart, startPosition = false, nil, nil
	titleLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true; dragStart = input.Position; startPosition = mainFrame.Position; end end)
	titleLabel.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end)

	screenGui.Parent = CoreGui
end

RegisterCommand({
	Name = "tpscan",
	Aliases = {"teleporterscan", "findtp"},
	Description = "Toggles a GUI that scans the workspace for potential teleporters."
}, function(args)
	Modules.TeleporterScanner:ToggleGUI()
end)

Modules.ToolPersistence = {
State = {
IsEnabled = false,
ToolCache = nil,
Connections = {}
},
Dependencies = {"Players", "CoreGui"}
}
function Modules.ToolPersistence:_initializeCache()
    if self.State.ToolCache and self.State.ToolCache.Parent then
        self.State.ToolCache:Destroy()
    end
    self.State.ToolCache = Instance.new("Folder")
    self.State.ToolCache.Name = "ToolCache_" .. math.random(1000, 9999)
    self.State.ToolCache.Parent = self.Services.CoreGui
end
function Modules.ToolPersistence:_cacheTool(tool)
    if not tool:IsA("Tool") then return end
        if self.State.ToolCache:FindFirstChild(tool.Name) then return end
            local success, result = pcall(function()
            local toolClone = tool:Clone()
            toolClone.Parent = self.State.ToolCache
        end)
        if not success then
            warn("[ToolPersistence] Failed to cache tool '" .. tool.Name .. "': " .. tostring(result))
        end
    end
    function Modules.ToolPersistence:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
            if not backpack then
                self.State.IsEnabled = false
                return warn("[ToolPersistence] Cannot enable: Backpack not found.")
            end
            self:_initializeCache()
            for _, tool in ipairs(backpack:GetChildren()) do
                self:_cacheTool(tool)
            end
            self.State.Connections.ChildAdded = backpack.ChildAdded:Connect(function(child)
            self:_cacheTool(child)
        end)
        self.State.Connections.ChildRemoved = backpack.ChildRemoved:Connect(function(child)
        if self.State.IsEnabled and child:IsA("Tool") then
            local cachedTool = self.State.ToolCache:FindFirstChild(child.Name)
            if cachedTool then
                task.defer(function()
                if backpack and backpack.Parent then
                    cachedTool:Clone().Parent = backpack
                end
            end)
        end
    end
end)
DoNotif("Tool Persistence: [Enabled]", 3)
end
function Modules.ToolPersistence:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for _, conn in pairs(self.State.Connections) do
            conn:Disconnect()
        end
        table.clear(self.State.Connections)
        if self.State.ToolCache then
            self.State.ToolCache:Destroy()
            self.State.ToolCache = nil
        end
        DoNotif("Tool Persistence: [Disabled]", 3)
    end
    function Modules.ToolPersistence:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.ToolPersistence:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "antitoolremove",
    Aliases = {"locktools", "atr"},
    Description = "Toggles a system that prevents your tools from being removed from your backpack."
    }, function(args)
    module:Toggle()
end)
end
Modules.GrabTools = {
State = {
IsEnabled = false,
Connection = nil
}
}
function Modules.GrabTools:_onHeartbeat()
    local localPlayerBackpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
    if not localPlayerBackpack then return end
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:IsA("Tool") and child:FindFirstChild("Handle") and not child.Handle.Anchored then
                child.Parent = localPlayerBackpack
                DoNotif("Grabbed Tool: " .. child.Name, 1.5)
            end
        end
    end
    function Modules.GrabTools:Toggle()
        local self = Modules.GrabTools
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            if self.State.Connection then self.State.Connection:Disconnect() end
                self.State.Connection = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
                DoNotif("Tool Grabber Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Tool Grabber Disabled", 2)
        end
    end
    function Modules.GrabTools:Initialize()
        local module = self
        RegisterCommand({
        Name = "grabtools",
        Aliases = {"gt", "toolgrab"},
        Description = "Toggles an auto-grabber for all dropped tools in the workspace."
        }, function(args)
        module:Toggle()
    end)
end
Modules.AdminSpoofDemonstration = {
    State = {
        IsSpoofing = false,
        SpoofedId = -1,
        OriginalIndex = nil,
        PlayerMetatable = nil
    },
    Dependencies = {"Players"} -- Declares required services for the Initialize function.
}

--- Enables the UserId spoof with the provided target ID.
-- @param targetId <number> The UserId to spoof.
function Modules.AdminSpoofDemonstration:Enable(targetId)
    if self.State.IsSpoofing then
        DoNotif("Already spoofing UserId. Reset first.", 3)
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return end

    -- Using pcall for robustness as getrawmetatable is a debug function and can fail.
    local success, playerMetatable = pcall(getrawmetatable, localPlayer)
    if not success or typeof(playerMetatable) ~= "table" then
        DoNotif("Error: Could not get the player's metatable. Environment may not support this.", 4)
        return
    end

    -- Store the original metatable and __index for restoration upon disabling.
    self.State.PlayerMetatable = playerMetatable
    self.State.OriginalIndex = playerMetatable.__index
    local originalIndexCache = self.State.OriginalIndex -- Cache as an upvalue for the hook's closure.

    self.State.SpoofedId = tonumber(targetId) or -1
    self.State.IsSpoofing = true

    -- Hook the __index metamethod. This is the core of the exploit.
    playerMetatable.__index = function(self, key)
        -- If a script tries to get the "UserId" property, we intercept and return our fake ID.
        if key == "UserId" then
            return Modules.AdminSpoofDemonstration.State.SpoofedId
        end

        -- CRITICAL FIX: The original __index is a table. We must index it to get the real property.
        -- The previous code's attempt to call it (`OriginalIndex(self, key)`) caused the error.
        -- This correctly forwards the property lookup to the original table.
        if typeof(originalIndexCache) == "table" then
            return originalIndexCache[key]
        elseif typeof(originalIndexCache) == "function" then
            -- A defensive fallback in case __index is ever a function.
            return originalIndexCache(self, key)
        end
    end

    DoNotif("Local UserId spoof enabled. Now appearing as: " .. self.State.SpoofedId, 3)
end

--- Disables the UserId spoof and restores the original engine behavior.
function Modules.AdminSpoofDemonstration:Disable()
    if not self.State.IsSpoofing then return end

    -- Restore the original __index from our backup. This is crucial for cleanup.
    if self.State.PlayerMetatable and self.State.OriginalIndex then
        self.State.PlayerMetatable.__index = self.State.OriginalIndex
    end

    -- Reset all state variables to default values to prevent memory leaks and ensure a clean state.
    self.State.IsSpoofing = false
    self.State.SpoofedId = -1
    self.State.OriginalIndex = nil
    self.State.PlayerMetatable = nil
    DoNotif("Local UserId spoof disabled. Identity restored.", 3)
end

--- Initializes the module, loads services, and registers its command.
function Modules.AdminSpoofDemonstration:Initialize()
    local module = self

    -- Adhering to the framework's pattern of loading dependencies into a local Services table.
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "spoofid",
        Aliases = {"setid", "fakeid"},
        Description = "Locally spoofs your UserId for vulnerable scripts."
    }, function(args)
        local argument = args[1]
        if not argument then
            return DoNotif("Usage: ;spoofid username", 4)
        end

        if argument:lower() == "reset" or argument:lower() == "clear" then
            module:Disable()
        else
            local targetId = tonumber(argument)
            if targetId and targetId > 0 then
                module:Enable(targetId)
            else
                DoNotif("Invalid UserId. It must be a positive number.", 3)
            end
        end
    end)
end

Modules.MADGuardian = {
    State = {
        IsEnabled = false,
        HeartbeatConnection = nil,
        LastRetaliation = 0
    },
    Config = {
        -- The upward force of our retaliatory fling. Higher is more aggressive.
        COUNTER_FLING_FORCE = 300,
        -- How long the counter-fling effect lasts on the attacker, in seconds.
        COUNTER_FLING_DURATION = 2.5,
        -- How often to scan for hostile physics objects, in seconds.
        SCAN_INTERVAL_SECONDS = 0.1,
        -- A cooldown period after retaliating to prevent spamming the counter-attack.
        RETALIATION_COOLDOWN_SECONDS = 3,
        -- An attribute to mark our own physics objects so the script doesn't destroy them.
        COUNTER_ATTACK_TAG = "MAD_Counter"
    }
}

--- [Internal] Finds the player character closest to the local player.
-- @returns Player? The closest player object, or nil if none are found.
function Modules.MADGuardian:_findClosestPlayer()
    local closestPlayer, minDistance = nil, math.huge
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                if distance < minDistance then
                    minDistance, closestPlayer = distance, player
                end
            end
        end
    end
    return closestPlayer
end

--- [Internal] Initiates a retaliatory fling against a specified target.
-- @param targetCharacter Model The character model of the player to be flung.
function Modules.MADGuardian:_initiateCounterFling(targetCharacter)
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    DoNotif("MAD Guardian: Retaliating against '"..targetCharacter.Name.."'", 1.5)

    local counterVelocity = Instance.new("BodyVelocity")
    counterVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    counterVelocity.Velocity = Vector3.new(0, self.Config.COUNTER_FLING_FORCE, 0)
    counterVelocity.Parent = targetRoot
    counterVelocity:SetAttribute(self.Config.COUNTER_ATTACK_TAG, true)

    -- Schedule the self-destruction of our counter-attack object.
    task.delay(self.Config.COUNTER_FLING_DURATION, function()
        if counterVelocity and counterVelocity.Parent then
            counterVelocity:Destroy()
        end
    end)
end

--- [Internal] The main detection loop connected to RunService.Heartbeat.
function Modules.MADGuardian:_onHeartbeat()
    local character = LocalPlayer.Character
    if not character then return end

    -- Scan for hostile physics movers descendant to the character.
    for _, descendant in ipairs(character:GetDescendants()) do
        -- BodyMover is the base class for BodyVelocity, BodyPosition, etc.
        -- We ignore any movers that have our specific tag.
        if descendant:IsA("BodyMover") and not descendant:GetAttribute(self.Config.COUNTER_ATTACK_TAG) then
            DoNotif("MAD Guardian: Hostile BodyMover '"..descendant.ClassName.."' detected. Nullifying.", 1)
            
            -- Stage 1: Defend by destroying the object.
            descendant:Destroy()

            -- Stage 2: Check if we are off cooldown for retaliation.
            local now = os.clock()
            if now - self.State.LastRetaliation > self.Config.RETALIATION_COOLDOWN_SECONDS then
                self.State.LastRetaliation = now
                
                -- Stage 3: Find a target and retaliate.
                local attacker = self:_findClosestPlayer()
                if attacker then
                    self:_initiateCounterFling(attacker.Character)
                end
            end
            
            -- We only handle one object per frame to be safe.
            break
        end
    end
end

--- Enables the MAD Guardian.
function Modules.MADGuardian:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    
    DoNotif("MAD Guardian: ENABLED. Fling retaliation is active.", 2)
end

--- Disables the MAD Guardian.
function Modules.MADGuardian:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.HeartbeatConnection then
        self.State.HeartbeatConnection:Disconnect()
        self.State.HeartbeatConnection = nil
    end
    
    DoNotif("MAD Guardian: DISABLED.", 2)
end

--- Toggles the MAD Guardian's state.
function Modules.MADGuardian:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Registers the command with your admin system.
function Modules.MADGuardian:Initialize()
    local module = self
    RegisterCommand({
        Name = "mad",
        Aliases = {"flingback", "antiflingretaliate"},
        Description = "Toggles a counter-fling system that retaliates against attackers."
    }, function()
        module:Toggle()
    end)
end


Modules.ClientCanary = {
    State = {
        IsEnabled = false,
        HeartbeatConnection = nil,
        ViolationData = {}, -- [Player] = { Level = number, LastCheck = number }
        HighlightedPlayers = {} -- [Player] = true
    },
    Config = {
        -- The horizontal speed (in studs/sec) above which behavior is considered suspicious.
        -- Normal walk speed is 16. This provides a generous buffer for normal game physics.
        MAX_REASONABLE_SPEED = 75,
        -- The number of violation "points" a player needs to accumulate before being flagged.
        VIOLATION_THRESHOLD = 8,
        -- How quickly (in seconds) a single violation point decays. This prevents false
        -- positives from single instances of high velocity (e.g., explosions).
        VIOLATION_DECAY_TIME = 2.5,
        -- How often (in seconds) the system checks players.
        CHECK_INTERVAL_SECONDS = 0.25
    }
}

--- [Internal] The main detection loop connected to RunService.Heartbeat.
function Modules.ClientCanary:_onHeartbeat(deltaTime)
    local now = os.clock()
    -- Iterate through all players and decay their violation levels over time.
    for player, data in pairs(self.State.ViolationData) do
        if now - data.LastCheck > self.Config.VIOLATION_DECAY_TIME then
            data.Level = math.max(0, data.Level - 1)
            data.LastCheck = now
        end
        if not player.Parent then -- Garbage collect data for players who left
            self.State.ViolationData[player] = nil
        end
    end

    -- Iterate through all players to check for new violations.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and self.State.HighlightedPlayers[player] == nil then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and rootPart and humanoid.Health > 0 then
                -- We check horizontal velocity to ignore high speeds from falling.
                local horizontalVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z)
                
                if horizontalVelocity.Magnitude > self.Config.MAX_REASONABLE_SPEED then
                    local data = self.State.ViolationData[player] or { Level = 0, LastCheck = now }
                    data.Level = data.Level + 1
                    data.LastCheck = now
                    self.State.ViolationData[player] = data
                    
                    -- If violation level exceeds the threshold, flag the player.
                    if data.Level >= self.Config.VIOLATION_THRESHOLD then
                        DoNotif(string.format("Exploiter Detected: %s (Reason: Sustained Speed)", player.Name), 4)
                        
                        -- Leverage the existing Highlight module to apply the visual.
                        pcall(function()
                            Modules.HighlightPlayer:ApplyHighlight(player.Character)
                        end)
                        
                        self.State.HighlightedPlayers[player] = true
                        self.State.ViolationData[player] = nil -- Reset their data to prevent re-flagging.
                    end
                end
            end
        end
    end
end

--- Enables the Client Canary.
function Modules.ClientCanary:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local lastCheck = 0
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        -- Throttle the main check for performance.
        if os.clock() - lastCheck > self.Config.CHECK_INTERVAL_SECONDS then
            self:_onHeartbeat(deltaTime)
            lastCheck = os.clock()
        end
    end)
    
    DoNotif("Client Canary: ENABLED. Automated exploiter detection is active.", 2)
end

--- Disables the Client Canary and clears any highlights it created.
function Modules.ClientCanary:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.HeartbeatConnection then
        self.State.HeartbeatConnection:Disconnect()
        self.State.HeartbeatConnection = nil
    end

    -- Clear all highlights that this module was responsible for.
    for player, _ in pairs(self.State.HighlightedPlayers) do
        -- We don't call ClearHighlight directly as it clears for all targets.
        -- Instead, we check if our highlight is still the active one.
        if Modules.HighlightPlayer.State.TargetPlayer == player then
            Modules.HighlightPlayer:ClearHighlight()
        end
    end
    
    table.clear(self.State.ViolationData)
    table.clear(self.State.HighlightedPlayers)
    
    DoNotif("Client Canary: DISABLED.", 2)
end

--- Toggles the Client Canary's state.
function Modules.ClientCanary:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Registers the command with your admin system.
function Modules.ClientCanary:Initialize()
    local module = self
    RegisterCommand({
        Name = "autodetect",
        Aliases = {"canary", "watchdog"},
        Description = "Toggles the automated client-side exploiter detection system."
    }, function()
        module:Toggle()
    end)
end


Modules.TweenClickTP = {
	State = {
		IsEnabled = false,
		Connection = nil,
		IsTweening = false -- Prevents starting a new tween while one is active
	},
	Config = {
		-- The key to hold while clicking. LeftAlt is a good choice to avoid conflicts.
		MODIFIER_KEY = Enum.KeyCode.LeftAlt,
		-- The duration of the camera "dash" animation in seconds.
		TWEEN_DURATION = 0.25,
		-- The easing style for a smooth acceleration/deceleration effect.
		TWEEN_STYLE = Enum.EasingStyle.Quint
	}
}

--- [Internal] Executes the camera tween and subsequent teleport.
function Modules.TweenClickTP:_executeTween(destination)
	if self.State.IsTweening then return end
	self.State.IsTweening = true

	-- Services (scoped locally for encapsulation)
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	
	local localPlayer = Players.LocalPlayer
	local character = localPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera

	if not (hrp and camera) then
		self.State.IsTweening = false
		return
	end

	-- 1. Create a temporary, invisible "anchor" part for the camera to follow.
	local cameraAnchor = Instance.new("Part")
	cameraAnchor.Size = Vector3.one
	cameraAnchor.Transparency = 1
	cameraAnchor.Anchored = true
	cameraAnchor.CanCollide = false
	cameraAnchor.CFrame = camera.CFrame
	cameraAnchor.Parent = Workspace

	-- 2. Define the animation for the anchor part.
	local tweenInfo = TweenInfo.new(self.Config.TWEEN_DURATION, self.Config.TWEEN_STYLE)
	-- The camera should arrive looking from its previous orientation towards the destination.
	local targetCFrame = CFrame.lookAt(destination, destination + camera.CFrame.LookVector)
	local tween = TweenService:Create(cameraAnchor, tweenInfo, { CFrame = targetCFrame })

	-- 3. Force the camera to follow the anchor part's tween.
	camera.CameraType = Enum.CameraType.Scriptable
	local camConnection = RunService.RenderStepped:Connect(function()
		camera.CFrame = cameraAnchor.CFrame
	end)
	
	tween:Play()

	-- 4. When the animation finishes, perform the actual teleport and clean up resources.
	tween.Completed:Connect(function()
		camConnection:Disconnect()
		hrp.CFrame = CFrame.new(destination) + Vector3.new(0, 3, 0) -- Vertical offset to prevent clipping
		camera.CameraType = Enum.CameraType.Custom
		cameraAnchor:Destroy()
		self.State.IsTweening = false
	end)
end

--- Enables the input listener for the TweenClickTP.
function Modules.TweenClickTP:Enable()
	if self.State.IsEnabled then return end
	self.State.IsEnabled = true

	self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or self.State.IsTweening then return end

		-- Check for the specific hotkey combination (e.g., LeftAlt + Left Click)
		if UserInputService:IsKeyDown(self.Config.MODIFIER_KEY) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = UserInputService:GetMouseLocation()
			local ray = Workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
			
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = { Players.LocalPlayer.Character }
			
			local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
			
			if result and result.Position then
				self:_executeTween(result.Position)
			end
		end
	end)

	DoNotif("Tween ClickTP: [Enabled]. Hold LeftAlt and click to teleport.", 3)
end

--- Disables the input listener and cleans up.
function Modules.TweenClickTP:Disable()
	if not self.State.IsEnabled then return end
	self.State.IsEnabled = false

	if self.State.Connection then
		self.State.Connection:Disconnect()
		self.State.Connection = nil
	end

	DoNotif("Tween ClickTP: [Disabled].", 2)
end

--- Toggles the state of the module.
function Modules.TweenClickTP:Toggle()
	if self.State.IsEnabled then
		self:Disable()
	else
		self:Enable()
	end
end

RegisterCommand({
	Name = "tweenclicktp",
	Aliases = {"tctp", "smoothtp", "blinktp"},
	Description = "Toggles a smooth, camera-animated teleport. Hold Left Alt and click to use."
}, function(args)
	Modules.TweenClickTP:Toggle()
end)



Modules.RespawnOnPlayer = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Connection = nil
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

--// --- Private Methods ---

function Modules.RespawnOnPlayer:_onCharacterAdded(character)
    task.defer(function()
        if not self.State.IsEnabled or not self.State.TargetPlayer or not self.State.TargetPlayer.Parent then
            DoNotif("Respawn target lost. Disabling.", 3)
            self:Disable()
            return
        end

        local myRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        -- [NEW ARCHITECTURE] Create a resilient wait loop for the target's character.
        -- This waits up to 5 seconds for the target to spawn, preventing the race condition.
        local targetCharacter = self.State.TargetPlayer.Character
        local targetRoot = nil
        
        if not targetCharacter then
            DoNotif("Waiting for " .. self.State.TargetPlayer.Name .. " to spawn...", 2)
            for i = 1, 10 do -- Try for 5 seconds (10 * 0.5s)
                targetCharacter = self.State.TargetPlayer.Character
                if targetCharacter then break end
                task.wait(0.5)
            end
        end

        -- Final check after the wait.
        if targetCharacter then
            targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        end

        if targetRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            DoNotif("Respawned on " .. self.State.TargetPlayer.Name, 2)
        else
            DoNotif("Could not respawn on target: Character not found (they may be respawning or have left).", 3)
        end
    end)
end

--// --- Public Methods (No changes needed here, the logic is sound) ---

function Modules.RespawnOnPlayer:Enable(targetPlayer)
    if not targetPlayer or targetPlayer == self.Services.Players.LocalPlayer then
        return DoNotif("Invalid or self-targeted player.", 3)
    end

    self:Disable() 

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer

    local module = self
    self.State.Connection = self.Services.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        module:_onCharacterAdded(char)
    end)

    DoNotif("Respawn on Target: ENABLED. Will respawn on " .. targetPlayer.Name, 3)
end

function Modules.RespawnOnPlayer:Disable()
    if not self.State.IsEnabled then return end

    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    self.State.TargetPlayer = nil
    self.State.IsEnabled = false

    DoNotif("Respawn on Target: DISABLED.", 2)
end

--// --- Command Registration ---
RegisterCommand({
    Name = "respawnontarget",
    Aliases = {"spon", "respawnon"},
    Description = "Sets your respawn point to a target player's location."
}, function(args)
    -- [CRITICAL FIX] Join all arguments to allow for names with spaces.
    local argument = table.concat(args, " ")
    
    if not argument or argument == "" then
        return DoNotif("Usage: ;spon <PlayerName|clear>", 3)
    end

    if argument:lower() == "clear" or argument:lower() == "reset" or argument:lower() == "off" then
        Modules.RespawnOnPlayer:Disable()
        return
    end

    local targetPlayer = Utilities.findPlayer(argument)
    if targetPlayer then
        Modules.RespawnOnPlayer:Enable(targetPlayer)
    else
        -- This notification will now correctly show the full name you tried to find.
        DoNotif("Player not found: '" .. argument .. "'", 3)
    end
end)

Modules.RemoteInteractor = {
    State = {
        IsExecuting = false
    },
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService")
    }
}

--// --- Public Method ---

function Modules.RemoteInteractor:Execute()
    if self.State.IsExecuting then
        return DoNotif("Remote interaction is already in progress.", 2)
    end

    self.State.IsExecuting = true
    DoNotif("Scanning workspace for all interactive objects...", 3)

    -- Run the entire operation in a separate thread to prevent the game from freezing.
    task.spawn(function()
        local localPlayer = self.Services.Players.LocalPlayer
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            DoNotif("Cannot execute: Character's HumanoidRootPart not found.", 3)
            self.State.IsExecuting = false
            return
        end

        local originalCFrame = hrp.CFrame
        local promptsFired = 0
        local detectorsTriggered = 0
        local allInteractiveObjects = self.Services.Workspace:GetDescendants()

        --// --- Phase 1: Fire all ProximityPrompts (Clean Method) ---
        if fireproximityprompt then
            for _, instance in ipairs(allInteractiveObjects) do
                if instance:IsA("ProximityPrompt") then
                    local success, err = pcall(fireproximityprompt, instance)
                    if success then
                        promptsFired = promptsFired + 1
                    end
                end
            end
        else
             warn("[RemoteInteractor] 'fireproximityprompt' is not available in this environment. Skipping ProximityPrompt phase.")
        end
        
        -- A small delay to allow the engine to process the fired prompts.
        task.wait()

        --// --- Phase 2: Trigger all ClickDetectors (Teleport Method) ---
        local detectorsToTrigger = {}
        for _, instance in ipairs(allInteractiveObjects) do
            if instance:IsA("ClickDetector") then
                table.insert(detectorsToTrigger, instance)
            end
        end

        if #detectorsToTrigger > 0 then
            DoNotif("Found " .. #detectorsToTrigger .. " ClickDetectors. Triggering via teleport...", 2)
            for _, detector in ipairs(detectorsToTrigger) do
                local targetPart = detector.Parent
                if targetPart and targetPart:IsA("BasePart") then
                    -- Teleport to the part, wait one frame for the server to register proximity, then continue.
                    hrp.CFrame = targetPart.CFrame
                    self.Services.RunService.Heartbeat:Wait()
                    detectorsTriggered = detectorsTriggered + 1
                end
            end

            -- After iterating through all detectors, return to the original position.
            hrp.CFrame = originalCFrame
        end

        DoNotif(string.format("Interaction complete. Fired %d prompts and triggered %d detectors.", promptsFired, detectorsTriggered), 4)
        self.State.IsExecuting = false
    end)
end

--// --- Command Registration ---
RegisterCommand({
    Name = "triggerall",
    Aliases = {"clickall", "fireclicks"},
    Description = "Scans and remotely fires all ClickDetectors and ProximityPrompts in the game."
}, function()
    Modules.RemoteInteractor:Execute()
end)


Modules.BlockRemote = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        BlockedRemotes = {} -- Using a dictionary/hash map for instant lookups
    }
}

--- Enables the __namecall hook to intercept and block remotes.
function Modules.BlockRemote:Enable()
    if self.State.IsEnabled then return end

    -- This check is critical for ensuring the environment supports the required functions.
    if not (getrawmetatable and getnamecallmethod) then
        DoNotif("Error: Your executor does not support __namecall hooking.", 4)
        return
    end
    
    local mt = getrawmetatable(game)
    self.State.OriginalNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = function(...)
        local args = {...}
        local selfArg = args[1]
        local method = getnamecallmethod()

        -- We only care about client-to-server remote invocations.
        if (selfArg:IsA("RemoteEvent") and method == "FireServer") or (selfArg:IsA("RemoteFunction") and method == "InvokeServer") then
            local remotePath = selfArg:GetFullName()
            
            -- If the remote's path is in our block list, we "swallow" the call by returning nil.
            if self.State.BlockedRemotes[remotePath] then
                print("--> [BlockRemote] Blocked call to:", remotePath)
                return nil -- Discard the call.
            end
        end

        -- If it's not in our block list, pass it through to the original function.
        return self.State.OriginalNamecall(...)
    end
    setreadonly(mt, true)
    
    self.State.IsEnabled = true
    DoNotif("Remote Blocking System: ENABLED.", 2)
end

--- Disables the hook and restores the original __namecall method.
function Modules.BlockRemote:Disable()
    if not self.State.IsEnabled then return end
    
    -- Safely attempt to restore the original metatable index.
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
    end)
    
    self.State.IsEnabled = false
    self.State.OriginalNamecall = nil
    DoNotif("Remote Blocking System: DISABLED.", 2)
end

--- Initializes the module and registers all associated commands.
function Modules.BlockRemote:Initialize()
    local module = self

    RegisterCommand({
        Name = "blockremote",
        Aliases = {"br", "block"},
        Description = "Blocks a remote by its full path."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;blockremote <path.to.remote>", 3)
        end
        -- Automatically enable the core system if it isn't already running.
        if not module.State.IsEnabled then
            module:Enable()
        end
        local path = args[1]
        module.State.BlockedRemotes[path] = true
        DoNotif("Added to block list: " .. path, 2)
    end)

    RegisterCommand({
        Name = "unblockremote",
        Aliases = {"ubr", "unblock"},
        Description = "Unblocks a remote by its full path."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;unblockremote <path.to.remote>", 3)
        end
        local path = args[1]
        if module.State.BlockedRemotes[path] then
            module.State.BlockedRemotes[path] = nil
            DoNotif("Removed from block list: " .. path, 2)
        else
            DoNotif("That remote was not on the block list.", 2)
        end
    end)

    RegisterCommand({
        Name = "listblocked",
        Aliases = {"lsb"},
        Description = "Lists all currently blocked remotes in the F9 console."
    }, function()
        print("--- [Blocked Remotes] ---")
        local count = 0
        for path, _ in pairs(module.State.BlockedRemotes) do
            print(" - " .. path)
            count = count + 1
        end
        DoNotif("Printed " .. count .. " blocked remotes to the console.", 2)
    end)

    RegisterCommand({
        Name = "clearblocked",
        Aliases = {"clb"},
        Description = "Clears the entire remote block list."
    }, function()
        table.clear(module.State.BlockedRemotes)
        DoNotif("Remote block list has been cleared.", 2)
    end)

    RegisterCommand({
        Name = "toggleremotehooks",
        Aliases = {"trh"},
        Description = "Toggles the remote hooking system on/off without clearing the block list."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
end

Modules.ForceRespawn = {
    -- This module does not require persistent state, so the State table is omitted.
}

--- Executes the client-sided respawn sequence.
function Modules.ForceRespawn:Execute()
    --// SERVICES
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    --// CONSTANTS & LOCALS
    local localPlayer: Player = Players.LocalPlayer
    local character: Model? = localPlayer.Character
    local humanoidRootPart: BasePart? = character and character:FindFirstChild("HumanoidRootPart")

    --// VALIDATION
    if not (character and humanoidRootPart) then
        DoNotif("Cannot respawn: Character or HumanoidRootPart not found.", 3)
        return
    end

    --// CAPTURE CURRENT STATE
    -- We save the CFrame of both the character and camera to restore them post-respawn.
    local originalCharacterCFrame: CFrame = humanoidRootPart.CFrame
    local originalCameraCFrame: CFrame = Workspace.CurrentCamera.CFrame

    --// RESPAWN LOGIC
    local success, err = pcall(function()
        -- [METHOD 1] Executor-Specific Respawn (High Reliability)
        -- This attempts to use non-standard, environment-specific functions for a cleaner respawn.
        -- 'gethiddenproperty' checks if the game prevents standard character deletion methods.
        local isDeletionRejected: boolean = gethiddenproperty(Workspace, "RejectCharacterDeletions")

        if isDeletionRejected and replicatesignal then
            -- If character deletion is rejected and we have 'replicatesignal', use the high-level method.
            replicatesignal(localPlayer.ConnectDiedSignalBackend)
            task.wait(Players.RespawnTime - 0.1) -- Wait just before the default respawn time.
            replicatesignal(localPlayer.Kill)
        else
            -- [METHOD 2] Manual Fallback Respawn (Universal Compatibility)
            -- This method works in most environments by manually destroying the character
            -- and tricking the engine into loading a new one.
            local humanoid: Humanoid? = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            end
            character:ClearAllChildren()

            -- Create a temporary model to force the character property to update.
            local tempModel = Instance.new("Model")
            tempModel.Parent = Workspace
            localPlayer.Character = tempModel
            task.wait() -- Wait for replication cycle.
            localPlayer.Character = nil -- Setting to nil triggers the standard respawn logic.
            tempModel:Destroy()
        end
    end)

    if not success then
        warn("[ForceRespawn] Respawn logic failed:", err)
        DoNotif("Respawn failed. See developer console for details.", 4)
        return
    end

    --// STATE RESTORATION
    -- Spawn a new thread to wait for the new character and restore the saved positions.
    task.spawn(function()
        local pcallSuccess, newCharacter = pcall(function()
            return localPlayer.CharacterAdded:Wait()
        end)

        if not pcallSuccess then return end

        local newHrp = newCharacter:WaitForChild("HumanoidRootPart", 5)
        if newHrp then
            newHrp.CFrame = originalCharacterCFrame
            Workspace.CurrentCamera.CFrame = originalCameraCFrame
        end
    end)
end

--// COMMAND REGISTRATION
RegisterCommand({
    Name = "respawn",
    Aliases = {"re", "rr"},
    Description = "Forces a client-sided character respawn, attempting to preserve position."
}, function()
    Modules.ForceRespawn:Execute()
end)

Modules.SuperPush = {
State = {
IsEnabled = false,
Connections = {},
Originals = setmetatable({}, {__mode = "k"})
},
Config = {
PUSH_FORCE = 900,
DENSITY = 100,
COOLDOWN = 0,
lastPushTime = 0
}
}
local HEAVY_PROPERTIES = PhysicalProperties.new(Modules.SuperPush.Config.DENSITY, 0.5, 0.5)
function Modules.SuperPush:_cleanupCharacter(character)
    if not character then return end
        if self.State.Connections.Touch then
            self.State.Connections.Touch:Disconnect()
            self.State.Connections.Touch = nil
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and self.State.Originals[part] then
                part.CustomPhysicalProperties = self.State.Originals[part]
                self.State.Originals[part] = nil
            end
        end
    end
    function Modules.SuperPush:_applyToCharacter(character)
        if not character then return end
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if not hrp then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not self.State.Originals[part] then
                            self.State.Originals[part] = part.CustomPhysicalProperties
                        end
                        part.CustomPhysicalProperties = HEAVY_PROPERTIES
                    end
                end
                self.State.Connections.Touch = hrp.Touched:Connect(function(otherPart)
                if os.clock() - self.Config.lastPushTime < self.Config.COOLDOWN then return end
                    local targetModel = otherPart:FindFirstAncestorWhichIsA("Model")
                    if not targetModel then return end
                        local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
                        if not targetPlayer or targetPlayer == LocalPlayer then return end
                            local direction = hrp.CFrame.LookVector
                            hrp.AssemblyLinearVelocity = direction * self.Config.PUSH_FORCE
                            self.Config.lastPushTime = os.clock()
                            task.wait()
                            if hrp and hrp.Parent then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                            end
                        end)
                    end
                    function Modules.SuperPush:Toggle()
                        self.State.IsEnabled = not self.State.IsEnabled
                        if self.State.IsEnabled then
                            DoNotif("Super Push Enabled (Force: " .. self.Config.PUSH_FORCE .. ", Density: " .. self.Config.DENSITY .. ")", 3)
                            if LocalPlayer.Character then
                                self:_applyToCharacter(LocalPlayer.Character)
                            end
                            self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
                            self:_applyToCharacter(character)
                        end)
                        self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
                        self:_cleanupCharacter(character)
                    end)
                else
                DoNotif("Super Push Disabled", 2)
                if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
                    if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
                        table.clear(self.State.Connections)
                        if LocalPlayer.Character then
                            self:_cleanupCharacter(LocalPlayer.Character)
                        end
                    end
                end
                RegisterCommand({
                Name = "superpush",
                Aliases = {"bump", "heavy"},
                Description = "Increases your mass and adds a velocity push when you bump into players."
                }, function()
                Modules.SuperPush:Toggle()
            end)
            Modules.Aura = {
            State = {
            Enabled = false,
            Distance = 20,
            Connection = nil,
            Visualizer = nil,
            },
            }
            function Modules.Aura:Disable()
                if not self.State.Enabled then return end
                    if self.State.Connection then
                        self.State.Connection:Disconnect()
                        self.State.Connection = nil
                    end
                    if self.State.Visualizer then
                        self.State.Visualizer:Destroy()
                        self.State.Visualizer = nil
                    end
                    self.State.Enabled = false
                    DoNotif("Aura disabled.", 2)
                end
                function Modules.Aura:Enable()
                    if self.State.Enabled then self:Disable() end
                        if not firetouchinterest then
                            return DoNotif("This script requires 'firetouchinterest' to function.", 5)
                        end
                        local Players = game:GetService("Players")
                        local RunService = game:GetService("RunService")
                        local Workspace = game:GetService("Workspace")
                        local visualizer = Instance.new("Part")
                        visualizer.Shape = Enum.PartType.Ball
                        visualizer.Size = Vector3.new(self.State.Distance * 2, self.State.Distance * 2, self.State.Distance * 2)
                        visualizer.Transparency = 0.8
                        visualizer.Color = Color3.fromRGB(255, 0, 0)
                        visualizer.Material = Enum.Material.Neon
                        visualizer.Anchored = true
                        visualizer.CanCollide = false
                        visualizer.Parent = Workspace
                        self.State.Visualizer = visualizer
                        self.State.Enabled = true
                        DoNotif("Aura enabled at " .. self.State.Distance .. " studs.", 2)
                        self.State.Connection = RunService.RenderStepped:Connect(function()
                        local localPlayer = Players.LocalPlayer
                        if not (localPlayer and self.State.Enabled) then return self:Disable() end
                            local character = localPlayer.Character
                            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                            local tool = character and character:FindFirstChildOfClass("Tool")
                            local handle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
                            if not (rootPart and handle and self.State.Visualizer) then
                                return
                            end
                            self.State.Visualizer.CFrame = rootPart.CFrame
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                    if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
                                        if (targetRoot.Position - rootPart.Position).Magnitude <= self.State.Distance then
                                            firetouchinterest(handle, targetRoot, 0)
                                            task.wait()
                                            firetouchinterest(handle, targetRoot, 1)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    function Modules.Aura:Initialize()
                        RegisterCommand({
                        Name = "aura",
                        Aliases = {},
                        Description = "Continuously damages nearby players. Optional [distance] argument."
                        }, function(args)
                        local dist = tonumber(args[1])
                        local wasEnabled = self.State.Enabled
                        if dist and dist > 0 then
                            self.State.Distance = dist
                            DoNotif("Aura distance set to " .. dist, 2)
                        end
                        if wasEnabled then
                            self:Disable()
                        else
                        self:Enable()
                    end
                end)
            end
            Modules.HandleKill = {
            State = {
            ActiveLoops = {},
            },
            }
            function Modules.HandleKill:StopLoop(targetPlayer)
                if not self.State.ActiveLoops[targetPlayer] then return end
                    self.State.ActiveLoops[targetPlayer] = nil
                    DoNotif("HandleKill stopped for " .. targetPlayer.Name, 2)
                end
                function Modules.HandleKill:StartLoop(targetPlayer)
                    if self.State.ActiveLoops[targetPlayer] then return end
                        local character = LocalPlayer.Character
                        if not character then return DoNotif("Your character was not found.", 3) end
                            local tool = character:FindFirstChildOfClass("Tool")
                            if not tool or not tool:FindFirstChild("Handle") then
                                return DoNotif("You must be holding a tool with a 'Handle'.", 3)
                            end
                            local handle = tool.Handle
                            local loopThread = coroutine.create(function()
                            self.State.ActiveLoops[targetPlayer] = true
                            while self.State.ActiveLoops[targetPlayer] and tool.Parent == character and targetPlayer.Character do
                                local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if not humanoid or humanoid.Health <= 0 then break end
                                    for _, part in ipairs(targetPlayer.Character:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            firetouchinterest(handle, part, 0)
                                            task.wait()
                                            firetouchinterest(handle, part, 1)
                                        end
                                    end
                                    RunService.Heartbeat:Wait()
                                end
                                self.State.ActiveLoops[targetPlayer] = nil
                            end)
                            coroutine.resume(loopThread)
                            DoNotif("HandleKill initiated on " .. targetPlayer.Name, 2)
                        end
                        function Modules.HandleKill:Initialize()
                            local module = self
                            RegisterCommand({
                            Name = "handlekill",
                            Aliases = {"hkill"},
                            Description = "Toggles a kill loop on a player using your equipped tool."
                            }, function(args)
                            if not firetouchinterest then
                                return DoNotif("firetouchinterest is not supported.", 3)
                            end
                            if not args[1] then
                                return DoNotif("Usage: hkill <player>", 3)
                            end
                            local targetPlayer = Utilities.findPlayer(args[1])
                            if not targetPlayer then
                                return DoNotif("No target found.", 3)
                            end
                            if module.State.ActiveLoops[targetPlayer] then
                                module:StopLoop(targetPlayer)
                            else
                            module:StartLoop(targetPlayer)
                        end
                    end)
                end
                Modules.RemoteSpy = {
                State = {
                IsEnabled = false,
                UI = nil,
                OriginalNamecall = nil,
                BlockedRemotes = {}
                }
                }
                function Modules.RemoteSpy:Toggle()
                    if self.State.IsEnabled then
                        pcall(function()
                        local mt = getrawmetatable(game)
                        if mt and self.State.OriginalNamecall then
                            setreadonly(mt, false)
                            mt.__namecall = self.State.OriginalNamecall
                            setreadonly(mt, true)
                        end
                        if self.State.UI then
                            self.State.UI:Destroy()
                        end
                    end)
                    self.State.IsEnabled = false
                    self.State.UI = nil
                    self.State.OriginalNamecall = nil
                    table.clear(self.State.BlockedRemotes)
                    DoNotif("RemoteSpy Disabled.", 2)
                    return
                end
                self.State.IsEnabled = true
                DoNotif("RemoteSpy Enabled.", 2)
                local CoreGui = game:GetService("CoreGui")
                local UserInputService = game:GetService("UserInputService")
                local CONFIG = {
                UI_TITLE = "Zuka's RemoteSpy",
                PRIMARY_COLOR = Color3.fromRGB(0, 255, 255),
                BACKGROUND_COLOR = Color3.fromRGB(30, 30, 40),
                FONT = Enum.Font.GothamSemibold
                }
                local remoteSpyGui = Instance.new("ScreenGui")
                remoteSpyGui.Name = "RemoteSpy_" .. math.random(1000, 9999)
                remoteSpyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                remoteSpyGui.ResetOnSpawn = false
                self.State.UI = remoteSpyGui
                local mainFrame = Instance.new("Frame")
                mainFrame.Size = UDim2.fromOffset(500, 350)
                mainFrame.Position = UDim2.fromScale(0.5, 0.5)
                mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                mainFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
                mainFrame.BorderSizePixel = 0
                mainFrame.ClipsDescendants = true
                mainFrame.Parent = remoteSpyGui
                Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)
                local stroke = Instance.new("UIStroke", mainFrame)
                stroke.Color = CONFIG.PRIMARY_COLOR
                stroke.Thickness = 1.5
                stroke.Transparency = 0.4
                local titleBar = Instance.new("Frame")
                titleBar.Size = UDim2.new(1, 0, 0, 30)
                titleBar.BackgroundColor3 = CONFIG.PRIMARY_COLOR
                titleBar.BackgroundTransparency = 0.85
                titleBar.Parent = mainFrame
                local titleLabel = Instance.new("TextLabel", titleBar)
                titleLabel.Size = UDim2.new(1, -60, 1, 0)
                titleLabel.Position = UDim2.fromOffset(10, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Font = CONFIG.FONT
                titleLabel.Text = CONFIG.UI_TITLE
                titleLabel.TextColor3 = Color3.new(1, 1, 1)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.TextSize = 16
                local exitButton = Instance.new("TextButton", titleBar)
                exitButton.Size = UDim2.fromOffset(30, 30)
                exitButton.Position = UDim2.new(1, 0, 0, 0)
                exitButton.AnchorPoint = Vector2.new(1, 0)
                exitButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                exitButton.BackgroundTransparency = 0.5
                exitButton.Font = CONFIG.FONT
                exitButton.Text = "X"
                exitButton.TextColor3 = Color3.new(1, 1, 1)
                local minimizeButton = Instance.new("TextButton", titleBar)
                minimizeButton.Size = UDim2.fromOffset(30, 30)
                minimizeButton.Position = UDim2.new(1, -30, 0, 0)
                minimizeButton.AnchorPoint = Vector2.new(1, 0)
                minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                minimizeButton.BackgroundTransparency = 0.5
                minimizeButton.Font = CONFIG.FONT
                minimizeButton.Text = "-"
                minimizeButton.TextColor3 = Color3.new(1, 1, 1)
                local contentFrame = Instance.new("Frame")
                contentFrame.Size = UDim2.new(1, 0, 1, -30)
                contentFrame.Position = UDim2.fromOffset(0, 30)
                contentFrame.BackgroundTransparency = 1
                contentFrame.Parent = mainFrame
                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
                scrollingFrame.Position = UDim2.fromScale(0.5, 0.5)
                scrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                scrollingFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
                scrollingFrame.BackgroundTransparency = 0.5
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.ScrollBarThickness = 5
                scrollingFrame.Parent = contentFrame
                local listLayout = Instance.new("UIListLayout", scrollingFrame)
                listLayout.Padding = UDim.new(0, 5)
                local entryTemplate = Instance.new("Frame")
                entryTemplate.Name = "EntryTemplate"
                entryTemplate.Size = UDim2.new(1, -4, 0, 60)
                entryTemplate.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                entryTemplate.BorderSizePixel = 0
                local pathLabel = Instance.new("TextLabel", entryTemplate)
                pathLabel.Size = UDim2.new(1, -10, 0, 20)
                pathLabel.Position = UDim2.fromOffset(5, 2)
                pathLabel.BackgroundTransparency = 1
                pathLabel.Font = Enum.Font.Code
                pathLabel.TextColor3 = CONFIG.PRIMARY_COLOR
                pathLabel.TextXAlignment = Enum.TextXAlignment.Left
                pathLabel.TextSize = 13
                pathLabel.ClipsDescendants = true
                local argsLabel = Instance.new("TextLabel", entryTemplate)
                argsLabel.Size = UDim2.new(1, -10, 0, 14)
                argsLabel.Position = UDim2.fromOffset(5, 22)
                argsLabel.BackgroundTransparency = 1
                argsLabel.Font = Enum.Font.Code
                argsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                argsLabel.TextXAlignment = Enum.TextXAlignment.Left
                argsLabel.TextSize = 12
                argsLabel.ClipsDescendants = true
                local fireButton = Instance.new("TextButton", entryTemplate)
                fireButton.Size = UDim2.fromOffset(60, 20)
                fireButton.Position = UDim2.new(1, -135, 1, -25)
                fireButton.AnchorPoint = Vector2.new(0, 1)
                fireButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                fireButton.Font = Enum.Font.Gotham
                fireButton.Text = "Fire"
                fireButton.TextColor3 = Color3.white
                local blockButton = Instance.new("TextButton", entryTemplate)
                blockButton.Size = UDim2.fromOffset(60, 20)
                blockButton.Position = UDim2.new(1, -65, 1, -25)
                blockButton.AnchorPoint = Vector2.new(0, 1)
                blockButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                blockButton.Font = Enum.Font.Gotham
                blockButton.Text = "Block"
                blockButton.TextColor3 = Color3.white
                local module = self
                exitButton.MouseButton1Click:Connect(function()
                module:Toggle()
            end)
            do
                local isMinimized = false
                minimizeButton.MouseButton1Click:Connect(function()
                isMinimized = not isMinimized
                contentFrame.Visible = not isMinimized
                minimizeButton.Text = isMinimized and "+" or "-"
                mainFrame.Size = isMinimized and UDim2.fromOffset(200, 30) or UDim2.fromOffset(500, 350)
            end)
        end
        do
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
                moveConn:Disconnect()
                endConn:Disconnect()
            end
        end)
    end
end)
end
local function serializeArguments(args)
local serialized = {}
for _, v in ipairs(args) do
    local t = typeof(v)
    if t == "string" then table.insert(serialized, string.format("%q", v))
    elseif t == "Instance" then table.insert(serialized, v:GetFullName())
elseif t == "table" then table.insert(serialized, "{...}")
else table.insert(serialized, tostring(v)) end
end
return "{" .. table.concat(serialized, ", ") .. "}"
end
local function logRemote(remote, args)
local fullName = remote:GetFullName()
local entry = entryTemplate:Clone()
local remoteType = remote:IsA("RemoteEvent") and "EVENT" or "FUNCTION"
entry.pathLabel.Text = string.format("[%s] %s", remoteType, fullName)
entry.argsLabel.Text = serializeArguments(args)
entry.Parent = scrollingFrame
entry.fireButton.MouseButton1Click:Connect(function()
if remote and remote.Parent then
    if remoteType == "EVENT" then
        remote:FireServer(unpack(args))
    else
    pcall(remote.InvokeServer, remote, unpack(args))
end
end
end)
entry.blockButton.MouseButton1Click:Connect(function()
module.State.BlockedRemotes[fullName] = true
entry.blockButton.Text = "Blocked"
entry.blockButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
entry.blockButton.AutoButtonColor = false
end)
scrollingFrame.CanvasPosition = Vector2.new(0, listLayout.AbsoluteContentSize.Y)
end
local mt = getrawmetatable(game)
self.State.OriginalNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(...)
local args = {...}
local selfArg = args[1]
local method = getnamecallmethod()
if (selfArg:IsA("RemoteEvent") and method == "FireServer") or (selfArg:IsA("RemoteFunction") and method == "InvokeServer") then
    local fullName = selfArg:GetFullName()
    if module.State.BlockedRemotes[fullName] then
        return
    end
    local callArgs = {}
    for i = 2, #args do table.insert(callArgs, args[i]) end
        logRemote(selfArg, callArgs)
    end
    return module.State.OriginalNamecall(...)
end
setreadonly(mt, true)
remoteSpyGui.Parent = CoreGui
end
function Modules.RemoteSpy:Initialize()
    local module = self
    RegisterCommand({
    Name = "remotespy",
    Aliases = {"rspy"},
    Description = "Toggles a UI to inspect and block remote events/functions."
    }, function(args)
    module:Toggle()
end)
end
Modules.Strengthen = {
State = {
Enabled = false,
Density = 100,
OriginalProperties = {},
},
}
function Modules.Strengthen:ApplyToCharacter(character)
    table.clear(self.State.OriginalProperties)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.State.OriginalProperties[part] = part.CustomPhysicalProperties
            part.CustomPhysicalProperties = PhysicalProperties.new(self.State.Density, 0.3, 0.5)
        end
    end
end
function Modules.Strengthen:RevertForCharacter()
    local character = Players.LocalPlayer.Character
    if not character then return end
        for part, originalProperties in pairs(self.State.OriginalProperties) do
            if part and part.Parent and part:IsDescendantOf(character) then
                part.CustomPhysicalProperties = originalProperties
            end
        end
        table.clear(self.State.OriginalProperties)
    end
    function Modules.Strengthen:Initialize()
        local module = self
        RegisterCommand({
        Name = "strengthen",
        Aliases = {"buff", "density"},
        Description = "Toggles high character density to resist forces. Optional [density] argument."
        }, function(args)
        local character = Players.LocalPlayer.Character
        if not character then
            return DoNotif("Character not found.", 3)
        end
        local newDensity = tonumber(args[1])
        if newDensity and newDensity > 0 then
            module.State.Density = newDensity
            DoNotif("Strengthen density set to " .. module.State.Density, 2)
        end
        if module.State.Enabled then
            module:RevertForCharacter()
            module.State.Enabled = false
            DoNotif("Strengthen disabled. Character physics restored.", 2)
        else
        module:ApplyToCharacter(character)
        module.State.Enabled = true
        DoNotif("Strengthen enabled at density " .. module.State.Density, 2)
    end
end)
end

Modules.AntiAnchor = {
    State = {
        Enabled = false,
        TrackedParts = setmetatable({}, {__mode="k"}),
        OriginalProperties = setmetatable({}, {__mode="k"}),
        Signals = setmetatable({}, {__mode="k"}),
        CharacterConnections = {},
        FailsafeConnection = nil,
    },
    Dependencies = {"Players", "RunService"},
}

function Modules.AntiAnchor:Enforce(part)
    if not (part and part:IsA("BasePart")) then return end
    
    if self.State.OriginalProperties[part] == nil then
        self.State.OriginalProperties[part] = part.Anchored
    end
    
    self.State.TrackedParts[part] = true
    if part.Anchored then part.Anchored = false end
    
    if not self.State.Signals[part] then
        self.State.Signals[part] = part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if self.State.Enabled and part.Anchored then
                part.Anchored = false
            end
        end)
    end
end

function Modules.AntiAnchor:ProcessCharacter(character)
    for _, child in ipairs(character:GetDescendants()) do self:Enforce(child) end
    
    table.insert(self.State.CharacterConnections, character.DescendantAdded:Connect(function(child) self:Enforce(child) end))
    table.insert(self.State.CharacterConnections, character.DescendantRemoving:Connect(function(child)
        if self.State.Signals[child] then
            self.State.Signals[child]:Disconnect()
            self.State.Signals[child] = nil
        end
        self.State.TrackedParts[child] = nil
        self.State.OriginalProperties[child] = nil
    end))
end

function Modules.AntiAnchor:Enable()
    if self.State.Enabled then return end
    self.State.Enabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then self:ProcessCharacter(localPlayer.Character) end
    
    table.insert(self.State.CharacterConnections, localPlayer.CharacterAdded:Connect(function(char) self:ProcessCharacter(char) end))
    
    self.State.FailsafeConnection = self.Services.RunService.Stepped:Connect(function()
        for part in pairs(self.State.TrackedParts) do
            if part and part.Anchored then part.Anchored = false end
        end
    end)
    DoNotif("Anti-Anchor enabled.", 2)
end

function Modules.AntiAnchor:Disable()
    if not self.State.Enabled then return end
    self.State.Enabled = false
    
    for _, conn in ipairs(self.State.CharacterConnections) do conn:Disconnect() end
    for _, conn in pairs(self.State.Signals) do conn:Disconnect() end
    if self.State.FailsafeConnection then self.State.FailsafeConnection:Disconnect() end
    
    for part, originalValue in pairs(self.State.OriginalProperties) do
        if part and part.Parent then part.Anchored = originalValue end
    end
    
    table.clear(self.State.TrackedParts)
    table.clear(self.State.OriginalProperties)
    table.clear(self.State.Signals)
    table.clear(self.State.CharacterConnections)
    self.State.FailsafeConnection = nil
    
    DoNotif("Anti-Anchor disabled.", 2)
end

function Modules.AntiAnchor:Initialize()
    -- ARCHITECT'S NOTE: The 'Initialize' function is where dependencies should be loaded.
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "antianchor",
        Aliases = {"aa"},
        Description = "Toggles a robust defense against being anchored."
    }, function()
        -- The previous logic was slightly flawed; calling self:Enable/Disable directly is cleaner.
        if self.State.Enabled then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.FakeLag = {
    State = {
        IsEnabled = false,
        LoopConnection = nil,
        IsCharacterAnchored = false, -- The current anchor state in the loop
        NextFlipTimestamp = 0,     -- The os.clock() time for the next state flip
        StartTime = 0              -- The time the effect was enabled, for duration checks
    },
    Config = {
        Interval = 0.05, -- The base time (in seconds) between anchoring/unanchoring
        Jitter = 0.02,   -- Random time added/subtracted from the interval
        Duration = nil   -- How long the effect should last in seconds (nil = infinite)
    },
    Dependencies = {"RunService", "Players"},
    Services = {}
}

---
-- [Private] The core logic loop that toggles the anchored state.
--
function Modules.FakeLag:_onHeartbeat()
    -- Failsafe: if the module is disabled but the loop is still running, kill it.
    if not self.State.IsEnabled then
        self:Disable()
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    -- If the character is gone, disable the module to clean up.
    if not hrp then
        self:Disable()
        return
    end

    -- Check if the duration has expired.
    if self.Config.Duration and (os.clock() - self.State.StartTime) > self.Config.Duration then
        self:Disable()
        return
    end

    -- The main toggle logic.
    local now = os.clock()
    if now >= self.State.NextFlipTimestamp then
        self.State.IsCharacterAnchored = not self.State.IsCharacterAnchored
        pcall(function() hrp.Anchored = self.State.IsCharacterAnchored end)

        -- Calculate the next interval with random jitter.
        local interval = self.Config.Interval
        local jitter = self.Config.Jitter
        local nextDelay = interval + (jitter > 0 and (math.random() * 2 * jitter - jitter) or 0)
        
        self.State.NextFlipTimestamp = now + math.max(0, nextDelay)
    end
end

---
-- Disables the fake lag effect and restores the character to a normal state.
--
function Modules.FakeLag:Disable()
    if not self.State.IsEnabled then return end

    if self.State.LoopConnection then
        self.State.LoopConnection:Disconnect()
        self.State.LoopConnection = nil
    end

    self.State.IsEnabled = false
    
    -- [CRITICAL] Ensure the player is unanchored upon disabling.
    task.spawn(function()
        local hrp = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function() hrp.Anchored = false end)
        end
    end)
    
    DoNotif("Fake Lag disabled.", 2)
end

---
-- Enables the fake lag effect, optionally updating its configuration.
--
function Modules.FakeLag:Enable(interval, jitter, duration)
    -- Always disable first to ensure a clean start and prevent duplicate loops.
    self:Disable()

    -- Safely parse and update config values.
    local newInterval = tonumber(interval)
    local newJitter = tonumber(jitter)
    local newDuration = tonumber(duration)

    if newInterval then self.Config.Interval = math.max(0, newInterval) end
    if newJitter then self.Config.Jitter = math.max(0, newJitter) end
    self.Config.Duration = (newDuration and newDuration > 0) and newDuration or nil

    -- Initialize state for the new session.
    self.State.IsEnabled = true
    self.State.StartTime = os.clock()
    self.State.NextFlipTimestamp = os.clock()
    self.State.IsCharacterAnchored = false

    -- Connect the core loop.
    self.State.LoopConnection = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)

    DoNotif("Fake Lag enabled.", 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.FakeLag:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "fakelag",
        Aliases = {"flag"},
        Description = "Toggles fake lag."
    }, function(args)
        local arg1 = args[1]
        
        if arg1 and (arg1:lower() == "off" or arg1:lower() == "stop") then
            module:Disable()
        else
            -- If already enabled and no new args, treat it as a toggle to turn it off.
            if module.State.IsEnabled and #args == 0 then
                module:Disable()
            else
                -- Enable with optional arguments.
                module:Enable(args[1], args[2], args[3])
            end
        end
    end)

    RegisterCommand({
        Name = "unfakelag",
        Aliases = {"unflag"},
        Description = "Stops the fake lag command."
    }, function()
        module:Disable()
    end)
end

Modules.RevealInvisible = {
    State = {
        Connection = nil,
        OriginalTransparency = setmetatable({}, {__mode="k"}),
    },
    Dependencies = {"RunService", "Workspace"},
}

function Modules.RevealInvisible:Disable()
    if not self.State.Connection then return end
    
    self.State.Connection:Disconnect()
    self.State.Connection = nil
    
    for part, originalValue in pairs(self.State.OriginalTransparency) do
        if part and part.Parent then
            part.Transparency = originalValue
        end
    end
    
    table.clear(self.State.OriginalTransparency)
    DoNotif("Invisible parts have been hidden again.", 2)
end

function Modules.RevealInvisible:Enable()
    self:Disable() -- Ensure any previous state is cleared before running.
    
    local partsRevealed = 0
    for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency > 0.95 then
            if self.State.OriginalTransparency[part] == nil then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
                partsRevealed = partsRevealed + 1
            end
        end
    end
    
    DoNotif("Initial scan revealed " .. partsRevealed .. " invisible parts.", 2)
    
    self.State.Connection = self.Services.RunService.RenderStepped:Connect(function()
        for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency > 0.95 and not self.State.OriginalTransparency[part] then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
            end
        end
    end)
end

function Modules.RevealInvisible:Initialize()
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "invisibleparts",
        Aliases = {"invisparts", "showinvisible"},
        Description = "Toggles the visibility of all invisible parts in the workspace."
    }, function()
        if self.State.Connection then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.GripEditor = {
    State = {
        UI = {}, -- Will hold all UI instances (ScreenGui, TextBoxes, etc.)
        GripConnection = nil -- Stores the RBXScriptConnection for the .Changed event
    },
    Dependencies = {"Players", "CoreGui", "UserInputService"},
    Services = {}
}


function Modules.GripEditor:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            -- Disconnect the drag on input release
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.GripEditor:_applyGrip()
    local localPlayer = self.Services.Players.LocalPlayer
    local char = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    local tool = char and char:FindFirstChildOfClass("Tool")

    if not (tool and backpack) then
        return DoNotif("You must be holding a tool to edit its grip.", 3)
    end
    
    -- Disconnect any previous connection to prevent stacking/leaks.
    if self.State.GripConnection then
        self.State.GripConnection:Disconnect()
        self.State.GripConnection = nil
    end

    -- Helper to safely get number values from textboxes
    local function getVal(name)
        return tonumber(self.State.UI.TextBoxes[name].Text) or 0
    end

    -- Construct the new CFrame from UI inputs
    local pos = Vector3.new(getVal("X"), getVal("Y"), getVal("Z"))
    local rot = Vector3.new(getVal("RX"), getVal("RY"), getVal("RZ"))
    local gripCFrame = CFrame.new(pos) * CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))

    -- Re-equip the tool to apply the new grip property
    tool.Parent = backpack
    task.wait()
    tool.Grip = gripCFrame
    tool.Parent = char

    -- This connection "fights" the game engine if it tries to reset the grip.
    self.State.GripConnection = tool.Changed:Connect(function(property)
        if property == "Grip" and tool.Grip ~= gripCFrame then
            tool.Grip = gripCFrame
        end
    end)

end


function Modules.GripEditor:CreateUI()
    if self.State.UI.ScreenGui then return end -- UI already exists

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GripEditorUI_Module"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = self.Services.CoreGui
    self.State.UI.ScreenGui = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 270)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Grip Position Editor"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = titleBar

    -- Create input boxes for Position and Rotation
    local labels = {"X", "Y", "Z", "RX", "RY", "RZ"}
    self.State.UI.TextBoxes = {}
    for i, label in ipairs(labels) do
        local xOffset = ((i - 1) % 3) * 100
        local yOffset = 40 + math.floor((i - 1) / 3) * 50

        local labelUI = Instance.new("TextLabel", frame)
        labelUI.Size = UDim2.fromOffset(40, 25)
        labelUI.Position = UDim2.fromOffset(10 + xOffset, yOffset)
        labelUI.BackgroundTransparency = 1
        labelUI.Text = label
        labelUI.TextColor3 = Color3.fromRGB(255, 255, 255)
        labelUI.Font = Enum.Font.Gotham
        labelUI.TextSize = 14

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.fromOffset(50, 25)
        box.Position = UDim2.fromOffset(50 + xOffset, yOffset)
        box.PlaceholderText = "0"
        box.Text = ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.ClearTextOnFocus = false
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        self.State.UI.TextBoxes[label] = box
    end
    
    -- Create control buttons
    local previewBtn = Instance.new("TextButton", frame)
    previewBtn.Size = UDim2.fromOffset(280, 28)
    previewBtn.Position = UDim2.fromOffset(20, 150)
    previewBtn.Text = "Preview Changes"
    previewBtn.Font = Enum.Font.GothamBold
    previewBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 95)
    previewBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", previewBtn).CornerRadius = UDim.new(0, 4)

    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.fromOffset(135, 32)
    applyBtn.Position = UDim2.fromOffset(20, 200)
    applyBtn.Text = "Apply & Close"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    applyBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.fromOffset(135, 32)
    closeBtn.Position = UDim2.fromOffset(165, 200)
    closeBtn.Text = "Close"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    -- Connect button events
    previewBtn.MouseButton1Click:Connect(function() self:_applyGrip() end)
    applyBtn.MouseButton1Click:Connect(function() self:_applyGrip(); self:DestroyUI() end)
    closeBtn.MouseButton1Click:Connect(function() self:DestroyUI() end)

    -- Make it draggable
    self:_makeDraggable(frame, titleBar)
    DoNotif("Grip Editor opened.", 2)
end

---
-- Destroys the user interface and cleans up state.
--
function Modules.GripEditor:DestroyUI()
    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui:Destroy()
    end
    if self.State.GripConnection then
        self.State.GripConnection:Disconnect()
    end
    self.State = { UI = {} } -- Reset the state table
    DoNotif("Grip Editor closed.", 2)
end


function Modules.GripEditor:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "grippos",
        Aliases = {"setgrip", "gripeditor"},
        Description = "Toggles a UI to manually edit your tool's grip CFrame."
    }, function()
        -- This command now acts as a toggle.
        if module.State.UI.ScreenGui then
            module:DestroyUI()
        else
            module:CreateUI()
        end
    end)
end

Modules.AnimationBuilder = {
    State = {
        UI = nil, 
        OriginalAnimations = nil 
    },
    Dependencies = {"Players", "CoreGui", "TweenService", "UserInputService"},
    Services = {}
}

function Modules.AnimationBuilder:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.AnimationBuilder:DestroyUI()
    if not self.State.UI then return end

    local mainFrame = self.State.UI.main
    local tween = self.Services.TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        Size = UDim2.fromScale(0.01, 0.01),
        Position = UDim2.new(0.99, 0, 0.01, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Wait()
    
    self.State.UI.screenGui:Destroy()
    self.State.UI = nil
    DoNotif("Animation Builder closed.", 2)
end

function Modules.AnimationBuilder:CreateUI()
    if self.State.UI then return end

    local localPlayer = self.Services.Players.LocalPlayer
    local char = localPlayer.Character
    local animateScript = char and char:FindFirstChild("Animate")

    if not animateScript then
        return DoNotif("Could not find 'Animate' script in character.", 4)
    end
    
    if not self.State.OriginalAnimations then
        self.State.OriginalAnimations = {}
        for _, valueObject in ipairs(animateScript:GetChildren()) do
            if valueObject:IsA("StringValue") then
                local anim = valueObject:FindFirstChildOfClass("Animation")
                if anim then
                    self.State.OriginalAnimations[valueObject.Name:lower()] = anim.AnimationId
                end
            end
        end
    end

    self.State.UI = {}
    local ui = self.State.UI

    ui.screenGui = Instance.new("ScreenGui")
    ui.screenGui.Name = "AnimationBuilder_Module"
    ui.screenGui.ResetOnSpawn = false
    ui.screenGui.Parent = self.Services.CoreGui
    
    ui.main = Instance.new("Frame", ui.screenGui)
    ui.main.Size = UDim2.new(0, 400, 0, 450)
    ui.main.Position = UDim2.fromScale(0.5, 0.5)
    ui.main.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.main.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    ui.main.BorderSizePixel = 0
    Instance.new("UICorner", ui.main).CornerRadius = UDim.new(0, 8)

    local header = Instance.new("Frame", ui.main)
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.fromOffset(15, 0)
    title.BackgroundTransparency = 1
    title.Text = "Animation Builder"
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.fromOffset(40, 40)
    closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20

    local scroll = Instance.new("ScrollingFrame", ui.main)
    scroll.Size = UDim2.new(1, 0, 1, -100)
    scroll.Position = UDim2.fromOffset(0, 40)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- [CRITICAL FIX] The incorrect UIPadding line has been replaced with the correct properties.
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingTop = UDim.new(0, 15)

    local footer = Instance.new("Frame", ui.main)
    footer.Size = UDim2.new(1, 0, 0, 60)
    footer.Position = UDim2.new(0, 0, 1, -60)
    footer.BackgroundTransparency = 1
    
    local saveBtn = Instance.new("TextButton", footer)
    saveBtn.Size = UDim2.new(0.5, -15, 0.7, 0)
    saveBtn.Position = UDim2.fromOffset(10, 10)
    saveBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 80)
    saveBtn.Text = "💾 Save"
    saveBtn.TextColor3 = Color3.new(1,1,1)
    saveBtn.Font = Enum.Font.GothamSemibold
    saveBtn.TextSize = 16
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

    local revertBtn = saveBtn:Clone()
    revertBtn.Position = UDim2.new(0.5, 5, 0, 10)
    revertBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
    revertBtn.Text = "↩️ Revert"
    revertBtn.Parent = footer
    
    ui.inputs = {}
    local states = {"Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Sit"}
    for _, name in ipairs(states) do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0.25, 0, 1, 0)
        label.Position = UDim2.fromOffset(10, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextSize = 15

        local box = Instance.new("TextBox", row)
        box.Size = UDim2.new(0.75, -20, 0.8, 0)
        box.Position = UDim2.new(0.25, 0, 0.5, 0)
        box.AnchorPoint = Vector2.new(0, 0.5)
        box.PlaceholderText = "rbxassetid://"
        box.ClearTextOnFocus = false
        box.TextColor3 = Color3.new(1,1,1)
        box.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        box.Font = Enum.Font.Code
        box.TextSize = 14
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        
        ui.inputs[name:lower()] = box
    end

    local function applyAnims(mode)
        local currentAnimate = localPlayer.Character and localPlayer.Character:FindFirstChild("Animate")
        if not currentAnimate then return DoNotif("Animate script not found.", 3) end

        for stateName, animId in pairs(mode == "save" and ui.inputs or self.State.OriginalAnimations) do
            local valueObj = currentAnimate:FindFirstChild(stateName, true)
            if valueObj then
                local anim = valueObj:FindFirstChildOfClass("Animation")
                if anim then
                    if mode == "save" then
                        local text = animId.Text 
                        if tonumber(text) then
                            anim.AnimationId = "rbxassetid://" .. text
                        end
                    else
                        anim.AnimationId = animId 
                        local num = animId:match("%d+")
                        if num and ui.inputs[stateName] then
                            ui.inputs[stateName].Text = num
                        end
                    end
                end
            end
        end
        DoNotif(mode == "save" and "Animations saved." or "Animations reverted.", 2)
    end
    
    for stateName, textBox in pairs(ui.inputs) do
        local originalId = self.State.OriginalAnimations[stateName]
        if originalId then
            local num = originalId:match("%d+")
            if num then textBox.Text = num end
        end
    end

    closeBtn.MouseButton1Click:Connect(function() self:DestroyUI() end)
    saveBtn.MouseButton1Click:Connect(function() applyAnims("save") end)
    revertBtn.MouseButton1Click:Connect(function() applyAnims("revert") end)
    
    self:_makeDraggable(ui.main, header)
    DoNotif("Animation Builder opened.", 2)
end

function Modules.AnimationBuilder:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "animbuilder",
        Aliases = {"abuilder"},
        Description = "Toggles a UI to edit your character's default animations."
    }, function()
        if module.State.UI then
            module:DestroyUI()
        else
            module:CreateUI()
        end
    end)
end

Modules.CharacterMorph = {
    State = {
        IsMorphed = false,
        OriginalDescription = nil,
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}


function Modules.CharacterMorph:_resolveDescription(target: string)
    local targetId = tonumber(target)
    
    -- If the target is not a valid number, assume it's a username and get the ID.
    if not targetId then
        local success, idFromName = pcall(function()
            return self.Services.Players:GetUserIdFromNameAsync(target)
        end)
        if not success or not idFromName then
            DoNotif("Could not find a user with the name: " .. tostring(target), 3)
            return nil
        end
        targetId = idFromName
    end
    
    -- Now, fetch the HumanoidDescription using the resolved UserId.
    DoNotif("Loading avatar for UserId: " .. targetId, 1.5)
    local success, description = pcall(function()
        return self.Services.Players:GetHumanoidDescriptionFromUserId(targetId)
    end)
    
    if not success or not description then
        DoNotif("Unable to load avatar description for that user.", 3)
        return nil
    end
    return description
end

--- [Internal] Applies a HumanoidDescription to the local player's character via respawn.
function Modules.CharacterMorph:_applyAndRespawn(description: HumanoidDescription)
    local localPlayer = self.Services.Players.LocalPlayer
    if not description then return end

    -- Disconnect any previous post-respawn event to prevent conflicts.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end


    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Once(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- Wrap in a pcall as ApplyDescription can sometimes fail with invalid assets.
            pcall(humanoid.ApplyDescription, humanoid, description)
        end
    end)
    
    -- Trigger the respawn.
    localPlayer:LoadCharacter()
end


function Modules.CharacterMorph:Morph(target: string)
    if not target then
        return DoNotif("Usage: ;avatar <username/userid>", 3)
    end

    -- Cache the player's original description if we haven't already.
    if not self.State.OriginalDescription then
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then
            self.State.OriginalDescription = originalDesc
        else
            warn("[CharacterMorph] Could not cache original character description.")
        end
    end

    -- Run the asynchronous parts in a new thread to not lag the game.
    task.spawn(function()
        local newDescription = self:_resolveDescription(target)
        if newDescription then
            self.State.IsMorphed = true
            self:_applyAndRespawn(newDescription)
            DoNotif("Applying character morph...", 2)
        end
    end)
end

--- Reverts the player's character to their original appearance.
function Modules.CharacterMorph:Revert()
    if not self.State.IsMorphed then
        return DoNotif("You are not currently morphed.", 2)
    end
    
    if not self.State.OriginalDescription then
        return DoNotif("Failed to revert: Original avatar description is missing.", 4)
    end
    
    self:_applyAndRespawn(self.State.OriginalDescription)
    self.State.IsMorphed = false
    DoNotif("Reverting to original character...", 2)
end

--- Initializes the module and registers its commands.
function Modules.CharacterMorph:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "swapinto",
        Aliases = {"change"},
        Description = "Change your character's appearance to someone else's."
    }, function(args)
        module:Morph(args[1])
    end)

    RegisterCommand({
        Name = "default",
        Aliases = {},
        Description = "Reverts your character's appearance to your own."
    }, function()
        module:Revert()
    end)
end

Modules.AvatarEditor = {
    State = {
        IsEnabled = false,
        UI = nil,
        Connections = {},
        OriginalAssets = {} -- Cache to revert local previews
    },

    Config = {
        -- [CRITICAL] This MUST be changed to the path of the game's avatar remote.
        -- Finding this requires a remote spy tool. If no such remote exists, replication is impossible.
        REMOTE_PATH = "ReplicatedStorage.Events.Avatar.ChangeAsset"
    },
    
    Services = {}
}

--// --- Private: Core Logic ---

--- [Internal] Applies asset changes locally for preview purposes. NOT visible to others.
function Modules.AvatarEditor:_applyLocally()
    local character = self.Services.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Clear previous accessories before applying new ones
    for _, accessory in ipairs(humanoid:GetAccessories()) do
        accessory:Destroy()
    end
    
    for assetType, textBox in pairs(self.State.UI.Inputs) do
        local assetId = tonumber(textBox.Text)
        if assetId and assetId > 0 then
            pcall(function()
                if assetType == "Shirt" then
                    local shirt = character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", character)
                    shirt.ShirtTemplate = "rbxassetid://" .. assetId
                elseif assetType == "Pants" then
                    local pants = character:FindFirstChildOfClass("Pants") or Instance.new("Pants", character)
                    pants.PantsTemplate = "rbxassetid://" .. assetId
                elseif assetType == "Face" then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local face = head:FindFirstChildOfClass("Decal")
                        if face then face.Texture = "rbxassetid://" .. assetId end
                    end
                else -- Assume it's an accessory
                    self.Services.InsertService:LoadAsset(assetId).Parent = character
                end
            end)
        end
    end
end

--- [Internal] Attempts to apply asset changes via a RemoteEvent. This IS visible to others if the game is vulnerable.
function Modules.AvatarEditor:_applyToServer()
    local remote = self:_findRemote()
    if not remote then
        return DoNotif("Replication failed: RemoteEvent not found at path: " .. self.Config.REMOTE_PATH, 5)
    end
    
    local itemsFired = 0
    for assetType, textBox in pairs(self.State.UI.Inputs) do
        local assetId = textBox.Text
        if #assetId > 0 then
            -- Fire the remote with the asset type and ID. The exact format
            -- may need to be adjusted based on how the target game's remote works.
            local success, err = pcall(function()
                remote:FireServer(assetType, tonumber(assetId) or assetId)
            end)

            if success then
                itemsFired = itemsFired + 1
            else
                warn("[AvatarEditor] Failed to fire remote for", assetType, ":", err)
            end
        end
    end
    
    if itemsFired > 0 then
        DoNotif("Fired " .. itemsFired .. " asset changes to the server. Re-joining or respawning may be required to see changes.", 4)
    else
        DoNotif("No valid asset IDs were entered to send to the server.", 3)
    end
end


--- [Internal] Finds the remote event based on the configured path.
function Modules.AvatarEditor:_findRemote()
    local current = game
    for component in string.gmatch(self.Config.REMOTE_PATH, "[^%.]+") do
        if not current then return nil end
        current = current:FindFirstChild(component, true)
    end
    return (current and current:IsA("RemoteEvent")) and current or nil
end

--// --- Private: UI Creation & Management ---

function Modules.AvatarEditor:_createUI()
    if self.State.UI then return end
    
    local ui = {}
    self.State.UI = ui
    ui.Inputs = {}

    ui.ScreenGui = Instance.new("ScreenGui")
    ui.ScreenGui.Name = "AvatarEditor_Module"
    ui.ScreenGui.ResetOnSpawn = false
    ui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(250, 380)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.Draggable = true
    mainFrame.Active = true
    mainFrame.Parent = ui.ScreenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
    
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    title.Text = "Replicating Avatar Editor"
    title.Font = Enum.Font.GothamSemibold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1, -10, 1, -80)
    scroll.Position = UDim2.fromOffset(5, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    
    -- Function to create a labeled text box for an asset type
    local function createInput(assetType)
        local row = Instance.new("TextLabel", scroll)
        row.Size = UDim2.new(1, 0, 0, 25)
        row.BackgroundTransparency = 1
        row.Font = Enum.Font.Gotham
        row.Text = assetType .. ":"
        row.TextColor3 = Color3.fromRGB(200, 200, 200)
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextSize = 15

        local textBox = Instance.new("TextBox", row)
        textBox.Size = UDim2.new(0.6, 0, 1, 0)
        textBox.Position = UDim2.new(0.4, 0, 0, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Font = Enum.Font.Code
        textBox.TextSize = 14
        textBox.ClearTextOnFocus = false
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
        ui.Inputs[assetType] = textBox
    end
    
    -- Create inputs for common asset types
    createInput("Shirt")
    createInput("Pants")
    createInput("Face")
    createInput("Hat1")
    createInput("Hat2")
    createInput("Waist")
    createInput("Shoulder")
    createInput("Hair")

    local applyButton = Instance.new("TextButton", mainFrame)
    applyButton.Size = UDim2.new(1, -10, 0, 30)
    applyButton.Position = UDim2.new(0.5, 0, 1, -10)
    applyButton.AnchorPoint = Vector2.new(0.5, 1)
    applyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    applyButton.Font = Enum.Font.GothamBold
    applyButton.Text = "Apply to Server (Replicates)"
    applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", applyButton).CornerRadius = UDim.new(0, 4)
    
    local previewButton = applyButton:Clone()
    previewButton.Position = UDim2.new(0.5, 0, 1, -45)
    previewButton.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    previewButton.Text = "Preview Locally (Client-Only)"
    previewButton.Parent = mainFrame
    
    applyButton.MouseButton1Click:Connect(function() self:_applyToServer() end)
    previewButton.MouseButton1Click:Connect(function() self:_applyLocally() end)

    ui.ScreenGui.Parent = CoreGui
end

--// --- Public: Control Methods ---

function Modules.AvatarEditor:Toggle()
    if self.State.IsEnabled then
        if self.State.UI and self.State.UI.ScreenGui then
            self.State.UI.ScreenGui:Destroy()
            self.State.UI = nil
        end
        self.State.IsEnabled = false
    else
        self:_createUI()
        self.State.IsEnabled = true
    end
end

function Modules.AvatarEditor:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.InsertService = game:GetService("InsertService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "avatareditor",
        Aliases = {"replicatedavatar", "ava"},
        Description = "Opens a UI to edit your avatar, with replication if the game is vulnerable."
    }, function()
        self:Toggle()
    end)
end

Modules.FixCamera = {
    State = {
        Enabled = false,
        Connection = nil,
        OriginalMaxZoom = nil,
        OriginalOcclusionMode = nil,
    }
}

RegisterCommand({
    Name = "fixcam",
    Aliases = {"fix", "unlockcam"},
    Description = "Unlocks camera, allows zooming through walls, and forces third-person."
}, function(args)
    if not LocalPlayer then return end
    
    local self = Modules.FixCamera -- Reference the module table
    self.State.Enabled = not self.State.Enabled
    
    if self.State.Enabled then
        self.State.OriginalMaxZoom = LocalPlayer.CameraMaxZoomDistance
        self.State.OriginalOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        LocalPlayer.CameraMaxZoomDistance = 10000
        
        local success, err = pcall(function()
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.None
        end)
        if not success then
            warn("FixCamera: Failed to set DevCameraOcclusionMode via Enum. Falling back to 0. Error:", err)
            LocalPlayer.DevCameraOcclusionMode = 0
        end
        
        self.State.Connection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end)
        DoNotif("Camera override enabled (with wall-zoom).", 3)
    else
        if self.State.Connection and self.State.Connection.Connected then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        
        pcall(function()
            if self.State.OriginalOcclusionMode ~= nil then
                LocalPlayer.DevCameraOcclusionMode = self.State.OriginalOcclusionMode
            end
            if self.State.OriginalMaxZoom ~= nil then
                LocalPlayer.CameraMaxZoomDistance = self.State.OriginalMaxZoom
            end
        end)
        
        self.State.OriginalOcclusionMode = nil
        self.State.OriginalMaxZoom = nil
        DoNotif("Camera override disabled.", 3)
    end
end)

RegisterCommand({
    Name = "night",
    Aliases = {"setnight", "nighttime"},
    Description = "Sets the time to night on your client."
}, function(args)
    -- Get the Lighting service robustly.
    local Lighting = game:GetService("Lighting")
    
    -- Parse the optional hour argument from the user's input.
    local targetTime = tonumber(args[1])
    
    -- If no valid time is given (or if it's out of the 0-24 range), default to 00:00 (Midnight).
    if not targetTime or targetTime < 0 or targetTime >= 24 then
        targetTime = 0 
    end
    
    -- Set the time. This is a purely local, visual change.
    Lighting.ClockTime = targetTime
    
    -- Notify the user of the successful change.
    DoNotif(string.format("Client time set to %02d:00", targetTime), 2)
end)

RegisterCommand({
    Name = "day",
    Aliases = {"setday", "daytime"},
    Description = "Sets the time to day on your client."
}, function(args)
    -- Get the Lighting service robustly.
    local Lighting = game:GetService("Lighting")
    
    -- Parse the optional hour argument from the user's input.
    local targetTime = tonumber(args[1])
    
    -- If no valid time is given (or if it's out of the 0-24 range), default to 14:00 (2 PM).
    if not targetTime or targetTime < 0 or targetTime >= 24 then
        targetTime = 14 
    end
    
    -- Set the time. This is a purely local, visual change.
    Lighting.ClockTime = targetTime
    
    -- Notify the user of the successful change.
    DoNotif(string.format("Client time set to %02d:00", targetTime), 2)
end)
local function loadstringCmd(url, notif)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    DoNotif(notif, 3)
end
RegisterCommand({Name = "teleporter", Aliases = {"tpui"}, Description = "Loads the Game Universe."}, function()
loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/UniverseFinder.lua", "Universe Initialized")
end)
RegisterCommand({Name = "wallwalk", Aliases = {"ww"}, Description = "Walk On Walls"}, function()
loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/WallWalk.lua", "Loaded!")
end)
RegisterCommand({Name = "dex", Aliases = {}, Description = "Loads Dex"}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/luaprojectse3/refs/heads/main/CustomDex.lua", "we lit")
end)
RegisterCommand({Name = "funbox", Aliases = {"fbox"}, Description = "Loads the Original Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/ZukasFunBox.lua", "Loading Zuka's FunBox...") end)

RegisterCommand({Name = "zukahub", Aliases = {"zuka"}, Description = "Loads the Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/ZukaHub.lua", "Loading Zuka's Hub...") end)

RegisterCommand({Name = "noacid", Aliases = {"antiskid"}, Description = "Stops lag from the acid feature in zgameupd3"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/AcidUpdated.lua", "Loading...") end)

RegisterCommand({Name = "stats", Aliases = {}, Description = "Edit and lock your properties."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/statlock.lua", "Loading Stats..") end)

RegisterCommand({Name = "zgui", Aliases = {"upd3", "zui"}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/ZfuckerUpgraded.lua", "Loaded GUI") end)

RegisterCommand({Name = "creepyanim", Aliases = {"canim"}, Description = "Uncanny Animation GUI"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/uncannyanim.lua", "Loaded GUI") end)

RegisterCommand({Name = "swordbot", Aliases = {"sf", "sfbot"}, Description = "Auto Sword Fighter, use E and R"}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/swordnpc", "Bot loaded.") end)

RegisterCommand({Name = "xvc", Aliases = {}, Description = "Loads the reliable XVC hub."}, function() loadstringCmd("https://luna.xvchubontop.workers.dev/", "XVC Hub") end)

RegisterCommand({Name = "zoneui", Aliases = {"masterequiper"}, Description = "For https://www.roblox.com/games/99381597249674/Zombie-Zone" }, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/Nice.lua", "Loaded") end)

RegisterCommand({Name = "ibtools", Aliases = {"btools"}, Description = "Upgraded Gui For Btools"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/fixedbtools.lua", "Loading Revamped Btools Gui") end)

RegisterCommand({Name = "ketamine", Aliases = {"kspy"}, Description = "Outdated"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/remotes.lua", "Loading rSpy...") end)

RegisterCommand({Name = "nocooldown", Aliases = {"ncd"}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/NocooldownsZombieUpd3.txt", "Loading Cooldownremover...") end)

RegisterCommand({Name = "scripts", Aliases = {}, Description = "May or may not work.."}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/scriptsearcher.lua", "Loading Scripts.") end)

RegisterCommand({Name = "antiafk", Aliases = {"npcmode"}, Description = "Avoid being kicked for being idle."}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/AutoPilotMode.lua", "Anti Afk loaded.") end)

RegisterCommand({Name = "scriptblox", Aliases = {}, Description = "Loads the scriptblox search."}, function() loadstringCmd("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher", "Loading API..") end)

RegisterCommand({Name = "flinger", Aliases = {"flingui"}, Description = "Loads a Fling GUI."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/SkidFling.lua", "Loading GUI..") end)

RegisterCommand({Name = "rem", Aliases = {}, Description = "In game exploit creation kit.."}, function() loadstringCmd("https://e-vil.com/anbu/rem.lua", "Loading Rem.") end)

RegisterCommand({Name = "copyconsole", Aliases = {"copy"}, Description = "Allows you to copy errors from the console.."}, function() loadstringCmd("https://raw.githubusercontent.com/scriptlisenbe-stack/luaprojectse3/refs/heads/main/consolecopy.lua", "Copy Console Activated.") end)

RegisterCommand({Name = "tptohp", Aliases = {}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/zgamemedkit.lua", "Loading HP Teleport") end)

function processCommand(message)
    if not (message:sub(1, #Prefix) == Prefix) then
        return false
    end
    local args = {}
    for word in message:sub(#Prefix + 1):gmatch("%S+") do
        table.insert(args, word)
    end
    if #args == 0 then
        return true
    end
    local cmdName = table.remove(args, 1):lower()
    local cmdFunc = Commands[cmdName]
    if cmdFunc then
        local success, err = pcall(cmdFunc, args)
        if not success then
            warn("Command Error:", err)
            DoNotif("Error: " .. tostring(err), 5)
        end
    else
    DoNotif("Unknown command: " .. cmdName, 3)
end
return true
end
for moduleName, module in pairs(Modules) do
    if type(module) == "table" and type(module.Initialize) == "function" then
        pcall(function()
        module:Initialize()
        print("Initialized module:", moduleName)
    end)
end
end


-- [Zuka's Addition: Mobile Command Bar Button]
local function CreateMobileCommandButton()
    -- 1. Pre-computation and Service Loading
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    -- 2. Environment Check: Only create the button for mobile users
    if not UserInputService.TouchEnabled then
        return
    end

    -- Failsafe: Check if the button already exists to prevent duplicates on script re-execution
    if CoreGui:FindFirstChild("MobileCommandButton_Zuka") then
        return
    end

    -- 3. UI Element Creation
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "MobileCommandButton_Zuka"
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.ResetOnSpawn = false
    buttonGui.Parent = CoreGui

    local cmdButton = Instance.new("ImageButton")
    cmdButton.Name = "DraggableCommandButton"
    cmdButton.Size = UDim2.fromOffset(60, 60) -- A comfortable tap size for mobile
    cmdButton.Position = UDim2.new(0, 20, 0.5, -30) -- Initial position: left side of the screen
    cmdButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    cmdButton.BackgroundTransparency = 0.2
    cmdButton.Image = "rbxassetid://7243158473" -- Using the gear icon from your splash screen
    cmdButton.ImageColor3 = Color3.fromRGB(0, 255, 255) -- Matching accent color
    cmdButton.Parent = buttonGui

    Instance.new("UICorner", cmdButton).CornerRadius = UDim.new(1, 0) -- Makes it circular
    Instance.new("UIStroke", cmdButton).Color = Color3.fromRGB(80, 80, 100)

    -- 4. Drag and Tap Logic
    local isDragging = false
    local dragStartPos = nil
    local startGuiPosition = nil
    local DRAG_THRESHOLD = 8 -- Minimum pixel distance to be considered a drag, preventing accidental drags on tap

    cmdButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = input.Position
            startGuiPosition = cmdButton.Position
            isDragging = false -- Reset state on new touch
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragStartPos then
            local delta = input.Position - dragStartPos
            
            -- If the finger moves past the threshold, it's officially a drag
            if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
                isDragging = true
            end

            if isDragging then
                cmdButton.Position = UDim2.new(startGuiPosition.X.Scale, startGuiPosition.X.Offset + delta.X, startGuiPosition.Y.Scale, startGuiPosition.Y.Offset + delta.Y)
            end
        end
    end)

    cmdButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = nil
            startGuiPosition = nil
        end
    end)

    cmdButton.Activated:Connect(function()
        -- The 'Activated' event fires on release. We only toggle the bar if it wasn't a drag.
        if not isDragging then
            if Modules.CommandBar and Modules.CommandBar.Toggle then
                Modules.CommandBar:Toggle()
            end
        end
        -- Reset dragging state after the action is complete
        isDragging = false
    end)
end

-- Execute the creation function
CreateMobileCommandButton()
Modules.CommandList:Initialize()
local TextChatService = game:GetService("TextChatService")
if TextChatService then
    TextChatService.SendingMessage:Connect(function(messageObject)
    local wasCommand = processCommand(messageObject.Text)
    if wasCommand then
        messageObject.ShouldSend = false
    end
end)
else
LocalPlayer.Chatted:Connect(processCommand)
end
DoNotif("hell yeah", 3)
