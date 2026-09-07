-- ============================================================
--  BLOX GANK SERVER MONITOR  (Free Public Edition)
-- ============================================================

local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local TextChatService   = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local TweenService      = game:GetService("TweenService")

-- ============================================================
--  CONFIG
-- ============================================================

local WEBHOOK_URL         = "" -- join / leave / monitor started
local WEBHOOK_FISH        = ""
local WEBHOOK_CHECKPLAYER = ""
local WEBHOOK_AVATAR      = ""

local PROXY = "https://square-haze-a007.remediashop.workers.dev"

local SCRIPT_ACTIVE = false

local BRAND_NAME        = "BLOX GANK"
local BRAND_ICON        = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/blox%20logo.png"
local BRAND_FOOTER_TEXT = "BLOX GANK - Server Monitor"

local TierColors = {
    Secret    = 1752220,
    Forgotten = 15263976,
    Ruby      = 16753920,
    Legendary = 3407871,
    Join      = 65280,
    Leave     = 16729344,
    NotBack   = 16711680,
}

-- ============================================================
--  FISH DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armor Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant", "Deepsea Monster Axolotl", "Blocky Lochness Monster", "Aurelion",
    "Runic Enchant Stone", "Frogalloon", "Coral Whale", "Flame Tyrant", "Withering Core",
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Machodon", "Scorching Veinmaw", "Crystalline Behemoth",
    "Frostmoon Whale", "Crystal Goliath", "Eggy Enchant Stone", "Dark Megalodon",
    "Elemental Tempestray", "Glacial Serpent", "Caustic Maw", "Coral Reaper",
    "Sunken Hadalith", "Trench Warden", "Caeruleum Razerback", "Two-headed shark", "Ragnarex",
    "Colossal Shipwreck Crab", "Astrelle", "Moonwake Ray", "Astralune", "Starglass Guardian", "Pelagon", "Crimson Dreadtusk", "Riftborn Arowana",
    "Pyrocoil", "Stormshell Brute", "Wintertusk Mammofin", "Elemental Hydra", "Overlord Hydra", "Tribunal Withering core", "Ashen Kingfish",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Crystalline Behemoth", "Trench Warden", "Ragnarex", "Astralune", "Crimson Dreadtusk", "Elemental Hydra", "Overlord Hydra",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo", "Blossom Jelly", "Bioluminescent Octopus",
}

local FishChanceData = {
    ["Crystal Crab"] = "1 in 750K", ["Orca"] = "1 in 1.5M", ["Zombie Shark"] = "1 in 250K",
    ["Zombie Megalodon"] = "1 in 4M", ["Dead Zombie Shark"] = "1 in 500K", ["Blob Shark"] = "1 in 250K",
    ["Ghost Shark"] = "1 in 500K", ["Skeleton Narwhal"] = "1 in 600K", ["Ghost Worm Fish"] = "1 in 1M",
    ["Worm Fish"] = "1 in 3M", ["Megalodon"] = "1 in 4M", ["1x1x1x1 Comet Shark"] = "1 in 4M",
    ["Bloodmoon Whale"] = "1 in 5M", ["Lochness Monster"] = "1 in 3M", ["Monster Shark"] = "1 in 2.5M",
    ["Eerie Shark"] = "1 in 250K", ["Great Whale"] = "1 in 900K", ["Frostborn Shark"] = "1 in 500K",
    ["Thin Armor Shark"] = "1 in 300K", ["Scare"] = "1 in 3M", ["Queen Crab"] = "1 in 800K",
    ["King Crab"] = "1 in 1.2M", ["Cryoshade Glider"] = "1 in 450K", ["Panther Eel"] = "1 in 750K",
    ["Giant Squid"] = "1 in 800K", ["Depthseeker Ray"] = "1 in 1.2M", ["Robot Kraken"] = "1 in 3.5M",
    ["Mosasaur Shark"] = "1 in 800K", ["King Jelly"] = "1 in 1.5M", ["Bone Whale"] = "1 in 2M",
    ["Elshark Gran Maja"] = "1 in 4M", ["Elpirate Gran Maja"] = "1 in 4M", ["ElRetro Gran Maja"] = "1 in 4M",
    ["Ancient Whale"] = "1 in 2.75M", ["Gladiator Shark"] = "1 in 1M", ["Ancient Lochness Monster"] = "1 in 3M",
    ["Talon Serpent"] = "1 in 3M", ["Hacker Shark"] = "1 in 2M", ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"] = "1 in 1M", ["Emerald Winter Whale"] = "1 in 1.5M", ["Winter Frost Shark"] = "1 in 3M",
    ["Icebreaker Whale"] = "1 in 4M", ["Cursed Kraken"] = "1 in 3M", ["Pirate Megalodon"] = "1 in 4M",
    ["Leviathan"] = "1 in 5M", ["Viridis Lurker"] = "1 in 1.4M", ["Ancient Magma Whale"] = "1 in 5M",
    ["Mutant Runic Koi"] = "1 in ??", ["Cosmic Mutant Shark"] = "1 in 2M", ["Strawberry Orca"] = "1 in 3M",
    ["Bonemaw Tyrant"] = "1 in 2.5M", ["Rainbow Comet Shark"] = "1 in ??", ["Love Nessie"] = "1 in ??",
    ["Broken Heart Nessie"] = "1 in ??", ["Sea Eater"] = "1 in 25M", ["Thunderzilla"] = "1 in 30M",
    ["Iridesca"] = "1 in 25M", ["Eggy Enchant Stone"] = "1 in 100K", ["Deepsea Monster Axolotl"] = "1 in 2M",
    ["Blocky Lochness Monster"] = "1 in 3M", ["Frostbite Leviathan"] = "1 in 12M", ["Aurelion"] = "1 in 3M",
    ["Runic Enchant Stone"] = "1 in 1.5M", ["Frogalloon"] = "1 in 1.5M", ["Fluorivane"] = "1 in 15M",
    ["Coral Whale"] = "1 in 2M", ["Flame Tyrant"] = "1 in 5M", ["Cerulean Dragon"] = "1 in 25M",
    ["Withering Core"] = "1 in 3M", ["Machodon"] = "1 in 10M", ["Crystalline Behemoth"] = "1 in 20M",
    ["Frostmoon Whale"] = "1 in 5M", ["Crystal Goliath"] = "1 in 3M", ["Ketupat Whale"] = "1 in ??",
    ["Scorching Veinmaw"] = "1 in 5M", ["Glacial Serpent"] = "1 in 6M", ["Elemental Tempestray"] = "1 in 1M",
    ["Dark Megalodon"] = "1 in 8M", ["Caustic Maw"] = "1 in 4M", ["Coral Reaper"] = "1 in 6M",
    ["Sunken Hadalith"] = "1 in ??", ["Trench Warden"] = "1 in 15M", ["Caeruleum Razerback"] = "1 in 3M",
    ["Two-headed shark"] = "1 in 3M", ["Ragnarex"] = "1 in 35M", ["Colossal Shipwreck Crab"] = "1 in 5M",
    ["Astrelle"] = "1 in 6M", ["Moonwake Ray"] = "1 in 5M", ["Astralune"] = "1 in 20M", ["Riftborn Arowana"] = "1 in 4.5M",
    ["Pyrocoil"] = "1 in 4M",
    ["Stormshell Brute"] = "1 in 4M",
    ["Wintertusk Mammofin"] = "1 in 4M",
    ["Crimson Dreadtusk"] ="1 in 20M",
    ["Elemental Hydra"] = "1 in 40M",
    ["Overlord Hydra"] = "1 in 45M",
    ["Ashen Kingfish"] = "1 in 3.5M",
    ["Tribunal Withering Core"] = "1 in 5M",

}

local NP = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/"

local FishImageURL = {
    ["Frostborn Shark"] = NP.."9.png", ["Crystal Goliath"] = NP.."11.png", ["Crystalline Behemoth"] = NP.."10.png",
    ["Elemental Tempestray"] = NP.."13.png", ["Dark Megalodon"] = NP.."14.png", ["Withering Core"] = NP.."16.png",
    ["Flame Tyrant"] = NP.."17.png", ["Scorching Veinmaw"] = NP.."18.png", ["Cerulean Dragon"] = NP.."19.png",
    ["King Crab"] = NP.."21.png", ["Queen Crab"] = NP.."22.png", ["Panther Eel"] = NP.."23.png",
    ["Cryoshade Glider"] = NP.."24.png", ["Giant Squid"] = NP.."25.png", ["Depthseeker Ray"] = NP.."26.png",
    ["Robot Kraken"] = NP.."27.png", ["Ghost Shark"] = NP.."29.png", ["Skeleton Narwhal"] = NP.."30.png",
    ["Blob Shark"] = NP.."31.png", ["Worm Fish"] = NP.."32.png", ["Cosmic Mutant Shark"] = NP.."33.png",
    ["Megalodon"] = NP.."34.png", ["Bloodmoon Whale"] = NP.."36.png", ["Frostmoon Whale"] = NP.."37.png",
    ["Thunderzilla"] = NP.."38.png", ["Thin Armor Shark"] = NP.."40.png", ["Scare"] = NP.."41.png",
    ["Lochness Monster"] = NP.."43.png", ["Ancient Magma Whale"] = NP.."44.png", ["Crystal Crab"] = NP.."46.png",
    ["Orca"] = NP.."47.png", ["Eerie Shark"] = NP.."49.png", ["Monster Shark"] = NP.."50.png",
    ["Eggy Enchant Stone"] = NP.."52.png", ["Strawberry Orca"] = NP.."53.png", ["Iridesca"] = NP.."54.png",
    ["Frogalloon"] = NP.."56.png", ["Blocky Lochness Monster"] = NP.."57.png", ["Aurelion"] = NP.."58.png",
    ["Frostbite Leviathan"] = NP.."59.png", ["Runic Enchant Stone"] = NP.."61.png", ["Bonemaw Tyrant"] = NP.."00.png",
    ["Mutant Runic Koi"] = NP.."62.png", ["Deepsea Monster Axolotl"] = NP.."63.png", ["Fluorivane"] = NP.."64.png",
    ["Sea Eater"] = NP.."65.png", ["Pirate Megalodon"] = NP.."67.png", ["Elpirate Gran Maja"] = NP.."68.png",
    ["Cursed Kraken"] = NP.."69.png", ["Mosasaur Shark"] = NP.."71.png", ["King Jelly"] = NP.."72.png",
    ["Gladiator Shark"] = NP.."75.png", ["Ancient Lochness Monster"] = NP.."76.png", ["Elshark Gran Maja"] = NP.."77.png",
    ["Viridis Lurker"] = NP.."78.png", ["Bone Whale"] = NP.."79.png", ["Ancient Whale"] = NP.."80.png",
    ["Great Whale"] = NP.."82.png", ["Coral Whale"] = NP.."83.png", ["Love Nessie"] = NP.."85.png",
    ["Broken Heart Nessie"] = NP.."86.png",
    ["Leviathan"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Rainbow Comet Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Ruby Gemstone"] = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/1.png",
    ["Glacial Serpent"] = NP.."81.png",
    ["Machodon"] = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/42.png",
    ["Caustic Maw"] = NP.."97.png",
    ["Coral Reaper"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Coral%20Reaper.png",
    ["Trench Warden"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Trench%20Warden.png",
    ["Caeruleum Razerback"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/cureleam%20barbak%20(1).png",
    ["Two-headed shark"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Two-headed%20shark.png",
    ["Ragnarex"] = NP.."104.png",
    ["Colossal Shipwreck Crab"] = NP.."106.png",
    ["Astrelle"] = NP.."Astrlele.png", -- cek nama file asli di repo kalau gambar gak muncul
    ["Astralune"] = NP.."1000188338.png",
    ["Moonwake Ray"] = NP.."1000188340.png",
    ["Riftborn Arowana"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/1000195428.png",
["Pyrocoil"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/115.png",
["Stormshell Brute"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/114.png",
["Wintertusk Mammofin"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/113.png",
["Crimson Dreadtusk"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/1000195427.png",
["Overlord Hydra"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/51072.png",
["Elemental Hydra"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/51076.png",
["Ashen Kingfish"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Ashen%20Kingfish.webp",
["Elemental Hydra"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/51076.png",
["Tribunal Withering core"] = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Tribunal%20Withering%20Core.png",
}

local FishImageURLLower = {}
for k, v in pairs(FishImageURL) do FishImageURLLower[string.lower(k)] = v end

local function GetFishImageURL(baseName)
    if not baseName then return nil end
    return FishImageURL[baseName] or FishImageURLLower[string.lower(baseName)]
end

-- ============================================================
--  STATE / CACHE
-- ============================================================

local FishImageCache = {}
local AvatarCache    = {}
local LeaveTimers    = {}
local PlayerStats    = {}
local PlayerNameToId = {}

-- ============================================================
--  UTILITY
-- ============================================================

local function GetRequestFunc()
    return (syn and syn.request) or (http and http.request) or http_request
        or (fluxus and fluxus.request) or request
end

local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function FormatNumber(n)
    n = tonumber(n)
    if not n then return "N/A" end
    local sign = n < 0 and "-" or ""
    n = math.abs(n)
    if n >= 1000000000 then return sign .. string.format("%.1fB", n / 1000000000)
    elseif n >= 1000000 then return sign .. string.format("%.1fM", n / 1000000)
    elseif n >= 1000     then return sign .. string.format("%.0fK", n / 1000)
    else return sign .. tostring(n) end
end

local function FindPlayer(name)
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower then return player end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lower, 1, true)
        or string.find(lower, string.lower(player.Name), 1, true) then
            return player
        end
    end
    return nil
end

local function GetAvatarUrlById(userId)
    if not userId then return nil end
    return PROXY .. "/avatar/" .. tostring(userId) .. "?t=" .. tostring(os.time())
end

-- ============================================================
--  SAVE CONFIG (webhook urls)
-- ============================================================

local CONFIG_FILE = "bloxgank_config.json"

local function SaveConfig(joinUrl, fishUrl, checkplayerUrl)
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            webhook_join        = joinUrl        or "",
            webhook_fish        = fishUrl        or "",
            webhook_checkplayer = checkplayerUrl or "",
        }))
    end)
end

local function LoadConfig()
    if not readfile or not isfile then return nil end
    local ok, raw = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(data) == "table" then return data end
    return nil
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName end
    end
    local bestBase, bestLen = nil, 0
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s and #baseName > bestLen then
            bestLen, bestBase = #baseName, baseName
        end
    end
    return bestBase
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh")                               then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture")         then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  CHECK PLAYER ON SERVER  (Caught + Server Luck saja, tanpa lokasi)
-- ============================================================

local function FindValueByName(container, names)
    if not container then return nil end
    for _, n in ipairs(names) do
        local child = container:FindFirstChild(n)
        if child then return child end
    end
    return nil
end

local function GetPlayerCaught(player)
    if not player then return "N/A" end
    local ls = player:FindFirstChild("leaderstats")
    local caughtStat = FindValueByName(ls, { "caught", "Caught" })
    if caughtStat then return FormatNumber(caughtStat.Value) end
    return "N/A"
end

local function ScanServerLuckInfo()
    local luckValue, luckEnds = nil, nil
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return luckValue, luckEnds end

    for _, v in ipairs(pg:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            local t = v.Text or ""
            if t ~= "" then
                if not luckValue then
                    local m = t:match("[Ll]uck.-x%s*(%d+)") or t:match("x%s*(%d+).-[Ll]uck")
                    if m then luckValue = m end
                end
                if not luckEnds then
                    local h, m2, s = t:match("(%d+)h%s*(%d+)m%s*(%d+)s")
                    if h then luckEnds = h .. "h " .. m2 .. "m " .. s .. "s" end
                end
            end
        end
        if luckValue and luckEnds then break end
    end
    return luckValue, luckEnds
end

local function BuildPlayerCheckDescription()
    local players = Players:GetPlayers()
    local lines = {}

    table.insert(lines, "Total player aktif: " .. #players)
    table.insert(lines, "")

    for _, p in ipairs(players) do
        table.insert(lines, string.format("- %s | Caught: %s", p.Name, GetPlayerCaught(p)))
    end

    table.insert(lines, "")
    local luckVal, luckEnds = ScanServerLuckInfo()
    table.insert(lines, "Server Luck: x" .. (luckVal or "?"))
    table.insert(lines, "End Server Luck: " .. (luckEnds or "?"))
    table.insert(lines, "")
    table.insert(lines, "Updated: " .. os.date("%d/%m/%Y %H:%M:%S"))

    return table.concat(lines, "\n")
end

-- ============================================================
--  WEBHOOK SENDERS
-- ============================================================

local function BrandAuthor()
    if BRAND_ICON ~= "" then return { name = BRAND_NAME, icon_url = BRAND_ICON } end
    return { name = BRAND_NAME }
end

local function BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, footerTag)
    local embed = {
        title       = title,
        description = description,
        color       = color,
        fields      = fields,
        footer      = { text = (footerTag or BRAND_FOOTER_TEXT) .. " | " .. os.date("%d/%m/%Y %H:%M:%S") },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        author      = BrandAuthor(),
    }
    if imageUrl then embed.image     = { url = imageUrl } end
    if thumbUrl then embed.thumbnail = { url = thumbUrl } end
    return embed
end

local function PostWebhook(url, body)
    local requestFunc = GetRequestFunc()
    if not requestFunc then
        warn("[BLOX Gank] PostWebhook gagal: request function tidak ditemukan di executor ini.")
        return
    end
    if url == "" then
        warn("[BLOX Gank] PostWebhook gagal: url webhook kosong.")
        return
    end
    task.spawn(function()
        local ok, err = pcall(function()
            local res = requestFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(body),
            })
            local status = res and (res.StatusCode or res.status_code)
            if status and (status < 200 or status >= 300) then
                warn("[BLOX Gank] Webhook response bukan 2xx. Status: " .. tostring(status))
            end
        end)
        if not ok then
            warn("[BLOX Gank] PostWebhook error: " .. tostring(err))
        end
    end)
end

local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl)
    PostWebhook(WEBHOOK_URL, {
        username   = BRAND_NAME,
        avatar_url = WEBHOOK_AVATAR,
        embeds     = { BuildEmbed(title, description, color, fields, imageUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl)
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    PostWebhook(url, {
        username   = BRAND_NAME,
        avatar_url = WEBHOOK_AVATAR,
        embeds     = { BuildEmbed(title, description, color, fields, imageUrl, thumbUrl) },
    })
end

local function SendPlayerCheckWebhook()
    local url = (WEBHOOK_CHECKPLAYER ~= "") and WEBHOOK_CHECKPLAYER or WEBHOOK_URL
    if url == "" then return end

    local description = BuildPlayerCheckDescription()
    PostWebhook(url, {
        username   = BRAND_NAME,
        avatar_url = WEBHOOK_AVATAR,
        embeds     = { BuildEmbed(
            "Check Player On Server - " .. Players.LocalPlayer.Name,
            description, TierColors.Join, {}, nil, nil, "BLOX GANK - Check Player"
        )},
    })
end

-- ============================================================
--  CHAT PARSING & DETECTION
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")
    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end
    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = Trim(playerName)
    weight     = weight and Trim(weight) or "N/A"
    fishFull   = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull   = fishFull:match("^(.-)%s*[!%.]?$")     or fishFull
    fishFull   = Trim(fishFull)
    return { player = playerName, fish = fishFull, weight = weight }
end

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = FindPlayer(data.player)
    local uid = (targetPlayer and targetPlayer.UserId) or PlayerNameToId[string.lower(data.player)]

    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), name = data.player }
        end
        PlayerStats[uid].catchCount = PlayerStats[uid].catchCount + 1
    end

    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = GetFishImageURL(legendaryBase) or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook("Crystalized Legendary", "", TierColors.Legendary, {
            { name = "Pemain", value = data.player, inline = true },
            { name = "Item",   value = data.fish,   inline = true },
            { name = "Berat",  value = data.weight, inline = true },
        }, nil, imageUrl)
        return
    end

    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = GetFishImageURL(rubyBase) or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook("Ruby Gemstone", "", TierColors.Ruby, {
            { name = "Pemain", value = data.player, inline = true },
            { name = "Item",   value = data.fish,   inline = true },
            { name = "Berat",  value = data.weight, inline = true },
        }, nil, imageUrl)
        return
    end

    local baseName = FindSecretFish(data.fish)
    if not baseName then return end

    local imageUrl = GetFishImageURL(baseName) or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))
    local isForgotten = false
    for _, name in ipairs(ForgottenList) do
        if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
    end
    if uid and PlayerStats[uid] then
        PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
    end
    local chanceInfo = FishChanceData[baseName] or "Unknown"
    local fields = {
        { name = "Pemain", value = data.player, inline = true },
        { name = "Ikan",   value = data.fish,   inline = true },
        { name = "Berat",  value = data.weight, inline = true },
        { name = "Chance", value = chanceInfo,   inline = true },
    }
    if isForgotten then
        SendFishWebhook("Forgotten Tier Terdeteksi", "", TierColors.Forgotten, fields, nil, imageUrl)
    else
        SendFishWebhook("Secret Fish Terdeteksi", "", TierColors.Secret, fields, nil, imageUrl)
    end
end

-- ============================================================
--  BACKPACK MONITOR
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not GetFishImageURL(baseName) and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchForFish(player)
    local bp = player:FindFirstChild("Backpack")
    if bp then WatchBackpack(bp) end
    player.CharacterAdded:Connect(function()
        local newBp = player:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(newBp) end
    end)
end

-- ============================================================
--  HOOK CHAT
-- ============================================================

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            local text = msg.Text or ""
            if msg.TextSource == nil then CheckAndSend(text) end
            if Trim(string.lower(text)) == "!checkplayer" then SendPlayerCheckWebhook() end
        end)
    end
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = string.lower(d.Message)
                if string.find(lowerMsg, "%[server%]") or string.find(lowerMsg, "obtained") then
                    CheckAndSend(d.Message)
                end
                if Trim(lowerMsg) == "!checkplayer" then SendPlayerCheckWebhook() end
            end)
        end
    end
end

-- ============================================================
--  START MONITORING
-- ============================================================

local function StartMonitoring()
    local allPlayers = Players:GetPlayers()
    local names      = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook("Monitor Aktif", "Server monitor sudah aktif.", TierColors.Join, {
        { name = "Host",          value = Players.LocalPlayer.Name,        inline = true  },
        { name = "Total Player",  value = tostring(#allPlayers),           inline = true  },
        { name = "Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
    })

    HookChat()

    for _, p in ipairs(allPlayers) do
        WatchForFish(p)
        AvatarCache[p.UserId]                       = GetAvatarUrlById(p.UserId)
        PlayerStats[p.UserId]                       = { catchCount = 0, secretList = {}, joinTime = os.time(), name = p.Name }
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId] = nil
        PlayerStats[player.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), name = player.Name }
        PlayerNameToId[string.lower(player.Name)]        = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)] = player.UserId
        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrlById(player.UserId)
            SendWebhook("Player Bergabung", "", TierColors.Join, {
                { name = "Username",     value = player.Name,                       inline = true },
                { name = "Total Player", value = tostring(#Players:GetPlayers()),   inline = true },
            }, nil, AvatarCache[player.UserId])
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName     = player.Name
        local pId       = player.UserId
        local avatarUrl = AvatarCache[pId] or GetAvatarUrlById(pId)
        local totalNow  = #Players:GetPlayers() - 1

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end

        SendWebhook("Player Keluar", "Salah satu pemain keluar server.", TierColors.Leave, {
            { name = "Username",     value = pName,               inline = true },
            { name = "Total Player", value = tostring(totalNow),  inline = true },
        }, nil, avatarUrl)

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                PostWebhook(WEBHOOK_URL, {
                    username   = BRAND_NAME,
                    avatar_url = WEBHOOK_AVATAR,
                    embeds     = { BuildEmbed("Player Tidak Kembali", "Pemain ini belum balik lagi ke server.", TierColors.NotBack, {
                        { name = "Username", value = pName,                        inline = true },
                        { name = "Info",     value = "Tidak kembali selama 10 menit", inline = true },
                    }, avatarUrl, nil, "BLOX GANK") },
                })
            end
        end)
    end)
end

-- ============================================================
--  UI
-- ============================================================

local function HoverTween(btn, hoverColor, baseColor)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = hoverColor }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = baseColor  }):Play() end)
end

-- Palette modern (dark, accent blurple)
local BG_MAIN       = Color3.fromRGB(17, 17, 23)
local BG_TOPBAR      = Color3.fromRGB(22, 22, 29)
local BG_CARD        = Color3.fromRGB(27, 27, 35)
local BG_CARD_HOVER  = Color3.fromRGB(34, 34, 44)
local BORDER_SUBTLE  = Color3.fromRGB(45, 45, 56)
local ACCENT         = Color3.fromRGB(114, 130, 240)
local ACCENT_DIM     = Color3.fromRGB(70, 78, 130)
local TEXT_PRIMARY   = Color3.fromRGB(235, 235, 242)
local TEXT_SECONDARY = Color3.fromRGB(140, 140, 158)
local SUCCESS        = Color3.fromRGB(76, 224, 137)
local DANGER         = Color3.fromRGB(235, 80, 90)

local function AddShadow(target, sizeBoost)
    local shadow = Instance.new("ImageLabel")
    shadow.Name              = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image             = "rbxassetid://6014261993"
    shadow.ImageColor3       = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.45
    shadow.ScaleType         = Enum.ScaleType.Slice
    shadow.SliceCenter       = Rect.new(49, 49, 450, 450)
    shadow.Size              = UDim2.new(1, sizeBoost or 34, 1, sizeBoost or 34)
    shadow.Position          = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint       = Vector2.new(0.5, 0.5)
    shadow.ZIndex            = (target.ZIndex or 1) - 1
    shadow.Parent            = target.Parent
    return shadow
end

local function CreateMainUI(gui)
    local savedConfig = LoadConfig()

    local FRAME_H = 304
    local frame = Instance.new("Frame")
    frame.Name             = "Main"
    frame.Size             = UDim2.new(0, 300, 0, FRAME_H)
    frame.AnchorPoint      = Vector2.new(0.5, 0.5)
    frame.Position         = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = BG_MAIN
    frame.BorderSizePixel  = 0
    frame.ClipsDescendants = true
    frame.ZIndex           = 2
    frame.Parent           = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke")
    stroke.Color = BORDER_SUBTLE; stroke.Thickness = 1; stroke.Transparency = 0.2; stroke.Parent = frame

    AddShadow(frame, 44)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 44); topBar.BackgroundColor3 = BG_TOPBAR
    topBar.BorderSizePixel = 0; topBar.Parent = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 16); topBarFix.Position = UDim2.new(0, 0, 1, -16)
    topBarFix.BackgroundColor3 = BG_TOPBAR; topBarFix.BorderSizePixel = 0; topBarFix.Parent = topBar

    local topAccentLine = Instance.new("Frame")
    topAccentLine.Size = UDim2.new(1, 0, 0, 2); topAccentLine.Position = UDim2.new(0, 0, 1, -2)
    topAccentLine.BorderSizePixel = 0; topAccentLine.BackgroundColor3 = ACCENT; topAccentLine.Parent = topBar
    local topAccentGradient = Instance.new("UIGradient")
    topAccentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 130, 240)),
        ColorSequenceKeypoint.new(1, ACCENT),
    })
    topAccentGradient.Parent = topAccentLine

    local titleDot = Instance.new("Frame")
    titleDot.Size = UDim2.new(0, 6, 0, 6); titleDot.Position = UDim2.new(0, 14, 0.5, -3)
    titleDot.BackgroundColor3 = ACCENT; titleDot.BorderSizePixel = 0; titleDot.Parent = topBar
    Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Text = "BLOX GANK"; title.Size = UDim2.new(1, -100, 0, 16); title.Position = UDim2.new(0, 28, 0, 8)
    title.BackgroundTransparency = 1; title.TextColor3 = TEXT_PRIMARY
    title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = topBar

    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "SERVER MONITOR"; subtitle.Size = UDim2.new(1, -100, 0, 12); subtitle.Position = UDim2.new(0, 28, 0, 23)
    subtitle.BackgroundTransparency = 1; subtitle.TextColor3 = TEXT_SECONDARY
    subtitle.Font = Enum.Font.Gotham; subtitle.TextSize = 9; subtitle.TextXAlignment = Enum.TextXAlignment.Left; subtitle.Parent = topBar

    local function MakeWinBtn(text, xOffset, hoverColor)
        local btn = Instance.new("TextButton")
        btn.Text = text; btn.Size = UDim2.new(0, 26, 0, 26); btn.Position = UDim2.new(1, xOffset, 0.5, -13)
        btn.BackgroundColor3 = BG_TOPBAR; btn.BackgroundTransparency = 1; btn.TextColor3 = TEXT_SECONDARY
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 13; btn.BorderSizePixel = 0; btn.Parent = topBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0, BackgroundColor3 = hoverColor, TextColor3 = Color3.fromRGB(255,255,255) }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 1, TextColor3 = TEXT_SECONDARY }):Play()
        end)
        return btn
    end

    local minBtn   = MakeWinBtn("–", -60, BORDER_SUBTLE)
    local closeBtn = MakeWinBtn("×", -30, DANGER)

    minBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

    -- Floating logo indicator (tetap pakai logo BLOX GANK)
    local floatLogo = Instance.new("ImageButton")
    floatLogo.Name             = "BloxGankFloatLogo"
    floatLogo.Size             = UDim2.new(0, 46, 0, 46)
    floatLogo.Position         = UDim2.new(0, 20, 0, 90)
    floatLogo.BackgroundColor3 = BG_MAIN
    floatLogo.Image            = BRAND_ICON
    floatLogo.ScaleType        = Enum.ScaleType.Crop
    floatLogo.BorderSizePixel  = 0
    floatLogo.ZIndex           = 5
    floatLogo.Parent           = gui
    Instance.new("UICorner", floatLogo).CornerRadius = UDim.new(1, 0)
    AddShadow(floatLogo, 18)

    local floatStroke = Instance.new("UIStroke")
    floatStroke.Color = BORDER_SUBTLE; floatStroke.Thickness = 2; floatStroke.Parent = floatLogo

    local floatStatusDot = Instance.new("Frame")
    floatStatusDot.Size             = UDim2.new(0, 14, 0, 14)
    floatStatusDot.Position         = UDim2.new(1, -14, 1, -14)
    floatStatusDot.BackgroundColor3 = DANGER
    floatStatusDot.BorderSizePixel  = 0
    floatStatusDot.ZIndex           = 6
    floatStatusDot.Parent           = floatLogo
    Instance.new("UICorner", floatStatusDot).CornerRadius = UDim.new(1, 0)

    local floatStatusDotStroke = Instance.new("UIStroke")
    floatStatusDotStroke.Color = BG_MAIN; floatStatusDotStroke.Thickness = 2; floatStatusDotStroke.Parent = floatStatusDot

    local floatPulseTween = nil
    local function SetFloatStatus(active)
        floatStatusDot.BackgroundColor3 = active and SUCCESS or DANGER
        floatStroke.Color               = active and SUCCESS or BORDER_SUBTLE
        if floatPulseTween then floatPulseTween:Cancel(); floatPulseTween = nil end
        floatStroke.Transparency = 0
        if active then
            floatPulseTween = TweenService:Create(floatStroke,
                TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                { Transparency = 0.55, Thickness = 3 })
            floatPulseTween:Play()
        else
            floatStroke.Thickness = 2
        end
    end
    SetFloatStatus(false)

    local floatDragging, floatDragStart, floatStartPos, floatMoved = false, nil, nil, false
    floatLogo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging, floatMoved = true, false
            floatDragStart, floatStartPos = input.Position, floatLogo.Position
        end
    end)
    floatLogo.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = false
            if not floatMoved then frame.Visible = not frame.Visible end
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatDragStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then floatMoved = true end
            floatLogo.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { Size = UDim2.new(0,300,0,0), BackgroundTransparency=1 }):Play()
        task.wait(0.2); gui:Destroy()
    end)

    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)

    -- Status chip
    local statusChip = Instance.new("Frame")
    statusChip.Size = UDim2.new(0, 118, 0, 22); statusChip.Position = UDim2.new(0, 12, 0, 52)
    statusChip.BackgroundColor3 = BG_CARD; statusChip.BorderSizePixel = 0; statusChip.Parent = frame
    Instance.new("UICorner", statusChip).CornerRadius = UDim.new(1, 0)
    local statusChipStroke = Instance.new("UIStroke")
    statusChipStroke.Color = BORDER_SUBTLE; statusChipStroke.Thickness = 1; statusChipStroke.Transparency = 0.3; statusChipStroke.Parent = statusChip

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0,7,0,7); statusDot.Position = UDim2.new(0,10,0.5,-3.5)
    statusDot.BackgroundColor3 = DANGER; statusDot.BorderSizePixel = 0; statusDot.Parent = statusChip
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Tidak Aktif"; statusLabel.Size = UDim2.new(1,-28,1,0); statusLabel.Position = UDim2.new(0,24,0,0)
    statusLabel.BackgroundTransparency = 1; statusLabel.TextColor3 = TEXT_SECONDARY
    statusLabel.Font = Enum.Font.GothamMedium; statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.Parent = statusChip

    local BOTTOM_BLOCK_H = 78
    local SCROLL_Y        = 84

    local content = Instance.new("ScrollingFrame")
    content.Name                   = "Content"
    content.Position               = UDim2.new(0, 0, 0, SCROLL_Y)
    content.Size                   = UDim2.new(1, 0, 0, FRAME_H - SCROLL_Y - BOTTOM_BLOCK_H)
    content.BackgroundTransparency = 1
    content.BorderSizePixel        = 0
    content.ScrollBarThickness     = 3
    content.ScrollBarImageColor3   = ACCENT
    content.CanvasSize             = UDim2.new(0, 0, 0, 0)
    content.Parent                 = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    listLayout.Padding       = UDim.new(0, 6)
    listLayout.Parent        = content

    local function UpdateCanvasSize()
        content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)

    local listPad = Instance.new("UIPadding")
    listPad.PaddingLeft   = UDim.new(0, 14)
    listPad.PaddingRight  = UDim.new(0, 14)
    listPad.PaddingTop    = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 6)
    listPad.Parent        = content

    local function MakeLabel(text)
        local lbl = Instance.new("TextLabel")
        lbl.Text = string.upper(text); lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = TEXT_SECONDARY
        lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 9; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = content
        return lbl
    end

    local function MakeInput(placeholder)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder; box.Size = UDim2.new(1, 0, 0, 30)
        box.BackgroundColor3 = BG_CARD; box.TextColor3 = TEXT_PRIMARY
        box.PlaceholderColor3 = Color3.fromRGB(95,95,110); box.Font = Enum.Font.Gotham; box.TextSize = 10
        box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Text = ""
        box.TextXAlignment = Enum.TextXAlignment.Left; box.ClipsDescendants = true; box.Parent = content
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
        local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0,10); pad.PaddingRight = UDim.new(0,10)
        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = BORDER_SUBTLE; boxStroke.Thickness = 1; boxStroke.Transparency = 0.2; boxStroke.Parent = box
        box.Focused:Connect(function()
            TweenService:Create(boxStroke, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0 }):Play()
            TweenService:Create(box, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD_HOVER }):Play()
        end)
        box.FocusLost:Connect(function()
            TweenService:Create(boxStroke, TweenInfo.new(0.12), { Color = BORDER_SUBTLE, Transparency = 0.2 }):Play()
            TweenService:Create(box, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play()
        end)
        return box
    end

    local function MakeToggleRow(labelText, defaultOn, onChange)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26); row.BackgroundTransparency = 1; row.Parent = content

        local lbl = Instance.new("TextLabel")
        lbl.Text = labelText; lbl.Size = UDim2.new(1, -44, 1, 0)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = TEXT_SECONDARY
        lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 10.5; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0,36,0,18); bg.Position = UDim2.new(1,-36,0.5,-9)
        bg.BackgroundColor3 = BORDER_SUBTLE; bg.BorderSizePixel = 0; bg.Parent = row
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(0,2,0.5,-7)
        knob.BackgroundColor3 = Color3.fromRGB(220,220,228); knob.BorderSizePixel = 0; knob.Parent = bg
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

        local hitbox = Instance.new("TextButton")
        hitbox.Size = UDim2.new(0,36,0,18); hitbox.Position = UDim2.new(1,-36,0.5,-9)
        hitbox.BackgroundTransparency = 1; hitbox.Text = ""; hitbox.BorderSizePixel = 0; hitbox.Parent = row

        local state = false
        local function setState(enabled)
            state = enabled
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position         = enabled and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7),
                BackgroundColor3 = enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(220,220,228),
            }):Play()
            TweenService:Create(bg, TweenInfo.new(0.15), {
                BackgroundColor3 = enabled and ACCENT or BORDER_SUBTLE,
            }):Play()
            lbl.TextColor3 = enabled and TEXT_PRIMARY or TEXT_SECONDARY
            if onChange then onChange(enabled) end
        end

        hitbox.MouseButton1Click:Connect(function() setState(not state) end)
        setState(defaultOn)
        return { setState = setState, getState = function() return state end, hitbox = hitbox }
    end

    MakeLabel("Webhook Join / Leave")
    local inputJoin  = MakeInput("Paste webhook join/leave...")
    MakeLabel("Webhook Secret Fish")
    local inputFish  = MakeInput("Paste webhook secret fish...")
    MakeLabel("Webhook Check Player")
    local inputCheckplayer = MakeInput("Kosong = pakai webhook join...")

    local saveEnabled = false
    local saveToggle = MakeToggleRow("Simpan Config", false, function(enabled) saveEnabled = enabled end)

    if savedConfig then
        if savedConfig.webhook_join        and savedConfig.webhook_join        ~= "" then inputJoin.Text        = savedConfig.webhook_join        end
        if savedConfig.webhook_fish        and savedConfig.webhook_fish        ~= "" then inputFish.Text        = savedConfig.webhook_fish        end
        if savedConfig.webhook_checkplayer and savedConfig.webhook_checkplayer ~= "" then inputCheckplayer.Text = savedConfig.webhook_checkplayer end
        saveToggle.setState(true)
    end

    local BTN_Y1 = FRAME_H - BOTTOM_BLOCK_H
    local BTN_Y3 = BTN_Y1 + 28 + 8

    local checkBtn = Instance.new("TextButton")
    checkBtn.Text = "CHECK PLAYER"; checkBtn.Size = UDim2.new(1,-24,0,28); checkBtn.Position = UDim2.new(0,12,0,BTN_Y1)
    checkBtn.BackgroundColor3 = BG_CARD; checkBtn.TextColor3 = TEXT_PRIMARY
    checkBtn.Font = Enum.Font.GothamBold; checkBtn.TextSize = 11; checkBtn.BorderSizePixel = 0; checkBtn.Parent = frame
    Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0,9)
    local checkBtnStroke = Instance.new("UIStroke")
    checkBtnStroke.Color = BORDER_SUBTLE; checkBtnStroke.Thickness = 1; checkBtnStroke.Transparency = 0.2; checkBtnStroke.Parent = checkBtn
    HoverTween(checkBtn, BG_CARD_HOVER, BG_CARD)

    checkBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then
            checkBtn.Text = "START MONITORING DULU"
            task.wait(1.5)
            checkBtn.Text = "CHECK PLAYER"
            return
        end
        SendPlayerCheckWebhook()
        checkBtn.Text = "TERKIRIM"
        task.wait(1.2)
        checkBtn.Text = "CHECK PLAYER"
    end)

    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"; startBtn.Size = UDim2.new(1,-24,0,36); startBtn.Position = UDim2.new(0,12,0,BTN_Y3)
    startBtn.BackgroundColor3 = ACCENT; startBtn.TextColor3 = Color3.fromRGB(255,255,255)
    startBtn.Font = Enum.Font.GothamBold; startBtn.TextSize = 12; startBtn.BorderSizePixel = 0; startBtn.Parent = frame
    startBtn.TextScaled  = true
    startBtn.TextWrapped = false
    local startBtnSizeConstraint = Instance.new("UITextSizeConstraint")
    startBtnSizeConstraint.MaxTextSize = 12
    startBtnSizeConstraint.Parent      = startBtn
    local startBtnPad = Instance.new("UIPadding", startBtn)
    startBtnPad.PaddingLeft  = UDim.new(0,6)
    startBtnPad.PaddingRight = UDim.new(0,6)
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,9)
    local startBtnGradient = Instance.new("UIGradient")
    startBtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 120, 235)),
    })
    startBtnGradient.Rotation = 20
    startBtnGradient.Parent = startBtn
    HoverTween(startBtn, Color3.fromRGB(130, 146, 250), ACCENT)

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end

        if not inputJoin.Text:find("discord.com/api/webhooks") then
            startBtn.Text = "WEBHOOK JOIN INVALID"; startBtnGradient.Enabled = false; startBtn.BackgroundColor3 = DANGER
            task.wait(2); startBtn.Text = "START MONITORING"; startBtnGradient.Enabled = true; startBtn.BackgroundColor3 = ACCENT
            return
        end

        WEBHOOK_URL = inputJoin.Text
        if inputFish.Text:find("discord.com/api/webhooks")        then WEBHOOK_FISH        = inputFish.Text        end
        if inputCheckplayer.Text:find("discord.com/api/webhooks") then WEBHOOK_CHECKPLAYER = inputCheckplayer.Text end

        if saveEnabled then SaveConfig(WEBHOOK_URL, WEBHOOK_FISH, WEBHOOK_CHECKPLAYER) end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = SUCCESS
        statusLabel.Text           = "Aktif - Monitoring..."
        statusLabel.TextColor3     = SUCCESS
        startBtn.Text              = "MONITORING AKTIF"
        startBtnGradient.Enabled   = false
        startBtn.BackgroundColor3  = BG_CARD

        SetFloatStatus(true)

        for _, box in ipairs({ inputJoin, inputFish, inputCheckplayer }) do
            box.TextEditable = false
        end
        saveToggle.hitbox.Active = false

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

local mainGui = Instance.new("ScreenGui")
mainGui.Name         = "BloxGankUI"
mainGui.ResetOnSpawn = false
mainGui.Parent       = (gethui and gethui()) or CoreGui

local uiOk, uiErr = pcall(CreateMainUI, mainGui)
if not uiOk then
    warn("[BLOX Gank] Gagal bikin UI: " .. tostring(uiErr))
end
