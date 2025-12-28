loadstring(game:HttpGet("https://raw.githubusercontent.com/dangdizi/DiziHub/refs/heads/main/UI-D2.0.lua"))()
local DiziGui = Dizi:new()

DiziGui:setTitle("Dizi Hub | Demon Blade")

-- một số biến có sẵn cho các DEV
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local IsDie = false

local function BindHumanoid(humanoid)
    humanoid.Died:Connect(function()
        IsDie = true
    end)
end

BindHumanoid(Humanoid)

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    Humanoid = newCharacter:WaitForChild("Humanoid")
    IsDie = false
    BindHumanoid(Humanoid)
end)




local ChristmasEventTab = DiziGui:createTab(nil, "Christmas Event")
local ChristmasEventAction = DiziGui:createAction(true)

-- ===== nhận thưởng =====
ChristmasEventAction:createLabel("Nhận thưởng hằng ngày", Color3.fromRGB(247, 113, 113))
ChristmasEventAction:createButton("Thưởng hằng giờ", "Nhận thưởng", function()
    local BigTree = workspace.Folder_GameOutside.EventMapOutside.BigTree
    HumanoidRootPart.CFrame = CFrame.new(BigTree:GetPivot() * Vector3.new(0,3,0))
    local Npc = workspace.Folder_GameOutside.ChristmasEvent.HourNpcGift.HourNpc
    local NpcHumanoidRootPart = Npc:FindFirstChild("HumanoidRootPart") or Npc:FindFirstChildWhichIsA("BasePart")
    HumanoidRootPart.CFrame = NpcHumanoidRootPart.CFrame * CFrame.new(0,3,0)
    task.wait(1)

    local args = {
        [1] = "Find",
        [2] = Npc.TouchPart.TouchPart
    }
    game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.HourNpcGift.CollectRF:InvokeServer(unpack(args))
end)
ChristmasEventAction:createButton("Thưởng hằng ngày", "Nhận thưởng", function()
    local BigTree = workspace.Folder_GameOutside.EventMapOutside.BigTree
    HumanoidRootPart.CFrame = CFrame.new(BigTree:GetPivot() * Vector3.new(0,3,0))
    local Box = workspace.Folder_GameOutside.ChristmasEvent.DayChest:GetChildren()[1]
    HumanoidRootPart.CFrame = CFrame.new (Box:getPivot() * Vector3.new(0, 3, 0))
    task.wait(0.5)
    local args = {
        [1] = "Find",
        [2] = Box
    }
    game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.DayChest.CollectRF:InvokeServer(unpack(args))
end)
ChristmasEventAction:createHr()

-- ===== Nhặt xu =====
local GoldStatus = false
local BlueStatus = false
local IsCollecting = false
local IsTeleported = false
local IsAutoConfirm = false
local GoldCoin = {}
local BlueCoin = {}
local TeleportPoints1 = {
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
local TeleportPoints2 = {
    CFrame.new(1476.4467, 2186.0842, 229.6751),
    CFrame.new(1443.9968, 2480.4644, 1372.7373),
    CFrame.new(81.4240, 2555.2900, 1271.4413),
    CFrame.new(-632.0176, 2157.9177, 3352.4141),
    CFrame.new(4366.5767, 2231.7886, -2482.4802),
    CFrame.new(4458.6626, 2797.0471, -2489.2322),
    CFrame.new(4708.2837, 3665.0085, -2466.6021),
    CFrame.new(-2890.4705, 2537.6365, -2030.8273),
    CFrame.new(-2921.7197, 3106.6506, -1944.9642),
    CFrame.new(-2440.6157, 2178.1230, -1934.5195),
    CFrame.new(174.9412, 2166.7644, -4257.1714),
    CFrame.new(-34.6641, 2268.6479, -4983.4814),
    CFrame.new(3468.3408, 2204.4983, -6875.7144),
    CFrame.new(4397.0356, 2395.7876, -6392.8174),
    CFrame.new(4453.9624, 2611.7529, -6869.8496),
    CFrame.new(4762.5820, 2617.3152, -6967.8115)
}
local function CollectPart(part)
    local StartTime = tick()
    local Timeout = 2

    while tick() - StartTime < Timeout do
        Character:PivotTo(CFrame.new(part.Position + Vector3.new(0, 1, 0)))

        local Offsets = {
            Vector3.new(0, 0, 0),
            Vector3.new(0, 2, 0),
            Vector3.new(0, -2, 0),
            Vector3.new(2, 0, 0),
            Vector3.new(-2, 0, 0),
            Vector3.new(0, 0, 2),
            Vector3.new(0, 0, -2),
        }

        for _, Off in ipairs(Offsets) do
            Humanoid:Move(Off, true)
            task.wait(0.05)
        end

        pcall(function()
            game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.CollectReward.CollectRF:InvokeServer(
                "Find", part)
        end)

        task.wait(0.1)
    end

    if IsAutoConfirm then
        local TaskRF = game:GetService("ReplicatedStorage")
            .FestivalActivities
            .ChristmasEvent
            .DailyTask
            .Events
            .TaskRF
    
        for Id = 17, 19 do
            TaskRF:InvokeServer("Claim", Id)
        end
    end
end


local function Collect()
    local List = (game.PlaceId == 98470671607734) and TeleportPoints2 or TeleportPoints1
    if not IsTeleported then
        for _, Cframe in ipairs(List) do
            if IsDie then
                continue
            end
            HumanoidRootPart.CFrame = Cframe + Vector3.new(0, 1, 0)
            task.wait(2)
        end
        IsTeleported = true
    end

    for _, Part in ipairs(workspace.Folder_GameOutside.ChristmasEvent.Collect:GetChildren()) do
        if Part:IsA("BasePart") then
            if string.sub(Part.Name, 1, 1) == "L" then
                table.insert(GoldCoin, Part)
            else
                table.insert(BlueCoin, Part)
            end
        end
    end

    if GoldStatus then
        for _, Part in ipairs(GoldCoin) do
            if IsDie or not GoldStatus then
                continue
            end
            CollectPart(Part)
        end
    end

    if BlueStatus then
        for _, Part in ipairs(BlueCoin) do
            if IsDie or not BlueStatus then
                continue
            end
            CollectPart(Part)
        end
    end
end

ChristmasEventAction:createLabel("Nhặt vật phẩm", Color3.fromRGB(85, 255, 241))
ChristmasEventAction:createToggleSwitch("Nhặt xu băng vàng", function(status)
    GoldStatus = status
end)
ChristmasEventAction:createToggleSwitch("Nhặt xu băng xanh", function(status)
    BlueStatus = status
end)
ChristmasEventAction:createToggleSwitch("Nhận xu nhiệm vụ", function(status)
    IsAutoConfirm = status
end)
ChristmasEventAction:createButton("Tự động nhặt xu", "Bắt đầu", function()
    Collect()
end)
ChristmasEventAction:createHr()
ChristmasEventAction:createText("Shop sự kiện", Color3.fromRGB(238, 252, 110))
ChristmasEventAction:createButton("Mua xu vàng", "Mua", function()
    local args = {
        [1] = "Buy",
        [2] = "daily",
        [3] = "d2"
    }
    for i = 1, 5 do
        task.spawn(function ()
            pcall(function ()
                game:GetService("ReplicatedStorage").FestivalActivities.ChristmasEvent.EventShop.Events.Exchange:InvokeServer(unpack(args))
            end)
        end)
    end
end)
ChristmasEventTab:setAction(ChristmasEventAction)


-- ===== Teleport ======
local TeleportTab = DiziGui:createTab(nil, "Teleport")
local TeleportAction = DiziGui:createAction()

TeleportAction:createLabel("Dịch chuyển các map", Color3.fromRGB(164, 255, 111))

if game.PlaceId ~= 98470671607734 then
    TeleportAction:createDropdown("Danh sách map", {
        { label = "Snow Village",       value = CFrame.new(-157.5720, 28.1144, -282.3664) },
        { label = "Training Forest",    value = CFrame.new(899.0273, 55.8635, -2759.9617) },
        { label = "Main Town",          value = CFrame.new(-2999.3496, 116.6300, -1836.6725) },
        { label = "Sakura Forest",      value = CFrame.new(-2776.2346, 117.6525, 92.3870) },
        { label = "Tamayo Home",        value = CFrame.new(2815.0774, 71.7557, -181.7715) },
        { label = "Deserted Village",   value = CFrame.new(-3465.4858, 83.6831, -6117.8452) },
        { label = "Spider Mountain",    value = CFrame.new(3365.3354, 73.6626, -5544.4155) },
        { label = "Hunter Home",        value = CFrame.new(871.7140, 10.6555, 3908.3376) },
        { label = "Train Station",      value = CFrame.new(4184.3506, 7.6544, -3077.3330) },
        { label = "Butterfly House",    value = CFrame.new(-7538.6748, 176.1826, -5871.8657) },
        { label = "Flower Street",      value = CFrame.new(3036.1704, 85.3820, 1912.8035) },
        { label = "Shrine Mountain",    value = CFrame.new(-6618.8247, 84.0118, -2550.0308) },
        { label = "Blackmisth Village", value = CFrame.new(-3010.2446, 62.2420, -8526.2725) },
        { label = "Training Canyon",    value = CFrame.new(-5586.9849, 98.5747, 359.5127) }
    }, function(position)
        HumanoidRootPart.CFrame = position.value -- đổi tọa độ tại đây
    end)

    TeleportAction:createDropdown("Danh sách NPC", {
        {label = "Breath Gacha", value = CFrame.new(0,0,0)},
        {label = "Demon Gacha", value = CFrame.new(0,0,0)},
        {label = "Breath Shop", value = CFrame.new(0,0,0)},
        {label = "Demon Shop", value = CFrame.new(0,0,0)},
        {label = "Echan", value = CFrame.new(0,0,0)},
        {label = "Create Item", value = CFrame.new(0,0,0)}
    }, function ()
        
    end)
else
    TeleportAction:createDropdown("Danh sách map", {
        { label = "Silvermoon Harbor",       value = CFrame.new(1476.4467, 2186.0842, 229.6751) },
        { label = "Mysterious Village",    value =  CFrame.new(-632.0176, 2157.9177, 3352.4141) },
        { label = "Thunder Island",          value = CFrame.new(4366.5767, 2231.7886, -2482.4802) },
        { label = "Music Island",      value = CFrame.new(-2440.6157, 2178.1230, -1934.5195) },
        { label = "Ice Castle",        value = CFrame.new(174.9412, 2166.7644, -4257.1714) },
        { label = "Lunar Goddess Palace",   value =  CFrame.new(3468.3408, 2204.4983, -6875.7144) }
    }, function(position)
        HumanoidRootPart.CFrame = position.value -- đổi tọa độ tại đây
    end)
end
TeleportAction:createHr()
TeleportAction:createText("Thế giới ẩn", Color3.fromRGB(248, 114, 114))
TeleportAction:createButton("Muzan Raid World", "Dịch chuyển", function ()
    game:GetService("TeleportService"):Teleport(124580522323509, Player)
end)
TeleportAction:createButton("Summer Event World", "Dịch chuyển", function ()
    game:GetService("TeleportService"):Teleport(18388152457, Player)
end)
TeleportTab:setAction(TeleportAction)


-- ===== Shop =====
local ShopTab = DiziGui:createTab(nil, "Shop")
local ShopAction = DiziGui:createAction ()

ShopAction:createLabel ("Chức năng Gacha", Color3.fromRGB(243, 255, 82))
ShopAction:createButton("Gacha Breath", "Get it", function ()
    local args = {
        [1] = "Buy",
        [2] = "RandomShop_Breath",
        [3] = "Breath"
    }
    game:GetService("ReplicatedStorage").Service.RandomShopService.Event.RemoteFunction_RandomShop:InvokeServer(unpack(args))
end)

ShopAction:createButton("Gacha Demon", "Get it", function ()
    local args = {
        [1] = "Buy",
        [2] = "RandomShop_Ghost",
        [3] = "Ghost"
    }
    game:GetService("ReplicatedStorage").Service.RandomShopService.Event.RemoteFunction_RandomShop:InvokeServer(unpack(args))
end)

ShopTab:setAction(ShopAction)
