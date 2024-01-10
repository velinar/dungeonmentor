local THRONE_TIDES_AREA_COUNT = 6;
local THRONE_TIDES_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Entrance",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Up, to Lazy Naz'Jar",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "Back Down, Ulthok First",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "First Floor, East to Erunak",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "First Floor, West to Ozumat",
        locationHint = "TBD",
        floorIndex = 1
    },
}

local THRONE_TIDES_NPCS = {
    size = 26,
    items = {
        [1] = {
            ["npcid"] = 212673,
            ["name"] = "Naz'jar Ravager",
            ["type"] = "",
            ["forceCount"] = 25,
            ["count"] = 0,
        },
        [2] = {
            ["npcid"] = 212681,
            ["name"] = "Vicious Snap Dragon",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [3] = {
            ["npcid"] = 212775,
            ["name"] = "Faceless Seer",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 212778,
            ["name"] = "Minion of Ghur'sha",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 213607,
            ["name"] = "Deep Sea Murloc",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 213770,
            ["name"] = "Ink of Ozumat",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [7] = {
            ["npcid"] = 213806,
            ["name"] = "Splotch",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 213942,
            ["name"] = "Sludge",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 39616,
            ["name"] = "Naz'jar Invader",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 39960,
            ["name"] = "Deep Murloc Drudge",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 40577,
            ["name"] = "Naz'jar Sentinel",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 40586,
            ["name"] = "Lady Naz'jar",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [13] = {
            ["npcid"] = 40633,
            ["name"] = "Naz'jar Honor Guard",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 40634,
            ["name"] = "Naz'jar Tempest Witch",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 40788,
            ["name"] = "Mindbender Ghur'sha",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [16] = {
            ["npcid"] = 40923,
            ["name"] = "Unstable Corruption",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 40925,
            ["name"] = "Tainted Sentry",
            ["type"] = "",
            ["forceCount"] = 7,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 40935,
            ["name"] = "Gilgoblin Hunter",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [19] = {
            ["npcid"] = 40936,
            ["name"] = "Faceless Watcher",
            ["type"] = "",
            ["forceCount"] = 8,
            ["count"] = 0,
        },
        [20] = {
            ["npcid"] = 40943,
            ["name"] = "Gilgoblin Aquamage",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 41096,
            ["name"] = "Naz'jar Oracle",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 44404,
            ["name"] = "Naz'jar Frost Witch",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 45620,
            ["name"] = "Naz'jar Soldier",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [24] = {
            ["npcid"] = 40765,
            ["name"] = "Commander Ulthok",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [25] = {
            ["npcid"] = 40825,
            ["name"] = "Erunak Stonespeaker",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [26] = {
            ["npcid"] = 44566,
            ["name"] = "Ozumat",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
    }
}

THRONE_TIDES_INDEX_MAP = {
    NAZJAR_RAVAGER_212673 = 1,
    [212673] = 1,
    VICIOUS_SNAP_DRAGON_212681 = 2,
    [212681] = 2,
    FACELESS_SEER_212775 = 3,
    [212775] = 3,
    MINION_OF_GHURSHA_212778 = 4,
    [212778] = 4,
    DEEP_SEA_MURLOC_213607 = 5,
    [213607] = 5,
    INK_OF_OZUMAT_213770 = 6,
    [213770] = 6,
    SPLOTCH_213806 = 7,
    [213806] = 7,
    SLUDGE_213942 = 8,
    [213942] = 8,
    NAZJAR_INVADER_39616 = 9,
    [39616] = 9,
    DEEP_MURLOC_DRUDGE_39960 = 10,
    [39960] = 10,
    NAZJAR_SENTINEL_40577 = 11,
    [40577] = 11,
    LADY_NAZJAR_40586 = 12,
    [40586] = 12,
    NAZJAR_HONOR_GUARD_40633 = 13,
    [40633] = 13,
    NAZJAR_TEMPEST_WITCH_40634 = 14,
    [40634] = 14,
    MINDBENDER_GHURSHA_40788 = 15,
    [40788] = 15,
    UNSTABLE_CORRUPTION_40923 = 16,
    [40923] = 16,
    TAINTED_SENTRY_40925 = 17,
    [40925] = 17,
    GILGOBLIN_HUNTER_40935 = 18,
    [40935] = 18,
    FACELESS_WATCHER_40936 = 19,
    [40936] = 19,
    GILGOBLIN_AQUAMAGE_40943 = 20,
    [40943] = 20,
    NAZJAR_ORACLE_41096 = 21,
    [41096] = 21,
    NAZJAR_FROST_WITCH_44404 = 22,
    [44404] = 22,
    NAZJAR_SOLDIER_45620 = 23,
    [45620] = 23,
    COMMANDER_ULTHOK_40765 = 24,
    [40765] = 24,
    ERUNAK_STONESPEAKER_40825 = 25,
    [40825] = 25,
    OZUMAT_44566 = 26,
    [44566] = 26,
}

local THRONE_TIDES_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=560,y=548}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 2,}},
                ["B"] = {metadata={position={x=564,y=527}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 1, [THRONE_TIDES_INDEX_MAP.VICIOUS_SNAP_DRAGON_212681] = 3,}},
                ["C"] = {metadata={position={x=565,y=504}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 2,}},
                ["D"] = {metadata={position={x=556,y=411}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_SENTINEL_40577] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 2,}},
                ["E"] = {metadata={position={x=556,y=337}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_RAVAGER_212673] = 1, [THRONE_TIDES_INDEX_MAP.VICIOUS_SNAP_DRAGON_212681] = 2,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=565,y=554}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 2,}},
                ["B"] = {metadata={position={x=564,y=523}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.DEEP_MURLOC_DRUDGE_39960] = 10,}},
                ["C"] = {metadata={position={x=567,y=474}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 1,}},
                ["D"] = {metadata={position={x=563,y=436}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_SENTINEL_40577] = 2,}},
                ["E"] = {metadata={position={x=565,y=381}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 2,}},
                ["F"] = {metadata={position={x=541,y=336}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_RAVAGER_212673] = 1,}},
                ["G"] = {metadata={position={x=565,y=341}, uniqueMobs=4}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 1, [THRONE_TIDES_INDEX_MAP.VICIOUS_SNAP_DRAGON_212681] = 2,}},
                ["H"] = {metadata={position={x=620,y=322}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 2, [THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 1,}},
                ["I"] = {metadata={position={x=585,y=298}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.VICIOUS_SNAP_DRAGON_212681] = 6,}},
                ["J"] = {metadata={position={x=559,y=279}, uniqueMobs=4}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_SENTINEL_40577] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_INVADER_39616] = 2, [THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 1, [THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 1,}},
                ["K"] = {metadata={position={x=511,y=320}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.NAZJAR_ORACLE_41096] = 2, [THRONE_TIDES_INDEX_MAP.NAZJAR_TEMPEST_WITCH_40634] = 1,}},
                ["L"] = {metadata={position={x=563,y=179}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.LADY_NAZJAR_40586] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=567,y=320}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.COMMANDER_ULTHOK_40765] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=589,y=330}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_WATCHER_40936] = 1,}},
                ["B"] = {metadata={position={x=629,y=330}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_SEER_212775] = 1, [THRONE_TIDES_INDEX_MAP.MINION_OF_GHURSHA_212778] = 4,}},
                ["C"] = {metadata={position={x=650,y=331}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_WATCHER_40936] = 1,}},
                ["D"] = {metadata={position={x=713,y=324}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_SEER_212775] = 1, [THRONE_TIDES_INDEX_MAP.MINION_OF_GHURSHA_212778] = 3,}},
                ["E"] = {metadata={position={x=745,y=281}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_SEER_212775] = 2,}},
                ["F"] = {metadata={position={x=752,y=235}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.FACELESS_WATCHER_40936] = 2,}},
                ["G"] = {metadata={position={x=751,y=190}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.MINION_OF_GHURSHA_212778] = 6,}},
                ["H"] = {metadata={position={x=730,y=114}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.MINION_OF_GHURSHA_212778] = 3,}},
                ["I"] = {metadata={position={x=778,y=115}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.MINION_OF_GHURSHA_212778] = 3,}},
                ["J"] = {metadata={position={x=763,y=147}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.ERUNAK_STONESPEAKER_40825] = 1, [THRONE_TIDES_INDEX_MAP.MINDBENDER_GHURSHA_40788] = 1,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=523,y=334}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.GILGOBLIN_HUNTER_40935] = 4, [THRONE_TIDES_INDEX_MAP.GILGOBLIN_AQUAMAGE_40943] = 2,}},
                ["B"] = {metadata={position={x=461,y=331}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.GILGOBLIN_HUNTER_40935] = 2, [THRONE_TIDES_INDEX_MAP.GILGOBLIN_AQUAMAGE_40943] = 2,}},
                ["C"] = {metadata={position={x=431,y=330}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.TAINTED_SENTRY_40925] = 1,}},
                ["D"] = {metadata={position={x=385,y=310}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.TAINTED_SENTRY_40925] = 1,}},
                ["E"] = {metadata={position={x=363,y=272}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.GILGOBLIN_AQUAMAGE_40943] = 6,}},
                ["F"] = {metadata={position={x=363,y=216}, uniqueMobs=1}, mobs={[THRONE_TIDES_INDEX_MAP.TAINTED_SENTRY_40925] = 2,}},
                ["G"] = {metadata={position={x=372,y=150}, uniqueMobs=2}, mobs={[THRONE_TIDES_INDEX_MAP.INK_OF_OZUMAT_213770] = 1, [THRONE_TIDES_INDEX_MAP.OZUMAT_44566] = 1,}},
            },
        },
    }
}

local THRONE_TIDES_TOTAL_FORCES = 466;

-- scenario objectives
-- #1: lady naz'jar
-- #2: Commander Ulthok
-- #3: Erunak Stonespeaker / Mindbender Ghur'sha
-- #4: ozumat

function DM_Dungeons_GetThroneTidesContext()
   return {
      name="Throne of the Tides",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 743,
         xOffset = 0,
         yOffset = 4,
         floorCount = 2,
         floorMapInfo = {
            [1] = {name="Abyssal Halls", mapFolder="ThroneOfTides", mapTilePrefix="ThroneOfTides1_"},
            [2] = {name="Throne of Neptulon", mapFolder="ThroneOfTides", mapTilePrefix="ThroneOfTides2_"}
         }
      },
      zoneId=643,
      timer=34*60, -- 34:00
      requiredForceCount=430,
      totalForceCount=THRONE_TIDES_TOTAL_FORCES,
      totalMobGroups=0,
      areaCount=THRONE_TIDES_AREA_COUNT,
      areas=THRONE_TIDES_MAP_AREAS,
      mapMarkers=THRONE_TIDES_MAP_MARKERS,
      npcs=THRONE_TIDES_NPCS,
      mobIndexMap=THRONE_TIDES_INDEX_MAP,
      envMarkers=THRONE_TIDES_POI,
      abilities=THRONE_TIDES_ABILITIES,
      abilitiesByMob=THRONE_TIDES_BY_MOB,
      neighbors=THRONE_TIDES_GROUP_NEIGHBORS,
      priorityAbilities=THRONE_TIDES_PRIORITY_ABILITIES
   };
end
