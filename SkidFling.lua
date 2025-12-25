local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function createFlingGui()
	if CoreGui:FindFirstChild("FlingGUI_Radiant") then
		CoreGui.FlingGUI_Radiant:Destroy()
	end

	local Player = Players.LocalPlayer
	local OldPos = nil
	local FPDH = workspace.FallenPartsDestroyHeight
	local isFlingingAll = false

	local function Message(_Title: string, _Text: string, Time: number)
		pcall(function()
			StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
		end)
	end

	local function SkidFling(TargetPlayer: Player)
		local Character: Model = Player.Character
		local Humanoid: Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart: BasePart = Humanoid and Humanoid.RootPart

		local TCharacter: Model = TargetPlayer.Character
		local THumanoid: Humanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
		local TRootPart: BasePart = THumanoid and THumanoid.RootPart
		local THead: BasePart = TCharacter and TCharacter:FindFirstChild("Head")
		
		if not (Character and Humanoid and RootPart and TCharacter and THumanoid and TRootPart) then
			return Message("Error Occurred", "Required character parts not found.", 5)
		end
		
		if RootPart.Velocity.Magnitude < 50 then
			OldPos = RootPart.CFrame
		end

		if THumanoid.Sit then
			return Message("Error Occurred", "Target is sitting.", 5)
		end

		workspace.CurrentCamera.CameraSubject = THead or TRootPart

		local function FPos(BasePart: BasePart, Pos: CFrame, Ang: CFrame)
			if RootPart and RootPart.Parent then
				RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
				RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
				RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			end
		end

		local function SFBasePart(BasePart: BasePart)
			local TimeToWait: number = 2
			local Time: number = tick()
			local Angle: number = 0

			repeat
				if RootPart and THumanoid and BasePart and BasePart.Parent then
					Angle = Angle + 100
					if BasePart.Velocity.Magnitude < 50 then
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or not BasePart.Parent or BasePart.Parent ~= TCharacter or not TargetPlayer.Parent or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end
		
		workspace.FallenPartsDestroyHeight = 0/0
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		
		if THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
			SFBasePart(THead)
		else
			SFBasePart(TRootPart)
		end
		
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		
		if OldPos then
			repeat
				pcall(function()
					RootPart.CFrame = OldPos * CFrame.new(0, 0.5, 0)
					Humanoid:ChangeState("GettingUp")
					for _, part: Instance in ipairs(Character:GetChildren()) do
						if part:IsA("BasePart") then
							part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
						end
					end
				end)
				task.wait()
			until not RootPart or (RootPart.Position - OldPos.p).Magnitude < 25
		end
		
		workspace.FallenPartsDestroyHeight = FPDH
	end

	local screenGui: ScreenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlingGUI_Radiant"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screenGui.Parent = CoreGui

	local mainFrame: Frame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 180)
	mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
	mainFrame.BackgroundColor3 = Color3.fromRGB(34, 32, 38)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	local corner: UICorner = Instance.new("UICorner", mainFrame)
	corner.CornerRadius = UDim.new(0, 8)

	local uiStroke: UIStroke = Instance.new("UIStroke", mainFrame)
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

	local titleLabel: TextLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.Text = "leet fling"
	titleLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
	titleLabel.TextSize = 20
	titleLabel.Parent = mainFrame
	
	titleLabel.InputBegan:Connect(function(input)
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

	local usernameBox: TextBox = Instance.new("TextBox")
	usernameBox.Name = "UsernameBox"
	usernameBox.Size = UDim2.new(1, -20, 0, 30)
	usernameBox.Position = UDim2.new(0, 10, 0, 50)
	usernameBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	usernameBox.Font = Enum.Font.Gotham
	usernameBox.PlaceholderText = "Username"
	usernameBox.Text = ""
	usernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	usernameBox.TextSize = 14
	usernameBox.ClearTextOnFocus = false
	usernameBox.Parent = mainFrame
	local boxCorner: UICorner = Instance.new("UICorner", usernameBox)
	boxCorner.CornerRadius = UDim.new(0, 6)
	local boxStroke = Instance.new("UIStroke", usernameBox)
	boxStroke.Color = Color3.fromRGB(80, 80, 100)

	local flingButton: TextButton = Instance.new("TextButton")
	flingButton.Name = "FlingButton"
	flingButton.Size = UDim2.new(1, -20, 0, 30)
	flingButton.Position = UDim2.new(0, 10, 0, 95)
	flingButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	flingButton.Font = Enum.Font.GothamSemibold
	flingButton.Text = "Fling Target"
	flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	flingButton.TextSize = 16
	flingButton.Parent = mainFrame
	local buttonCorner: UICorner = Instance.new("UICorner", flingButton)
	buttonCorner.CornerRadius = UDim.new(0, 6)

	local flingAllButton: TextButton = Instance.new("TextButton")
	flingAllButton.Name = "FlingAllButton"
	flingAllButton.Size = UDim2.new(1, -20, 0, 30)
	flingAllButton.Position = UDim2.new(0, 10, 0, 135)
	flingAllButton.BackgroundColor3 = Color3.fromRGB(200, 80, 150)
	flingAllButton.Font = Enum.Font.GothamSemibold
	flingAllButton.Text = "Fling All"
	flingAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	flingAllButton.TextSize = 16
	flingAllButton.Parent = mainFrame
	local allButtonCorner: UICorner = Instance.new("UICorner", flingAllButton)
	allButtonCorner.CornerRadius = UDim.new(0, 6)
	
	flingButton.MouseButton1Click:Connect(function()
		local inputText: string = usernameBox.Text:lower()
		
		if inputText == "" then
			return Message("Input Error", "Username box is empty.", 3)
		end

		local targetPlayer: Player = nil
		
		for _, player: Player in ipairs(Players:GetPlayers()) do
			if player ~= Player then
				if player.Name:lower():match("^"..inputText) or player.DisplayName:lower():match("^"..inputText) then
					targetPlayer = player
					break
				end
			end
		end

		if targetPlayer then
			if targetPlayer.UserId == 1414978355 then
				return Message("Error Occurred", "This user is whitelisted (Owner).", 5)
			end
			
			task.spawn(function()
				local success, err = pcall(function()
					SkidFling(targetPlayer)
				end)
				if not success then
					Message("Fling Error", "An unexpected error occurred: "..tostring(err), 5)
					pcall(function()
						Player.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true)
						workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChildOfClass("Humanoid")
						workspace.FallenPartsDestroyHeight = FPDH
					end)
				end
			end)
		else
			Message("Error Occurred", "Player '" .. usernameBox.Text .. "' not found.", 5)
		end
	end)

	flingAllButton.MouseButton1Click:Connect(function()
		isFlingingAll = not isFlingingAll

		if isFlingingAll then
			flingAllButton.Text = "Stop Flinging All"
			flingAllButton.BackgroundColor3 = Color3.fromRGB(150, 60, 120)
			
			task.spawn(function()
				for _, targetPlayer: Player in ipairs(Players:GetPlayers()) do
					if not isFlingingAll then break end
					
					if targetPlayer ~= Player and targetPlayer.UserId ~= 1414978355 then
						local success, err = pcall(function()
							Message("Flinging", "Now targeting: " .. targetPlayer.Name, 2)
							SkidFling(targetPlayer)
						end)
						if not success then
							Message("Fling Error", "Skipping " .. targetPlayer.Name .. ": "..tostring(err), 3)
							pcall(function()
								Player.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true)
								workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChildOfClass("Humanoid")
								workspace.FallenPartsDestroyHeight = FPDH
							end)
						end
						task.wait(1) 
					end
				end
				
				isFlingingAll = false
				flingAllButton.Text = "Fling All"
				flingAllButton.BackgroundColor3 = Color3.fromRGB(200, 80, 150)
				Message("Fling All", "Cycle finished.", 4)
			end)
		else
			flingAllButton.Text = "Fling All"
			flingAllButton.BackgroundColor3 = Color3.fromRGB(200, 80, 150)
			Message("Fling All", "Cycle stopped by user.", 4)
		end
	end)
	
	Message("Fling Utility", "GUI loaded successfully.", 5)
end

createFlingGui()
