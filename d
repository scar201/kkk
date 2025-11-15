--[[
    ═══════════════════════════════════════════════════════════
    🔥 ULTIMATE RP GUI V4 - السكربت الأقوى!
    ═══════════════════════════════════════════════════════════
    
    ✅ تجاوز حماية كامل
    ✅ نسخ الماب بالكامل + تحميل
    ✅ كل المقالب والميزات
    ✅ استخراج السكربتات
    
    🎯 افتح القائمة: F12
    
    ═══════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- المتغيرات
-- ═══════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = Player:WaitForChild("Backpack")

local SelectedPlayer = nil
local BypassedAC = 0
local CopiedMap = nil
local ExtractedScripts = {}

-- حالات
local Flying = false
local Noclipping = false
local ESPEnabled = false

-- ═══════════════════════════════════════════════════════════
-- BYPASS الكامل والأقوى
-- ═══════════════════════════════════════════════════════════
print("═══════════════════════════════════════")
print("🛡️ [BYPASS] بدء تجاوز الحماية الكامل...")
print("═══════════════════════════════════════")

-- تعطيل Anti-Cheat Scripts
local ACNames = {
    "AntiCheat", "AC", "AntiExploit", "AE", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard", "Shield",
    "AntiSpeed", "AntiTeleport", "AntiFly", "AntiNoclip", "Anticheat",
    "ANTICHEAT", "anticheat", "AntiScript", "Secure", "Ban", "Kick"
}

-- تعطيل في كل الأماكن
local Locations = {
    Workspace, 
    RS, 
    game:GetService("ReplicatedFirst"),
    Player.PlayerScripts, 
    Player.PlayerGui,
    game:GetService("StarterGui"),
    game:GetService("StarterPlayer").StarterPlayerScripts,
    Lighting
}

for _, Location in pairs(Locations) do
    for _, ACName in pairs(ACNames) do
        pcall(function()
            local AC = Location:FindFirstChild(ACName, true)
            if AC then
                AC:Destroy()
                BypassedAC = BypassedAC + 1
                print("  ✅ تم تعطيل: " .. ACName)
            end
        end)
    end
end

-- تعطيل جميع LocalScripts المشبوهة
for _, Script in pairs(Player.PlayerScripts:GetDescendants()) do
    if Script:IsA("LocalScript") or Script:IsA("Script") then
        local ScriptName = string.lower(Script.Name)
        if string.match(ScriptName, "anti") or string.match(ScriptName, "kick") or 
           string.match(ScriptName, "ban") or string.match(ScriptName, "detect") or
           string.match(ScriptName, "secure") then
            pcall(function()
                Script.Disabled = true
                Script:Destroy()
                BypassedAC = BypassedAC + 1
                print("  ✅ تم إيقاف: " .. Script.Name)
            end)
        end
    end
end

-- Kick Protection (أقوى نسخة)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- منع Kick
        if method == "Kick" and self == Player then
            print("🛡️ تم منع محاولة طرد!")
            return
        end
        
        -- منع FireServer الخبيثة
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = string.lower(tostring(self))
            if string.find(remoteName, "kick") or string.find(remoteName, "ban") then
                print("🛡️ تم منع RemoteEvent خبيث: " .. tostring(self))
                return
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("  ✅ Kick Protection مفعّل")
end)

-- Teleport Protection
pcall(function()
    local TS = game:GetService("TeleportService")
    TS.Teleport = function()
        print("🛡️ تم منع Teleport!")
        return
    end
    TS.TeleportToPlaceInstance = function()
        print("🛡️ تم منع TeleportToPlaceInstance!")
        return
    end
    print("  ✅ Teleport Protection مفعّل")
end)

-- Ghost Mode (إخفاء وجود Executor)
pcall(function()
    local HiddenFuncs = {
        "getrawmetatable", "hookmetamethod", "newcclosure", "setreadonly",
        "getnamecallmethod", "hookfunction", "getgc", "gcinfo", "getconnections"
    }
    
    for _, Func in pairs(HiddenFuncs) do
        getgenv()[Func] = nil
        _G[Func] = nil
    end
    print("  ✅ Ghost Mode مفعّل")
end)

print("\n✅ [BYPASS] مكتمل: " .. BypassedAC .. " حماية معطّلة")
print("═══════════════════════════════════════\n")

-- ═══════════════════════════════════════════════════════════
-- دوال مساعدة
-- ═══════════════════════════════════════════════════════════
local function Notify(Text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔥 RP GUI V4";
        Text = Text;
        Duration = 3;
    })
end

-- دالة حفظ الملف (سيُحفظ في Workspace)
local function SaveToFile(FileName, Content)
    local FilePath = FileName .. ".txt"
    writefile(FilePath, Content)
    return FilePath
end

-- ═══════════════════════════════════════════════════════════
-- دوال نسخ الماب
-- ═══════════════════════════════════════════════════════════
local function CopyObject(Obj)
    local Success, Clone = pcall(function()
        return Obj:Clone()
    end)
    if Success then
        return Clone
    end
    return nil
end

local function ExtractScripts()
    print("\n🔍 استخراج السكربتات...")
    ExtractedScripts = {}
    local ScriptCount = 0
    
    for _, Obj in pairs(Workspace:GetDescendants()) do
        if Obj:IsA("LocalScript") or Obj:IsA("Script") or Obj:IsA("ModuleScript") then
            pcall(function()
                local ScriptSource = decompile(Obj)
                if ScriptSource then
                    table.insert(ExtractedScripts, {
                        Name = Obj.Name,
                        Type = Obj.ClassName,
                        Path = Obj:GetFullName(),
                        Source = ScriptSource
                    })
                    ScriptCount = ScriptCount + 1
                    print("  ✅ " .. Obj.Name .. " (" .. Obj.ClassName .. ")")
                end
            end)
        end
    end
    
    print("\n✅ تم استخراج " .. ScriptCount .. " سكربت!")
    return ScriptCount
end

local function CopyMap()
    print("\n📦 بدء نسخ الماب...")
    Notify("📦 جاري النسخ...")
    
    local MapFolder = Instance.new("Folder")
    MapFolder.Name = "CopiedMap_" .. os.time()
    
    local CopiedCount = 0
    local FailedCount = 0
    
    -- نسخ Workspace
    for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj ~= Character and Obj ~= workspace.CurrentCamera and 
           not Players:GetPlayerFromCharacter(Obj) then
            
            local Clone = CopyObject(Obj)
            if Clone then
                Clone.Parent = MapFolder
                CopiedCount = CopiedCount + 1
                
                if CopiedCount % 50 == 0 then
                    print("  📦 تم نسخ: " .. CopiedCount .. " عنصر...")
                    wait(0.1)
                end
            else
                FailedCount = FailedCount + 1
            end
        end
    end
    
    MapFolder.Parent = Workspace
    CopiedMap = MapFolder
    
    print("\n✅ اكتمل النسخ!")
    print("  ✅ تم نسخ: " .. CopiedCount .. " عنصر")
    print("  ❌ فشل: " .. FailedCount .. " عنصر")
    
    return MapFolder, CopiedCount
end

local function ExportMapData()
    if not CopiedMap then
        Notify("⚠️ انسخ الماب أولاً!")
        return
    end
    
    print("\n💾 جاري تصدير بيانات الماب...")
    
    local MapData = {
        Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        PlaceId = game.PlaceId,
        ExportTime = os.date("%Y-%m-%d %H:%M:%S"),
        Objects = {},
        Scripts = ExtractedScripts
    }
    
    local function GetObjectData(Obj)
        local Data = {
            Name = Obj.Name,
            ClassName = Obj.ClassName,
            Properties = {}
        }
        
        if Obj:IsA("BasePart") then
            Data.Properties = {
                Size = tostring(Obj.Size),
                Position = tostring(Obj.Position),
                Color = tostring(Obj.Color),
                Material = tostring(Obj.Material),
                Transparency = Obj.Transparency
            }
        end
        
        return Data
    end
    
    for _, Obj in pairs(CopiedMap:GetDescendants()) do
        table.insert(MapData.Objects, GetObjectData(Obj))
    end
    
    local JsonData = HttpService:JSONEncode(MapData)
    
    -- حفظ في Workspace
    local DataFolder = Instance.new("Folder", Workspace)
    DataFolder.Name = "MapData_Export"
    
    local StringValue = Instance.new("StringValue", DataFolder)
    StringValue.Name = "MapJSON"
    StringValue.Value = JsonData
    
    print("✅ تم تصدير بيانات الماب!")
    print("  📁 الموقع: Workspace > MapData_Export")
    print("  📊 عدد العناصر: " .. #MapData.Objects)
    print("  📜 عدد السكربتات: " .. #MapData.Scripts)
    
    Notify("💾 تم التصدير في Workspace!")
    
    return DataFolder
end

local function SaveScriptsToFile()
    if #ExtractedScripts == 0 then
        Notify("⚠️ لا توجد سكربتات!")
        return
    end
    
    local AllScripts = "-- ═══════════════════════════════════════\n"
    AllScripts = AllScripts .. "-- 📜 السكربتات المستخرجة\n"
    AllScripts = AllScripts .. "-- 🎮 اللعبة: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n"
    AllScripts = AllScripts .. "-- 📅 التاريخ: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    AllScripts = AllScripts .. "-- ═══════════════════════════════════════\n\n"
    
    for i, ScriptData in pairs(ExtractedScripts) do
        AllScripts = AllScripts .. "\n\n-- ═══════════════════════════════════════\n"
        AllScripts = AllScripts .. "-- السكربت #" .. i .. "\n"
        AllScripts = AllScripts .. "-- الاسم: " .. ScriptData.Name .. "\n"
        AllScripts = AllScripts .. "-- النوع: " .. ScriptData.Type .. "\n"
        AllScripts = AllScripts .. "-- المسار: " .. ScriptData.Path .. "\n"
        AllScripts = AllScripts .. "-- ═══════════════════════════════════════\n\n"
        AllScripts = AllScripts .. ScriptData.Source .. "\n"
    end
    
    -- حفظ في StringValue
    local ScriptsFolder = Instance.new("Folder", Workspace)
    ScriptsFolder.Name = "ExtractedScripts_" .. os.time()
    
    local StringValue = Instance.new("StringValue", ScriptsFolder)
    StringValue.Name = "AllScripts"
    StringValue.Value = AllScripts
    
    print("✅ تم حفظ السكربتات!")
    print("  📁 الموقع: Workspace > " .. ScriptsFolder.Name)
    
    Notify("📜 تم حفظ السكربتات!")
    
    return ScriptsFolder
end

-- ═══════════════════════════════════════════════════════════
-- إنشاء GUI
-- ═══════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RPGUIV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 750, 0, 520)
Main.Position = UDim2.new(0.5, -375, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- شريط العنوان
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
TopBar.BorderSizePixel = 0

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 ULTIMATE RP GUI V4 - THE STRONGEST"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local BypassText = Instance.new("TextLabel", TopBar)
BypassText.Size = UDim2.new(0, 300, 1, 0)
BypassText.Position = UDim2.new(1, -310, 0, 0)
BypassText.BackgroundTransparency = 1
BypassText.Text = "🛡️ BYPASS: " .. BypassedAC .. " حماية ✅"
BypassText.TextColor3 = Color3.fromRGB(0, 255, 150)
BypassText.TextSize = 13
BypassText.Font = Enum.Font.GothamBold
BypassText.TextXAlignment = Enum.TextXAlignment.Right

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- الشريط الجانبي
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, -60)
Sidebar.Position = UDim2.new(0, 8, 0, 58)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.BorderSizePixel = 0

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 6)

-- المحتوى
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -198, 1, -68)
Content.Position = UDim2.new(0, 193, 0, 58)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 8
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 100)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)

Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 12)

local ContentList = Instance.new("UIListLayout", Content)
ContentList.Padding = UDim.new(0, 8)

ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
end)

-- ═══════════════════════════════════════════════════════════
-- دوال إنشاء العناصر
-- ═══════════════════════════════════════════════════════════
local function Clear()
    for _, v in pairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
end

local function CreateTab(Name, Icon)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -10, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = Icon .. "  " .. Name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0, 12)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    return Btn
end

local function CreateButton(Text, Icon, Callback)
    local Btn = Instance.new("TextButton", Content)
    Btn.Size = UDim2.new(1, -20, 0, 48)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
    Btn.Text = Icon .. "  " .. Text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    Btn.MouseButton1Click:Connect(Callback)
    return Btn
end

local function CreateToggle(Text, Icon, Callback)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -20, 0, 52)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Icon .. "  " .. Text
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Toggle = Instance.new("TextButton", Frame)
    Toggle.Size = UDim2.new(0, 55, 0, 32)
    Toggle.Position = UDim2.new(1, -62, 0.5, -16)
    Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 13
    Toggle.Font = Enum.Font.GothamBold
    
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)
    
    local State = false
    Toggle.MouseButton1Click:Connect(function()
        State = not State
        Toggle.BackgroundColor3 = State and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 80)
        Toggle.Text = State and "ON" or "OFF"
        Callback(State)
    end)
end

local function CreatePlayerSelector()
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -20, 0, 220)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 35)
    Label.Position = UDim2.new(0, 10, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = "🎯  اختر لاعب:"
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Search = Instance.new("TextBox", Frame)
    Search.Size = UDim2.new(1, -20, 0, 38)
    Search.Position = UDim2.new(0, 10, 0, 48)
    Search.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Search.PlaceholderText = "ابحث..."
    Search.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    Search.Text = ""
    Search.TextColor3 = Color3.new(1, 1, 1)
    Search.TextSize = 14
    Search.Font = Enum.Font.Gotham
    Search.ClearTextOnFocus = false
    
    Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)
    
    local List = Instance.new("ScrollingFrame", Frame)
    List.Size = UDim2.new(1, -20, 0, 120)
    List.Position = UDim2.new(0, 10, 0, 92)
    List.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 5
    List.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 100)
    
    Instance.new("UICorner", List).CornerRadius = UDim.new(0, 8)
    
    local ListLayout = Instance.new("UIListLayout", List)
    ListLayout.Padding = UDim.new(0, 3)
    
    local function UpdateList(Filter)
        for _, v in pairs(List:GetChildren()) do
            if v:IsA("TextButton") then
                v:Destroy()
            end
        end
        
        for _, Plr in pairs(Players:GetPlayers()) do
            if Plr ~= Player then
                local Name = Plr.Name
                if Filter == "" or string.find(string.lower(Name), string.lower(Filter)) then
                    local Btn = Instance.new("TextButton", List)
                    Btn.Size = UDim2.new(1, -8, 0, 32)
                    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    Btn.Text = Name
                    Btn.TextColor3 = Color3.new(1, 1, 1)
                    Btn.TextSize = 13
                    Btn.Font = Enum.Font.Gotham
                    Btn.TextXAlignment = Enum.TextXAlignment.Left
                    
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
                    Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0, 10)
                    
                    Btn.MouseButton1Click:Connect(function()
                        SelectedPlayer = Plr
                        Notify("✅ تم اختيار: " .. Name)
                        
                        for _, Other in pairs(List:GetChildren()) do
                            if Other:IsA("TextButton") then
                                Other.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                            end
                        end
                        Btn.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
                    end)
                end
            end
        end
        
        List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
    end
    
    Search:GetPropertyChangedSignal("Text"):Connect(function()
        UpdateList(Search.Text)
    end)
    
    UpdateList("")
end

-- ═══════════════════════════════════════════════════════════
-- التبويبات
-- ═══════════════════════════════════════════════════════════

-- تبويب نسخ الماب (الأقوى!)
local CopyMapTab = CreateTab("نسخ الماب", "📦")
CopyMapTab.MouseButton1Click:Connect(function()
    Clear()
    
    -- تحذير
    local Warning = Instance.new("Frame", Content)
    Warning.Size = UDim2.new(1, -20, 0, 150)
    Warning.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    
    Instance.new("UICorner", Warning).CornerRadius = UDim.new(0, 10)
    
    local WarningText = Instance.new("TextLabel", Warning)
    WarningText.Size = UDim2.new(1, -20, 1, -20)
    WarningText.Position = UDim2.new(0, 10, 0, 10)
    WarningText.BackgroundTransparency = 1
    WarningText.Text = [[
⚠️ تحذير!
━━━━━━━━━━━━━━━━━━
النسخ قد يستغرق وقت طويل!

💾 سيتم الحفظ في:
  • Workspace > CopiedMap
  • Workspace > MapData_Export
  • Workspace > ExtractedScripts

✅ اضغط الأزرار بالترتيب!
]]
    WarningText.TextColor3 = Color3.new(1, 1, 1)
    WarningText.TextSize = 14
    WarningText.Font = Enum.Font.GothamBold
    WarningText.TextXAlignment = Enum.TextXAlignment.Left
    WarningText.TextYAlignment = Enum.TextYAlignment.Top
    
    CreateButton("1️⃣ نسخ الماب بالكامل", "📦", function()
        Notify("📦 جاري النسخ... قد يستغرق دقائق!")
        
        spawn(function()
            local MapFolder, Count = CopyMap()
            Notify("✅ تم نسخ " .. Count .. " عنصر!")
        end)
    end)
    
    CreateButton("2️⃣ استخراج السكربتات", "📜", function()
        Notify("🔍 جاري الاستخراج...")
        
        spawn(function()
            local Count = ExtractScripts()
            if Count > 0 then
                SaveScriptsToFile()
            else
                Notify("⚠️ لم يتم العثور على سكربتات!")
            end
        end)
    end)
    
    CreateButton("3️⃣ تصدير البيانات كـ JSON", "💾", function()
        Notify("💾 جاري التصدير...")
        
        spawn(function()
            ExportMapData()
        end)
    end)
    
    CreateButton("📋 عرض الملفات المحفوظة", "📁", function()
        print("\n📁 الملفات المحفوظة:")
        print("═══════════════════════════════════════")
        
        local Files = {}
        for _, Obj in pairs(Workspace:GetChildren()) do
            if string.find(Obj.Name, "CopiedMap") or 
               string.find(Obj.Name, "MapData") or 
               string.find(Obj.Name, "ExtractedScripts") then
                table.insert(Files, Obj.Name)
                print("  📁 " .. Obj.Name)
            end
        end
        
        print("═══════════════════════════════════════")
        print("📊 إجمالي: " .. #Files .. " مجلد")
        
        Notify("📁 تحقق من Output! (F9)")
    end)
    
    CreateButton("🗑️ حذف جميع الملفات", "🗑️", function()
        for _, Obj in pairs(Workspace:GetChildren()) do
            if string.find(Obj.Name, "CopiedMap") or 
               string.find(Obj.Name, "MapData") or 
               string.find(Obj.Name, "ExtractedScripts") then
                Obj:Destroy()
            end
        end
        Notify("🗑️ تم الحذف!")
    end)
end)

-- تبويب الأسلحة
local WeaponsTab = CreateTab("أسلحة", "🔫")
WeaponsTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreateButton("جلب جميع الأسلحة", "🔫", function()
        Notify("🔍 جاري البحث...")
        local Found = 0
        
        for _, Item in pairs(RS:GetDescendants()) do
            if Item:IsA("Tool") then
                pcall(function()
                    Item:Clone().Parent = Backpack
                    Found = Found + 1
                    wait(0.02)
                end)
            end
        end
        
        for _, Item in pairs(Workspace:GetDescendants()) do
            if Item:IsA("Tool") and Item:FindFirstChild("Handle") then
                pcall(function()
                    Item:Clone().Parent = Backpack
                    Found = Found + 1
                    wait(0.02)
                end)
            end
        end
        
        Notify("✅ " .. Found .. " سلاح!")
    end)
    
    CreateButton("تعديل الأسلحة", "⚡", function()
        local Modified = 0
        for _, Tool in pairs(Backpack:GetChildren()) do
            if Tool:IsA("Tool") then
                for _, Child in pairs(Tool:GetDescendants()) do
                    if Child:IsA("IntValue") or Child:IsA("NumberValue") then
                        pcall(function()
                            local N = string.lower(Child.Name)
                            if string.find(N, "ammo") then Child.Value = 999999 end
                            if string.find(N, "damage") then Child.Value = 999 end
                            if string.find(N, "fire") or string.find(N, "cool") then Child.Value = 0.01 end
                            if string.find(N, "recoil") or string.find(N, "spread") then Child.Value = 0 end
                        end)
                    end
                end
                Modified = Modified + 1
            end
        end
        Notify("⚡ " .. Modified .. " سلاح!")
    end)
    
    CreateButton("أدوات خاصة", "🔑", function()
        local Found = 0
        local Keywords = {"key", "phone", "card", "badge", "radio", "handcuff", "taser", "baton"}
        for _, Item in pairs(RS:GetDescendants()) do
            if Item:IsA("Tool") then
                local N = string.lower(Item.Name)
                for _, K in pairs(Keywords) do
                    if string.find(N, K) then
                        pcall(function()
                            Item:Clone().Parent = Backpack
                            Found = Found + 1
                        end)
                        break
                    end
                end
            end
        end
        Notify("✅ " .. Found .. " أداة!")
    end)
end)

-- تبويب الحركة
local MovementTab = CreateTab("حركة", "🚀")
MovementTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreateToggle("طيران", "🚀", function(State)
        Flying = State
        if State then
            local BV = Instance.new("BodyVelocity", RootPart)
            BV.Name = "FlyVel"
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BV.Velocity = Vector3.new(0, 0, 0)
            
            local BG = Instance.new("BodyGyro", RootPart)
            BG.Name = "FlyGyro"
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BG.P = 9e4
            
            spawn(function()
                while Flying and RootPart:FindFirstChild("FlyVel") do
                    local Cam = Workspace.CurrentCamera
                    BG.CFrame = Cam.CFrame
                    local Dir = Vector3.new(0, 0, 0)
                    local S = 50
                    if UIS:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Cam.CFrame.LookVector * S end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Cam.CFrame.LookVector * S end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Cam.CFrame.RightVector * S end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Cam.CFrame.RightVector * S end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then Dir = Dir + Vector3.new(0, S, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then Dir = Dir - Vector3.new(0, S, 0) end
                    BV.Velocity = Dir
                    wait()
                end
            end)
            Notify("🚀 طيران مفعّل!")
        else
            if RootPart:FindFirstChild("FlyVel") then RootPart.FlyVel:Destroy() end
            if RootPart:FindFirstChild("FlyGyro") then RootPart.FlyGyro:Destroy() end
            Notify("🚀 طيران معطّل")
        end
    end)
    
    CreateToggle("Noclip", "👻", function(State)
        Noclipping = State
        if State then
            spawn(function()
                while Noclipping do
                    for _, Part in pairs(Character:GetDescendants()) do
                        if Part:IsA("BasePart") then
                            Part.CanCollide = false
                        end
                    end
                    wait()
                end
            end)
            Notify("👻 Noclip مفعّل!")
        else
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
                    Part.CanCollide = true
                end
            end
            Notify("👻 Noclip معطّل")
        end
    end)
    
    CreateButton("سرعة 100", "⚡", function()
        Humanoid.WalkSpeed = 100
        Notify("⚡ سرعة 100!")
    end)
    
    CreateButton("سرعة عادية", "🚶", function()
        Humanoid.WalkSpeed = 16
        Notify("🚶 سرعة عادية")
    end)
    
    CreateButton("قفز عالي", "🦘", function()
        Humanoid.JumpPower = 150
        Humanoid.JumpHeight = 100
        Notify("🦘 قفز عالي!")
    end)
    
    CreateButton("Teleport للاعب", "📍", function()
        if SelectedPlayer and SelectedPlayer.Character then
            RootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Notify("📍 تم النقل!")
        else
            Notify("⚠️ اختر لاعب!")
        end
    end)
end)

-- تبويب الحماية
local ProtectionTab = CreateTab("حماية", "🛡️")
ProtectionTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreateButton("God Mode", "🛡️", function()
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.HealthChanged:Connect(function()
            Humanoid.Health = math.huge
        end)
        Notify("🛡️ God Mode!")
    end)
    
    CreateToggle("ESP", "🎯", function(State)
        ESPEnabled = State
        if State then
            for _, Plr in pairs(Players:GetPlayers()) do
                if Plr ~= Player and Plr.Character then
                    pcall(function()
                        local H = Instance.new("Highlight", Plr.Character)
                        H.Name = "ESP"
                        H.FillColor = Color3.fromRGB(255, 50, 50)
                        H.OutlineColor = Color3.new(1, 1, 1)
                        H.FillTransparency = 0.5
                        
                        local Head = Plr.Character:FindFirstChild("Head")
                        if Head then
                            local BB = Instance.new("BillboardGui", Head)
                            BB.Name = "ESPName"
                            BB.Adornee = Head
                            BB.Size = UDim2.new(0, 200, 0, 50)
                            BB.StudsOffset = Vector3.new(0, 3, 0)
                            BB.AlwaysOnTop = true
                            
                            local TL = Instance.new("TextLabel", BB)
                            TL.Size = UDim2.new(1, 0, 1, 0)
                            TL.BackgroundTransparency = 1
                            TL.Text = Plr.Name
                            TL.TextColor3 = Color3.new(1, 1, 1)
                            TL.TextSize = 18
                            TL.Font = Enum.Font.GothamBold
                            TL.TextStrokeTransparency = 0
                        end
                    end)
                end
            end
            Notify("🎯 ESP مفعّل!")
        else
            for _, Plr in pairs(Players:GetPlayers()) do
                if Plr.Character then
                    pcall(function()
                        if Plr.Character:FindFirstChild("ESP") then
                            Plr.Character.ESP:Destroy()
                        end
                        local Head = Plr.Character:FindFirstChild("Head")
                        if Head and Head:FindFirstChild("ESPName") then
                            Head.ESPName:Destroy()
                        end
                    end)
                end
            end
            Notify("🎯 ESP معطّل")
        end
    end)
end)

-- تبويب المقالب
local PranksTab = CreateTab("مقالب", "😈")
PranksTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreatePlayerSelector()
    
    CreateButton("💥 تفجير", "💥", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        local Exp = Instance.new("Explosion", Workspace)
        Exp.Position = SelectedPlayer.Character.HumanoidRootPart.Position
        Exp.BlastRadius = 30
        Exp.BlastPressure = 1000000
        Notify("💥 تم!")
    end)
    
    CreateButton("🚀 رمي للسماء", "🚀", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        local BV = Instance.new("BodyVelocity", SelectedPlayer.Character.HumanoidRootPart)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 500, 0)
        wait(1)
        BV:Destroy()
        Notify("🚀 تم!")
    end)
    
    CreateButton("🌪️ دوران", "🌪️", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        local Spin = Instance.new("BodyAngularVelocity", SelectedPlayer.Character.HumanoidRootPart)
        Spin.MaxTorque = Vector3.new(0, 9e9, 0)
        Spin.AngularVelocity = Vector3.new(0, 150, 0)
        Notify("🌪️ يدور!")
    end)
    
    CreateButton("🔥 حرق", "🔥", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        for _, Part in pairs(SelectedPlayer.Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Instance.new("Fire", Part).Size = 15
            end
        end
        Notify("🔥 يحترق!")
    end)
    
    CreateButton("⚡ كهرباء", "⚡", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        for i = 1, 5 do
            Instance.new("Sparkles", SelectedPlayer.Character.HumanoidRootPart).SparkleColor = Color3.fromRGB(100, 200, 255)
        end
        Notify("⚡ مصعوق!")
    end)
    
    CreateButton("🌈 ألوان قوس قزح", "🌈", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        spawn(function()
            for i = 1, 50 do
                for _, Part in pairs(SelectedPlayer.Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.BrickColor = BrickColor.Random()
                    end
                end
                wait(0.1)
            end
        end)
        Notify("🌈 ألوان!")
    end)
    
    CreateButton("❄️ تجميد", "❄️", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        for _, Part in pairs(SelectedPlayer.Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.Anchored = true
            end
        end
        Notify("❄️ مجمّد!")
    end)
    
    CreateButton("🔓 فك التجميد", "🔓", function()
        if not SelectedPlayer or not SelectedPlayer.Character then
            Notify("⚠️ اختر لاعب!")
            return
        end
        
        for _, Part in pairs(SelectedPlayer.Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.Anchored = false
            end
        end
        Notify("🔓 تم!")
    end)
end)

-- تبويب السيارات
local CarsTab = CreateTab("سيارات", "🚗")
CarsTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreateButton("فتح جميع السيارات", "🚗", function()
        local Unlocked = 0
        for _, Vehicle in pairs(Workspace:GetDescendants()) do
            if Vehicle:IsA("VehicleSeat") then
                pcall(function()
                    Vehicle.Disabled = false
                    Vehicle.MaxSpeed = 200
                    Unlocked = Unlocked + 1
                end)
            end
        end
        Notify("🚗 " .. Unlocked .. " سيارة!")
    end)
    
    CreateButton("سرعة × 5", "🏎️", function()
        for _, Vehicle in pairs(Workspace:GetDescendants()) do
            if Vehicle:IsA("VehicleSeat") then
                pcall(function()
                    Vehicle.MaxSpeed = Vehicle.MaxSpeed * 5
                end)
            end
        end
        Notify("🏎️ تم!")
    end)
end)

-- تبويب العالم
local WorldTab = CreateTab("العالم", "🌍")
WorldTab.MouseButton1Click:Connect(function()
    Clear()
    
    CreateButton("نهار", "🌅", function()
        Lighting.TimeOfDay = "12:00:00"
        Notify("🌅 النهار")
    end)
    
    CreateButton("ليل", "🌙", function()
        Lighting.TimeOfDay = "00:00:00"
        Notify("🌙 الليل")
    end)
    
    CreateButton("ألوان مجنونة", "🌈", function()
        Lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        Notify("🌈 ألوان!")
    end)
    
    CreateButton("انفجارات عشوائية", "💥", function()
        spawn(function()
            for i = 1, 30 do
                local Exp = Instance.new("Explosion", Workspace)
                Exp.Position = Vector3.new(math.random(-500, 500), math.random(0, 100), math.random(-500, 500))
                Exp.BlastRadius = 25
                wait(0.2)
            end
        end)
        Notify("💥 انفجارات!")
    end)
end)

-- تبويب الإعدادات
local SettingsTab = CreateTab("إعدادات", "⚙️")
SettingsTab.MouseButton1Click:Connect(function()
    Clear()
    
    local Info = Instance.new("Frame", Content)
    Info.Size = UDim2.new(1, -20, 0, 280)
    Info.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 10)
    
    local InfoText = Instance.new("TextLabel", Info)
    InfoText.Size = UDim2.new(1, -20, 1, -20)
    InfoText.Position = UDim2.new(0, 10, 0, 10)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = string.format([[
🔥 ULTIMATE RP GUI V4
═══════════════════════════════════

🛡️ حالة الحماية:
  ✅ Bypass: %d حماية معطّلة
  ✅ Kick Protection
  ✅ Teleport Protection
  ✅ Ghost Mode

📊 معلومات:
  👤 الاسم: %s
  🆔 ID: %d
  🎮 اللعبة: %s

⌨️ الاختصار:
  F12 = فتح/إغلاق

💾 ملفات النسخ:
  • CopiedMap = الماب المنسوخ
  • MapData_Export = JSON Data
  • ExtractedScripts = السكربتات

📝 ملاحظة:
  كل الملفات محفوظة في Workspace
  افتح F9 لرؤية التفاصيل

⚠️ استخدم على مسؤوليتك!
]], BypassedAC, Player.Name, Player.UserId, game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    InfoText.TextColor3 = Color3.new(1, 1, 1)
    InfoText.TextSize = 12
    InfoText.Font = Enum.Font.Code
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.TextYAlignment = Enum.TextYAlignment.Top
    
    CreateButton("إعادة تحميل", "🔄", function()
        ScreenGui:Destroy()
        Notify("🔄 إعادة تحميل...")
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scar201/snsladk/refs/heads/main/s"))()
    end)
    
    CreateButton("إغلاق", "❌", function()
        ScreenGui:Destroy()
        Notify("👋 تم الإغلاق")
    end)
end)

-- ═══════════════════════════════════════════════════════════
-- فتح/إغلاق بـ F12
-- ═══════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    
    if Input.KeyCode == Enum.KeyCode.F12 then
        Main.Visible = not Main.Visible
        if Main.Visible then
            CopyMapTab.MouseButton1Click()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- بدء التشغيل
-- ═══════════════════════════════════════════════════════════
print("\n═══════════════════════════════════════")
print("🔥 ULTIMATE RP GUI V4 - THE STRONGEST!")
print("═══════════════════════════════════════")
print("🛡️ Bypass: " .. BypassedAC .. " حماية معطّلة")
print("⌨️ F12 = فتح القائمة")
print("📦 نسخ الماب متاح!")
print("💾 الملفات تُحفظ في Workspace")
print("═══════════════════════════════════════\n")

Notify("🔥 GUI V4 جاهز! اضغط F12")

-- فتح تلقائي
wait(1.5)
Main.Visible = true
CopyMapTab.MouseButton1Click()
