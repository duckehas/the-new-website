local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_GUI"
ScreenGui.Parent = game:GetService("CoreGui")  -- or PlayerGui

-- Create Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Toggle ESP"
ToggleButton.Parent = ScreenGui

local ESPEnabled = false
local boxes = {}

-- Function to create or update boxes around players
local function createESPBox(player)
    if player == LocalPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    if boxes[player] and boxes[player].Parent then
        -- Already have box
        return
    end

    -- Create box adornment
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = player.Character.HumanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Color3 = Color3.new(1, 0, 0) -- Red color
    box.Parent = player.Character.HumanoidRootPart

    boxes[player] = box
end

-- Remove all ESP boxes
local function removeAllBoxes()
    for player, box in pairs(boxes) do
        if box and box.Parent then
            box:Destroy()
        end
    end
    boxes = {}
end

-- Toggle ESP on button click
ToggleButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ToggleButton.Text = "ESP: ON"
    else
        ToggleButton.Text = "ESP: OFF"
        removeAllBoxes()
    end
end)

-- Update loop for ESP
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESPBox(player)
        end
    else
        removeAllBoxes()
    end
end)

-- Cleanup on character removing (to avoid orphan boxes)
Players.PlayerRemoving:Connect(function(player)
    if boxes[player] then
        boxes[player]:Destroy()
        boxes[player] = nil
    end
end)
