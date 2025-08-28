-- 自适应网格布局UI系统
IP=nil
local AdaptiveGridUI = {
    Config = {
        Title = "MP Hub 背景配置      自行关闭     可不选，选择后无法更改",
        ButtonCount = 0,
        ButtonsPerRow = 5,
        ButtonSize = UDim2.new(0, 70, 0, 70),
        ButtonSpacing = 10,
        ContainerSize = UDim2.new(0, 450, 0, 350)
    },
    Buttons = {},
    UI = nil
}

-- 创建主界面
function AdaptiveGridUI:CreateMainUI()
    if self.UI then self.UI:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdaptiveGridUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    -- 主容器（居中圆角带边框）- 整个界面可拖动
    local mainContainer = Instance.new("TextButton")  -- 使用TextButton而不是Frame
    mainContainer.Name = "MainContainer"
    mainContainer.Size = self.Config.ContainerSize
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainContainer.BorderSizePixel = 0
    mainContainer.Text = ""  -- 清空文本
    mainContainer.AutoButtonColor = false  -- 禁用按钮颜色变化
    mainContainer.Draggable = true  -- 整个界面可拖动！
    mainContainer.Active = true  -- 确保可以交互
    mainContainer.ClipsDescendants = true
    mainContainer.Parent = screenGui

    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainContainer

    -- 边框
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Thickness = 2
    stroke.Parent = mainContainer

    -- 标题栏（只是显示，不可拖动）
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainContainer

    -- 标题栏圆角（只圆顶部）
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Config.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = titleBar

    -- 关闭按钮（正确位置在界面右上角）
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)  -- 右上角位置
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.ZIndex = 2
    closeButton.Parent = mainContainer  -- 直接放在主容器上
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    -- 内容区域（网格容器）
    local gridContainer = Instance.new("ScrollingFrame")
    gridContainer.Name = "GridContainer"
    gridContainer.Size = UDim2.new(1, -20, 1, -45)
    gridContainer.Position = UDim2.new(0, 10, 0, 40)
    gridContainer.BackgroundTransparency = 1
    gridContainer.BorderSizePixel = 0
    gridContainer.ScrollBarThickness = 4
    gridContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    gridContainer.Parent = mainContainer

    -- 网格布局
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellPadding = UDim2.new(0, self.Config.ButtonSpacing, 0, self.Config.ButtonSpacing)
    gridLayout.CellSize = self.Config.ButtonSize
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = gridContainer

    -- 关闭按钮事件
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        self.UI = nil
    end)

    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    end)

    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    end)

    self.UI = screenGui
    self.MainContainer = mainContainer
    self.GridContainer = gridContainer
    return screenGui
end

-- 添加按钮到网格
function AdaptiveGridUI:AddButton(config)
    if not self.UI then
        self:CreateMainUI()
    end

    local button = Instance.new("TextButton")
    button.Name = "Button_" .. self.Config.ButtonCount
    button.Size = self.Config.ButtonSize
    button.BackgroundColor3 = config.Color or Color3.fromRGB(60, 60, 70)
    button.Text = config.Text or "按钮"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 11
    button.LayoutOrder = self.Config.ButtonCount
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- 边框
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 110)
    stroke.Thickness = 1
    stroke.Parent = button

    -- 悬停效果
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = (config.Color or Color3.fromRGB(60, 60, 70)):Lerp(Color3.fromRGB(255, 255, 255), 0.1)
        button.TextColor3 = Color3.fromRGB(220, 220, 220)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = config.Color or Color3.fromRGB(60, 60, 70)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- 点击事件
    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end
    button.Parent = self.GridContainer
    self.Config.ButtonCount += 1
    
    table.insert(self.Buttons, button)
    return button
    
end

-- 添加图标按钮
function AdaptiveGridUI:AddIconButton(config)
    local button = self:AddButton({
        Text = "",
        Color = config.Color,
        Callback = config.Callback
    })

    -- 图标标签
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0.6, 0)
    iconLabel.Position = UDim2.new(0, 0, 0.2, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = config.Icon or "⚡"
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20
    iconLabel.Parent = button

    -- 文字标签
    if config.Text then
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -5, 0.3, 0)
        textLabel.Position = UDim2.new(0, 2.5, 0.7, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = config.Text
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextSize = 9
        textLabel.TextWrapped = true
        textLabel.Parent = button
    end

    return button
end

-- 使用示例：
AdaptiveGridUI:CreateMainUI()

-- 添加示例按钮
AdaptiveGridUI:AddIconButton({
    Icon = "海豹", 
    Text = "有点煳",
    Color = Color3.fromRGB(70, 150, 70),
    Callback = function()
    IP = "rbxassetid://113786259584052"
        print("海豹")
    end
})

AdaptiveGridUI:AddIconButton({
    Icon = "猫羽雫1", 
    Text = "不知道",
    Color = Color3.fromRGB(60, 120, 200),
    Callback = function()
    IP = "rbxassetid://130923340937036"
        print("打开设置")
    end
})

AdaptiveGridUI:AddIconButton({
    Icon = "猫羽雫2", 
    Text = "不知道",
    Color = Color3.fromRGB(60, 120, 200),
    Callback = function()
    IP = "rbxassetid://98446137628032"
        print("打开设置")
    end
})



