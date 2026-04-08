-- ╔═══════════════════════════════════════════════╗
-- ║         CUSTOM TOOLBOX SCRIPT                 ║
-- ║     Compatible with Roblox Studio Toolbox     ║
-- ╚═══════════════════════════════════════════════╝

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ══════════════════════════════════════
--           CONSTANTS & CONFIG
-- ══════════════════════════════════════
local PROXY_API   = "https://roblox-three-mauve.vercel.app/api/search"
local ASSET_API   = "https://assetdelivery.roblox.com/v1/asset/?id="
local THUMB_API   = "https://thumbnails.roblox.com/v1/assets?assetIds=%s&returnPolicy=PlaceHolder&size=150x150&format=Png&isCircular=false"

local CATEGORIES = {
    { name = "Models",      assetType = 10, icon = "🏠" },
    { name = "Decals",      assetType = 13, icon = "🖼️" },
    { name = "Audio",       assetType = 3,  icon = "🎵" },
    { name = "Plugins",     assetType = 38, icon = "🔌" },
    { name = "Meshes",      assetType = 4,  icon = "🔷" },
    { name = "Packages",    assetType = 32, icon = "📦" },
}

-- ══════════════════════════════════════
--            SCREEN GUI SETUP
-- ══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomToolbox"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--       TOGGLE BUTTON (Round Gray 🔨)
-- ══════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 54, 0, 54)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
ToggleBtn.AnchorPoint = Vector2.new(0, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
ToggleBtn.Text = "🔨"
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(140, 140, 150)
ToggleStroke.Parent = ToggleBtn

-- Hover glow
ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(115, 115, 120)
    }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(90, 90, 95)
    }):Play()
end)

-- ══════════════════════════════════════
--            MAIN FRAME (GUI)
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 580)
MainFrame.Position = UDim2.new(0, 85, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Parent = MainFrame

-- ── Shadow Effect ──
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 4
Shadow.Image = "rbxasset://textures/ui/Shadow.png"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(30, 30, 270, 270)
Shadow.Parent = MainFrame

-- ── Header ──
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Header.BorderSizePixel = 0
Header.ZIndex = 6
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- Fix bottom corners of header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 6
HeaderFix.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔨  Custom Toolbox"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 17
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 7
TitleLabel.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 8
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(230, 80, 80)
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    }):Play()
end)

-- ── Search Bar ──
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -24, 0, 38)
SearchContainer.Position = UDim2.new(0, 12, 0, 60)
SearchContainer.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
SearchContainer.BorderSizePixel = 0
SearchContainer.ZIndex = 6
SearchContainer.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 10)
SearchCorner.Parent = SearchContainer

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Thickness = 1
SearchStroke.Color = Color3.fromRGB(55, 55, 65)
SearchStroke.Parent = SearchContainer

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 32, 1, 0)
SearchIcon.Position = UDim2.new(0, 4, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 15
SearchIcon.ZIndex = 7
SearchIcon.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -80, 1, 0)
SearchBox.Position = UDim2.new(0, 36, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "Search toolbox..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(220, 220, 228)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 7
SearchBox.Parent = SearchContainer

-- ── Category Tabs ──
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -24, 0, 36)
TabContainer.Position = UDim2.new(0, 12, 0, 106)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 6
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabContainer

local currentCategory = CATEGORIES[1]
local tabButtons = {}

local function createTab(cat, index)
    local tab = Instance.new("TextButton")
    tab.Name = cat.name
    tab.Size = UDim2.new(0, 62, 1, 0)
    tab.BackgroundColor3 = index == 1 and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(38, 38, 46)
    tab.Text = cat.icon .. "\n" .. cat.name
    tab.TextColor3 = Color3.fromRGB(220, 220, 228)
    tab.TextSize = 10
    tab.Font = Enum.Font.GothamBold
    tab.AutoButtonColor = false
    tab.LayoutOrder = index
    tab.ZIndex = 7
    tab.Parent = TabContainer

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tab

    tabButtons[index] = tab
    return tab
end

-- ── Asset Grid ──
local GridContainer = Instance.new("ScrollingFrame")
GridContainer.Name = "AssetGrid"
GridContainer.Size = UDim2.new(1, -24, 1, -200)
GridContainer.Position = UDim2.new(0, 12, 0, 150)
GridContainer.BackgroundTransparency = 1
GridContainer.ScrollBarThickness = 4
GridContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
GridContainer.BorderSizePixel = 0
GridContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
GridContainer.ZIndex = 6
GridContainer.Parent = MainFrame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 118, 0, 140)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = GridContainer

-- ── Status Bar ──
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 32)
StatusBar.Position = UDim2.new(0, 0, 1, -32)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 7
StatusBar.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -12, 1, 0)
StatusLabel.Position = UDim2.new(0, 12, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 120)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 8
StatusLabel.Parent = StatusBar

-- ══════════════════════════════════════
--         ASSET CARD CREATION
-- ══════════════════════════════════════
local function createAssetCard(assetData, index)
    local card = Instance.new("Frame")
    card.Name = "AssetCard_" .. assetData.id
    card.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.ZIndex = 7
    card.Parent = GridContainer

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Thickness = 1
    cs.Color = Color3.fromRGB(55, 55, 65)
    cs.Parent = card

    -- Thumbnail image
    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(1, -12, 0, 80)
    thumb.Position = UDim2.new(0, 6, 0, 6)
    thumb.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    thumb.BorderSizePixel = 0
    thumb.ScaleType = Enum.ScaleType.Fit
    -- Use real thumbnail URL with asset ID
    thumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. assetData.id .. "&width=150&height=150&format=Png"
    thumb.ZIndex = 8
    thumb.Parent = card

    local tc2 = Instance.new("UICorner")
    tc2.CornerRadius = UDim.new(0, 7)
    tc2.Parent = thumb

    -- Asset name label (exact name from API)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -8, 0, 28)
    nameLabel.Position = UDim2.new(0, 4, 0, 88)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = assetData.name or "Unknown"
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 228)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextWrapped = true
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 8
    nameLabel.Parent = card

    -- Buttons row
    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -8, 0, 20)
    btnRow.Position = UDim2.new(0, 4, 0, 116)
    btnRow.BackgroundTransparency = 1
    btnRow.ZIndex = 8
    btnRow.Parent = card

    -- GET / Insert button
    local getBtn = Instance.new("TextButton")
    getBtn.Size = UDim2.new(0.55, -2, 1, 0)
    getBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    getBtn.Text = "GET"
    getBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getBtn.TextSize = 11
    getBtn.Font = Enum.Font.GothamBold
    getBtn.AutoButtonColor = false
    getBtn.ZIndex = 9
    getBtn.Parent = btnRow

    local gc = Instance.new("UICorner")
    gc.CornerRadius = UDim.new(0, 5)
    gc.Parent = getBtn

    -- COPY ID button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.45, -2, 1, 0)
    copyBtn.Position = UDim2.new(0.55, 2, 0, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    copyBtn.Text = "ID"
    copyBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    copyBtn.TextSize = 10
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.AutoButtonColor = false
    copyBtn.ZIndex = 9
    copyBtn.Parent = btnRow

    local cpc = Instance.new("UICorner")
    cpc.CornerRadius = UDim.new(0, 5)
    cpc.Parent = copyBtn

    -- ─── COPY ID FUNCTIONALITY (Fitur 1) ───
    copyBtn.MouseButton1Click:Connect(function()
        -- Copy Asset ID to clipboard
        setclipboard(tostring(assetData.id))
        copyBtn.Text = "✓"
        copyBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
        StatusLabel.Text = "✓ Copied ID: " .. tostring(assetData.id)
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
        task.delay(1.5, function()
            copyBtn.Text = "ID"
            copyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
            StatusLabel.Text = "Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 120)
        end)
    end)

    -- ─── INSERT MODEL FUNCTIONALITY ───
    getBtn.MouseButton1Click:Connect(function()
        StatusLabel.Text = "⏳ Inserting: " .. (assetData.name or "asset") .. "..."
        StatusLabel.TextColor3 = Color3.fromRGB(220, 180, 60)
        local ok, err = pcall(function()
            local model = InsertService:LoadAsset(assetData.id)
            if model then
                model.Parent = workspace
                -- Position near player if in play mode
                local char = Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    model:SetPrimaryPartCFrame(
                        char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                    )
                end
                StatusLabel.Text = "✓ Inserted: " .. (assetData.name or "asset")
                StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
            end
        end)
        if not ok then
            StatusLabel.Text = "✗ Failed to insert asset"
            StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
        task.delay(2, function()
            StatusLabel.Text = "Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 120)
        end)
    end)

    -- Hover highlight
    card.MouseEnter:Connect(function()
        TweenService:Create(cs, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(80, 120, 220),
            Thickness = 1.5
        }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(cs, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(55, 55, 65),
            Thickness = 1
        }):Play()
    end)

    return card
end

-- ══════════════════════════════════════
--         API FETCH FUNCTION
--   Fitur 2: All Models In Toolbox
--   Fitur 3: foto model harus sama
--   Fitur 4: nama model harus sama
-- ══════════════════════════════════════
local currentKeyword = ""
local debounceTimer = nil

local function clearGrid()
    for _, child in ipairs(GridContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    GridContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function fetchAssets(keyword, assetType)
    clearGrid()
    StatusLabel.Text = "⏳ Loading assets..."
    StatusLabel.TextColor3 = Color3.fromRGB(220, 180, 60)

    -- Build URL pakai proxy kamu
    -- Contoh: https://roblox-three-mauve.vercel.app/api/search?keyword=house
    local kw = (keyword and #keyword > 0) and keyword or "a"
    local url = PROXY_API .. "?keyword=" .. HttpService:UrlEncode(kw)

    local ok, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = {
                ["Accept"] = "application/json",
            }
        })
    end)

    if not ok or not response or response.StatusCode ~= 200 then
        StatusLabel.Text = "✗ Proxy error: " .. (response and tostring(response.StatusCode) or "no response")
        StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
        return
    end

    local data
    local parseOk = pcall(function()
        data = HttpService:JSONDecode(response.Body)
    end)

    if not parseOk or not data then
        StatusLabel.Text = "✗ Failed to parse response"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
        return
    end

    -- Support berbagai format JSON dari proxy:
    -- { data: [...] } atau { items: [...] } atau [ ... ] langsung
    local items = {}
    if type(data) == "table" then
        if data.data and type(data.data) == "table" then
            items = data.data
        elseif data.items and type(data.items) == "table" then
            items = data.items
        elseif data.results and type(data.results) == "table" then
            items = data.results
        elseif data[1] then
            items = data  -- array langsung
        end
    end

    if #items == 0 then
        StatusLabel.Text = "No results found"
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        return
    end

    for i, item in ipairs(items) do
        -- Ambil id & name dari berbagai kemungkinan field proxy
        local assetId   = item.id or item.assetId or item.asset_id or 0
        local assetName = item.name or item.assetName or item.title or "Unknown Asset"
        -- Kalau ada nested asset object
        if type(item.asset) == "table" then
            assetId   = item.asset.id or assetId
            assetName = item.asset.name or assetName
        end

        createAssetCard({ id = assetId, name = assetName }, i)
    end

    local rows = math.ceil(#items / 3)
    GridContainer.CanvasSize = UDim2.new(0, 0, 0, rows * 148 + 10)
    StatusLabel.Text = "✓ Loaded " .. #items .. " assets"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 120)
end

-- ══════════════════════════════════════
--           SEARCH HANDLING
-- ══════════════════════════════════════
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentKeyword = SearchBox.Text
    if debounceTimer then
        task.cancel(debounceTimer)
    end
    debounceTimer = task.delay(0.5, function()
        fetchAssets(currentKeyword, currentCategory.assetType)
    end)
end)

-- ══════════════════════════════════════
--           CATEGORY TABS
-- ══════════════════════════════════════
for i, cat in ipairs(CATEGORIES) do
    local tab = createTab(cat, i)
    tab.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for j, t in ipairs(tabButtons) do
            TweenService:Create(t, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            }):Play()
        end
        -- Highlight selected
        TweenService:Create(tab, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        }):Play()
        currentCategory = cat
        fetchAssets(currentKeyword, cat.assetType)
    end)
end

-- ══════════════════════════════════════
--         OPEN / CLOSE TOGGLE
-- ══════════════════════════════════════
local isOpen = false

local function openGui()
    isOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0, 85, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 580),
        Position = UDim2.new(0, 85, 0.5, -290)
    }):Play()
    -- Load assets on open
    task.delay(0.2, function()
        fetchAssets(currentKeyword, currentCategory.assetType)
    end)
end

local function closeGui()
    isOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 85, 0.5, 0)
    }):Play()
    task.delay(0.22, function()
        MainFrame.Visible = false
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then
        closeGui()
    else
        openGui()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    closeGui()
end)

-- ══════════════════════════════════════
--         DRAG FUNCTIONALITY
-- ══════════════════════════════════════
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════
print("✅ Custom Toolbox loaded!")
print("🔨 Klik tombol abu-abu di kiri layar untuk buka/tutup")
