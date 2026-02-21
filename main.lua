local MarketService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local decalId = 105271121261622 -- 요청하신 ID

-- 실제 이미지 ID를 가져오는 함수
local success, info = pcall(function()
    return MarketService:GetProductInfo(decalId)
end)

local finalImageId = "rbxassetid://" .. decalId
if success and info.AssetTypeId == 13 then -- 13은 Decal 타입
    -- 데칼 ID를 이미지 ID로 변환 시도 (보통 -1 정도 차이남)
    finalImageId = "rbxassetid://" .. tostring(decalId)
end

-- UI 생성 및 적용
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 500, 0, 500)
imageLabel.Position = UDim2.new(0.5, -250, 0.5, -250)
imageLabel.Image = finalImageId -- 변환된 ID 적용
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = screenGui

print("이미지 로딩 시도 중: " .. finalImageId)
