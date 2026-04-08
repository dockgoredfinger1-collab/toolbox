-- Custom Toolbox Delta Executor (Versi Debug)
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")

local PROXY_URL = "https://roblox-three-mauve.vercel.app"  -- GANTI kalau beda

local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaToolbox"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.7, 0, 0.8, 0)
mainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = " Delta Custom Toolbox - Debug Mode"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 18
title.Parent = mainFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.65, 0, 0, 40)
searchBox.Position = UDim2.new(0.05, 0, 0.12, 0)
searchBox.PlaceholderText = "modern house / furniture / car"
searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Parent = mainFrame

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0.25, 0, 0, 40)
searchBtn.Position = UDim2.new(0.72, 0, 0.12, 0)
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
searchBtn.Text = "CARI"
searchBtn.TextColor3 = Color3.new(1,1,1)
searchBtn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Text = "Status: Menunggu..."
statusLabel.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0.65, 0)
scroll.Position = UDim2.new(0.025, 0, 0.28, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 160, 0, 210)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.Parent = scroll

local function searchAssets(keyword)
    statusLabel.Text = "Status: Sedang mencari..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)

    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local url = PROXY_URL .. "/api/search?keyword=" .. HttpService:UrlEncode(keyword or "modern house")

    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if not success then
        statusLabel.Text = "ERROR: Gagal koneksi ke proxy\n" .. tostring(response)
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        warn("Proxy Error: " .. tostring(response))
        return
    end

    local successDecode, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not successDecode then
        statusLabel.Text = "ERROR: Response bukan JSON"
        return
    end

    statusLabel.Text = "Status: Berhasil! Ditemukan " .. #data.results .. " asset"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

    for _, asset in ipairs(data.results or {}) do
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        card.Parent = scroll

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 0.55, 0)
        img.Image = asset.thumbnail or ""
        img.BackgroundTransparency = 1
        img.Parent = card

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0, 40)
        name.Position = UDim2.new(0, 0, 0.55, 0)
        name.BackgroundTransparency = 1
        name.Text = asset.name
        name.TextColor3 = Color3.new(1,1,1)
        name.TextScaled = true
        name.Parent = card

        local insertBtn = Instance.new("TextButton")
        insertBtn.Size = UDim2.new(1, 0, 0, 35)
        insertBtn.Position = UDim2.new(0, 0, 0.82, 0)
        insertBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        insertBtn.Text = "Insert ke Workspace"
        insertBtn.TextColor3 = Color3.new(1,1,1)
        insertBtn.Parent = card

        insertBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local model = InsertService:LoadAsset(asset.id)
                if model then
                    model.Parent = workspace
                    print("Inserted: " .. asset.name)
                end
            end)
        end)
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y)
end

searchBtn.MouseButton1Click:Connect(function()
    searchAssets(searchBox.Text)
end)

searchBox.FocusLost:Connect(function(enter)
    if enter then searchAssets(searchBox.Text) end
end)

-- Auto search
task.wait(2)
searchAssets("modern house")

print("Delta Toolbox loaded. Cek apakah HTTP Requests sudah di-enable di Delta Settings!!") 
