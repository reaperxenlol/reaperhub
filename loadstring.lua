-- Blox Fruits Fully Automatic Fruit Hunter (Final Version)
-- Features: Auto-Team, Auto-ESP, Auto-Store, Auto-Tween, Auto-Hop, Discord Logging
-- ALL FEATURES ENABLED BY DEFAULT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- User Settings (All ON by default)
_G.FruitESP = true
_G.AutoStore = true
_G.WebhookEnabled = true
_G.WebhookURL = "https://discord.com/api/webhooks/1465707073840091221/5atHFi4pPOHQ4yb2JAtPtcAeWorZPiYyMQGUhP8Aeh15lBt4zI8kfqI2gHcsq4NuGasI"
_G.AutoHop = true
_G.AutoTeam = true
_G.AutoTweenToFruit = true

local NO_FRUIT_TIMEOUT = 8 -- Seconds to wait before hopping if no fruit is found
local TWEEN_SPEED = 150 -- Speed for tweening to fruit

-- Fruit Rarity Mapping
local RarityColors = {
    Mythical = 16711935, -- Purple/Pink
    Legendary = 16711680, -- Red
    Rare = 255, -- Blue
    Uncommon = 65280, -- Green
    Common = 12632256 -- Gray
}

local FruitData = {
    ["Kitsune"] = "Mythical", ["Leopard"] = "Mythical", ["Dragon"] = "Mythical", ["Spirit"] = "Mythical", ["Control"] = "Mythical", ["Venom"] = "Mythical", ["Shadow"] = "Mythical", ["Dough"] = "Mythical", ["Mammoth"] = "Mythical", ["Gravity"] = "Mythical", ["T-Rex"] = "Mythical",
    ["Blizzard"] = "Legendary", ["Pain"] = "Legendary", ["Rumble"] = "Legendary", ["Portal"] = "Legendary", ["Phoenix"] = "Legendary", ["Sound"] = "Legendary", ["Love"] = "Legendary", ["Spider"] = "Legendary", ["Buddha"] = "Legendary", ["Quake"] = "Legendary",
    ["Magma"] = "Rare", ["Ghost"] = "Rare", ["Barrier"] = "Rare", ["Rubber"] = "Rare", ["Light"] = "Rare", ["Diamond"] = "Rare",
    ["Dark"] = "Uncommon", ["Sand"] = "Uncommon", ["Ice"] = "Uncommon", ["Falcon"] = "Uncommon", ["Flame"] = "Uncommon",
    ["Spike"] = "Common", ["Smoke"] = "Common", ["Bomb"] = "Common", ["Spring"] = "Common", ["Chop"] = "Common", ["Spin"] = "Common", ["Rocket"] = "Common"
}

-- Function to send Discord webhook
local function SendWebhook(fruitName, status)
    if not _G.WebhookEnabled or _G.WebhookURL == "" then return end
    local cleanName = fruitName:gsub(" Fruit", "")
    local rarity = FruitData[cleanName] or "Common"
    local color = RarityColors[rarity] or RarityColors.Common
    local data = {
        ["embeds"] = {{
            ["title"] = "Blox Fruits Auto-Hunter",
            ["description"] = "**" .. status .. ":** " .. fruitName .. "\n**Rarity:** " .. rarity .. "\n**Server:** " .. game.JobId,
            ["color"] = color,
            ["footer"] = { ["text"] = "Manus AI | " .. os.date("%X") }
        }}
    }
    pcall(function() HttpService:PostAsync(_G.WebhookURL, HttpService:JSONEncode(data)) end)
end

-- Function to notify the player
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5
    })
end

-- Function to store a fruit
local function StoreFruit(fruit)
    local fruitName = fruit:GetAttribute("OriginalName") or fruit.Name
    local success, result = pcall(function()
        return CommF:InvokeServer("StoreFruit", fruitName, fruit)
    end)
    if success then
        Notify("Fruit Storer", "Stored: " .. fruitName)
        SendWebhook(fruitName, "Stored Successfully")
    end
end

-- Auto Team Selection
local function AutoSelectTeam()
    if not _G.AutoTeam then return end
    local success, err = pcall(function()
        -- Blox Fruits specific team selection remote
        CommF:InvokeServer("SetTeam", "Pirates")
    end)
    if not success then
        warn("Auto Team failed: " .. tostring(err))
    end
end

-- Server Hopping
local function ServerHop()
    if not _G.AutoHop then return end
    Notify("Server Hopper", "No fruit found, hopping...")
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local function ListServers(cursor)
        local Raw = game:HttpGet(Api .. ((cursor and "&cursor=" .. cursor) or ""))
        return Http:JSONDecode(Raw)
    end
    local Server = ListServers()
    if Server.data then
        for _, v in pairs(Server.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                break
            end
        end
    end
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHelperFinal"
ScreenGui.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "AUTO FRUIT HUNTER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local function CreateToggle(name, pos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    local state = default
    local function updateVisuals() 
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
    end
    updateVisuals()
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function() 
        state = not state 
        updateVisuals()
        callback(state) 
    end)
    btn.Parent = MainFrame
end

CreateToggle("Fruit ESP", 45, _G.FruitESP, function(v) _G.FruitESP = v end)
CreateToggle("Auto Store", 85, _G.AutoStore, function(v) _G.AutoStore = v end)
CreateToggle("Discord Log", 125, _G.WebhookEnabled, function(v) _G.WebhookEnabled = v end)
CreateToggle("Auto Hop", 165, _G.AutoHop, function(v) _G.AutoHop = v end)
CreateToggle("Auto Team", 205, _G.AutoTeam, function(v) _G.AutoTeam = v end)
CreateToggle("Auto Tween", 245, _G.AutoTweenToFruit, function(v) _G.AutoTweenToFruit = v end)

-- ESP Logic
local function CreateESP(fruit)
    if fruit:FindFirstChild("FruitESP") then return end
    local bgui = Instance.new("BillboardGui", fruit)
    bgui.Name = "FruitESP"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 100, 0, 30)
    bgui.Adornee = fruit:FindFirstChild("Handle") or fruit
    local text = Instance.new("TextLabel", bgui)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Text = fruit.Name
    text.TextColor3 = Color3.new(1, 0.8, 0)
    text.TextStrokeTransparency = 0
    text.TextScaled = true
end

-- Main Loop
local loggedFruits = {}
local lastFruitFoundTime = tick()

task.spawn(function()
    -- Immediate Auto-Team
    AutoSelectTeam()
    
    while task.wait(1) do
        local foundFruit = nil

        -- Scan for fruits
        for _, v in pairs(Workspace:GetChildren()) do
            if (v:IsA("Tool") or v:IsA("Model")) and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                local handle = v:FindFirstChild("Handle") or v
                if _G.FruitESP then CreateESP(handle) end
                if not loggedFruits[v] then
                    SendWebhook(v.Name, "Fruit Found")
                    loggedFruits[v] = true
                end
                foundFruit = handle
                lastFruitFoundTime = tick()
                break
            end
        end

        -- Auto Tween
        if _G.AutoTweenToFruit and foundFruit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local dist = (hrp.Position - foundFruit.Position).Magnitude
            local tweenInfo = TweenInfo.new(dist / TWEEN_SPEED, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = foundFruit.CFrame})
            tween:Play()
        end

        -- Auto Store
        if _G.AutoStore then
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Fruit") then StoreFruit(item) end
            end
            if LocalPlayer.Character then
                for _, item in pairs(LocalPlayer.Character:GetChildren()) do
                    if item:IsA("Tool") and item.Name:find("Fruit") then StoreFruit(item) end
                end
            end
        end

        -- Auto Hop if no fruit found for timeout
        if _G.AutoHop and not foundFruit and (tick() - lastFruitFoundTime > NO_FRUIT_TIMEOUT) then
            ServerHop()
        end
    end
end)

Notify("Script Loaded", "Fully Automatic Fruit Hunter is ACTIVE!")
