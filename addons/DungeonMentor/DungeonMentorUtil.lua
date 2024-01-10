local debugPrintEnabled = true;
local debugPrintCount = 0;
local debugPrintMax = 1;

local classColors = {
   size = 12,
   items = {
       [1] = {name="Warrior", colorName="Tan", hexCode="C69B6D", r=0.78, g=0.61, b=0.43},
       [2] = {name="Paladin", colorName="Pink", hexCode="F48CBA", r=0.96, g=0.55, b=0.73}, 
       [3] = {name="Hunter", colorName="Green", hexCode="AAD372", r=0.67, g=0.83, b=0.45},
       [4] = {name="Rogue", colorName="Yellow", hexCode="FFF468", r=1, g=0.96, b=0.41},
       [5] = {name="Priest", colorName="White", hexCode="FFFFFF", r=1, g=1, b=1},
       [7] = {name="Shaman", colorName="Blue", hexCode="0070DD", r=0, g=0.44, b=0.87},
       [8] = {name="Mage", colorName="Light Blue", hexCode="3FC7EB", r=0.25, g=0.78, b=0.92},
       [9] = {name="Warlock", colorName="Purple", hexCode="8788EE", r=0.53, g=0.53, b=0.93},
      [11] = {name="Druid", colorName="Orange", hexCode="FF7C0A", r=1, g=0.49, b=0.04},
       [6] = {name="Death Knight", colorName="Red", hexCode="C41E3A", r=0.77, g=0.12, b=0.23},
      [12] = {name="Demon Hunter", colorName="Dark Magenta", hexCode="A330C9", r=0.64, g=0.19, b=0.79},
      [10] = {name="Monk", colorName="Spring Green", hexCode="00FF98", r=0, g=1, b=0.6}
   }
};

local wowClasses = {
   deathKnight = {index = 1,  color = {r=0.77, g=0.12, b=0.23}},
   demonHunter = {index = 2,  color = {r=0.64, g=0.19, b=0.79}},
   druid       = {index = 3,  color = {r=1, g=0.49, b=0.04}},
   hunter      = {index = 4,  color = {r=0.67, g=0.83, b=0.45}},
   mage        = {index = 5,  color = {r=0.25, g=0.78, b=0.92}},
   monk        = {index = 6,  color = {r=0, g=1, b=0.6}},
   paladin     = {index = 7,  color = {r=0.96, g=0.55, b=0.73}},
   priest      = {index = 8,  color = {r=1, g=1, b=1}},
   rogue       = {index = 9,  color = {r=1, g=0.96, b=0.41}},
   shaman      = {index = 10, color = {r=0, g=0.44, b=0.87}},
   warlock     = {index = 11, color = {r=0.53, g=0.53, b=0.93}},
   warrior     = {index = 12, color = {r=0.78, g=0.61, b=0.43}}
};

local raidTargetIconTextures = {
   [1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
   [2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
   [3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
   [4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
   [5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
   [6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
   [7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
   [8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"
};

function DM_Util_InDungeonGroup()
   local inst, instType = IsInInstance();

   return instType == "party";
end

function DM_Util_GetSkullTextureString()
   return ICON_LIST[8] .. "0\124t";
end

function DM_Util_PrintDebug(line)
   if debugPrintCount < debugPrintMax then
      print(line);
   end
end

function DM_Util_PrintDebugEnd(line)
   if debugPrintCount < debugPrintMax then
      print(line);
      debugPrintCount = debugPrintCount + 1;
   end
end

function DM_Util_PrintDebugNoLimit(line)
   if debugPrintEnabled then
      print(line);
   end
end

function DM_Util_PrintSystemMessage(m)
   if m then
      print("|cFF77A3CE<|cFFFF8040DM|cFF77A3CE> |cFFFF8040" .. tostring(m) .. "|r");
   end
end

function DM_Util_DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function DM_Util_NpcIdFromGuid(guid)
   --print("DM_Util_NpcIdFromGuid: " .. tostring(guid));
   if not guid then
      print("DM_Util_NpcIdFromGuid: error, guid is nil");
      return;
   end

   local npcId, _ = select(6, strsplit("-", guid));

   return tonumber(npcId);
end

function DM_Util_NpcId(unitId)
   local g = UnitGUID(unitId);
   
   if g == nil then
      return nil;
   end

   local npcId, _ = select(6, strsplit("-", g));

   return tonumber(npcId);
end

function DM_Util_ShortGuid(guid)
   if guid == nil then
      return "";
   end

   return select(6, strsplit("-", guid)) .. "-" .. select(7, strsplit("-", guid));
end
 
function DM_Util_NpcIdByUnitId(unitId)
   local g = UnitGUID(unitId);

   if g == nil then
      return nil;
   end

   local npcId, _ = select(6, strsplit("-", g));

   return tonumber(npcId);
end

function DM_Util_NpcIdStr(unitId)
   local g = UnitGUID(unitId);

   if g == nil then
      return "";
   end

   local npcId, _ = select(6, strsplit("-", g));

   return npcId;
end

function DM_Util_FormatTimeDisplay(t)
   if t > 10*60 then -- greater than 10 mins, only show minutes
      return tostring(floor(t/60)) .. "m";-- .. tostring(floor(t%60)) .. "s";
   elseif t >= 61 then -- greater than a minute, show mins/secs
      return tostring(floor(t/60)) .. "m " .. tostring(floor(t%60)) .. "s";
   else -- otherwise show seconds/ms
      return string.format("%.2fs", t);
   end
end

function DM_Util_FormatLine(text, unitId, unitName, spellId, spellName, stackCount, misc1, misc2, misc3)
   local m = text;

   if unitId ~= nil then
      m = string.gsub(m, "$uid", unitId);
   end
   if unitName ~= nil then
      m = string.gsub(m, "$unm", unitName);
   end
   if spellId ~= nil then
      m = string.gsub(m, "$spi", spellId);
      m = string.gsub(m, "$spl", GetSpellLink(spellId));
   end
   if spellName ~= nil then
      m = string.gsub(m, "$spn", spellName);
   end
   if stackCount ~= nil then
      m = string.gsub(m, "$stk", stackCount);
   end
   if misc1 ~= nil then
      m = string.gsub(m, "$m1", misc1);
   end
   if misc2 ~= nil then
      m = string.gsub(m, "$m2", misc2);
   end
   if misc3 ~= nil then
      m = string.gsub(m, "$m3", misc3);
   end

   return m;
end

--function StringEndsWith(str, suffix)
--   return suffix == "" or str.sub(-#suffix) == suffix;
--end

function DM_Util_SplitString(str, d)
   d = d or ",";
   
   local result = {};

   -- bad argument here in gmatch when i got invited to a group
   -- 'string expected got nil'
   for f,s in string.gmatch(str, "([^"..d.."]*)("..d.."?)") do
      table.insert(result, f);
      if s == "" then
         return result;
      end
   end
   
   return result;
end

function DM_Util_stringifyObject(o)
   --print("dump type: " .. type(o));
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. stringifyObject(v) .. ','
      end
      return s .. '} '
   else
      if type(o) == 'string' then
         return '"' .. tostring(o) .. '"'
      else
         return tostring(o)
      end
   end
end

-- http://lua-users.org/wiki/BaseSixtyFour

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function DM_Util_Base64_Encode(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function DM_Util_Base64_Decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function DM_Util_StringToTable(str)
   local t = {}
   for i = 1, #str do
       t[i] = str:sub(i, i)
   end

   return t;
end

function DM_Util_SafeFormat(input)
   local str = string.format("%q", input)
   return (str:gsub("%-%-", "-\\-"))
end

function StringContains(str, sub)
   return str ~= nil and string.find(str, sub) ~= nil;
end

function StringStartsWith(str, s2)
   return str ~= nil and string.find(str, s2) == 1;
end

function IsGuidPlayer(guid)
   return guid ~= nil and StringStartsWith(guid, "Player");
end

-- https://wowwiki-archive.fandom.com/wiki/InstanceMapID
function DM_Util_GetCurrentZoneId()
   return select(8,GetInstanceInfo());
end

-- i love how i wrote these then promptly ignored them almost everywhere
function DM_Util_CreateList()
   return { size = 0, items = {}};
end

function DM_Util_AddItemToList(list, item)
   list[list.size+1] = item;
   list.size = list.size+1;
end

function DM_Util_RemoveLastItemFromList(list)
   local item = list[list.size];

   list[list.size] = nil;
   list.size = list.size - 1;
   
   return item;
end

function DM_Util_ClearList(list)
   list.size = 0;
   list.items = {};
end

function DM_Util_ConvertSecondsToUnits(timestamp)
	timestamp = math.max(timestamp, 0);
	local days = math.floor(timestamp / (24*60*60));
	timestamp = timestamp - (days * (24*60*60));
	local hours = math.floor(timestamp / (60*60));
	timestamp = timestamp - (hours * (60*60));
	local minutes = math.floor(timestamp / (60));
	timestamp = timestamp - (minutes * (60));
	local seconds = math.floor(timestamp);
	local milliseconds = timestamp - seconds;
	return {
		days=days,
		hours=hours,
		minutes=minutes,
		seconds=seconds,
		milliseconds=milliseconds,
	}
end

function DM_Util_SecondsToClock(seconds, displayZeroHours)
	local units = DM_Util_ConvertSecondsToUnits(seconds);
	if units.hours > 0 or displayZeroHours then
		return format("%2d:%02d:%02d", units.hours, units.minutes, units.seconds);
	else
      -- certain case where %02d is not adding the extra 0 padding,
      -- we'll cheese this until we figure out the formatting issue
      --
		-- return format("%2d:%02d", units.minutes, units.seconds);
      if units.seconds < 10 then
         return tostring(units.minutes) .. ":0" .. tostring(units.seconds);
      else
         return tostring(units.minutes) .. ":" .. tostring(units.seconds);
      end
	end
end

--local worldStateTimerId = nil;

function DM_Util_GetWorldStateTimerId()
   return 1; -- TODO: revisit this, should be able to reliably get it at dungeon start but most everyone is working with assumption there's only one timer and it always had id 1
end

function DM_Util_GetWorldStateTimer_Elapsed()
   local _, elapsedTime, type = GetWorldElapsedTime(DM_Util_GetWorldStateTimerId());

   return elapsedTime;
end

function DM_Util_IsDungeonNormal()
   local diffId = GetDungeonDifficultyID();

   return diffId == 1;
end

function DM_Util_IsDungeonHeroic()
   local diffId = GetDungeonDifficultyID();

   return diffId == 2;
end

function DM_Util_IsDungeonMythic()
   local diffId = GetDungeonDifficultyID();

   return diffId == 23;
end
