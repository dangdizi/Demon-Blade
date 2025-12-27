--================= SERVICES =================--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--================= PLAYER =================--
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--================= TELEPORT LIST =================--
local teleportPoints1 = {
    CFrame.new(-157.5720, 28.1144, -282.3664),
    CFrame.new(899.0273, 55.8635, -2759.9617),
    CFrame.new(-2999.3496, 116.6300, -1836.6725),
    CFrame.new(-2776.2346, 117.6525, 92.3870),
    CFrame.new(2815.0774, 71.7557, -181.7715),
    CFrame.new(-3465.4858, 83.6831, -6117.8452),
    CFrame.new(3365.3354, 73.6626, -5544.4155),
    CFrame.new(871.7140, 10.6555, 3908.3376),
    CFrame.new(4184.3506, 7.6544, -3077.3330),
    CFrame.new(-7538.6748, 176.1826, -5871.8657),
    CFrame.new(3036.1704, 85.3820, 1912.8035),
    CFrame.new(-6618.8247, 84.0118, -2550.0308),
    CFrame.new(-3010.2446, 62.2420, -8526.2725),
    CFrame.new(-5586.9849, 98.5747, 359.5127)
}

local teleportPoints2 = {
    CFrame.new(1476.4467, 2186.0842, 229.6751),
    CFrame.new(-632.0176, 2157.9177, 3352.4141),
    CFrame.new(4366.5767, 2231.7886, -2482.4802),
    CFrame.new(-2440.6157, 2178.1230, -1934.5195),
    CFrame.new(174.9412, 2166.7644, -4257.1714),
    CFrame.new(3468.3408, 2204.4983, -6875.7144)
}

--================= TELEPORT =================--

--================= COLLECT =================--
local CollectRF = ReplicatedStorage.FestivalActivities.ChristmasEvent.CollectReward.CollectRF
local folder = workspace.Folder_GameOutside.ChristmasEvent.Collect

-- Hàm collect
local function collectPart(part)
    local startTime = tick()
    local timeout = 2

    while tick() - startTime < timeout do
        char:PivotTo(CFrame.new(part.Position + Vector3.new(0, 1, 0)))

        local offsets = {
            Vector3.new(0,0,0),
            Vector3.new(0,2,0),
            Vector3.new(0,-2,0),
            Vector3.new(2,0,0),
            Vector3.new(-2,0,0),
            Vector3.new(0,0,2),
            Vector3.new(0,0,-2),
        }

        for _, off in ipairs(offsets) do
            humanoid:Move(off, true)
            task.wait(0.05)
        end

        pcall(function()
            CollectRF:InvokeServer("Find", part)
        end)

        task.wait(0.1)
    end
    local args = {
    [1] = "Claim",
    [2] = 17
}

game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.DailyTask.Events.TaskRF:InvokeServer(unpack(args))

local args = {
    [1] = "Claim",
    [2] = 18
}

game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.DailyTask.Events.TaskRF:InvokeServer(unpack(args))

local args = {
    [1] = "Claim",
    [2] = 19
}

game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.DailyTask.Events.TaskRF:InvokeServer(unpack(args))

end

--================= SORT OBJECT =================--
local priorityList = {} -- tên bắt đầu bằng L
local normalList = {}   -- còn lại



loadstring(game:HttpGet("https://raw.githubusercontent.com/dangdizi/DiziHub/refs/heads/main/UI-D2.0.lua"))()
local DiziGui = Dizi:new()
DiziGui:setTitle("Dizi Hub | Demon Blade")
local autoCollectTab = DiziGui:createTab(nil, "Auto Collect")
local autoCollectAction = DiziGui:createAction(true)
autoCollectAction:createLabel("Tu dong nhat xu", Color3.fromRGB(255,255,255))
local goldStatus = false
local blueStatus = false
autoCollectAction:createToggleSwitch("Collect Gold", function (status)
    goldStatus = status
end)
autoCollectAction:createToggleSwitch("Collect Blue", function (status)
    blueStatus = status
end)

autoCollectAction:createText("chon truoc khi nhat", Color3.fromRGB(255,255,255))
autoCollectAction:createHr()
local collectStatus = false
local teleportCollectStatus = false
function collect ()

    local list = (game.PlaceId == 98470671607734) and teleportPoints2 or teleportPoints1
    if not teleportCollectStatus then
        for _, cf in ipairs(list) do
            hrp.CFrame = cf + Vector3.new(0, 1, 0)
            task.wait(2)
        end
        for _, part in ipairs(folder:GetChildren()) do
            if part:IsA("BasePart") then
                if string.sub(part.Name, 1, 1) == "L" then
                    table.insert(priorityList, part)
                else
                    table.insert(normalList, part)
                end
            end
        end
    end
    
    teleportCollectStatus = true

    if (goldStatus) then
        for _, part in ipairs(priorityList) do
            collectPart(part)
        end
    end

    if (blueStatus) then
        for _, part in ipairs(normalList) do
            collectPart(part)
        end
    end
end

autoCollectAction:createButton("Auto Collect", "Collect", function()
    if not collectStatus then
        collectStatus = true
        collect()
        collectStatus = false
    end
end)
autoCollectTab:setAction(autoCollectAction)

-- teleport

local teleportTab = DiziGui:createTab(nil, "Teleport")
local teleportAction = DiziGui:createAction()
teleportAction:createLabel("Dich Chuyen map an")
teleportAction:createButton("Muzan raid", "Dich Chuyen", function ()
    game:GetService("TeleportService"):Teleport(124580522323509, game.Players.LocalPlayer)
end)

teleportAction:createButton("Summer Event", "Dich Chuyen", function ()
    game:GetService("TeleportService"):Teleport(18388152457, game.Players.LocalPlayer)
end)

teleportAction:createHr()

teleportTab:setAction(teleportAction)
