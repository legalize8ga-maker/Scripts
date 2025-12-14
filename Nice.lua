--[[
all items with varients/level table. by zuka
MODIFIED BY CALLUM - V43.0 - Resilient Data-Finder Update
This version dynamically locates the item database to withstand game updates.
--]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LOCAL_PLAYER = Players.LocalPlayer
local queuedWeaponConfig = nil
local weaponKeybinds = {}
local isSettingKeybind = false
local masterWeaponMap, perkDatabase, variantDatabase, isInitialized = {}, {}, {}, false
local selectedWeapon, perkControls = nil, {}

-- GUI Instances
local screenGui = Instance.new("ScreenGui");
screenGui.Name = "MasterEquipperGUI_V43_0";
screenGui.ResetOnSpawn = false;
screenGui.Parent = LOCAL_PLAYER:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame");
mainFrame.Size = UDim2.new(0, 700, 0, 500);
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250);
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80);
mainFrame.Active = true;
mainFrame.Draggable = true;
mainFrame.Visible = false;
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel", mainFrame);
titleLabel.Size = UDim2.new(1, 0, 0, 30);
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
titleLabel.Text = "Master Equipper V43.0 (Resilient Data-Finder)";
titleLabel.Font = Enum.Font.SourceSansBold;
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
titleLabel.TextSize = 18

-- Left Panel (Weapons)
local weaponPanel = Instance.new("Frame", mainFrame);
weaponPanel.Size = UDim2.new(0, 250, 1, -30);
weaponPanel.Position = UDim2.new(0, 0, 0, 30);
weaponPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
weaponPanel.BorderSizePixel = 0

local searchBox = Instance.new("TextBox", weaponPanel);
searchBox.Size = UDim2.new(1, -10, 0, 30);
searchBox.Position = UDim2.new(0, 5, 0, 5);
searchBox.PlaceholderText = "Search Weapons...";
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
searchBox.TextColor3 = Color3.fromRGB(220, 220, 220)

local weaponList = Instance.new("ScrollingFrame", weaponPanel);
weaponList.Size = UDim2.new(1, 0, 1, -40);
weaponList.Position = UDim2.new(0, 0, 0, 40);
weaponList.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
weaponList.ScrollBarThickness = 6

local weaponListLayout = Instance.new("UIListLayout", weaponList);
weaponListLayout.Padding = UDim.new(0, 2);
weaponListLayout.SortOrder = Enum.SortOrder.Name

-- Right Panel (Configuration)
local configPanel = Instance.new("Frame", mainFrame);
configPanel.Size = UDim2.new(1, -260, 1, -40);
configPanel.Position = UDim2.new(0, 260, 0, 35);
configPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
configPanel.BorderSizePixel = 0

local selectedWeaponLabel = Instance.new("TextLabel", configPanel);
selectedWeaponLabel.Size = UDim2.new(1, -10, 0, 30);
selectedWeaponLabel.Position = UDim2.new(0, 5, 0, 5);
selectedWeaponLabel.Font = Enum.Font.SourceSansBold;
selectedWeaponLabel.Text = "Selected: None";
selectedWeaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
selectedWeaponLabel.TextSize = 18;
selectedWeaponLabel.TextXAlignment = Enum.TextXAlignment.Left

local rarityLabel = Instance.new("TextLabel", configPanel);
rarityLabel.Size = UDim2.new(0.5, -10, 0, 20);
rarityLabel.Position = UDim2.new(0, 5, 0, 40);
rarityLabel.Text = "Rarity:";
rarityLabel.TextColor3 = Color3.fromRGB(200,200,200);
rarityLabel.BackgroundTransparency=1;
rarityLabel.TextXAlignment = Enum.TextXAlignment.Left

local levelLabel = Instance.new("TextLabel", configPanel);
levelLabel.Size = UDim2.new(0.5, -10, 0, 20);
levelLabel.Position = UDim2.new(0.5, 5, 0, 40);
levelLabel.Text = "Level:";
levelLabel.TextColor3 = Color3.fromRGB(200,200,200);
levelLabel.BackgroundTransparency=1;
levelLabel.TextXAlignment = Enum.TextXAlignment.Left

local levelInput = Instance.new("TextBox", configPanel);
levelInput.Size = UDim2.new(0.5, -10, 0, 30);
levelInput.Position = UDim2.new(0.5, 5, 0, 60);
levelInput.Text = "800";
levelInput.BackgroundColor3 = Color3.fromRGB(30,30,30);
levelInput.TextColor3 = Color3.fromRGB(220,220,220)

local perkList = Instance.new("ScrollingFrame", configPanel);
perkList.Size = UDim2.new(0.5, -10, 0, 200);
perkList.Position = UDim2.new(0, 5, 0, 100);
perkList.BackgroundColor3 = Color3.fromRGB(35,35,35);
perkList.ScrollBarThickness = 4

local perkListLayout = Instance.new("UIListLayout", perkList);
perkListLayout.Padding = UDim.new(0, 5)

local variantList = Instance.new("ScrollingFrame", configPanel);
variantList.Size = UDim2.new(0.5, -10, 0, 200);
variantList.Position = UDim2.new(0.5, 5, 0, 100);
variantList.BackgroundColor3 = Color3.fromRGB(35,35,35);
variantList.ScrollBarThickness = 4

-- Bottom Buttons
local equipButton = Instance.new("TextButton", mainFrame);
equipButton.Name = "EquipButton";
equipButton.Size = UDim2.new(0.5, -135, 0, 30);
equipButton.Position = UDim2.new(0, 260, 1, -35);
equipButton.BackgroundColor3 = Color3.fromRGB(83, 12, 255);
equipButton.Font = Enum.Font.SourceSansBold;
equipButton.Text = "CONSTRUCT & EQUIP";
equipButton.TextColor3 = Color3.fromRGB(255, 255, 255);
equipButton.TextSize = 16

local setKeybindButton = Instance.new("TextButton", mainFrame);
setKeybindButton.Name = "SetKeybindButton";
setKeybindButton.Size = UDim2.new(0.5, -135, 0, 30);
setKeybindButton.Position = UDim2.new(0.5, 95, 1, -35);
setKeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
setKeybindButton.Font = Enum.Font.SourceSansBold;
setKeybindButton.Text = "SET KEYBIND";
setKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255);
setKeybindButton.TextSize = 16

-- Keybinds Display
local keybindsDisplay = Instance.new("ScrollingFrame", configPanel);
keybindsDisplay.Name = "KeybindsDisplay";
keybindsDisplay.Size = UDim2.new(1, -10, 0, 110);
keybindsDisplay.Position = UDim2.new(0, 5, 1, -150);
keybindsDisplay.BackgroundColor3 = Color3.fromRGB(35,35,35);
keybindsDisplay.BorderColor3 = Color3.fromRGB(80, 80, 80);

local keybindsDisplayLayout = Instance.new("UIListLayout", keybindsDisplay);
keybindsDisplayLayout.Padding = UDim.new(0, 3)

local keybindsTitle = Instance.new("TextLabel", configPanel);
keybindsTitle.Size = UDim2.new(1, -10, 0, 20);
keybindsTitle.Position = UDim2.new(0, 5, 1, -175);
keybindsTitle.Text = "Active Keybinds";
keybindsTitle.Font = Enum.Font.SourceSansBold;
keybindsTitle.TextColor3 = Color3.fromRGB(220,220,220);
keybindsTitle.TextXAlignment = Enum.TextXAlignment.Left;
keybindsTitle.BackgroundTransparency = 1;

local rarityDropdown, variantDropdown;

-- MODULES AND FUNCTIONS (Slider, Dropdown, etc.)
local function createSlider(parent, name, minValue, maxValue, initialValue)
    local sliderData = { Value = initialValue or 0 };
    local container = Instance.new("Frame", parent);
    container.Size = UDim2.new(1, 0, 0, 50);
    container.BackgroundTransparency = 1;
    container.LayoutOrder = 1;
    local nameLabel = Instance.new("TextLabel", container);
    nameLabel.Size = UDim2.new(1, -50, 0, 20);
    nameLabel.Position = UDim2.new(0, 5, 0, 5);
    nameLabel.Text = name;
    nameLabel.TextColor3 = Color3.fromRGB(200,200,200);
    nameLabel.BackgroundTransparency = 1;
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left;
    nameLabel.Font = Enum.Font.SourceSans;
    nameLabel.TextSize = 14;
    local valueLabel = Instance.new("TextLabel", container);
    valueLabel.Size = UDim2.new(0, 40, 0, 20);
    valueLabel.Position = UDim2.new(1, -45, 0, 5);
    valueLabel.Text = "0";
    valueLabel.TextColor3 = Color3.fromRGB(200,200,200);
    valueLabel.BackgroundTransparency = 1;
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right;
    valueLabel.Font = Enum.Font.SourceSans;
    valueLabel.TextSize = 14;
    local track = Instance.new("Frame", container);
    track.Size = UDim2.new(1, -10, 0, 6);
    track.Position = UDim2.new(0, 5, 0, 30);
    track.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
    track.BorderSizePixel = 0;
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0);
    local handle = Instance.new("TextButton", track);
    handle.Size = UDim2.new(0, 12, 0, 12);
    handle.Position = UDim2.new(0, 0, 0.5, 0);
    handle.AnchorPoint = Vector2.new(0.5, 0.5);
    handle.BackgroundColor3 = Color3.fromRGB(120, 120, 120);
    handle.Text = "";
    handle.ZIndex = 2;
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0);
    local isDragging = false;
    handle.MouseButton1Down:Connect(function() isDragging = true end);
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end);
    local function updateSlider(percentage)
        handle.Position = UDim2.fromScale(percentage, 0.5);
        sliderData.Value = math.floor(minValue + (maxValue - minValue) * percentage);
        valueLabel.Text = tostring(sliderData.Value)
    end;
    RunService.Heartbeat:Connect(function()
        if isDragging then
            local mouseX = UserInputService:GetMouseLocation().X;
            local trackStart = track.AbsolutePosition.X;
            local trackWidth = track.AbsoluteSize.X;
            local percentage = math.clamp((mouseX - trackStart) / trackWidth, 0, 1);
            updateSlider(percentage)
        end
    end);
    local function setValue(newValue)
        local clampedValue = math.clamp(newValue, minValue, maxValue);
        if (maxValue - minValue) == 0 then return end;
        local percentage = (clampedValue - minValue) / (maxValue - minValue);
        updateSlider(percentage)
    end;
    setValue(sliderData.Value);
    return {
        GetValue = function() return sliderData.Value end,
        SetValue = setValue
    }
end

local dropdownModule = {}
function dropdownModule.new(parent, position, size, options)
    local self = {};
    local selectedValue = options[1] or "None";
    local dropdownFrame = Instance.new("Frame", parent);
    dropdownFrame.Position = position;
    dropdownFrame.Size = size;
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    dropdownFrame.BorderSizePixel = 1;
    dropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 80);
    dropdownFrame.ZIndex = 3;

    local mainButton = Instance.new("TextButton", dropdownFrame);
    mainButton.Size = UDim2.new(1, 0, 1, 0);
    mainButton.Text = "";
    mainButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45);

    local mainButtonLabel = Instance.new("TextLabel", mainButton);
    mainButtonLabel.Size=UDim2.new(1, -5, 1, 0);
    mainButtonLabel.Position=UDim2.new(0,5,0,0);
    mainButtonLabel.Text=selectedValue;
    mainButtonLabel.TextColor3=Color3.fromRGB(220,220,220);
    mainButtonLabel.Font=Enum.Font.SourceSans;
    mainButtonLabel.TextSize=14;
    mainButtonLabel.BackgroundTransparency=1;
    mainButtonLabel.TextXAlignment = Enum.TextXAlignment.Left;

    local optionsList = Instance.new("ScrollingFrame", dropdownFrame);
    optionsList.Size = UDim2.new(1, 0, 4, 0);
    optionsList.Position = UDim2.new(0, 0, 1, 0);
    optionsList.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    optionsList.BackgroundTransparency = 0.3
    optionsList.BorderColor3 = Color3.fromRGB(80, 80, 80);
    optionsList.ScrollBarThickness = 5;
    optionsList.Visible = false;
    optionsList.ZIndex = 4;

    local listLayout = Instance.new("UIListLayout", optionsList);
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    
    function self:UpdateOptions(newOptions)
        for _, c in ipairs(optionsList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, optionName in ipairs(newOptions) do
            local optionButton = Instance.new("TextButton", optionsList);
            optionButton.Size = UDim2.new(1, 0, 0, 25);
            optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
            optionButton.BackgroundTransparency = 0.3
            optionButton.TextColor3 = Color3.fromRGB(200, 200, 200);
            optionButton.Font = Enum.Font.SourceSans;
            optionButton.TextSize = 14;
            optionButton.Text = "  " .. optionName;
            optionButton.LayoutOrder = i;
            optionButton.TextXAlignment = Enum.TextXAlignment.Left;
           
            optionButton.MouseButton1Click:Connect(function()
                selectedValue = optionName;
                mainButtonLabel.Text = optionName;
                optionsList.Visible = false
            end)
        end
        task.wait();
        optionsList.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
    end
    
    function self:SetSelectedOption(optionName)
        selectedValue = optionName;
        mainButtonLabel.Text = optionName;
    end
    
    self.GetSelectedOption = function() return selectedValue end
    
    mainButton.MouseButton1Click:Connect(function()
        optionsList.Visible = not optionsList.Visible
    end)
    
    self:UpdateOptions(options)
    return self
end

rarityDropdown = dropdownModule.new(configPanel, UDim2.new(0, 5, 0, 60), UDim2.new(0.5, -10, 0, 30), {"basic", "standard", "improved", "refined", "advanced", "calibrated", "elite", "masterwork", "ascendant"})

-- --> NEW: This function dynamically searches for the item database module.
local function findItemDataModule()
    print("--> V43.0: Searching for item data module...")
    local searchAreas = {ReplicatedStorage} 
    
    for _, area in ipairs(searchAreas) do
        for _, child in ipairs(area:GetDescendants()) do
            if child:IsA("ModuleScript") then
                local success, result = pcall(require, child)
                if success and type(result) == "table" and next(result) then
                    -- Heuristic check: does this look like an item DB?
                    -- Check if one of the first few items has a recognizable property.
                    local sample = result[next(result)]
                    if type(sample) == "table" and (sample.itemType or sample.Category or sample.Type) then
                        print("--> V43.0: Found potential item database at:", child:GetFullName())
                        return result -- Return the required module (the data table)
                    end
                end
            end
        end
    end
    warn("--> V43.0 CRITICAL FAILURE: Could not dynamically locate any valid item data module.")
    return nil
end

-- --> MODIFIED: This function is now more resilient.
local function initializeFirstTime()
    if isInitialized then return true end
    print("--> V43.0: Initializing...")

    -- Load item data using the new dynamic finder
    masterWeaponMap = findItemDataModule()
    if not masterWeaponMap then
        return false -- Stop initialization if no data is found
    end
    
    -- Load other data (assuming these paths are more stable)
    pcall(function() 
        local modulesFolder = ReplicatedStorage:FindFirstChild("modules")
        if modulesFolder then
            perkDatabase = require(modulesFolder:WaitForChild("upgradeData")).upgrade 
        end
    end)

    local assets = ReplicatedStorage:FindFirstChild("assets");
    if assets and assets:FindFirstChild("variants") then
        for _, wFolder in ipairs(assets.variants:GetChildren()) do
            local wName = wFolder.Name;
            variantDatabase[wName] = {};
            for _, v in ipairs(wFolder:GetChildren()) do
                table.insert(variantDatabase[wName], v.Name)
            end
        end
    end

    -- Populate Perks
    for _, c in ipairs(perkList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end;
    perkControls = {}
    if perkDatabase and next(perkDatabase) then
        local sortedPerks = {};
        for n in pairs(perkDatabase) do table.insert(sortedPerks, n) end;
        table.sort(sortedPerks)
        for _, pName in ipairs(sortedPerks) do
            if type(perkDatabase[pName]) == "table" then
                perkControls[pName] = createSlider(perkList, pName, 0, perkDatabase[pName].maxUpgrades or 1, 0)
            end
        end
    end

    -- Populate Variants Dropdown
    local vTitle = Instance.new("TextLabel", variantList);
    vTitle.Size = UDim2.new(1,0,0,20);
    vTitle.Text = "Weapon Variant";
    vTitle.TextColor3=Color3.fromRGB(200,200,200);
    vTitle.BackgroundTransparency=1;
    vTitle.TextXAlignment=Enum.TextXAlignment.Left
    variantDropdown = dropdownModule.new(variantList, UDim2.new(0,0,0,25), UDim2.new(1,0,0,30), {"None"})

    -- Populate Weapons List
    for _, b in ipairs(weaponList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local sortedWeapons = {};
    local weaponTypeKeys = {"itemType", "Category", "Type"} -- Flexible property checking

    for n, d in pairs(masterWeaponMap) do
        if type(d) == "table" then
            for _, key in ipairs(weaponTypeKeys) do
                if d[key] and (string.lower(tostring(d[key])) == "weapons" or string.lower(tostring(d[key])) == "weapon") then
                    table.insert(sortedWeapons, n)
                    break -- Found a match, no need to check other keys for this item
                end
            end
        end
    end;
    table.sort(sortedWeapons)
    
    print(`--> Found { #sortedWeapons } weapons to populate the list.`)
    if #sortedWeapons == 0 then
        warn("--> WARNING: No items classified as 'weapons' found in the located database. List will be blank.")
    end

    for _, name in ipairs(sortedWeapons) do
        local btn = Instance.new("TextButton", weaponList);
        btn.Size=UDim2.new(1,-10,0,25);
        btn.Text="  "..name;
        btn.BackgroundColor3=Color3.fromRGB(50,50,50);
        btn.TextColor3=Color3.fromRGB(220,220,220);
        btn.TextXAlignment=Enum.TextXAlignment.Left;
        btn.Font = Enum.Font.SourceSans;
        btn.TextSize = 14
        btn.MouseButton1Click:Connect(function()
            selectedWeapon=name;
            selectedWeaponLabel.Text="Selected: "..name;
            for _,s in pairs(perkControls) do s:SetValue(0) end;
            variantDropdown:UpdateOptions({"None"});
            if variantDatabase[name] then
                -- Create a fresh copy for insertion to avoid corrupting the master list
                local variantsForThisWeapon = table.clone(variantDatabase[name])
                table.insert(variantsForThisWeapon, 1, "None")
                variantDropdown:UpdateOptions(variantsForThisWeapon)
            end
        end)
    end
    
    task.wait();
    weaponList.CanvasSize = UDim2.fromOffset(0, weaponListLayout.AbsoluteContentSize.Y);
    perkList.CanvasSize = UDim2.fromOffset(0, perkListLayout.AbsoluteContentSize.Y)
    print("--> V43.0: Database built and GUI populated.");
    isInitialized = true;
    return true
end

local function updateKeybindsDisplay()
    for _, child in ipairs(keybindsDisplay:GetChildren()) do
        if not child:IsA("UILayout") then child:Destroy() end
    end
    for keyCode, config in pairs(weaponKeybinds) do
        local keybindLabel = Instance.new("TextLabel");
        keybindLabel.Size = UDim2.new(1, -10, 0, 20);
        keybindLabel.Text = `  [ {keyCode.Name} ] - {config.weaponName}`;
        keybindLabel.Font = Enum.Font.SourceSans;
        keybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left;
        keybindLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
        keybindLabel.Parent = keybindsDisplay
    end
    task.wait();
    keybindsDisplay.CanvasSize = UDim2.fromOffset(0, keybindsDisplayLayout.AbsoluteContentSize.Y)
end

local function verifyWeaponConstruction(weaponName)
    print(`--> Verifying construction of '{weaponName}'...`)
    local playerData = LOCAL_PLAYER:WaitForChild("data", 5);
    if not playerData then warn("--> Verification FAILED: Player 'data' folder did not appear."); return end
    local exaltedWeapons = playerData:WaitForChild("exaltedWeapons", 2);
    if not exaltedWeapons then warn("--> Verification FAILED: 'exaltedWeapons' table did not appear."); return end
    if exaltedWeapons:FindFirstChild(weaponName) then
        print("--> SUCCESS: Construction confirmed.")
    else
        warn("--> FAILED: Weapon entry did not appear in local data.")
    end
end

local function executeEquipSequence(config)
    print("--> Executing weapon equip sequence for:", config.weaponName)
    local eventsFolder = ReplicatedStorage:WaitForChild("events", 5);
    if not eventsFolder then warn("--> CRITICAL: 'events' folder not found."); return end
    local remotes = {
        reroll=eventsFolder:FindFirstChild("rerollItem"),
        equip=eventsFolder:FindFirstChild("equipItem"),
        upgrade=eventsFolder:FindFirstChild("purchaseUpgrade"),
        infuse=eventsFolder:FindFirstChild("infuseExaltedWeapon")
    }
    if not (remotes.reroll and remotes.equip and remotes.upgrade and remotes.infuse) then
        warn("--> CRITICAL: One or more remotes missing. Injection aborted.");
        return
    end
    local weaponData = {perkData = {}, rarity = config.rarity, level = config.level, attributes = {}};
    pcall(function() remotes.reroll:InvokeServer(config.weaponName, weaponData) end);
    task.wait(0.2);
    pcall(function() remotes.equip:InvokeServer(config.weaponName) end);
    task.wait(0.3)
    for perkName, perkValue in pairs(config.perks) do
        for i = 1, perkValue do
            pcall(function() remotes.upgrade:FireServer(config.weaponName, perkName) end);
            task.wait(0.05)
        end
    end
    if config.variant and config.variant ~= "None" then
        pcall(function() remotes.infuse:FireServer(config.weaponName, config.variant) end);
        print(`--> Fired Infuse for variant: "{config.variant}"`)
    end
    print("--> Injection sequence complete.");
    task.delay(1, function() verifyWeaponConstruction(config.weaponName) end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if not isInitialized then initializeFirstTime() end;
    local f=searchBox.Text:lower();
    for _,b in ipairs(weaponList:GetChildren()) do
        if b:IsA("TextButton") then
            b.Visible = f=="" or b.Text:lower():find(f,1,true)
        end
    end;
    task.wait();
    weaponList.CanvasSize=UDim2.fromOffset(0,weaponListLayout.AbsoluteContentSize.Y)
end)

setKeybindButton.MouseButton1Click:Connect(function()
    if not isInitialized or not selectedWeapon or isSettingKeybind then return end;
    isSettingKeybind = true;
    setKeybindButton.Text = "PRESS ANY KEY...";
    setKeybindButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    local connection;
    connection = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            warn("--> Cannot bind to the GUI toggle key.");
            connection:Disconnect();
            setKeybindButton.Text = "SET KEYBIND";
            setKeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
            isSettingKeybind = false;
            return
        end
        local currentConfig = {
            weaponName = selectedWeapon,
            rarity = rarityDropdown.GetSelectedOption(),
            level = math.clamp(tonumber(levelInput.Text) or 800, 1, 800),
            variant = variantDropdown and variantDropdown.GetSelectedOption() or "None",
            perks = {}
        };
        for perkName, slider in pairs(perkControls) do
            currentConfig.perks[perkName] = slider:GetValue()
        end
        weaponKeybinds[input.KeyCode] = currentConfig;
        print(`--> Keybind set! Key '{input.KeyCode.Name}' is now bound to '{selectedWeapon}'.`);
        updateKeybindsDisplay();
        connection:Disconnect();
        setKeybindButton.Text = "SET KEYBIND";
        setKeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
        isSettingKeybind = false
    end)
end)

equipButton.MouseButton1Click:Connect(function()
    if not isInitialized then
        if not initializeFirstTime() then warn("Init failed."); return end
    end;
    if not selectedWeapon then return end
    local character = LOCAL_PLAYER.Character;
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local currentConfig = {
        weaponName = selectedWeapon,
        rarity = rarityDropdown.GetSelectedOption(),
        level = math.clamp(tonumber(levelInput.Text) or 800, 1, 800),
        variant = variantDropdown and variantDropdown.GetSelectedOption() or "None",
        perks = {}
    };
    for perkName, slider in pairs(perkControls) do
        currentConfig.perks[perkName] = slider:GetValue()
    end
    if humanoid and humanoid.Health > 0 then
        print("--> Player is alive in-round. Equipping immediately.");
        executeEquipSequence(currentConfig)
    else
        queuedWeaponConfig = currentConfig;
        print(`--> Player is in lobby. Queued '{selectedWeapon}' for next spawn.`);
        selectedWeaponLabel.Text = "QUEUED: " .. selectedWeapon
    end
end)

LOCAL_PLAYER.CharacterAdded:Connect(function(character)
    if queuedWeaponConfig then
        print("--> Character spawned, proceeding with queued weapon equip.");
        local configToEquip = queuedWeaponConfig;
        queuedWeaponConfig = nil;
        task.wait(2);
        executeEquipSequence(configToEquip)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end;
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible;
        if mainFrame.Visible and not isInitialized then
            initializeFirstTime()
        end;
        return
    end
    if isSettingKeybind then return end;
    local boundConfig = weaponKeybinds[input.KeyCode]
    if boundConfig then
        print(`--> Keybind '{input.KeyCode.Name}' pressed.`);
        local character = LOCAL_PLAYER.Character;
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            print("--> Executing keybind sequence.");
            executeEquipSequence(boundConfig)
        else
            warn("--> Cannot equip via keybind while in the lobby or dead.")
        end
    end
end)

print("Master Equipper V43.0 Loaded. Press [RIGHT CONTROL] to toggle the GUI.");
