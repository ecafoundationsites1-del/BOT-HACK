local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [ 설정: 관리자 및 초기 허용 명단 ]
local ADMIN_NAME = "WORPLAYTIMEEXP"
local allowedUsers = {
	[ADMIN_NAME] = true -- 관리자는 항상 허용
}

-- [ 접속 차단 체크 ]
-- 주의: 실제 게임 보안을 위해서는 서버 스크립트에서 Kick 로직을 처리해야 합니다.
local function checkAccess()
	if not allowedUsers[Player.Name] then
		Player:Kick("접속 차단: 귀하는 ECA 재단 접근 권한이 없습니다.")
	end
end
-- checkAccess() -- 테스트 완료 후 주석을 해제하면 목록에 없는 인원은 튕깁니다.

-- [ UI 생성 ]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ECA_Integrated_System"
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 450)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- [ 상단 헤더 및 로고 ]
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 5)
logo.Image = "rbxassetid://97233077922960" -- ECA 로고 ID
logo.BackgroundTransparency = 1
logo.Parent = header

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 60, 0, 0)
titleText.Text = "ECA FOUNDATION - Experiment Container Attack"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.BackgroundTransparency = 1
titleText.Parent = header

-- [ 사이드바 ]
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Parent = sidebar

-- [ 메인 콘텐츠 영역 ]
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -150, 1, -50)
contentFrame.Position = UDim2.new(0, 150, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- [ 기능: 인원 허용 관리창 ]
local function showAccessControl()
	for _, v in pairs(contentFrame:GetChildren()) do v:Destroy() end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 50)
	label.Text = "인원 허용 관리 (관리자 전용)"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.Parent = contentFrame

	local input = Instance.new("TextBox")
	input.Size = UDim2.new(0.6, 0, 0, 40)
	input.Position = UDim2.new(0.05, 0, 0.2, 0)
	input.PlaceholderText = "허용할 유저 아이디 입력..."
	input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	input.TextColor3 = Color3.new(1, 1, 1)
	input.Parent = contentFrame

	local addBtn = Instance.new("TextButton")
	addBtn.Size = UDim2.new(0.25, 0, 0, 40)
	addBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
	addBtn.Text = "허용 추가"
	addBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
	addBtn.TextColor3 = Color3.new(1, 1, 1)
	addBtn.Parent = contentFrame

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(0.9, 0, 0.6, 0)
	scroll.Position = UDim2.new(0.05, 0, 0.35, 0)
	scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	scroll.Parent = contentFrame
	Instance.new("UIListLayout").Parent = scroll

	local function updateList()
		for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
		for user, _ in pairs(allowedUsers) do
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 35)
			row.BackgroundTransparency = 1
			row.Parent = scroll
			
			local name = Instance.new("TextLabel")
			name.Size = UDim2.new(0.7, 0, 1, 0)
			name.Text = user
			name.TextColor3 = Color3.new(1, 1, 1)
			name.Parent = row
			
			if user ~= ADMIN_NAME then
				local del = Instance.new("TextButton")
				del.Size = UDim2.new(0.25, 0, 0.8, 0)
				del.Position = UDim2.new(0.7, 0, 0.1, 0)
				del.Text = "접근삭제"
				del.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
				del.TextColor3 = Color3.new(1, 1, 1)
				del.Parent = row
				del.MouseButton1Click:Connect(function()
					allowedUsers[user] = nil
					updateList()
				end)
			end
		end
	end

	addBtn.MouseButton1Click:Connect(function()
		if input.Text ~= "" then
			allowedUsers[input.Text] = true
			input.Text = ""
			updateList()
		end
	end)
	updateList()
end

-- [ 메뉴 구성 ]
local menus = {"카메라", "구조물식별", "데미지파트", "실시간 현상황", "인원허용"}

for _, name in pairs(menus) do
	-- 인원허용 메뉴는 WORPLAYTIMEEXP에게만 생성
	if name == "인원허용" and Player.Name ~= ADMIN_NAME then
		continue
	end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Parent = sidebar

	btn.MouseButton1Click:Connect(function()
		for _, v in pairs(contentFrame:GetChildren()) do v:Destroy() end
		
		if name == "인원허용" then
			showAccessControl()
		elseif name == "실시간 현상황" then
			-- 이미지 48461 기반 실시간 현상황 연출
			local t = Instance.new("TextLabel")
			t.Size = UDim2.new(1, 0, 0, 50)
			t.Text = "실시간 현상황 (정보받기 ON)"
			t.TextColor3 = Color3.new(1, 1, 0)
			t.Parent = contentFrame
			
			local charInfo = Instance.new("TextLabel")
			charInfo.Size = UDim2.new(0.5, 0, 0.5, 0)
			charInfo.Position = UDim2.new(0, 0, 0.3, 0)
			charInfo.Text = "플레이어:\nWORPLAYTIMEEXP" -- 캐릭터 명시
			charInfo.TextColor3 = Color3.new(1, 1, 1)
			charInfo.Parent = contentFrame
		else
			local t = Instance.new("TextLabel")
			t.Size = UDim2.new(1, 0, 1, 0)
			t.Text = name .. " 메뉴 활성화 중..."
			t.TextColor3 = Color3.new(1, 1, 1)
			t.Parent = contentFrame
		end
	end)
end
