local EVERBLOOM_AREA_COUNT = 9;
local EVERBLOOM_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Entrance",
        locationHint = "Near entrance portal",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Right Path",
        locationHint = "Right at fork in road after entrance",
        floorIndex = 1
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "Spider",
        locationHint = "Road to spider boss and spider boss",
        floorIndex = 1
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "Archmage Sol",
        locationHint = "Area around and including Archmage Sol",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "Left Path",
        locationHint = "Left at fork in road after entrance",
        floorIndex = 1
    },
    ["area#6"] = {
        areaIndex = 6,
        name = "Witherbark",
        locationHint = "Witherbark boss and nearby groups",
        floorIndex = 1
    },
    ["area#7"] = {
        areaIndex = 7,
        name = "North of Witherbark",
        locationHint = "Road north of Witherbark",
        floorIndex = 1
    },
    ["area#8"] = {
        areaIndex = 8,
        name = "Yalnu",
        locationHint = "Yalnu boss, through portal after defeating all other bosses",
        floorIndex = 2
    },
}

local EVERBLOOM_NPCS = {
    size = 24,
    items = {
        [1] = {
            ["npcid"] = 81819,
            ["name"] = "Everbloom Naturalist",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [2] = {
            ["npcid"] = 81820,
            ["name"] = "Everbloom Mender",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [3] = {
            ["npcid"] = 81864,
            ["name"] = "Dreadpetal",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 82039,
            ["name"] = "Rockspine Stinger",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 84767,
            ["name"] = "Twisted Abomination",
            ["type"] = "",
            ["forceCount"] = 8,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 84957,
            ["name"] = "Putrid Pyromancer",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [7] = {
            ["npcid"] = 84989,
            ["name"] = "Infested Icecaller",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 84990,
            ["name"] = "Addled Arcanomancer",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 86372,
            ["name"] = "Melded Berserker",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 81522,
            ["name"] = "Witherbark",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [11] = {
            ["npcid"] = 82682,
            ["name"] = "Archmage Sol",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [12] = {
            ["npcid"] = 83846,
            ["name"] = "Yalnu",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [13] = {
            ["npcid"] = 81985,
            ["name"] = "Everbloom Cultivator",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 212981,
            ["name"] = "Hapless Assistant",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 83892,
            ["name"] = "Life Warden Gola",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [16] = {
            ["npcid"] = 83893,
            ["name"] = "Earthshaper Telu",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [17] = {
            ["npcid"] = 83894,
            ["name"] = "Dulhu",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [18] = {
            ["npcid"] = 81984,
            ["name"] = "Gnarlroot",
            ["type"] = "",
            ["forceCount"] = 25,
            ["count"] = 0,
        },
        [19] = {
            ["npcid"] = 84550,
            ["name"] = "Xeri'tac",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [20] = {
            ["npcid"] = 84552,
            ["name"] = "Toxic Spiderling",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 85232,
            ["name"] = "Infested Venomfang",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 86547,
            ["name"] = "Venom Sprayer",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 84554,
            ["name"] = "Venom-Crazed Pale One",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [24] = {
            ["npcid"] = 84666,
            ["name"] = "Xeri'tac",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
    }
}

EVERBLOOM_INDEX_MAP = {
    EVERBLOOM_NATURALIST_81819 = 1,
    [81819] = 1,
    EVERBLOOM_MENDER_81820 = 2,
    [81820] = 2,
    DREADPETAL_81864 = 3,
    [81864] = 3,
    ROCKSPINE_STINGER_82039 = 4,
    [82039] = 4,
    TWISTED_ABOMINATION_84767 = 5,
    [84767] = 5,
    PUTRID_PYROMANCER_84957 = 6,
    [84957] = 6,
    INFESTED_ICECALLER_84989 = 7,
    [84989] = 7,
    ADDLED_ARCANOMANCER_84990 = 8,
    [84990] = 8,
    MELDED_BERSERKER_86372 = 9,
    [86372] = 9,
    WITHERBARK_81522 = 10,
    [81522] = 10,
    ARCHMAGE_SOL_82682 = 11,
    [82682] = 11,
    YALNU_83846 = 12,
    [83846] = 12,
    EVERBLOOM_CULTIVATOR_81985 = 13,
    [81985] = 13,
    HAPLESS_ASSISTANT_212981 = 14,
    [212981] = 14,
    LIFE_WARDEN_GOLA_83892 = 15,
    [83892] = 15,
    EARTHSHAPER_TELU_83893 = 16,
    [83893] = 16,
    DULHU_83894 = 17,
    [83894] = 17,
    GNARLROOT_81984 = 18,
    [81984] = 18,
    XERITAC_84550 = 19,
    [84550] = 19,
    TOXIC_SPIDERLING_84552 = 20,
    [84552] = 20,
    INFESTED_VENOMFANG_85232 = 21,
    [85232] = 21,
    VENOM_SPRAYER_86547 = 22,
    [86547] = 22,
    VENOMCRAZED_PALE_ONE_84554 = 23,
    [84554] = 23,
    XERITAC_84666 = 24,
    [84666] = 24,
}

local EVERBLOOM_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=805,y=439}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["B"] = {metadata={position={x=786,y=424}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["C"] = {metadata={position={x=792,y=380}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 1,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=770,y=353}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["B"] = {metadata={position={x=741,y=339}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["C"] = {metadata={position={x=778,y=334}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1, [EVERBLOOM_INDEX_MAP.TWISTED_ABOMINATION_84767] = 1,}},
                ["D"] = {metadata={position={x=767,y=311}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["E"] = {metadata={position={x=768,y=294}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["F"] = {metadata={position={x=744,y=298}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["G"] = {metadata={position={x=764,y=278}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1,}},
                ["H"] = {metadata={position={x=738,y=265}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 2,}},
                ["I"] = {metadata={position={x=761,y=251}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["J"] = {metadata={position={x=783,y=265}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["K"] = {metadata={position={x=805,y=295}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["L"] = {metadata={position={x=805,y=273}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["M"] = {metadata={position={x=805,y=249}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.TWISTED_ABOMINATION_84767] = 1,}},
                ["N"] = {metadata={position={x=777,y=225}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["O"] = {metadata={position={x=812,y=222}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["P"] = {metadata={position={x=832,y=205}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["Q"] = {metadata={position={x=808,y=187}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["R"] = {metadata={position={x=785,y=178}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1, [EVERBLOOM_INDEX_MAP.TWISTED_ABOMINATION_84767] = 1,}},
                ["S"] = {metadata={position={x=777,y=137}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["T"] = {metadata={position={x=764,y=154}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["U"] = {metadata={position={x=745,y=134}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.MELDED_BERSERKER_86372] = 1,}},
                ["V"] = {metadata={position={x=758,y=181}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.TWISTED_ABOMINATION_84767] = 1,}},
                ["W"] = {metadata={position={x=728,y=173}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.LIFE_WARDEN_GOLA_83892] = 1, [EVERBLOOM_INDEX_MAP.DULHU_83894] = 1, [EVERBLOOM_INDEX_MAP.EARTHSHAPER_TELU_83893] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=688,y=112}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=643,y=189}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.INFESTED_ICECALLER_84989] = 1, [EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 2,}},
                ["B"] = {metadata={position={x=662,y=220}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["C"] = {metadata={position={x=647,y=236}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["D"] = {metadata={position={x=627,y=240}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["E"] = {metadata={position={x=635,y=212}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.PUTRID_PYROMANCER_84957] = 1,}},
                ["F"] = {metadata={position={x=605,y=239}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.ADDLED_ARCANOMANCER_84990] = 1, [EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 2,}},
                ["G"] = {metadata={position={x=666,y=246}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["H"] = {metadata={position={x=683,y=261}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["I"] = {metadata={position={x=678,y=285}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 2,}},
                ["J"] = {metadata={position={x=649,y=274}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.ADDLED_ARCANOMANCER_84990] = 1, [EVERBLOOM_INDEX_MAP.PUTRID_PYROMANCER_84957] = 1, [EVERBLOOM_INDEX_MAP.INFESTED_ICECALLER_84989] = 1,}},
                ["K"] = {metadata={position={x=620,y=271}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ARCHMAGE_SOL_82682] = 1,}},
                ["L"] = {metadata={position={x=579,y=249}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["M"] = {metadata={position={x=579,y=225}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["N"] = {metadata={position={x=543,y=228}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["O"] = {metadata={position={x=553,y=249}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 1,}},
                ["P"] = {metadata={position={x=581,y=282}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.HAPLESS_ASSISTANT_212981] = 2,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=722,y=356}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["B"] = {metadata={position={x=743,y=377}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["C"] = {metadata={position={x=708,y=384}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["D"] = {metadata={position={x=703,y=399}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["E"] = {metadata={position={x=698,y=414}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1,}},
                ["F"] = {metadata={position={x=740,y=400}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["G"] = {metadata={position={x=733,y=426}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["H"] = {metadata={position={x=710,y=438}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.GNARLROOT_81984] = 1,}},
                ["I"] = {metadata={position={x=743,y=446}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["J"] = {metadata={position={x=720,y=460}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 3,}},
                ["K"] = {metadata={position={x=699,y=477}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["L"] = {metadata={position={x=766,y=458}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["M"] = {metadata={position={x=766,y=481}, uniqueMobs=3}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1, [EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["N"] = {metadata={position={x=738,y=490}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1,}},
                ["O"] = {metadata={position={x=743,y=506}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["P"] = {metadata={position={x=718,y=497}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.ROCKSPINE_STINGER_82039] = 1,}},
                ["Q"] = {metadata={position={x=693,y=506}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["R"] = {metadata={position={x=660,y=426}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["S"] = {metadata={position={x=650,y=468}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1,}},
                ["T"] = {metadata={position={x=657,y=487}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_CULTIVATOR_81985] = 1,}},
                ["U"] = {metadata={position={x=643,y=504}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
            },
        },
        ["area#6"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=624,y=417}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 1, [EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["B"] = {metadata={position={x=602,y=435}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 2, [EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["C"] = {metadata={position={x=571,y=442}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 2, [EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["D"] = {metadata={position={x=569,y=400}, uniqueMobs=2}, mobs={[EVERBLOOM_INDEX_MAP.EVERBLOOM_NATURALIST_81819] = 2, [EVERBLOOM_INDEX_MAP.EVERBLOOM_MENDER_81820] = 1,}},
                ["E"] = {metadata={position={x=591,y=408}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.WITHERBARK_81522] = 1,}},
            },
        },
        ["area#7"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=622,y=334}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
                ["B"] = {metadata={position={x=643,y=360}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.DREADPETAL_81864] = 5,}},
            },
        },
        ["area#8"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=504,y=614}, uniqueMobs=1}, mobs={[EVERBLOOM_INDEX_MAP.YALNU_83846] = 1,}},
            },
        },
    }
}

local EVERBLOOM_TOTAL_FORCES = 444;

EVERBLOOM_PRIORITY_ABILITIES = {
}

-- scenario objects
-- #1: witherbark
-- #2: ancient protectors
-- #3: archmage sol
-- #4: yalnu

function DM_Dungeons_GetEverbloomContext()
   return {
      name="The Everbloom",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 644,
         xOffset = 0,
         yOffset = 4,
         floorCount = 2,
         floorMapInfo = {
            [1] = {name="The Everbloom", mapFolder="OvergrownOutpost", mapTilePrefix="OvergrownOutpost"},
            [2] = {name="The Overlook", mapFolder="OvergrownOutpost", mapTilePrefix="OvergrownOutpost1_"},
         }
      },
      zoneId=1279,
      timer=33*60, -- 33:00
      requiredForceCount=300,
      totalForceCount=EVERBLOOM_TOTAL_FORCES,
      totalMobGroups=0,
      areaCount=EVERBLOOM_AREA_COUNT,
      areas=EVERBLOOM_MAP_AREAS,
      mapMarkers=EVERBLOOM_MAP_MARKERS,
      --mobGroups=EVERBLOOM_MOB_GROUPS,
      npcs=EVERBLOOM_NPCS,
      --mobGroupPositions=EVERBLOOM_GROUP_POSITIONS,
      mobIndexMap=EVERBLOOM_INDEX_MAP,
      --envMarkers=EVERBLOOM_POI,
      abilities=EVERBLOOM_ABILITIES,
      abilitiesByMob=EVERBLOOM_BY_MOB,
      neighbors=EVERBLOOM_GROUP_NEIGHBORS,
      priorityAbilities=EVERBLOOM_PRIORITY_ABILITIES
   };
end
