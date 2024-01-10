local ATALDAZAR_AREA_COUNT = 12;
local ATALDAZAR_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "No Area",
        locationHint = "Uncategorized",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "South, Top Path",
        locationHint = "Top left path from entrance",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "North, Top Path",
        locationHint = "Top right path from entrance",
        floorIndex = 1
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "South, Bottom Path",
        locationHint = "Bottom left path from entrance but not as far as center",
        floorIndex = 1
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "North, Bottom Path",
        locationHint = "Bottom right path from entrance but not as far as center",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "Totem Boss",
        locationHint = "Near/at totem boss",
        floorIndex = 1
    },
    ["area#6"] = {
        areaIndex = 6,
        name = "Totem Boss Stairs",
        locationHint = "South into stairs, after totem boss, or north toward totem boss",
        floorIndex = 1
    },
    ["area#7"] = {
        areaIndex = 7,
        name = "Center",
        locationHint = "Center",
        floorIndex = 1
    },
    ["area#8"] = {
        areaIndex = 8,
        name = "Priestess Stairs",
        locationHint = "North into stairs after princess, or south up to princess",
        floorIndex = 1
    },
    ["area#9"] = {
        areaIndex = 9,
        name = "Priestess Boss",
        locationHint = "South and up, near/at Priestess boss",
        floorIndex = 1
    },
    ["area#10"] = {
        areaIndex = 10,
        name = "Rezan Boss",
        locationHint = "Rezan Boss, entire bottom floor",
        floorIndex = 2
    },
    ["area#11"] = {
        areaIndex = 11,
        name = "Yazma Boss",
        locationHint = "Yazma Boss, west and up after other bosses are dead",
        floorIndex = 1
    },
}

local ATALDAZAR_NPCS = {
    size = 22,
    items = {
        [1] = {
            ["npcid"] = 122965,
            ["name"] = "Vol'kaal",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [2] = {
            ["npcid"] = 122968,
            ["name"] = "Yazma",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [3] = {
            ["npcid"] = 122969,
            ["name"] = "Zanchuli Witch-Doctor",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 122970,
            ["name"] = "Shadowblade Stalker",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 122971,
            ["name"] = "Dazar'ai Juggernaut",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 122972,
            ["name"] = "Dazar'ai Augur",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [7] = {
            ["npcid"] = 122973,
            ["name"] = "Dazar'ai Confessor",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 122984,
            ["name"] = "Dazar'ai Colossus",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 125977,
            ["name"] = "Reanimation Totem",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 127757,
            ["name"] = "Reanimated Honor Guard",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 127799,
            ["name"] = "Dazar'ai Honor Guard",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 127879,
            ["name"] = "Shieldbearer of Zul",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [13] = {
            ["npcid"] = 128434,
            ["name"] = "Feasting Skyscreamer",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 128455,
            ["name"] = "T'lonja",
            ["type"] = "",
            ["forceCount"] = 8,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 129552,
            ["name"] = "Monzumi",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [16] = {
            ["npcid"] = 129553,
            ["name"] = "Dinomancer Kish'o",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 135989,
            ["name"] = "Shieldbearer of Zul",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 122963,
            ["name"] = "Rezan",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [19] = {
            ["npcid"] = 122967,
            ["name"] = "Priestess Alun'za",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [20] = {
            ["npcid"] = 132126,
            ["name"] = "Gilded Priestess",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 127315,
            ["name"] = "Reanimation Totem",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 128435,
            ["name"] = "Toxic Saurid",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
    }
}

ATALDAZAR_INDEX_MAP = {
    VOLKAAL_122965 = 1,
    [122965] = 1,
    YAZMA_122968 = 2,
    [122968] = 2,
    ZANCHULI_WITCHDOCTOR_122969 = 3,
    [122969] = 3,
    SHADOWBLADE_STALKER_122970 = 4,
    [122970] = 4,
    DAZARAI_JUGGERNAUT_122971 = 5,
    [122971] = 5,
    DAZARAI_AUGUR_122972 = 6,
    [122972] = 6,
    DAZARAI_CONFESSOR_122973 = 7,
    [122973] = 7,
    DAZARAI_COLOSSUS_122984 = 8,
    [122984] = 8,
    REANIMATION_TOTEM_125977 = 9,
    [125977] = 9,
    REANIMATED_HONOR_GUARD_127757 = 10,
    [127757] = 10,
    DAZARAI_HONOR_GUARD_127799 = 11,
    [127799] = 11,
    SHIELDBEARER_OF_ZUL_127879 = 12,
    [127879] = 12,
    FEASTING_SKYSCREAMER_128434 = 13,
    [128434] = 13,
    TLONJA_128455 = 14,
    [128455] = 14,
    MONZUMI_129552 = 15,
    [129552] = 15,
    DINOMANCER_KISHO_129553 = 16,
    [129553] = 16,
    SHIELDBEARER_OF_ZUL_135989 = 17,
    [135989] = 17,
    REZAN_122963 = 18,
    [122963] = 18,
    PRIESTESS_ALUNZA_122967 = 19,
    [122967] = 19,
    GILDED_PRIESTESS_132126 = 20,
    [132126] = 20,
    REANIMATION_TOTEM_127315 = 21,
    [127315] = 21,
    TOXIC_SAURID_128435 = 22,
    [128435] = 22,
}

local ATALDAZAR_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=770,y=444}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_HONOR_GUARD_127799] = 2, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1,}},
                ["B"] = {metadata={position={x=765,y=493}, uniqueMobs=3}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_CONFESSOR_122973] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1,}},
                ["C"] = {metadata={position={x=778,y=536}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1,}},
                ["D"] = {metadata={position={x=748,y=533}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_CONFESSOR_122973] = 1,}},
                ["E"] = {metadata={position={x=736,y=511}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_CONFESSOR_122973] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_COLOSSUS_122984] = 1,}},
                ["F"] = {metadata={position={x=702,y=518}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1,}},
                ["G"] = {metadata={position={x=747,y=570}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 2, [ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_CONFESSOR_122973] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_COLOSSUS_122984] = 1,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=774,y=325}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.SHADOWBLADE_STALKER_122970] = 1,}},
                ["B"] = {metadata={position={x=776,y=305}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 1, [ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1,}},
                ["C"] = {metadata={position={x=764,y=231}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1, [ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 1, [ATALDAZAR_INDEX_MAP.SHIELDBEARER_OF_ZUL_127879] = 1, [ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 1,}},
                ["D"] = {metadata={position={x=727,y=220}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.SHIELDBEARER_OF_ZUL_127879] = 2,}},
                ["E"] = {metadata={position={x=708,y=193}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 1, [ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1, [ATALDAZAR_INDEX_MAP.SHIELDBEARER_OF_ZUL_127879] = 1, [ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 1,}},
                ["F"] = {metadata={position={x=676,y=207}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.SHADOWBLADE_STALKER_122970] = 2,}},
                ["G"] = {metadata={position={x=663,y=185}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.SHIELDBEARER_OF_ZUL_127879] = 2, [ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 1, [ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1, [ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=706,y=450}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
                ["B"] = {metadata={position={x=722,y=464}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=727,y=363}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
                ["B"] = {metadata={position={x=725,y=305}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=614,y=165}, uniqueMobs=3}, mobs={[ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 1, [ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 2, [ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1,}},
                ["B"] = {metadata={position={x=561,y=202}, uniqueMobs=3}, mobs={[ATALDAZAR_INDEX_MAP.REANIMATED_HONOR_GUARD_127757] = 2, [ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 1, [ATALDAZAR_INDEX_MAP.REANIMATION_TOTEM_127315] = 1,}},
                ["C"] = {metadata={position={x=613,y=118}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.VOLKAAL_122965] = 1,}},
            },
        },
        ["area#6"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=615,y=199}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.SHADOWBLADE_STALKER_122970] = 2,}},
                ["B"] = {metadata={position={x=612,y=234}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.ZANCHULI_WITCHDOCTOR_122969] = 2, [ATALDAZAR_INDEX_MAP.SHIELDBEARER_OF_ZUL_127879] = 2,}},
                ["C"] = {metadata={position={x=616,y=276}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1, [ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
            },
        },
        ["area#7"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=615,y=327}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1, [ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
                ["B"] = {metadata={position={x=659,y=361}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
                ["C"] = {metadata={position={x=660,y=381}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
                ["D"] = {metadata={position={x=639,y=396}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
                ["E"] = {metadata={position={x=615,y=409}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 5,}},
                ["F"] = {metadata={position={x=588,y=396}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
                ["G"] = {metadata={position={x=618,y=362}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.DINOMANCER_KISHO_129553] = 1, [ATALDAZAR_INDEX_MAP.TLONJA_128455] = 1, [ATALDAZAR_INDEX_MAP.MONZUMI_129552] = 1, [ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 4,}},
            },
        },
        ["area#8"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=617,y=454}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.TOXIC_SAURID_128435] = 4, [ATALDAZAR_INDEX_MAP.FEASTING_SKYSCREAMER_128434] = 1,}},
                ["B"] = {metadata={position={x=618,y=491}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 2, [ATALDAZAR_INDEX_MAP.DAZARAI_HONOR_GUARD_127799] = 2,}},
            },
        },
        ["area#9"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=681,y=587}, uniqueMobs=2}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1,}},
                ["B"] = {metadata={position={x=662,y=636}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.GILDED_PRIESTESS_132126] = 1,}},
                ["C"] = {metadata={position={x=616,y=630}, uniqueMobs=4}, mobs={[ATALDAZAR_INDEX_MAP.DAZARAI_HONOR_GUARD_127799] = 3, [ATALDAZAR_INDEX_MAP.GILDED_PRIESTESS_132126] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_JUGGERNAUT_122971] = 1, [ATALDAZAR_INDEX_MAP.DAZARAI_AUGUR_122972] = 1,}},
                ["D"] = {metadata={position={x=581,y=635}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.GILDED_PRIESTESS_132126] = 1,}},
                ["E"] = {metadata={position={x=616,y=659}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.PRIESTESS_ALUNZA_122967] = 1,}},
            },
        },
        ["area#10"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=613,y=329}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.REZAN_122963] = 1,}},
            },
        },
        ["area#11"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=395,y=363}, uniqueMobs=1}, mobs={[ATALDAZAR_INDEX_MAP.YAZMA_122968] = 1,}},
            },
        },
    }
}

local ATALDAZAR_TOTAL_FORCES = 340;

-- scenario objectives
-- #1: priestess alun'za
-- #2: vol'kaal
-- #3: rezan
-- #4: yazma

function DM_Dungeons_GetAtalDazarContext()
   return {
      name="Atal'Dazar",
      config = {
         SOURCE_MAP_WIDTH = 1122,
         SOURCE_MAP_HEIGHT = 744,
         xOffset = -6,
         yOffset = 0,
         floorCount = 2,
         floorMapInfo = {
            [1] = {name="Atal'Dazar", mapFolder="CityOfGold", mapTilePrefix="CityOfGold1_"},
            [2] = {name="Sacrificial Pits", mapFolder="CityOfGold", mapTilePrefix="CityOfGold2_"}
         }
      },
      zoneId=1763,
      timer=1800, -- 30:00
      requiredForceCount=225,
      totalForceCount=ATALDAZAR_TOTAL_FORCES, -- this number is wrong!, not 254
      totalMobGroups=0,
      areaCount=ATALDAZAR_AREA_COUNT,
      areas=ATALDAZAR_MAP_AREAS,
      mapMarkers=ATALDAZAR_MAP_MARKERS,
      --mobGroups=ATALDAZAR_MOB_GROUPS,
      npcs=ATALDAZAR_NPCS,
      --mobGroupPositions=ATALDAZAR_GROUP_POSITIONS,
      mobIndexMap=ATALDAZAR_INDEX_MAP, -- TODO: fix this
      --envMarkers=ATALDAZAR_POI,
      abilities=ATALDAZAR_ABILITIES,
      abilitiesByMob=ATALDAZAR_BY_MOB,
      neighbors=ATALDAZAR_GROUP_NEIGHBORS,
      priorityAbilities=ATALDAZAR_PRIORITY_ABILITIES
   };
end
