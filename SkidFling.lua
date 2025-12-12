local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")


local function createFlingGui()
	-- Destroy any existing GUI to prevent duplicates
	if CoreGui:FindFirstChild("FlingGUI_Integrated") then
		CoreGui.FlingGUI_Integrated:Destroy()
	end

	-- Local Player variables, defined inside the main scope
	local Player = Players.LocalPlayer
	local OldPos = nil -- Will store the player's position before flinging
	local FPDH = workspace.FallenPartsDestroyHeight -- Store original FallenPartsDestroyHeight


	local function Message(_Title, _Text, Time)
		-- Use a pcall for safety, as SetCore can sometimes fail.
		pcall(function()
			StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
		end)
	end

	local function SkidFling(TargetPlayer)
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart

		local TCharacter = TargetPlayer.Character
		local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
		local TRootPart = THumanoid and THumanoid.RootPart
		local THead = TCharacter and TCharacter:FindFirstChild("Head")
		
		-- Sanity checks
		if not (Character and Humanoid and RootPart and TCharacter and THumanoid and TRootPart) then
			return Message("Error Occurred", "Required character parts not found.", 5)
		end
		
		-- Store original position if not already moving fast
		if RootPart.Velocity.Magnitude < 50 then
			OldPos = RootPart.CFrame
		end

		if THumanoid.Sit then
			return Message("Error Occurred", "Target is sitting.", 5)
		end

		-- Set camera subject to target
		workspace.CurrentCamera.CameraSubject = THead or TRootPart

		-- The function that teleports the local player to induce a collision
		local function FPos(BasePart, Pos, Ang)
			if RootPart and RootPart.Parent then
				RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
				RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
				RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			end
		end

		-- The main loop that repeatedly calls FPos
		local function SFBasePart(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0

			repeat
				if RootPart and THumanoid and BasePart and BasePart.Parent then
					Angle = Angle + 100
					if BasePart.Velocity.Magnitude < 50 then
						-- More complex pattern for stationary targets
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						-- Simpler pattern for moving targets
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
		
		-- Modify workspace properties and player state
		workspace.FallenPartsDestroyHeight = 0/0 -- Effectively disables it
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		
		-- Prioritize flinging by Head if it's detached (common in R15), otherwise use RootPart
		if THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
			SFBasePart(THead)
		else
			SFBasePart(TRootPart)
		end
		
		-- Cleanup and reset the local player
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		
		if OldPos then
			repeat
				pcall(function()
					RootPart.CFrame = OldPos * CFrame.new(0, 0.5, 0)
					Humanoid:ChangeState("GettingUp")
					for _, part in ipairs(Character:GetChildren()) do
						if part:IsA("BasePart") then
							part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
						end
					end
				end)
				task.wait()
			until not RootPart or (RootPart.Position - OldPos.p).Magnitude < 25
		end
		
		workspace.FallenPartsDestroyHeight = FPDH -- Restore original value
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlingGUI_Integrated"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screenGui.Parent = CoreGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 120)
	mainFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
	mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner", mainFrame)
	corner.CornerRadius = UDim.new(0, 6)
	
	local topBar = Instance.new("Frame", mainFrame)
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 30)
	topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	local topCorner = Instance.new("UICorner", topBar)
	topCorner.CornerRadius = UDim.new(0, 6)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -10, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.Text = "Collision Fling"
	titleLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	local usernameBox = Instance.new("TextBox")
	usernameBox.Name = "UsernameBox"
	usernameBox.Size = UDim2.new(1, -20, 0, 30)
	usernameBox.Position = UDim2.new(0, 10, 0, 40)
	usernameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	usernameBox.BorderSizePixel = 0
	usernameBox.Font = Enum.Font.SourceSans
	usernameBox.PlaceholderText = "Username"
	usernameBox.Text = ""
	usernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	usernameBox.TextSize = 14
	usernameBox.ClearTextOnFocus = false
	usernameBox.Parent = mainFrame
	local boxCorner = Instance.new("UICorner", usernameBox)
	boxCorner.CornerRadius = UDim.new(0, 4)

	local flingButton = Instance.new("TextButton")
	flingButton.Name = "FlingButton"
	flingButton.Size = UDim2.new(1, -20, 0, 30)
	flingButton.Position = UDim2.new(0, 10, 0, 80)
	flingButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	flingButton.BorderSizePixel = 0
	flingButton.Font = Enum.Font.SourceSansBold
	flingButton.Text = "Fling"
	flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	flingButton.TextSize = 16
	flingButton.Parent = mainFrame
	local buttonCorner = Instance.new("UICorner", flingButton)
	buttonCorner.CornerRadius = UDim.new(0, 4)


	flingButton.MouseButton1Click:Connect(function()
		local inputText = usernameBox.Text:lower()
		
		if inputText == "" then
			return Message("Input Error", "Username box is empty.", 3)
		end

		local targetPlayer = nil
		
		-- Find player by partial match
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= Player then
				if player.Name:lower():match("^"..inputText) or player.DisplayName:lower():match("^"..inputText) then
					targetPlayer = player
					break
				end
			end
		end

		if targetPlayer then
			-- Check for the owner's whitelist from the original script
			if targetPlayer.UserId == 1414978355 then
				return Message("Error Occurred", "This user is whitelisted (Owner).", 5)
			end
			
			-- [CRITICAL] Spawn the function in a new thread to prevent the GUI from freezing.
			task.spawn(function()
				local success, err = pcall(function()
					SkidFling(targetPlayer)
				end)
				if not success then
					Message("Fling Error", "An unexpected error occurred: "..tostring(err), 5)
					-- Restore state on error
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
	
	Message("Made by AnthonyIsntHere, Skidded by zuka.", "GUI loaded successfully.", 5)
end

createFlingGui()
