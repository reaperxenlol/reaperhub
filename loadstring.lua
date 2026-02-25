--[[
    Blox Fruits Modernized Auto-Hunter
    Features:
    - Advanced Fruit Detection (Tool & Model)
    - Modernized UI with Detailed Logging
    - Reliable Collection & Storage Logic
    - Multi-Executor Webhook Support
    - Smart Server Hopping
]]

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer

-- Webhook Configuration
local WebhookURL = "https://discord.com/api/webhooks/1465707073840091221/5atHFi4pPOHQ4yb2JAtPtcAeWorZPiYyMQGUhP8Aeh15lBt4zI8kfqI2gHcsq4NuGasI"

local RarityColors = {
    Mythical = 16711935, -- Purple/Pink
    Legendary = 16711680, -- Red
    Rare = 255, -- Blue
    Uncommon = 65280, -- Green
    Common = 12632256 -- Gray
}

local FruitData = {
    ["Rocket"] = "Common", ["Spin"] = "Common", ["Blade"] = "Common", ["Spring"] = "Common", ["Bomb"] = "Common", ["Smoke"] = "Common", ["Spike"] = "Common",
    ["Flame"] = "Uncommon", ["Ice"] = "Uncommon", ["Sand"] = "Uncommon", ["Dark"] = "Uncommon", ["Eagle"] = "Uncommon", ["Diamond"] = "Uncommon",
    ["Light"] = "Rare", ["Rubber"] = "Rare", ["Ghost"] = "Rare", ["Magma"] = "Rare",
    ["Quake"] = "Legendary", ["Buddha"] = "Legendary", ["Love"] = "Legendary", ["Creation"] = "Legendary", ["Spider"] = "Legendary", ["Sound"] = "Legendary", ["Phoenix"] = "Legendary", ["Portal"] = "Legendary", ["Lightning"] = "Legendary", ["Pain"] = "Legendary", ["Blizzard"] = "Legendary",
    ["Gravity"] = "Mythical", ["Mammoth"] = "Mythical", ["T-Rex"] = "Mythical", ["Dough"] = "Mythical", ["Shadow"] = "Mythical", ["Venom"] = "Mythical", ["Gas"] = "Mythical", ["Spirit"] = "Mythical", ["Tiger"] = "Mythical", ["Yeti"] = "Mythical", ["Kitsune"] = "Mythical", ["Control"] = "Mythical", ["Dragon"] = "Mythical"
}

local Config = {
    AutoFruit = true,
    AutoStoreFruit = true,
    FruitLog = {},
    Status = "Initializing...",
    Running = true
}

-- Helper: Get Fruit Name and Rarity
local function GetFruitInfo(name)
    local cleanName = name:gsub(" Fruit", ""):gsub(" fruit", "")
    local rarity = FruitData[cleanName] or "Common"
    return cleanName, rarity
end

-- Webhook Sender
local function SendWebhook(title, description, color)
    if not WebhookURL or WebhookURL == "" or not WebhookURL:find("discord.com") then return end
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description .. "\n**Server:** " .. game.JobId,
            ["color"] = color,
            ["footer"] = { ["text"] = "Manus AI | " .. os.date("%X") }
        }}
    }
    
    local headers = {["Content-Type"] = "application/json"}
    local body = HttpService:JSONEncode(data)
    
    pcall(function()
        if request then
            request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
        elseif syn and syn.request then
            syn.request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
        elseif http_request then
            http_request({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
        else
            HttpService:PostAsync(WebhookURL, body)
        end
    end)
end

local function SendFruitWebhook(fruitName, status)
    local name, rarity = GetFruitInfo(fruitName)
    local color = RarityColors[rarity] or RarityColors.Common
    SendWebhook("Blox Fruits Logger", "**" .. status .. ":** " .. name .. " Fruit\n**Rarity:** " .. rarity, color)
end

-- UI Implementation
local function CreateModernUI()
    local ScreenGui = Instance.new("ScreenGui")
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = plr:WaitForChild("PlayerGui") end
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
    MainFrame.Size = UDim2.new(0, 320, 0, 360)
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BorderSizePixel = 0
    local TopCorner = Instance.new("UICorner", TopBar)
    TopCorner.CornerRadius = UDim.new(0, 12)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FRUIT FINDER PRO"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local StatusContainer = Instance.new("Frame", MainFrame)
    StatusContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    StatusContainer.Position = UDim2.new(0, 15, 0, 65)
    StatusContainer.Size = UDim2.new(1, -30, 0, 45)
    Instance.new("UICorner", StatusContainer).CornerRadius = UDim.new(0, 8)
    
    local StatusLabel = Instance.new("TextLabel", StatusContainer)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = "Status: Initializing..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    
    local LogLabel = Instance.new("TextLabel", MainFrame)
    LogLabel.BackgroundTransparency = 1
    LogLabel.Position = UDim2.new(0, 15, 0, 120)
    LogLabel.Size = UDim2.new(0, 100, 0, 20)
    LogLabel.Font = Enum.Font.GothamBold
    LogLabel.Text = "RECENT LOGS"
    LogLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    LogLabel.TextSize = 12
    LogLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local LogFrame = Instance.new("ScrollingFrame", MainFrame)
    LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    LogFrame.Position = UDim2.new(0, 15, 0, 145)
    LogFrame.Size = UDim2.new(1, -30, 0, 150)
    LogFrame.BorderSizePixel = 0
    LogFrame.ScrollBarThickness = 4
    LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 8)
    
    local UIListLayout = Instance.new("UIListLayout", LogFrame)
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", LogFrame).PaddingTop = UDim.new(0, 5)
    
    local ToggleButton = Instance.new("TextButton", MainFrame)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(65, 165, 65)
    ToggleButton.Position = UDim2.new(0, 15, 0, 310)
    ToggleButton.Size = UDim2.new(1, -30, 0, 35)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "STOP SCRIPT"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
    
    -- Dragging Logic
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    local ui = {}
    
    function ui.UpdateStatus(text)
        StatusLabel.Text = "Status: " .. text
    end
    
    function ui.AddLog(fruitName)
        local name, rarity = GetFruitInfo(fruitName)
        local color = RarityColors[rarity] or RarityColors.Common
        
        local LogEntry = Instance.new("TextLabel", LogFrame)
        LogEntry.BackgroundTransparency = 1
        LogEntry.Size = UDim2.new(1, -10, 0, 25)
        LogEntry.Font = Enum.Font.GothamMedium
        LogEntry.Text = string.format("[%s] %s Fruit (%s)", os.date("%X"), name, rarity)
        LogEntry.TextColor3 = Color3.fromHex(string.format("#%06x", color))
        LogEntry.TextSize = 12
        LogEntry.LayoutOrder = -tick()
        
        -- Keep only last 20 logs
        local children = LogFrame:GetChildren()
        if #children > 25 then children[2]:Destroy() end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config.Running = not Config.Running
        ToggleButton.Text = Config.Running and "STOP SCRIPT" or "START SCRIPT"
        ToggleButton.BackgroundColor3 = Config.Running and Color3.fromRGB(65, 165, 65) or Color3.fromRGB(165, 65, 65)
        ui.UpdateStatus(Config.Running and "Resuming..." or "Paused")
    end)
    
    return ui
end

local ui = CreateModernUI()

-- Collection Logic
local function StoreFruit(tool)
    if not Config.AutoStoreFruit then return end
    pcall(function()
        local name = tool:GetAttribute("OriginalName") or tool.Name
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", name, tool)
    end)
end

local function CollectFruit(item)
    if not item or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local hrp = plr.Character.HumanoidRootPart
    local targetPart = item:IsA("Tool") and item:FindFirstChild("Handle") or item:IsA("Model") and item:FindFirstChildWhichIsA("BasePart", true)
    
    if not targetPart then return false end
    
    local startTime = tick()
    local collected = false
    
    repeat
        if not Config.Running then task.wait(0.5) continue end
        hrp.CFrame = targetPart.CFrame
        task.wait(0.1)
        
        -- Check if collected (moved from workspace to player)
        if not item:IsDescendantOf(workspace) then
            collected = true
            break
        end
    until tick() - startTime > 5 or not item:IsDescendantOf(workspace)
    
    if collected then
        local name = item.Name
        ui.AddLog(name)
        SendFruitWebhook(name, "Fruit Collected")
        
        -- Try to store if it's a tool now in backpack
        task.delay(0.5, function()
            for _, tool in ipairs(plr.Backpack:GetChildren()) do
                if tool.Name == name then StoreFruit(tool) break end
            end
        end)
    end
    
    return collected
end

-- Main Loop
local function StartFinder()
    local lastServerHop = tick()
    
    while task.wait(0.5) do
        if not Config.Running then continue end
        
        local found = false
        ui.UpdateStatus("Scanning for fruits...")
        
        for _, v in ipairs(workspace:GetChildren()) do
            if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") then
                found = true
                local name, _ = GetFruitInfo(v.Name)
                ui.UpdateStatus("Found: " .. name)
                
                if CollectFruit(v) then
                    task.wait(1)
                end
                break
            end
        end
        
        if not found then
            local timeSinceHop = math.floor(tick() - lastServerHop)
            ui.UpdateStatus("No fruits. Hopping in: " .. (30 - timeSinceHop) .. "s")
            
            if timeSinceHop >= 30 then
                ui.UpdateStatus("Server Hopping...")
                SendWebhook("Blox Fruits Auto-Hunter", "No fruits found, hopping servers.", 16776960)
                
                pcall(function()
                    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                    for _, server in ipairs(servers.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                            break
                        end
                    end
                end)
                lastServerHop = tick() -- Reset if hop fails
            end
        else
            lastServerHop = tick() -- Reset timer if fruit found
        end
    end
end

-- Auto-Store for manual pickups
plr.Backpack.ChildAdded:Connect(StoreFruit)
if plr.Character then
    plr.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then StoreFruit(child) end
    end)
end
plr.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then StoreFruit(child) end
    end)
end)

-- Start
ui.UpdateStatus("Script Started")
SendWebhook("Blox Fruits Auto-Hunter", "Modernized script started!", 3447003)
task.spawn(StartFinder)
