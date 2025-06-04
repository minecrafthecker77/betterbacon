-- Main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfiniteBacon"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
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

-- DateTime Label
local dateTimeLabel = Instance.new("TextLabel")
dateTimeLabel.Size = UDim2.new(0, 250, 0, 25)
dateTimeLabel.Position = UDim2.new(0, 25, 0, 40)
dateTimeLabel.Text = "2025-06-04 01:54:06 UTC" -- Current time
dateTimeLabel.Font = Enum.Font.SourceSans
dateTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dateTimeLabel.BackgroundTransparency = 1
dateTimeLabel.TextSize = 14
dateTimeLabel.Parent = frame

-- Status Label (New)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 250, 0, 25)
statusLabel.Position = UDim2.new(0, 25, 0, 150)
statusLabel.Text = "Ready to redeem"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Parent = frame

-- Update DateTime function
local function updateDateTime()
    local date = os.date("!*t")
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
label.Position = UDim2.new(0, 70, 0, 80)
label.Text = "Better Bacon v2.1"
label.Font = Enum.Font.SourceSansBold
label.TextColor3 = Color3.fromRGB(200, 200, 255)
label.BackgroundColor3 = Color3.fromRGB(10, 109, 100)
label.TextSize = 16
label.Parent = frame

-- Redeem button
local redeemButton = Instance.new("TextButton")
redeemButton.Text = "Redeem Bacon"
redeemButton.Font = Enum.Font.SourceSansBold
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
redeemButton.Size = UDim2.new(0, 200, 0, 50)
redeemButton.Position = UDim2.new(0, 50, 0, 220)
redeemButton.TextSize = 16
redeemButton.Parent = frame

-- Close functionality
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

-- Dragging functionality
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

-- Updated Redeem functionality with better error handling
redeemButton.MouseButton1Click:Connect(function()
    -- Update status
    statusLabel.Text = "Processing..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Get current UTC time for logging
    local currentTime = os.date("!*t")
    local timeString = string.format("%04d-%02d-%02d %02d:%02d:%02d UTC", 
        currentTime.year, currentTime.month, currentTime.day,
        currentTime.hour, currentTime.min, currentTime.sec)
    
    print(string.format("[Bacon GUI] Redeem attempt at %s", timeString))
    
    -- Attempt to find and use remote event with better error handling
    local success, result = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        -- Try multiple possible paths for the remote event
        local possiblePaths = {
            {"RedeemAnniversary"},
            {"Remotes", "RedeemBacon"},
            {"rbxts_include", "node_modules", "net", "out", "_NetManaged", "RedeemAnniversary"},
            {"Events", "RedeemBacon"}
        }
        
        local function findRemote()
            for _, path in ipairs(possiblePaths) do
                local current = ReplicatedStorage
                local found = true
                
                for _, name in ipairs(path) do
                    current = current:FindFirstChild(name)
                    if not current then
                        found = false
                        break
                    end
                end
                
                if found then
                    return current
                end
            end
            return nil
        end
        
        local remoteEvent = findRemote()
        
        if remoteEvent then
            -- Found the remote event, attempt to fire it
            remoteEvent:FireServer({
                amount = 64,
                timestamp = timeString,
                player = game.Players.LocalPlayer.Name
            })
            return true, "Success"
        else
            return false, "Remote event not found"
        end
    end)
    
    -- Handle the result
    if success and result == true then
        statusLabel.Text = "Successfully redeemed!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Success",
            Text = string.format("Redeemed at %s", timeString),
            Duration = 5
        })
    else
        statusLabel.Text = "Failed to redeem - Retrying..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Retry once after a short delay
        wait(1)
        
        -- Second attempt with alternative method
        local retrySuccess = pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remoteFunction = ReplicatedStorage:WaitForChild("RedeemBacon", 2)
            
            if remoteFunction then
                remoteFunction:InvokeServer({
                    amount = 64,
                    timestamp = timeString,
                    player = game.Players.LocalPlayer.Name,
                    retry = true
                })
            end
        end)
        
        if retrySuccess then
            statusLabel.Text = "Redemption successful!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            statusLabel.Text = "Failed to redeem"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Failed to redeem - Please try again later",
                Duration = 5
            })
        end
    end
end)

-- Initial time update
updateDateTime()
