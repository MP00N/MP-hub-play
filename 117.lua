local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- 清除旧UI
if gui:FindFirstChild("SimpleMPHub") then
    gui.SimpleMPHub:Destroy()
end

-- 创建主UI容器
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleMPHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建中央UI框架
local mainFrame = Instance.new("Frame")
mainFrame.Name = "HubFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.15, 0)
corner.Parent = mainFrame

-- 标题文本
local title = Instance.new("TextLabel")
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.new(0.5, 0, 0.4, 0)
title.Size = UDim2.new(0.9, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "MP Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- 加载条容器
local barContainer = Instance.new("Frame")
barContainer.Name = "BarContainer"
barContainer.AnchorPoint = Vector2.new(0.5, 0.5)
barContainer.Position = UDim2.new(0.5, 0, 0.75, 0)
barContainer.Size = UDim2.new(0.85, 0, 0.15, 0)
barContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
barContainer.BorderSizePixel = 0
barContainer.Parent = mainFrame

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0.5, 0)
containerCorner.Parent = barContainer

-- 加载条
local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Size = UDim2.new(0, 0, 1, 0)  -- 初始宽度0
loadingBar.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = barContainer

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0.5, 0)
barCorner.Parent = loadingBar

-- 添加到界面树
mainFrame.Parent = screenGui
screenGui.Parent = gui

-- 创建检测阶段元素（初始隐藏）
local circleFrame = Instance.new("Frame")
circleFrame.Name = "CircleFrame"
circleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
circleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
circleFrame.Size = UDim2.new(0, 0, 0, 0)  -- 初始尺寸0
circleFrame.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
circleFrame.Visible = false  -- 初始隐藏
circleFrame.Parent = screenGui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circleFrame

local detectionText = Instance.new("TextLabel")
detectionText.Name = "DetectionText"
detectionText.AnchorPoint = Vector2.new(0.5, 0.5)
detectionText.Position = UDim2.new(0.5, 0, 0.5, 0)
detectionText.Size = UDim2.new(0.7, 0, 0.1, 0)
detectionText.BackgroundTransparency = 1
detectionText.Text = "正在自动检测服务器，请您等待..."
detectionText.TextColor3 = Color3.new(1, 1, 1)
detectionText.Font = Enum.Font.GothamBold
detectionText.TextSize = 28
detectionText.Visible = false  -- 初始隐藏
detectionText.Parent = circleFrame

-- 核心动画流程函数
local function runAnimation()
    -- 1. 加载条填充动画
    local fillDuration = 2.5  -- 加载时间
    
    for time = 0, fillDuration, 1/60 do
        local progress = time / fillDuration
        loadingBar.Size = UDim2.new(progress, 0, 1, 0)
        RunService.RenderStepped:Wait()
    end
    
    loadingBar.Size = UDim2.new(1, 0, 1, 0)
    
    -- 2. UI缩小动画
    local shrinkTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0.01, 0, 0.01, 0),
        BackgroundTransparency = 1
    })
    
    shrinkTween:Play()
    shrinkTween.Completed:Wait()
    mainFrame.Visible = false
    
    -- 3. 圆形扩展动画
    circleFrame.Visible = true
    circleFrame.BackgroundTransparency = 0.3
    circleFrame.Position = mainFrame.Position  -- 从UI位置开始
    
    -- 计算目标尺寸（比屏幕尺寸大）
    local screenSize = workspace.CurrentCamera.ViewportSize
    local targetSize = math.max(screenSize.X, screenSize.Y) * 1.5
    
    local expandTween = TweenService:Create(circleFrame, TweenInfo.new(0.7), {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0.5, 0, 0.5, 0)  -- 确保最终在中心
    })
    
    expandTween:Play()
    expandTween.Completed:Wait()
    
    -- 4. 显示检测文本
    detectionText.Visible = true
    detectionText.TextTransparency = 1  -- 初始透明
    
    local textFadeIn = TweenService:Create(detectionText, TweenInfo.new(0.5), {
        TextTransparency = 0
    })
    
    textFadeIn:Play()
    textFadeIn.Completed:Wait()
    
    -- 5. 等待2.5秒
    wait(2.5)
    
    -- 6. 隐藏文本
    local textFadeOut = TweenService:Create(detectionText, TweenInfo.new(0.5), {
        TextTransparency = 1
    })
    
    textFadeOut:Play()
    textFadeOut.Completed:Wait()
    
    -- 7. 隐藏圆形
    local circleFadeOut = TweenService:Create(circleFrame, TweenInfo.new(0.7), {
        BackgroundTransparency = 1
    })
    
    circleFadeOut:Play()
    circleFadeOut.Completed:Wait()
    
    -- 8. 移除UI
    screenGui:Destroy()
end

-- 启动动画流程
coroutine.wrap(runAnimation)()
