local _L1iIl1 = string.char
local _i1L1li = string.byte
local _lIL1Il = table.insert
local _IlI1lL = table.concat
local _1iLIi1 = table.sort
local _Li1l1I = math.floor
local _l1ILiI = math.random
local _IiL1l1 = tonumber
local _1lIL1i = tostring
local _iIlL1I = type
local _L1l1Ii = pairs
local _lI1iLl = ipairs
local _1LiIl1 = pcall
local _Il1iL1 = os.time
local _iL1I1l = os.date

local function _xL1(a, b)
    local r = 0
    for i = 0, 7 do
        local x = _Li1l1I(a / 2^i) % 2
        local y = _Li1l1I(b / 2^i) % 2
        if x ~= y then r = r + 2^i end
    end
    return r
end

local function _dS(t, k)
    k = k or 0x2F
    local r = {}
    for i = 1, #t do
        local s = (k + (i - 1) * 7) % 256
        local c = (bit32 and bit32.bxor or _xL1)(t[i], s)
        _lIL1Il(r, _L1iIl1(c))
    end
    return _IlI1lL(r)
end

local _S = {
    ts = {123,83,81,33,59,61,43,20,52,11,7,10,234,233,244},
    hs = {103,66,73,52,24,55,43,22,14,13,16},
    ps = {127,90,92,61,46,32,42},
    rs = {125,83,77,40,34,49,56,20,2,10,38,8,236,248,240,255,250},
    pk = {127,87,94,47,42,53,60,19},
    dt = {107,87,73,37,56},
    sh = {124,94,92,54,46,54},
    ut = {122,66,84,40,56},
    sy = {124,79,83,39,35,32,54,14,14,20,16,14},
    an = {110,88,84,41,42,62,42},
    ra = {125,87,79,45,63,59,60,19},
    nu = {97,67,80,38,46,32,12,20,14,2,6},
    pl = {127,90,82,48,56},
    al = {110,88,84,41,42,62,21,9,20,26},
    ow = {96,65,83,33,57},
    ct = {108,89,83,48,46,60,45,77,51,23,5,25},
    aj = {78,70,77,40,34,49,56,20,14,1,27,83,233,249,254,246},
    po = {127,121,110,16},
    xr = {87,27,79,37,63,55,53,9,10,7,1,81,241,239,252,249,246,200,196,218,220},
    XR = {119,27,111,37,63,55,21,9,10,7,1,81,209,239,252,249,246,200,196,218,220},
    xra = {87,27,79,37,63,55,53,9,10,7,1,81,241,239,226,253,235,139,204,210,207,167,187},
    XRA = {119,27,111,37,63,55,21,9,10,7,1,81,209,239,226,253,235,139,236,210,207,167,187},
}

local _W = {
    w1 = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,10,10,121,119,118,96,106,82,82,69,78,73,190,190,162,180,231,227,239,218,209,182,137,140,152,168,132,160,152,133,108,58,107,123,90,30,98,115,15,13,51,34,97,37,8,84,70,36,196,209,234,244,193,223,199,251,213,137,139,182,135,156,149,160,135,205,81,67,105,32,76,26,102,88,87,93,52,53,24,46,56,57,34,37},
    w2 = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,10,10,121,119,124,103,100,81,95,68,75,72,177,181,162,180,209,235,214,130,247,154,141,178,239,182,178,184,219,173,101,104,74,111,68,93,99,100,100,0,6,57,33,12,63,29,3,48,242,249,217,209,212,231,158,225,227,145,163,254,146,153,131,184,203,129,98,99,35,65,41,82,101,71,12,108,43,63,30,12,44,17,68,5},
    w3 = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,10,10,120,126,125,98,100,84,82,64,78,72,176,187,160,180,143,222,216,142,211,175,180,180,227,147,141,181,180,186,125,74,96,118,84,80,3,7,119,34,34,14,42,22,84,36,26,15,235,217,194,193,166,239,217,203,242,167,190,131,148,187,146,134,223,145,103,118,116,109,47,115,114,112,122,110,34,31,0,33,43,45,34,18},
    w4 = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,10,10,120,114,119,103,110,83,90,69,72,70,180,189,165,180,240,241,234,243,218,157,253,191,227,177,173,221,130,173,85,93,36,79,108,19,84,115,117,8,122,0,111,0,60,50,70,67,246,217,244,166,196,223,253,250,252,147,140,140,172,173,140,219,154,131,45,95,95,81,113,107,72,96,113,83,4,1,33,118,38,35,56,65},
    w5 = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,10,10,121,115,120,108,100,84,83,69,65,73,177,184,160,180,201,243,209,143,220,141,248,130,137,162,159,183,156,175,115,120,93,120,74,105,123,67,116,50,123,38,55,44,41,47,7,17,177,176,245,237,253,210,129,134,143,179,175,165,133,240,187,154,184,173,101,50,124,67,81,119,99,107,112,104,62,12,36,31,86,59,67,90},
    wf = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,3,1,112,126,124,100,105,90,88,65,74,74,180,185,161,180,193,222,246,143,240,142,148,145,234,212,175,215,154,135,78,127,35,118,77,69,73,67,104,4,46,16,106,12,30,23,16,42,228,205,223,222,250,136,149,224,229,136,175,137,225,190,214,221,163,142,103,101,118,71,120,81,123,80,85,72,49,52,97,13,56,27,1,60},
    wh = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,249,239,214,131,215,212,175,230,177,167,183,202,155,150,152,105,103,96,125,110,11,26,6,13,121,117,124,109,108,87,88,72,65,79,191,188,161,173,148,156,159,211,223,172,186,155,226,149,197,166,169,175,125,38,118,45,113,85,104,123,93,113,37,16,51,103,48,2,77,61,213,226,192,175,179,213,214,192,219,150,190,165,183,175,187,186,187,142,100,73,106,77,108,78,64,107,110,12,40,27,63,10,23,17,33,30,76,178,221},
    ws = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,182,252,201,192,155,218,178,160,255,160,187,135,132,156,149,106,123,32,39,41,16,18,0,11,117,117,126,98,105,85,91,68,64,75,177,186,166,180,148,157,253,213,142,181,137,231,189,166,128,157,174,176,64,91,120,41,100,113,98,86,73,51,4,39,11,20,45,2,4,73,201,238,221,214,249,246,235,203,243,128,139,251,189,234,178,216,194,143,111,101,74,125,37,123,114,0,118,103,41,35,2,33,26,32,21,53},
    w2s = {71,66,73,52,56,104,118,79,3,7,6,31,236,248,245,249,239,214,131,215,212,175,230,177,167,183,202,155,150,152,105,103,96,125,110,11,26,6,13,121,117,125,97,100,81,92,73,72,76,176,186,161,169,147,144,159,129,202,232,161,186,168,153,209,223,189,172,116,91,36,78,78,99,118,94,117,110,125,105,46,54,19,23,55,28,202,229,229,165,242,233,129,209,201,236,141,165,140,233,215,135,159,183,66,115,109,32,111,77,114,8,112,122,42,47,19,18,23,28,56,33,56,255,254},
    av = {71,66,73,52,56,104,118,79,4,10,27,82,231,227,226,251,240,212,201,213,203,178,231,179,184,179,202,141,135,142,96,107,103,123,120,74,95,65,22,113,115,122,108,109,86,82,64,78,73,180,181,173,171,151,144,137,143,140,234,253,231,238,216,218,220,197,200,53,59,39,33,25,23,30,0,5,116,127,126,42,58,7,29,17,9,172,249,254,240},
    ap = {71,66,73,52,56,104,118,79,21,11,20,12,230,248,226,249,245,136,192,213,213,183,186,254,164,174,132,143,150,213,96,120,102,57,121,69,95,83},
    rp = {71,66,73,52,56,104,118,79,0,15,24,25,240,164,227,247,253,202,194,204,149,161,166,189,248,168,212,195,148,155,108,109,124,57},
}

local _rK = _l1ILiI(10000, 99999)
local _gK = "_" .. _1lIL1i(_rK)

if _G[_gK] then return end
_G[_gK] = true

local _tS = game:GetService(_dS(_S.ts))
local _hS = game:GetService(_dS(_S.hs))
local _pS = game:GetService(_dS(_S.ps))
local _rS = game:GetService(_dS(_S.rs))

local _pI = 109983668079237
local _sD = 3
local _aR = true
local _rC = 3
local _cE = 0

local _wH = {
    {t = 1000000000, u = _dS(_W.w1), n = "1B+"},
    {t = 300000000, u = _dS(_W.w2), n = "300M+"},
    {t = 100000000, u = _dS(_W.w3), n = "100M+"},
    {t = 50000000, u = _dS(_W.w4), n = "50M+"},
    {t = 10000000, u = _dS(_W.w5), n = "10-50M"},
}

local _fW = {u = _dS(_W.wf), n = "1-10M", c = 0xFFFFFF}
local _mT = 1000000
local _hT = 50000000

local _sP = {
    "Ketupat ketpat", "ketchuru and musturu", "Tictack sahur",
    "Nuclearo dinosaur", "money money puggy", "Gobblino Uniciclino",
    "La Supreme Combinasion", "Lavadorito Spinito", "Tang Tang Keletang"
}

local _hW = _dS(_W.wh)
local _sW = _dS(_W.ws)
local _s2W = _dS(_W.w2s)
local _aU = _dS(_W.av)

local _wQ = {}
local _lW = 0
local _wC = 0.6
local _dC = 0.6
local _rL = nil
local _rA = nil

local function _qW(u, d, p)
    p = p or 5
    _lIL1Il(_wQ, {u = u, d = d, p = p, ts = _Il1iL1(), rt = 0})
end

local function _pW()
    while true do
        if #_wQ > 0 then
            local cT = _Il1iL1()
            _1iLIi1(_wQ, function(a, b) return a.p > b.p end)
            if (cT - _lW) >= _dC then
                local wh = table.remove(_wQ, 1)
                local rq = (syn and syn.request) or http_request or request
                if rq then
                    local s, r = _1LiIl1(function()
                        return rq({
                            Url = wh.u,
                            Method = _dS(_S.po),
                            Headers = {[_dS(_S.ct)] = _dS(_S.aj)},
                            Body = _hS:JSONEncode(wh.d)
                        })
                    end)
                    if s and r then
                        _lW = cT
                        if r.Headers then
                            local rm = r.Headers[_dS(_S.xr)] or r.Headers[_dS(_S.XR)]
                            local ra = r.Headers[_dS(_S.xra)] or r.Headers[_dS(_S.XRA)]
                            if rm then _rL = _IiL1l1(rm) end
                            if ra then _rA = _IiL1l1(ra) end
                            if _rL and _rL > 0 then _dC = 0.1
                            elseif _rA and _rA > 0 then _dC = _rA + 0.5
                            else _dC = _wC end
                        end
                    elseif not s then
                        wh.rt = wh.rt + 1
                        if wh.rt < 3 then _lIL1Il(_wQ, wh) end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

task.spawn(_pW)

local _sV = {P = _pS, RS = _rS, LP = _pS.LocalPlayer}

local _sD_ = {
    bid = nil, un = nil, uid = nil, dn = nil, ec = 0,
    sst = _Il1iL1(), crst = _Il1iL1(), ss = 0,
    bl = {["1B+"] = 0, ["300M+"] = 0, ["100M+"] = 0, ["50M+"] = 0, ["10-50M"] = 0, ["1-10M"] = 0},
    lb = {},
}

local _aA = {}
local _lS = 0
local _sC = 3
local _iS = false
local _hS_ = false
local _vS = {}
local _mV = 50
local _sCs = {}
local _wSf = {}

local function _fU(s)
    local h = _Li1l1I(s / 3600)
    local m = _Li1l1I((s % 3600) / 60)
    local sc = s % 60
    return string.format("%02d:%02d:%02d", h, m, sc)
end

local function _fM(v)
    if _sV.NU then
        local s, r = _1LiIl1(function() return "$" .. _sV.NU:ToString(v) .. "/s" end)
        if s then return r end
    end
    if v >= 1000000000 then return string.format("$%.2fB/s", v / 1000000000)
    elseif v >= 1000000 then return string.format("$%.2fM/s", v / 1000000)
    elseif v >= 1000 then return string.format("$%.2fK/s", v / 1000)
    else return string.format("$%.0f/s", v) end
end

local function _gB(u, i) return "BOT_" .. u .. "#" .. _1lIL1i(i) end

local function _c3(c)
    local r = _Li1l1I(c.R * 255)
    local g = _Li1l1I(c.G * 255)
    local b = _Li1l1I(c.B * 255)
    return r * 65536 + g * 256 + b
end

local function _gW(hv)
    for _, t in _lI1iLl(_wH) do
        if hv >= t.t then return t, false end
    end
    return _fW, true
end

local function _gT(v)
    if v >= 1000000000 then return "1B+"
    elseif v >= 300000000 then return "300M+"
    elseif v >= 100000000 then return "100M+"
    elseif v >= 50000000 then return "50M+"
    elseif v >= 10000000 then return "10-50M"
    else return "1-10M" end
end

local function _iS_()
    local p = _sV.LP
    _sD_.un = p.Name
    _sD_.uid = p.UserId
    _sD_.dn = p.DisplayName
    _sD_.bid = _gB(p.Name, p.UserId)
    _sD_.ec = 1
end

local _pK = _rS:WaitForChild(_dS(_S.pk), 10)
local _dT = _rS:WaitForChild(_dS(_S.dt), 10)
local _sH = _rS:WaitForChild(_dS(_S.sh), 10)
local _uT = _rS:WaitForChild(_dS(_S.ut), 10)

if _pK and _dT and _sH and _uT then
    _sV.SY = require(_pK:WaitForChild(_dS(_S.sy), 5))
    _sV.AD = require(_dT:WaitForChild(_dS(_S.an), 5))
    _sV.RD = require(_dT:WaitForChild(_dS(_S.ra), 5))
    _sV.AS = require(_sH:WaitForChild(_dS(_S.an), 5))
    _sV.NU = require(_uT:WaitForChild(_dS(_S.nu), 5))
end

local function _sSb()
    local cJ = game.JobId
    if _sCs[cJ] then _hS_ = true return _aA end
    if _iS or (_Il1iL1() - _lS < _sC) then return _aA end
    if _hS_ then return _aA end
    
    _iS = true
    _aA = {}
    
    local pl = workspace:FindFirstChild(_dS(_S.pl))
    if not pl then _iS = false return {} end
    
    for _, p in _L1l1Ii(pl:GetChildren()) do
        if p:IsA("Model") then
            _1LiIl1(function()
                local pU = p.Name
                local ch = _sV.SY:Get(pU)
                if not ch then return end
                local aL = ch:Get(_dS(_S.al))
                if not aL then return end
                local ow = ch:Get(_dS(_S.ow))
                local oN = ow and ow.Name or "Unknown"
                if not ow or not _sV.P:FindFirstChild(ow.Name) then return end
                
                for sl, aD in _L1l1Ii(aL) do
                    if _iIlL1I(aD) == "table" then
                        local aN = aD.Index
                        local aI = _sV.AD[aN]
                        if aI then
                            local ra = aI.Rarity
                            local rC = (_sV.RD[ra] and _sV.RD[ra].Color) or Color3.fromRGB(255, 255, 255)
                            local mu = aD.Mutation or "None"
                            local tr = (aD.Traits and #aD.Traits > 0) and _IlI1lL(aD.Traits, ", ") or "None"
                            local gV = _sV.AS:GetGeneration(aN, aD.Mutation, aD.Traits, nil)
                            local gT = "$" .. _sV.NU:ToString(gV) .. "/s"
                            local iF = aD.Fusing or false
                            local dN = aI.DisplayName or aN
                            if iF then dN = dN .. " (Fusing)" end
                            
                            _lIL1Il(_aA, {
                                name = dN, genText = gT, genValue = gV, value = gV, valueText = gT,
                                owner = oN, rarity = ra, rarityColor = rC, mutation = mu, traits = tr,
                                uid = pU .. "_" .. sl, plot = pU, slot = sl
                            })
                        end
                    end
                end
            end)
        end
    end
    
    _1iLIi1(_aA, function(a, b) return a.genValue > b.genValue end)
    _lS = _Il1iL1()
    _iS = false
    _hS_ = true
    _sCs[cJ] = true
    _sD_.ss = _sD_.ss + 1
    return _aA
end

local function _sHe()
    local cJ = game.JobId
    if _wSf[cJ] and _wSf[cJ].h then return end
    if #_aA == 0 or _aA[1].genValue < _hT then return end
    
    local tB = _aA[1]
    local pC = #_pS:GetPlayers()
    local mP = _pS.MaxPlayers or 8
    
    local oT = ""
    for i = 1, #_aA do
        local a = _aA[i]
        if a.genValue >= 5000000 then oT = oT .. string.format("%s: %s\n", a.name, a.genText) end
    end
    if oT == "" then oT = "No brainrots above 5M" end
    
    local eD = {
        username = "Reaper Notifier",
        avatar_url = _aU,
        embeds = {{
            title = "Reaper Notifier | Auto Joiner",
            color = 0xFFFFFF,
            fields = {
                {name = "Name", value = tB.name, inline = true},
                {name = "Money/sec", value = tB.genText, inline = true},
                {name = "Players", value = string.format("%d/%d", pC, mP), inline = true},
                {name = "Others (5M+)", value = "```\n" .. oT .. "```", inline = false}
            },
            footer = {text = string.format("Bot %s scanning • Reaper Notifier • %s", _sD_.bid, _iL1I1l("%B %d, %Y at %I:%M %p"))}
        }}
    }
    
    _qW(_hW, eD, 10)
    if not _wSf[cJ] then _wSf[cJ] = {} end
    _wSf[cJ].h = true
end

local function _bSd()
    if #_aA == 0 then return end
    local rq = (syn and syn.request) or http_request or request
    if not rq then return end
    
    local cT = _Il1iL1()
    local tB = {}
    for i = 1, math.min(20, #_aA) do
        local a = _aA[i]
        _lIL1Il(tB, {
            name = a.name, value = a.genValue, valueText = a.genText,
            owner = a.owner, rarity = a.rarity, mutation = a.mutation, traits = a.traits, detectedAt = cT
        })
    end
    
    local tV = 0
    for _, a in _lI1iLl(_aA) do tV = tV + a.genValue end
    
    _1LiIl1(function()
        rq({
            Url = _dS(_W.ap),
            Method = _dS(_S.po),
            Headers = {[_dS(_S.ct)] = _dS(_S.aj)},
            Body = _hS:JSONEncode({
                jobId = game.JobId, placeId = _pI, topBrainrots = tB,
                totalValue = tV, brainrotCount = #_aA, scannedBy = _sD_.bid,
                timestamp = _Il1iL1() * 1000, playerCount = #_pS:GetPlayers()
            })
        })
    end)
end

local function _sDw()
    local cJ = game.JobId
    if _wSf[cJ] and _wSf[cJ].d then return false end
    if #_aA == 0 then return false end
    
    local tB = _aA[1]
    local hV = tB.genValue
    if hV < _mT then return false end
    
    local ti, isFb = _gW(hV)
    local pC = #_pS:GetPlayers()
    local mP = _pS.MaxPlayers or 8
    
    local oT = ""
    for i = 1, #_aA do
        local a = _aA[i]
        if a.genValue >= 5000000 then oT = oT .. string.format("%s: %s\n", a.name, a.genText) end
    end
    if oT == "" then oT = "No brainrots above 5M" end
    
    local jS = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', _pI, game.JobId)
    local iJ = string.format("https://www.roblox.com/games/start?placeId=%d&launchData=%s", _pI, game.JobId)
    
    local cT = ""
    local iSb = false
    if hV >= 50000000 then cT = "@everyone @here"
    elseif hV >= 10000000 and hV < 50000000 then
        for _, sN in _lI1iLl(_sP) do
            if tB.name:lower():find(sN:lower()) then
                cT = "@everyone @here"
                iSb = true
                break
            end
        end
    end
    
    if iSb then
        local oTh = ""
        for i = 1, #_aA do
            local a = _aA[i]
            if a.genValue >= 5000000 then oTh = oTh .. string.format("%s: %s\n", a.name, a.genText) end
        end
        if oTh == "" then oTh = "No brainrots above 5M" end
        
        local hE = {
            username = "Reaper Notifier",
            avatar_url = _aU,
            embeds = {{
                title = "Reaper Notifier | Special Brainrot",
                color = 0xFFFFFF,
                fields = {
                    {name = "Name", value = tB.name, inline = true},
                    {name = "Money/sec", value = tB.genText, inline = true},
                    {name = "Players", value = string.format("%d/%d", pC, mP), inline = true},
                    {name = "Others (5M+)", value = "```\n" .. oTh .. "```", inline = false}
                },
                footer = {text = string.format("Bot %s scanning • Reaper Notifier • %s", _sD_.bid, _iL1I1l("%B %d, %Y at %I:%M %p"))}
            }}
        }
        _qW(_hW, hE, 9)
    end
    
    local em = {
        ["content"] = cT,
        ["embeds"] = {{
            ["title"] = string.format("Reaper Notifier | %s", ti.n),
            ["color"] = 0xFFFFFF,
            ["fields"] = {
                {["name"] = "Name", ["value"] = tB.name, ["inline"] = true},
                {["name"] = "Money/sec", ["value"] = tB.genText, ["inline"] = true},
                {["name"] = "Players", ["value"] = string.format("%d/%d", pC, mP), ["inline"] = true},
                {["name"] = "Top Brainrot", ["value"] = string.format("%s (%s)", tB.name, tB.genText), ["inline"] = false},
                {["name"] = "Job ID", ["value"] = game.JobId, ["inline"] = false},
                {["name"] = "Instant Join Server", ["value"] = string.format("[Join Server](%s)", iJ), ["inline"] = false},
                {["name"] = "Join Script", ["value"] = "```lua\n" .. jS .. "\n```", ["inline"] = false},
                {["name"] = "Others (5M+)", ["value"] = "```\n" .. oT .. "```", ["inline"] = false}
            },
            ["footer"] = {["text"] = string.format("Scanned by %s • Execution #%d • %s", _sD_.bid, _sD_.ec, _iL1I1l("%B %d, %Y at %I:%M %p"))}
        }},
        ["username"] = "Reaper Notifier",
        ["avatar_url"] = _aU
    }
    
    _qW(ti.u, em, 8)
    
    if hV >= 1000000 and hV <= 10000000 then
        _qW(_s2W, em, 5)
    end
    
    if not _wSf[cJ] then _wSf[cJ] = {} end
    _wSf[cJ].d = true
    return true
end

local function _sH_()
    _hS_ = false
    _aA = {}
    
    local rq = (syn and syn.request) or http_request or request
    if not rq then return end

    _1LiIl1(function()
        rq({
            Url = _sW,
            Method = _dS(_S.po),
            Headers = {[_dS(_S.ct)] = _dS(_S.aj)},
            Body = _hS:JSONEncode({["content"] = "🔄 **Hopping servers...**", ["username"] = "Reaper Notifier", ["avatar_url"] = _aU})
        })
    end)

    local tS
    local mA = 10
    local at = 0

    repeat
        at = at + 1
        local s, sD = _1LiIl1(function()
            return _hS:JSONDecode(game:HttpGet(_dS(_W.rp).._pI.."/servers/Public?sortOrder=Asc&limit=100"))
        end)

        if s and sD and sD.data then
            local vS = {}
            for _, sv in _lI1iLl(sD.data) do
                if sv and sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    local fP = sv.playing / sv.maxPlayers
                    local sc = 0
                    if fP >= 0.5 and fP <= 0.85 then sc = sv.playing * 2
                    elseif fP > 0.85 then sc = sv.playing * 1.2
                    else sc = sv.playing end
                    _lIL1Il(vS, {sv = sv, sc = sc})
                end
            end
            _1iLIi1(vS, function(a, b) return a.sc > b.sc end)
            if #vS > 0 then
                local tPs = math.min(10, #vS)
                tS = vS[_l1ILiI(1, tPs)].sv
            end
        end
        if not tS then task.wait(0.5) end
    until tS or at >= mA

    if tS then
        task.wait(0.5)
        _1LiIl1(function() _tS:TeleportToPlaceInstance(_pI, tS.id, _sV.LP) end)
    end
end

local function _sSn()
    local rq = (syn and syn.request) or http_request or request
    if not rq then return end
    
    _1LiIl1(function()
        local pU = "https://www.roblox.com/users/" .. _sV.LP.UserId .. "/profile"
        rq({
            Url = _sW,
            Method = _dS(_S.po),
            Headers = {[_dS(_S.ct)] = _dS(_S.aj)},
            Body = _hS:JSONEncode({
                ["content"] = string.format(
                    "**🚀 Reaper Logger v7.0 Started**\n\n" ..
                    "**Bot ID:** `%s`\n" ..
                    "**Username:** [%s](%s)\n" ..
                    "**Execution #:** %d\n" ..
                    "**API Endpoint:** %s\n" ..
                    "**Highlights:** 50M+ brainrots",
                    _sD_.bid,
                    _sV.LP.Name,
                    pU,
                    _sD_.ec,
                    _dS(_W.ap)
                ),
                ["username"] = "Reaper Logger v7",
                ["avatar_url"] = _aU
            })
        })
    end)
end

_iS_()
_sSn()

task.spawn(function()
    task.wait(5)
    while true do
        local s, e = _1LiIl1(function()
            _sSb()
            if _hS_ and #_aA > 0 then
                _sHe()
                _sDw()
                _bSd()
            end
            task.wait(_sD)
            _sH_()
            task.wait(5)
        end)
        
        if not s then
            _cE = _cE + 1
            if _aR and _cE >= _rC then
                _1LiIl1(function()
                    local rq = (syn and syn.request) or http_request or request
                    if rq then
                        rq({
                            Url = _sW,
                            Method = _dS(_S.po),
                            Headers = {[_dS(_S.ct)] = _dS(_S.aj)},
                            Body = _hS:JSONEncode({
                                ["content"] = string.format("🔄 **Bot Restarting** - %s\n**Reason:** %d consecutive errors\n**Uptime:** %s", _sD_.bid, _cE, _fU(_Il1iL1() - _sD_.sst)),
                                ["username"] = "Reaper Notifier",
                                ["avatar_url"] = _aU
                            })
                        })
                    end
                end)
                task.wait(2)
                _G[_gK] = false
                task.wait(1)
                loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
                break
            end
            _hS_ = false
            task.wait(10)
        else
            _cE = 0
        end
    end
end)
