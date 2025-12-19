local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = true,
    Items = true,
    Client = true,
    Server = true
}

do 
    local tab = gui:CreateTab("Changelog")
    local btn : TextButton = tab:CreateButton("test").inst
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextScaled = false
    btn.TextYAlignment = Enum.TextYAlignment.Top
    btn.TextSize = 24
    btn.Text = [[
    + ESP
    + Spawn cookies (amount per second depends on server and ping)
    + Grab Charged_bat (must be in server)
    + Grab Fire katana 
    + Equip Shop weapons (must own weapon and be the correct team)
    ]]
end

for i, v in tabs do
    tabs[i] = gui:CreateTab(i)
end

local plrs : Players = cloneref(game:GetService("Players"))
local starGui : StarterGui = cloneref(game:GetService("StarterGui"))
local starPlr : StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local rStor : ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local runServ : RunService = cloneref(game:GetService("RunService"))
local networkCli : NetworkClient = cloneref(game:GetService("NetworkClient"))
local Teams : Teams = cloneref(game:GetService("Teams"))
local TeleportService : TeleportService = cloneref(game:GetService("TeleportService"))

local lplr = plrs.LocalPlayer
local char = lplr.Character
local Entities = workspace.Entities


function GetChar(lplr) -- ong we need a function for ts.
	local FindChar = lplr.Character or lplr.CharacterAdded:wait()
	return FindChar
end


function GetHumRootPart(char)
    local HumRootPart = char:FindFirstChild("HumanoidRootPart")
    return HumRootPart
end

local Equipables = { -- ah yes make another shit table for 5 fucking items will you
    "katana", "machete", "wooden_bat", "crowbar","hatchet"
}


local find = {
    Melee = "katana" or "machete" or "wooden_bat" or"charged_bat" or "flame_katana" or "crowbar" or "hatchet" or "Attack"
}

local Barriers = {
    --"Emitters",
    "VisualBarrier",
    "Collision",
    "Protection",
    "Collission and proteciton"
}

for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (lplr:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem) or nil)
    end
end


tabs.Items:CreateButton("Charged_bat", function()
    local oldCFrame = GetHumRootPart(lplr.Character).CFrame

    if workspace:FindFirstChild("charged_bat") then
        workspace.charged_bat.RightArm.Hitbox.ProximityPrompt.HoldDuration = 0.001
        GetHumRootPart(lplr.Character).CFrame = CFrame.new(workspace.charged_bat.RightArm.Handle.Position)
        wait(0.23)
        fireproximityprompt(workspace.charged_bat.RightArm.Hitbox.ProximityPrompt)
        wait(0.13)
        GetHumRootPart(lplr.Character).CFrame = oldCFrame
    else
        gui:Notify("Charged bat not in server")
    end
end)


tabs.Items:CreateButton("Flame katana", function()
    local oldCFrame = GetHumRootPart(lplr.Character).CFrame

    workspace.Scripted.Flame_Katana_Giver.Prompt.HoldDuration = 0.001
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(workspace.Scripted.Flame_Katana_Giver.Position)
    wait(0.23)
    fireproximityprompt(workspace.Scripted.Flame_Katana_Giver.Prompt)
    wait(0.13)
    GetHumRootPart(lplr.Character).CFrame = oldCFrame
end)

do
    local ShopRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop")
    for _,v in Equipables do
        tabs.Items:CreateButton("Equip ".. v, function()
            ShopRemote:InvokeServer("equip" ,v)
        end)
    end
end



tabs.Teams:CreateButton("Become Human", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateServerData"):InvokeServer("spawn_select", "human_main")
    lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)

tabs.Teams:CreateButton("Become Zombie", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateServerData"):InvokeServer("spawn_select", "zombie_main")
    lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)


do
    local function AddHighlight(plr)
        local res = plr.Character and plr.Character:FindFirstChildWhichIsA("Highlight")

        if not res then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = plr.Character
            highlight.Parent = plr.Character 
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = plr.TeamColor.Color
            highlight.OutlineColor = Color3.fromRGB(235,235,235)
            highlight.FillTransparency = .3

            return highlight
        end
    end

    local function RemoveHighlights(plr)
        local highlight = plr.Character and plr.Character:FindFirstChildWhichIsA("Highlight")

        if highlight then
            highlight:Destroy()
        end
    end

    local function ActuallyAddingHighlights(plr) 
        local ratlight

        if plr.CharacterAdded then
            ratlight = AddHighlight(plr)
        end

        if plr.CharacterRemoving then
            RemoveHighlights(plr)
        end

        if plrs.PlayerAdded then
            ratlight = AddHighlight(plr)
        end

        if plr.Character then
            ratlight = AddHighlight(plr)
        end

        plr:GetPropertyChangedSignal("TeamColor"):connect(function()
            if ratlight and ratlight.Parent then
                ratlight.FillColor = plr.TeamColor.Color
            end
        end)
    end

    local tgl
    tgl = tabs.Client:CreateToggle("ESP", function()
        if tgl.Enabled then
            repeat
                for _,v in plrs:GetPlayers() do 
                    if lplr ~= v then
                    ActuallyAddingHighlights(v)
                    end
                end
            task.wait(0.1)
            until not tgl.Enabled
            for _,v in plrs:GetPlayers() do
                RemoveHighlights(v)
            end
        end
    end)
end

do
    local tgl
    tgl = tabs.Client:CreateToggle("Infinite Stamina", function(c) -- https://www.youtube.com/watch?v=EVurkB9vZnI
        if c then
            repeat
                if GetChar(lplr):GetAttribute("MaxStamina") ~= tonumber("inf") then
                    GetChar(lplr):SetAttribute("MaxStamina", tonumber("inf"))
                end
                task.wait()
            until not tgl.Enabled 
            GetChar(lplr):SetAttribute("MaxStamina", 20)
        end
    end)
end

do
    local tgl
    tgl = tabs.Client:CreateToggle("OP Sprint", function(c)
        if c then
            repeat
                if GetChar(lplr):GetAttribute("SprintSpeed") ~= 50 then
                    GetChar(lplr):SetAttribute("SprintSpeed", 50)
                end
                task.wait()
            until not tgl.Enabled 
            GetChar(lplr):SetAttribute("SprintSpeed", 6)
        end
    end)
end

tabs.Client:CreateButton("Remove Team Barriers", function()
    for _,v in Barriers do
        if workspace:FindFirstChild(v, true) then
            repeat
                workspace:FindFirstChild(v, true):Destroy()
                task.wait(0.1)
            until not workspace:FindFirstChild(v, true)
        end
    end
end)



do
    local tgl
    local event = rStor.Tools.Remotes.MeleeDamage
    local CheckRemote = rStor.Tools.Remotes.AttackStart
    local eventC = 0
    tgl = tabs.Server:CreateToggle("Kill aura", function(c)
        if c then
            repeat
                if find.Melee(true) then
                    for _, v in Entities:GetChildren() do
                        if v:GetAttribute("Team") and v:GetAttribute("Team") ~= lplr.Character:GetAttribute("Team") then
                            local hum = v:FindFirstChildWhichIsA("Humanoid")
                            if hum and hum.Health > 0 and hum.RootPart and (hum.RootPart.Position - lplr.Character.Humanoid.RootPart.Position).Magnitude <= 20 then
                                if eventC < 100 then
                                    coroutine.wrap(function()
                                        eventC += 1
                                        event:FireServer(hum.RootPart)
                                        CheckRemote:FireServer(workspace:GetServerTimeNow(), workspace.DistributedGameTime)
                                        eventC -= 1
                                    end)()
                                end
                            end
                        end
                    end
                end
                task.wait()
            until not tgl.Enabled
        end
    end)
end

do 
    local tgl
    local clickdetector = workspace.Scripted.CookiesPlate.Part.ClickDetector -- idk why i made a variable for this tbh
    local cookieTbl = {} 
    

    function getcookies()
        for _, v in lplr.Backpack:GetChildren() do
            if v.ClassName == "Tool" and v.Name == "cookie" then
                table.insert(cookieTbl, v)
            end
        end
        for _, v in lplr.Character:GetChildren() do
            if v.ClassName == "Tool" and v.Name == "cookie" then
                table.insert(cookieTbl, v)
            end
        end
    end

    tgl = tabs.Server:CreateToggle("Spawn cookies", function()
        if tgl.Enabled then
            repeat
                getcookies()
                for i,v in cookieTbl do
                    v.Parent = char
                    v.Parent = workspace
                    table.remove(cookieTbl, i)
                end
                task.wait(0.01)
                fireclickdetector(clickdetector)
            until not tgl.Enabled
            table.clear(cookieTbl)
        end
    end)
end
