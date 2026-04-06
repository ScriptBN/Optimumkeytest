-- ==========================================
-- OPTIMUM KEY SYSTEM - PREMIUM EDITION
-- ==========================================
-- Fully Featured, Animated, Glass UI with Sounds
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
-- Using CoreGui is safer for exploits, but falling back to PlayerGui if normal execution
local GuiParent = (RunService and RunService:IsStudio()) and player:WaitForChild("PlayerGui") or (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

-- ==========================================
-- CONFIGURATION
-- ==========================================
local CORRECT_KEY = "Rwnv-toEfk-69gI-PteDt"
local GET_KEY_LINK = "https://pastebin.com/raw/pB1h5cjF" 
local DISCORD_LINK = "https://discord.gg/yv9GpfEzkC" 

-- ==========================================
-- SOUND SYSTEM (NEW)
-- ==========================================
-- We parent sounds to Workspace temporarily to preload them, then move them to the UI
local Sounds = {
    Hover = Instance.new("Sound"),
    Click = Instance.new("Sound"),
    Success = Instance.new("Sound"),
    Error = Instance.new("Sound"),
    Notify = Instance.new("Sound")
}

Sounds.Hover.SoundId = "rbxassetid://6895086153"
Sounds.Hover.Volume = 0.5
Sounds.Hover.Pitch = 1.2

Sounds.Click.SoundId = "rbxassetid://6895079853"
Sounds.Click.Volume = 0.6

Sounds.Success.SoundId = "rbxassetid://4590657391"
Sounds.Success.Volume = 0.8

Sounds.Error.SoundId = "rbxassetid://2865227271"
Sounds.Error.Volume = 0.7

Sounds.Notify.SoundId = "rbxassetid://4590657391"
Sounds.Notify.Volume = 0.5
Sounds.Notify.Pitch = 1.5

-- Parent sounds
for _, sound in pairs(Sounds) do
    sound.Parent = Workspace
end

-- ==========================================
-- TWEENING SETTINGS
-- ==========================================
local HoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local ClickInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SlideInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local FadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ParticleInfo = TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

-- ==========================================
-- BLUR EFFECT (GLASS LOOK ADDITION)
-- ==========================================
local BackgroundBlur = Instance.new("BlurEffect")
BackgroundBlur.Name = "OptimumBlur"
BackgroundBlur.Size = 0 -- Starts at 0, tweens up
BackgroundBlur.Parent = Lighting

-- ==========================================
-- SCREEN GUI BUILD
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OptimumKeySystem"
ScreenGui.Parent = GuiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- FULL BACKGROUND (Dark Glass Overlay)
local Background = Instance.new("Frame")
Background.Name = "Overlay"
Background.Size = UDim2.fromScale(1, 1)
Background.Position = UDim2.fromScale(0, 0)
Background.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Background.BackgroundTransparency = 1 -- Starts transparent for intro
Background.BorderSizePixel = 0
Background.ZIndex = 1
Background.Parent = ScreenGui

-- ==========================================
-- ANIMATED BACKGROUND SYSTEM (NEW)
-- ==========================================
local ParticleContainer = Instance.new("Frame")
ParticleContainer.Name = "ParticleContainer"
ParticleContainer.Size = UDim2.fromScale(1, 1)
ParticleContainer.Position = UDim2.fromScale(0, 0)
ParticleContainer.BackgroundTransparency = 1
ParticleContainer.ZIndex = 2
ParticleContainer.ClipsDescendants = true
ParticleContainer.Parent = Background

local particleActive = true

-- Function to spawn dynamic floating particles
local function spawnParticle()
    if not particleActive then return end

    local size = math.random(10, 40)
    local startX = math.random(0, 100) / 100
    local speed = math.random(8, 15)
    
    local Particle = Instance.new("Frame")
    Particle.Size = UDim2.new(0, size, 0, size)
    Particle.Position = UDim2.new(startX, 0, 1.1, 0)
    
    -- Randomize colors slightly between blue and purple to match UI
    local isBlue = math.random(1, 2) == 1
    if isBlue then
        Particle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    else
        Particle.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    end
    
    Particle.BackgroundTransparency = math.random(6, 9) / 10
    Particle.BorderSizePixel = 0
    Particle.Rotation = math.random(0, 360)
    Particle.ZIndex = 2
    Particle.Parent = ParticleContainer
    
    local PCorner = Instance.new("UICorner")
    PCorner.CornerRadius = UDim.new(0.5, 0) -- Make them circles
    PCorner.Parent = Particle
    
    -- Animate Particle moving up and fading out
    local targetY = math.random(-20, 20) / 100 -- Floats past the top of the screen
    local targetRot = Particle.Rotation + math.random(-180, 180)
    
    local moveTween = TweenService:Create(Particle, TweenInfo.new(speed, Enum.EasingStyle.Linear), {
        Position = UDim2.new(startX + (math.random(-10, 10)/100), 0, targetY, 0),
        Rotation = targetRot,
        BackgroundTransparency = 1
    })
    
    moveTween:Play()
    moveTween.Completed:Connect(function()
        Particle:Destroy()
    end)
end

-- Particle Loop Routine
task.spawn(function()
    while particleActive do
        spawnParticle()
        task.wait(math.random(2, 5) / 10) -- Random intervals for natural feel
    end
end)

-- ==========================================
-- MAIN UI FRAME
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 310)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -130) -- Starts slightly lower for pop-in effect
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
MainFrame.BackgroundTransparency = 1 -- Will tween to glass-like transparency
MainFrame.ZIndex = 3
MainFrame.Parent = Background

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- MAIN FRAME ANIMATED STROKE
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1
MainStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
StrokeGradient.Parent = MainStroke

-- Animate the gradient rotation continuously
task.spawn(function()
    local rotation = 0
    while MainFrame.Parent do
        rotation = rotation + 1
        if rotation >= 360 then rotation = 0 end
        StrokeGradient.Rotation = rotation
        task.wait(0.01)
    end
end)

-- ==========================================
-- TITLE CONTAINER
-- ==========================================
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(1, 0, 0, 50)
TitleContainer.Position = UDim2.new(0, 0, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.ZIndex = 4
TitleContainer.Parent = MainFrame

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 24, 0, 24)
TitleIcon.Position = UDim2.new(0, 20, 0.5, -12)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://10137902368" -- Cool key/shield icon
TitleIcon.ImageColor3 = Color3.fromRGB(0, 170, 255)
TitleIcon.ImageTransparency = 1
TitleIcon.ZIndex = 4
TitleIcon.Parent = TitleContainer

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 55, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "OPTIMUM KEY SYSTEM"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextTransparency = 1
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 4
TitleText.Parent = TitleContainer

local TitleDivider = Instance.new("Frame")
TitleDivider.Size = UDim2.new(0.9, 0, 0, 1)
TitleDivider.Position = UDim2.new(0.05, 0, 1, 0)
TitleDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleDivider.BackgroundTransparency = 1
TitleDivider.BorderSizePixel = 0
TitleDivider.ZIndex = 4
TitleDivider.Parent = TitleContainer

local DividerGradient = Instance.new("UIGradient")
DividerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 17)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 17))
}
DividerGradient.Parent = TitleDivider

-- ==========================================
-- TEXTBOX (CENTER FIX APPLIED)
-- ==========================================
local BoxContainer = Instance.new("Frame")
BoxContainer.Size = UDim2.new(0.9, 0, 0, 42)
BoxContainer.Position = UDim2.new(0.05, 0, 0, 70)
BoxContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
BoxContainer.BackgroundTransparency = 1
BoxContainer.ZIndex = 4
BoxContainer.Parent = MainFrame

Instance.new("UICorner", BoxContainer).CornerRadius = UDim.new(0, 6)
local BoxStroke = Instance.new("UIStroke", BoxContainer)
BoxStroke.Color = Color3.fromRGB(40, 40, 45)
BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BoxStroke.Transparency = 1

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(1, 0, 1, 0)
Box.Position = UDim2.new(0, 0, 0, 0)
Box.BackgroundTransparency = 1
Box.PlaceholderText = "Paste your key here..."
Box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextTransparency = 1
Box.Font = Enum.Font.GothamMedium
Box.TextSize = 13
-- FIX: Changed TextXAlignment to Center so text looks even and symmetric
Box.TextXAlignment = Enum.TextXAlignment.Center 
Box.ZIndex = 5
Box.Parent = BoxContainer

-- FIX: Maintained Padding Object but set values to 0 to prevent off-center push while obeying constraints
local BoxPadding = Instance.new("UIPadding", Box)
BoxPadding.PaddingLeft = UDim.new(0, 0) 
BoxPadding.PaddingRight = UDim.new(0, 0)

-- Focus animations for TextBox
Box.Focused:Connect(function()
    Sounds.Hover:Play()
    TweenService:Create(BoxStroke, HoverInfo, {Color = Color3.fromRGB(0, 170, 255)}):Play()
end)

Box.FocusLost:Connect(function()
    TweenService:Create(BoxStroke, HoverInfo, {Color = Color3.fromRGB(40, 40, 45)}):Play()
end)

-- ==========================================
-- BUTTON CREATION FUNCTION WITH SOUNDS
-- ==========================================
local function createButton(name, yPos, text, accentColor)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Size = UDim2.new(0.9, 0, 0, 42)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Btn.BackgroundTransparency = 1
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextTransparency = 1
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.ZIndex = 4
    Btn.Parent = MainFrame

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = accentColor
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Transparency = 1

    -- Hover animations & Sounds
    Btn.MouseEnter:Connect(function()
        Sounds.Hover:Play()
        TweenService:Create(Btn, HoverInfo, {BackgroundColor3 = accentColor}):Play()
        TweenService:Create(Btn, HoverInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, HoverInfo, {BackgroundColor3 = Color3.fromRGB(15, 15, 17)}):Play()
    end)

    Btn.MouseButton1Down:Connect(function()
        Sounds.Click:Play()
        TweenService:Create(Btn, ClickInfo, {Size = UDim2.new(0.86, 0, 0, 38), Position = UDim2.new(0.07, 0, 0, yPos + 2)}):Play()
    end)

    Btn.MouseButton1Up:Connect(function()
        TweenService:Create(Btn, ClickInfo, {Size = UDim2.new(0.9, 0, 0, 42), Position = UDim2.new(0.05, 0, 0, yPos)}):Play()
    end)

    return Btn, Stroke
end

local SubmitBtn, SubmitStroke = createButton("SubmitBtn", 125, "Verify Key", Color3.fromRGB(0, 170, 255))
local GetKeyBtn, GetKeyStroke = createButton("GetKeyBtn", 180, "Get Key", Color3.fromRGB(255, 100, 0))
local DiscordBtn, DiscordStroke = createButton("DiscordBtn", 235, "Join Discord", Color3.fromRGB(88, 101, 242))

-- ==========================================
-- NOTIFICATION SYSTEM (FIXED & SOUNDS ADDED)
-- ==========================================
local NotificationList = {}

local function notify(text, duration, isError)
    duration = duration or 2.5
    local accent = isError and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)

    -- Play corresponding sound
    if isError then
        Sounds.Error:Play()
    else
        Sounds.Success:Play()
    end

    -- Container for the notification
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 220, 0, 36) 
    
    -- FIX: Moved initial X position further right and added more vertical space (50 instead of 45 multiplier)
    NotifFrame.Position = UDim2.new(1, 50, 0, 30 + (#NotificationList * 50)) 
    
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    NotifFrame.BackgroundTransparency = 0.1 -- Slight glass effect on notifications too
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 10
    NotifFrame.Parent = ScreenGui

    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 4)

    local NotifStroke = Instance.new("UIStroke", NotifFrame)
    NotifStroke.Color = accent
    NotifStroke.Thickness = 1.2
    NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -15, 1, 0)
    NotifText.Position = UDim2.new(0, 15, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(240, 240, 240)
    NotifText.Font = Enum.Font.GothamMedium
    NotifText.TextSize = 11
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.ZIndex = 11
    NotifText.Parent = NotifFrame

    -- Color bar indicator on the left
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.Position = UDim2.new(0, 6, 0.2, 0)
    Indicator.BackgroundColor3 = accent
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 11
    Indicator.Parent = NotifFrame
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    table.insert(NotificationList, NotifFrame)

    -- FIX: Slide In Target - Further left from edge so it doesn't touch UI, adjusted Y padding
    TweenService:Create(NotifFrame, SlideInfo, {
        Position = UDim2.new(1, -250, 0, 30 + ((#NotificationList - 1) * 50))
    }):Play()

    -- Cleanup Routine
    task.delay(duration, function()
        -- Slide Out
        local fadeOut = TweenService:Create(NotifFrame, FadeInfo, {
            Position = UDim2.new(1, 50, 0, NotifFrame.Position.Y.Offset), 
            BackgroundTransparency = 1
        })
        TweenService:Create(NotifStroke, FadeInfo, {Transparency = 1}):Play()
        TweenService:Create(NotifText, FadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(Indicator, FadeInfo, {BackgroundTransparency = 1}):Play()
        
        fadeOut:Play()
        fadeOut.Completed:Wait()

        -- Remove from table and rearrange others
        local index = table.find(NotificationList, NotifFrame)
        if index then
            table.remove(NotificationList, index)
            for i, frame in ipairs(NotificationList) do
                -- Maintain the fixed offsets during rearrangement
                TweenService:Create(frame, SlideInfo, {
                    Position = UDim2.new(1, -250, 0, 30 + ((i - 1) * 50))
                }):Play()
            end
        end
        NotifFrame:Destroy()
    end)
end

-- ==========================================
-- UI INTRO & OUTRO ANIMATIONS (GLASS ADDED)
-- ==========================================
local function introUI()
    -- Enable Blur
    TweenService:Create(BackgroundBlur, FadeInfo, {Size = 12}):Play()

    -- Fade Background Overlay
    TweenService:Create(Background, FadeInfo, {BackgroundTransparency = 0.5}):Play()
    
    -- Slide Main Frame & apply glass transparency
    local mainTween = TweenService:Create(MainFrame, SlideInfo, {
        Position = UDim2.new(0.5, -170, 0.5, -155), 
        BackgroundTransparency = 0.15 -- FIX: This creates the "see-through" aesthetic from the image
    })
    mainTween:Play()

    -- Fade in elements
    TweenService:Create(MainStroke, FadeInfo, {Transparency = 0}):Play()
    TweenService:Create(TitleText, FadeInfo, {TextTransparency = 0}):Play()
    TweenService:Create(TitleIcon, FadeInfo, {ImageTransparency = 0}):Play()
    TweenService:Create(TitleDivider, FadeInfo, {BackgroundTransparency = 0}):Play()
    
    -- Box Container Glass Match
    TweenService:Create(BoxContainer, FadeInfo, {BackgroundTransparency = 0.4}):Play() 
    TweenService:Create(BoxStroke, FadeInfo, {Transparency = 0}):Play()
    TweenService:Create(Box, FadeInfo, {TextTransparency = 0}):Play()

    TweenService:Create(SubmitBtn, FadeInfo, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(SubmitStroke, FadeInfo, {Transparency = 0}):Play()

    TweenService:Create(GetKeyBtn, FadeInfo, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(GetKeyStroke, FadeInfo, {Transparency = 0}):Play()

    TweenService:Create(DiscordBtn, FadeInfo, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(DiscordStroke, FadeInfo, {Transparency = 0}):Play()
end

local function fadeOutUI()
    -- Stop background particle spawner
    particleActive = false

    -- Blur out
    TweenService:Create(BackgroundBlur, FadeInfo, {Size = 0}):Play()

    -- Hide strokes first
    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("UIStroke") then
            TweenService:Create(v, FadeInfo, {Transparency = 1}):Play()
        end
    end

    -- Shrink and fade main frame
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 300, 0, 270),
        Position = UDim2.new(0.5, -150, 0.5, -135)
    }):Play()

    for _, v in pairs(ScreenGui:GetDescendants()) do
        if v:IsA("GuiObject") and not v:IsA("UIStroke") then
            if v.BackgroundTransparency < 1 then
                TweenService:Create(v, FadeInfo, {BackgroundTransparency = 1}):Play()
            end
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                TweenService:Create(v, FadeInfo, {TextTransparency = 1}):Play()
            end
            if v:IsA("ImageLabel") then
                TweenService:Create(v, FadeInfo, {ImageTransparency = 1}):Play()
            end
        end
    end

    task.wait(0.5)
    BackgroundBlur:Destroy()
    
    -- Cleanup sounds
    for _, sound in pairs(Sounds) do
        sound:Destroy()
    end
    
    ScreenGui:Destroy()
end

-- ==========================================
-- MAIN LOGIC (KEY SYSTEM)
-- ==========================================
SubmitBtn.MouseButton1Click:Connect(function()
    if Box.Text == CORRECT_KEY then
        notify("Key Authenticated Successfully!", 2, false)
        task.wait(1.5)

        fadeOutUI()

        notify("Loading Scripts...", 2, false)
        task.wait(1)

        local success, errorMessage = pcall(function()
            -- Loading main execution script
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptBN/ScriptOptimum-BN/refs/heads/main/README.lua"))()
        end)

        if success then
            notify("Optimum Script Loaded!", 3, false)
        else
            notify("Error Loading Script", 4, true)
            warn("Failed to load: " .. tostring(errorMessage))
        end
    else
        notify("Invalid Key Provided", 2.5, true)
        
        -- Shake effect on wrong key
        local originalPos = MainFrame.Position
        for i = 1, 4 do
            MainFrame.Position = originalPos + UDim2.new(0, math.random(-6, 6), 0, 0)
            task.wait(0.04)
        end
        MainFrame.Position = originalPos
    end
end)

-- ==========================================
-- GET KEY LOGIC
-- ==========================================
local hasCopiedKey = false
GetKeyBtn.MouseButton1Click:Connect(function()
    if hasCopiedKey then
        notify("Key link is already in your clipboard", 2, true)
    else
        if setclipboard then
            setclipboard(GET_KEY_LINK)
            hasCopiedKey = true
            notify("Key Link Copied! Paste it in your browser.", 5, false)
        else
            notify("Your executor doesn't support clipboard copying.", 3, true)
        end
    end
end)

-- ==========================================
-- DISCORD LOGIC
-- ==========================================
local hasCopiedDiscord = false
DiscordBtn.MouseButton1Click:Connect(function()
    if hasCopiedDiscord then
        notify("Discord link is already in your clipboard", 2, true)
    else
        if setclipboard then
            setclipboard(DISCORD_LINK)
            hasCopiedDiscord = true
            notify("Discord Link Copied!", 3, false)
        else
            notify("Your executor doesn't support clipboard copying.", 3, true)
        end
    end
end)

-- Start the main intro initialization animation
introUI()
