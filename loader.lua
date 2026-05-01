--// Final Infinite Loading GUI (Smooth + Softer Color Transition)

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "LoadingGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 240)
frame.Position = UDim2.new(0.5, -250, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.15
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Drag
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 60)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Script Loading Please Wait"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
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
bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bar.Parent = barBG
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)

-- Glow
local glow = Instance.new("UIStroke")
glow.Thickness = 3
glow.Transparency = 0.4
glow.Parent = bar

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 10)
close.Text = ""
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Progress values
local realProgress = 0
local visualProgress = 0
local dotCount = 0
local hue = 0

-- Status function
local function getStatus(p)
    if p < 15 then return "Initializing"
    elseif p < 35 then return "Loading assets"
    elseif p < 55 then return "Connecting to server"
    elseif p < 75 then return "Fetching data"
    elseif p < 90 then return "Syncing resources"
    else return "Finalizing"
    end
end

-- Status animation
task.spawn(function()
    while true do
        dotCount = (dotCount % 3) + 1
        status.Text = getStatus(realProgress) .. string.rep(".", dotCount)
        task.wait(0.4)
    end
end)

-- Real progress logic
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

-- 🔥 Smooth update + normal speed + softer colors
RunService.RenderStepped:Connect(function(dt)
    -- Smooth progress
    local alpha = 1 - math.exp(-10 * dt)
    visualProgress = visualProgress + (realProgress - visualProgress) * alpha

    bar.Size = UDim2.new(visualProgress/100, 0, 1, 0)
    percent.Text = math.floor(visualProgress) .. "%"

    -- 🌈 Softer color transition (normal speed)
    hue = (hue + dt * 0.06) % 1
    local color = Color3.fromHSV(hue, 0.7, 0.85)

    bar.BackgroundColor3 = color
    glow.Color = color
end)
