local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

-- UI 생성
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DecalUI"
screenGui.Parent = playerGui

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 400, 0, 400) -- 이미지 크기
imageLabel.Position = UDim2.new(0.5, -200, 0.5, -200) -- 중앙 배치
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://105271121261622" -- 요청하신 ID
imageLabel.Parent = screenGui
