-- ForeverFriendsHub: erfasst Daten der eigenen Charaktere und gibt sie als Text aus,
-- den man auf der Webseite einfügen kann. Ein Addon kann selbst nichts ins Internet senden.

local ADDON_NAME = ...
local PREFIX = "FFHUB1"

local FRAKTIONEN = { Alliance = "Allianz", Horde = "Horde" }

local frame = CreateFrame("Frame")

local function Db()
  FFHubDB = FFHubDB or {}
  FFHubDB.chars = FFHubDB.chars or {}
  return FFHubDB
end

-- Trennzeichen aus Werten entfernen, damit der Export eindeutig lesbar bleibt
local function Clean(value)
  return (tostring(value or ""):gsub("[;=|\n\r]", " "))
end

local function Snapshot(levelOverride)
  local name = UnitName("player")
  local realm = GetRealmName()
  if not name or not realm then return nil end

  local fraktionToken = UnitFactionGroup("player")
  local gear
  -- In manchen Classic-Clients gibt es die Funktion nicht
  if GetAverageItemLevel then
    local _, equipped = GetAverageItemLevel()
    if equipped and equipped > 0 then gear = math.floor(equipped + 0.5) end
  end

  return {
    name = name,
    realm = realm,
    fraktion = FRAKTIONEN[fraktionToken] or fraktionToken,
    klasse = (UnitClass("player")),
    rasse = (UnitRace("player")),
    level = levelOverride or UnitLevel("player"),
    gear = gear,
    zone = GetRealZoneText(),
    subzone = GetSubZoneText(),
    updated = time(),
  }
end

local function Update(levelOverride)
  local s = Snapshot(levelOverride)
  if not s then return end
  Db().chars[s.name .. "-" .. s.realm] = s
end

-- Eine Zeile pro Charakter: FFHUB1;name=...;realm=...;...
local function Export()
  local lines = {}
  for _, c in pairs(Db().chars) do
    local parts = { PREFIX }
    local function add(key, value) parts[#parts + 1] = key .. "=" .. Clean(value) end
    add("name", c.name)
    add("realm", c.realm)
    add("fraktion", c.fraktion)
    add("klasse", c.klasse)
    add("rasse", c.rasse)
    add("level", c.level)
    add("gear", c.gear)
    add("zone", c.zone)
    add("subzone", c.subzone)
    add("updated", c.updated)
    lines[#lines + 1] = table.concat(parts, ";")
  end
  table.sort(lines)
  return table.concat(lines, "\n")
end

StaticPopupDialogs["FFHUB_EXPORT"] = {
  text = "ForeverFriendsHub: Strg+A, Strg+C und auf der Webseite einfügen.",
  button1 = CLOSE,
  hasEditBox = 1,
  editBoxWidth = 350,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  OnShow = function(self)
    local box = self.editBox or _G[self:GetName() .. "EditBox"]
    box:SetText(Export())
    box:HighlightText()
    box:SetFocus()
  end,
  EditBoxOnEscapePressed = function(self)
    self:GetParent():Hide()
  end,
}

SLASH_FFHUB1 = "/ffhub"
SlashCmdList["FFHUB"] = function()
  Update()
  if next(Db().chars) == nil then
    print("|cff7fd0ffForeverFriendsHub:|r Noch keine Daten erfasst.")
    return
  end
  StaticPopup_Show("FFHUB_EXPORT")
end

frame:SetScript("OnEvent", function(_, event, arg1)
  if event == "PLAYER_LEVEL_UP" then
    Update(arg1) -- UnitLevel liefert hier noch den alten Wert
  else
    Update()
  end
end)

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
