local assetId = "rbxassetid://132177265338575"

local function applyDecal(part)
    if part and part:IsA("BasePart") and not part:FindFirstChild("AppliedDecal") then
        
        local decal = Instance.new("Decal")
        decal.Name = "AppliedDecal"
        decal.Texture = assetId
        decal.Face = Enum.NormalId.Front
        decal.Parent = part
        
        
        local decalBack = Instance.new("Decal")
        decalBack.Name = "AppliedDecalBack"
        decalBack.Texture = assetId
        decalBack.Face = Enum.NormalId.Back
        decalBack.Parent = part
        
        print("[DECAL] Dipasang di: " .. part:GetFullName())
    end
end

for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        applyDecal(part)
    end
end

workspace.DescendantAdded:Connect(function(part)
    task.wait(0.1)
    if part:IsA("BasePart") then
        applyDecal(part)
    end
end)
