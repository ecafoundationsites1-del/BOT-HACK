--// ECA FOUNDATION FULL SYSTEM

local Players = game:GetService("Players")

--------------------------------------------------
-- 🔐 인원 허용 시스템
--------------------------------------------------

local allowedUsers = {
    [1234567890] = true, -- 관리자 본인 UserId 넣기
}

local ALWAYS_ALLOWED_NAME = "WORPLAYTIMEEXP"

Players.PlayerAdded:Connect(function(player)
    if player.Name == ALWAYS_ALLOWED_NAME then return end
    
    if not allowedUsers[player.UserId] then
        player:Kick("접속이 차단되었습니다.")
    end
end)

--------------------------------------------------
-- 🎨 UI 생성
--------------------------------------------------

local function createUI(player)

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "ECA_UI"
    gui.ResetOnSpawn = false

    -- 상단 바
    local top = Instance.new("Frame", gui)
    top.Size = UDim2.new(1,0,0,80)
    top.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local logo = Instance.new("ImageLabel", top)
    logo.Size = UDim2.new(0,80,0,80)
    logo.Image = "rbxassetid://97233077922960"
    logo.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", top)
    title.Position = UDim2.new(0,90,0,0)
    title.Size = UDim2.new(0,500,1,0)
    title.Text = "ECA FOUNDATION\nExperiment Container Attack"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.TextScaled = true

    -- 사이드바
    local sidebar = Instance.new("Frame", gui)
    sidebar.Position = UDim2.new(0,0,0,80)
    sidebar.Size = UDim2.new(0,200,1,-80)
    sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local main = Instance.new("Frame", gui)
    main.Position = UDim2.new(0,200,0,80)
    main.Size = UDim2.new(1,-200,1,-80)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)

--------------------------------------------------
-- 🧠 기능 함수들
--------------------------------------------------

    local uvEnabled = false
    local highlightEnabled = false
    local dangerEnabled = false

    local function toggleUV()
        uvEnabled = not uvEnabled
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if uvEnabled then
                    v.Material = Enum.Material.Neon
                    v.Color = Color3.fromRGB(0,0,255)
                    v.LocalTransparencyModifier = 0.4
                else
                    v.Material = Enum.Material.Plastic
                    v.LocalTransparencyModifier = 0
                end
            end
        end
    end

    local function toggleHighlight()
        highlightEnabled = not highlightEnabled
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if highlightEnabled then
                    local h = Instance.new("Highlight")
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.fromRGB(0,0,255)
                    h.Parent = v
                else
                    if v:FindFirstChildOfClass("Highlight") then
                        v:FindFirstChildOfClass("Highlight"):Destroy()
                    end
                end
            end
        end
    end

    local function toggleDanger()
        dangerEnabled = not dangerEnabled
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and string.find(v.Name:lower(),"danger") then
                if dangerEnabled then
                    local h = Instance.new("Highlight")
                    h.OutlineColor = Color3.fromRGB(255,0,0)
                    h.FillColor = Color3.fromRGB(255,0,0)
                    h.Parent = v
                else
                    if v:FindFirstChildOfClass("Highlight") then
                        v:FindFirstChildOfClass("Highlight"):Destroy()
                    end
                end
            end
        end
    end

--------------------------------------------------
-- 📋 버튼 생성 함수
--------------------------------------------------

    local function makeButton(text, pos, callback)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1,0,0,50)
        btn.Position = UDim2.new(0,0,0,pos)
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.MouseButton1Click:Connect(callback)
    end

--------------------------------------------------
-- 📌 사이드바 버튼들
--------------------------------------------------

    makeButton("카메라 (UV)",0,toggleUV)
    makeButton("구조물식별",50,toggleHighlight)
    makeButton("위험물 감지",100,toggleDanger)

    makeButton("실시간 현상황",150,function()
        main:ClearAllChildren()
        local info = Instance.new("TextLabel",main)
        info.Size = UDim2.new(1,0,1,0)
        info.Text = "플레이어 : WORPLAYTIMEEXP"
        info.TextColor3 = Color3.new(1,1,1)
        info.BackgroundTransparency = 1
        info.TextScaled = true
    end)

    makeButton("WORPLAYTIMEEXP",200,function()
        main:ClearAllChildren()
        local t = Instance.new("TextLabel",main)
        t.Size = UDim2.new(1,0,1,0)
        t.Text = "WORPLAYTIMEEXP 전용 메뉴"
        t.TextColor3 = Color3.new(1,1,1)
        t.BackgroundTransparency = 1
        t.TextScaled = true
    end)

--------------------------------------------------
-- 👥 인원 허용 UI
--------------------------------------------------

    makeButton("인원허용",250,function()

        main:ClearAllChildren()

        local box = Instance.new("TextBox",main)
        box.Size = UDim2.new(0,300,0,50)
        box.Position = UDim2.new(0.5,-150,0.3,0)
        box.PlaceholderText = "UserId 입력"

        local allowBtn = Instance.new("TextButton",main)
        allowBtn.Size = UDim2.new(0,200,0,50)
        allowBtn.Position = UDim2.new(0.5,-100,0.5,0)
        allowBtn.Text = "허용"

        allowBtn.MouseButton1Click:Connect(function()
            local id = tonumber(box.Text)
            if id then
                allowedUsers[id] = true
            end
        end)

    end)

end

--------------------------------------------------
-- UI 적용
--------------------------------------------------

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    createUI(player)
end)
