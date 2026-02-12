local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- [ 설정: 관리자 및 로고 ]
local ADMIN_NAME = "WORPLAYTIMEEXP"
local LOGO_ID = "rbxassetid://97233077922960"

-- [ UI 상태 변수 ]
local status = {
	UV = false,
	StructureID = false,
	RealTimeInfo = false
}

-- [ UI 생성 ]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ECA_System_Final"
screenGui.Parent = Player.PlayerGui

-- 메인 프레임
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 450)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true -- 드래그를 위해 활성화
mainFrame.Draggable = true -- UI 이동 기능 활성화
mainFrame.Parent = screenGui

-- [ 닫기 X 버튼 ]
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.TextSize = 30
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- [ 상단 헤더 ]
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -50, 0, 50)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 5)
logo.Image = LOGO_ID
logo.BackgroundTransparency = 1
logo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.Text = "ECA FOUNDATION - Experiment Container Attack"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = header

-- [ 사이드바 & 콘텐츠 ]
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.Parent = mainFrame
Instance.new("UIListLayout").Parent = sidebar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -150, 1, -50)
content.Position = UDim2.new(0, 150, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- [ 기능 함수: 메뉴 전환 ]
local function openMenu(name)
	for _, v in pairs(content:GetChildren()) do v:Destroy() end
	
	local menuTitle = Instance.new("TextLabel")
	menuTitle.Size = UDim2.new(1, 0, 0, 60)
	menuTitle.Text = name
	menuTitle.TextColor3 = Color3.new(1, 1, 1)
	menuTitle.TextSize = 35
	menuTitle.Font = Enum.Font.GothamBold
	menuTitle.Parent = content

	if name == "카메라" then
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 50)
		btn.Position = UDim2.new(0.5, -100, 0.4, 0)
		btn.Text = "자외선: " .. (status.UV and "ON" or "OFF")
		btn.BackgroundColor3 = status.UV and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
		btn.Parent = content
		btn.MouseButton1Click:Connect(function()
			status.UV = not status.UV
			openMenu("카메라") -- UI 갱신
		end)
	elseif name == "구조물식별" then
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 50)
		btn.Position = UDim2.new(0.5, -100, 0.4, 0)
		btn.Text = "식별: " .. (status.StructureID and "ON" or "OFF")
		btn.BackgroundColor3 = status.StructureID and Color3.new(0, 0, 0.5) or Color3.new(0.5, 0, 0)
		btn.Parent = content
		btn.MouseButton1Click:Connect(function()
			status.StructureID = not status.StructureID
			openMenu("구조물식별")
		end)
	elseif name == "실시간 현상황" then
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 50)
		btn.Position = UDim2.new(0.5, -100, 0.2, 0)
		btn.Text = "정보받기: " .. (status.RealTimeInfo and "ON" or "OFF")
		btn.Parent = content
		btn.MouseButton1Click:Connect(function()
			status.RealTimeInfo = not status.RealTimeInfo
			openMenu("실시간 현상황")
		end)
		
		if status.RealTimeInfo then
			local box = Instance.new("Frame")
			box.Size = UDim2.new(0.9, 0, 0.5, 0)
			box.Position = UDim2.new(0.05, 0, 0.4, 0)
			box.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			box.Parent = content
			local txt = Instance.new("TextLabel")
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.Text = "플레이어: " .. ADMIN_NAME .. "\n상태: 정상 작동 중"
			txt.TextColor3 = Color3.new(1, 1, 1)
			txt.Parent = box
		end
	end
end

-- [ 사이드바 버튼 생성 ]
local menuList = {"카메라", "구조물식별", "데미지파트", "실시간 현상황", "인원허용"}
for _, m in pairs(menuList) do
	if m == "인원허용" and Player.Name ~= ADMIN_NAME then continue end
	
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 45)
	b.Text = m
	b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = sidebar
	b.MouseButton1Click:Connect(function() openMenu(m) end)
end

openMenu("카메라")

