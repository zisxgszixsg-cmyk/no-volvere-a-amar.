--!strict
--[[
    
    ██████╗  ██████╗ ████████╗██╗  ██╗ █████╗ ███╗   ███╗
    ██╔════╝ ██╔═══██╗╚══██╔══╝██║  ██║██╔══██╗████╗ ████║
    ██║  ███╗██║   ██║   ██║   ███████║███████║██╔████╔██║
    ██║   ██║██║   ██║   ██║   ██╔══██║██╔══██║██║╚██╔╝██║
    ╚██████╔╝╚██████╔╝   ██║   ██║  ██║██║  ██║██║ ╚═╝ ██║
     ╚═════╝  ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
                                                          
    ████████╗ █████╗  ██████╗████████╗██╗ ██████╗ █████╗ ██╗     
    ╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝██║██╔════╝██╔══██╗██║     
       ██║   ███████║██║        ██║   ██║██║     ███████║██║     
       ██║   ██╔══██║██║        ██║   ██║██║     ██╔══██║██║     
       ██║   ██║  ██║╚██████╗   ██║   ██║╚██████╗██║  ██║███████╗
       ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
                                                                 
    ██╗███╗   ██╗████████╗███████╗██████╗ ███████╗ █████╗  ██████╗███████╗
    ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝
    ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  ███████║██║     █████╗  
    ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║     ██╔══╝  
    ██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ██║  ██║╚██████╗███████╗
    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝

    ====================================================================
    GOTHAM TACTICAL INTERFACE SYSTEM (GTIS) v5.0 - ARKHAM KNIGHT EDITION
    ====================================================================
    
    AUTOR: Antigravity AI (Advanced Agentic Assistant)
    TEMA: Arkham Knight (Azul Eléctrico, Carbono, HUD Táctico)
    LICENCIA: Wayne Enterprises Open Source
    
    --------------------------------------------------------------------
    ESTRUCTURA DE LA API (Rayfield-Styled):
    --------------------------------------------------------------------
    local Gotham = loadstring(game:HttpGet("..."))()
    
    local Window = Gotham:CreateWindow({
        Name = "Example",
        LoadingTitle = "Wayne Tech",
        KeySystem = true,
        KeySettings = {
            Key = {"MYKEY-123"}
        }
    })
    
    local Tab = Window:CreateTab("Combat")
    Tab:CreateButton({ Name = "Kill All", Callback = function() print("Done") end })
    --------------------------------------------------------------------
    
    ESTE CÓDIGO HA SIDO OPTIMIZADO PARA:
    - Bajo consumo de memoria (Reciclaje de instancias)
    - Animaciones de 60fps (Uso de RenderStepped y TweenService)
    - Luau StrictType (Seguridad de tipos y rendimiento)
    
    ====================================================================
]]

-- (Continuará con el código anterior...)

--[=[ 
    1. DEFINICIÓN DE TIPOS ESTRICTOS (Luau Architecture)
]=]

type Signal = { _handlers: {(...any) -> ()}, Fire: (self: Signal, ...any) -> (), Connect: (self: Signal, (...any) -> ()) -> () }
type TweenConfig = { Time: number, Style: Enum.EasingStyle, Direction: Enum.EasingDirection }
type ThemeConfig = {
    Background: Color3, Secondary: Color3, Tertiary: Color3, 
    Stroke: Color3, Accent: Color3, AccentLight: Color3,
    TextPrimary: Color3, TextSecondary: Color3, TextDisabled: Color3,
    Danger: Color3, Success: Color3, Warning: Color3,
    Font: Enum.Font, FontBold: Enum.Font, FontLight: Enum.Font,
    CornerRadius: number, CarbonTexture: string
}

type WindowConfig = {
    Name: string,
    LoadingTitle: string?,
    LoadingSubtitle: string?,
    ConfigurationSaving: { Enabled: boolean, Folder: string, FileName: string }?,
    KeySystem: boolean,
    KeySettings: {
        Title: string?,
        Subtitle: string?,
        Note: string?,
        FileName: string?,
        SaveKey: boolean?,
        GrabKeyFromSite: boolean?,
        Key: {string}
    }?
}

type ElementState = "Idle" | "Hover" | "Pressed" | "Disabled"

--[=[ 
    2. SERVICIOS Y CONSTANTES GLOBALES
]=]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--[=[ 
    3. TEMA: ARKHAM KNIGHT (Electric Blue & Carbon Fiber)
]=]

local ArkhamTheme: ThemeConfig = {
    Background = Color3.fromRGB(5, 7, 10),
    Secondary = Color3.fromRGB(12, 16, 22),
    Tertiary = Color3.fromRGB(20, 26, 35),
    Stroke = Color3.fromRGB(45, 55, 75),
    Accent = Color3.fromRGB(0, 170, 255),        -- Electric Cyan (Arkham Knight HUD)
    AccentLight = Color3.fromRGB(150, 220, 255),
    TextPrimary = Color3.fromRGB(240, 245, 250),
    TextSecondary = Color3.fromRGB(140, 155, 175),
    TextDisabled = Color3.fromRGB(70, 80, 95),
    Danger = Color3.fromRGB(255, 45, 65),
    Success = Color3.fromRGB(0, 255, 128),
    Warning = Color3.fromRGB(255, 180, 0),
    Font = Enum.Font.GothamBold,
    FontBold = Enum.Font.GothamBlack,
    FontLight = Enum.Font.GothamMedium,
    CornerRadius = 8,
    CarbonTexture = "rbxassetid://7335272671" -- Textura de fibra de carbono sutil
}

--[=[ 
    4. MOTOR DE SEÑALES (Event System)
]=]

local Signal = {}
Signal.__index = Signal

function Signal.new(): Signal
    local self = setmetatable({}, Signal)
    self._handlers = {}
    return (self :: any) :: Signal
end

function Signal:Fire(...: any)
    for _, handler in self._handlers do
        task.spawn(handler, ...)
    end
end

function Signal:Connect(handler: (...any) -> ())
    table.insert(self._handlers, handler)
    return function()
        local idx = table.find(self._handlers, handler)
        if idx then table.remove(self._handlers, idx) end
    end
end

--[=[ 
    5. MOTOR DE ANIMACIÓN AVANZADO (GTIS Motion Engine)
]=]

local Animate = {
    Presets = {
        Standard = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Spring = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        Smooth = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        Heavy = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
        Elastic = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    }
}

function Animate.Property(instance: Instance, info: TweenInfo, properties: {[string]: any}): Tween
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Animate.UIStroke(stroke: UIStroke, color: Color3, thickness: number?, time: number?)
    Animate.Property(stroke, TweenInfo.new(time or 0.2), { Color = color, Thickness = thickness or stroke.Thickness })
end

--[=[ 
    6. UTILIDADES DE DIBUJO Y MATEMÁTICAS
]=]

local Utils = {}

function Utils.Create(class: string, props: {[string]: any}): any
    local inst = Instance.new(class)
    for k, v in props do
        if k ~= "Parent" then
            pcall(function() (inst :: any)[k] = v end)
        end
    end
    inst.Parent = props.Parent
    return inst
end

function Utils.AddShadow(parent: GuiObject, size: number?)
    local shadow = Utils.Create("ImageLabel", {
        Name = "DropShadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.6,
        Size = UDim2.new(1, (size or 30), 1, (size or 30)),
        Position = UDim2.new(0, -(size or 15), 0, -(size or 15)),
        ZIndex = parent.ZIndex - 1,
        Parent = parent
    })
    return shadow
end

function Utils.AddCarbon(parent: GuiObject)
    local carbon = Utils.Create("ImageLabel", {
        Name = "CarbonPattern",
        BackgroundTransparency = 1,
        Image = ArkhamTheme.CarbonTexture,
        ImageTransparency = 0.94,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(128, 128),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = parent.ZIndex + 1,
        Parent = parent
    })
    return carbon
end

--[=[ 
    7. GESTOR DE SONIDO (GTIS Audio Interface)
]=]

local AudioManager = {
    _cache = {} :: {[string]: Sound},
    Links = {
        Hover = "http://www.soundjay.com/buttons/button-11.mp3", -- Ejemplo de link externo
        Click = "http://www.soundjay.com/buttons/button-14.mp3",
        Notify = "http://www.soundjay.com/communication/beep-07.mp3",
        Error = "http://www.soundjay.com/communication/beep-05.mp3"
    }
}

function AudioManager.Play(nameOrUrl: string, volume: number?)
    local url = AudioManager.Links[nameOrUrl] or nameOrUrl
    local sound = AudioManager._cache[url]
    
    if not sound then
        sound = Instance.new("Sound")
        sound.SoundId = url:find("rbxassetid") and url or "rbxassetid://0" -- Fallback si no es rbxassetid directamente
        -- Nota: Roblox no soporta MP3 directos via URL en el cliente sin proxies, 
        -- pero para este simulacro usaremos rbxassetids representativos.
        
        -- Mapeo de audios tácticos reales de la librería de Roblox
        local mapping = {
            Hover = "rbxassetid://6042048313",
            Click = "rbxassetid://6895079853",
            Notify = "rbxassetid://6518499133",
            Error = "rbxassetid://8458408910"
        }
        
        sound.SoundId = mapping[nameOrUrl] or url
        sound.Volume = volume or 0.5
        sound.Parent = Lighting
        AudioManager._cache[url] = sound
    end
    
    sound:Play()
end

--[=[ 
    8. SISTEMA DE LLAVES (GTIS Security Layer)
]=]

local Security = {}

function Security.Validate(config: WindowConfig): boolean
    if not config.KeySystem or not config.KeySettings then return true end
    
    local settings = config.KeySettings
    local validated = false
    
    local KeyGui = Utils.Create("ScreenGui", { Name = "GTIS_KeySystem", Parent = CoreGui })
    local Blur = Utils.Create("BlurEffect", { Size = 0, Parent = Lighting })
    Animate.Property(Blur, Animate.Presets.Smooth, { Size = 15 })
    
    local Main = Utils.Create("Frame", {
        Name = "KeyWindow",
        BackgroundColor3 = ArkhamTheme.Background,
        Size = UDim2.fromOffset(400, 280),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = KeyGui
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, ArkhamTheme.CornerRadius), Parent = Main })
    local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 2, Parent = Main })
    Utils.AddShadow(Main)
    Utils.AddCarbon(Main)
    
    local Title = Utils.Create("TextLabel", {
        Text = settings.Title or "SISTEMA DE ACCESO GOTHAM",
        Font = ArkhamTheme.FontBold,
        TextColor3 = ArkhamTheme.Accent,
        TextSize = 18,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    local Subtitle = Utils.Create("TextLabel", {
        Text = settings.Subtitle or "Ingresa tu llave táctica para continuar.",
        Font = ArkhamTheme.FontLight,
        TextColor3 = ArkhamTheme.TextSecondary,
        TextSize = 14,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    local InputBox = Utils.Create("TextBox", {
        PlaceholderText = "LLAVE-GOTHAM-XXXX",
        Text = "",
        Font = ArkhamTheme.Font,
        TextColor3 = ArkhamTheme.TextPrimary,
        PlaceholderColor3 = ArkhamTheme.TextDisabled,
        BackgroundColor3 = ArkhamTheme.Secondary,
        Size = UDim2.new(0.8, 0, 0, 45),
        Position = UDim2.new(0.5, 0, 0.5, 10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Main
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputBox })
    Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = InputBox })
    
    local SubmitBtn = Utils.Create("TextButton", {
        Text = "VERIFICAR IDENTIDAD",
        Font = ArkhamTheme.FontBold,
        TextColor3 = ArkhamTheme.Background,
        BackgroundColor3 = ArkhamTheme.Accent,
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.5, 0, 0.82, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Main
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SubmitBtn })
    
    SubmitBtn.MouseButton1Click:Connect(function()
        local input = InputBox.Text
        local isCorrect = false
        for _, k in settings.Key do
            if input == k then isCorrect = true; break end
        end
        
        if isCorrect then
            AudioManager.Play("Success")
            Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Success })
            task.delay(0.5, function()
                Animate.Property(Blur, Animate.Presets.Fast, { Size = 0 })
                Animate.Property(Main, Animate.Presets.Fast, { Position = UDim2.new(0.5, 0, 0.5, 100), BackgroundTransparency = 1 })
                task.delay(0.2, function() KeyGui:Destroy(); Blur:Destroy() end)
            end)
            validated = true
        else
            AudioManager.Play("Error")
            Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Danger })
            local origPos = Main.Position
            for i = 1, 6 do
                Animate.Property(Main, TweenInfo.new(0.05), { Position = origPos + UDim2.fromOffset(i%2==0 and 5 or -5, 0) })
                task.wait(0.05)
            end
            Main.Position = origPos
            task.delay(1, function() Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Stroke }) end)
        end
    end)
    
    while not validated do task.wait(0.1) end
    return true
end

--[=[ 
    9. GESTOR PRINCIPAL (Gotham Library Object)
]=]

local Gotham = {
    _connections = {} :: {RBXScriptConnection},
    Version = "5.0.1",
    TotalLines = 0 -- Meta: ~2000
}

function Gotham:CreateWindow(config: WindowConfig)
    if config.KeySystem then
        Security.Validate(config)
    end
    
    local Root = Utils.Create("ScreenGui", {
        Name = "GTIS_v5_" .. config.Name,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = CoreGui
    })
    
    -- Loading Effect (Like Arkham HUD) - REDUCED SIZE
    local LoadFrame = Utils.Create("Frame", {
        BackgroundColor3 = ArkhamTheme.Background,
        Size = UDim2.fromOffset(400, 220),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 1100,
        Parent = Root
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = LoadFrame })
    local LoadStroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Accent, Thickness = 2, Parent = LoadFrame })
    
    local LoadLines = Utils.Create("Frame", {
        BackgroundColor3 = ArkhamTheme.Accent,
        BackgroundTransparency = 0.8,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0.5, 0, 0, 10),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoadFrame
    })
    Animate.Property(LoadLines, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Position = UDim2.new(0.5, 0, 1, -10) })
    
    local LoadLabel = Utils.Create("TextLabel", {
        Text = string.upper(config.LoadingTitle or "GOTHAM COMMAND"),
        Font = ArkhamTheme.FontBold,
        TextColor3 = ArkhamTheme.TextPrimary,
        TextSize = 20,
        Position = UDim2.new(0.5, 0, 0.45, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = LoadFrame
    })
    
    local LoadSub = Utils.Create("TextLabel", {
        Text = "VERIFICANDO IDENTIDAD...",
        Font = ArkhamTheme.FontLight,
        TextColor3 = ArkhamTheme.Accent,
        TextSize = 12,
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = LoadFrame
    })
    
    task.delay(1.5, function()
        Animate.Property(LoadFrame, Animate.Presets.Smooth, { BackgroundTransparency = 1, Size = UDim2.fromOffset(450, 270) })
        Animate.Property(LoadLabel, Animate.Presets.Smooth, { TextTransparency = 1 })
        Animate.Property(LoadSub, Animate.Presets.Smooth, { TextTransparency = 1 })
        Animate.Property(LoadStroke, Animate.Presets.Smooth, { Transparency = 1 })
        task.delay(0.5, function() LoadFrame:Destroy() end)
    end)
    
    -- Main Window Structure
    local Main = Utils.Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = ArkhamTheme.Background,
        Size = UDim2.fromOffset(600, 450),
        Position = UDim2.new(0.5, 0, 0.5, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = false,
        Parent = Root
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 2, Parent = Main })
    Utils.AddShadow(Main)
    Utils.AddCarbon(Main)
    
    -- Horizontal Header (Navigation)
    local Header = Utils.Create("Frame", {
        Name = "Header",
        BackgroundColor3 = ArkhamTheme.Secondary,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = Main
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Header })
    Utils.Create("Frame", {
        BackgroundColor3 = ArkhamTheme.Secondary,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 0,
        Parent = Header
    }) -- Corner fix
    Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1.5, Parent = Header })
    
    local Title = Utils.Create("TextLabel", {
        Text = "GOTHAM COMMAND CENTER",
        Font = ArkhamTheme.FontBold,
        TextColor3 = ArkhamTheme.Accent,
        TextSize = 12,
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 150, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    local NavHolder = Utils.Create("ScrollingFrame", {
        Name = "NavHolder",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 150, 0, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        Parent = Header
    })
    Utils.Create("UIListLayout", { 
        FillDirection = Enum.FillDirection.Horizontal, 
        Padding = UDim.new(0, 15), 
        HorizontalAlignment = Enum.HorizontalAlignment.Left, 
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = NavHolder 
    })
    
    -- Content Area (SHIFTED DOWN)
    local Container = Utils.Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -65),
        Position = UDim2.new(0, 10, 0, 55),
        Parent = Main
    })
    
    local TabContainer = Utils.Create("Frame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Container
    })
    
    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local WindowAPI = {
        _tabs = {} :: {any},
        _activeTab = nil :: any
    }
    
    function WindowAPI:CreateTab(name: string, iconId: string?)
        local TabBtn = Utils.Create("TextButton", {
            Name = "TabBtn_" .. name,
            Text = string.upper(name),
            Font = ArkhamTheme.Font,
            TextColor3 = ArkhamTheme.TextSecondary,
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 100, 1, 0),
            Parent = NavHolder
        })
        
        local Indicator = Utils.Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = ArkhamTheme.Accent,
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Parent = TabBtn
        })
        
        NavHolder.CanvasSize = UDim2.new(0, NavHolder:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.X + 10, 0, 0)
        
        local Page = Utils.Create("ScrollingFrame", {
            Name = "Page_" .. name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ArkhamTheme.Accent,
            Visible = false,
            Parent = TabContainer
        })
        local PageLayout = Utils.Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = Page })
        Utils.Create("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 15), PaddingTop = UDim.new(0, 10), Parent = Page })
        
        local function OpenTab()
            if WindowAPI._activeTab then
                WindowAPI._activeTab.Page.Visible = false
                Animate.Property(WindowAPI._activeTab.Btn, Animate.Presets.Fast, { TextColor3 = ArkhamTheme.TextSecondary })
                Animate.Property(WindowAPI._activeTab.Indicator, Animate.Presets.Fast, { BackgroundTransparency = 1 })
            end
            Page.Visible = true
            WindowAPI._activeTab = { Page = Page, Btn = TabBtn, Indicator = Indicator }
            Animate.Property(TabBtn, Animate.Presets.Fast, { TextColor3 = ArkhamTheme.Accent })
            Animate.Property(Indicator, Animate.Presets.Fast, { BackgroundTransparency = 0 })
            AudioManager.Play("Click")
        end
        
        TabBtn.MouseButton1Click:Connect(OpenTab)
        if not WindowAPI._activeTab then OpenTab() end
        
        local TabAPI = { Page = Page, Layout = PageLayout }
        
        local TabAPI = { Page = Page, Layout = PageLayout }
        
        function TabAPI:CreateButton(options: {Name: string, Callback: () -> ()})
            local ButtonFrame = Utils.Create("Frame", {
                Name = "Button_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ButtonFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = ButtonFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextPrimary,
                TextSize = 13,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = ButtonFrame
            })
            
            local ClickBtn = Utils.Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = ButtonFrame
            })
            
            ClickBtn.MouseEnter:Connect(function()
                Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Accent })
                Animate.Property(ButtonFrame, Animate.Presets.Fast, { BackgroundColor3 = ArkhamTheme.Tertiary })
                AudioManager.Play("Hover")
            end)
            ClickBtn.MouseLeave:Connect(function()
                Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Stroke })
                Animate.Property(ButtonFrame, Animate.Presets.Fast, { BackgroundColor3 = ArkhamTheme.Secondary })
            end)
            ClickBtn.MouseButton1Down:Connect(function()
                Animate.Property(ButtonFrame, Animate.Presets.Fast, { Size = UDim2.new(0.98, 0, 0, 38) })
                AudioManager.Play("Click")
            end)
            ClickBtn.MouseButton1Up:Connect(function()
                Animate.Property(ButtonFrame, Animate.Presets.Spring, { Size = UDim2.new(1, 0, 0, 40) })
                options.Callback()
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            return ButtonFrame
        end

        function TabAPI:CreateToggle(options: {Name: string, CurrentValue: boolean, Callback: (boolean) -> ()})
            local state = options.CurrentValue
            local ToggleFrame = Utils.Create("Frame", {
                Name = "Toggle_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = ToggleFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 13,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = ToggleFrame
            })
            
            local SwitchBg = Utils.Create("Frame", {
                BackgroundColor3 = state and ArkhamTheme.Accent or ArkhamTheme.Tertiary,
                Size = UDim2.fromOffset(36, 18),
                Position = UDim2.new(1, -45, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = ToggleFrame
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchBg })
            
            local Dot = Utils.Create("Frame", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                Size = UDim2.fromOffset(12, 12),
                Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = SwitchBg
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Dot })
            
            local ClickBtn = Utils.Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = ToggleFrame
            })
            
            local function Update()
                Animate.Property(SwitchBg, Animate.Presets.Fast, { BackgroundColor3 = state and ArkhamTheme.Accent or ArkhamTheme.Tertiary })
                Animate.Property(Dot, Animate.Presets.Spring, { Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
                Animate.Property(Text, Animate.Presets.Fast, { TextColor3 = state and ArkhamTheme.TextPrimary or ArkhamTheme.TextSecondary })
                options.Callback(state)
            end
            
            ClickBtn.MouseButton1Click:Connect(function()
                state = not state
                AudioManager.Play("Click")
                Update()
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            return ToggleFrame
        end

        function TabAPI:CreateSlider(options: {Name: string, Range: {number}, Increment: number, CurrentValue: number, Callback: (number) -> ()})
            local val = options.CurrentValue
            local SliderFrame = Utils.Create("Frame", {
                Name = "Slider_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 55),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SliderFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = SliderFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 12,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(0, 100, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = SliderFrame
            })
            
            local ValLabel = Utils.Create("TextLabel", {
                Text = tostring(val),
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.Accent,
                TextSize = 12,
                Position = UDim2.new(1, -65, 0, 10),
                Size = UDim2.new(0, 50, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Parent = SliderFrame
            })
            
            local Track = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Tertiary,
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0.5, 0, 0, 38),
                AnchorPoint = Vector2.new(0.5, 0),
                Parent = SliderFrame
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            
            local Fill = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Accent,
                Size = UDim2.new((val - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0),
                Parent = Track
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                val = math.floor(((options.Range[2] - options.Range[1]) * pos + options.Range[1]) / options.Increment) * options.Increment
                Animate.Property(Fill, Animate.Presets.Fast, { Size = UDim2.new((val - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0) })
                ValLabel.Text = tostring(val)
                options.Callback(val)
            end
            
            local dragging = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            return SliderFrame
        end

        function TabAPI:CreateDropdown(options: {Name: string, Options: {string}, CurrentOption: string, MultipleOptions: boolean?, Callback: (any) -> ()})
            local DropdownFrame = Utils.Create("Frame", {
                Name = "Dropdown_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropdownFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = DropdownFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name .. " : " .. options.CurrentOption,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 13,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -40, 0, 40),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = DropdownFrame
            })
            
            local Icon = Utils.Create("ImageLabel", {
                Image = "rbxassetid://6034818372",
                ImageColor3 = ArkhamTheme.TextSecondary,
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -30, 0, 12),
                BackgroundTransparency = 1,
                Parent = DropdownFrame
            })
            
            local OptionHolder = Utils.Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 40),
                Parent = DropdownFrame
            })
            Utils.Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = OptionHolder })
            
            local open = false
            local function ToggleDropdown()
                open = not open
                local targetSize = open and (40 + (#options.Options * 32) + 5) or 40
                Animate.Property(DropdownFrame, Animate.Presets.Smooth, { Size = UDim2.new(1, 0, 0, targetSize) })
                Animate.Property(Icon, Animate.Presets.Fast, { Rotation = open and 180 or 0 })
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
                AudioManager.Play("Click")
            end
            
            local ClickBtn = Utils.Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = DropdownFrame
            })
            ClickBtn.MouseButton1Click:Connect(ToggleDropdown)
            
            for _, opt in options.Options do
                local OptBtn = Utils.Create("TextButton", {
                    Text = opt,
                    Font = ArkhamTheme.FontLight,
                    TextColor3 = ArkhamTheme.TextDisabled,
                    TextSize = 12,
                    BackgroundColor3 = ArkhamTheme.Tertiary,
                    Size = UDim2.new(0.95, 0, 0, 30),
                    Position = UDim2.new(0.025, 0, 0, 0),
                    Parent = OptionHolder
                })
                Utils.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OptBtn })
                
                OptBtn.MouseButton1Click:Connect(function()
                    Text.Text = options.Name .. " : " .. opt
                    options.Callback(opt)
                    ToggleDropdown()
                end)
                
                OptBtn.MouseEnter:Connect(function() Animate.Property(OptBtn, Animate.Presets.Fast, { TextColor3 = ArkhamTheme.Accent }) end)
                OptBtn.MouseLeave:Connect(function() Animate.Property(OptBtn, Animate.Presets.Fast, { TextColor3 = ArkhamTheme.TextDisabled }) end)
            end
            
            return DropdownFrame
        end

        function TabAPI:CreateInput(options: {Name: string, Placeholder: string, RemoveTextAfterFocusLost: boolean, Callback: (string) -> ()})
            local InputFrame = Utils.Create("Frame", {
                Name = "Input_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = InputFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 12,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = InputFrame
            })
            
            local Box = Utils.Create("TextBox", {
                PlaceholderText = options.Placeholder,
                Text = "",
                Font = ArkhamTheme.FontLight,
                TextColor3 = ArkhamTheme.TextPrimary,
                PlaceholderColor3 = ArkhamTheme.TextDisabled,
                BackgroundColor3 = ArkhamTheme.Tertiary,
                Size = UDim2.new(0.5, 0, 0, 30),
                Position = UDim2.new(1, -15, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = InputFrame
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Box })
            
            Box.FocusLost:Connect(function(enter)
                if enter then
                    options.Callback(Box.Text)
                    if options.RemoveTextAfterFocusLost then Box.Text = "" end
                end
                Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Stroke })
            end)
            Box.Focused:Connect(function()
                Animate.Property(Stroke, Animate.Presets.Fast, { Color = ArkhamTheme.Accent })
                AudioManager.Play("Hover")
            end)
            
            return InputFrame
        end

        function TabAPI:CreateSection(name: string)
            local SectionLabel = Utils.Create("TextLabel", {
                Text = string.upper(name),
                Font = ArkhamTheme.FontBold,
                TextColor3 = ArkhamTheme.Accent,
                TextSize = 11,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
            Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Accent,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, -100, 0, 1),
                Position = UDim2.new(0, 90, 0.5, 0),
                BorderSizePixel = 0,
                Parent = SectionLabel
            })
            return SectionLabel
        end

        function TabAPI:CreateParagraph(options: {Title: string, Content: string})
            local ParaFrame = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 60), -- Dynamic size later
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ParaFrame })
            
            local T = Utils.Create("TextLabel", {
                Text = options.Title,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextPrimary,
                TextSize = 13,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(1, -20, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = ParaFrame
            })
            
            local C = Utils.Create("TextLabel", {
                Text = options.Content,
                Font = ArkhamTheme.FontLight,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 11,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                BackgroundTransparency = 1,
                Parent = ParaFrame
            })
            C.AutomaticSize = Enum.AutomaticSize.Y
            ParaFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            return ParaFrame
        end

        function TabAPI:CreateKeybind(options: {Name: string, CurrentKeybind: Enum.KeyCode, HoldToInteract: boolean, Callback: (Enum.KeyCode) -> ()})
            local key = options.CurrentKeybind
            local KeybindFrame = Utils.Create("Frame", {
                Name = "Keybind_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeybindFrame })
            local Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1, Parent = KeybindFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 13,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = KeybindFrame
            })
            
            local KeyBox = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Tertiary,
                Size = UDim2.fromOffset(60, 24),
                Position = UDim2.new(1, -75, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = KeybindFrame
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBox })
            
            local KeyLabel = Utils.Create("TextLabel", {
                Text = key.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.Accent,
                TextSize = 11,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = KeyBox
            })
            
            local binding = false
            local ClickBtn = Utils.Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = KeybindFrame
            })
            
            ClickBtn.MouseButton1Click:Connect(function()
                binding = true
                KeyLabel.Text = "..."
                AudioManager.Play("Hover")
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeyLabel.Text = key.Name
                    binding = false
                    options.Callback(key)
                    AudioManager.Play("Click")
                end
            end)
            
            return KeybindFrame
        end

        function TabAPI:CreateColorPicker(options: {Name: string, Color: Color3, Callback: (Color3) -> ()})
            local col = options.Color
            local PickerFrame = Utils.Create("Frame", {
                Name = "ColorPicker_" .. options.Name,
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = PickerFrame })
            
            local Text = Utils.Create("TextLabel", {
                Text = options.Name,
                Font = ArkhamTheme.Font,
                TextColor3 = ArkhamTheme.TextSecondary,
                TextSize = 13,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -60, 0, 40),
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = PickerFrame
            })
            
            local ColorBox = Utils.Create("Frame", {
                BackgroundColor3 = col,
                Size = UDim2.fromOffset(40, 20),
                Position = UDim2.new(1, -55, 0, 10),
                Parent = PickerFrame
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ColorBox })
            
            -- Color picking logic simplified for library length
            -- (Normally would have a slider/grid)
            local open = false
            local ClickBtn = Utils.Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = PickerFrame
            })
            
            ClickBtn.MouseButton1Click:Connect(function()
                -- Placeholder for advanced color picker
                AudioManager.Play("Click")
            end)
            
            return PickerFrame
        end

        function TabAPI:BuildDetectivePreview(config: { Enabled: boolean })
            if not config.Enabled then return end
            
            local PreviewOuter = Utils.Create("Frame", {
                Name = "DetectivePreviewOuter",
                BackgroundColor3 = ArkhamTheme.Secondary,
                Size = UDim2.new(1, 0, 0, 320),
                Parent = Page
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = PreviewOuter })
            Utils.Create("UIStroke", { Color = ArkhamTheme.Stroke, Thickness = 1.5, Parent = PreviewOuter })

            local PreviewFrame = Utils.Create("Frame", {
                Name = "DetectivePreview",
                BackgroundColor3 = Color3.new(0.02, 0.03, 0.05),
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ClipsDescendants = true,
                Parent = PreviewOuter
            })
            Utils.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = PreviewFrame })
            
            -- Scanline effect
            local Scanline = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Accent,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 10,
                Parent = PreviewFrame
            })
            Animate.Property(Scanline, TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Position = UDim2.new(0, 0, 1, 0) })
            
            -- Character Model Simulation
            local Dummy = Utils.Create("ImageLabel", {
                Name = "BatmanDummy",
                Image = "rbxassetid://109556531456186",
                ImageColor3 = ArkhamTheme.Accent,
                ImageTransparency = 0.2,
                BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.new(0, 180, 0, 250),
                Position = UDim2.new(0.5, 0, 0.5, 20),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = 5,
                Parent = PreviewFrame
            })
            
            local Overlay = Utils.Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 6,
                Parent = PreviewFrame
            })
            
            local function CreateESPLine(name, pos, size, rot)
                return Utils.Create("Frame", {
                    Name = name,
                    BackgroundColor3 = ArkhamTheme.Accent,
                    BorderSizePixel = 0,
                    Size = size,
                    Position = pos,
                    Rotation = rot or 0,
                    ZIndex = 7,
                    Parent = Overlay
                })
            end
            
            -- Corner Boxes (Arkham Style)
            local cl = 25
            local bx, by, bw, bh = 0.5, 0.5, 120, 220
            
            CreateESPLine("TLH", UDim2.new(bx, -60, by, -100), UDim2.fromOffset(cl, 1.5))
            CreateESPLine("TLV", UDim2.new(bx, -60, by, -100), UDim2.fromOffset(1.5, cl))
            
            CreateESPLine("TRH", UDim2.new(bx, 60-cl, by, -100), UDim2.fromOffset(cl, 1.5))
            CreateESPLine("TRV", UDim2.new(bx, 60, by, -100), UDim2.fromOffset(1.5, cl))
            
            CreateESPLine("BLH", UDim2.new(bx, -60, by, 120), UDim2.fromOffset(cl, 1.5))
            CreateESPLine("BLV", UDim2.new(bx, -60, by, 120-cl), UDim2.fromOffset(1.5, cl))
            
            CreateESPLine("BRH", UDim2.new(bx, 60-cl, by, 120), UDim2.fromOffset(cl, 1.5))
            CreateESPLine("BRV", UDim2.new(bx, 60, by, 120-cl), UDim2.fromOffset(1.5, cl))
            
            -- Info HUD
            local InfoBox = Utils.Create("Frame", {
                BackgroundColor3 = Color3.new(0,0,0),
                BackgroundTransparency = 0.4,
                Size = UDim2.fromOffset(150, 60),
                Position = UDim2.new(0.5, 80, 0.5, -60),
                ZIndex = 8,
                Parent = PreviewFrame
            })
            Utils.Create("UIStroke", { Color = ArkhamTheme.Accent, Thickness = 0.8, Parent = InfoBox })
            
            Utils.Create("TextLabel", {
                Text = "STATUS: DETECTED\nTARGET: ARMORED_THUG\nDIST: 12.4m\nTHREAT: LOW",
                Font = Enum.Font.Code,
                TextColor3 = ArkhamTheme.Accent,
                TextSize = 10,
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.fromOffset(5, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 9,
                Parent = InfoBox
            })
            
            -- Connection line
            CreateESPLine("Conn", UDim2.new(0.5, 60, 0.5, 10), UDim2.fromOffset(20, 1), 35)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            return PreviewOuter
        end

        function TabAPI:AddSeparator()
            local Sep = Utils.Create("Frame", {
                BackgroundColor3 = ArkhamTheme.Stroke,
                BackgroundTransparency = 0.6,
                Size = UDim2.new(1, 0, 0, 1),
                Parent = Page
            })
            return Sep
        end
        
        return TabAPI
    end
    
    return WindowAPI
end

--[=[ 
    10. MOTOR DE NOTIFICACIONES (GTIS Intelligence Reports)
]=]

local NotificationManager = {
    _queue = {} :: {Frame},
    _holder = nil :: Frame?
}

function Gotham:Notify(options: {Title: string, Content: string, Type: string?, Duration: number?})
    if not NotificationManager._holder then
        local Root = CoreGui:FindFirstChildOfClass("ScreenGui") or Utils.Create("ScreenGui", { Name = "GTIS_Notifications", Parent = CoreGui })
        NotificationManager._holder = Utils.Create("Frame", {
            Name = "NotifHolder",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -320, 0, 0),
            Parent = Root
        })
        Utils.Create("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10), Parent = NotificationManager._holder })
        Utils.Create("UIPadding", { PaddingBottom = UDim.new(0, 20), Parent = NotificationManager._holder })
    end
    
    local color = options.Type == "Error" and ArkhamTheme.Danger or options.Type == "Success" and ArkhamTheme.Success or ArkhamTheme.Accent
    
    local Notif = Utils.Create("Frame", {
        Name = "Notif_" .. tick(),
        BackgroundColor3 = ArkhamTheme.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = NotificationManager._holder
    })
    Utils.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Notif })
    local Stroke = Utils.Create("UIStroke", { Color = color, Thickness = 1.5, Parent = Notif })
    
    local T = Utils.Create("TextLabel", {
        Text = string.upper(options.Title),
        Font = ArkhamTheme.FontBold,
        TextColor3 = color,
        TextSize = 13,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Notif
    })
    
    local C = Utils.Create("TextLabel", {
        Text = options.Content,
        Font = ArkhamTheme.FontLight,
        TextColor3 = ArkhamTheme.TextSecondary,
        TextSize = 12,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -30, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Parent = Notif
    })
    
    Animate.Property(Notif, Animate.Presets.Spring, { Size = UDim2.new(1, 0, 0, 70) })
    AudioManager.Play("Notify")
    
    task.delay(options.Duration or 5, function()
        Animate.Property(Notif, Animate.Presets.Fast, { Position = UDim2.new(1.1, 0, 0, 0), BackgroundTransparency = 1 })
        task.delay(0.3, function() Notif:Destroy() end)
    end)
end

--[=[ 
    11. MOTOR DE RENDERIZADO ESP 2D (GTIS Detective Vision)
]=]

local ESPRenderer = {
    _elements = {} :: {[string]: any},
    _enabled = false,
    _teamCheck = false,
    _maxDist = 1000,
    _names = true,
    _boxes = true,
    _health = true,
    _tracers = false
}

function ESPRenderer:Clear(name: string)
    if self._elements[name] then
        for _, obj in self._elements[name] do
            if typeof(obj) == "Instance" then obj:Destroy() end
        end
        self._elements[name] = nil
    end
end

function ESPRenderer:DrawESP(player: Player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        self:Clear(player.Name)
        return 
    end
    
    local char = player.Character
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    local pos, vis = Camera:WorldToViewportPoint(root.Position)
    
    if not vis or (root.Position - Camera.CFrame.Position).Magnitude > self._maxDist then
        self:Clear(player.Name)
        return
    end
    
    if not self._elements[player.Name] then
        self._elements[player.Name] = {
            Box = Utils.Create("Frame", { Name = "Box", BackgroundTransparency = 1, Parent = CoreGui:FindFirstChildOfClass("ScreenGui") }),
            Stroke = nil,
            NameLabel = Utils.Create("TextLabel", { Name = "Name", BackgroundTransparency = 1, Parent = CoreGui:FindFirstChildOfClass("ScreenGui") }),
            HealthBar = Utils.Create("Frame", { Name = "HP", Parent = CoreGui:FindFirstChildOfClass("ScreenGui") })
        }
        self._elements[player.Name].Stroke = Utils.Create("UIStroke", { Color = ArkhamTheme.Accent, Thickness = 1.5, Parent = self._elements[player.Name].Box })
    end
    
    local el = self._elements[player.Name]
    local cf, sz = char:GetBoundingBox()
    local tl = Camera:WorldToViewportPoint((cf * CFrame.new(-sz.X/2, sz.Y/2, 0)).Position)
    local br = Camera:WorldToViewportPoint((cf * CFrame.new(sz.X/2, -sz.Y/2, 0)).Position)
    
    local boxW, boxH = math.abs(tl.X - br.X), math.abs(tl.Y - br.Y)
    
    el.Box.Visible = self._boxes
    el.Box.Position = UDim2.fromOffset(tl.X, tl.Y)
    el.Box.Size = UDim2.fromOffset(boxW, boxH)
    
    el.NameLabel.Visible = self._names
    el.NameLabel.Text = string.upper(player.Name) .. " [" .. math.floor((root.Position - Camera.CFrame.Position).Magnitude) .. "m]"
    el.NameLabel.Font = ArkhamTheme.FontBold
    el.NameLabel.TextColor3 = ArkhamTheme.Accent
    el.NameLabel.TextSize = 12
    el.NameLabel.Position = UDim2.fromOffset(tl.X, tl.Y - 20)
    el.NameLabel.Size = UDim2.fromOffset(boxW, 20)
    
    if hum then
        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        el.HealthBar.Visible = self._health
        el.HealthBar.BackgroundColor3 = hp > 0.6 and ArkhamTheme.Success or hp > 0.3 and ArkhamTheme.Warning or ArkhamTheme.Danger
        el.HealthBar.Position = UDim2.fromOffset(tl.X - 5, tl.Y + (boxH * (1 - hp)))
        el.HealthBar.Size = UDim2.fromOffset(2, boxH * hp)
    end
end

RunService.RenderStepped:Connect(function()
    if not ESPRenderer._enabled then return end
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer then
            if ESPRenderer._teamCheck and p.Team == LocalPlayer.Team then
                ESPRenderer:Clear(p.Name)
                continue
            end
            ESPRenderer:DrawESP(p)
        end
    end
end)

--[=[ 
    12. EXPORTACIÓN FINAL Y CONFIGURACIÓN
]=]

function Gotham:Destroy()
    local Root = CoreGui:FindFirstChild("GTIS_v5_" .. (self.Name or ""))
    if Root then Root:Destroy() end
    for _, conn in self._connections do conn:Disconnect() end
end

-- Añadiendo el motor ESP al objeto Gotham para acceso externo
Gotham.ESPSystem = ESPRenderer

return Gotham
