-- RYZEN ULTRA v11 | ALL-IN-ONE (runs all 18 parts, shows the exact failing part on screen)
local StarterGui = game:GetService("StarterGui")
local function toast(t, m)
    pcall(function() StarterGui:SetCore("SendNotification", { Title = t, Text = tostring(m):sub(1, 190), Duration = 12 }) end)
end
local PARTS = {
{ name = "Core", src = [==[
-- RYZEN ULTRA v11 | PART 1/18 (CORE BASE)
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.3)

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP           = Players.LocalPlayer
local genv         = (getgenv and getgenv()) or _G

pcall(function() if genv.RYZEN and genv.RYZEN.unload then genv.RYZEN.unload() end end)

-- ═══ CONFIG (naam yahan badalo) ═══
local R = {
    version = "v11 ULTRA", owner = "RYZEN",
    running = true, conns = {}, cleanups = {}, errors = {},
    scale = UIS.TouchEnabled and 0.66 or 0.85,
    total = 13, attempted = 0, okCount = 0, finished = false,
    notifOn = true, startTime = os.clock(), lastAct = os.clock(),
    pal = {
        accent  = Color3.fromRGB(155, 80, 255),
        accent2 = Color3.fromRGB(255, 120, 220),
        light   = Color3.fromRGB(235, 190, 255),
    },
}
genv.RYZEN = R

-- executor info (diagnostics ke liye)
R.exec = "Unknown"
pcall(function()
    if identifyexecutor then
        local n, v = identifyexecutor()
        R.exec = tostring(n) .. (v and (" " .. tostring(v)) or "")
    end
end)

-- ═══ SAFE GUI PARENT ═══
local function tryParent(p)
    if not p then return false end
    return pcall(function()
        local t = Instance.new("ScreenGui")
        t.Parent = p
        local good = (t.Parent == p)
        t:Destroy()
        if not good then error("x") end
    end)
end
local guiParent
pcall(function() if gethui then local h = gethui() if tryParent(h) then guiParent = h end end end)
if not guiParent then
    pcall(function() local c = game:GetService("CoreGui") if tryParent(c) then guiParent = c end end)
end
if not guiParent then guiParent = LP:WaitForChild("PlayerGui") end
local coreGui
pcall(function() coreGui = game:GetService("CoreGui") end)
R.guiParent, R.coreGui = guiParent, coreGui

-- ═══ UTILS ═══
local function bind(sig, fn)
    local c = sig:Connect(fn)
    R.conns[#R.conns + 1] = c
    return c
end
local function tw(o, t, props, style, dir)
    local x = TweenService:Create(o,
        TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    x:Play()
    return x
end
local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 10)
    c.Parent = o
    return c
end
local function stroke(o, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(180, 100, 255)
    s.Thickness = th or 2
    s.Transparency = tr or 0.2
    s.Parent = o
    return s
end
R.bind, R.tw, R.corner, R.stroke = bind, tw, corner, stroke

function R.isTap(i)
    return i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1
end
function R.getChar() return LP.Character end
function R.getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
function R.getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
function R.firstOpt(o)
    if type(o) == "table" then o = o[1] end
    if type(o) == "string" and o ~= "" then return o end
    return nil
end

-- Draggable helper
function R.drag(obj)
    obj.Active = true
    local dragging, startIn, startPos, dIn = false, nil, nil, nil
    bind(obj.InputBegan, function(i)
        if R.isTap(i) then
            dragging, dIn, startIn, startPos = true, i, i.Position, obj.Position
        end
    end)
    bind(UIS.InputChanged, function(i)
        if dragging and (i == dIn or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = i.Position - startIn
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    bind(UIS.InputEnded, function(i)
        if dragging and (i == dIn or i.UserInputType == Enum.UserInputType.MouseButton1) then dragging = false end
    end)
end

-- Safe UI creator
function R.ui(tab, kind, cfg)
    if not tab then return nil end
    local ok, res = pcall(function() return tab["Create" .. kind](tab, cfg) end)
    if not ok then
        local nm = kind
        if type(cfg) == "table" and cfg.Name then nm = kind .. ":" .. tostring(cfg.Name) end
        R.errors[#R.errors + 1] = { name = nm, err = tostring(res) }
        warn("[RYZEN] UI fail:", nm, res)
        return nil
    end
    return res
end

-- ═══ FLOATING GUI ═══
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "RyzenFloating"
floatGui.ResetOnSpawn = false
floatGui.IgnoreGuiInset = true
floatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
floatGui.DisplayOrder = 999
floatGui.Parent = guiParent
R.floatGui = floatGui

print("[RYZEN] Part 1/18 (Core Base) loaded")

]==] },
{ name = "Intro A", src = [==[
-- RYZEN ULTRA v11 | PART 2/18 (INTRO A: scene + card + logo)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R then warn("[RYZEN] Run Part 1 first!") return end

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local P, tw, corner, stroke = R.pal, R.tw, R.corner, R.stroke
local kp = NumberSequenceKeypoint.new
local rng = Random.new()
local S = { closed = false, pct = 0 }
R.S = S

local okI, errI = pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "RyzenSplash"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 1000
    sg.Parent = R.guiParent
    S.sg = sg

    local dim = Instance.new("Frame")
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(6, 2, 12)
    dim.BackgroundTransparency = 1
    dim.BorderSizePixel = 0
    dim.ZIndex = 1
    dim.Parent = sg
    tw(dim, 0.5, { BackgroundTransparency = 0.12 })
    S.dim = dim

    pcall(function()
        local blur = Instance.new("BlurEffect")
        blur.Name = "RyzenBlur"
        blur.Size = 0
        blur.Parent = Lighting
        tw(blur, 0.7, { Size = 22 })
        S.blur = blur
    end)

    -- ═══ AURORA BLOBS (soft drifting colour clouds) ═══
    local aur = Instance.new("Frame")
    aur.Size = UDim2.new(1, 0, 1, 0)
    aur.BackgroundTransparency = 1
    aur.ClipsDescendants = true
    aur.ZIndex = 1
    aur.Parent = sg
    local blobs = {
        { P.accent, 0.15, 0.25, 520 },
        { P.accent2, 0.85, 0.75, 480 },
        { Color3.fromRGB(70, 90, 255), 0.5, 0.95, 560 },
    }
    for _, b in ipairs(blobs) do
        local c = Instance.new("Frame")
        c.AnchorPoint = Vector2.new(0.5, 0.5)
        c.Position = UDim2.new(b[2], 0, b[3], 0)
        c.Size = UDim2.new(0, 0, 0, 0)
        c.BackgroundTransparency = 1
        c.Parent = aur
        for _, f in ipairs({ 1, 0.72, 0.46 }) do
            local layer = Instance.new("Frame")
            layer.AnchorPoint = Vector2.new(0.5, 0.5)
            layer.Size = UDim2.new(0, b[4] * f, 0, b[4] * f)
            layer.BackgroundColor3 = b[1]
            layer.BackgroundTransparency = 0.94
            layer.BorderSizePixel = 0
            layer.Parent = c
            corner(layer, UDim.new(1, 0))
        end
        TweenService:Create(c, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            { Position = UDim2.new(1 - b[2], 0, 1 - b[3] + 0.1, 0) }):Play()
    end

    -- scanline sweeping top -> bottom
    local scan = Instance.new("Frame")
    scan.Size = UDim2.new(1, 0, 0, 2)
    scan.Position = UDim2.new(0, 0, -0.02, 0)
    scan.BackgroundColor3 = Color3.new(1, 1, 1)
    scan.BorderSizePixel = 0
    scan.ZIndex = 2
    scan.Parent = sg
    local sgr = Instance.new("UIGradient")
    sgr.Color = ColorSequence.new(P.accent, P.accent2)
    sgr.Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.5), kp(1, 1) })
    sgr.Parent = scan
    TweenService:Create(scan, TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Position = UDim2.new(0, 0, 1.02, 0) }):Play()

    -- floating particles
    local pf = Instance.new("Frame")
    pf.Size = UDim2.new(1, 0, 1, 0)
    pf.BackgroundTransparency = 1
    pf.ClipsDescendants = true
    pf.ZIndex = 2
    pf.Parent = sg
    for i = 1, 36 do
        local p = Instance.new("Frame")
        local sz = rng:NextInteger(2, 5)
        p.AnchorPoint = Vector2.new(0.5, 0.5)
        p.Size = UDim2.new(0, sz, 0, sz)
        local xs = rng:NextNumber()
        p.Position = UDim2.new(xs, 0, 1.06, 0)
        p.BackgroundColor3 = (i % 2 == 0) and P.accent or P.accent2
        p.BackgroundTransparency = rng:NextNumber(0.4, 0.85)
        p.BorderSizePixel = 0
        p.Parent = pf
        corner(p, UDim.new(1, 0))
        task.delay(rng:NextNumber(0, 3), function()
            if S.closed then return end
            pcall(function()
                TweenService:Create(p,
                    TweenInfo.new(rng:NextNumber(4, 8), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                    { Position = UDim2.new(xs, 0, -0.06, 0) }):Play()
            end)
        end)
    end

    -- ═══ MAIN CARD ═══
    local card = Instance.new("CanvasGroup")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.new(0, 330, 0, 262)
    card.BackgroundColor3 = Color3.new(1, 1, 1)
    card.BorderSizePixel = 0
    card.GroupTransparency = 1
    card.ZIndex = 3
    card.Parent = sg
    corner(card, UDim.new(0, 22))
    local cg = Instance.new("UIGradient")
    cg.Color = ColorSequence.new(Color3.fromRGB(32, 16, 58), Color3.fromRGB(11, 5, 21))
    cg.Rotation = 90
    cg.Parent = card

    local cs = stroke(card, Color3.new(1, 1, 1), 2, 0)
    local csg = Instance.new("UIGradient")
    csg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, P.accent),
        ColorSequenceKeypoint.new(0.5, P.accent2),
        ColorSequenceKeypoint.new(1, P.accent),
    })
    csg.Parent = cs
    TweenService:Create(csg, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Rotation = 360 }):Play()

    local sc = Instance.new("UIScale")
    sc.Scale = 0.7
    sc.Parent = card
    tw(sc, 0.7, { Scale = 1 }, Enum.EasingStyle.Back)
    tw(card, 0.45, { GroupTransparency = 0 })
    S.card, S.sc = card, sc
    -- gentle floating motion once the card has appeared
    task.delay(0.9, function()
        if S.closed then return end
        pcall(function()
            TweenService:Create(card, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                { Position = UDim2.new(0.5, 0, 0.5, -5) }):Play()
        end)
    end)

    -- version badge
    local badge = Instance.new("TextLabel")
    badge.AnchorPoint = Vector2.new(1, 0)
    badge.Position = UDim2.new(1, -12, 0, 10)
    badge.Size = UDim2.new(0, 52, 0, 16)
    badge.BackgroundColor3 = P.accent
    badge.BackgroundTransparency = 0.6
    badge.Text = "v11 PRO"
    badge.TextColor3 = P.light
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 9
    badge.Parent = card
    corner(badge, UDim.new(1, 0))

    -- ═══ LOGO: halo + rings + orbit + R ═══
    local halo = Instance.new("Frame")
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Position = UDim2.new(0.5, 0, 0, 66)
    halo.Size = UDim2.new(0, 120, 0, 120)
    halo.BackgroundColor3 = P.accent
    halo.BackgroundTransparency = 0.88
    halo.BorderSizePixel = 0
    halo.Parent = card
    corner(halo, UDim.new(1, 0))
    TweenService:Create(halo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Size = UDim2.new(0, 142, 0, 142), BackgroundTransparency = 0.94 }):Play()

    local function arc(sz, th, dur, rev, y)
        local f = Instance.new("Frame")
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.new(0.5, 0, 0, y)
        f.Size = UDim2.new(0, sz, 0, sz)
        f.BackgroundTransparency = 1
        f.Parent = card
        corner(f, UDim.new(1, 0))
        local s = Instance.new("UIStroke")
        s.Thickness = th
        s.Color = Color3.new(1, 1, 1)
        s.Parent = f
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(P.accent, P.accent2)
        g.Transparency = NumberSequence.new({ kp(0, 0), kp(0.5, 0.1), kp(0.51, 1), kp(1, 1) })
        g.Parent = s
        TweenService:Create(g, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Rotation = rev and -360 or 360 }):Play()
    end
    arc(94, 3, 1.2, false, 66)
    arc(76, 2, 1.9, true, 66)
    arc(110, 1, 3.2, false, 66)

    local orb = Instance.new("Frame")
    orb.AnchorPoint = Vector2.new(0.5, 0.5)
    orb.Position = UDim2.new(0.5, 0, 0, 66)
    orb.Size = UDim2.new(0, 116, 0, 116)
    orb.BackgroundTransparency = 1
    orb.Parent = card
    for i = 1, 4 do
        local d = Instance.new("Frame")
        local a = math.rad(i * 90)
        d.AnchorPoint = Vector2.new(0.5, 0.5)
        d.Size = UDim2.new(0, (i % 2 == 0) and 5 or 7, 0, (i % 2 == 0) and 5 or 7)
        d.Position = UDim2.new(0.5 + 0.5 * math.cos(a), 0, 0.5 + 0.5 * math.sin(a), 0)
        d.BackgroundColor3 = (i % 2 == 0) and P.accent2 or P.light
        d.BorderSizePixel = 0
        d.Parent = orb
        corner(d, UDim.new(1, 0))
    end
    TweenService:Create(orb, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Rotation = 360 }):Play()

    local logo = Instance.new("TextLabel")
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.new(0.5, 0, 0, 66)
    logo.Size = UDim2.new(0, 52, 0, 52)
    logo.BackgroundColor3 = Color3.fromRGB(80, 36, 130)
    logo.Text = "R"
    logo.TextColor3 = P.light
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 28
    logo.Parent = card
    corner(logo, UDim.new(1, 0))
    local lg = Instance.new("UIGradient")
    lg.Color = ColorSequence.new(Color3.fromRGB(160, 90, 240), Color3.fromRGB(70, 30, 120))
    lg.Rotation = 45
    lg.Parent = logo
    TweenService:Create(logo, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Size = UDim2.new(0, 60, 0, 60) }):Play()
    S.logo = logo

    -- ═══ BURST: particles explode out of the logo when the card appears ═══
    task.delay(0.75, function()
        if S.closed then return end
        for i = 1, 18 do
            local a = (i / 18) * math.pi * 2 + rng:NextNumber(-0.15, 0.15)
            local r = rng:NextNumber(70, 150)
            local d = Instance.new("Frame")
            d.AnchorPoint = Vector2.new(0.5, 0.5)
            d.Position = UDim2.new(0.5, 0, 0, 66)
            d.Size = UDim2.new(0, 4, 0, 4)
            d.BackgroundColor3 = (i % 2 == 0) and P.accent2 or P.light
            d.BorderSizePixel = 0
            d.Parent = card
            corner(d, UDim.new(1, 0))
            tw(d, 0.9, { Position = UDim2.new(0.5, math.cos(a) * r, 0, 66 + math.sin(a) * r),
                BackgroundTransparency = 1, Size = UDim2.new(0, 1, 0, 1) })
            task.delay(1, function() pcall(function() d:Destroy() end) end)
        end
    end)

    -- tap anywhere to skip the intro
    local skip = Instance.new("TextButton")
    skip.Size = UDim2.new(1, 0, 1, 0)
    skip.BackgroundTransparency = 1
    skip.Text = ""
    skip.ZIndex = 50
    skip.Parent = sg
    skip.MouseButton1Click:Connect(function()
        if R.splash and R.splash.close then R.splash.close() end
    end)
    local hint = Instance.new("TextLabel")
    hint.AnchorPoint = Vector2.new(0.5, 1)
    hint.Position = UDim2.new(0.5, 0, 1, -16)
    hint.Size = UDim2.new(0, 200, 0, 14)
    hint.BackgroundTransparency = 1
    hint.Text = "tap anywhere to skip"
    hint.TextColor3 = P.light
    hint.TextTransparency = 0.55
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 10
    hint.ZIndex = 4
    hint.Parent = sg

end)
if not okI then
    R.errors[#R.errors + 1] = { name = "Intro A", err = tostring(errI) }
    warn("[RYZEN] Intro A failed: " .. tostring(errI))
    pcall(function() if S.sg then S.sg:Destroy() end end)
    pcall(function() if S.blur then S.blur:Destroy() end end)
    R.S = nil
end

print("[RYZEN] Part 2/18 (Intro A) loaded")

]==] },
{ name = "Intro B", src = [==[
-- RYZEN ULTRA v11 | PART 3/18 (INTRO B: title + glitch + progress + finale)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.S or not R.S.card then warn("[RYZEN] Run Part 1 & 2 first!") return end

local okI, errI = pcall(function()
    local TweenService = game:GetService("TweenService")
    local tw, corner, stroke, P = R.tw, R.corner, R.stroke, R.pal
    local kp = NumberSequenceKeypoint.new
    local rng = Random.new()
    local S = R.S
    local card = S.card

    local function lbl(y, h, txt, size, col, font, align, x)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, x or 20, 0, y)
        l.Size = UDim2.new(1, -((x or 20) + 20), 0, h)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextSize = size
        l.TextColor3 = col
        l.Font = font
        l.TextXAlignment = align or Enum.TextXAlignment.Center
        l.Parent = card
        return l
    end

    -- ═══ TITLE: typewriter + shimmer + glitch ghosts ═══
    local TITLE = "RYZEN ULTRA"
    local ghostP = lbl(128, 30, TITLE, 26, Color3.fromRGB(255, 80, 200), Enum.Font.GothamBlack)
    local ghostC = lbl(128, 30, TITLE, 26, Color3.fromRGB(70, 220, 255), Enum.Font.GothamBlack)
    ghostP.TextTransparency = 1
    ghostC.TextTransparency = 1
    ghostP.ZIndex, ghostC.ZIndex = 1, 1
    local title = lbl(128, 30, TITLE, 26, Color3.new(1, 1, 1), Enum.Font.GothamBlack)
    title.ZIndex = 2
    title.MaxVisibleGraphemes = 0
    local tg = Instance.new("UIGradient")
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    tg.Offset = Vector2.new(-1, 0)
    tg.Parent = title
    TweenService:Create(tg, TweenInfo.new(1.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Offset = Vector2.new(1, 0) }):Play()
    task.spawn(function()
        task.wait(0.45)
        for i = 1, #TITLE do
            if S.closed then return end
            title.MaxVisibleGraphemes = i
            task.wait(0.055)
        end
    end)
    local function glitch()
        for _ = 1, 6 do
            if S.closed then break end
            local dx = rng:NextInteger(-4, 4)
            ghostP.Position = UDim2.new(0, 20 + dx, 0, 128 + rng:NextInteger(-2, 2))
            ghostC.Position = UDim2.new(0, 20 - dx, 0, 128 + rng:NextInteger(-2, 2))
            ghostP.TextTransparency, ghostC.TextTransparency = 0.35, 0.35
            task.wait(0.04)
        end
        ghostP.Position = UDim2.new(0, 20, 0, 128)
        ghostC.Position = UDim2.new(0, 20, 0, 128)
        ghostP.TextTransparency, ghostC.TextTransparency = 1, 1
    end
    task.spawn(function()
        task.wait(1.5)
        while not S.closed and R.running do
            glitch()
            task.wait(rng:NextNumber(2.5, 4.5))
        end
    end)

    local sub = lbl(160, 14, R.version .. "  •  coded by " .. R.owner, 11, Color3.fromRGB(200, 150, 255), Enum.Font.GothamBold)
    sub.TextTransparency = 1
    task.delay(0.9, function() if not S.closed then tw(sub, 0.6, { TextTransparency = 0 }) end end)

    -- ═══ SPINNER + STATUS + PERCENT ═══
    local spin = Instance.new("Frame")
    spin.AnchorPoint = Vector2.new(0.5, 0.5)
    spin.Position = UDim2.new(0, 27, 0, 193)
    spin.Size = UDim2.new(0, 13, 0, 13)
    spin.BackgroundTransparency = 1
    spin.Parent = card
    corner(spin, UDim.new(1, 0))
    local spS = Instance.new("UIStroke")
    spS.Thickness = 2
    spS.Color = Color3.new(1, 1, 1)
    spS.Parent = spin
    local spG = Instance.new("UIGradient")
    spG.Color = ColorSequence.new(P.accent, P.accent2)
    spG.Transparency = NumberSequence.new({ kp(0, 0), kp(0.6, 0.2), kp(0.61, 1), kp(1, 1) })
    spG.Parent = spS
    TweenService:Create(spG, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Rotation = 360 }):Play()

    local status = lbl(186, 14, "Starting", 11, Color3.fromRGB(190, 160, 220), Enum.Font.Gotham, Enum.TextXAlignment.Left, 42)
    local pctLbl = lbl(186, 14, "0%", 11, Color3.fromRGB(235, 205, 255), Enum.Font.GothamBold, Enum.TextXAlignment.Right)

    -- ═══ PROGRESS BAR (shimmer + glowing head) ═══
    local barBg = Instance.new("Frame")
    barBg.Position = UDim2.new(0, 20, 0, 208)
    barBg.Size = UDim2.new(1, -40, 0, 7)
    barBg.BackgroundColor3 = Color3.fromRGB(45, 22, 70)
    barBg.BorderSizePixel = 0
    barBg.Parent = card
    corner(barBg, UDim.new(1, 0))
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    corner(fill, UDim.new(1, 0))
    local fg = Instance.new("UIGradient")
    fg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 70, 240)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 245)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 90, 255)),
    })
    fg.Offset = Vector2.new(-1, 0)
    fg.Parent = fill
    TweenService:Create(fg, TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Offset = Vector2.new(1, 0) }):Play()
    local head = Instance.new("Frame")
    head.AnchorPoint = Vector2.new(0.5, 0.5)
    head.Position = UDim2.new(1, 0, 0.5, 0)
    head.Size = UDim2.new(0, 13, 0, 13)
    head.BackgroundColor3 = Color3.new(1, 1, 1)
    head.BackgroundTransparency = 0.25
    head.BorderSizePixel = 0
    head.Visible = false
    head.ZIndex = 3
    head.Parent = fill
    corner(head, UDim.new(1, 0))
    TweenService:Create(head, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Size = UDim2.new(0, 9, 0, 9) }):Play()

    -- ═══ TIPS ═══
    local tipLbl = lbl(230, 14, "", 10, Color3.fromRGB(150, 125, 180), Enum.Font.Gotham)
    local tips = {
        "Tip: Drag the R button to any screen edge - it snaps automatically",
        "Tip: Settings tab lets you resize the whole menu",
        "Tip: Visuals tab has cinematic shader presets",
        "Tip: Fun tab effects only affect YOUR screen / character",
        "Tip: If something fails, open Settings > Show Errors",
        "Tip: About tab has the 7yd7 Emote Script loader",
    }
    task.spawn(function()
        local i = 1
        while not S.closed and R.running do
            tipLbl.Text = tips[i]
            tipLbl.TextTransparency = 1
            tw(tipLbl, 0.3, { TextTransparency = 0 })
            task.wait(1.9)
            if S.closed then break end
            tw(tipLbl, 0.25, { TextTransparency = 1 })
            task.wait(0.28)
            i = i % #tips + 1
        end
    end)

    -- animated status dots + smooth percent counter
    local baseTxt, final = "Starting", false
    task.spawn(function()
        local n = 0
        while not S.closed and R.running do
            if not final then
                n = n % 3 + 1
                status.Text = baseTxt .. string.rep(".", n)
            end
            task.wait(0.33)
        end
    end)
    task.spawn(function()
        local shown = 0
        while not S.closed and R.running do
            shown = shown + (S.pct - shown) * 0.25
            pctLbl.Text = math.floor(shown * 100 + 0.5) .. "%"
            task.wait(0.03)
        end
    end)

    -- ═══ FINALE: R turns into a check mark ═══
    local function showCheck()
        local logo = S.logo
        if not logo then return end
        tw(logo, 0.25, { TextTransparency = 1 })
        local box = Instance.new("Frame")
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.Position = UDim2.new(0.5, 0, 0.5, 0)
        box.Size = UDim2.new(0, 30, 0, 30)
        box.BackgroundTransparency = 1
        box.Parent = logo
        local bs = Instance.new("UIScale")
        bs.Scale = 0
        bs.Parent = box
        local function bar(len, ax, ay, rot)
            local b = Instance.new("Frame")
            b.AnchorPoint = Vector2.new(0.5, 0.5)
            b.Position = UDim2.new(0, ax, 0, ay)
            b.Size = UDim2.new(0, 4, 0, len)
            b.Rotation = rot
            b.BackgroundColor3 = Color3.fromRGB(190, 255, 220)
            b.BorderSizePixel = 0
            b.Parent = box
            corner(b, UDim.new(1, 0))
        end
        bar(9, 9, 19, -45)
        bar(19, 18, 14, 43)
        tw(bs, 0.45, { Scale = 1.15 }, Enum.EasingStyle.Back)
    end

    local function flash()
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = Color3.new(1, 1, 1)
        f.BackgroundTransparency = 0.8
        f.BorderSizePixel = 0
        f.ZIndex = 10
        f.Parent = S.sg
        tw(f, 0.55, { BackgroundTransparency = 1 })
        task.delay(0.6, function() pcall(function() f:Destroy() end) end)
    end

    -- ═══ PUBLIC API ═══
    local obj = {}
    function obj.set(p, txt, isFinal)
        if S.closed then return end
        p = math.clamp(p, 0, 1)
        if p < S.pct then p = S.pct end
        S.pct = p
        tw(fill, 0.4, { Size = UDim2.new(p, 0, 1, 0) })
        if p > 0 then head.Visible = true end
        if txt then
            baseTxt = (txt:gsub("%.+$", ""))
            if isFinal then
                final = true
                status.Text = txt
                status.TextColor3 = Color3.fromRGB(190, 255, 220)
                spin.Visible = false
                showCheck()
                flash()
            end
        end
    end
    function obj.close()
        if S.closed then return end
        S.closed = true
        pctLbl.Text = "100%"
        local wave = Instance.new("Frame")
        wave.AnchorPoint = Vector2.new(0.5, 0.5)
        wave.Position = UDim2.new(0.5, 0, 0.5, 0)
        wave.Size = UDim2.new(0, 40, 0, 40)
        wave.BackgroundTransparency = 1
        wave.ZIndex = 4
        wave.Parent = S.sg
        corner(wave, UDim.new(1, 0))
        local ws = stroke(wave, P.accent2, 3, 0)
        tw(wave, 0.9, { Size = UDim2.new(0, 1100, 0, 1100) })
        tw(ws, 0.9, { Transparency = 1 })
        tw(S.sc, 0.55, { Scale = 1.18 })
        tw(S.card, 0.55, { GroupTransparency = 1 })
        tw(S.dim, 0.7, { BackgroundTransparency = 1 })
        if S.blur then
            tw(S.blur, 0.6, { Size = 0 })
            task.delay(0.8, function() pcall(function() S.blur:Destroy() end) end)
        end
        task.delay(1.0, function() pcall(function() S.sg:Destroy() end) end)
    end
    R.splash = obj
    obj.set(0.08, "Loading Rayfield...")

end)
if not okI then
    R.errors[#R.errors + 1] = { name = "Intro B", err = tostring(errI) }
    warn("[RYZEN] Intro B failed: " .. tostring(errI))
    pcall(function() if R.S and R.S.sg then R.S.sg:Destroy() end end)
    pcall(function() if R.S and R.S.blur then R.S.blur:Destroy() end end)
    R.splash = nil
end

print("[RYZEN] Part 3/18 (Intro B) loaded")

]==] },
{ name = "Window", src = [==[
-- RYZEN ULTRA v11 | PART 4/18 (RAYFIELD + WINDOW + TABS)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R then warn("[RYZEN] Run Part 1 first!") return end
-- agar splash (Part 2/3) fail ho jaye to bhi menu chalega
if not R.splash then
    R.splash = { set = function() end, close = function()
        pcall(function() if R.S and R.S.sg then R.S.sg:Destroy() end end)
        pcall(function() if R.S and R.S.blur then R.S.blur:Destroy() end end)
    end }
    R.splash.close()
end
local splash = R.splash

-- ═══ LOAD RAYFIELD ═══
local Rayfield
for _, url in ipairs({
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
}) do
    local ok, res = pcall(function() return loadstring(game:HttpGet(url))() end)
    if ok and res then Rayfield = res break end
    warn("[RYZEN] Rayfield fail:", url, res)
end
if not Rayfield then
    splash.set(1, "Rayfield failed to load - check internet")
    task.delay(3, splash.close)
    pcall(function() R.floatGui:Destroy() end)
    genv.RYZEN = nil
    return
end
R.Rayfield = Rayfield
splash.set(0.18, "Building menu...")

-- ═══ THEME ═══
local Theme = {}
pcall(function() for k, v in pairs(Rayfield.Theme.Default) do Theme[k] = v end end)
for k, v in pairs({
    TextColor = Color3.fromRGB(245, 235, 255),
    Background = Color3.fromRGB(15, 8, 25),
    Topbar = Color3.fromRGB(25, 12, 40),
    Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(25, 12, 40),
    NotificationActionsBackground = Color3.fromRGB(55, 28, 85),
    TabBackground = Color3.fromRGB(25, 12, 40),
    TabStroke = Color3.fromRGB(120, 60, 180),
    TabBackgroundSelected = Color3.fromRGB(100, 50, 160),
    TabTextColor = Color3.fromRGB(200, 180, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(35, 18, 55),
    ElementBackgroundHover = Color3.fromRGB(55, 28, 85),
    SecondaryElementBackground = Color3.fromRGB(25, 12, 40),
    ElementStroke = Color3.fromRGB(80, 40, 130),
    SecondaryElementStroke = Color3.fromRGB(60, 30, 100),
    SliderBackground = Color3.fromRGB(45, 22, 70),
    SliderProgress = Color3.fromRGB(155, 80, 255),
    SliderStroke = Color3.fromRGB(180, 100, 255),
    ToggleBackground = Color3.fromRGB(45, 22, 70),
    ToggleEnabled = Color3.fromRGB(155, 80, 255),
    ToggleDisabled = Color3.fromRGB(75, 55, 95),
    ToggleEnabledStroke = Color3.fromRGB(180, 100, 255),
    ToggleDisabledStroke = Color3.fromRGB(100, 80, 120),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 50, 160),
    ToggleDisabledOuterStroke = Color3.fromRGB(60, 40, 80),
    DropdownSelected = Color3.fromRGB(55, 28, 85),
    DropdownUnselected = Color3.fromRGB(35, 18, 55),
    InputBackground = Color3.fromRGB(25, 12, 40),
    InputStroke = Color3.fromRGB(120, 60, 180),
    PlaceholderColor = Color3.fromRGB(160, 140, 180),
}) do Theme[k] = v end

local cfgBase = {
    Name = "★ RYZEN ULTRA ★  by RYZEN",
    LoadingTitle = "RYZEN ULTRA",
    LoadingSubtitle = R.version .. "  •  coded by RYZEN",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
}
local Window
for _, th in ipairs({ Theme, "Amethyst", false }) do
    local c = {}
    for k, v in pairs(cfgBase) do c[k] = v end
    if th then c.Theme = th end
    local ok, res = pcall(function() return Rayfield:CreateWindow(c) end)
    if ok and res then Window = res break end
    warn("[RYZEN] Window fail:", res)
end
if not Window then
    splash.set(1, "Menu could not be created (Rayfield error)")
    task.delay(3, splash.close)
    pcall(function() R.floatGui:Destroy() end)
    genv.RYZEN = nil
    return
end
R.Window = Window
R.Theme = Theme

local function mkTab(name, icon)
    local ok, t = pcall(function() return Window:CreateTab(name, icon) end)
    if not ok or not t then
        ok, t = pcall(function() return Window:CreateTab(name, 4483362458) end)
    end
    if not ok then warn("[RYZEN] Tab fail:", name, t) end
    return ok and t or nil
end
R.Tabs = {
    Teleport  = mkTab("Teleport", "map-pin"),
    Movement  = mkTab("Movement", "wind"),
    Visuals   = mkTab("Visuals", "eye"),
    Misc      = mkTab("Misc", "layout-grid"),
    Interface = mkTab("Settings", "settings"),
    About     = mkTab("About", "info"),
}

function R.notify(title, content, dur)
    if not R.notifOn then return end
    pcall(function()
        Rayfield:Notify({ Title = title, Content = content, Duration = dur or 3, Image = 4483362458 })
    end)
end

print("[RYZEN] Part 4/18 (Rayfield + Window) loaded")

]==] },
{ name = "Runner", src = [==[
-- RYZEN ULTRA v11 | PART 5/18 (MENU HELPERS + RUNNER + GLITCH FIX)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.Rayfield then warn("[RYZEN] Run Parts 1-4 first!") return end
if not R.splash then R.splash = { set = function() end, close = function() end } end

local Players = game:GetService("Players")
local Rayfield, guiParent, coreGui = R.Rayfield, R.guiParent, R.coreGui
local splash = R.splash

-- ═══ FIND RAYFIELD GUI + APPLY MENU SCALE (ek baar, koi tween nahi) ═══
local function findRayfieldGui()
    for _, p in ipairs({ guiParent, coreGui }) do
        if p then
            for _, g in ipairs(p:GetChildren()) do
                if g:IsA("ScreenGui") then
                    local m = g:FindFirstChild("Main")
                    if m and m:FindFirstChild("Topbar") then return g end
                end
            end
        end
    end
end
R.findRayfieldGui = findRayfieldGui
task.spawn(function()
    local g
    for _ = 1, 100 do
        g = findRayfieldGui()
        if g then break end
        task.wait(0.1)
    end
    if g then
        local s = Instance.new("UIScale")
        s.Scale = R.scale
        s.Parent = g.Main
        R.uiScale = s
    end
end)

-- GLITCH FIX: pehle yahan UIScale tween hota tha jo Rayfield ke apne size animation se lad jata tha.
function R.playOpenAnim() end

function R.setMenu(show)
    local ok = pcall(function() Rayfield:SetVisibility(show) end)
    if not ok then
        local g = findRayfieldGui()
        if g then g.Enabled = show end
    end
end
function R.menuVisible()
    local ok, res = pcall(function() return Rayfield:IsVisible() end)
    if ok and type(res) == "boolean" then return res end
    local g = findRayfieldGui()
    if g then return g.Enabled end
    return true
end

-- Debounce: Rayfield ka animation khatam hone se pehle dobara toggle nahi hoga
local lockUntil = 0
function R.toggleMenu()
    if os.clock() < lockUntil then return end
    lockUntil = os.clock() + 0.7
    R.setMenu(not R.menuVisible())
end

-- ═══ MODULE RUNNER / FINISH / UNLOAD ═══
function R.run(name, fn)
    R.lastAct = os.clock()
    splash.set(math.min(0.2 + 0.75 * (R.attempted / R.total), 0.97), "Loading " .. name .. "...")
    local ok, err = xpcall(fn, function(e) return tostring(e) end)
    R.attempted = R.attempted + 1
    if ok then
        R.okCount = R.okCount + 1
    else
        R.errors[#R.errors + 1] = { name = name, err = err }
        warn("[RYZEN] Module fail: " .. name .. " -> " .. tostring(err))
        R.notify("⚠ " .. name .. " failed", tostring(err):sub(1, 120))
    end
end

function R.finish()
    if R.finished then return end
    R.finished = true
    local nm = Players.LocalPlayer.DisplayName
    splash.set(1, "Welcome, " .. nm .. "  ✔", true)
    task.delay(1.1, splash.close)
    task.delay(1.5, function()
        R.notify("★ RYZEN ULTRA ★", "Loaded " .. R.okCount .. "/" .. R.total .. " modules  •  coded by RYZEN", 5)
    end)
    print("[RYZEN " .. R.version .. "] Loaded " .. R.okCount .. "/" .. R.total .. " modules.")
end

function R.unload()
    R.running = false
    for i = #R.cleanups, 1, -1 do pcall(R.cleanups[i]) end
    for _, c in ipairs(R.conns) do pcall(function() c:Disconnect() end) end
    pcall(function() Rayfield:Destroy() end)
    pcall(function() R.floatGui:Destroy() end)
    pcall(function() splash.close() end)
    genv.RYZEN = nil
end

-- Watchdog: 90 sec koi part na aaye to loading card band
task.spawn(function()
    while R.running and not R.finished do
        task.wait(5)
        if os.clock() - R.lastAct > 90 then splash.close() break end
    end
end)

splash.set(0.2, "Core ready ✔")
print("[RYZEN] Part 5/18 (Runner) loaded")

]==] },
{ name = "Teleport 1", src = [==[
-- RYZEN ULTRA v11 | PART 6/18 (TELEPORT 1/3)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-5 first!") return end

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local bind, notify, firstOpt = R.bind, R.notify, R.firstOpt
local getChar, getHum, getHRP = R.getChar, R.getHum, R.getHRP

R.run("Teleport 1/3", function()
    local Tab = R.Tabs.Teleport
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local T = { selected = nil, smooth = false, dist = 4, last = nil, busy = false }
    R.T = T

    -- ═══ CORE TELEPORT ═══
    local function safeTP(cf)
        local char, hrp, hum = getChar(), getHRP(), getHum()
        if not (char and hrp) then notify("✖ Error", "Character not loaded") return end
        if T.busy then return end
        T.busy = true
        T.last = hrp.CFrame
        task.spawn(function()
            pcall(function()
                if hum and hum.SeatPart then hum.Sit = false task.wait(0.1) end
                if T.smooth then
                    local cv = Instance.new("CFrameValue")
                    cv.Value = char:GetPivot()
                    local c = cv.Changed:Connect(function(v) pcall(function() char:PivotTo(v) end) end)
                    local t = TweenService:Create(cv, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Value = cf })
                    t:Play()
                    t.Completed:Wait()
                    c:Disconnect()
                    cv:Destroy()
                end
                for _ = 1, 8 do
                    if not char.Parent then break end
                    char:PivotTo(cf)
                    local r = char:FindFirstChild("HumanoidRootPart")
                    if r then
                        r.AssemblyLinearVelocity = Vector3.zero
                        r.AssemblyAngularVelocity = Vector3.zero
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
            T.busy = false
        end)
    end
    R.safeTP = safeTP

    -- ═══ PLAYER SELECT ═══
    local function playerNames()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then t[#t + 1] = p.Name end
        end
        table.sort(t)
        return t
    end
    local function findPlayer(q)
        q = ((q or ""):lower():gsub("%s+", ""))
        if q == "" then return nil end
        local partial
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local n, d = p.Name:lower(), p.DisplayName:lower()
                if n == q or d == q then return p end
                if not partial and (n:find(q, 1, true) or d:find(q, 1, true)) then partial = p end
            end
        end
        return partial
    end

    U("Section", "Player")
    local selLabel = U("Label", "Selected: none")
    local function setSelected(p)
        T.selected = p
        if selLabel then pcall(function() selLabel:Set("Selected: " .. p.Name) end) end
        notify("✔ Selected", p.Name)
    end
    T.setSelected = setSelected

    local playerDrop = U("Dropdown", {
        Name = "Select Player",
        Options = playerNames(),
        CurrentOption = {},
        MultipleOptions = false,
        Callback = function(opt)
            local v = firstOpt(opt)
            if v then
                local p = Players:FindFirstChild(v)
                if p then setSelected(p) end
            end
        end,
    })
    U("Input", {
        Name = "Search player (name / display name)",
        PlaceholderText = "Type 3+ letters, press Enter",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            local p = findPlayer(text)
            if p then setSelected(p) else notify("✖ Not found", "No matching player") end
        end,
    })
    U("Button", {
        Name = "Refresh Player List",
        Callback = function()
            if playerDrop then pcall(function() playerDrop:Refresh(playerNames()) end) end
        end,
    })
    local function autoRefresh()
        task.wait(0.5)
        if playerDrop then pcall(function() playerDrop:Refresh(playerNames()) end) end
    end
    bind(Players.PlayerAdded, autoRefresh)
    bind(Players.PlayerRemoving, function(p)
        if p == T.selected then
            T.selected = nil
            if selLabel then pcall(function() selLabel:Set("Selected: none") end) end
        end
        autoRefresh()
    end)

    function T.targetRoot()
        local p = T.selected
        if not (p and p.Parent) then notify("✖ Error", "Select a player first") return nil end
        local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if not r then notify("✖ Error", p.Name .. "'s character is not loaded (too far?)") return nil end
        return r, p
    end
end)

print("[RYZEN] Part 6/18 (Teleport 1/3) done")

]==] },
{ name = "Teleport 2", src = [==[
-- RYZEN ULTRA v11 | PART 7/18 (TELEPORT 2/3)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-6 first!") return end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local notify = R.notify
local getChar, getHum, getHRP = R.getChar, R.getHum, R.getHRP

R.run("Teleport 2/3", function()
    local Tab = R.Tabs.Teleport
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local T, safeTP = R.T, R.safeTP
    if not T then error("Run Part 6 first") end

    U("Section", "Teleport Actions")
    U("Button", {
        Name = "Teleport to Player",
        Callback = function()
            local r, p = T.targetRoot()
            if r then safeTP(r.CFrame * CFrame.new(0, 2, T.dist)) notify("✔ Teleported", "→ " .. p.Name) end
        end,
    })
    U("Button", {
        Name = "Bring Player (client-side, only you see it)",
        Callback = function()
            local r, p = T.targetRoot()
            local me = getHRP()
            if r and me then
                r.CFrame = me.CFrame * CFrame.new(0, 0, -4)
                notify("✔ Brought", p.Name .. " (client-side)")
            end
        end,
    })
    U("Button", {
        Name = "Teleport to Nearest Player",
        Callback = function()
            local me = getHRP()
            if not me then return end
            local best, bd
            for _, p in ipairs(Players:GetPlayers()) do
                local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local d = (r.Position - me.Position).Magnitude
                    if not bd or d < bd then best, bd = p, d end
                end
            end
            if best then
                T.setSelected(best)
                safeTP(best.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, T.dist))
            else
                notify("✖ Error", "No players nearby")
            end
        end,
    })
    U("Button", {
        Name = "Teleport to Random Player",
        Callback = function()
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    list[#list + 1] = p
                end
            end
            if #list > 0 then
                local p = list[math.random(1, #list)]
                T.setSelected(p)
                safeTP(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, T.dist))
            else
                notify("✖ Error", "No players found")
            end
        end,
    })
    U("Button", {
        Name = "Undo Teleport (back to previous position)",
        Callback = function()
            if T.last then safeTP(T.last) else notify("✖ Error", "No previous position saved") end
        end,
    })

    -- Follow / Orbit / Spectate
    local followConn, orbitConn, followTog, orbitTog, specTog
    local function stopFollow() if followConn then followConn:Disconnect() followConn = nil end end
    local function stopOrbit() if orbitConn then orbitConn:Disconnect() orbitConn = nil end end
    followTog = U("Toggle", {
        Name = "Follow Player",
        CurrentValue = false,
        Callback = function(on)
            stopFollow()
            if on then
                if not T.targetRoot() then
                    if followTog then pcall(function() followTog:Set(false) end) end
                    return
                end
                followConn = RunService.Heartbeat:Connect(function()
                    local char = getChar()
                    local r = T.selected and T.selected.Character and T.selected.Character:FindFirstChild("HumanoidRootPart")
                    if char and r then char:PivotTo(r.CFrame * CFrame.new(0, 0, T.dist)) end
                end)
            end
        end,
    })
    orbitTog = U("Toggle", {
        Name = "Orbit Player",
        CurrentValue = false,
        Callback = function(on)
            stopOrbit()
            if on then
                if not T.targetRoot() then
                    if orbitTog then pcall(function() orbitTog:Set(false) end) end
                    return
                end
                local t0 = os.clock()
                orbitConn = RunService.Heartbeat:Connect(function()
                    local char = getChar()
                    local r = T.selected and T.selected.Character and T.selected.Character:FindFirstChild("HumanoidRootPart")
                    if char and r then
                        local a = (os.clock() - t0) * 2
                        char:PivotTo(CFrame.new(r.Position + Vector3.new(math.cos(a) * 8, 2, math.sin(a) * 8), r.Position))
                    end
                end)
            end
        end,
    })
    R.cleanups[#R.cleanups + 1] = function() stopFollow() stopOrbit() end

    function R.stopSpectate()
        local h = getHum()
        if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = h end
    end
    specTog = U("Toggle", {
        Name = "Spectate Player",
        CurrentValue = false,
        Callback = function(on)
            if on then
                local th = T.selected and T.selected.Character and T.selected.Character:FindFirstChildOfClass("Humanoid")
                if th then
                    workspace.CurrentCamera.CameraSubject = th
                else
                    notify("✖ Error", "Select a player first")
                    if specTog then pcall(function() specTog:Set(false) end) end
                end
            else
                R.stopSpectate()
            end
        end,
    })
    R.cleanups[#R.cleanups + 1] = function() R.stopSpectate() end
end)

print("[RYZEN] Part 7/18 (Teleport 2/3) done")

]==] },
{ name = "Teleport 3", src = [==[
-- RYZEN ULTRA v11 | PART 8/18 (TELEPORT 3/3)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-7 first!") return end

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local bind, notify, firstOpt = R.bind, R.notify, R.firstOpt
local getChar, getHRP = R.getChar, R.getHRP

R.run("Teleport 3/3", function()
    local Tab = R.Tabs.Teleport
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local T, safeTP = R.T, R.safeTP
    if not T then error("Run Part 6 first") end

    -- ═══ OPTIONS ═══
    U("Section", "Teleport Options")
    U("Slider", {
        Name = "Offset Distance (behind player)", Range = { 0, 20 }, Increment = 1, Suffix = " studs",
        CurrentValue = 4, Callback = function(v) T.dist = v end,
    })
    U("Toggle", { Name = "Smooth Teleport", CurrentValue = false, Callback = function(v) T.smooth = v end })
    local clickTP = false
    U("Toggle", {
        Name = "Tap / Click Teleport (Ctrl+Click on PC)", CurrentValue = false,
        Callback = function(v) clickTP = v end,
    })
    local function rayAt(x, y)
        local cam = workspace.CurrentCamera
        local ray = cam:ViewportPointToRay(x, y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { getChar() }
        return workspace:Raycast(ray.Origin, ray.Direction * 3000, params)
    end
    bind(UIS.TouchTapInWorld, function(pos, processed)
        if not clickTP or processed then return end
        local r = rayAt(pos.X, pos.Y)
        if r then safeTP(CFrame.new(r.Position + Vector3.new(0, 3, 0))) end
    end)
    bind(UIS.InputBegan, function(i, gp)
        if gp or not clickTP then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            local m = UIS:GetMouseLocation()
            local r = rayAt(m.X, m.Y)
            if r then safeTP(CFrame.new(r.Position + Vector3.new(0, 3, 0))) end
        end
    end)

    U("Button", {
        Name = "Sky TP (+60 studs up)",
        Callback = function()
            local hrp = getHRP()
            if hrp then safeTP(hrp.CFrame + Vector3.new(0, 60, 0)) end
        end,
    })
    U("Button", {
        Name = "Forward TP (+60 studs ahead)",
        Callback = function()
            local hrp = getHRP()
            if hrp then safeTP(hrp.CFrame * CFrame.new(0, 0, -60)) end
        end,
    })

    local coordText = ""
    U("Input", {
        Name = "Coordinates (x, y, z)", PlaceholderText = "e.g. 100, 50, -20",
        RemoveTextAfterFocusLost = false, Callback = function(t) coordText = t end,
    })
    U("Button", {
        Name = "Teleport to Coordinates",
        Callback = function()
            local nums = {}
            for n in tostring(coordText):gmatch("-?%d+%.?%d*") do nums[#nums + 1] = tonumber(n) end
            if #nums >= 3 then
                safeTP(CFrame.new(nums[1], nums[2], nums[3]))
                notify("✔ Teleported", string.format("%s, %s, %s", nums[1], nums[2], nums[3]))
            else
                notify("✖ Error", "Enter 3 numbers: x, y, z")
            end
        end,
    })

    -- ═══ WAYPOINTS ═══
    U("Section", "Waypoints")
    local waypoints, wpSelected, wpInput = {}, nil, ""
    local wpDrop = U("Dropdown", {
        Name = "Saved Waypoints", Options = {}, CurrentOption = {}, MultipleOptions = false,
        Callback = function(opt)
            local v = firstOpt(opt)
            if v then wpSelected = v end
        end,
    })
    U("Input", {
        Name = "Waypoint Name", PlaceholderText = "e.g. Base",
        RemoveTextAfterFocusLost = false, Callback = function(t) wpInput = t end,
    })
    local function refreshWP()
        local names = {}
        for n in pairs(waypoints) do names[#names + 1] = n end
        table.sort(names)
        if wpDrop then pcall(function() wpDrop:Refresh(names) end) end
    end
    local function wpCount()
        local c = 0
        for _ in pairs(waypoints) do c = c + 1 end
        return c
    end
    U("Button", {
        Name = "Save Current Position",
        Callback = function()
            local hrp = getHRP()
            if not hrp then return end
            local name = (wpInput ~= "" and wpInput) or ("WP" .. (wpCount() + 1))
            waypoints[name] = hrp.CFrame
            refreshWP()
            notify("✔ Saved", name)
        end,
    })
    U("Button", {
        Name = "Teleport to Waypoint",
        Callback = function()
            if wpSelected and waypoints[wpSelected] then safeTP(waypoints[wpSelected])
            else notify("✖ Error", "Select a waypoint first") end
        end,
    })
    U("Button", {
        Name = "Delete Waypoint",
        Callback = function()
            if wpSelected then
                waypoints[wpSelected] = nil
                wpSelected = nil
                refreshWP()
            end
        end,
    })
    U("Button", {
        Name = "Teleport to Spawn",
        Callback = function()
            local sp = LP.RespawnLocation or workspace:FindFirstChildWhichIsA("SpawnLocation", true)
            if sp then safeTP(sp.CFrame + Vector3.new(0, 5, 0)) else notify("✖ Error", "Spawn not found") end
        end,
    })
    U("Button", {
        Name = "Copy My Position",
        Callback = function()
            local hrp = getHRP()
            if hrp and setclipboard then
                local p = hrp.Position
                setclipboard(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z))
                notify("✔ Copied", "Position copied to clipboard")
            end
        end,
    })
end)

print("[RYZEN] Part 8/18 (Teleport 3/3) done")

]==] },
{ name = "Movement 1", src = [==[
-- RYZEN ULTRA v11 | PART 9/18 (MOVEMENT 1/2)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-8 first!") return end

local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local bind, tw, corner, stroke, isTap = R.bind, R.tw, R.corner, R.stroke, R.isTap
local getHum, getHRP = R.getHum, R.getHRP

R.run("Movement 1/2", function()
    local Tab = R.Tabs.Movement
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local floatGui = R.floatGui
    local M = { flying = false, flySpeed = 60, ws = 16, jp = 50, lock = false, defGravity = workspace.Gravity }
    R.M = M
    local flyBV, flyBG, flyConn
    local flyUp, flyDown = false, false

    -- ═══ FLY UP / DOWN BUTTONS (mobile) ═══
    local function makeFlyBtn(txt, yOff)
        local b = Instance.new("TextButton")
        b.AnchorPoint = Vector2.new(1, 1)
        b.Position = UDim2.new(1, -30, 1, yOff)
        b.Size = UDim2.new(0, 0, 0, 0)
        b.BackgroundColor3 = Color3.fromRGB(50, 22, 80)
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(235, 190, 255)
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.AutoButtonColor = false
        b.Visible = false
        b.Parent = floatGui
        corner(b, UDim.new(1, 0))
        stroke(b, Color3.fromRGB(180, 100, 255), 2, 0.2)
        return b
    end
    local upBtn, downBtn = makeFlyBtn("UP", -200), makeFlyBtn("DN", -150)
    local function holdBind(btn, setter)
        bind(btn.InputBegan, function(i)
            if isTap(i) then setter(true) tw(btn, 0.1, { BackgroundColor3 = Color3.fromRGB(120, 60, 190) }) end
        end)
        bind(btn.InputEnded, function(i)
            if isTap(i) then setter(false) tw(btn, 0.1, { BackgroundColor3 = Color3.fromRGB(50, 22, 80) }) end
        end)
    end
    holdBind(upBtn, function(v) flyUp = v end)
    holdBind(downBtn, function(v) flyDown = v end)

    local function showFlyButtons(show)
        for _, b in ipairs({ upBtn, downBtn }) do
            if show then
                b.Visible = true
                tw(b, 0.3, { Size = UDim2.new(0, 46, 0, 46) }, Enum.EasingStyle.Back)
            else
                tw(b, 0.2, { Size = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.22, function() if not M.flying then b.Visible = false end end)
            end
        end
    end

    local function stopFly()
        M.flying = false
        flyUp, flyDown = false, false
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        local h = getHum()
        if h then h.PlatformStand = false end
        showFlyButtons(false)
    end
    M.stopFly = stopFly

    local function startFly()
        local hrp, hum = getHRP(), getHum()
        if not hrp or not hum then return end
        stopFly()
        M.flying = true
        hum.PlatformStand = true

        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "RyzenFly"
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp

        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "RyzenFlyGyro"
        flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBG.P = 9e4
        flyBG.Parent = hrp

        local current = Vector3.zero
        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local h = getHum()
            if not (M.flying and cam and h and flyBV and flyBG and flyBV.Parent) then return end
            local rel = cam.CFrame:VectorToObjectSpace(h.MoveDirection)
            local target = (cam.CFrame.LookVector * -rel.Z + cam.CFrame.RightVector * rel.X) * M.flySpeed
            local up = 0
            if flyUp or UIS:IsKeyDown(Enum.KeyCode.Space) then up = 1 end
            if flyDown or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then up = -1 end
            target = target + Vector3.new(0, up * M.flySpeed, 0)
            current = current:Lerp(target, 0.25)
            flyBV.Velocity = current
            flyBG.CFrame = cam.CFrame
        end)
        showFlyButtons(true)
    end

    U("Section", "Fly")
    M.flyToggle = U("Toggle", {
        Name = "Enable Fly", CurrentValue = false,
        Callback = function(on) if on then startFly() else stopFly() end end,
    })
    U("Slider", {
        Name = "Fly Speed", Range = { 10, 400 }, Increment = 5, Suffix = " spd", CurrentValue = 60,
        Callback = function(v) M.flySpeed = v end,
    })

    U("Section", "Humanoid")
    U("Slider", {
        Name = "WalkSpeed", Range = { 16, 500 }, Increment = 1, Suffix = " spd", CurrentValue = 16,
        Callback = function(v)
            M.ws = v
            local h = getHum()
            if h then h.WalkSpeed = v end
        end,
    })
    U("Toggle", {
        Name = "Lock Speed (keeps value after reset)", CurrentValue = false,
        Callback = function(v) M.lock = v end,
    })
    U("Slider", {
        Name = "JumpPower", Range = { 50, 500 }, Increment = 5, Suffix = " pow", CurrentValue = 50,
        Callback = function(v)
            M.jp = v
            local h = getHum()
            if h then h.UseJumpPower = true h.JumpPower = v end
        end,
    })
    U("Slider", {
        Name = "Gravity", Range = { 0, 400 }, Increment = 5,
        CurrentValue = math.clamp(math.floor(M.defGravity), 0, 400),
        Callback = function(v) workspace.Gravity = v end,
    })

    R.cleanups[#R.cleanups + 1] = function()
        stopFly()
        workspace.Gravity = M.defGravity
    end
end)

print("[RYZEN] Part 9/18 (Movement 1/2) done")

]==] },
{ name = "Movement 2", src = [==[
-- RYZEN ULTRA v11 | PART 10/18 (MOVEMENT 2/2)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-9 first!") return end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local bind = R.bind
local getChar, getHum, getHRP = R.getChar, R.getHum, R.getHRP

R.run("Movement 2/2", function()
    local Tab = R.Tabs.Movement
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local M = R.M
    if not M then error("Run Part 9 first") end

    U("Section", "Utility")
    local noclip, infJump, antiVoid, antiFling, spin, bhop, airOn = false, false, false, false, false, false, false
    local spinSpeed, lastSafe, airPart, airY = 10, nil, nil, 0

    U("Toggle", { Name = "Noclip", CurrentValue = false, Callback = function(v) noclip = v end })
    U("Toggle", { Name = "Infinite Jump", CurrentValue = false, Callback = function(v) infJump = v end })
    U("Toggle", { Name = "Bunny Hop (auto jump)", CurrentValue = false, Callback = function(v) bhop = v end })
    U("Toggle", {
        Name = "Air Walk", CurrentValue = false,
        Callback = function(v)
            airOn = v
            local hrp = getHRP()
            if v and hrp then airY = hrp.Position.Y - 3.2 end
            if not v and airPart then airPart:Destroy() airPart = nil end
        end,
    })
    U("Toggle", {
        Name = "Freeze Position", CurrentValue = false,
        Callback = function(v) local hrp = getHRP() if hrp then hrp.Anchored = v end end,
    })
    U("Toggle", { Name = "Anti Void (safe-position rescue)", CurrentValue = false, Callback = function(v) antiVoid = v end })
    U("Toggle", { Name = "Anti Fling", CurrentValue = false, Callback = function(v) antiFling = v end })
    U("Toggle", { Name = "Spin", CurrentValue = false, Callback = function(v) spin = v end })
    U("Slider", {
        Name = "Spin Speed", Range = { 1, 60 }, Increment = 1, CurrentValue = 10,
        Callback = function(v) spinSpeed = v end,
    })
    U("Button", {
        Name = "Reset Character",
        Callback = function() local h = getHum() if h then h.Health = 0 end end,
    })

    bind(RunService.Stepped, function()
        local c = getChar()
        if noclip and c then
            for _, v in ipairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    bind(UIS.JumpRequest, function()
        if infJump then
            local h = getHum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
    bind(RunService.Heartbeat, function()
        local hrp, h = getHRP(), getHum()
        if not (hrp and h) then return end
        if antiFling and hrp.AssemblyAngularVelocity.Magnitude > 60 then
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        if M.lock and h.WalkSpeed ~= M.ws then h.WalkSpeed = M.ws end
        if spin and not M.flying then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
        if bhop and h.MoveDirection.Magnitude > 0 and h.FloorMaterial ~= Enum.Material.Air then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if airOn then
            if not airPart then
                airPart = Instance.new("Part")
                airPart.Name = "RyzenAir"
                airPart.Size = Vector3.new(8, 1, 8)
                airPart.Anchored = true
                airPart.Transparency = 1
                airPart.CanQuery = false
                airPart.Parent = workspace
            end
            airPart.CFrame = CFrame.new(hrp.Position.X, airY, hrp.Position.Z)
        end
    end)
    task.spawn(function()
        while R.running and task.wait(0.25) do
            local hrp, h = getHRP(), getHum()
            if hrp and h and antiVoid then
                local lim = workspace.FallenPartsDestroyHeight
                if h.FloorMaterial ~= Enum.Material.Air and hrp.Position.Y > lim + 100 then lastSafe = hrp.CFrame end
                if lastSafe and hrp.Position.Y < lim + 80 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = lastSafe + Vector3.new(0, 4, 0)
                end
            end
        end
    end)

    bind(LP.CharacterAdded, function(char)
        M.stopFly()
        if R.stopSpectate then R.stopSpectate() end
        if M.flyToggle then pcall(function() M.flyToggle:Set(false) end) end
        local h = char:WaitForChild("Humanoid", 10)
        if h then
            task.wait(0.5)
            if M.ws ~= 16 then h.WalkSpeed = M.ws end
            if M.jp ~= 50 then h.UseJumpPower = true h.JumpPower = M.jp end
        end
    end)

    R.cleanups[#R.cleanups + 1] = function()
        if airPart then pcall(function() airPart:Destroy() end) end
        local hrp, h = getHRP(), getHum()
        if hrp then hrp.Anchored = false end
        if h then h.WalkSpeed = 16 h.JumpPower = 50 end
    end
end)

print("[RYZEN] Part 10/18 (Movement 2/2) done")

]==] },
{ name = "Visuals 1 ESP", src = [==[
-- RYZEN ULTRA v11 | PART 11/18 (VISUALS 1/4: ESP)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-10 first!") return end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local bind, corner, getHRP = R.bind, R.corner, R.getHRP
local C = Color3.fromRGB

R.run("Visuals 1/4 (ESP)", function()
    local Tab = R.Tabs.Visuals
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end

    local ESP = { on = false, info = true, rainbow = false, teamCheck = false,
                  max = 1500, fill = 0.55, outlineMatch = false, color = C(175, 100, 255) }
    local V = { ESP = ESP, SH = { on = false, name = "Off", k = 1 } }
    R.V = V

    pcall(function()
        for _, c in ipairs(R.guiParent:GetChildren()) do
            if c.Name == "RyzenESP" then c:Destroy() end
        end
    end)
    local espFolder = Instance.new("Folder")
    espFolder.Name = "RyzenESP"
    espFolder.Parent = R.guiParent
    local objs = {}

    local function clearESP(plr)
        local o = objs[plr]
        if o then
            pcall(function() o.folder:Destroy() end)
            objs[plr] = nil
        end
    end
    function V.clearAllESP() for p in pairs(objs) do clearESP(p) end end

    local function mkLabel(parent, y, h, size, font)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Position = UDim2.new(0, 0, 0, y)
        l.Size = UDim2.new(1, 0, 0, h)
        l.Font = font
        l.TextSize = size
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextStrokeTransparency = 0.35
        l.TextStrokeColor3 = Color3.new(0, 0, 0)
        l.Text = ""
        l.Parent = parent
        return l
    end

    local function build(plr)
        clearESP(plr)
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local head = char:FindFirstChild("Head") or hrp

        local f = Instance.new("Folder")
        f.Name = tostring(plr.UserId)
        f.Parent = espFolder

        local hl = Instance.new("Highlight")
        hl.FillColor = ESP.color
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.FillTransparency = ESP.fill
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = f

        local bb = Instance.new("BillboardGui")
        bb.Adornee = head
        bb.Size = UDim2.new(0, 170, 0, 40)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.Parent = f

        local nameL = mkLabel(bb, 0, 16, 13, Enum.Font.GothamBold)
        nameL.Text = plr.DisplayName
        local infoL = mkLabel(bb, 16, 14, 11, Enum.Font.Gotham)

        local barBg = Instance.new("Frame")
        barBg.AnchorPoint = Vector2.new(0.5, 0)
        barBg.Position = UDim2.new(0.5, 0, 0, 33)
        barBg.Size = UDim2.new(0, 70, 0, 4)
        barBg.BackgroundColor3 = C(20, 20, 20)
        barBg.BackgroundTransparency = 0.2
        barBg.BorderSizePixel = 0
        barBg.Parent = bb
        corner(barBg, UDim.new(1, 0))
        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(1, 0, 1, 0)
        barFill.BackgroundColor3 = C(80, 255, 120)
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg
        corner(barFill, UDim.new(1, 0))

        local o = { folder = f, char = char, hl = hl, bb = bb, name = nameL,
                    info = infoL, barBg = barBg, fill = barFill }
        objs[plr] = o
        return o
    end

    local acc = 0
    bind(RunService.Heartbeat, function(dt)
        if not ESP.on then return end
        acc = acc + dt
        if acc < 0.1 then return end
        acc = 0
        local me = getHRP()
        local col = ESP.rainbow and Color3.fromHSV((os.clock() * 0.25) % 1, 0.8, 1) or ESP.color
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local char = p.Character
                local hide = (not char) or (ESP.teamCheck and LP.Team ~= nil and p.Team == LP.Team)
                if hide then
                    clearESP(p)
                else
                    local o = objs[p]
                    if (not o) or o.char ~= char or not o.folder.Parent then o = build(p) end
                    if o and me then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hrp then
                            local d = (hrp.Position - me.Position).Magnitude
                            local vis = d <= ESP.max
                            o.hl.Enabled = vis
                            o.bb.Enabled = vis
                            if vis then
                                o.hl.FillColor = col
                                o.hl.OutlineColor = ESP.outlineMatch and col or Color3.new(1, 1, 1)
                                o.hl.FillTransparency = ESP.fill
                                o.name.TextColor3 = col
                                o.info.Visible = ESP.info
                                o.barBg.Visible = ESP.info
                                if ESP.info then
                                    local hp = hum and hum.Health or 0
                                    local mx = hum and hum.MaxHealth or 100
                                    o.info.Text = string.format("%d m  •  %d HP", math.floor(d + 0.5), math.floor(hp + 0.5))
                                    local fr = math.clamp(hp / math.max(mx, 1), 0, 1)
                                    o.fill.Size = UDim2.new(fr, 0, 1, 0)
                                    o.fill.BackgroundColor3 = Color3.fromHSV(fr * 0.33, 0.85, 1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    bind(Players.PlayerRemoving, clearESP)

    U("Section", "ESP")
    U("Toggle", { Name = "Player ESP", CurrentValue = false, Callback = function(v)
        ESP.on = v
        if not v then V.clearAllESP() end
    end })
    U("Toggle", { Name = "Show Distance + Health", CurrentValue = true, Callback = function(v) ESP.info = v end })
    U("Toggle", { Name = "Hide Teammates", CurrentValue = false, Callback = function(v) ESP.teamCheck = v end })
    U("Toggle", { Name = "Rainbow ESP", CurrentValue = false, Callback = function(v) ESP.rainbow = v end })
    U("Toggle", { Name = "Outline matches ESP color", CurrentValue = false, Callback = function(v) ESP.outlineMatch = v end })
    U("Slider", {
        Name = "ESP Max Distance", Range = { 50, 3000 }, Increment = 50, Suffix = " m", CurrentValue = 1500,
        Callback = function(v) ESP.max = v end,
    })
    U("Slider", {
        Name = "Fill Transparency", Range = { 0, 1 }, Increment = 0.05, CurrentValue = 0.55,
        Callback = function(v) ESP.fill = v end,
    })

    R.cleanups[#R.cleanups + 1] = function()
        V.clearAllESP()
        pcall(function() espFolder:Destroy() end)
    end
end)

print("[RYZEN] Part 11/18 (Visuals 1/4) done")

]==] },
{ name = "Visuals 2 Color", src = [==[
-- RYZEN ULTRA v11 | PART 12/18 (VISUALS 2/4: ESP COLOR + CAMERA)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-11 first!") return end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local bind, corner, notify, firstOpt = R.bind, R.corner, R.notify, R.firstOpt
local C = Color3.fromRGB

R.run("Visuals 2/4 (Color+Camera)", function()
    local Tab = R.Tabs.Visuals
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local V = R.V
    if not V then error("Run Part 11 first") end
    local ESP = V.ESP

    -- ═══ ESP COLOR (RGB sliders + presets + HEX) ═══
    U("Section", "ESP Color")
    local rgb = { 175, 100, 255 }
    local sliders, syncing = {}, false
    local colorLbl = U("Label", "Current color: #AF64FF")
    local function toHex(c)
        return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function refreshLabel()
        if colorLbl then pcall(function() colorLbl:Set("Current color: " .. toHex(ESP.color), nil, ESP.color) end) end
    end
    local function setColor(c)
        ESP.color = c
        rgb = { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
        refreshLabel()
        syncing = true
        for i, s in ipairs(sliders) do pcall(function() s:Set(rgb[i]) end) end
        syncing = false
    end

    local COLORS = {
        Purple = C(175, 100, 255), Red = C(255, 60, 60), Green = C(70, 255, 110), Blue = C(60, 130, 255),
        Cyan = C(40, 235, 255), Yellow = C(255, 235, 60), Pink = C(255, 100, 200), Orange = C(255, 150, 40),
        White = C(255, 255, 255),
    }
    U("Dropdown", {
        Name = "Color Preset",
        Options = { "Purple", "Red", "Green", "Blue", "Cyan", "Yellow", "Pink", "Orange", "White" },
        CurrentOption = { "Purple" },
        MultipleOptions = false,
        Callback = function(opt)
            local v = firstOpt(opt)
            if v and COLORS[v] then setColor(COLORS[v]) end
        end,
    })
    for i, nm in ipairs({ "Red", "Green", "Blue" }) do
        sliders[i] = U("Slider", {
            Name = nm .. " channel", Range = { 0, 255 }, Increment = 1, CurrentValue = rgb[i],
            Callback = function(v)
                if syncing then return end
                rgb[i] = v
                ESP.color = C(rgb[1], rgb[2], rgb[3])
                refreshLabel()
            end,
        })
    end
    U("Input", {
        Name = "HEX color", PlaceholderText = "#7B00FF", RemoveTextAfterFocusLost = false,
        Callback = function(t)
            local h = tostring(t or ""):gsub("[#%s]", "")
            if #h == 6 and h:match("^%x+$") then
                setColor(C(tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)))
            else
                notify("✖ Invalid HEX", "Use format like #7B00FF")
            end
        end,
    })

    -- ═══ CAMERA ═══
    U("Section", "Camera")
    local cam0 = workspace.CurrentCamera
    local defaultFOV = cam0 and cam0.FieldOfView or 70
    local fovOn, fovVal = false, 70
    bind(RunService.RenderStepped, function()
        if fovOn then
            local cam = workspace.CurrentCamera
            if cam then cam.FieldOfView = fovVal end
        end
    end)
    U("Toggle", {
        Name = "Custom Field of View", CurrentValue = false,
        Callback = function(v)
            fovOn = v
            if not v and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = defaultFOV end
        end,
    })
    U("Slider", {
        Name = "Field of View", Range = { 40, 120 }, Increment = 1, Suffix = "°", CurrentValue = 70,
        Callback = function(v) fovVal = v end,
    })
    local defMaxZoom = LP.CameraMaxZoomDistance
    U("Toggle", {
        Name = "Unlock Camera Zoom", CurrentValue = false,
        Callback = function(v)
            LP.CameraMaxZoomDistance = v and 2000 or defMaxZoom
            if v then LP.CameraMode = Enum.CameraMode.Classic end
        end,
    })
    local ch = Instance.new("Frame")
    ch.AnchorPoint = Vector2.new(0.5, 0.5)
    ch.Position = UDim2.new(0.5, 0, 0.5, 0)
    ch.Size = UDim2.new(0, 6, 0, 6)
    ch.BackgroundColor3 = C(190, 110, 255)
    ch.Visible = false
    ch.Parent = R.floatGui
    corner(ch, UDim.new(1, 0))
    R.stroke(ch, Color3.new(0, 0, 0), 1, 0.3)
    U("Toggle", { Name = "Crosshair (center dot)", CurrentValue = false, Callback = function(v) ch.Visible = v end })
    U("Slider", {
        Name = "Crosshair Size", Range = { 3, 20 }, Increment = 1, Suffix = " px", CurrentValue = 6,
        Callback = function(v) ch.Size = UDim2.new(0, v, 0, v) end,
    })

    R.cleanups[#R.cleanups + 1] = function()
        pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = defaultFOV end end)
        pcall(function() LP.CameraMaxZoomDistance = defMaxZoom end)
        pcall(function() ch:Destroy() end)
    end
end)

print("[RYZEN] Part 12/18 (Visuals 2/4) done")

]==] },
{ name = "Visuals 3 Lighting", src = [==[
-- RYZEN ULTRA v11 | PART 13/18 (VISUALS 3/4: LIGHTING + SHADER PRESETS)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-12 first!") return end

local Lighting = game:GetService("Lighting")
local C = Color3.fromRGB

R.run("Visuals 3/4 (Lighting)", function()
    local Tab = R.Tabs.Visuals
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local V = R.V
    if not V then error("Run Part 11 first") end

    -- ═══ LIGHTING ═══
    U("Section", "Lighting")
    local old = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    }
    local fb = false
    local function applyFB()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = C(180, 180, 180)
        Lighting.OutdoorAmbient = C(180, 180, 180)
    end
    U("Toggle", {
        Name = "Fullbright", CurrentValue = false,
        Callback = function(s)
            fb = s
            if s then applyFB()
            else
                for _, k in ipairs({ "Brightness", "ClockTime", "GlobalShadows", "Ambient", "OutdoorAmbient" }) do
                    Lighting[k] = old[k]
                end
            end
        end,
    })
    task.spawn(function()
        while R.running and task.wait(1) do if fb and not V.SH.on then applyFB() end end
    end)
    U("Toggle", {
        Name = "No Fog", CurrentValue = false,
        Callback = function(s)
            Lighting.FogEnd = s and 1e6 or old.FogEnd
            local atm = Lighting:FindFirstChildOfClass("Atmosphere")
            if atm and not atm.Name:find("RyzenFX") then atm.Density = s and 0 or 0.3 end
        end,
    })
    U("Slider", {
        Name = "Time of Day", Range = { 0, 24 }, Increment = 0.5, Suffix = " h",
        CurrentValue = math.clamp(math.floor(Lighting.ClockTime), 0, 24),
        Callback = function(v) Lighting.ClockTime = v end,
    })
    local postOld = {}
    U("Toggle", {
        Name = "FPS Boost (effects / shadows off)", CurrentValue = false,
        Callback = function(on)
            if on then
                Lighting.GlobalShadows = false
                pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
                for _, e in ipairs(Lighting:GetChildren()) do
                    if e:IsA("PostEffect") and not e.Name:find("RyzenFX") then postOld[e] = e.Enabled e.Enabled = false end
                end
            else
                Lighting.GlobalShadows = old.GlobalShadows
                for e, en in pairs(postOld) do pcall(function() e.Enabled = en end) end
                postOld = {}
            end
        end,
    })

    -- ═══ SHADER PRESET DATA ═══
    -- bloom{intensity,size,threshold} cc{brightness,contrast,saturation,tint} sun{intensity,spread}
    -- dof{far,focusDist,radius} atm{density,offset,color,decay,glare,haze} light{...} time
    V.LIGHT_KEYS = { "Brightness", "ExposureCompensation", "EnvironmentDiffuseScale",
        "EnvironmentSpecularScale", "Ambient", "OutdoorAmbient", "ColorShift_Top", "ClockTime" }
    V.NEUTRAL = {
        BloomEffect = { Intensity = 0, Size = 24, Threshold = 2 },
        ColorCorrectionEffect = { Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.new(1, 1, 1) },
        SunRaysEffect = { Intensity = 0, Spread = 1 },
        DepthOfFieldEffect = { FarIntensity = 0, NearIntensity = 0, FocusDistance = 50, InFocusRadius = 30 },
    }
    V.PRESETS = {
        ["Cinematic"] = {
            bloom = { 0.45, 28, 0.9 }, cc = { -0.02, 0.18, -0.08, C(255, 244, 230) }, sun = { 0.12, 0.8 },
            dof = { 0.12, 90, 22 }, atm = { 0.32, 0.25, C(199, 205, 225), C(106, 112, 125), 0.2, 1.2 },
            light = { Brightness = 2.4, ExposureCompensation = 0.1, EnvironmentDiffuseScale = 0.8, EnvironmentSpecularScale = 0.8 },
        },
        ["Realistic HD"] = {
            bloom = { 0.25, 24, 1.0 }, cc = { 0, 0.12, 0.12, C(255, 252, 245) }, sun = { 0.2, 0.9 },
            atm = { 0.3, 0.1, C(199, 210, 230), C(160, 170, 185), 0, 0.6 },
            light = { Brightness = 3, ExposureCompensation = 0.15, EnvironmentDiffuseScale = 1, EnvironmentSpecularScale = 1 },
        },
        ["Vibrant"] = {
            bloom = { 0.35, 30, 0.85 }, cc = { 0.02, 0.15, 0.35, C(255, 250, 245) }, sun = { 0.15, 1 },
            atm = { 0.25, 0.1, C(190, 215, 255), C(150, 175, 210), 0, 0.5 },
            light = { Brightness = 2.6, ExposureCompensation = 0.1, EnvironmentDiffuseScale = 1, EnvironmentSpecularScale = 1 },
        },
        ["Golden Sunset"] = {
            time = 17.6,
            bloom = { 0.6, 36, 0.8 }, cc = { 0, 0.15, 0.2, C(255, 214, 170) }, sun = { 0.35, 1 },
            atm = { 0.35, 0.2, C(255, 190, 140), C(255, 120, 80), 0.6, 1.6 },
            light = { Brightness = 2.2, ExposureCompensation = 0.2, ColorShift_Top = C(255, 170, 90),
                EnvironmentDiffuseScale = 0.9, EnvironmentSpecularScale = 0.9 },
        },
        ["Cyber Neon"] = {
            time = 0,
            bloom = { 1, 40, 0.7 }, cc = { -0.04, 0.25, 0.4, C(220, 200, 255) }, sun = { 0, 1 },
            atm = { 0.4, 0, C(90, 60, 160), C(120, 40, 200), 0.3, 1.8 },
            light = { Brightness = 1.5, ExposureCompensation = 0.3, Ambient = C(60, 30, 110),
                OutdoorAmbient = C(80, 40, 140), ColorShift_Top = C(150, 80, 255) },
        },
        ["Dreamy"] = {
            bloom = { 0.8, 48, 0.75 }, cc = { 0.05, -0.05, 0.15, C(255, 230, 245) }, sun = { 0.2, 1 },
            dof = { 0.2, 60, 25 }, atm = { 0.3, 0.2, C(255, 220, 240), C(255, 200, 230), 0.4, 2 },
            light = { Brightness = 2.6, ExposureCompensation = 0.25 },
        },
        ["Noir (B/W)"] = {
            bloom = { 0.2, 24, 1 }, cc = { 0, 0.3, -1, C(230, 230, 255) }, sun = { 0, 1 },
            atm = { 0.25, 0.1, C(160, 160, 170), C(100, 100, 110), 0, 1 },
            light = { Brightness = 2, ExposureCompensation = -0.1 },
        },
        ["Frost"] = {
            bloom = { 0.4, 30, 0.9 }, cc = { 0.02, 0.1, -0.1, C(200, 225, 255) }, sun = { 0.15, 1 },
            atm = { 0.4, 0.2, C(200, 225, 255), C(170, 200, 240), 0.2, 1.4 },
            light = { Brightness = 2.4, ExposureCompensation = 0.15 },
        },
        ["Horror"] = {
            time = 0,
            bloom = { 0.3, 24, 0.9 }, cc = { -0.08, 0.3, -0.3, C(255, 190, 190) }, sun = { 0, 1 },
            atm = { 0.5, 0, C(60, 20, 25), C(80, 20, 20), 0, 2.2 },
            light = { Brightness = 1, ExposureCompensation = -0.3, Ambient = C(25, 10, 10), OutdoorAmbient = C(30, 12, 12) },
        },
    }
    V.ORDER = { "Cinematic", "Realistic HD", "Vibrant", "Golden Sunset", "Cyber Neon",
        "Dreamy", "Noir (B/W)", "Frost", "Horror" }

    R.cleanups[#R.cleanups + 1] = function()
        for k, v in pairs(old) do pcall(function() Lighting[k] = v end) end
    end
end)

print("[RYZEN] Part 13/18 (Visuals 3/4) done")

]==] },
{ name = "Visuals 4 Shaders", src = [==[
-- RYZEN ULTRA v11 | PART 14/18 (VISUALS 4/4: SHADER ENGINE)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-13 first!") return end

local Lighting     = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local firstOpt = R.firstOpt

R.run("Visuals 4/4 (Shaders)", function()
    local Tab = R.Tabs.Visuals
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end
    local V = R.V
    if not (V and V.PRESETS) then error("Run Parts 11-13 first") end
    local SH, PRESETS, NEUTRAL = V.SH, V.PRESETS, V.NEUTRAL

    U("Section", "Shaders")
    local fx, base, atmOrig, atmOwn, gen = {}, nil, nil, nil, 0

    local function tweenTo(inst, props, t)
        pcall(function()
            TweenService:Create(inst, TweenInfo.new(t or 0.9, Enum.EasingStyle.Sine), props):Play()
        end)
    end
    local function getFX(class)
        local e = fx[class]
        if e and e.Parent then return e end
        e = Instance.new(class)
        e.Name = "RyzenFX_" .. class
        for k, v in pairs(NEUTRAL[class]) do pcall(function() e[k] = v end) end
        e.Parent = Lighting
        fx[class] = e
        return e
    end
    local function getAtm()
        if atmOwn and atmOwn.Parent then return atmOwn end
        atmOwn = Instance.new("Atmosphere")
        atmOwn.Name = "RyzenFX_Atmosphere"
        atmOwn.Density, atmOwn.Offset, atmOwn.Glare, atmOwn.Haze = 0, 0, 0, 0
        atmOwn.Parent = Lighting
        return atmOwn
    end
    local function saveBase()
        if base then return end
        base = {}
        for _, k in ipairs(V.LIGHT_KEYS) do pcall(function() base[k] = Lighting[k] end) end
        for _, a in ipairs(Lighting:GetChildren()) do
            if a:IsA("Atmosphere") and not a.Name:find("RyzenFX") then
                atmOrig = { inst = a, Density = a.Density, Offset = a.Offset, Color = a.Color,
                    Decay = a.Decay, Glare = a.Glare, Haze = a.Haze }
                break
            end
        end
    end

    local function applyShader(name)
        local p = PRESETS[name]
        if not p then return end
        saveBase()
        gen = gen + 1
        SH.on, SH.name = true, name
        local k = SH.k
        local kc = math.clamp(k, 0, 1)
        local function mix(n, v) return n + (v - n) * k end

        tweenTo(getFX("BloomEffect"), { Intensity = mix(0, p.bloom[1]), Size = p.bloom[2], Threshold = p.bloom[3] })
        tweenTo(getFX("ColorCorrectionEffect"), {
            Brightness = mix(0, p.cc[1]), Contrast = mix(0, p.cc[2]), Saturation = mix(0, p.cc[3]),
            TintColor = Color3.new(1, 1, 1):Lerp(p.cc[4], kc),
        })
        tweenTo(getFX("SunRaysEffect"), { Intensity = mix(0, p.sun[1]), Spread = p.sun[2] })
        if p.dof then
            tweenTo(getFX("DepthOfFieldEffect"), { FarIntensity = mix(0, p.dof[1]), NearIntensity = 0,
                FocusDistance = p.dof[2], InFocusRadius = p.dof[3] })
        elseif fx.DepthOfFieldEffect then
            tweenTo(fx.DepthOfFieldEffect, { FarIntensity = 0 })
        end

        local a = (atmOrig and atmOrig.inst) or getAtm()
        local A = p.atm
        local function n(key) return (atmOrig and atmOrig[key]) or 0 end
        tweenTo(a, {
            Density = n("Density") + (A[1] - n("Density")) * k,
            Offset = n("Offset") + (A[2] - n("Offset")) * k,
            Color = ((atmOrig and atmOrig.Color) or A[3]):Lerp(A[3], kc),
            Decay = ((atmOrig and atmOrig.Decay) or A[4]):Lerp(A[4], kc),
            Glare = n("Glare") + (A[5] - n("Glare")) * k,
            Haze = n("Haze") + (A[6] - n("Haze")) * k,
        })

        local props = {}
        for key, v in pairs(p.light) do
            local b = base[key]
            if b ~= nil then
                if typeof(v) == "Color3" then props[key] = b:Lerp(v, kc) else props[key] = mix(b, v) end
            end
        end
        if p.time then props.ClockTime = p.time end
        tweenTo(Lighting, props)
    end

    local function clearShader()
        if not SH.on then return end
        SH.on, SH.name = false, "Off"
        gen = gen + 1
        local my = gen
        if base then tweenTo(Lighting, base, 0.6) end
        for class, e in pairs(fx) do tweenTo(e, NEUTRAL[class], 0.6) end
        if atmOrig then
            tweenTo(atmOrig.inst, { Density = atmOrig.Density, Offset = atmOrig.Offset, Color = atmOrig.Color,
                Decay = atmOrig.Decay, Glare = atmOrig.Glare, Haze = atmOrig.Haze }, 0.6)
        elseif atmOwn then
            tweenTo(atmOwn, { Density = 0, Haze = 0, Glare = 0 }, 0.6)
        end
        task.delay(0.8, function()
            if gen ~= my then return end
            for class, e in pairs(fx) do pcall(function() e:Destroy() end) fx[class] = nil end
            if atmOwn then pcall(function() atmOwn:Destroy() end) atmOwn = nil end
            base, atmOrig = nil, nil
        end)
    end

    local function hardClearShader()
        gen = gen + 1
        SH.on = false
        if base then for k, v in pairs(base) do pcall(function() Lighting[k] = v end) end end
        if atmOrig then
            pcall(function()
                local a = atmOrig.inst
                a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze =
                    atmOrig.Density, atmOrig.Offset, atmOrig.Color, atmOrig.Decay, atmOrig.Glare, atmOrig.Haze
            end)
        end
        for _, e in pairs(fx) do pcall(function() e:Destroy() end) end
        fx = {}
        if atmOwn then pcall(function() atmOwn:Destroy() end) atmOwn = nil end
        base, atmOrig = nil, nil
    end

    local opts = { "Off" }
    for _, n in ipairs(V.ORDER) do opts[#opts + 1] = n end
    U("Dropdown", {
        Name = "Shader Preset", Options = opts, CurrentOption = { "Off" }, MultipleOptions = false,
        Callback = function(opt)
            local v = firstOpt(opt)
            if not v then return end
            if v == "Off" then clearShader() else applyShader(v) end
        end,
    })
    U("Slider", {
        Name = "Shader Intensity", Range = { 0, 150 }, Increment = 5, Suffix = " %", CurrentValue = 100,
        Callback = function(v)
            SH.k = v / 100
            if SH.on then applyShader(SH.name) end
        end,
    })
    U("Label", "Tip: Roblox Graphics Quality 7+ gives the best shader look. Heavy presets can lower FPS on weak phones.")

    U("Section", "Shader Fine-Tune (pick a preset first)")
    local function live(fn) if SH.on then pcall(fn) end end
    U("Slider", { Name = "Bloom", Range = { 0, 3 }, Increment = 0.05, CurrentValue = 0.5,
        Callback = function(v) live(function() getFX("BloomEffect").Intensity = v end) end })
    U("Slider", { Name = "Saturation", Range = { -1, 1.5 }, Increment = 0.05, CurrentValue = 0.1,
        Callback = function(v) live(function() getFX("ColorCorrectionEffect").Saturation = v end) end })
    U("Slider", { Name = "Contrast", Range = { -0.5, 1 }, Increment = 0.05, CurrentValue = 0.15,
        Callback = function(v) live(function() getFX("ColorCorrectionEffect").Contrast = v end) end })
    U("Slider", { Name = "Exposure", Range = { -2, 2 }, Increment = 0.1, CurrentValue = 0.1,
        Callback = function(v) live(function() Lighting.ExposureCompensation = v end) end })
    U("Slider", { Name = "Sun Rays", Range = { 0, 1 }, Increment = 0.05, CurrentValue = 0.15,
        Callback = function(v) live(function() getFX("SunRaysEffect").Intensity = v end) end })
    U("Slider", { Name = "Depth of Field", Range = { 0, 1 }, Increment = 0.05, CurrentValue = 0,
        Callback = function(v) live(function() getFX("DepthOfFieldEffect").FarIntensity = v end) end })
    U("Slider", { Name = "Atmosphere Haze", Range = { 0, 10 }, Increment = 0.1, CurrentValue = 1,
        Callback = function(v) live(function() ((atmOrig and atmOrig.inst) or getAtm()).Haze = v end) end })
    U("Button", { Name = "Remove All Shaders", Callback = function() clearShader() end })

    R.cleanups[#R.cleanups + 1] = hardClearShader
end)

print("[RYZEN] Part 14/18 (Visuals 4/4) done")

]==] },
{ name = "Misc", src = [==[
-- RYZEN ULTRA v11 | PART 15/18 (MISC)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-14 first!") return end

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local GuiService      = game:GetService("GuiService")
local Stats           = game:GetService("Stats")
local LP = Players.LocalPlayer
local bind, tw, corner, stroke, notify = R.bind, R.tw, R.corner, R.stroke, R.notify

R.run("Misc", function()
    local Tab = R.Tabs.Misc
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end

    -- HUD: topbar ke neeche, draggable
    local HUD_Y = 62
    local hud = Instance.new("TextLabel")
    hud.AnchorPoint = Vector2.new(0.5, 0)
    hud.Position = UDim2.new(0.5, 0, 0, HUD_Y - 40)
    hud.Size = UDim2.new(0, 230, 0, 24)
    hud.BackgroundColor3 = Color3.fromRGB(20, 10, 34)
    hud.BackgroundTransparency = 1
    hud.Text = ""
    hud.TextColor3 = Color3.fromRGB(230, 210, 255)
    hud.TextTransparency = 1
    hud.Font = Enum.Font.GothamBold
    hud.TextSize = 12
    hud.Visible = false
    hud.ZIndex = 20
    hud.Parent = R.floatGui
    corner(hud, UDim.new(0, 8))
    local hudStroke = stroke(hud, Color3.fromRGB(155, 80, 255), 1, 1)
    R.drag(hud)

    local frames = 0
    bind(RunService.RenderStepped, function() frames = frames + 1 end)
    task.spawn(function()
        while R.running and task.wait(0.5) do
            local fps = frames * 2
            frames = 0
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            hud.Text = string.format("FPS %d   |   PING %dms   |   %s", fps, ping, os.date("%H:%M"))
            hud.TextColor3 = (ping < 90 and Color3.fromRGB(170, 255, 190))
                or (ping < 160 and Color3.fromRGB(255, 240, 150))
                or Color3.fromRGB(255, 150, 150)
        end
    end)

    U("Section", "Info")
    U("Toggle", {
        Name = "Show FPS / Ping HUD (draggable)", CurrentValue = false,
        Callback = function(on)
            if on then
                hud.Visible = true
                tw(hud, 0.4, { Position = UDim2.new(0.5, 0, 0, HUD_Y), BackgroundTransparency = 0.25, TextTransparency = 0 }, Enum.EasingStyle.Back)
                tw(hudStroke, 0.3, { Transparency = 0.4 })
            else
                tw(hud, 0.25, { BackgroundTransparency = 1, TextTransparency = 1 })
                tw(hudStroke, 0.25, { Transparency = 1 })
                task.delay(0.28, function() hud.Visible = false end)
            end
        end,
    })

    U("Section", "Server")
    local function fetchServers()
        local ok, body = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100")
        end)
        if not ok then return nil end
        local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
        return ok2 and data and data.data or nil
    end
    local function hop(mode)
        notify("🔍 Searching", "Looking for a new server...")
        task.spawn(function()
            local list = fetchServers()
            if not list then notify("✖ Failed", "Could not fetch server list") return end
            local c = {}
            for _, s in ipairs(list) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then c[#c + 1] = s end
            end
            if #c == 0 then notify("✖ Failed", "No server found") return end
            local pick = (mode == "small") and c[1] or c[math.random(1, #c)]
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LP) end)
        end)
    end
    U("Button", {
        Name = "Rejoin Server",
        Callback = function()
            pcall(function()
                if #Players:GetPlayers() <= 1 then TeleportService:Teleport(game.PlaceId, LP)
                else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end
            end)
        end,
    })
    U("Button", { Name = "Server Hop (random)", Callback = function() hop("random") end })
    U("Button", { Name = "Small Server Hop (fewest players)", Callback = function() hop("small") end })

    local jobInput = ""
    U("Input", {
        Name = "Join by JobId", PlaceholderText = "Paste JobId...", RemoveTextAfterFocusLost = false,
        Callback = function(t) jobInput = t end,
    })
    U("Button", {
        Name = "Join this JobId",
        Callback = function()
            if jobInput ~= "" then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobInput, LP) end)
            else
                notify("✖ Error", "Enter a JobId first")
            end
        end,
    })

    local autoRejoin = false
    U("Toggle", {
        Name = "Auto Rejoin (on kick / disconnect)", CurrentValue = false,
        Callback = function(v) autoRejoin = v end,
    })
    bind(GuiService.ErrorMessageChanged, function()
        if autoRejoin then
            task.wait(1.5)
            pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
        end
    end)

    U("Section", "Copy")
    local function copy(txt, label)
        if setclipboard then setclipboard(tostring(txt)) notify("✔ Copied", label) end
    end
    U("Button", { Name = "Copy Server JobId", Callback = function() copy(game.JobId, "JobId copied") end })
    U("Button", { Name = "Copy Game ID (PlaceId)", Callback = function() copy(game.PlaceId, tostring(game.PlaceId)) end })
    U("Button", { Name = "Copy My UserId", Callback = function() copy(LP.UserId, tostring(LP.UserId)) end })

    bind(LP.Idled, function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end)
    U("Label", "Anti-AFK is always ON ✔")

    R.cleanups[#R.cleanups + 1] = function() pcall(function() hud:Destroy() end) end
end)

print("[RYZEN] Part 15/18 (Misc) done")

]==] },
{ name = "Settings+About", src = [==[
-- RYZEN ULTRA v11 | PART 16/18 (SETTINGS + ABOUT)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-15 first!") return end

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService        = game:GetService("HttpService")
local notify = R.notify

-- ═══ SAVED SETTINGS (writefile/readfile ho to hi kaam karta hai, warna chupchap skip) ═══
local FILE = "RYZEN_settings.json"
local cfg = {}
pcall(function()
    if isfile and readfile and isfile(FILE) then
        local d = HttpService:JSONDecode(readfile(FILE))
        if type(d) == "table" then cfg = d end
    end
end)
R.cfg = cfg
local pendingSave = false
function R.saveCfg()
    if pendingSave or not writefile then return end
    pendingSave = true
    task.delay(1, function()
        pendingSave = false
        pcall(function() writefile(FILE, HttpService:JSONEncode(cfg)) end)
    end)
end
if type(cfg.menu) == "number" then R.scale = math.clamp(cfg.menu, 40, 110) / 100 end
if type(cfg.notif) == "boolean" then R.notifOn = cfg.notif end

-- ═══════════ SETTINGS ═══════════
R.run("Settings", function()
    local Tab = R.Tabs.Interface
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end

    U("Section", "Menu")
    U("Slider", {
        Name = "Menu Size", Range = { 40, 110 }, Increment = 5, Suffix = " %",
        CurrentValue = math.clamp(math.floor(R.scale * 100), 40, 110),
        Callback = function(v)
            R.scale = v / 100
            cfg.menu = v
            R.saveCfg()
            if R.uiScale then R.uiScale.Scale = R.scale end
        end,
    })
    U("Toggle", { Name = "Notifications", CurrentValue = R.notifOn, Callback = function(v)
        R.notifOn = v
        cfg.notif = v
        R.saveCfg()
    end })
    U("Dropdown", {
        Name = "Menu Theme",
        Options = { "RYZEN Purple", "Ocean", "Amethyst", "DarkBlue", "Green", "Bloom", "Serenity", "AmberGlow", "Light" },
        CurrentOption = { "RYZEN Purple" },
        MultipleOptions = false,
        Callback = function(opt)
            local v = R.firstOpt(opt)
            if not v then return end
            local ok = pcall(function()
                if v == "RYZEN Purple" then R.Window.ModifyTheme(R.Theme) else R.Window.ModifyTheme(v) end
            end)
            if ok then cfg.theme = v R.saveCfg() else notify("✖ Theme", "This Rayfield version has no theme switch") end
        end,
    })

    U("Section", "R Button")
    U("Slider", {
        Name = "R Button Size", Range = { 36, 80 }, Increment = 2, Suffix = " px",
        CurrentValue = math.clamp(tonumber(cfg.btn) or 52, 36, 80),
        Callback = function(v)
            cfg.btn = v
            R.saveCfg()
            if R.dock then R.dock.setSize(v) end
        end,
    })
    U("Toggle", {
        Name = "Always show R Button", CurrentValue = cfg.always == true,
        Callback = function(v)
            cfg.always = v
            R.saveCfg()
            if R.dock then R.dock.setAlways(v) end
        end,
    })
    U("Toggle", {
        Name = "Hide Rayfield's 'Show' chip", CurrentValue = true,
        Callback = function(v) if R.dock then R.dock.setHideChip(v) end end,
    })
    U("Button", {
        Name = "Reset R Button position",
        Callback = function() if R.dock then R.dock.reset() end end,
    })
    U("Label", "Drag the R button - it snaps to the nearest edge when released.")

    U("Section", "Watermark")
    local wm = Instance.new("TextLabel")
    wm.AnchorPoint = Vector2.new(0, 1)
    wm.Position = UDim2.new(0, 10, 1, -8)
    wm.Size = UDim2.new(0, 280, 0, 18)
    wm.BackgroundTransparency = 1
    wm.Text = "★ RYZEN ULTRA  •  coded by RYZEN"
    wm.TextColor3 = Color3.fromRGB(200, 150, 255)
    wm.TextTransparency = 0.25
    wm.TextXAlignment = Enum.TextXAlignment.Left
    wm.Font = Enum.Font.GothamBold
    wm.TextSize = 11
    wm.Visible = false
    wm.Parent = R.floatGui
    U("Toggle", { Name = "Show Watermark", CurrentValue = false, Callback = function(v) wm.Visible = v end })

    U("Section", "Diagnostics")
    local statusLbl = U("Label", "Status: ...")
    local function refreshStatus()
        if statusLbl then
            pcall(function()
                statusLbl:Set("Executor: " .. tostring(R.exec) .. "  |  Modules: " .. R.okCount .. "/" .. R.total
                    .. "  |  Errors: " .. #R.errors)
            end)
        end
    end
    refreshStatus()
    U("Button", { Name = "Refresh Status", Callback = refreshStatus })
    U("Button", {
        Name = "Show Errors",
        Callback = function()
            if #R.errors == 0 then notify("✔ All good", "No errors recorded")
            else
                for i, e in ipairs(R.errors) do
                    if i > 6 then break end
                    notify("⚠ " .. e.name, tostring(e.err):sub(1, 150), 5)
                end
            end
        end,
    })
    U("Button", {
        Name = "Copy Error Log (send it to the developer)",
        Callback = function()
            local lines = { "RYZEN " .. R.version .. " | executor: " .. tostring(R.exec)
                .. " | modules " .. R.okCount .. "/" .. R.total .. " | place " .. tostring(game.PlaceId) }
            if #R.errors == 0 then lines[#lines + 1] = "no errors recorded" end
            for _, e in ipairs(R.errors) do
                lines[#lines + 1] = "[" .. tostring(e.name) .. "] " .. tostring(e.err)
            end
            local text = table.concat(lines, "\n")
            if setclipboard then
                setclipboard(text)
                notify("✔ Copied", "Error log copied - paste it in chat")
            else
                notify("✖ Not supported", "Your executor has no setclipboard")
            end
        end,
    })

    U("Section", "Danger Zone")
    U("Button", { Name = "Unload Script (remove everything)", Callback = function() R.unload() end })
end)

-- ═══════════ ABOUT ═══════════
R.run("About", function()
    local Tab = R.Tabs.About
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end

    U("Section", "RYZEN ULTRA")
    U("Paragraph", {
        Title = "★ RYZEN ULTRA " .. R.version .. " ★",
        Content = "Premium multi-tool: teleport, movement, ESP, cinematic shaders, fun effects and server tools in one clean menu. Optimized for mobile (Delta).",
    })

    -- ═══ 7yd7 EMOTES ═══
    U("Section", "Extra Scripts")
    U("Paragraph", {
        Title = "7yd7 | Emote Script + UGC",
        Content = "Universal emote script that adds 10,000+ UGC emotes to your Roblox emote menu. Made by 7yd7.",
    })
    local emoteLoaded, emoteBusy = false, false
    U("Button", {
        Name = "Load 7yd7 Emote Script",
        Callback = function()
            if emoteLoaded then notify("ℹ Emotes", "7yd7 Emote Script is already loaded") return end
            if emoteBusy then return end
            emoteBusy = true
            notify("⏳ Emotes", "Loading 7yd7 Emote Script...")
            task.spawn(function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
                end)
                emoteBusy = false
                if ok then
                    emoteLoaded = true
                    notify("✔ Emotes", "7yd7 Emote Script loaded", 4)
                else
                    R.errors[#R.errors + 1] = { name = "7yd7 Emotes", err = tostring(err) }
                    notify("✖ Emotes failed", tostring(err):sub(1, 120), 5)
                end
            end)
        end,
    })
    -- ═══ RYZENXZ3N CHAT ═══
    U("Paragraph", {
        Title = "Ryzenxz3n | Gang & Chat System",
        Content = "Gang chat, daily gang points, leaderboard, stickers aur owner/admin panel. Made by Ryzenxz3n.",
    })
    local chatLoaded, chatBusy = false, false
    U("Button", {
        Name = "Load Ryzenxz3n Chat Script",
        Callback = function()
            if chatLoaded then notify("ℹ Chat", "Ryzenxz3n Chat Script is already loaded") return end
            if chatBusy then return end
            chatBusy = true
            notify("⏳ Chat", "Loading Ryzenxz3n Chat Script...")
            task.spawn(function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/RyzenxZen/Ryzenui.github.io/refs/heads/main/Ryzenxz3n_Chat_Script_v4.1_FINAL.lua"))()
                end)
                chatBusy = false
                if ok then
                    chatLoaded = true
                    notify("✔ Chat", "Ryzenxz3n Chat Script loaded", 4)
                else
                    R.errors[#R.errors + 1] = { name = "Ryzenxz3n Chat", err = tostring(err) }
                    notify("✖ Chat failed", tostring(err):sub(1, 120), 5)
                end
            end)
        end,
    })

    U("Section", "Owner")
    U("Paragraph", {
        Title = "★ Coded by RYZEN ★",
        Content = "Developer & Owner: RYZEN",
    })

    U("Section", "Features")
    U("Paragraph", {
        Title = "What's inside",
        Content = "• Teleport: player select, nearest/random, follow, orbit, spectate, waypoints, coordinates, click TP, undo TP\n"
            .. "• Movement: fly (UP/DN buttons), speed, jump, gravity, noclip, inf jump, bhop, air walk, anti void/fling\n"
            .. "• Visuals: ESP (RGB/HEX color, rainbow, distance, HP, team check), FOV, zoom unlock, crosshair, fullbright, FPS boost, 9 cinematic shader presets\n"
            .. "• Fun: big head, rainbow body/trail, scale, emotes, auto dance, sit/lie/faint, jitter, earthquake + drunk camera\n"
            .. "• Misc: FPS/ping HUD, server hop, rejoin, JobId join, auto rejoin, anti-AFK\n"
            .. "• Extras: 7yd7 Emote Script (10,000+ UGC emotes)",
    })

    U("Section", "Session")
    local upLbl = U("Label", "Session: 00:00:00")
    local gameLbl = U("Label", "Game: ...")
    local plrLbl = U("Label", "Players: ...")
    task.spawn(function()
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if gameLbl then
            pcall(function() gameLbl:Set("Game: " .. ((ok and info and info.Name) or "Unknown") .. "  (" .. game.PlaceId .. ")") end)
        end
    end)
    task.spawn(function()
        while R.running and task.wait(1) do
            local t = math.floor(os.clock() - R.startTime)
            if upLbl then
                pcall(function()
                    upLbl:Set(string.format("Session: %02d:%02d:%02d", t // 3600, (t // 60) % 60, t % 60))
                end)
            end
            if plrLbl then
                pcall(function() plrLbl:Set("Players: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers) end)
            end
        end
    end)

    U("Section", "Credits")
    U("Paragraph", {
        Title = "Credits",
        Content = "Script: RYZEN\nUI Library: Rayfield by Sirius\nEmote Script: 7yd7\nTesting: Delta Mobile",
    })
end)

print("[RYZEN] Part 16/18 (Settings + About) done")

]==] },
{ name = "Fun", src = [==[
-- RYZEN ULTRA v11 | PART 17/18 (FUN TAB - effects on YOU only)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-16 first!") return end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local bind, notify, firstOpt = R.bind, R.notify, R.firstOpt
local getChar, getHum, getHRP = R.getChar, R.getHum, R.getHRP

R.total = R.total + 1
R.run("Fun", function()
    local ok, Tab = pcall(function() return R.Window:CreateTab("Fun", "smile") end)
    if not ok or not Tab then ok, Tab = pcall(function() return R.Window:CreateTab("Fun", 4483362458) end) end
    if not ok or not Tab then error("Fun tab could not be created") end
    local function U(kind, cfg) return R.ui(Tab, kind, cfg) end

    U("Section", "Info")
    U("Label", "Fun tab = effects on YOUR character / screen only. Nothing here targets other players.")

    -- ═══ BODY ═══
    U("Section", "Body (visible to you)")
    local headOrig, headOn, headSize = {}, false, 2
    local function applyHead()
        local c = getChar()
        local head = c and c:FindFirstChild("Head")
        if not head then return end
        if not headOrig[head] then headOrig[head] = head.Size end
        local o = headOrig[head]
        head.Size = headOn and (o * headSize) or o
    end
    U("Toggle", { Name = "Big Head", CurrentValue = false, Callback = function(v) headOn = v applyHead() end })
    U("Slider", { Name = "Head Size", Range = { 1, 6 }, Increment = 0.25, Suffix = "x", CurrentValue = 2,
        Callback = function(v) headSize = v if headOn then applyHead() end end })

    local origScale = {}
    local SCALE_NAMES = { "BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale" }
    U("Slider", { Name = "Character Scale (R15)", Range = { 0.5, 3 }, Increment = 0.1, Suffix = "x", CurrentValue = 1,
        Callback = function(v)
            local h = getHum()
            if not h then return end
            for _, n in ipairs(SCALE_NAMES) do
                local nv = h:FindFirstChild(n)
                if nv and nv:IsA("NumberValue") then
                    if not origScale[nv] then origScale[nv] = nv.Value end
                    nv.Value = origScale[nv] * v
                end
            end
        end })

    local rainbowOn, colorBackup = false, {}
    U("Toggle", { Name = "Rainbow Body", CurrentValue = false,
        Callback = function(v)
            rainbowOn = v
            if not v then
                for part, col in pairs(colorBackup) do pcall(function() part.Color = col end) end
                colorBackup = {}
            end
        end })
    task.spawn(function()
        while R.running and task.wait(0.1) do
            if rainbowOn then
                local c = getChar()
                if c then
                    local col = Color3.fromHSV((os.clock() * 0.3) % 1, 0.85, 1)
                    for _, p in ipairs(c:GetChildren()) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            if not colorBackup[p] then colorBackup[p] = p.Color end
                            p.Color = col
                        end
                    end
                end
            end
        end
    end)

    local trail, att0, att1
    local function removeTrail()
        for _, o in ipairs({ trail, att0, att1 }) do if o then pcall(function() o:Destroy() end) end end
        trail, att0, att1 = nil, nil, nil
    end
    local function makeTrail()
        removeTrail()
        local hrp = getHRP()
        if not hrp then return end
        att0 = Instance.new("Attachment")
        att0.Position = Vector3.new(0, 1.2, 0)
        att0.Parent = hrp
        att1 = Instance.new("Attachment")
        att1.Position = Vector3.new(0, -1.2, 0)
        att1.Parent = hrp
        trail = Instance.new("Trail")
        trail.Attachment0, trail.Attachment1 = att0, att1
        trail.Lifetime = 0.7
        trail.LightEmission = 1
        trail.Transparency = NumberSequence.new(0, 1)
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 90, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 255)),
        })
        trail.Parent = hrp
    end
    U("Toggle", { Name = "Rainbow Trail", CurrentValue = false,
        Callback = function(v) if v then makeTrail() else removeTrail() end end })

    -- ═══ ACTIONS ═══
    U("Section", "Actions")
    local emote = "dance"
    U("Dropdown", { Name = "Emote", Options = { "dance", "dance2", "dance3", "laugh", "cheer", "wave", "point" },
        CurrentOption = { "dance" }, MultipleOptions = false,
        Callback = function(opt) emote = firstOpt(opt) or emote end })
    U("Button", { Name = "Play Emote",
        Callback = function()
            local h = getHum()
            if not h then return end
            local ok2 = pcall(function() h:PlayEmote(emote) end)
            if not ok2 then notify("✖ Emote", "This game does not support emotes") end
        end })
    local autoDance = false
    U("Toggle", { Name = "Auto Dance (loop)", CurrentValue = false, Callback = function(v) autoDance = v end })
    task.spawn(function()
        while R.running and task.wait(5) do
            if autoDance then
                local h = getHum()
                if h then pcall(function() h:PlayEmote(emote) end) end
            end
        end
    end)
    U("Button", { Name = "Stop Animations",
        Callback = function()
            local h = getHum()
            local an = h and h:FindFirstChildOfClass("Animator")
            if an then for _, t in ipairs(an:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
        end })
    U("Button", { Name = "Sit Down", Callback = function() local h = getHum() if h then h.Sit = true end end })

    U("Toggle", { Name = "Lie Down", CurrentValue = false,
        Callback = function(v)
            local h, hrp = getHum(), getHRP()
            if not (h and hrp) then return end
            if v then
                h.PlatformStand = true
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
            else
                local _, yaw = hrp.CFrame:ToOrientation()
                hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, yaw, 0)
                h.PlatformStand = false
                h:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end })
    U("Button", { Name = "Faint (fall over)",
        Callback = function()
            local h = getHum()
            if not h then return end
            h:ChangeState(Enum.HumanoidStateType.Ragdoll)
            task.delay(2.2, function()
                local hh = getHum()
                if hh then hh:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end)
        end })
    local jitter, jAmp = false, 0.15
    U("Toggle", { Name = "Jitter / Glitch Shake", CurrentValue = false, Callback = function(v) jitter = v end })
    bind(RunService.Heartbeat, function()
        if jitter then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.new((math.random() - 0.5) * jAmp, 0, (math.random() - 0.5) * jAmp)
            end
        end
    end)

    -- ═══ SCREEN ═══
    U("Section", "Screen (only you see it)")
    local quake, drunk, qAmp = false, false, 0.5
    U("Toggle", { Name = "Earthquake Camera", CurrentValue = false, Callback = function(v) quake = v end })
    U("Slider", { Name = "Earthquake Strength", Range = { 1, 10 }, Increment = 1, CurrentValue = 5,
        Callback = function(v) qAmp = v / 10 end })
    U("Toggle", { Name = "Drunk Camera (slow sway)", CurrentValue = false, Callback = function(v) drunk = v end })
    pcall(function() RunService:UnbindFromRenderStep("RyzenFunCam") end)
    RunService:BindToRenderStep("RyzenFunCam", Enum.RenderPriority.Camera.Value + 1, function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        if quake then
            local a = qAmp * 0.02
            cam.CFrame = cam.CFrame * CFrame.Angles((math.random() - 0.5) * a, (math.random() - 0.5) * a, (math.random() - 0.5) * a)
        end
        if drunk then
            local t = os.clock()
            cam.CFrame = cam.CFrame * CFrame.Angles(math.sin(t * 0.9) * 0.03, math.sin(t * 0.6) * 0.04, math.sin(t * 0.8) * 0.07)
        end
    end)

    bind(LP.CharacterAdded, function()
        headOrig, origScale = {}, {}
        if trail then task.wait(1) makeTrail() end
    end)

    R.cleanups[#R.cleanups + 1] = function()
        pcall(function() RunService:UnbindFromRenderStep("RyzenFunCam") end)
        removeTrail()
        for part, col in pairs(colorBackup) do pcall(function() part.Color = col end) end
        for head, s in pairs(headOrig) do pcall(function() head.Size = s end) end
        for nv, v in pairs(origScale) do pcall(function() nv.Value = v end) end
        local h = getHum()
        if h then h.PlatformStand = false end
    end
end)

print("[RYZEN] Part 17/18 (Fun) done")

]==] },
{ name = "R Button", src = [==[
-- RYZEN ULTRA v11 | PART 18/18 (R BUTTON DOCK + FINISH)
local genv = (getgenv and getgenv()) or _G
local R = genv.RYZEN
if not R or not R.run then warn("[RYZEN] Run Parts 1-17 first!") return end

local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local bind, tw, corner, stroke = R.bind, R.tw, R.corner, R.stroke
local floatGui = R.floatGui

R.run("R Button", function()
    local saved = R.cfg or {}
    local btnSize, always, hideChip = math.clamp(tonumber(saved.btn) or 52, 36, 80), saved.always == true, true

    local rBtn = Instance.new("TextButton")
    rBtn.Name = "RButton"
    rBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    rBtn.Size = UDim2.new(0, 0, 0, 0)
    rBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    rBtn.BorderSizePixel = 0
    rBtn.Text = "R"
    rBtn.TextColor3 = Color3.fromRGB(240, 190, 255)
    rBtn.Font = Enum.Font.GothamBlack
    rBtn.TextSize = 24
    rBtn.AutoButtonColor = false
    rBtn.Active = true
    rBtn.Visible = false
    rBtn.ZIndex = 5
    rBtn.Parent = floatGui
    corner(rBtn, UDim.new(1, 0))

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(135, 75, 195)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 25, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 58, 175)),
    })
    grad.Parent = rBtn
    TweenService:Create(grad, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Rotation = 360 }):Play()
    local st = stroke(rBtn, Color3.fromRGB(190, 110, 255), 2, 0.2)
    TweenService:Create(st, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Thickness = 4, Transparency = 0.6 }):Play()

    -- ═══ POSITION + EDGE SNAP ═══
    local function screen()
        local s = floatGui.AbsoluteSize
        if s.X < 10 then s = workspace.CurrentCamera.ViewportSize end
        return s
    end
    local px, py = 0, 0
    local function place(x, y, animate)
        local s = screen()
        x = math.clamp(x, btnSize / 2 + 6, s.X - btnSize / 2 - 6)
        y = math.clamp(y, 80 + btnSize / 2, s.Y - btnSize / 2 - 12)
        px, py = x, y
        local pos = UDim2.new(0, x, 0, y)
        if animate then tw(rBtn, 0.35, { Position = pos }, Enum.EasingStyle.Back) else rBtn.Position = pos end
    end
    local function snap()
        local s = screen()
        local x = (px < s.X / 2) and (btnSize / 2 + 6) or (s.X - btnSize / 2 - 6)
        place(x, py, true)
    end
    local function reset() place(btnSize / 2 + 6, screen().Y * 0.45, false) end
    reset()

    local shown = false
    local function showR(state)
        if state == shown then return end
        shown = state
        if state then
            rBtn.Visible = true
            tw(rBtn, 0.4, { Size = UDim2.new(0, btnSize, 0, btnSize) }, Enum.EasingStyle.Back)
        else
            tw(rBtn, 0.2, { Size = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.delay(0.22, function() if not shown then rBtn.Visible = false end end)
        end
    end

    -- ═══ DRAG + TAP (tap -> debounced toggle) ═══
    local dragging, dragStart, startX, startY, moved, dragInput = false, nil, 0, 0, false, nil
    bind(rBtn.InputBegan, function(i)
        if R.isTap(i) then
            dragging, moved, dragInput = true, false, i
            dragStart, startX, startY = i.Position, px, py
            tw(rBtn, 0.1, { Size = UDim2.new(0, btnSize - 6, 0, btnSize - 6) })
        end
    end)
    bind(UIS.InputChanged, function(i)
        if not dragging then return end
        if i == dragInput or i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            if d.Magnitude > 8 then moved = true end
            if moved then place(startX + d.X, startY + d.Y, false) end
        end
    end)
    bind(UIS.InputEnded, function(i)
        if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            tw(rBtn, 0.15, { Size = UDim2.new(0, btnSize, 0, btnSize) }, Enum.EasingStyle.Back)
            if moved then snap() else R.toggleMenu() end
        end
    end)

    -- ═══ HIDE RAYFIELD'S OWN "SHOW RAYFIELD" CHIP ═══
    local chip, lastScan = nil, 0
    local function hideRayfieldChip()
        if chip and chip.Parent then
            chip.Visible = false
            return
        end
        chip = nil
        if os.clock() - lastScan < 2 then return end
        lastScan = os.clock()
        local g = R.findRayfieldGui()
        if not g then return end
        pcall(function()
            for _, d in ipairs(g:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("TextLabel")) and d.Text == "Show Rayfield" then
                    local t, p = d, d.Parent
                    if p and p:IsA("GuiObject") and p.Name ~= "Main" and not p:FindFirstChild("Topbar") then t = p end
                    chip = t
                    break
                end
            end
        end)
    end

    -- ═══ SYNC LOOP ═══
    task.spawn(function()
        while R.running and task.wait(0.25) do
            local vis = R.menuVisible()
            showR((not vis) or always)
            local target = (vis and always) and 0.55 or 0
            if math.abs(rBtn.BackgroundTransparency - target) > 0.01 then
                tw(rBtn, 0.25, { BackgroundTransparency = target, TextTransparency = target })
            end
            if hideChip and not vis then hideRayfieldChip() end
        end
    end)

    -- PC: RightShift toggles the menu
    bind(UIS.InputBegan, function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightShift then R.toggleMenu() end
    end)

    -- API used by the Settings tab
    R.dock = {
        setSize = function(n)
            btnSize = n
            if shown then tw(rBtn, 0.2, { Size = UDim2.new(0, n, 0, n) }) end
            place(px, py, false)
        end,
        setAlways = function(v) always = v end,
        setHideChip = function(v) hideChip = v end,
        reset = reset,
    }
end)

-- saved theme restore
if R.cfg and type(R.cfg.theme) == "string" and R.cfg.theme ~= "RYZEN Purple" then
    pcall(function() R.Window.ModifyTheme(R.cfg.theme) end)
end

R.finish()
print("[RYZEN] Part 18/18 (R Button) done. Everything ready!")

]==] },
}
local genv = (getgenv and getgenv()) or _G
for i, p in ipairs(PARTS) do
    local fn, cerr = loadstring(p.src, "=RYZEN_part" .. i)
    local failed = false
    if not fn then
        failed = true
        warn("[RYZEN] SYNTAX ERROR in Part " .. i .. " (" .. p.name .. "): " .. tostring(cerr))
        toast("RYZEN: syntax error Part " .. i .. " (" .. p.name .. ")", cerr)
    else
        local ok, e = xpcall(fn, function(m) return tostring(m) .. "\n" .. debug.traceback() end)
        if not ok then
            failed = true
            warn("[RYZEN] RUNTIME ERROR in Part " .. i .. " (" .. p.name .. "): " .. tostring(e))
            toast("RYZEN: error in Part " .. i .. " (" .. p.name .. ")", e)
        end
    end
    if failed and i <= 5 and i ~= 2 and i ~= 3 then break end
    task.wait(0.03)
end
local R = genv.RYZEN
if R and R.finish and not R.finished then pcall(R.finish) end
