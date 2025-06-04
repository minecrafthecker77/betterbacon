-- Main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfiniteBacon"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.Parent = screenGui

-- Draggable bar
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
dragBar.Parent = frame

-- Title label
local title = Instance.new("TextLabel")
title.Text = "Infinite Bacon"
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 28)
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextSize = 15
title.Parent = dragBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSans
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(250, 20, 20)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BorderSizePixel = 0
closeButton.TextSize = 20
closeButton.Parent = dragBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Fake redeem button
local redeemButton = Instance.new("TextButton")
redeemButton.Text = "Redeem Bacon"
redeemButton.Font = Enum.Font.SourceSansBold
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
redeemButton.Size = UDim2.new(0, 200, 0, 50)
redeemButton.Position = UDim2.new(0, 50, 0, 185)
redeemButton.TextSize = 16
redeemButton.Parent = frame

-- Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 150, 0, 60)
label.Position = UDim2.new(0, 70, 0, 60)
label.Text = "This is a test GUI"
label.Font = Enum.Font.SourceSansBold
label.TextColor3 = Color3.fromRGB(200, 200, 255)
label.BackgroundColor3 = Color3.fromRGB(10, 109, 1000)
label.TextSize = 16
label.Parent = frame

-- TweenService animation
local TweenService = game:GetService("TweenService")
local function fadeIn(target)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return TweenService:Create(target, tweenInfo, { Transparency = 0 })
end

fadeIn(frame):Play()
fadeIn(label):Play()
fadeIn(redeemButton):Play()

-- Dragging
local dragging, dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)\n
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Redeem functionality
redeemButton.MouseButton1Click:Connect(function()
    print("[Bacon GUI] Redeem button clicked")
    wait(0.1) -- originally low, changed for logic control

    -- FireServer logic with exaggerated data (placeholder remote path)
    local Net = game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged
    if Net and Net.RedeemAnniversary then
        Net.RedeemAnniversary:FireServer({ amount = 64 }) -- exaggerated
    end

    wait(0.1)

    -- SetCore notice
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Success",
        Text = "You redeemed 999 bacon!",
        Duration = 99
    })
end)
