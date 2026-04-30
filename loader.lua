--// Smooth Infinite Loading GUI (same speed, smoother visuals)

local player = game:GetService("Players").LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LoadingGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 0.4
overlay.Parent = gui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 240)
frame.Position = UDim2.new(0.5, -250, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.15
frame.Parent = overlay
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "Script Loading Please Wait"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Credit
local credit = Instance.new("TextLabel")
credit.Position = UDim2.new(0, 0, 0, 60)
credit.Size = UDim2.new(1, 0, 0, 25)
credit.BackgroundTransparency = 1
credit.Text = "Script by: Moonscript0"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.TextScaled = true
credit.Font = Enum.Font.Gotham
credit.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0, 0, 0, 90)
status.Size = UDim2.new(1, 0, 0, 25)
status.BackgroundTransparency = 1
status.Text = "Initializing"
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Percent
local percent = Instance.new("TextLabel")
percent.Position = UDim2.new(0, 0, 0, 115)
percent.Size = UDim2.new(1, 0, 0, 25)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.new(1,1,1)
percent.TextScaled = true
percent.Font = Enum.Font.GothamBold
percent.Parent = frame

-- Bar BG
local barBG = Instance.new("Frame")
barBG.Position = UDim2.new(0.1, 0, 0, 150)
barBG.Size = UDim2.new(0.8, 0, 0, 25)
barBG.BackgroundColor3 = Color3.fromRGB(200,200,200)
barBG.Parent = frame
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 8)

-- Bar Fill
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
bar.Parent = barBG
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 10)
close.Text = "-"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Messages
local messages = {
    "Initializing",
    "Loading assets",
    "Connecting to server",
    "Fetching data",
    "Syncing resources",
    "Finalizing"
}

local realProgress = 0   -- actual logic
local visualProgress = 0 -- smoothed display
local msgIndex = 1
local dotCount = 0

-- Animated text
task.spawn(function()
    while true do
        dotCount = (dotCount % 3) + 1
        status.Text = messages[msgIndex] .. string.rep(".", dotCount)

        if math.random() < 0.2 then
            msgIndex = math.random(1, #messages)
        end

        task.wait(0.4)
    end
end)

-- Real progress logic (UNCHANGED speed feel)
task.spawn(function()
    while true do
        local speed = (1 - realProgress/100)^2 * 2
        local increment = math.random() * speed

        realProgress = math.clamp(realProgress + increment, 0, 99)

        if realProgress > 90 and math.random() < 0.3 then
            task.wait(math.random(1,3))
        else
            task.wait(0.05)
        end
    end
end)

-- Smooth visual update
while true do
    -- LERP toward real value (this is the only smoothing)
    visualProgress = visualProgress + (realProgress - visualProgress) * 0.1

    bar.Size = UDim2.new(visualProgress/100, 0, 1, 0)
    percent.Text = math.floor(visualProgress) .. "%"

    task.wait(0.016) -- ~60 FPS smoothness
end
