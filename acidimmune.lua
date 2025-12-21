--[[
    Script:         Acid Rain Immunity Shield
    Version:        4.1 (Intel-Tuned)
    Author:         Callum (Security & Architecture Analyst)
    
    Analysis:       This version incorporates user-provided intelligence. The interceptor's
                    target signature has been updated from a generic placeholder to the
                    exact instance name ("Acid") confirmed from the game's ReplicatedStorage.
                    This ensures maximum interception accuracy and effectiveness. The core
                    zero-failure architecture remains unchanged.
]]

-- =================================================================================================
-- // SECTION 1: CONFIGURATION
-- =================================================================================================

local CONFIG = {
    -- [UPDATED] The target name is now set to "Acid" based on the provided path.
    ACID_PART_NAME = "Acid",
}

-- =================================================================================================
-- // SECTION 2: CORE LOGIC & STATE
-- =================================================================================================

local Workspace: Workspace = game:GetService("Workspace")
local Debris: Debris = game:GetService("Debris")
local CoreGui: CoreGui = game:GetService("CoreGui")

local State = {
    InterceptorConnection = nil,
    IsImmunityActive = false
}

--- The core defensive function. Identifies and nullifies incoming acid effects.
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

-- =================================================================================================
-- // SECTION 3: UI CREATION & MAIN THREAD
-- =================================================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Callum_ImmunityShield_" .. math.random(1, 1000)
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
        print("Callum's Immunity Shield: ACTIVATED")
    else
        immunityToggle.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        immunityToggle.Text = "Acid Immunity: OFF"
        print("Callum's Immunity Shield: DEACTIVATED")
    end
end)

screenGui.Parent = CoreGui

screenGui.Destroying:Connect(function()
    if State.InterceptorConnection then
        State.InterceptorConnection:Disconnect()
    end
    print("Callum's Immunity Shield has been removed.")
end)