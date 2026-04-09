-- ==============================================================================
-- OPTIMUM KEY SYSTEM - ENTERPRISE EDITION
-- ==============================================================================
-- Fully Featured, Animated, Glass UI with Sounds & Particle Systems
-- Refactored for maximum performance, scalability, and immediate visual feedback.
-- Includes Live Status Polling (Cache-Bypass) & Game Breaker Anti-Bypass
-- ==============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

-- Robust Safe execution context fallback
local function GetSafeGuiParent()
    if gethui then return gethui() end
    if RunService:IsStudio() then return player:WaitForChild("PlayerGui") end
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return player:WaitForChild("PlayerGui")
end

local GuiParent = GetSafeGuiParent()

-- ==============================================================================
-- SYSTEM CONFIGURATION
-- ==============================================================================
local Config = {
    SystemStatus = {
        -- Change this to true to stop NEW executions immediately.
        ScriptDown = false, 
        DownReason = "Just Testing Bro Dont worry script ain't down",
        
        -- To kick players who have ALREADY executed, the script checks this URL every 30 seconds.
        -- Create a raw text file (like Pastebin or Github) and type: false
        -- When you want to shut it down globally, change the text in the pastebin to: true|Your Reason Here
        LiveCheckURL = "https://pastebin.com/raw/ECD5PKTd"
    },
    KeySystem = {
        CorrectKey = "Rwnv-toEfk-69gI-PteDt",
        GetKeyURL = "https://pastebin.com/raw/pB1h5cjF",
        DiscordURL = "https://discord.gg/yv9GpfEzkC",
        MainScriptURL = "https://raw.githubusercontent.com/ScriptBN/ScriptOptimum-BN/refs/heads/main/README.lua"
    },
    Theme = {
        Background = Color3.fromRGB(5, 5, 8),
        MainFrame = Color3.fromRGB(15, 15, 17),
        BoxContainer = Color3.fromRGB(10, 10, 12),
        AccentPrimary = Color3.fromRGB(0, 170, 255),   -- Blue
        AccentSecondary = Color3.fromRGB(170, 0, 255), -- Purple
        TextLight = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(100, 100, 105),
        Success = Color3.fromRGB(0, 200, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 150, 0)
    },
    UI = {
        GlassTransparency = 0.15,
        BlurIntensity = 12,
        CornerRadius = 10,
        BorderThickness = 1.5
    },
    Animations = {
        Hover = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        Click = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Slide = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        Fade = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),  
        ParticleSpeedMin = 5, 
        ParticleSpeedMax = 10
    }
}

-- ==============================================================================
-- KILL SWITCH & GAME BREAKER SYSTEM
-- ==============================================================================

-- Function to completely break the game if they bypass the kick
local function BreakGameAndKick(reason)
    -- Attempt standard kick first
    pcall(function()
        player:Kick("🛑 OPTIMUM SCRIPT DOWN 🛑\n\nReason: " .. tostring(reason))
    end)
    
    -- Wait a second to see if they bypassed the kick
    task.wait(1)
    
    pcall(function()
        -- 1. Delete their character to lose all functions
        if player.Character then
            player.Character:Destroy()
        end
        
        -- 2. Create a massive black blocking screen
        local breakGui = Instance.new("ScreenGui")
        breakGui.Name = "CriticalError"
        breakGui.Parent = GuiParent
        breakGui.IgnoreGuiInset = true
        breakGui.DisplayOrder = 999999
        
        local bg = Instance.new("Frame", breakGui)
        bg.Size = UDim2.new(10, 0, 10, 0)
        bg.Position = UDim2.new(-5, 0, -5, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.ZIndex = 999999
        
        local txt = Instance.new("TextLabel", bg)
        txt.Size = UDim2.new(0.1, 0, 0.1, 0)
        txt.Position = UDim2.new(0.45, 0, 0.45, 0)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.fromRGB(255, 0, 0)
        txt.TextScaled = true
        txt.Font = Enum.Font.GothamBlack
        txt.Text = "SCRIPT DOWN: " .. tostring(reason) .. "\n\nPLEASE REJOIN."
        
        -- 3. Intentionally crash the client via memory loop to force a rejoin
        while true do end
    end)
end

-- Function to bypass executor HttpGet caching
local function FetchFreshData(url)
    local success, result = pcall(function()
        -- Append a random query parameter to bypass cache
        local cacheBusterUrl = url .. (string.find(url, "?") and "&" or "?") .. "cb=" .. tostring(tick())
        return game:HttpGet(cacheBusterUrl)
    end)
    
    if success and result then
        return result
    else
        -- Fallback to standard request if cachebuster causes a 404 (some raw CDNs do this)
        local fallbackSuccess, fallbackResult = pcall(function()
            return game:HttpGet(url)
        end)
        return fallbackSuccess and fallbackResult or ""
    end
end

-- 1st Check: If script is manually disabled in code for new executions
if Config.SystemStatus.ScriptDown then
    BreakGameAndKick(Config.SystemStatus.DownReason)
    return -- Halt entire script
end

-- 2nd Check: Live Polling for players already injected
local LivePollingActive = true
task.spawn(function()
    while LivePollingActive do 
        task.wait(30) -- Checks every 30 seconds silently in the background
        pcall(function()
            if Config.SystemStatus.LiveCheckURL and Config.SystemStatus.LiveCheckURL ~= "" then
                local statusData = FetchFreshData(Config.SystemStatus.LiveCheckURL)
                
                -- Strip all whitespace, newlines, and invisible characters
                statusData = string.gsub(statusData, "^%s*(.-)%s*$", "%1")
                local dataLower = string.lower(statusData)
                
                -- If URL says "true", it means script is down. 
                -- Format on your Pastebin should be: true|Reason goes here
                if string.sub(dataLower, 1, 4) == "true" then
                    local splitData = string.split(statusData, "|")
                    local liveReason = splitData[2] or Config.SystemStatus.DownReason
                    LivePollingActive = false -- Stop loop before crashing
                    BreakGameAndKick(liveReason)
                end
            end
        end)
    end
end)

-- ==============================================================================
-- SOUND MANAGER
-- ==============================================================================
local SoundManager = {
    Sounds = {},
    SoundGroup = nil
}

function SoundManager:Initialize()
    self.SoundGroup = Instance.new("SoundGroup")
    self.SoundGroup.Name = "OptimumKeySystemSounds"
    self.SoundGroup.Parent = SoundService

    local soundData = {
        Hover = {Id = "rbxassetid://6895086153", Volume = 0.5, Pitch = 1.2},
        Click = {Id = "rbxassetid://6895079853", Volume = 0.6, Pitch = 1.0},
        Success = {Id = "rbxassetid://4590657391", Volume = 0.8, Pitch = 1.0},
        Error = {Id = "rbxassetid://2865227271", Volume = 0.7, Pitch = 1.0},
        Notify = {Id = "rbxassetid://4590657391", Volume = 0.5, Pitch = 1.5}
    }

    for name, data in pairs(soundData) do
        local snd = Instance.new("Sound")
        snd.Name = "OptimumSound_" .. name
        snd.SoundId = data.Id
        snd.Volume = data.Volume
        snd.Pitch = data.Pitch
        snd.Parent = self.SoundGroup
        self.Sounds[name] = snd
    end
end

function SoundManager:Play(soundName)
    if self.Sounds[soundName] then
        local snd = self.Sounds[soundName]:Clone()
        snd.Parent = self.SoundGroup
        snd:Play()
        game.Debris:AddItem(snd, snd.TimeLength + 0.5)
    end
end

function SoundManager:Cleanup()
    for _, snd in pairs(self.Sounds) do
        if snd and snd.Parent then
            snd:Destroy()
        end
    end
    if self.SoundGroup then
        self.SoundGroup:Destroy()
    end
end

SoundManager:Initialize()

-- ==============================================================================
-- CORE UI CREATION & BLUR
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Optimum KeySystem | By Fuddy"
ScreenGui.Parent = GuiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BackgroundBlur = Instance.new("BlurEffect")
BackgroundBlur.Name = "OptimumBlur"
BackgroundBlur.Size = 0 
BackgroundBlur.Parent = Lighting

local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Name = "Overlay"
BackgroundOverlay.Size = UDim2.fromScale(1, 1)
BackgroundOverlay.Position = UDim2.fromScale(0, 0)
BackgroundOverlay.BackgroundColor3 = Config.Theme.Background
BackgroundOverlay.BackgroundTransparency = 1 
BackgroundOverlay.BorderSizePixel = 0
BackgroundOverlay.ZIndex = 1
BackgroundOverlay.Parent = ScreenGui

-- ==============================================================================
-- PARTICLE MANAGER 
-- ==============================================================================
local ParticleManager = {
    Container = nil,
    Active = false,
    Particles = {},
    LoopConnection = nil
}

function ParticleManager:Initialize(parentFrame)
    self.Container = Instance.new("Frame")
    self.Container.Name = "ParticleContainer"
    self.Container.Size = UDim2.fromScale(1, 1)
    self.Container.Position = UDim2.fromScale(0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.ZIndex = 2
    self.Container.ClipsDescendants = true
    self.Container.Parent = parentFrame
end

function ParticleManager:SpawnParticle(randomY)
    if not self.Active then return end

    local size = math.random(10, 35)
    local startX = math.random(0, 100) / 100
    local speed = math.random(Config.Animations.ParticleSpeedMin, Config.Animations.ParticleSpeedMax)
    
    local startY = 1.1
    if randomY then
        startY = math.random(0, 100) / 100
    end
    
    local Particle = Instance.new("Frame")
    Particle.Size = UDim2.new(0, size, 0, size)
    Particle.Position = UDim2.new(startX, 0, startY, 0)
    
    if math.random(1, 2) == 1 then
        Particle.BackgroundColor3 = Config.Theme.AccentPrimary
    else
        Particle.BackgroundColor3 = Config.Theme.AccentSecondary
    end
    
    Particle.BackgroundTransparency = math.random(5, 8) / 10
    Particle.BorderSizePixel = 0
    Particle.Rotation = math.random(0, 360)
    Particle.ZIndex = 2
    Particle.Parent = self.Container
    
    local PCorner = Instance.new("UICorner")
    PCorner.CornerRadius = UDim.new(0.5, 0)
    PCorner.Parent = Particle
    
    local targetY = math.random(-20, -5) / 100 
    local targetRot = Particle.Rotation + math.random(-180, 180)
    
    local moveTween = TweenService:Create(Particle, TweenInfo.new(speed, Enum.EasingStyle.Linear), {
        Position = UDim2.new(startX + (math.random(-15, 15)/100), 0, targetY, 0),
        Rotation = targetRot,
        BackgroundTransparency = 1
    })
    
    moveTween:Play()
    table.insert(self.Particles, Particle)
    
    moveTween.Completed:Connect(function()
        if Particle and Particle.Parent then
            Particle:Destroy()
        end
        for i, p in ipairs(self.Particles) do
            if p == Particle then
                table.remove(self.Particles, i)
                break
            end
        end
    end)
end

function ParticleManager:SpawnBurst(amount)
    for i = 1, amount do
        self:SpawnParticle(true) 
    end
end

function ParticleManager:Start()
    self.Active = true
    task.spawn(function()
        while self.Active do
            self:SpawnParticle(false)
            task.wait(math.random(1, 3) / 10) 
        end
    end)
end

function ParticleManager:Stop()
    self.Active = false
    for _, p in pairs(self.Particles) do
        if p and p.Parent then
            TweenService:Create(p, Config.Animations.Fade, {BackgroundTransparency = 1}):Play()
            game.Debris:AddItem(p, 0.5)
        end
    end
    self.Particles = {}
end

ParticleManager:Initialize(BackgroundOverlay)

-- ==============================================================================
-- NOTIFICATION MANAGER 
-- ==============================================================================
local NotificationManager = {
    List = {},
    Width = 200,  
    Height = 35,  
    Padding = 42, 
    StartX = 20,  
    StartY = 30   
}

function NotificationManager:Notify(text, duration, isError)
    duration = duration or 2.5
    local accentColor = isError and Config.Theme.Error or Config.Theme.Success

    if isError then
        SoundManager:Play("Error")
    else
        SoundManager:Play("Success")
    end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Size = UDim2.new(0, self.Width, 0, self.Height) 
    NotifFrame.Position = UDim2.new(1, self.StartX + 50, 0, self.StartY + (#self.List * self.Padding)) 
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    NotifFrame.BackgroundTransparency = 0.1
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 20
    NotifFrame.Parent = ScreenGui

    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 4)

    local NotifStroke = Instance.new("UIStroke", NotifFrame)
    NotifStroke.Color = accentColor
    NotifStroke.Thickness = 1
    NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -16, 1, 0)
    NotifText.Position = UDim2.new(0, 14, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(240, 240, 240)
    NotifText.Font = Enum.Font.GothamMedium
    
    NotifText.TextScaled = true
    NotifText.TextWrapped = true
    local TextConstraint = Instance.new("UITextSizeConstraint")
    TextConstraint.MaxTextSize = 13 
    TextConstraint.MinTextSize = 9
    TextConstraint.Parent = NotifText
    
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.ZIndex = 21
    NotifText.Parent = NotifFrame

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.Position = UDim2.new(0, 6, 0.2, 0)
    Indicator.BackgroundColor3 = accentColor
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 21
    Indicator.Parent = NotifFrame
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    table.insert(self.List, NotifFrame)

    local targetX = -self.Width - self.StartX
    TweenService:Create(NotifFrame, Config.Animations.Slide, {
        Position = UDim2.new(1, targetX, 0, self.StartY + ((#self.List - 1) * self.Padding))
    }):Play()

    task.delay(duration, function()
        if not NotifFrame or not NotifFrame.Parent then return end
        
        local fadeOut = TweenService:Create(NotifFrame, Config.Animations.Fade, {
            Position = UDim2.new(1, self.StartX + 50, 0, NotifFrame.Position.Y.Offset), 
            BackgroundTransparency = 1
        })
        TweenService:Create(NotifStroke, Config.Animations.Fade, {Transparency = 1}):Play()
        TweenService:Create(NotifText, Config.Animations.Fade, {TextTransparency = 1}):Play()
        TweenService:Create(Indicator, Config.Animations.Fade, {BackgroundTransparency = 1}):Play()
        
        fadeOut:Play()
        fadeOut.Completed:Wait()

        local index = table.find(self.List, NotifFrame)
        if index then
            table.remove(self.List, index)
            for i, frame in ipairs(self.List) do
                if frame and frame.Parent then
                    TweenService:Create(frame, Config.Animations.Slide, {
                        Position = UDim2.new(1, targetX, 0, self.StartY + ((i - 1) * self.Padding))
                    }):Play()
                end
            end
        end
        NotifFrame:Destroy()
    end)
end

-- ==============================================================================
-- MAIN INTERFACE CONSTRUCTION
-- ==============================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 310)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -120) 
MainFrame.BackgroundColor3 = Config.Theme.MainFrame
MainFrame.BackgroundTransparency = 1 
MainFrame.ZIndex = 3
MainFrame.Parent = BackgroundOverlay

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, Config.UI.CornerRadius)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = Config.UI.BorderThickness
MainStroke.Transparency = 1
MainStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Config.Theme.AccentPrimary),
    ColorSequenceKeypoint.new(0.5, Config.Theme.AccentSecondary),
    ColorSequenceKeypoint.new(1, Config.Theme.AccentPrimary)
}
StrokeGradient.Parent = MainStroke

-- Optimised RenderStepped connection for completely smooth rotation without crashing
local GradientRotationConnection
GradientRotationConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if not StrokeGradient or not StrokeGradient.Parent then
        if GradientRotationConnection then GradientRotationConnection:Disconnect() end
        return
    end
    
    local currentRotation = StrokeGradient.Rotation
    local newRotation = currentRotation + (120 * deltaTime) -- Rotates 120 degrees per second smoothly
    if newRotation >= 360 then newRotation = newRotation - 360 end
    StrokeGradient.Rotation = newRotation
end)

-- TITLE SECTION
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
TitleIcon.Image = "rbxassetid://10137902368"
TitleIcon.ImageColor3 = Config.Theme.AccentPrimary
TitleIcon.ImageTransparency = 1
TitleIcon.ZIndex = 4
TitleIcon.Parent = TitleContainer

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 55, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "OPTIMUM KEYSYSTEM | By Fuddy" 
TitleText.TextColor3 = Config.Theme.TextLight
TitleText.TextTransparency = 1
TitleText.Font = Enum.Font.GothamBlack

TitleText.TextScaled = true
local TitleConstraint = Instance.new("UITextSizeConstraint")
TitleConstraint.MaxTextSize = 14
TitleConstraint.Parent = TitleText

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
    ColorSequenceKeypoint.new(0, Config.Theme.MainFrame),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 55)),
    ColorSequenceKeypoint.new(1, Config.Theme.MainFrame)
}
DividerGradient.Parent = TitleDivider

-- TEXTBOX SECTION
local BoxContainer = Instance.new("Frame")
BoxContainer.Size = UDim2.new(0.9, 0, 0, 42)
BoxContainer.Position = UDim2.new(0.05, 0, 0, 70)
BoxContainer.BackgroundColor3 = Config.Theme.BoxContainer
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
Box.PlaceholderColor3 = Config.Theme.TextDim
Box.Text = ""
Box.TextColor3 = Config.Theme.TextLight
Box.TextTransparency = 1
Box.Font = Enum.Font.GothamMedium
Box.ClearTextOnFocus = false 

Box.TextScaled = true
local BoxConstraint = Instance.new("UITextSizeConstraint")
BoxConstraint.MaxTextSize = 13
BoxConstraint.Parent = Box

Box.TextXAlignment = Enum.TextXAlignment.Center 
Box.ZIndex = 5
Box.Parent = BoxContainer

local BoxPadding = Instance.new("UIPadding", Box)
BoxPadding.PaddingLeft = UDim.new(0, 0) 
BoxPadding.PaddingRight = UDim.new(0, 0)

Box.Focused:Connect(function()
    SoundManager:Play("Hover")
    TweenService:Create(BoxStroke, Config.Animations.Hover, {Color = Config.Theme.AccentPrimary}):Play()
end)

Box.FocusLost:Connect(function()
    TweenService:Create(BoxStroke, Config.Animations.Hover, {Color = Color3.fromRGB(40, 40, 45)}):Play()
end)

-- BUTTON FACTORY
local function CreateInteractiveButton(name, yPos, text, accentColor)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Size = UDim2.new(0.9, 0, 0, 42)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.BackgroundColor3 = Config.Theme.MainFrame
    Btn.BackgroundTransparency = 1
    Btn.Text = text
    Btn.TextColor3 = Config.Theme.TextLight
    Btn.TextTransparency = 1
    Btn.Font = Enum.Font.GothamBold
    
    Btn.TextScaled = true
    local BtnConstraint = Instance.new("UITextSizeConstraint")
    BtnConstraint.MaxTextSize = 13
    BtnConstraint.Parent = Btn
    
    Btn.AutoButtonColor = false
    Btn.ZIndex = 4
    Btn.Parent = MainFrame

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = accentColor
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Transparency = 1

    Btn.MouseEnter:Connect(function()
        if not Btn.Active then return end
        SoundManager:Play("Hover")
        TweenService:Create(Btn, Config.Animations.Hover, {BackgroundColor3 = accentColor}):Play()
        TweenService:Create(Btn, Config.Animations.Hover, {TextColor3 = Config.Theme.TextLight}):Play()
    end)

    Btn.MouseLeave:Connect(function()
        if not Btn.Active then return end
        TweenService:Create(Btn, Config.Animations.Hover, {BackgroundColor3 = Config.Theme.MainFrame}):Play()
    end)

    Btn.MouseButton1Down:Connect(function()
        if not Btn.Active then return end
        SoundManager:Play("Click")
        TweenService:Create(Btn, Config.Animations.Click, {
            Size = UDim2.new(0.86, 0, 0, 38), 
            Position = UDim2.new(0.07, 0, 0, yPos + 2)
        }):Play()
    end)

    Btn.MouseButton1Up:Connect(function()
        if not Btn.Active then return end
        TweenService:Create(Btn, Config.Animations.Click, {
            Size = UDim2.new(0.9, 0, 0, 42), 
            Position = UDim2.new(0.05, 0, 0, yPos)
        }):Play()
    end)

    return Btn, Stroke
end

local SubmitBtn, SubmitStroke = CreateInteractiveButton("SubmitBtn", 125, "Verify Key", Config.Theme.AccentPrimary)
local GetKeyBtn, GetKeyStroke = CreateInteractiveButton("GetKeyBtn", 180, "Get Key", Color3.fromRGB(255, 100, 0))
local DiscordBtn, DiscordStroke = CreateInteractiveButton("DiscordBtn", 235, "Join Discord", Color3.fromRGB(88, 101, 242))

-- ==============================================================================
-- ANIMATION CONTROLLERS
-- ==============================================================================
local function PerformIntro()
    TweenService:Create(BackgroundBlur, Config.Animations.Fade, {Size = Config.UI.BlurIntensity}):Play()
    TweenService:Create(BackgroundOverlay, Config.Animations.Fade, {BackgroundTransparency = 0.4}):Play()
    
    local mainTween = TweenService:Create(MainFrame, Config.Animations.Slide, {
        Position = UDim2.new(0.5, -170, 0.5, -155), 
        BackgroundTransparency = Config.UI.GlassTransparency 
    })
    mainTween:Play()

    ParticleManager:Start()
    ParticleManager:SpawnBurst(20) 

    local elementsToFade = {
        {Obj = MainStroke, Prop = "Transparency", Target = 0},
        {Obj = TitleText, Prop = "TextTransparency", Target = 0},
        {Obj = TitleIcon, Prop = "ImageTransparency", Target = 0},
        {Obj = TitleDivider, Prop = "BackgroundTransparency", Target = 0},
        
        {Obj = BoxContainer, Prop = "BackgroundTransparency", Target = 0.4},
        {Obj = BoxStroke, Prop = "Transparency", Target = 0},
        {Obj = Box, Prop = "TextTransparency", Target = 0},

        {Obj = SubmitBtn, Prop = "BackgroundTransparency", Target = 0.2},
        {Obj = SubmitBtn, Prop = "TextTransparency", Target = 0},
        {Obj = SubmitStroke, Prop = "Transparency", Target = 0},

        {Obj = GetKeyBtn, Prop = "BackgroundTransparency", Target = 0.2},
        {Obj = GetKeyBtn, Prop = "TextTransparency", Target = 0},
        {Obj = GetKeyStroke, Prop = "Transparency", Target = 0},

        {Obj = DiscordBtn, Prop = "BackgroundTransparency", Target = 0.2},
        {Obj = DiscordBtn, Prop = "TextTransparency", Target = 0},
        {Obj = DiscordStroke, Prop = "Transparency", Target = 0}
    }

    for _, data in ipairs(elementsToFade) do
        TweenService:Create(data.Obj, Config.Animations.Fade, {[data.Prop] = data.Target}):Play()
    end
end

local function PerformOutro()
    ParticleManager:Stop()
    
    -- Disconnect visual connections cleanly
    if GradientRotationConnection then
        GradientRotationConnection:Disconnect()
        GradientRotationConnection = nil
    end

    TweenService:Create(BackgroundBlur, Config.Animations.Fade, {Size = 0}):Play()

    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("UIStroke") then
            TweenService:Create(v, Config.Animations.Fade, {Transparency = 1}):Play()
        end
    end

    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 300, 0, 270),
        Position = UDim2.new(0.5, -150, 0.5, -120),
        BackgroundTransparency = 1
    }):Play()

    for _, v in pairs(ScreenGui:GetDescendants()) do
        if v:IsA("GuiObject") and not v:IsA("UIStroke") then
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                TweenService:Create(v, Config.Animations.Fade, {TextTransparency = 1}):Play()
            end
            if v:IsA("ImageLabel") then
                TweenService:Create(v, Config.Animations.Fade, {ImageTransparency = 1}):Play()
            end
            if v.Name ~= "MainFrame" and v.BackgroundTransparency < 1 then
                 TweenService:Create(v, Config.Animations.Fade, {BackgroundTransparency = 1}):Play()
            end
        end
    end

    task.wait(0.4)
    BackgroundBlur:Destroy()
    SoundManager:Cleanup()
    
    -- Clear references then destroy
    ScreenGui:Destroy()
end

-- ==============================================================================
-- LOGIC & EVENT HANDLERS
-- ==============================================================================

SubmitBtn.MouseButton1Click:Connect(function()
    if Box.Text == Config.KeySystem.CorrectKey then
        NotificationManager:Notify("Key Authenticated Successfully!", 2, false)
        
        Box.TextEditable = false
        SubmitBtn.Active = false
        
        -- Change button state to a success indicator visually
        TweenService:Create(SubmitBtn, Config.Animations.Fade, {BackgroundColor3 = Config.Theme.Success}):Play()
        
        task.wait(1.5)
        PerformOutro()

        task.wait(0.5)
        local success, errorMessage = pcall(function()
            -- Force secure closure to avoid executor environment leaks
            local func = loadstring(game:HttpGet(Config.KeySystem.MainScriptURL))
            if func then
                func()
            else
                error("Script payload returned nil")
            end
        end)

        if success then
            NotificationManager:Notify("Optimum Script loaded successfully!", 4, false)
        else
            NotificationManager:Notify("Failed to load script: " .. tostring(errorMessage), 5, true)
            warn("Optimum Load Error: ", errorMessage)
        end
    else
        NotificationManager:Notify("Invalid Key Provided", 2.5, true)
        
        -- Red Flash Error Animation on Box
        local oldStrokeColor = BoxStroke.Color
        TweenService:Create(BoxStroke, Config.Animations.Hover, {Color = Config.Theme.Error}):Play()
        task.wait(0.5)
        TweenService:Create(BoxStroke, Config.Animations.Hover, {Color = oldStrokeColor}):Play()
    end
end)

local hasCopiedKey = false
GetKeyBtn.MouseButton1Click:Connect(function()
    if hasCopiedKey then
        NotificationManager:Notify("Key link is already in your clipboard", 2, true)
        return
    end
    
    if setclipboard then
        local success = pcall(function() setclipboard(Config.KeySystem.GetKeyURL) end)
        if success then
            hasCopiedKey = true
            NotificationManager:Notify("Key Link Copied! Paste it in your browser.", 5, false)
        else
            NotificationManager:Notify("Failed to access your clipboard.", 3, true)
        end
    else
        NotificationManager:Notify("Your executor doesn't support clipboard copying.", 3, true)
    end
end)

local hasCopiedDiscord = false
DiscordBtn.MouseButton1Click:Connect(function()
    if hasCopiedDiscord then
        NotificationManager:Notify("Discord link is already in your clipboard", 2, true)
        return
    end
    
    if setclipboard then
        local success = pcall(function() setclipboard(Config.KeySystem.DiscordURL) end)
        if success then
            hasCopiedDiscord = true
            NotificationManager:Notify("Discord Link Copied!", 3, false)
        else
            NotificationManager:Notify("Failed to access your clipboard.", 3, true)
        end
    else
        NotificationManager:Notify("Your executor doesn't support clipboard copying.", 3, true)
    end
end)

-- ==============================================================================
-- INITIALIZATION
-- ==============================================================================
PerformIntro()
