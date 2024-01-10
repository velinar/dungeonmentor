-- Dragonflight Season 1
local ZONE_ID_ALGETHAR_ACADEMY = 2526;
local ZONE_ID_AZURE_VAULT = 2515;
local ZONE_ID_NOKHUD_OFFENSIVE = 2516;
local ZONE_ID_RUBY_LIFE_POOLS = 2521;
local ZONE_ID_COURT_OF_STARS = 1571;
local ZONE_ID_HALLS_OF_VALOR = 1477;
local ZONE_ID_JADE_TEMPLE = 960;
local ZONE_ID_SHADOWMOON_BURIAL = 1176;

-- Dragonflight Season 2
local ZONE_ID_UNDERROT = 1841; -- 30:00
local ZONE_ID_VORTEX_PINNACLE = 657; -- 30:00
local ZONE_ID_HALLS_OF_INFUSION = 2527; -- 35:00
local ZONE_ID_BRACKENHIDE = 2520; -- 35:00
local ZONE_ID_NELTHARUS = 2519; -- 33:00
local ZONE_ID_FREEHOLD = 1754; -- 30:00
local ZONE_ID_NELTHARIONS_LAIR = 1458; -- 33:00
local ZONE_ID_TYR = 2451; -- 35:00

-- Dragonflight Season 3
local ZONE_ID_ATALDAZAR = 1763;
local ZONE_ID_BLACKROOK = 1501;
local ZONE_ID_DARKHEART = 1466;
local ZONE_ID_DAWN_ONE = 2579;
local ZONE_ID_DAWN_TWO = 2579; -- <=== problem. need disambiguator parameter
local ZONE_ID_EVERBLOOM = 1279;
local ZONE_ID_THRONE_TIDES = 643;
local ZONE_ID_WAYCREST  = 1862;

-- TODO: probably should be scoped to each season since indexes cannot be re-used
local dungeonIndexToZoneId = {
   --  [1] = ZONE_ID_ALGETHAR_ACADEMY,
   --  [2] = ZONE_ID_AZURE_VAULT,
   --  [3] = ZONE_ID_NOKHUD_OFFENSIVE,
   --  [4] = ZONE_ID_RUBY_LIFE_POOLS,
   --  [5] = ZONE_ID_COURT_OF_STARS,
   --  [6] = ZONE_ID_HALLS_OF_VALOR,
   --  [7] = ZONE_ID_JADE_TEMPLE,
   --  [8] = ZONE_ID_SHADOWMOON_BURIAL,
   --  [9] = ZONE_ID_UNDERROT
   [1] = ZONE_ID_ATALDAZAR,
   [2] = ZONE_ID_BLACKROOK,
   [3] = ZONE_ID_DARKHEART,
   [4] = ZONE_ID_DAWN_ONE,
   [5] = ZONE_ID_DAWN_TWO,
   [6] = ZONE_ID_EVERBLOOM,
   [7] = ZONE_ID_THRONE_TIDES,
   [8] = ZONE_ID_WAYCREST
};

local dungeonContext = {
   -- zoneId
   -- name
   -- dungeonNpcs
   -- npcIndexMap
   -- activeRoute
};

-- Ruby Life Pools	30
-- The Nokhud Offensive	40
-- The Azure Vaults	34
-- Algeth'ar Academy	32
-- Court of Stars	30
-- Halls of Valor	38
-- Shadowmoon Burial Grounds	33
-- Temple of the Jade Serpent	35

-- SEASON 3
-- Dawn of the Infinites: Galakrond's Fall
-- Dawn of the Infinites: Murozond's Rise
-- Darkheart Thicket (Legion)
-- Black Rook Hold (Legion)
-- Waycrest Manor (Battle for Azeroth)
-- Atal'Dazar (Battle for Azeroth)
-- Everbloom (Warlords of Draenor)
-- Throne of the Tides (Cataclysm)

local dungeonSeasons = {
   [10] = {
      [1] = {
         [1] = "",[2] = "",[3] = "",[4] = "",[5] = "",[6] = "",[7] = "",[8] = ""
      },
      [2] = {
         size = 8,
         items = {
            -- [1] = DM_Dungeons_GetBrackenhideContext(),
            -- [2] = DM_Dungeons_GetFreeholdContext(),
            -- [3] = DM_Dungeons_GetHallsOfInfusionContext(),
            -- [4] = DM_Dungeons_GetNeltharusContext(),
            -- [5] = DM_Dungeons_GetNelthLairContext(),
            -- [6] = DM_Dungeons_GetVortexPinnacleContext(),
            -- [7] = DM_Dungeons_GetLegacyOfTyrContext(),
            -- [8] = DM_Dungeons_GetUnderrotContext()
         }
      },
      [3] = {
         size = 8,
         items = { --6,4,3,1,2,7,8,5
            [1] = DM_Dungeons_GetAtalDazarContext(),
            [2] = DM_Dungeons_GetBlackRookContext(),
            [3] = DM_Dungeons_GetDarkheartContext(),
            [4] = DM_Dungeons_GetDawnPartOneContext(),
            [5] = DM_Dungeons_GetDawnPartTwoContext(),
            [6] = DM_Dungeons_GetEverbloomContext(),
            [7] = DM_Dungeons_GetThroneTidesContext(),
            [8] = DM_Dungeons_GetWaycrestContext()
         }
      }
   }
};

-- /script print(select(8,GetInstanceInfo()))
local dungeonZoneToIndex = {
   -- season 2
   [2520] = 1,
   [1754] = 2,
   [2527] = 3,
   [2519] = 4,
   [1458] = 5,
   [657] = 6,
   [2451] = 7,
   [1841] = 8,
   -- season 3
   [1763] = 1,
   [1501] = 2,
   [1466] = 3,
   [2579] = 4,
   -- [2579] = 5, -- keeping for clarity reasons but don't want this in here twice
   [1279] = 6,
   [643] = 7,
   [1862] = 8
};

function DM_Dungeons_ZoneIdToDungeonName(zoneId, zoneDiscriminator)
   if not zoneId or not dungeonZoneToIndex[zoneId] then
      return "Unknown (zone id is " .. tostring(zoneId) .. ")";
   end

   local index = dungeonZoneToIndex[zoneId];
   local delta = 0;

   if zoneDiscriminator and zoneDiscriminator == 2 then
       delta = 1;
   end

   local d = dungeonSeasons[10][3].items[index + delta];

   return d.name;
end

function DM_Dungeons_ZoneIdToDungeonIndex(zoneId, zoneDiscriminator)
   if not zoneId or not dungeonZoneToIndex[zoneId] then
      print("Unknown (zone id is " .. tostring(zoneId) .. ")");
      return nil;
   end

   local index = dungeonZoneToIndex[zoneId];
   local delta = 0;

   if zoneDiscriminator and zoneDiscriminator == 2 then
     delta = 1;
   end

   return index + delta;
end

local CURRENT_DUNGEON_SEASON = 3;
local zoneDiscriminator = 1;

function DM_Dungeons_GetSeasonContext(gameVersion, season)
    return dungeonSeasons[gameVersion][season];
end

function DM_Dungeons_GetCurrentSeasonContext()
    return DM_Dungeons_GetSeasonContext(10, CURRENT_DUNGEON_SEASON);
end

function DM_Dungeons_GetDungeonByIndex(index)
    return DM_Dungeons_GetCurrentSeasonContext().items[index];
end

function DM_Dungeons_GetZoneDiscriminator()
    return zoneDiscriminator;
end

function DM_Dungeons_SetZoneDiscriminator(d)
   if d ~= 1 and d ~= 2 then
      print("DM_Dungeons_SetZoneDiscriminator: invalid discriminator, defaulting to 1");
      zoneDiscriminator = 1;
   else
      zoneDiscriminator = d;
   end
end

function DM_Dungeons_GetDungeonContextByZone(zoneId, zd)
   -- local zoneId = DM_Util_GetCurrentZoneId();

   -- if zoneId == 657 then
   --    return dungeonSeasons[10][2].items[6];
   -- end
   -- if zoneId == 1458 then
   --    return dungeonSeasons[10][2].items[5];
   -- end
   -- if zoneId == 1841 then
   --    return dungeonSeasons[10][2].items[8];
   -- end

   if zoneId == ZONE_ID_DAWN_ONE then
      if zd == 2 then
         DM_Dungeons_GetDawnPartTwoContext();
      else
         DM_Dungeons_GetDawnPartOneContext();
      end
   end

   if dungeonZoneToIndex[zoneId] then
       return dungeonSeasons[10][CURRENT_DUNGEON_SEASON].items[dungeonZoneToIndex[zoneId]];
   end

   -- print("DM_Dungeons_GetDungeonByIndex - dungeon not found for zone: " .. tostring(zoneId));

   return nil;
end

function DM_Dungeons_GetDungeonContextByCurrentZone()
   local zoneId = DM_Util_GetCurrentZoneId();

   return DM_Dungeons_GetDungeonContextByZone(zoneId);

   -- if zoneId == 657 then
   --    return dungeonSeasons[10][2].items[6];
   -- end
   -- if zoneId == 1458 then
   --    return dungeonSeasons[10][2].items[5];
   -- end
   -- if zoneId == 1841 then
   --    return dungeonSeasons[10][2].items[8];
   -- end

   -- if zoneId == ZONE_ID_DAWN_ONE then
   --    if zoneDiscriminator == 2 then
   --       DM_Dungeons_GetDawnPartTwoContext();
   --    else
   --       DM_Dungeons_GetDawnPartOneContext();
   --    end
   -- end

   -- if dungeonZoneToIndex[zoneId] then
   --     return dungeonSeasons[10][CURRENT_DUNGEON_SEASON].items[dungeonZoneToIndex[zoneId]];
   -- end

   -- -- print("DM_Dungeons_GetDungeonByIndex - dungeon not found for zone: " .. tostring(zoneId));

   -- return nil;
end

function DM_Dungeons_LoadDungeon(zoneId)
   if zoneId == nil then
      print("DM_Dungeons_LoadDungeon: zoneId is nil, cannot load dungeon data");
   end

   -- DM_Dungeons_SetDungeonContextByZone(ZONE_ID_SHADOWMOON_BURIAL);
   DM_Dungeons_SetDungeonContextByZone(zoneId);
end

-- local ZONE_ID_BRACKENHIDE = 2520;
-- local ZONE_ID_HALLS_OF_INFUSION = 2527;
-- local ZONE_ID_NELTHARUS = 2519;
-- local ZONE_ID_LEGACY_OF_TYR = 2451;

function DM_Dungeons_SetDungeonContextByZone(zoneId)
   if zoneId == ZONE_ID_DAWN_ONE then
      if zoneDiscriminator == 2 then
         DM_Dungeons_GetDawnPartTwoContext();
      else
         DM_Dungeons_GetDawnPartTwoContext();
      end
      return;
   end

   dungeonContext = dungeonSeasons[10][CURRENT_DUNGEON_SEASON].items[dungeonZoneToIndex[zoneId]];

   -- TODO: Change this to a function reference to the specific dungeon data file
   -- if zoneID == 2520 then
   --    -- brackenhide
   --    dungeonContext.zoneId = 2520;
   --    dungeonContext.name = "Brackenhide Hollow";
   --    dungeonContext.activeRoute = DM_Dungeons_GetBrackenhideRoute1(); --DM_Dungeons_GetShadowmoonRoute1();
   --    dungeonContext.offRoute = {}; --DM_Dungeons_GetShadowmoonOffRoute1();
   --    dungeonContext.info = DM_Dungeons_GetShadowmoonData();
   --    -- function DM_Dungeons_GetBrackenhideData()
   --    --    return {
   --    --       npcs = BRACKENHIDE_NPCS,
   --    --       npcIndexMap = BRACKENHIDE_INDEX_MAP,
   --    --       pullGroups = BRACKENHIDE_MOB_GROUPS,
   --    --       timer = 35*60
   --    --    };
   --    -- end
   -- end

   -- if zoneId == ZONE_ID_SHADOWMOON_BURIAL then
   --    dungeonContext.zoneId = ZONE_ID_SHADOWMOON_BURIAL;
   --    dungeonContext.name = "Shadowmoon Burial Grounds";
   --    --dungeonContext.dungeonNpcs = DM_Dungeons_GetShadowmoonNpcs();
   --    --dungeonContext.npcIndexMap = DM_Dungeons_GetShadowmoonNpcIndexMap();
   --    dungeonContext.activeRoute = DM_Dungeons_GetShadowmoonRoute1();
   --    dungeonContext.offRoute = DM_Dungeons_GetShadowmoonOffRoute1();
   --    --dungeonContext.mobGroups = DM_Dungeons_GetShadowmoonMobGroups();
   --    --dungeonContext.timer = DM_Dungeons_GetShadowmoonTimer();
   --    dungeonContext.info = DM_Dungeons_GetShadowmoonData();
   -- end

   -- if zoneId == ZONE_ID_UNDERROT then
   --    dungeonContext.zoneId = ZONE_ID_UNDERROT;
   --    dungeonContext.name = "The Underrot";
   --    --dungeonContext.activeRoute = DM_Dungeons_GetShadowmoonRoute1();
   --    --dungeonContext.offRoute = DM_Dungeons_GetShadowmoonOffRoute1();
   --    --dungeonContext.timer = DM_Dungeons_GetShadowmoonTimer();
   --    dungeonContext.info = DM_Dungeons_GetUnderrotData();
   -- end

   -- if zoneId == ZONE_ID_NELTHARIONS_LAIR then
   --    dungeonContext.zoneId = ZONE_ID_NELTHARIONS_LAIR;
   --    dungeonContext.name = "Neltharion's Lair";
   --    --dungeonContext.activeRoute = DM_Dungeons_GetShadowmoonRoute1();
   --    --dungeonContext.offRoute = DM_Dungeons_GetShadowmoonOffRoute1();
   --    --dungeonContext.timer = DM_Dungeons_GetShadowmoonTimer();
   --    dungeonContext.info = DM_Dungeons_GetNelthLairContext();
   -- end
end

--DM_Dungeons_GetContext().
function DM_Dungeons_GetContext()
   return dungeonContext;
end

function DM_Dungeons_GetNpcs()
   return dungeonContext.info.npcs;
end

function DM_Dungeons_GetNpcIndexMap()
    return dungeonContext.info.npcIndexMap;
end

function DM_Dungeons_GetActiveRoute()
    return dungeonContext.activeRoute;
end

function DM_Dungeons_GetPullGroups()
   return dungeonContext.info.pullGroups;
end

function DM_Dungeons_GetOffRoute()
   return dungeonContext.offRoute;
end

function DM_Dungeons_GetTimer()
   return dungeonContext.timer;
end

function DM_Dungeons_DungeonMobsCount()
   if dungeonContext == nil or dungeonContext.dungeonNpcs == nil then
      -- DM_Chat_DebugPrint("DM_Dungeons_DungeonMobsCount() == 0");
      return 0;
   end

   -- DM_Chat_DebugPrint("DM_Dungeons_DungeonMobsCount() == " .. dungeonContext.dungeonNpcs.size);
   return DM_Dungeons_GetNpcs().size;
end

function DM_Dungeons_GetDungeonMob(mobIndex)
   return DM_Dungeons_GetNpcs().items[mobIndex];
end

function DM_Dungeons_IsMobSpawnable(mobIndex)
   return dungeonContext.dungeonNpcs.items[mobIndex].canSpawn == true;
end

function DM_Dungeons_FindMobByNpcId(npcId)
   if npcId == nil then
      DM_Chat_DebugPrint("nil npcId passed to FindMobByNpcId");
      return;
   end

   DM_Chat_DebugPrint("DM_Dungeons_FindMobByNpcId searching for npc id: " .. npcId);

   for i = 1, DM_Dungeons_DungeonMobsCount() do
      local mob = DM_Dungeons_GetDungeonMob(i);

      if mob.npcid == tonumber(npcId) then
         return mob;
      end
   end

   return nil;
end

local dungeonTimerStart = nil;
local dungeonTimerEnd = nil;

function DM_Dungeons_StartTimer(t)
   dungeonTimerStart = t;
end

function DM_Dungeons_StopTimer()
end

function DM_Dungeons_CurrentTimer()
end
