--[[
    VZRO HUB - Ultimate Advanced Hub (V2 Dynamic Goal)
    Features:
    - Anti-AFK
    - Auto-Claim & Set Booth
    - Dynamic Goal System (Auto-increases as you reach it)
    - Auto-Beg (Improved Rotating Messages)
    - Chat Responder (Keyword Detection)
    - Auto-Thank (Improved Messages)
    - Auto-Emote (Customizable)
    - Auto-Rejoin
    - Discord Webhook Logging (Executions, Donations, Chat, Begging)
    - Color-Coded Donation Embeds (Red: 5-30, Yellow: 40-90, Green: 100+)
    - Advanced Auto-Walk & Interaction System (25+ Messages, Follow Me Logic)
    - Auto-Save & Auto-Load (Settings persist across server hops)
    - Rayfield GUI
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "VZRO HUB | Ultimate Hub V2",
   LoadingTitle = "Initializing Vzro Hub V2...",
   LoadingSubtitle = "by Manus AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VzroHubV2",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- Global Variables
local _G = getgenv()
_G.WebhookURL = "https://discord.com/api/webhooks/1473858554891997207/nIxT8nRCANDGPtk63Ak5hb9G9amwSFCN-LJHue_2OQxWzm2fOcBxGO6mykLg3150KsZY"
_G.AntiAFK = false
_G.AutoClaim = false
_G.AutoBeg = false
_G.AutoThank = false
_G.AutoRejoin = false
_G.ChatResponder = false
_G.AutoEmote = false
_G.AutoWalk = false
_G.BoothMessage = "Goal: {raised} / {goal}! Please help me reach it! ❤️"
_G.CurrentGoal = 100
_G.GoalIncrement = 100

-- 25+ Approach Messages
_G.ApproachMessages = {
    "Hey! Mind checking out my booth? 🥺",
    "Hi there! I'm so close to my goal, any help? 🙏",
    "Excuse me, would you like to be a legend today? ❤️",
    "Hello! Spare a moment for a small donation? ✨",
    "Hi! Your outfit looks amazing! Mind helping me out? 😊",
    "Hey friend! Every Robux helps me reach my dream! 🌈",
    "Hi! I'm saving up for my first gamepass, any support? 🎁",
    "Hello! You look like a generous person! Mind donating? 💎",
    "Hey! Just 1 Robux would make my entire day! 🚀",
    "Hi! Help me reach my goal? I'm almost there! ✨",
    "Excuse me, could you spare some change? 🥺",
    "Hi! Donating makes you a hero in my book! 🏆",
    "Hey! I'd really appreciate any support you can give! ❤️",
    "Hello! Mind helping a fellow player out? 🙏",
    "Hi! Small donations make a big difference! ✨",
    "Hey! You're awesome! Mind checking my booth? 😊",
    "Hi! I'm working hard for my goal, any help? 🚀",
    "Hello! Your kindness would mean the world to me! 🌈",
    "Hey! Spare some Robux for a dream? 🎁",
    "Hi! Be the reason I smile today! Donate! 😊",
    "Hello! I'm so close to my goal, can you help? 💎",
    "Hey! You look like you have a big heart! Mind donating? ❤️",
    "Hi! Every bit counts, please consider helping! 🙏",
    "Hello! Help me reach my dream today? ✨",
    "Hey! You're a legend! Mind supporting my booth? 🏆"
}

-- Improved Thank You Messages
local thankMessages = {
    "OH MY GOD! Thank you so much! ❤️❤️❤️",
    "You are literally a legend! Tysm! 🏆",
    "I really appreciate the support! Have an amazing day! ✨",
    "Wow! That's so generous of you! Thank you! 🙏",
    "Tysm for the donation! You're the best! 😊",
    "I'm speechless! Thank you for being so kind! 💎",
    "You just made my entire week! Thank you! 🌈",
    "Much love for the donation! ❤️",
    "Thank you! I'll never forget this! 🎁",
    "You're a real one! Thanks for the support! 🚀"
}

-- Keyword Responses
local responses = {
    ["hello"] = "Hey! Welcome to my booth! Hope you're having a great day! 😊",
    ["hi"] = "Hi there! Feel free to check out my goals! ❤️",
    ["how are you"] = "I'm doing great, just vibing and hoping for some support! How about you? ✨",
    ["scam"] = "No scams here! Just a player with a dream. Feel free to verify! 🙏",
    ["no"] = "No worries at all! Have a wonderful day! 😊",
    ["rich"] = "I wish! That's why I'm here working hard! haha 💎",
    ["why"] = "I'm saving up for some cool items and gamepasses! Every bit helps! 🚀",
    ["free"] = "I can't give free Robux, but I'd be so happy if you could support me! 🙏",
    ["goal"] = "My goal is to reach my next milestone! We're slowly getting there! ✨",
    ["donate"] = "Yes please! Any amount is highly appreciated! ❤️",
    ["sure"] = "Okay, follow me! I'll take you to my booth! 😊",
    ["okay"] = "Okay, follow me! I'll take you to my booth! 😊",
    ["yes"] = "Okay, follow me! I'll take you to my booth! 😊",
    ["fine"] = "Okay, follow me! I'll take you to my booth! 😊"
}

-- Discord Webhook Function
local function sendWebhook(title, description, color)
    if _G.WebhookURL == "" then return end
    local headers = {["Content-Type"] = "application/json"}
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color or 65280,
            ["footer"] = {["text"] = "Vzro Hub V2 | " .. os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local finalData = game:GetService("HttpService"):JSONEncode(data)
    task.spawn(function()
        pcall(function()
            request({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = headers,
                Body = finalData
            })
        end)
    end)
end

-- Helper: Send Chat Message
local function sendMessage(msg)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if chatEvent then
        chatEvent:FireServer(msg, "All")
    else
        local textChatService = game:GetService("TextChatService")
        if textChatService and textChatService.TextChannels:FindFirstChild("RBXGeneral") then
            textChatService.TextChannels.RBXGeneral:SendAsync(msg)
        end
    end
end

-- Tabs
local MainTab = Window:CreateTab("Main Features", 4483362458)
local WalkTab = Window:CreateTab("Auto-Walk", 4483362458)
local ChatTab = Window:CreateTab("Chat & Begging", 4483362458)
local EmoteTab = Window:CreateTab("Emotes", 4483362458)
local LogsTab = Window:CreateTab("Logs", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Logging Helper for GUI
local function logToGUI(text)
    LogsTab:CreateLabel(os.date("[%X] ") .. text)
end

-- 1. Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        logToGUI("Anti-AFK: Reset idle timer")
    end
end)

MainTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(Value) _G.AntiAFK = Value end,
})

-- 2. Auto-Claim & Dynamic Booth
local LocalPlayer = game:GetService("Players").LocalPlayer
local raised = LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Raised")

local function updateBoothText()
    local currentRaised = raised.Value
    -- Auto-increase goal if reached
    while currentRaised >= _G.CurrentGoal do
        _G.CurrentGoal = _G.CurrentGoal + _G.GoalIncrement
    end
    
    local finalMsg = _G.BoothMessage:gsub("{raised}", tostring(currentRaised)):gsub("{goal}", tostring(_G.CurrentGoal))
    game:GetService("ReplicatedStorage").Events.EditBooth:FireServer(finalMsg, "booth")
    logToGUI("Booth Updated: " .. finalMsg)
end

local myBooth = nil
local function claimBooth()
    local boothFolder = workspace:FindFirstChild("BoothInteractions") or workspace:FindFirstChild("Booths")
    if boothFolder then
        for _, booth in pairs(boothFolder:GetChildren()) do
            if booth:FindFirstChild("Claimed") and booth.Claimed.Value == false then
                game:GetService("ReplicatedStorage").Events.ClaimBooth:FireServer(booth.BoothId.Value)
                myBooth = booth
                logToGUI("Auto-Claim: Claimed booth " .. booth.Name)
                sendWebhook("Booth Claimed", "Successfully claimed booth: " .. booth.Name, 3066993)
                
                task.wait(2)
                updateBoothText()
                break
            end
        end
    end
end

MainTab:CreateToggle({
   Name = "Auto-Claim & Dynamic Booth",
   CurrentValue = false,
   Flag = "AutoClaim",
   Callback = function(Value)
      _G.AutoClaim = Value
      if Value then
          task.spawn(function()
              while _G.AutoClaim do
                  claimBooth()
                  task.wait(10)
              end
          end)
      end
   end,
})

SettingsTab:CreateInput({
   Name = "Booth Message Template",
   Info = "Use {raised} and {goal} as placeholders",
   PlaceholderText = "Goal: {raised} / {goal}!",
   RemoveTextAfterFocusLost = false,
   Flag = "BoothMessage",
   Callback = function(Text)
      _G.BoothMessage = Text
      updateBoothText()
   end,
})

SettingsTab:CreateSlider({
   Name = "Goal Increment",
   Range = {10, 1000},
   Increment = 10,
   Suffix = " Robux",
   CurrentValue = 100,
   Flag = "GoalIncrement",
   Callback = function(Value) _G.GoalIncrement = Value end,
})

-- 3. Auto-Walk & Interaction
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

local function walkTo(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char.Humanoid
    
    local path = PathfindingService:CreatePath({AgentCanJump = true})
    path:ComputeAsync(char.HumanoidRootPart.Position, targetPos)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in pairs(waypoints) do
            if not _G.AutoWalk and not _G.FollowingMe then break end
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait()
        end
    else
        humanoid:MoveTo(targetPos)
    end
end

local function getNearestPlayer()
    local nearest = nil
    local minDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist and dist > 5 then
                minDist = dist
                nearest = player
            end
        end
    end
    return nearest
end

WalkTab:CreateToggle({
   Name = "Auto-Walk to Players",
   CurrentValue = false,
   Flag = "AutoWalk",
   Callback = function(Value)
      _G.AutoWalk = Value
      if Value then
          task.spawn(function()
              while _G.AutoWalk do
                  local target = getNearestPlayer()
                  if target and target.Character then
                      logToGUI("Auto-Walk: Walking to " .. target.Name)
                      walkTo(target.Character.HumanoidRootPart.Position)
                      
                      task.wait(1)
                      local msg = _G.ApproachMessages[math.random(1, #_G.ApproachMessages)]
                      sendMessage("@" .. target.Name .. " " .. msg)
                      sendWebhook("Auto-Walk Approach", "Approached: " .. target.Name .. "\nMessage: " .. msg, 3447003)
                      
                      task.wait(5)
                  end
                  task.wait(2)
              end
          end)
      end
   end,
})

-- 4. Chat Responder & Follow Me
ChatTab:CreateToggle({
   Name = "Chat Responder (Keyword Detection)",
   CurrentValue = false,
   Flag = "ChatResponder",
   Callback = function(Value) _G.ChatResponder = Value end,
})

local function handleChat(message, sender)
    if not _G.ChatResponder or sender == LocalPlayer.Name then return end
    local lowerMsg = string.lower(message)
    
    if string.find(lowerMsg, "sure") or string.find(lowerMsg, "okay") or string.find(lowerMsg, "yes") then
        logToGUI("Chat Responder: " .. sender .. " agreed! Leading to booth.")
        sendMessage("@" .. sender .. " Okay, follow me! I'll take you to my booth! 😊")
        sendWebhook("Donor Found!", sender .. " agreed to donate! Leading them to booth.", 65280)
        
        _G.FollowingMe = true
        if myBooth then
            walkTo(myBooth.BoothId.Parent.Position)
        end
        _G.FollowingMe = false
        return
    end

    for keyword, response in pairs(responses) do
        if string.find(lowerMsg, keyword) then
            logToGUI("Chat Responder: Detected '" .. keyword .. "' from " .. sender)
            task.wait(math.random(1, 3))
            sendMessage("@" .. sender .. " " .. response)
            sendWebhook("Chat Interaction", "User: " .. sender .. "\nMessage: " .. message .. "\nResponse: " .. response, 3447003)
            break
        end
    end
end

Players.PlayerChatted:Connect(function(type, player, message)
    handleChat(message, player.Name)
end)

-- 5. Auto-Beg (Rotating)
ChatTab:CreateToggle({
   Name = "Auto-Beg (Rotating Messages)",
   CurrentValue = false,
   Flag = "AutoBeg",
   Callback = function(Value)
      _G.AutoBeg = Value
      if Value then
          task.spawn(function()
              while _G.AutoBeg do
                  local msg = _G.BegMessages[math.random(1, #_G.BegMessages)]
                  sendMessage(msg)
                  logToGUI("Auto-Beg: Sent message - " .. msg)
                  sendWebhook("Begging Message Sent", "Message: " .. msg, 16776960)
                  task.wait(_G.BegDelay)
              end
          end)
      end
   end,
})

-- 6. Auto-Emote
local emotes = {"Dance", "Dance2", "Dance3", "Wave", "Laugh", "Cheer", "Point"}
EmoteTab:CreateDropdown({
   Name = "Select Emote",
   Options = emotes,
   CurrentOption = "Dance",
   Flag = "SelectedEmote",
   Callback = function(Option) _G.SelectedEmote = Option end,
})

EmoteTab:CreateToggle({
   Name = "Auto-Emote",
   CurrentValue = false,
   Flag = "AutoEmote",
   Callback = function(Value)
      _G.AutoEmote = Value
      if Value then
          task.spawn(function()
              while _G.AutoEmote do
                  local char = LocalPlayer.Character
                  if char and char:FindFirstChild("Humanoid") then
                      char.Humanoid:PlayEmote(_G.SelectedEmote)
                  end
                  task.wait(10)
              end
          end)
      end
   end,
})

-- 7. Auto-Thank & Goal Tracking
MainTab:CreateToggle({
   Name = "Auto-Thank",
   CurrentValue = false,
   Flag = "AutoThank",
   Callback = function(Value) _G.AutoThank = Value end,
})

local lastRaised = raised.Value

raised.Changed:Connect(function(val)
    local amount = val - lastRaised
    lastRaised = val
    if amount > 0 then
        -- Update Booth Goal
        updateBoothText()
        
        if _G.AutoThank then
            task.wait(1)
            local msg = thankMessages[math.random(1, #thankMessages)]
            sendMessage(msg)
            logToGUI("Auto-Thank: Sent message - " .. msg)
            
            local color = 65280
            if amount >= 5 and amount <= 30 then color = 16711680
            elseif amount >= 40 and amount <= 90 then color = 16776960
            elseif amount >= 100 then color = 65280 end
            
            sendWebhook("Donation Received!", "Amount: " .. amount .. " Robux\nNew Total Raised: " .. val .. " Robux\nThank You Message: " .. msg, color)
        end
    end
end)

-- 8. Auto-Rejoin
MainTab:CreateToggle({
   Name = "Auto-Rejoin",
   CurrentValue = false,
   Flag = "AutoRejoin",
   Callback = function(Value) _G.AutoRejoin = Value end,
})

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if _G.AutoRejoin then
        sendWebhook("Disconnected", "Attempting to rejoin server...", 15158332)
        task.wait(5)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
end)

-- Initial Execution Log
logToGUI("Vzro Hub V2 Executed Successfully")
sendWebhook("Vzro Hub V2 Executed", "User: " .. LocalPlayer.Name .. " has started the script.", 65280)

Rayfield:Notify({
   Title = "Vzro Hub V2 Loaded",
   Content = "Dynamic Goal System Active! Check Settings to customize.",
   Duration = 5,
})

-- Auto-Load Configuration
Rayfield:LoadConfiguration()
