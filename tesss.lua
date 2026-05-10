-- ============================================
-- DECAL SPAM - PASANG GAMBAR DI SEMUA PART + UI TOGGLE
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local pGui = LocalPlayer:WaitForChild("PlayerGui")

local assetId = "rbxassetid://132177265338575"
local decalActive = false
local decalInstances = {}  -- nyimpen decal yang udah dipasang
local connection = nil

-- Fungsi pasang decal di part
local function applyDecal(part)
    if not part or not part:IsA("BasePart") then return end
    if decalInstances[part] then return end  -- udah pernah dipasang
    
    local decal = Instance.new("Decal")
    decal.Name = "SpamDecal"
    decal.Texture = assetId
    decal.Face = Enum.NormalId.Front
    decal.Parent = part
    
    local decalBack = Instance.new("Decal")
    decalBack.Name = "SpamDecalBack"
    decalBack.Texture = assetId
    decalBack.Face = Enum.NormalId.Back
    decalBack.Parent = part
    
    decalInstances[part] = {decal, decalBack}
end

-- Fungsi hapus semua decal
local function clearAllDecals()
    for part, decals in pairs(decalInstances) do
        for _, decal in pairs(decals) do
            pcall(function() decal:Destroy() end)
        end
    end
    decalInstances = {}
end

-- Fungsi scan semua part dan pasang decal
local function scanAndApply()
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            applyDecal(part)
        end
    end
end

-- Fungsi mulai pasang decal (aktif)
local function startDecalSpam()
    if decalActive then return end
    decalActive = true
    
    -- Pasang ke part yang udah ada
    scanAndApply()
    
    -- Pantau part baru
    connection = workspace.DescendantAdded:Connect(function(part)
        task.wait(0.1)
        if decalActive and part:IsA("BasePart") then
            applyDecal(part)
        end
    end)
    
    print("[DECAL] ON - Mulai pasang decal")
end

-- Fungsi berhenti & hapus decal
local function stopDecalSpam()
    decalActive = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
    clearAllDecals()
    print("[DECAL] OFF - Semua decal dihapus")
end

-- ========== UI TOGGLE SEDERHANA ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DecalUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = pGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 150, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -75, 0.85, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleBtn.Text = "🔴 DECAL: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 25)
btnCorner.Parent = toggleBtn

-- Tombol toggle
toggleBtn.MouseButton1Click:Connect(function()
    if decalActive then
        stopDecalSpam()
        toggleBtn.Text = "🔴 DECAL: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        startDecalSpam()
        toggleBtn.Text = "🟢 DECAL: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

print("🔥 DECAL SPAM UI AKTIF!")
print("📌 Klik tombol merah/hijau di layar buat ON/OFF")
