-- ECA HUB 설정
local HUB_NAME = "ECA HUB"
local LOGO_NAME = "ECALOGO.png"
local FOLDER_PATH = "Delta/Workspace/" -- 실행기마다 경로 설정이 다를 수 있음 (보통 workspace/ 기준)

-- 1. 폴더 및 파일 체크/생성 함수
local function EnsureLogoExists()
    -- 실제 파일 시스템 경로는 실행기(Delta)의 워크스페이스 기준입니다.
    local filePath = LOGO_NAME 
    
    -- 파일이 존재하는지 확인 (readfile은 파일이 없으면 에러가 날 수 있어 pcall 사용)
    local success, content = pcall(function() return readfile(filePath) end)
    
    if not success or not content then
        print(HUB_NAME .. ": 로고 파일이 없습니다. 생성을 시작합니다.")
        
        -- 여기에 이미지의 Raw Data(Base64 또는 바이너리)를 넣어야 하지만, 
        -- 가장 깔끔한 방법은 서버(GitHub 등)에서 로고를 다운로드해오는 것입니다.
        local logoUrl = "https://your-image-link.com/ECALOGO.png" -- 여기에 실제 이미지 직링크를 넣으세요.
        local downloadedData = game:HttpGet(logoUrl)
        
        writefile(filePath, downloadedData)
        print(HUB_NAME .. ": 로고 저장 완료.")
    else
        print(HUB_NAME .. ": 로고 확인됨.")
    end
end

-- 2. UI에 이미지 적용하기
local function GetLogoAsset()
    EnsureLogoExists()
    -- 실행기 전용 Asset ID로 변환
    return getcustomasset(LOGO_NAME)
end

-- [테스트용 UI 생성]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local LogoImage = Instance.new("ImageLabel", MainFrame)
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = GetLogoAsset() -- 여기서 위에서 만든 함수 호출
