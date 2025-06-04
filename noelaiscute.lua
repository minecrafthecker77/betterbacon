-- Main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfiniteBacon"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300) -- Increased height for datetime
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
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

-- DateTime Label (New)
local dateTimeLabel = Instance.new("TextLabel")
dateTimeLabel.Size = UDim2.new(0, 250, 0, 25)
dateTimeLabel.Position = UDim2.new(0, 25, 0, 40)
dateTimeLabel.Text = "Loading time..."
dateTimeLabel.Font = Enum.Font.SourceSans
dateTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dateTimeLabel.BackgroundTransparency = 1
dateTimeLabel.TextSize = 14
dateTimeLabel.Parent = frame

-- Update DateTime function
local function updateDateTime()
    local date = os.date("!*t") -- Use UTC time
    local formattedDateTime = string.format(
        "%04d-%02d-%02d %02d:%02d:%02d UTC",
        date.year, date.month, date.day,
        date.hour, date.min, date.sec
    )
    dateTimeLabel.Text = formattedDateTime
end

-- Update time every second
spawn(function()
    while wait(1) do
        updateDateTime()
    end
end)

-- Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 150, 0, 60)
label.Position = UDim2.new(0, 70, 0, 80) -- Adjusted position
label.Text = "Better Bacon v2.0"
label.Font = Enum.Font.SourceSansBold
label.TextColor3 = Color3.fromRGB(200, 200, 255)
label.BackgroundColor3 = Color3.fromRGB(10, 109, 100)
label.TextSize = 16
label.Parent = frame

-- Fake redeem button with current positioning
local redeemButton = Instance.new("TextButton")
redeemButton.Text = "Redeem Bacon"
redeemButton.Font = Enum.Font.SourceSansBold
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
redeemButton.Size = UDim2.new(0, 200, 0, 50)
redeemButton.Position = UDim2.new(0, 50, 0, 220) -- Adjusted position
redeemButton.TextSize = 16
redeemButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

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
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Redeem functionality
redeemButton.MouseButton1Click:Connect(function()
    -- Get current UTC time for logging
    local currentTime = os.date("!*t")
    local timeString = string.format("%04d-%02d-%02d %02d:%02d:%02d UTC", 
        currentTime.year, currentTime.month, currentTime.day,
        currentTime.hour, currentTime.min, currentTime.sec)
    
    print(string.format("[Bacon GUI] Redeem attempt at %s", timeString))
    
    -- Add delay for rate limiting
    wait(0.5)

    -- Attempt to find and use remote event
    local success, message = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Net = ReplicatedStorage:WaitForChild("rbxts_include", 2)
            :WaitForChild("node_modules", 2)
            :WaitForChild("net", 2)
            :WaitForChild("out", 2)
            :WaitForChild("_NetManaged", 2)
        
        if Net and Net:FindFirstChild("RedeemAnniversary") then
            Net.RedeemAnniversary:FireServer({ 
                amount = 64,
                timestamp = timeString
            })
            return "Success"
        end
        return "Remote event not found"
    end)

    -- Notification with timestamp
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = success and "Success" or "Error",
        Text = success and string.format("Redeemed at %s", timeString) or "Failed to redeem",
        Duration = 5
    })
end)

-- Initial time update
updateDateTime()
