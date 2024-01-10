local BLACKROOK_AREA_COUNT = 10;
local BLACKROOK_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Left Path (from entrance)",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Right Path (from entrance)",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#4"] = {
        areaIndex = 3,
        name = "Ascent from Chamber of War",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 4,
        name = "Second Ascent",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#6"] = {
        areaIndex = 5,
        name = "First Rocky Ascent",
        locationHint = "TBD",
        floorIndex = 3
    },
    ["area#7"] = {
        areaIndex = 6,
        name = "Second Rocky Ascent",
        locationHint = "TBD",
        floorIndex = 4
    },
    ["area#8"] = {
        areaIndex = 7,
        name = "Final Ascent",
        locationHint = "TBD",
        floorIndex = 5
    },
    ["area#9"] = {
        areaIndex = 8,
        name = "Final Boss",
        locationHint = "TBD",
        floorIndex = 6
    },
    ["area#3"] = {
        areaIndex = 9,
        name = "First Boss",
        locationHint = "TBD",
        floorIndex = 1
    },
}

local BLACKROOK_NPCS = {
    size = 30,
    items = {
        [1] = {
            ["npcid"] = 100436,
            ["name"] = "Illysanna Ravencrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 2,
        },
        [2] = {
            ["npcid"] = 100486,
            ["name"] = "Risen Arcanist",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [3] = {
            ["npcid"] = 100861,
            ["name"] = "Kur'talos Ravencrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 101549,
            ["name"] = "Arcane Minion",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 101839,
            ["name"] = "Risen Companion",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 102094,
            ["name"] = "Risen Swordsman",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [7] = {
            ["npcid"] = 102095,
            ["name"] = "Risen Lancer",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 98243,
            ["name"] = "Soul-Torn Champion",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 98275,
            ["name"] = "Risen Archer",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 98280,
            ["name"] = "Risen Arcanist",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 98366,
            ["name"] = "Ghostly Retainer",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 98368,
            ["name"] = "Ghostly Protector",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [13] = {
            ["npcid"] = 98370,
            ["name"] = "Ghostly Councilor",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 98521,
            ["name"] = "Lord Etheldrin Ravencrest",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 98542,
            ["name"] = "Amalgam of Souls",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 1,
        },
        [16] = {
            ["npcid"] = 98677,
            ["name"] = "Rook Spiderling",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 98681,
            ["name"] = "Rook Spinner",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 98691,
            ["name"] = "Risen Scout",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [19] = {
            ["npcid"] = 98706,
            ["name"] = "Commander Shemdah'sohn",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [20] = {
            ["npcid"] = 98792,
            ["name"] = "Wyrmtongue Scavenger",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 98810,
            ["name"] = "Wrathguard Bladelord",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 98813,
            ["name"] = "Bloodscent Felhound",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 98900,
            ["name"] = "Wyrmtongue Trickster",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [24] = {
            ["npcid"] = 98965,
            ["name"] = "Kur'talos Ravencrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [25] = {
            ["npcid"] = 98696,
            ["name"] = "Illysanna Ravencrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 2,
        },
        [26] = {
            ["npcid"] = 98949,
            ["name"] = "Smashspite the Hateful",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 3,
        },
        [27] = {
            ["npcid"] = 98538,
            ["name"] = "Lady Velandras Ravencrest",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [28] = {
            ["npcid"] = 102788,
            ["name"] = "Felspite Dominator",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [29] = {
            ["npcid"] = 102781,
            ["name"] = "Fel Bat Pup",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [30] = {
            ["npcid"] = 98970,
            ["name"] = "Latosius / Dantalionax",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 4,
        },
    }
}

BLACKROOK_INDEX_MAP = {
    ILLYSANNA_RAVENCREST_100436 = 1,
    [100436] = 1,
    RISEN_ARCANIST_100486 = 2,
    [100486] = 2,
    KURTALOS_RAVENCREST_100861 = 3,
    [100861] = 3,
    ARCANE_MINION_101549 = 4,
    [101549] = 4,
    RISEN_COMPANION_101839 = 5,
    [101839] = 5,
    RISEN_SWORDSMAN_102094 = 6,
    [102094] = 6,
    RISEN_LANCER_102095 = 7,
    [102095] = 7,
    SOULTORN_CHAMPION_98243 = 8,
    [98243] = 8,
    RISEN_ARCHER_98275 = 9,
    [98275] = 9,
    RISEN_ARCANIST_98280 = 10,
    [98280] = 10,
    GHOSTLY_RETAINER_98366 = 11,
    [98366] = 11,
    GHOSTLY_PROTECTOR_98368 = 12,
    [98368] = 12,
    GHOSTLY_COUNCILOR_98370 = 13,
    [98370] = 13,
    LORD_ETHELDRIN_RAVENCREST_98521 = 14,
    [98521] = 14,
    AMALGAM_OF_SOULS_98542 = 15,
    [98542] = 15,
    ROOK_SPIDERLING_98677 = 16,
    [98677] = 16,
    ROOK_SPINNER_98681 = 17,
    [98681] = 17,
    RISEN_SCOUT_98691 = 18,
    [98691] = 18,
    COMMANDER_SHEMDAHSOHN_98706 = 19,
    [98706] = 19,
    WYRMTONGUE_SCAVENGER_98792 = 20,
    [98792] = 20,
    WRATHGUARD_BLADELORD_98810 = 21,
    [98810] = 21,
    BLOODSCENT_FELHOUND_98813 = 22,
    [98813] = 22,
    WYRMTONGUE_TRICKSTER_98900 = 23,
    [98900] = 23,
    KURTALOS_RAVENCREST_98965 = 24,
    [98965] = 24,
    ILLYSANNA_RAVENCREST_98696 = 25,
    [98696] = 25,
    SMASHSPITE_THE_HATEFUL_98949 = 26,
    [98949] = 26,
    LADY_VELANDRAS_RAVENCREST_98538 = 27,
    [98538] = 27,
    FELSPITE_DOMINATOR_102788 = 28,
    [102788] = 28,
    FEL_BAT_PUP_102781 = 29,
    [102781] = 29,
    LATOSIUS_98970 = 30,
    [98970] = 30,
}

local BLACKROOK_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=391,y=148}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 2,}},
                ["B"] = {metadata={position={x=435,y=167}, uniqueMobs=3}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 2, [BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_PROTECTOR_98368] = 1,}},
                ["C"] = {metadata={position={x=475,y=197}, uniqueMobs=3}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_PROTECTOR_98368] = 1,}},
                ["D"] = {metadata={position={x=576,y=273}, uniqueMobs=3}, mobs={[BLACKROOK_INDEX_MAP.LORD_ETHELDRIN_RAVENCREST_98521] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 2,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=262,y=173}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_PROTECTOR_98368] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 2,}},
                ["B"] = {metadata={position={x=284,y=188}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 1,}},
                ["C"] = {metadata={position={x=242,y=216}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 2, [BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 1,}},
                ["D"] = {metadata={position={x=204,y=288}, uniqueMobs=4}, mobs={[BLACKROOK_INDEX_MAP.LADY_VELANDRAS_RAVENCREST_98538] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_COUNCILOR_98370] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_RETAINER_98366] = 1, [BLACKROOK_INDEX_MAP.GHOSTLY_PROTECTOR_98368] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=440,y=458}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.AMALGAM_OF_SOULS_98542] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=693,y=661}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
                ["B"] = {metadata={position={x=698,y=684}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
                ["C"] = {metadata={position={x=717,y=698}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
                ["D"] = {metadata={position={x=737,y=687}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
                ["E"] = {metadata={position={x=742,y=666}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
                ["F"] = {metadata={position={x=737,y=643}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 7,}},
                ["G"] = {metadata={position={x=758,y=637}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 2,}},
                ["H"] = {metadata={position={x=779,y=631}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 1,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=231,y=241}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 2,}},
                ["B"] = {metadata={position={x=209,y=287}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPINNER_98681] = 1,}},
                ["C"] = {metadata={position={x=166,y=320}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ROOK_SPIDERLING_98677] = 2,}},
                ["D"] = {metadata={position={x=289,y=260}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.SOULTORN_CHAMPION_98243] = 1, [BLACKROOK_INDEX_MAP.RISEN_SCOUT_98691] = 1,}},
                ["E"] = {metadata={position={x=333,y=146}, uniqueMobs=4}, mobs={[BLACKROOK_INDEX_MAP.SOULTORN_CHAMPION_98243] = 1, [BLACKROOK_INDEX_MAP.RISEN_ARCHER_98275] = 1, [BLACKROOK_INDEX_MAP.RISEN_ARCANIST_98280] = 1, [BLACKROOK_INDEX_MAP.ARCANE_MINION_101549] = 1,}},
                ["F"] = {metadata={position={x=407,y=248}, uniqueMobs=3}, mobs={[BLACKROOK_INDEX_MAP.SOULTORN_CHAMPION_98243] = 1, [BLACKROOK_INDEX_MAP.RISEN_ARCHER_98275] = 1, [BLACKROOK_INDEX_MAP.RISEN_SCOUT_98691] = 1,}},
                ["G"] = {metadata={position={x=426,y=262}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SCOUT_98691] = 1, [BLACKROOK_INDEX_MAP.RISEN_COMPANION_101839] = 1,}},
                ["H"] = {metadata={position={x=487,y=308}, uniqueMobs=4}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SCOUT_98691] = 1, [BLACKROOK_INDEX_MAP.RISEN_ARCHER_98275] = 2, [BLACKROOK_INDEX_MAP.RISEN_ARCANIST_98280] = 1, [BLACKROOK_INDEX_MAP.ARCANE_MINION_101549] = 1,}},
                ["I"] = {metadata={position={x=507,y=323}, uniqueMobs=3}, mobs={[BLACKROOK_INDEX_MAP.COMMANDER_SHEMDAHSOHN_98706] = 1, [BLACKROOK_INDEX_MAP.RISEN_SCOUT_98691] = 2, [BLACKROOK_INDEX_MAP.RISEN_ARCHER_98275] = 2,}},
                ["J"] = {metadata={position={x=543,y=562}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.SOULTORN_CHAMPION_98243] = 1, [BLACKROOK_INDEX_MAP.RISEN_ARCHER_98275] = 2,}},
                ["K"] = {metadata={position={x=704,y=442}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.ILLYSANNA_RAVENCREST_98696] = 1,}},
            },
        },
        ["area#6"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=612,y=494}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 3,}},
                ["B"] = {metadata={position={x=666,y=500}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 1,}},
                ["C"] = {metadata={position={x=654,y=453}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WRATHGUARD_BLADELORD_98810] = 1, [BLACKROOK_INDEX_MAP.BLOODSCENT_FELHOUND_98813] = 1,}},
                ["D"] = {metadata={position={x=547,y=361}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 4, [BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 1,}},
                ["E"] = {metadata={position={x=416,y=289}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 1,}},
                ["F"] = {metadata={position={x=431,y=321}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 1,}},
                ["G"] = {metadata={position={x=452,y=365}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 2, [BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 1,}},
                ["H"] = {metadata={position={x=388,y=434}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 2,}},
                ["I"] = {metadata={position={x=214,y=390}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 1, [BLACKROOK_INDEX_MAP.BLOODSCENT_FELHOUND_98813] = 1,}},
                ["J"] = {metadata={position={x=430,y=576}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WRATHGUARD_BLADELORD_98810] = 2, [BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 2,}},
                ["K"] = {metadata={position={x=456,y=645}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 3,}},
            },
        },
        ["area#7"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=433,y=574}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.WYRMTONGUE_TRICKSTER_98900] = 1, [BLACKROOK_INDEX_MAP.WYRMTONGUE_SCAVENGER_98792] = 1,}},
                ["B"] = {metadata={position={x=452,y=667}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.FELSPITE_DOMINATOR_102788] = 1, [BLACKROOK_INDEX_MAP.FEL_BAT_PUP_102781] = 2,}},
                ["C"] = {metadata={position={x=587,y=587}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.FELSPITE_DOMINATOR_102788] = 1,}},
                ["D"] = {metadata={position={x=580,y=464}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.FELSPITE_DOMINATOR_102788] = 1,}},
                ["E"] = {metadata={position={x=641,y=383}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.FELSPITE_DOMINATOR_102788] = 1, [BLACKROOK_INDEX_MAP.FEL_BAT_PUP_102781] = 7,}},
                ["F"] = {metadata={position={x=855,y=184}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.SMASHSPITE_THE_HATEFUL_98949] = 1,}},
                ["G"] = {metadata={position={x=543,y=481}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SWORDSMAN_102094] = 1, [BLACKROOK_INDEX_MAP.RISEN_LANCER_102095] = 1,}},
            },
        },
        ["area#8"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=453,y=366}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SWORDSMAN_102094] = 2,}},
                ["B"] = {metadata={position={x=286,y=401}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SWORDSMAN_102094] = 1, [BLACKROOK_INDEX_MAP.RISEN_LANCER_102095] = 1,}},
                ["C"] = {metadata={position={x=391,y=588}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SWORDSMAN_102094] = 1, [BLACKROOK_INDEX_MAP.RISEN_LANCER_102095] = 1,}},
                ["D"] = {metadata={position={x=653,y=585}, uniqueMobs=2}, mobs={[BLACKROOK_INDEX_MAP.RISEN_SWORDSMAN_102094] = 2, [BLACKROOK_INDEX_MAP.RISEN_LANCER_102095] = 2,}},
            },
        },
        ["area#9"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=439,y=346}, uniqueMobs=1}, mobs={[BLACKROOK_INDEX_MAP.LATOSIUS_98970] = 1,}},
            },
        },
    }
}

local BLACKROOK_TOTAL_FORCES = 379;

-- scenario objectives:
-- #1: amalgam of souls
-- #2: illysanna ravencrest
-- #3: smashspite the hateful
-- #4: lord kur'talos ravencrest

function DM_Dungeons_GetBlackRookContext()
   return {
      name="Black Rook Hold",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 743,
         xOffset = 0,
         yOffset = 4,
         floorCount = 6,
         floorMapInfo = {
            [1] = {name="The Ravenscrypt", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon1_"},
            [2] = {name="The Grand Hall", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon2_"},
            [3] = {name="Ravenshold", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon3_"},
            [4] = {name="The Rook's Roost", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon4_"},
            [5] = {name="Lord Ravenscrest's Chamber", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon5_"},
            [6] = {name="The Raven's Crown", mapFolder="BlackRookHoldDungeon", mapTilePrefix="BlackRookHoldDungeon6_"}
         }
      },
      zoneId=1501,
      timer=36*60, -- 36:00
      requiredForceCount=312,
      totalForceCount=BLACKROOK_TOTAL_FORCES,
      totalMobGroups=0,
      --mobGroups=BLACKROOK_MOB_GROUPS,
      areaCount=BLACKROOK_AREA_COUNT,
      areas=BLACKROOK_MAP_AREAS,
      mapMarkers=BLACKROOK_MAP_MARKERS,
      npcs=BLACKROOK_NPCS,
      --mobGroupPositions=BLACKROOK_GROUP_POSITIONS,
      mobIndexMap=BLACKROOK_INDEX_MAP,
      envMarkers=BLACKROOK_POI,
      abilities=BLACKROOK_ABILITIES,
      abilitiesByMob=BLACKROOK_BY_MOB,
      neighbors=BLACKROOK_GROUP_NEIGHBORS,
      priorityAbilities=BLACKROOK_PRIORITY_ABILITIES
   };
end
    