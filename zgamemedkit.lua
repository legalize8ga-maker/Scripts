--[[
    @Author: Callum (Roblox Scripting Architect & Game Security Analyst)
    @Description: The definitive script for global, instant ProximityPrompt activation (v10).
                   This version is a multi-target controller that dynamically discovers and sets up
                   intercepts for ALL medkits, while also performing environmental sanitization.
    @Date: 12/15/2025
]]

print("[Callum's Log] Initiating Multi-Target Intercept Controller (v10).")

--//================================================================
--// Services & Core Variables
--//================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local teleportInProgress = false
local processedPrompts = {} -- A table to track prompts we've already set up

--//================================================================
--// Core Logic: Reusable Intercept Setup
--//================================================================
-- This function is now parameterized to work on ANY prompt we pass to it.
local function setupInterceptForPrompt(prompt)
    print("[Callum's Log] Setting up new intercept for:", prompt:GetFullName())

    prompt.MaxActivationDistance = 99999
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0

    prompt.Triggered:Connect(function()
        if teleportInProgress then return end

        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not (character and character.PrimaryPart and humanoid) then return end
        
        teleportInProgress = true
        print("[Callum's Log] Trigger detected! Executing event-driven teleport for:", prompt.Parent.Parent.Name)

        local originalCFrame = character.PrimaryPart.CFrame
        local originalHealth = humanoid.Health
        local targetPart = prompt.Parent
        
        local healthConnection
        local hasReturned = false

        task.delay(1.5, function() -- Increased failsafe to 1.5s for extra safety
            if not hasReturned then
                print("[Callum's Log] Failsafe timeout triggered. Returning to origin.")
                character:SetPrimaryPartCFrame(originalCFrame)
                if healthConnection then healthConnection:Disconnect() end
                teleportInProgress = false
            end
        end)

        healthConnection = humanoid.HealthChanged:Connect(function(newHealth)
            if newHealth > originalHealth and not hasReturned then
                hasReturned = true
                print("[Callum's Log] Health increase detected! Returning to origin.")
                character:SetPrimaryPartCFrame(originalCFrame)
                healthConnection:Disconnect()
                teleportInProgress = false
            end
        end)
        
        character:SetPrimaryPartCFrame(targetPart.CFrame * CFrame.new(0, 3, 0))
    end)
    print("[Callum's Log] Intercept is armed for:", prompt.Parent.Parent.Name)
end

--//================================================================
--// Main Execution Loop
--//================================================================
while true do
    -- Step 1: Environmental Sanitization
    pcall(function()
        local zombieDoor = Workspace.Interaction:FindFirstChild("ZombieDoor3")
        if zombieDoor then
            zombieDoor:Destroy()
            print("[Callum's Log] Threat neutralized: Removed 'ZombieDoor3'.")
        end
    end)

    -- Step 2: Discover and Process New Medkits
    pcall(function()
        local medkitsFolder = Workspace.Scripted:FindFirstChild("Medkits")
        if not medkitsFolder then return end

        for _, medkitModel in ipairs(medkitsFolder:GetChildren()) do
            local handle = medkitModel:FindFirstChild("Handle")
            if handle then
                local prompt = handle:FindFirstChild("ProximityPrompt")
                -- If we found a prompt AND we haven't processed it before...
                if prompt and not processedPrompts[prompt] then
                    processedPrompts[prompt] = true -- Mark it as processed immediately
                    setupInterceptForPrompt(prompt) -- ...then set up the intercept.
                end
            end
        end
    end)

    task.wait(3) -- Main loop checks every 3 seconds.
end
