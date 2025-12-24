local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local TOOL_TRANSPARENCY: number = 1.0
local COLLISION_ENABLED: boolean = false

--[=[
    Function to update the visual state of a Tool instance.
    We use LocalTransparencyModifier (LTM) as it is client-only.
]=]
local function updateToolVisibility(tool: Tool, transparency: number, canCollide: boolean)
    -- Ensure we only operate on valid Tool instances
    if not tool:IsA("Tool") then
        return
    end

    -- Iterate over all parts in the tool model
    for _, part in tool:GetDescendants() do
        if part:IsA("BasePart") then
            -- LTM is the key for local-only visibility change
            part.LocalTransparencyModifier = transparency
            part.CanCollide = canCollide
        elseif part:IsA("Decal") or part:IsA("Texture") then
            -- Optionally hide decals/textures to ensure full visual removal
            part.Transparency = transparency
        end
    end
end

--[=[
    Handles the event when a tool is equipped.
    It immediately hides the tool and sets up the cleanup routine for when it's unequipped.
]=]
local function handleToolEquipped(tool: Tool)
    -- Hide the tool upon equip
    updateToolVisibility(tool, TOOL_TRANSPARENCY, COLLISION_ENABLED)

    -- Connection to revert visibility when unequipped
    local unequippedConnection = tool.Unequipped:Connect(function()
        -- Revert the visibility (Transparency 0) when the tool leaves the hand
        updateToolVisibility(tool, 0, false)
        unequippedConnection:Disconnect()
    end)
end

--[=[
    Main logic to handle character loading and equipping events.
]=]
local function handleCharacterAdded(character: Model)
    -- Listen for any Tool instance being added to the character (which happens upon equip)
    character.ChildAdded:Connect(function(instance)
        if instance:IsA("Tool") then
            handleToolEquipped(instance)
        end
    end)

    -- Handle the case where the character spawns with a tool already equipped
    local equippedTool = character:FindFirstChildOfClass("Tool")
    if equippedTool then
        handleToolEquipped(equippedTool)
    end
end

-- Main Execution Thread
if localPlayer.Character then
    handleCharacterAdded(localPlayer.Character)
end

-- Connect the handler for future character spawns/resets
localPlayer.CharacterAdded:Connect(handleCharacterAdded)
