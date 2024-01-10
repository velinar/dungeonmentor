local DARKHEART_AREA_COUNT = 11;
local DARKHEART_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "Uncategorized",
        floorIndex = 2
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Start, Main Road",
        locationHint = "Road from entrance to first boss",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Rotting Grotto",
        locationHint = "Rotting Groto, off main road",
        floorIndex = 1
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "Back to Main Road",
        locationHint = "Off main road, other side from Rotting Grotto",
        floorIndex = 1
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "South on Main Road",
        locationHint = "First Boss",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "Fountain, North on Main Road",
        locationHint = "Road from fountain to second boss",
        floorIndex = 1
    },
    ["area#6"] = {
        areaIndex = 6,
        name = "Oakheart Boss",
        locationHint = "Immediate area around Oakheart",
        floorIndex = 1
    },
    ["area#7"] = {
        areaIndex = 7,
        name = "Right at Fork",
        locationHint = "Brief dip into right fork after Oakheart",
        floorIndex = 1
    },
    ["area#8"] = {
        areaIndex = 8,
        name = "River",
        locationHint = "River to third boss",
        floorIndex = 1
    },
    ["area#9"] = {
        areaIndex = 9,
        name = "Bloodseekers",
        locationHint = "Bloodseekers pack, to right of downed tree",
        floorIndex = 1
    },
    ["area#10"] = {
        areaIndex = 10,
        name = "Into the Heart of Dread",
        locationHint = "Left of downed tree, headed toward Xavius",
        floorIndex = 1
    },
}

local DARKHEART_NPCS = {
    size = 27,
    items = {
        [1] = {
            ["npcid"] = 100526,
            ["name"] = "Tormented Bloodseeker",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [2] = {
            ["npcid"] = 100527,
            ["name"] = "Dreadfire Imp",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [3] = {
            ["npcid"] = 100529,
            ["name"] = "Hatespawn Slime",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 100531,
            ["name"] = "Bloodtainted Fury",
            ["type"] = "",
            ["forceCount"] = 8,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 100532,
            ["name"] = "Bloodtainted Burster",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 100533,
            ["name"] = "Corrupted Egg",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [7] = {
            ["npcid"] = 100539,
            ["name"] = "Taintheart Deadeye",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 101074,
            ["name"] = "Hatespawn Whelpling",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 101679,
            ["name"] = "Dreadsoul Poisoner",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 101991,
            ["name"] = "Nightmare Dweller",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 107638,
            ["name"] = "Druidic Preserver",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 108460,
            ["name"] = "Injured Preserver Druid",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [13] = {
            ["npcid"] = 95766,
            ["name"] = "Crazed Razorbeak",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 95769,
            ["name"] = "Mindshattered Screecher",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 95771,
            ["name"] = "Dreadsoul Ruiner",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [16] = {
            ["npcid"] = 95772,
            ["name"] = "Frenzied Nightclaw",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 95779,
            ["name"] = "Festerhide Grizzly",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 96512,
            ["name"] = "Archdruid Glaidalis",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [19] = {
            ["npcid"] = 99192,
            ["name"] = "Shade of Xavius",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [20] = {
            ["npcid"] = 99200,
            ["name"] = "Dresaron",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [21] = {
            ["npcid"] = 99358,
            ["name"] = "Rotheart Dryad",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 99359,
            ["name"] = "Rotheart Keeper",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 99360,
            ["name"] = "Vilethorn Blossom",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [24] = {
            ["npcid"] = 99365,
            ["name"] = "Taintheart Stalker",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [25] = {
            ["npcid"] = 99366,
            ["name"] = "Taintheart Summoner",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [26] = {
            ["npcid"] = 101329,
            ["name"] = "Nightmare Bindings",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [27] = {
            ["npcid"] = 103344,
            ["name"] = "Oakheart",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
    }
}

DARKHEART_INDEX_MAP = {
    TORMENTED_BLOODSEEKER_100526 = 1,
    [100526] = 1,
    DREADFIRE_IMP_100527 = 2,
    [100527] = 2,
    HATESPAWN_SLIME_100529 = 3,
    [100529] = 3,
    BLOODTAINTED_FURY_100531 = 4,
    [100531] = 4,
    BLOODTAINTED_BURSTER_100532 = 5,
    [100532] = 5,
    CORRUPTED_EGG_100533 = 6,
    [100533] = 6,
    TAINTHEART_DEADEYE_100539 = 7,
    [100539] = 7,
    HATESPAWN_WHELPLING_101074 = 8,
    [101074] = 8,
    DREADSOUL_POISONER_101679 = 9,
    [101679] = 9,
    NIGHTMARE_DWELLER_101991 = 10,
    [101991] = 10,
    DRUIDIC_PRESERVER_107638 = 11,
    [107638] = 11,
    INJURED_PRESERVER_DRUID_108460 = 12,
    [108460] = 12,
    CRAZED_RAZORBEAK_95766 = 13,
    [95766] = 13,
    MINDSHATTERED_SCREECHER_95769 = 14,
    [95769] = 14,
    DREADSOUL_RUINER_95771 = 15,
    [95771] = 15,
    FRENZIED_NIGHTCLAW_95772 = 16,
    [95772] = 16,
    FESTERHIDE_GRIZZLY_95779 = 17,
    [95779] = 17,
    ARCHDRUID_GLAIDALIS_96512 = 18,
    [96512] = 18,
    SHADE_OF_XAVIUS_99192 = 19,
    [99192] = 19,
    DRESARON_99200 = 20,
    [99200] = 20,
    ROTHEART_DRYAD_99358 = 21,
    [99358] = 21,
    ROTHEART_KEEPER_99359 = 22,
    [99359] = 22,
    VILETHORN_BLOSSOM_99360 = 23,
    [99360] = 23,
    TAINTHEART_STALKER_99365 = 24,
    [99365] = 24,
    TAINTHEART_SUMMONER_99366 = 25,
    [99366] = 25,
    NIGHTMARE_BINDINGS_101329 = 26,
    [101329] = 26,
    OAKHEART_103344 = 27,
    [103344] = 27,
}

local DARKHEART_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=410,y=173}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 1, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 2,}},
                ["B"] = {metadata={position={x=373,y=188}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 1, [DARKHEART_INDEX_MAP.MINDSHATTERED_SCREECHER_95769] = 3,}},
                ["C"] = {metadata={position={x=347,y=189}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771] = 2,}},
                ["D"] = {metadata={position={x=322,y=200}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 1,}},
                ["E"] = {metadata={position={x=383,y=131}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 1,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=298,y=141}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 1,}, mutexMobs={size=2,items={[1]={display="Dreadsoul Poisoner/Ruiner",option1=DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679,option2=DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771},[2]={display="Dreadsoul Poisoner/Ruiner",option1=DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679,option2=DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771},}}},
                ["B"] = {metadata={position={x=269,y=184}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.CRAZED_RAZORBEAK_95766] = 2,}, mutexMobs={size=1,items={[1]={display="Dreadsoul Poisoner/Ruiner",option1=DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679,option2=DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771},}}},
                ["C"] = {metadata={position={x=195,y=150}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 2,}},
                ["D"] = {metadata={position={x=173,y=199}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 2, [DARKHEART_INDEX_MAP.CRAZED_RAZORBEAK_95766] = 2,}},
                ["E"] = {metadata={position={x=196,y=214}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 1, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 2,}},
                ["F"] = {metadata={position={x=237,y=260}, uniqueMobs=3}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 2, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 1, [DARKHEART_INDEX_MAP.MINDSHATTERED_SCREECHER_95769] = 1,}},
                ["G"] = {metadata={position={x=264,y=228}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 2, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 2,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=291,y=243}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 1, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 2,}},
                ["B"] = {metadata={position={x=329,y=237}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 1,}},
                ["C"] = {metadata={position={x=352,y=281}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 2,}},
                ["D"] = {metadata={position={x=313,y=294}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771] = 2, [DARKHEART_INDEX_MAP.FRENZIED_NIGHTCLAW_95772] = 2,}},
                ["E"] = {metadata={position={x=278,y=306}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_POISONER_101679] = 2,}},
                ["F"] = {metadata={position={x=300,y=340}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.DREADSOUL_RUINER_95771] = 1, [DARKHEART_INDEX_MAP.MINDSHATTERED_SCREECHER_95769] = 1,}},
                ["G"] = {metadata={position={x=285,y=402}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.FESTERHIDE_GRIZZLY_95779] = 2,}},
                ["H"] = {metadata={position={x=271,y=445}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.ARCHDRUID_GLAIDALIS_96512] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=279,y=566}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 2,}},
                ["B"] = {metadata={position={x=307,y=573}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_DRYAD_99358] = 1,}},
                ["C"] = {metadata={position={x=326,y=608}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_DRYAD_99358] = 1,}},
                ["D"] = {metadata={position={x=341,y=584}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_KEEPER_99359] = 1, [DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 2,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=380,y=610}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_DRYAD_99358] = 1, [DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 2,}},
                ["B"] = {metadata={position={x=425,y=643}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 4,}},
                ["C"] = {metadata={position={x=428,y=591}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_KEEPER_99359] = 2,}},
                ["D"] = {metadata={position={x=404,y=576}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 2,}},
                ["E"] = {metadata={position={x=477,y=479}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.ROTHEART_DRYAD_99358] = 1, [DARKHEART_INDEX_MAP.VILETHORN_BLOSSOM_99360] = 2,}},
            },
        },
        ["area#6"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=456,y=389}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.NIGHTMARE_DWELLER_101991] = 1,}},
                ["B"] = {metadata={position={x=515,y=401}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.NIGHTMARE_DWELLER_101991] = 1,}},
                ["C"] = {metadata={position={x=525,y=361}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.NIGHTMARE_DWELLER_101991] = 1,}},
                ["D"] = {metadata={position={x=425,y=363}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.NIGHTMARE_DWELLER_101991] = 1,}},
                ["E"] = {metadata={position={x=449,y=322}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.NIGHTMARE_DWELLER_101991] = 1,}},
                ["F"] = {metadata={position={x=490,y=342}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.OAKHEART_103344] = 1,}},
            },
        },
        ["area#7"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=577,y=355}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.TAINTHEART_DEADEYE_100539] = 2,}},
                ["B"] = {metadata={position={x=600,y=334}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.TAINTHEART_STALKER_99365] = 1,}},
                ["C"] = {metadata={position={x=585,y=405}, uniqueMobs=3}, mobs={[DARKHEART_INDEX_MAP.TAINTHEART_STALKER_99365] = 2, [DARKHEART_INDEX_MAP.TAINTHEART_SUMMONER_99366] = 1, [DARKHEART_INDEX_MAP.DREADFIRE_IMP_100527] = 1,}},
            },
        },
        ["area#8"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=546,y=285}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 8,}},
                ["B"] = {metadata={position={x=567,y=251}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 1,}},
                ["C"] = {metadata={position={x=594,y=269}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.BLOODTAINTED_FURY_100531] = 1, [DARKHEART_INDEX_MAP.BLOODTAINTED_BURSTER_100532] = 4,}},
                ["D"] = {metadata={position={x=652,y=248}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 8,}},
                ["E"] = {metadata={position={x=673,y=243}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 1,}},
                ["F"] = {metadata={position={x=690,y=286}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 8,}},
                ["G"] = {metadata={position={x=699,y=302}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.HATESPAWN_SLIME_100529] = 1,}},
                ["H"] = {metadata={position={x=727,y=303}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.BLOODTAINTED_FURY_100531] = 1, [DARKHEART_INDEX_MAP.BLOODTAINTED_BURSTER_100532] = 4,}},
                ["I"] = {metadata={position={x=743,y=338}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.DRESARON_99200] = 1,}},
            },
        },
        ["area#9"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=631,y=364}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.TORMENTED_BLOODSEEKER_100526] = 4,}},
            },
        },
        ["area#10"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=647,y=469}, uniqueMobs=2}, mobs={[DARKHEART_INDEX_MAP.TAINTHEART_SUMMONER_99366] = 1, [DARKHEART_INDEX_MAP.DREADFIRE_IMP_100527] = 2,}},
                ["B"] = {metadata={position={x=683,y=500}, uniqueMobs=3}, mobs={[DARKHEART_INDEX_MAP.TAINTHEART_SUMMONER_99366] = 1, [DARKHEART_INDEX_MAP.TAINTHEART_STALKER_99365] = 1, [DARKHEART_INDEX_MAP.DREADFIRE_IMP_100527] = 2,}},
                ["C"] = {metadata={position={x=738,y=544}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.TORMENTED_BLOODSEEKER_100526] = 4,}},
                ["D"] = {metadata={position={x=836,y=609}, uniqueMobs=5}, mobs={[DARKHEART_INDEX_MAP.TORMENTED_BLOODSEEKER_100526] = 1, [DARKHEART_INDEX_MAP.TAINTHEART_STALKER_99365] = 1, [DARKHEART_INDEX_MAP.TAINTHEART_SUMMONER_99366] = 1, [DARKHEART_INDEX_MAP.TAINTHEART_DEADEYE_100539] = 1, [DARKHEART_INDEX_MAP.DREADFIRE_IMP_100527] = 1,}},
                ["E"] = {metadata={position={x=899,y=638}, uniqueMobs=1}, mobs={[DARKHEART_INDEX_MAP.SHADE_OF_XAVIUS_99192] = 1,}},
            },
        },
    }
}

local DARKHEART_TOTAL_FORCES = 506;

DARKHEART_PRIORITY_ABILITIES = {
}

-- scenario objectives:
-- #1: archdruid glaidalis
-- #2: oakheart
-- #3: dresaron
-- #4: shade of xavius

function DM_Dungeons_GetDarkheartContext()
   return {
      name="Darkheart Thicket",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 743,
         xOffset = 0,
         yOffset = 4,
         floorCount = 1,
         floorMapInfo = {
            [1] = {name="Darkheart Thicket", mapFolder="DarkheartThicket", mapTilePrefix="DarkheartThicket"},
         }
      },
      zoneId=1466,
      timer=30*60, -- 30:00
      requiredForceCount=273,
      totalForceCount=DARKHEART_TOTAL_FORCES,
      totalMobGroups=0,
      --mobGroups=DARKHEART_MOB_GROUPS,
      areaCount=DARKHEART_AREA_COUNT,
      areas=DARKHEART_MAP_AREAS,
      mapMarkers=DARKHEART_MAP_MARKERS,
      npcs=DARKHEART_NPCS,
      --mobGroupPositions=DARKHEART_GROUP_POSITIONS,
      mobIndexMap=DARKHEART_INDEX_MAP,
      envMarkers=DARKHEART_POI,
      abilities=DARKHEART_ABILITIES,
      abilitiesByMob=DARKHEART_BY_MOB,
      neighbors=DARKHEART_GROUP_NEIGHBORS,
      priorityAbilities=DARKHEART_PRIORITY_ABILITIES
   };
end
