-- Custom Toolbox untuk Delta Executor
-- Paste langsung ke Delta Executor (bisa sebagai LocalScript)

local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local PROXY_URL = "https://roblox-three-mauve.vercel.app"   -- GANTI kalau nama Vercel kamu beda

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaCustomToolbox"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.75, 0, 0.85, 0)
mainFrame.Position = UDim2.new(0.125, 0, 0.075, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = " Delta Custom Toolbox"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.65, 0, 0, 45)
searchBox.Position = UDim2.new(0.05, 0, 0.12, 0)
searchBox.PlaceholderText = "Ketik: modern house, furniture, car..."
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.TextSize = 16
searchBox.Parent = mainFrame

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0.25, 0, 0, 45)
searchBtn.Position = UDim2.new(0.72, 0, 0.12, 0)
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
searchBtn.Text = "CARI"
searchBtn.TextColor3 = Color3.new(1,1,1)
searchBtn.TextSize = 16
searchBtn.Font = Enum.Font.GothamSemibold
searchBtn.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0.72, 0)
scroll.Position = UDim2.new(0.025, 0, 0.23, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 160, 0, 220)
grid.CellPadding = UDim2.new(0, 12, 0, 12)
grid.Parent = scroll

-- Fungsi Search
local function searchAssets(keyword)
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local url = PROXY_URL .. "/api/search?keyword=" .. HttpService:UrlEncode(keyword or "modern house") .. "&limit=30"

    local success, resp = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if not success then
        warn("[Delta Toolbox] Gagal koneksi ke proxy: " .. tostring(resp))
        return
    end

    local data = HttpService:JSONDecode(resp)

    if not data.results or #data.results == 0 then
        warn("[Delta Toolbox] Tidak ada hasil")
        return
    end

    for _, asset in ipairs(data.results) do
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        card.BorderSizePixel = 0

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 0.55, 0)
        img.BackgroundTransparency = 1
        img.Image = asset.thumbnail
        img.Parent = card

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0, 50)
        name.Position = UDim2.new(0, 0, 0.55, 0)
        name.BackgroundTransparency = 1
        name.Text = asset.name
        name.TextColor3 = Color3.new(1,1,1)
        name.TextScaled = true
        name.TextWrapped = true
        name.Font = Enum.Font.GothamSemibold
        name.Parent = card

        local idLabel = Instance.new("TextLabel")
        idLabel.Size = UDim2.new(1, 0, 0, 20)
        idLabel.Position = UDim2.new(0, 0, 0.78, 0)
        idLabel.BackgroundTransparency = 1
        idLabel.Text = "ID: " .. asset.id
        idLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        idLabel.TextSize = 13
        idLabel.Parent = card

        -- Button Download / Insert
        local insertBtn = Instance.new("TextButton")
        insertBtn.Size = UDim2.new(1, 0, 0, 35)
        insertBtn.Position = UDim2.new(0, 0, 0.88, 0)
        insertBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        insertBtn.Text = "Insert ke Workspace"
        insertBtn.TextColor3 = Color3.new(1,1,1)
        insertBtn.TextSize = 14
        insertBtn.Parent = card

        insertBtn.MouseButton1Click:Connect(function()
            insertBtn.Text = "Loading..."
            pcall(function()
                local model = InsertService:LoadAsset(asset.id)
                if model then
                    model.Parent = workspace
                    print("✅ Berhasil insert: " .. asset.name .. " (ID: " .. asset.id .. ")")
                end
            end)
            insertBtn.Text = "Insert ke Workspace"
        end)

        card.Parent = scroll
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y)
end

-- Event
searchBtn.MouseButton1Click:Connect(function()
    searchAssets(searchBox.Text)
end)

searchBox.FocusLost:Connect(function(enter)
    if enter then
        searchAssets(searchBox.Text)
    end
end)

-- Auto search pertama
task.wait(1.5)
searchAssets("modern house")

print("Delta Custom Toolbox berhasil dimuat!")
