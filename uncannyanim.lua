local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local currentAnim = "None"
local isActive = false
local connection = nil
local originalC0 = {}
local function storeOriginalC0(motors)
    for name, motor in pairs(motors) do
        if motor and not originalC0[name] then
            originalC0[name] = motor.C0
        end
    end
end
local function resetMotors(motors)
    for name, motor in pairs(motors) do
        if motor and originalC0[name] then
            motor.C0 = originalC0[name]
        end
    end
end
local function getMotors(character, isR15)
    local motors = {}
    if isR15 then
        local upperTorso = character:FindFirstChild("UpperTorso")
        if upperTorso then
            motors.Waist = upperTorso:FindFirstChild("Waist")
        end
        local head = character:FindFirstChild("Head")
        if head then
            motors.Neck = head:FindFirstChild("Neck")
        end
        local leftUpperArm = character:FindFirstChild("LeftUpperArm")
        if leftUpperArm then
            motors.LeftShoulder = leftUpperArm:FindFirstChild("LeftShoulder")
        end
        local rightUpperArm = character:FindFirstChild("RightUpperArm")
        if rightUpperArm then
            motors.RightShoulder = rightUpperArm:FindFirstChild("RightShoulder")
        end
        local leftUpperLeg = character:FindFirstChild("LeftUpperLeg")
        if leftUpperLeg then
            motors.LeftHip = leftUpperLeg:FindFirstChild("LeftHip")
        end
        local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
        if rightUpperLeg then
            motors.RightHip = rightUpperLeg:FindFirstChild("RightHip")
        end
    else
        local torso = character:FindFirstChild("Torso")
        if torso then
            motors.Neck = torso:FindFirstChild("Neck")
            motors.LeftShoulder = torso:FindFirstChild("Left Shoulder")
            motors.RightShoulder = torso:FindFirstChild("Right Shoulder")
            motors.LeftHip = torso:FindFirstChild("Left Hip")
            motors.RightHip = torso:FindFirstChild("Right Hip")
        end
    end
    storeOriginalC0(motors)
    return motors
end
local function applyAnimation(character, animType)
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local time = 0
    local motors = getMotors(character, isR15)
    if animType == "Twitchy" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            local glitch = math.random() > 0.85
            local snap = glitch and math.random(-30, 30) / 10 or 0
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * CFrame.Angles(
                    math.sin(time * 15) * 0.5 + snap,
                    math.cos(time * 12) * 0.4 + (glitch and math.random(-1, 1) or 0),
                    math.sin(time * 8) * 0.2
                )
            end
            if motors.LeftShoulder then
                local armSnap = glitch and math.pi / 4 or 0
                motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                    CFrame.Angles(math.floor(math.sin(time * 10) * 4) / 4 + armSnap, math.floor(math.cos(time * 7) * 3) / 3, -0.4)
            end
            if motors.RightShoulder then
                local armSnap = glitch and -math.pi / 4 or 0
                motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                    CFrame.Angles(math.floor(-math.sin(time * 10 + 1) * 4) / 4 + armSnap, -math.floor(math.cos(time * 7 + 1) * 3) / 3, 0.4)
            end
            if humanoid.MoveDirection.Magnitude > 0 then
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(math.sin(time * 8) * 0.7 + (glitch and 0.5 or 0), 0, -0.2)
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(-math.sin(time * 8) * 0.7 + (glitch and -0.5 or 0), 0, 0.2)
                end
            end
        end)
    elseif animType == "Broken" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * 
                    CFrame.Angles(math.pi / 3, math.sin(time * 1.5) * 1.2, math.pi / 4)
            end
            if motors.LeftShoulder then
                motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                    CFrame.Angles(math.pi / 2, 0, -math.pi / 2) * CFrame.Angles(0, 0, math.sin(time * 3) * 0.3)
            end
            if motors.RightShoulder then
                motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                    CFrame.Angles(math.pi / 6, 0, math.pi / 3) * CFrame.new(0, math.sin(time * 2) * 0.1, 0)
            end
            if motors.LeftHip then
                motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * CFrame.Angles(0.2, 0, -0.5)
            end
            if motors.RightHip then
                motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * CFrame.Angles(-0.1, 0, 0.3)
            end
            if motors.Waist and isR15 then
                motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(0.3, 0, 0.4)
            end
        end)
    elseif animType == "Spider" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                local lookDir = math.floor(time * 3) % 8
                local angles = {{-0.5, -1}, {-0.3, 0}, {-0.5, 1}, {0, 1.2}, {0.5, 1}, {0.3, 0}, {0.5, -1}, {0, -1.2}}
                local ang = angles[lookDir + 1]
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * CFrame.Angles(ang[1], ang[2], 0)
            end
            if humanoid.MoveDirection.Magnitude > 0 then
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(-math.pi / 3 + math.sin(time * 10) * 0.8, 0, -0.6 + math.cos(time * 10) * 0.4)
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(-math.pi / 3 + math.sin(time * 10 + math.pi) * 0.8, 0, 0.6 + math.cos(time * 10 + math.pi) * 0.4)
                end
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(math.sin(time * 15) * 0.6, 0, -0.3 + math.cos(time * 15) * 0.2)
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(-math.sin(time * 15) * 0.6, 0, 0.3 + math.cos(time * 15 + math.pi) * 0.2)
                end
            else
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(math.pi / 4, 0, -0.5) * CFrame.Angles(math.sin(time * 20) * 0.2, 0, 0)
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(math.pi / 4, 0, 0.5) * CFrame.Angles(math.sin(time * 20 + 1) * 0.2, 0, 0)
                end
            end
        end)
    elseif animType == "Possessed" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                local convulse = {math.sin(time * 25) * 1.5, math.cos(time * 30) * 1.5, math.sin(time * 28) * 1.2}
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * CFrame.Angles(convulse[1], convulse[2], convulse[3])
            end
            if motors.LeftShoulder then
                motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                    CFrame.Angles(math.sin(time * 18) * 2.5, math.cos(time * 22) * 1, math.sin(time * 16) * 1.5)
            end
            if motors.RightShoulder then
                motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                    CFrame.Angles(math.cos(time * 20) * 2.5, -math.sin(time * 19) * 1, math.cos(time * 17) * 1.5)
            end
            if motors.LeftHip then
                motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                    CFrame.Angles(math.sin(time * 25) * 0.8, math.cos(time * 20) * 0.4, math.sin(time * 22) * 0.5)
            end
            if motors.RightHip then
                motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                    CFrame.Angles(-math.sin(time * 23) * 0.8, math.cos(time * 21) * 0.4, -math.sin(time * 24) * 0.5)
            end
            if motors.Waist and isR15 then
                motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(math.sin(time * 26) * 0.5, math.cos(time * 24) * 0.5, math.sin(time * 27) * 0.4)
            end
        end)
    elseif animType == "Stalker" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * CFrame.Angles(-0.3, math.sin(time * 0.5) * 0.1, 0)
            end
            if humanoid.MoveDirection.Magnitude > 0 then
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(math.pi / 6, 0, -0.1 + math.sin(time * 2) * 0.05)
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(math.pi / 6, 0, 0.1 + math.sin(time * 2 + 1) * 0.05)
                end
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(math.sin(time * 1.5) * 0.3, 0, -0.05)
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(-math.sin(time * 1.5) * 0.3, 0, 0.05)
                end
            else
                if motors.Waist and isR15 then
                    motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(math.sin(time * 1) * 0.02, 0, 0)
                end
            end
        end)
    elseif animType == "Contortionist" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * 
                    CFrame.Angles(math.sin(time * 0.8) * 0.5, time * 0.5, 0)
            end
            if motors.LeftShoulder then
                motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                    CFrame.Angles(math.sin(time * 2) * math.pi, math.cos(time * 1.5) * 0.8, -math.pi / 2 + math.sin(time * 3) * 0.5)
            end
            if motors.RightShoulder then
                motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                    CFrame.Angles(math.cos(time * 2.2) * math.pi, -math.sin(time * 1.7) * 0.8, math.pi / 2 + math.cos(time * 2.8) * 0.5)
            end
            if motors.LeftHip then
                motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                    CFrame.Angles(math.cos(time * 2) * 0.6, math.sin(time * 1.8) * 0.5, -0.3 + math.sin(time * 2.5) * 0.4)
            end
            if motors.RightHip then
                motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                    CFrame.Angles(-math.cos(time * 2.1) * 0.6, -math.sin(time * 1.9) * 0.5, 0.3 + math.cos(time * 2.4) * 0.4)
            end
            if motors.Waist and isR15 then
                motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(math.sin(time * 1.2) * 0.4, math.cos(time * 1.5) * 0.8, math.sin(time * 1.8) * 0.3)
            end
        end)
    elseif animType == "Jittery" then
        connection = RunService.Heartbeat:Connect(function()
            local jit = function() return (math.random() - 0.5) * 0.3 end
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * CFrame.Angles(jit(), jit(), jit())
            end
            if motors.LeftShoulder then
                motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * CFrame.Angles(jit() * 2, jit(), -0.2 + jit())
            end
            if motors.RightShoulder then
                motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * CFrame.Angles(jit() * 2, -jit(), 0.2 + jit())
            end
            if motors.LeftHip then
                motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * CFrame.Angles(jit(), jit() * 0.5, jit())
            end
            if motors.RightHip then
                motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * CFrame.Angles(jit(), jit() * 0.5, jit())
            end
            if motors.Waist and isR15 then
                motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(jit() * 0.5, jit() * 0.5, jit() * 0.5)
            end
        end)
    elseif animType == "SCP-096" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if humanoid.MoveDirection.Magnitude > 0 then
                if motors.Neck then
                    motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * 
                        CFrame.Angles(
                            -0.3 + math.sin(time * 35) * 0.15, 
                            math.sin(time * 40) * 0.1, 
                            0
                        )
                end
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 2.5 + math.sin(time * 8) * 0.3, 
                            0,
                            -0.4 + math.cos(time * 8) * 0.2
                        )
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 2.5 + math.sin(time * 8 + 1) * 0.3,
                            0,
                            0.4 + math.cos(time * 8 + 1) * 0.2
                        )
                end
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(math.sin(time * 14) * 1.0, 0, -0.15)
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(-math.sin(time * 14) * 1.0, 0, 0.15)
                end
                if motors.Waist and isR15 then
                    motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(
                        0.3 + math.sin(time * 35) * 0.05, 
                        0,
                        0
                    )
                end
            else
                if motors.Neck then
                    motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * 
                        CFrame.Angles(
                            1.4 + math.sin(time * 4) * 0.15, 
                            math.sin(time * 3) * 0.1, 
                            0
                        )
                end
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(
                            -2.0, 
                            0,
                            -1.2 + math.sin(time * 5) * 0.15 
                        )
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(
                            -2.0,
                            0,
                            1.2 + math.sin(time * 5 + 1.5) * 0.15
                        )
                end
                if motors.LeftHip then
                    if isR15 then
                        motors.LeftHip.C0 = CFrame.new(0, -0.5, 0) * 
                            CFrame.Angles(
                                1.5, 
                                -0.2,
                                -0.3
                            )
                    else
                        motors.LeftHip.C0 = CFrame.new(-1, -1, 0) * 
                            CFrame.Angles(
                                1.2, 
                                0,
                                -0.5
                            )
                    end
                end
                if motors.RightHip then
                    if isR15 then
                        motors.RightHip.C0 = CFrame.new(0, -0.5, 0) * 
                            CFrame.Angles(
                                1.5, 
                                0.2,
                                0.3
                            )
                    else
                        motors.RightHip.C0 = CFrame.new(1, -1, 0) * 
                            CFrame.Angles(
                                1.2, 
                                0,
                                0.5
                            )
                    end
                end
                if motors.Waist and isR15 then
                    motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(
                        1.0 + math.sin(time * 4) * 0.1, 
                        0,
                        math.sin(time * 3) * 0.05
                    )
                end
            end
        end)
        humanoid.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
                spawn(function()
                    local jumpTime = 0
                    local jumpConnection
                    jumpConnection = RunService.Heartbeat:Connect(function(dt)
                        jumpTime = jumpTime + dt
                        if motors.LeftShoulder then
                            motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                                CFrame.Angles(-math.pi + math.sin(jumpTime * 20) * 0.3, 0, -0.3)
                        end
                        if motors.RightShoulder then
                            motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                                CFrame.Angles(-math.pi + math.sin(jumpTime * 20) * 0.3, 0, 0.3)
                        end
                        if humanoid:GetState() == Enum.HumanoidStateType.Landed then
                            jumpConnection:Disconnect()
                        end
                    end)
                end)
            end
        end)
    elseif animType == "Crawler" then
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            if motors.Neck then
                motors.Neck.C0 = (isR15 and CFrame.new(0, 0.8, 0) or CFrame.new(0, 1, 0)) * 
                    CFrame.Angles(
                        -0.8 + math.sin(time * 4) * 0.2, 
                        math.cos(time * 3) * 0.3, 
                        0
                    )
            end
            if humanoid.MoveDirection.Magnitude > 0 then
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 2 + math.sin(time * 8) * 0.7, 
                            0,
                            -0.7 + math.cos(time * 8) * 0.3
                        )
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 2 + math.sin(time * 8 + math.pi) * 0.7,
                            0,
                            0.7 + math.cos(time * 8 + math.pi) * 0.3
                        )
                end
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(
                            -0.3 + math.sin(time * 8) * 0.5, 
                            0,
                            -0.4
                        )
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(
                            -0.3 + math.sin(time * 8 + math.pi) * 0.5,
                            0,
                            0.4
                        )
                end
            else
                if motors.LeftShoulder then
                    motors.LeftShoulder.C0 = (isR15 and CFrame.new(-1, 0.5, 0) or CFrame.new(-1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 3, 
                            0,
                            -0.5 + math.sin(time * 2) * 0.1
                        )
                end
                if motors.RightShoulder then
                    motors.RightShoulder.C0 = (isR15 and CFrame.new(1, 0.5, 0) or CFrame.new(1, 0.5, 0)) * 
                        CFrame.Angles(
                            -math.pi / 3,
                            0,
                            0.5 + math.sin(time * 2 + 1) * 0.1
                        )
                end
                if motors.LeftHip then
                    motors.LeftHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(-1, -1, 0)) * 
                        CFrame.Angles(-0.4, 0, -0.3)
                end
                if motors.RightHip then
                    motors.RightHip.C0 = (isR15 and CFrame.new(0, -0.5, 0) or CFrame.new(1, -1, 0)) * 
                        CFrame.Angles(-0.4, 0, 0.3)
                end
            end
            if motors.Waist and isR15 then
                motors.Waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(
                    0.7, 
                    math.sin(time * 2) * 0.1,
                    0
                )
            end
        end)
    elseif animType == "Glitchy" then
        local lastGlitch = 0
        local glitchCooldown = math.random(10, 20) / 10
        local originals = {}
        for name, motor in pairs(motors) do
            if motor then
                originals[name] = motor.C0
            end
        end
        connection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt
            lastGlitch = lastGlitch + dt
            if lastGlitch >= glitchCooldown then
                lastGlitch = 0
                glitchCooldown = math.random(10, 20) / 10
                spawn(function()
                    for i = 1, 3 do 
                        local gX = (math.random() - 0.5) * 2
                        local gY = (math.random() - 0.5) * 2
                        local gZ = (math.random() - 0.5) * 2
                        if motors.Neck then
                            motors.Neck.C0 = originals.Neck * CFrame.Angles(gX, gY, gZ)
                        end
                        if motors.LeftShoulder then
                            motors.LeftShoulder.C0 = originals.LeftShoulder * CFrame.Angles(gX, gY, gZ)
                        end
                        if motors.RightShoulder then
                            motors.RightShoulder.C0 = originals.RightShoulder * CFrame.Angles(-gX, -gY, gZ)
                        end
                        if motors.LeftHip then
                            motors.LeftHip.C0 = originals.LeftHip * CFrame.Angles(gX * 0.3, gY * 0.3, gZ * 0.3)
                        end
                        if motors.RightHip then
                            motors.RightHip.C0 = originals.RightHip * CFrame.Angles(-gX * 0.3, -gY * 0.3, -gZ * 0.3)
                        end
                        if motors.Waist and isR15 then
                            motors.Waist.C0 = originals.Waist * CFrame.Angles(gX * 0.2, gY * 0.2, gZ * 0.2)
                        end
                        wait(0.03)
                    end
                    for name, motor in pairs(motors) do
                        if motor and originals[name] then
                            motor.C0 = originals[name]
                        end
                    end
                end)
            end
        end)
    end
end
local function stopAnimation(character)
    if connection then
        connection:Disconnect()
        connection = nil
    end
    local isR15 = character:FindFirstChild("Humanoid") and character.Humanoid.RigType == Enum.HumanoidRigType.R15
    local motors = getMotors(character, isR15)
    resetMotors(motors)
end
local function createGUI()
    if player.PlayerGui:FindFirstChild("CreepyAnimGUI") then
        player.PlayerGui.CreepyAnimGUI:Destroy()
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CreepyAnimGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 260, 0, 490)
    mainFrame.Position = UDim2.new(1, -280, 0.5, -245)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    title.BorderSizePixel = 0
    title.Font = Enum.Font.GothamBold
    title.Text = "🕷️ Creepy Animations"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -42, 0, 2)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Parent = mainFrame
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeButton
    local isMinimized = false
    closeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 260, 0, 490), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            container.Visible = true
            closeButton.Text = "X"
            isMinimized = false
        else
            if player.Character then
                stopAnimation(player.Character)
            end
            isActive = false
            currentAnim = "None"
            screenGui:Destroy()
            print("Creepy animations stopped and GUI closed")
        end
    end)
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 40, 0, 40)
    minimizeButton.Position = UDim2.new(1, -87, 0, 2)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 20
    minimizeButton.Parent = mainFrame
    local minBtnCorner = Instance.new("UICorner")
    minBtnCorner.CornerRadius = UDim.new(0, 8)
    minBtnCorner.Parent = minimizeButton
    minimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 260, 0, 490), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            container.Visible = true
            minimizeButton.Text = "_"
            isMinimized = false
        else
            mainFrame:TweenSize(UDim2.new(0, 260, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            container.Visible = false
            minimizeButton.Text = "+"
            isMinimized = true
        end
    end)
    minimizeButton.MouseEnter:Connect(function()
        minimizeButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end)
    minimizeButton.MouseLeave:Connect(function()
        minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -20, 1, -65)
    container.Position = UDim2.new(0, 10, 0, 55)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 6
    container.CanvasSize = UDim2.new(0, 0, 0, 510)
    container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    container.Parent = mainFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    local animations = {"Twitchy", "Broken", "Spider", "Possessed", "Stalker", "Contortionist", "Jittery", "SCP-096", "Crawler", "Glitchy"}
    for _, animName in ipairs(animations) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 42)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.BorderSizePixel = 0
        button.Font = Enum.Font.GothamSemibold
        button.Text = animName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 15
        button.Parent = container
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        button.MouseButton1Click:Connect(function()
            if currentAnim == animName and isActive then
                stopAnimation(player.Character)
                isActive = false
                currentAnim = "None"
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            else
                if player.Character then
                    stopAnimation(player.Character)
                end
                currentAnim = animName
                isActive = true
                for _, btn in ipairs(container:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    end
                end
                button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
                if player.Character then
                    applyAnimation(player.Character, animName)
                end
            end
        end)
        button.MouseEnter:Connect(function()
            if currentAnim ~= animName or not isActive then
                button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            end
        end)
        button.MouseLeave:Connect(function()
            if currentAnim ~= animName or not isActive then
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            elseif isActive and currentAnim == animName then
                button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            end
        end)
    end
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end
player.CharacterAdded:Connect(function(character)
    wait(1)
    if isActive and currentAnim ~= "None" then
        applyAnimation(character, currentAnim)
    end
end)
createGUI()
print("we lit")
