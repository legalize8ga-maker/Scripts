local CONFIG = {
    TARGET_PART_NAMES = {"Acid", "Spit"},
    TARGET_SOUND_KEYWORDS = {"acid", "spit", "damage", "touched"},
}
local Workspace: Workspace = game:GetService("Workspace")
local RunService: RunService = game:GetService("RunService")
local CoreGui: CoreGui = game:GetService("CoreGui")
local State = {
    InterceptorConnection = nil,
    CollectorConnection = nil,
    IsImmunityActive = false
}
local partsToDestroy: {Instance} = {}
local function toggleAcidInterceptor(enabled: boolean)
    if State.InterceptorConnection then State.InterceptorConnection:Disconnect() end
    if State.CollectorConnection then State.CollectorConnection:Disconnect() end
    State.InterceptorConnection, State.CollectorConnection = nil, nil
    table.clear(partsToDestroy)
    if enabled then
        State.InterceptorConnection = Workspace.ChildAdded:Connect(function(child)
            if child:IsA("Sound") then
                local soundNameLower = child.Name:lower()
                for _, keyword in ipairs(CONFIG.TARGET_SOUND_KEYWORDS) do
                    if string.find(soundNameLower, keyword, 1, true) then
                        pcall(function()
                            child.Volume = 0
                            child.PlaybackSpeed = 0 
                        end)
                        break 
                    end
                end
            elseif child:IsA("BasePart") then
                for _, nameToBlock in ipairs(CONFIG.TARGET_PART_NAMES) do
                    if child.Name == nameToBlock then
                        table.insert(partsToDestroy, child)
                        break 
                    end
                end
            end
        end)
        State.CollectorConnection = RunService.Heartbeat:Connect(function()
            if #partsToDestroy > 0 then
                for _, part in ipairs(partsToDestroy) do
                    part:Destroy()
                end
                table.clear(partsToDestroy)
            end
        end)
    end
end
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "C_ImmunityShield_" .. math.random(1, 1000)
screenGui.ResetOnSpawn = false
local immunityToggle = Instance.new("TextButton")
immunityToggle.Name = "ImmunityToggleButton"
immunityToggle.Size = UDim2.new(0, 180, 0, 35)
immunityToggle.Position = UDim2.new(0, 20, 0, 20)
immunityToggle.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
immunityToggle.BorderColor3 = Color3.fromRGB(10, 10, 10)
immunityToggle.BorderSizePixel = 2
immunityToggle.Font = Enum.Font.SourceSansBold
immunityToggle.Text = "Acid Immunity: OFF"
immunityToggle.TextColor3 = Color3.fromRGB(225, 225, 225)
immunityToggle.TextSize = 16
immunityToggle.Parent = screenGui
immunityToggle.MouseButton1Click:Connect(function()
    State.IsImmunityActive = not State.IsImmunityActive
    toggleAcidInterceptor(State.IsImmunityActive)
    if State.IsImmunityActive then
        immunityToggle.BackgroundColor3 = Color3.fromRGB(40, 150, 90)
        immunityToggle.Text = "Acid Immunity: ON"
        print("Hybrid Immunity Shield: ACTIVATED")
    else
        immunityToggle.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        immunityToggle.Text = "Acid Immunity: OFF"
        print("Hybrid Immunity Shield: DEACTIVATED")
    end
end)
screenGui.Parent = CoreGui
screenGui.Destroying:Connect(function()
    if State.InterceptorConnection then State.InterceptorConnection:Disconnect() end
    if State.CollectorConnection then State.CollectorConnection:Disconnect() end
    print("Immunity Shield has been removed and all connections terminated.")
end)