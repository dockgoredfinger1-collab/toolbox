-- Toolbox Script by Claude
-- Compatible with Delta Executor & Studio Lite
-- Proxy: https://roblox-three-mauve.vercel.app/api/test

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("ToolboxGUI") then
    playerGui:FindFirstChild("ToolboxGUI"):Destroy()
end

local isOpen = false
local activeTab = "Models"
local PROXY_URL = "https://roblox-three-mauve.vercel.app/api/search"

-- ═══════════════════════════════════
--           SCREEN GUI
-- ═══════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolboxGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ═══════════════════════════════════
--         TOGGLE BUTTON 🔨
-- ═══════════════════════════════════
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -27)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ToggleButton.Text = "🔨"
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
local TS = Instance.new("UIStroke", ToggleButton)
TS.Color = Color3.fromRGB(120, 120, 120)
TS.Thickness = 2

ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(110,110,110)}):Play()
end)
ToggleButton.MouseLeave:Connect(function()
    if not isOpen then
        TweenService:Create(ToggleButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
    end
end)

-- ═══════════════════════════════════
--           MAIN FRAME
-- ═══════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 560)
MainFrame.Position = UDim2.new(0, 85, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MS = Instance.new("UIStroke", MainFrame)
MS.Color = Color3.fromRGB(70, 130, 255)
MS.Thickness = 1.5

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, 5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.ZIndex = 4
Shadow.Parent = MainFrame
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 14)

-- ═══════════════════════════════════
--           TITLE BAR
-- ═══════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TitleBar.ZIndex = 6
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)
local TFix = Instance.new("Frame", TitleBar)
TFix.Size = UDim2.new(1, 0, 0.5, 0)
TFix.Position = UDim2.new(0, 0, 0.5, 0)
TFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TFix.BorderSizePixel = 0
TFix.ZIndex = 6

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔨 Toolbox"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 7
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 8
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255,80,80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220,60,60)}):Play()
end)

-- ═══════════════════════════════════
--           TAB BAR
-- ═══════════════════════════════════
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TabBar.ZIndex = 6
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)
local TabPad = Instance.new("UIPadding", TabBar)
TabPad.PaddingLeft = UDim.new(0, 4)
TabPad.PaddingTop = UDim.new(0, 4)
TabPad.PaddingBottom = UDim.new(0, 4)

local tabs = {"Models", "Decals", "Audio", "Plugins"}
local tabButtons = {}
for i, name in ipairs(tabs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 90, 1, 0)
    b.BackgroundColor3 = (name == activeTab) and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(35, 35, 42)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Font = Enum.Font.GothamSemibold
    b.AutoButtonColor = false
    b.LayoutOrder = i
    b.ZIndex = 7
    b.Parent = TabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = b
end

-- ═══════════════════════════════════
--           SEARCH BAR
-- ═══════════════════════════════════
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 38)
SearchFrame.Position = UDim2.new(0, 10, 0, 92)
SearchFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
SearchFrame.ZIndex = 6
SearchFrame.Parent = MainFrame
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 8)
local SS = Instance.new("UIStroke", SearchFrame)
SS.Color = Color3.fromRGB(70, 130, 255)
SS.Thickness = 1

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Position = UDim2.new(0, 5, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 16
SearchIcon.ZIndex = 7
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -80, 1, 0)
SearchBox.Position = UDim2.new(0, 35, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "Search models..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 7
SearchBox.Parent = SearchFrame

local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0, 38, 0, 28)
SearchBtn.Position = UDim2.new(1, -42, 0.5, -14)
SearchBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
SearchBtn.Text = "Go"
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.TextSize = 13
SearchBtn.Font = Enum.Font.GothamBold
SearchBtn.AutoButtonColor = false
SearchBtn.ZIndex = 8
SearchBtn.Parent = SearchFrame
Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 6)

-- ═══════════════════════════════════
--         SCROLL / GRID
-- ═══════════════════════════════════
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -180)
ScrollFrame.Position = UDim2.new(0, 10, 0, 138)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ZIndex = 6
ScrollFrame.Parent = MainFrame
Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0, 8)

local Grid = Instance.new("UIGridLayout", ScrollFrame)
Grid.CellSize = UDim2.new(0, 118, 0, 148)
Grid.CellPadding = UDim2.new(0, 8, 0, 8)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
local GridPad = Instance.new("UIPadding", ScrollFrame)
GridPad.PaddingLeft = UDim.new(0, 8)
GridPad.PaddingTop = UDim.new(0, 8)

-- ═══════════════════════════════════
--           STATUS BAR
-- ═══════════════════════════════════
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -38)
StatusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
StatusBar.ZIndex = 6
StatusBar.Parent = MainFrame
Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 6)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 8, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready — Enter a keyword to search"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 7
StatusLabel.Parent = StatusBar

-- ═══════════════════════════════════
--             TOAST
-- ═══════════════════════════════════
local Toast = Instance.new("Frame")
Toast.Size = UDim2.new(0, 280, 0, 40)
Toast.Position = UDim2.new(0.5, -140, 1, 10)
Toast.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
Toast.ZIndex = 20
Toast.Parent = ScreenGui
Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 10)

local ToastLabel = Instance.new("TextLabel")
ToastLabel.Size = UDim2.new(1, -10, 1, 0)
ToastLabel.Position = UDim2.new(0, 8, 0, 0)
ToastLabel.BackgroundTransparency = 1
ToastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToastLabel.TextSize = 13
ToastLabel.Font = Enum.Font.GothamBold
ToastLabel.Text = "✅ Ready!"
ToastLabel.ZIndex = 21
ToastLabel.Parent = Toast

local function showToast(msg, color)
    Toast.BackgroundColor3 = color or Color3.fromRGB(40, 200, 100)
    ToastLabel.Text = msg
    TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -140, 1, -55)
    }):Play()
    task.delay(2.5, function()
        TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -140, 1, 10)
        }):Play()
    end)
end

-- ═══════════════════════════════════
--          INSERT ASSET
-- ═══════════════════════════════════
local function insertAsset(assetId)
    assetId = tonumber(assetId)
    if not assetId or assetId <= 0 then
        showToast("❌ ID tidak valid", Color3.fromRGB(200, 60, 60))
        return
    end
    showToast("🔄 Inserting ID: " .. assetId, Color3.fromRGB(255, 180, 0))
    
    -- Coba GetObjects dulu (works di Delta)
    local success, result = pcall(function()
        local objects = game:GetObjects("rbxassetid://" .. assetId)
        if objects and #objects > 0 then
            for _, obj in ipairs(objects) do
                obj.Parent = workspace
            end
            return true
        end
        return false
    end)
    
    if success and result then
        showToast("✅ Inserted! ID: " .. assetId, Color3.fromRGB(40, 200, 100))
        return
    end
    
    -- Fallback ke InsertService kalau GetObjects gagal
    local ok, err = pcall(function()
        local model = InsertService:LoadAsset(assetId)
        if model then
            model.Parent = workspace
        end
    end)
    
    if ok then
        showToast("✅ Inserted! ID: " .. assetId, Color3.fromRGB(40, 200, 100))
    else
        print("Insert Error:", err)
        showToast("❌ Gagal insert — lihat console", Color3.fromRGB(200, 60, 60))
    end
end

-- ═══════════════════════════════════
--          CREATE CARD
-- ═══════════════════════════════════
local function clearItems()
    for _, c in ipairs(ScrollFrame:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end
end

local function createCard(item, index)
    local assetId = tostring(item.id or item.AssetId or 0)
    local assetName = tostring(item.name or item.Name or "Unknown")

    local Card = Instance.new("Frame")
    Card.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Card.ZIndex = 7
    Card.LayoutOrder = index
    Card.Parent = ScrollFrame
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    local CS = Instance.new("UIStroke", Card)
    CS.Color = Color3.fromRGB(50, 50, 65)
    CS.Thickness = 1

    -- Thumbnail
    local Thumb = Instance.new("ImageLabel")
    Thumb.Size = UDim2.new(1, -10, 0, 80)
    Thumb.Position = UDim2.new(0, 5, 0, 5)
    Thumb.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    -- Pakai thumbnail dari proxy kalau ada, fallback ke Roblox URL
    -- Thumb.Image = item.thumbnail or ("https://www.roblox.com/asset-thumbnail/image?assetId=" .. assetId .. "&width=150&height=150&format=png")
    Thumb.Image = "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
    Thumb.ScaleType = Enum.ScaleType.Fit
    Thumb.ZIndex = 8
    Thumb.Parent = Card
    Instance.new("UICorner", Thumb).CornerRadius = UDim.new(0, 6)

    -- Name
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -8, 0, 26)
    NameLabel.Position = UDim2.new(0, 4, 0, 88)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = assetName
    NameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    NameLabel.TextSize = 11
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.TextWrapped = true
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    NameLabel.ZIndex = 8
    NameLabel.Parent = Card

    -- Copy ID Button
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0.48, -5, 0, 24)
    CopyBtn.Position = UDim2.new(0, 5, 1, -28)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    CopyBtn.Text = "📋 ID"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.TextSize = 11
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.AutoButtonColor = false
    CopyBtn.ZIndex = 9
    CopyBtn.Parent = Card
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 5)

    -- Insert Button
    local InsertBtn = Instance.new("TextButton")
    InsertBtn.Size = UDim2.new(0.48, -5, 0, 24)
    InsertBtn.Position = UDim2.new(0.52, 0, 1, -28)
    InsertBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    InsertBtn.Text = "📥 Get"
    InsertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InsertBtn.TextSize = 11
    InsertBtn.Font = Enum.Font.GothamBold
    InsertBtn.AutoButtonColor = false
    InsertBtn.ZIndex = 9
    InsertBtn.Parent = Card
    Instance.new("UICorner", InsertBtn).CornerRadius = UDim.new(0, 5)

    -- Hover
    Card.MouseEnter:Connect(function()
        TweenService:Create(CS, TweenInfo.new(0.1), {Color = Color3.fromRGB(70,130,255), Thickness = 1.5}):Play()
    end)
    Card.MouseLeave:Connect(function()
        TweenService:Create(CS, TweenInfo.new(0.1), {Color = Color3.fromRGB(50,50,65), Thickness = 1}):Play()
    end)

    -- Copy ID event
    CopyBtn.MouseButton1Click:Connect(function()
        local ok = pcall(setclipboard, assetId)
        if ok then
            showToast("✅ Copied ID: " .. assetId, Color3.fromRGB(40, 200, 100))
            CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
            task.delay(1.2, function()
                CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
            end)
        else
            showToast("❌ Copy gagal!", Color3.fromRGB(200, 60, 60))
        end
    end)

    -- Insert event
    InsertBtn.MouseButton1Click:Connect(function()
        insertAsset(assetId)
    end)
end

-- ═══════════════════════════════════
--          LOAD ITEMS (PROXY)
-- ═══════════════════════════════════
local function loadItems(keyword)
    clearItems()
    local kw = (keyword and #keyword > 0) and keyword or "house"
    StatusLabel.Text = "🔄 Searching: " .. kw .. "..."

    task.spawn(function()
        local url = PROXY_URL .. "?keyword=" .. HttpService:UrlEncode(kw)
        print("🔗 Fetching: " .. url)

        local ok, res = pcall(function()
            return game:HttpGet(url, true)
        end)

        if not ok then
            StatusLabel.Text = "❌ HttpGet gagal"
            showToast("❌ Koneksi gagal", Color3.fromRGB(200, 60, 60))
            print("❌ HttpGet error:", res)
            return
        end

        local pok, dec = pcall(HttpService.JSONDecode, HttpService, res)
        if not pok or not dec then
            StatusLabel.Text = "❌ JSON decode gagal"
            print("❌ JSON error:", dec)
            return
        end

        -- Proxy return: { success, total, keyword, results: [{id, name, creator, thumbnail}] }
        local items = dec.results or {}

        if #items == 0 then
            StatusLabel.Text = "⚠️ Tidak ada hasil untuk: " .. kw
            showToast("⚠️ Tidak ada hasil", Color3.fromRGB(200, 150, 0))
            return
        end

        for i, item in ipairs(items) do
            createCard(item, i)
        end

        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#items / 3) * 156 + 16)
        StatusLabel.Text = "✅ Found " .. #items .. " results for: " .. kw
        print("✅ Loaded " .. #items .. " items")
        -- Tambah ini setelah JSONDecode berhasil
print("RAW RESPONSE:", res)
print("ITEMS COUNT:", #items)
if items[1] then
    print("ITEM 1:", items[1].id, items[1].name, items[1].thumbnail)
end
            
    end)
end

-- ═══════════════════════════════════
--              TABS
-- ═══════════════════════════════════
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        activeTab = tabName
        for n, b in pairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = (n == activeTab) and Color3.fromRGB(70,130,255) or Color3.fromRGB(35,35,42)
            }):Play()
        end
        SearchBox.PlaceholderText = "Search " .. tabName:lower() .. "..."
        loadItems(SearchBox.Text)
    end)
end

SearchBtn.MouseButton1Click:Connect(function()
    loadItems(SearchBox.Text)
end)
SearchBox.FocusLost:Connect(function(enter)
    if enter then loadItems(SearchBox.Text) end
end)

-- ═══════════════════════════════════
--         OPEN / CLOSE TOGGLE
-- ═══════════════════════════════════
local function toggleGui()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0, 85, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 420, 0, 560),
            Position = UDim2.new(0, 85, 0.5, -280)
        }):Play()
        task.delay(0.1, function()
            loadItems(SearchBox.Text)
        end)
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 85, 0.5, 0)
        }):Play()
        task.delay(0.22, function() MainFrame.Visible = false end)
    end
    TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
        BackgroundColor3 = isOpen and Color3.fromRGB(70,130,255) or Color3.fromRGB(80,80,80)
    }):Play()
end

ToggleButton.MouseButton1Click:Connect(toggleGui)

CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 85, 0.5, 0)
    }):Play()
    task.delay(0.22, function() MainFrame.Visible = false end)
    TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    }):Play()
end)

-- ═══════════════════════════════════
--              DRAG
-- ═══════════════════════════════════
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ═══════════════════════════════════
print("✅ Toolbox loaded!")
showToast("🔨 Toolbox Ready!", Color3.fromRGB(70, 130, 255))
