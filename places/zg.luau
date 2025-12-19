local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = 1,
    Items = 2,
    Weapons = 3,
    Client = 4,
    Server = 5,
}
tabs = gui:Init({
    tabs = tabs,
    changelog = [[
    + Rewrote kill Zombies
    + ESP
    ]]
}).tabs

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


--[[function GetHumRootPart(char) -- not needed rn
	local HumRootPart = char:FindFirstChild("HumanoidRootPart")
	return HumRootPart
end]]



local find = {
    Weapons = "Hitbox" or "Handle" or "Damage",
    Sniper = "M24" or "Bolt"
}


local Teambarriers = {
    "ZombieSIGN",
    "ZombieDoor",
    "ZombieDoor2",
    "ZombieDoor3",
    "NoZombie"
}


for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (lplr:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem and FindingItem.Parent.Parent) or nil)
    end
end



tabs.Teams:CreateButton("Become Human", function()
    lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)

tabs.Teams:CreateButton("Become Zombie", function()
    game.TextChatService.TextChannels.RBXGeneral:SendAsync(";zombie")
end)


tabs.Items:CreateButton("Minigun Sniper", function()
    game:GetService("ReplicatedStorage").Remotes.Shop.EquipWeapon:InvokeServer("Sniper")
    
    local Sniper = lplr:FindFirstChild("Sniper", true) or char:FindFirstChild("Sniper", true)
    local scr = getsenv(Sniper.LocalScript)
    local shoot = debug.getupvalue(scr.FireGun, 5)
    local calc = debug.getupvalue(scr.FireGun, 6)
    local sound = Sniper.Handle["Sniper fire sound"]
    scr.FireGun = function(...)
        local sc = sound:Clone()
        sc.Playing = true
        sc.Parent = Sniper.Handle
        task.delay(sc.TimeLength, function()
            sc:Destroy() 
        end)
        shoot(Sniper.Flash2.Position, calc(...))
    end
    
    local mouse = lplr:GetMouse()
    local buttonDown = false
    mouse.Button1Down:Connect(function()
        if not buttonDown and Sniper.Parent == char then
            buttonDown = true
            repeat
                coroutine.wrap(scr.FireGun)(mouse.X, mouse.Y)
                -- res:FireGun(mouse.X, mouse.Y)
                task.wait()
            until not buttonDown
        end
    end)
    
    mouse.Button1Up:Connect(function()
        buttonDown = false
    end)
end)

tabs.Items:CreateButton("Give Antidote", function()
    fireclickdetector(workspace.Interaction.ToolGivers.Antidote.ClickDetector, 0)
end)

tabs.Items:CreateButton("Give Rainbow Potion", function()
    fireclickdetector(workspace.Interaction.ToolGivers["Rainbow Potion"].ClickDetector, 0)
end)

tabs.Items:CreateButton("Give all Signs", function() -- i will not touch this nor try to format it better
    if lplr.Team == Teams.Human then
        if not lplr:FindFirstChild("AntiZombieSign", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("AntiZombieSign2", true) and not char:FindFirstChild("AntiZombieSign2", true) and not lplr:FindFirstChild("AntiZombieSign3", true) and not char:FindFirstChild("AntiZombieSign3", true) then
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
        else
            gui:Notify("You already have every sign.")
        end
    else
        if not lplr:FindFirstChild("AntiZombieSign", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("AntiZombieSign2", true) and not char:FindFirstChild("AntiZombieSign2", true) and not lplr:FindFirstChild("AntiZombieSign3", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("ZombieSign", true) and not char:FindFirstChild("ZombieSign") and not lplr:FindFirstChild("ZombieSign2", true) and not char:FindFirstChild("ZombieSign2", true) then
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
        else
            gui:Notify("You already have every sign.")
        end
    end
end)



do
    local ShopRemote = game:GetService("ReplicatedStorage").Remotes.Shop.EquipWeapon
    for _,v in game:GetService("ReplicatedStorage").Assets.Weapons:GetChildren() do
        if v:IsA("Tool") then
            tabs.Weapons:CreateButton("Give ".. v.Name, function()
                ShopRemote:InvokeServer(v.Name)
            end)
        end
    end
end



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

tabs.Client:CreateButton("Remove Team Barriers", function()
    for _,v in Teambarriers do
        if workspace:FindFirstChild(v, true) then
            workspace:FindFirstChild(v, true):Destroy()
        end
    end
end)

local living = workspace.LivingThings

tabs.Client:CreateToggle("Unload Entites", function(c)
    lplr.Character.Parent = (c and workspace) or living
    if c then
        living.Parent = nil
    else
        living.Parent = workspace
    end
end)



networkCli:SetOutgoingKBPSLimit(tonumber("-inf")) -- experimental
local rastorThreads = 24
local lagServer = function(event, ...)
    for _ = 1, rastorThreads do
        coroutine.wrap(function(...)
            for _ = 1, (rastorThreads * 1000) do
                coroutine.wrap(event.FireServer)(event, ...)
            end
        end)(...)
    end
end

local AcidThreads = 4
local AcidlagServer = function(event, ...) -- Modify some values so acid lag server doesnt fucking crash roblox instantly, It still temp freezes but idgaf.
    for _ = 1, AcidThreads do
        coroutine.wrap(function(...)
            for _ = 1, (AcidThreads * 20) do
                coroutine.wrap(event.FireServer)(event, ...)
            end
        end)(...)
    end
end

local rejoin = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

tabs.Server:CreateToggle("Lag Server (Landmine Edition)", function(c)
    if c then
        workspace.Interaction.PlayerPlaced.Parent = nil
        lagServer(game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent, "PLACE_LANDMINE")
    else
        rejoin()
    end
end)

tabs.Server:CreateToggle("Lag Server (Necro Edition)", function(c)
    if c then
        lagServer(game:GetService("ReplicatedStorage").Remotes.ZombieRelated.Necro.AbilityPlayer)
    else
        rejoin()
    end
end)

tabs.Server:CreateToggle("Lag Server (Acid Edition)", function(c) -- not reliable for server lagging as it only lasts about 1-2 minutes, but it does rape the shit out of anyone with low end devices causing them to crash most of the time.
    if c then
        gui:Notify("This method Isn't too reliable for lagging the server, It can crash players games on low end phones and laptops though.")
        for coverX = -266, 378, 18 do 
        for coverZ = -268, 378, 18 do
            AcidlagServer(game:GetService("ReplicatedStorage").Remotes.ZombieRelated.AcidSpit, Vector3.new(coverX, 255, coverZ), Vector3.new(0,0,0))
        end
        end
    else
        rejoin()
    end
end)

tabs.Server:CreateToggle("Acid rain", function(c)
    if c then
        while true do
            task.wait(0.3)
            for coverX = -266, 378, 18 do 
            for coverZ = -268, 378, 18 do
            game:GetService("ReplicatedStorage").Remotes.ZombieRelated.AcidSpit:FireServer(Vector3.new(coverX, 255, coverZ), Vector3.new(0,0,0))
            end
            end
            end
    else
        rejoin()
    end
end)

tabs.Server:CreateButton("Summon Landmines", function()
    game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent:FireServer("PLACE_LANDMINE")
end)

tabs.Server:CreateButton("Summon Zombies", function()
    game:GetService("ReplicatedStorage").Remotes.ZombieRelated.Necro.AbilityPlayer:FireServer()
end)

tabs.Server:CreateButton("Summon Acid", function()
    local AcidRemote = game:GetService("ReplicatedStorage").Remotes.ZombieRelated.AcidSpit

    for coverX = -266, 378, 18 do
    for coverZ = -268, 378, 18 do
        AcidRemote:FireServer(
            Vector3.new(coverX, 255, coverZ),
            Vector3.new(0,0,0)
            )
        end
    end
end)

do
    local tgl
    local event = rStor.Remotes.ZombieRelated.PlayerAttack
    local eventC = 0
    local Attack = game:GetService("ReplicatedStorage").Attack:Clone()
    tgl = tabs.Server:CreateToggle("Annoy all", function(c)
        if not lplr:FindFirstChild("Attack", true) or char:FindFirstChild("Attack", true) then 
            Attack.Parent = lplr:WaitForChild("Backpack") 
        end

        if c then
            repeat
                if find.Weapon(true) then
                    for _, v in living:GetChildren() do
                        if lplr.Character ~= v then
                            local hum = v:FindFirstChildWhichIsA("Humanoid")
                            if hum and hum.Health > 0 and hum.RootPart then
                                if eventC < 100 then
                                    coroutine.wrap(function()
                                        eventC += 1
                                        event:InvokeServer(hum.RootPart)
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
    local event = rStor.Remotes.Melee.Damage
    local eventC = 0
    tgl = tabs.Server:CreateToggle("Kill aura", function(c)
        if c then
            repeat
                if lplr.Team == Teams.Zombie then
                    event = rStor.Remotes.ZombieRelated.PlayerAttack
                else
                    event = rStor.Remotes.Melee.Damage
                end
                if find.Weapon(true) then
                    for _, v in living:GetChildren() do
                        if v:GetAttribute("Team") and v:GetAttribute("Team") ~= lplr.Character:GetAttribute("Team") then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            local hum = v:FindFirstChildWhichIsA("Humanoid")
                            if hum and hum.Health > 0 and root and (root.Position - lplr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                                if eventC < 100 then
                                    coroutine.wrap(function()
                                        eventC += 1
                                        event:InvokeServer(root)
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
    local zombieTbl = {}

    function getzombies()
        for _,v in living:GetChildren() do
            if v and v:FindFirstChild("Humanoid") then 
                if v:GetAttribute("Team") ~= lplr.Team and v.Humanoid.Health > 0 then
                    table.insert(zombieTbl, v)
                end
            end
        end
    end

    local tgl
    local event = game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteEvent")

    tgl = tabs.Server:CreateToggle("Kill Zombies", function()
        if tgl.Enabled then
            repeat
                if lplr.Team == Teams.Human then
                    if find.Sniper(true) then
                        getzombies()

                        for i,v in zombieTbl do
                            if v and v:FindFirstChild("Humanoid") then
                                event:FireServer("GUN_DAMAGE", v)
                                table.remove(zombieTbl, i)
                            end
                        end
                    else
                        game:GetService("ReplicatedStorage").Remotes.Shop.EquipWeapon:InvokeServer("Sniper") 
                        find.Sniper(true)
                    end
                end
            task.wait(0.1)
            until not tgl.Enabled
            table.clear(zombieTbl)
        end
    end)
end
