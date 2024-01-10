local DAWN_ONE_AREA_COUNT = 6;
local DAWN_ONE_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Sanctum of Chronology",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Millennia's Threshold",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "Locus of Eternity",
        locationHint = "TBD",
        floorIndex = 3
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "Galakrond's Fall",
        locationHint = "TBD",
        floorIndex = 5
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "Crossroads of Fate",
        locationHint = "TBD",
        floorIndex = 5
    },
}

local DAWN_ONE_NPCS = {
    size = 25,
    items = {
        [1] = {
            ["npcid"] = 163366,
            ["name"] = "Magus of the Dead",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [2] = {
            ["npcid"] = 198933,
            ["name"] = "Iridikron",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 4,
        },
        [3] = {
            ["npcid"] = 198995,
            ["name"] = "Chronikar",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 1,
        },
        [4] = {
            ["npcid"] = 198996,
            ["name"] = "Manifested Timeways",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 2,
        },
        [5] = {
            ["npcid"] = 201788,
            ["name"] = "Dazhak",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 3,
        },
        [6] = {
            ["npcid"] = 201790,
            ["name"] = "Loszkeleth",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 3,
        },
        [7] = {
            ["npcid"] = 204536,
            ["name"] = "Blight Chunk",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 204918,
            ["name"] = "Iridikron's Creation",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 205384,
            ["name"] = "Infinite Chronoweaver",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 205408,
            ["name"] = "Infinite Timeslicer",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 205435,
            ["name"] = "Epoch Ripper",
            ["type"] = "",
            ["forceCount"] = 12,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 205691,
            ["name"] = "Iridikron's Creation",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [13] = {
            ["npcid"] = 205804,
            ["name"] = "Risen Dragon",
            ["type"] = "",
            ["forceCount"] = 15,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 206063,
            ["name"] = "Temporal Deviation",
            ["type"] = "",
            ["forceCount"] = 2,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 206064,
            ["name"] = "Coalesced Moment",
            ["type"] = "",
            ["forceCount"] = 2,
            ["count"] = 0,
        },
        [16] = {
            ["npcid"] = 206065,
            ["name"] = "Interval",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 206066,
            ["name"] = "Timestream Leech",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 206068,
            ["name"] = "Temporal Fusion",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [19] = {
            ["npcid"] = 206214,
            ["name"] = "Infinite Infiltrator",
            ["type"] = "",
            ["forceCount"] = 20,
            ["count"] = 0,
        },
        [20] = {
            ["npcid"] = 207638,
            ["name"] = "Blight of Galakrond",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 207639,
            ["name"] = "Blight of Galakrond",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 206140,
            ["name"] = "Coalesced Time",
            ["type"] = "",
            ["forceCount"] = 12,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 199749,
            ["name"] = "Timestream Anomaly",
            ["type"] = "",
            ["forceCount"] = 12,
            ["count"] = 0,
        },
        [24] = {
            ["npcid"] = 198997,
            ["name"] = "Blight of Galakrond",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 3,
        },
        [25] = {
            ["npcid"] = 201792,
            ["name"] = "Ahnzon",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["allowGuidReassign"] = true,
            ["autocompleteAfter"] = 3,
        },
    }
}

DAWN_ONE_INDEX_MAP = {
    MAGUS_OF_THE_DEAD_163366 = 1,
    [163366] = 1,
    IRIDIKRON_198933 = 2,
    [198933] = 2,
    CHRONIKAR_198995 = 3,
    [198995] = 3,
    MANIFESTED_TIMEWAYS_198996 = 4,
    [198996] = 4,
    DAZHAK_201788 = 5,
    [201788] = 5,
    LOSZKELETH_201790 = 6,
    [201790] = 6,
    BLIGHT_CHUNK_204536 = 7,
    [204536] = 7,
    IRIDIKRONS_CREATION_204918 = 8,
    [204918] = 8,
    INFINITE_CHRONOWEAVER_205384 = 9,
    [205384] = 9,
    INFINITE_TIMESLICER_205408 = 10,
    [205408] = 10,
    EPOCH_RIPPER_205435 = 11,
    [205435] = 11,
    IRIDIKRONS_CREATION_205691 = 12,
    [205691] = 12,
    RISEN_DRAGON_205804 = 13,
    [205804] = 13,
    TEMPORAL_DEVIATION_206063 = 14,
    [206063] = 14,
    COALESCED_MOMENT_206064 = 15,
    [206064] = 15,
    INTERVAL_206065 = 16,
    [206065] = 16,
    TIMESTREAM_LEECH_206066 = 17,
    [206066] = 17,
    TEMPORAL_FUSION_206068 = 18,
    [206068] = 18,
    INFINITE_INFILTRATOR_206214 = 19,
    [206214] = 19,
    BLIGHT_OF_GALAKROND_207638 = 20,
    [207638] = 20,
    BLIGHT_OF_GALAKROND_207639 = 21,
    [207639] = 21,
    COALESCED_TIME_206140 = 22,
    [206140] = 22,
    TIMESTREAM_ANOMALY_199749 = 23,
    [199749] = 23,
    BLIGHT_OF_GALAKROND_198997 = 24,
    [198997] = 24,
    AHNZON_201792 = 25,
    [201792] = 25,
}

local DAWN_ONE_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=501,y=316}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 1, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 2,}},
                ["B"] = {metadata={position={x=557,y=306}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 2, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 1,}},
                ["C"] = {metadata={position={x=532,y=353}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 1,}},
                ["D"] = {metadata={position={x=478,y=372}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 2, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 2,}},
                ["E"] = {metadata={position={x=553,y=379}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.EPOCH_RIPPER_205435] = 2,}},
                ["F"] = {metadata={position={x=612,y=452}, uniqueMobs=3}, mobs={[DAWN_ONE_INDEX_MAP.EPOCH_RIPPER_205435] = 2, [DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 1, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 2,}},
                ["G"] = {metadata={position={x=649,y=498}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.CHRONIKAR_198995] = 1,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=723,y=489}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.COALESCED_TIME_206140] = 1,}},
                ["B"] = {metadata={position={x=709,y=533}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["C"] = {metadata={position={x=711,y=564}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["D"] = {metadata={position={x=687,y=506}, uniqueMobs=3}, mobs={[DAWN_ONE_INDEX_MAP.TEMPORAL_DEVIATION_206063] = 2, [DAWN_ONE_INDEX_MAP.TEMPORAL_FUSION_206068] = 2, [DAWN_ONE_INDEX_MAP.COALESCED_MOMENT_206064] = 1,}},
                ["E"] = {metadata={position={x=782,y=529}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.COALESCED_MOMENT_206064] = 2, [DAWN_ONE_INDEX_MAP.TIMESTREAM_ANOMALY_199749] = 1,}},
                ["F"] = {metadata={position={x=806,y=510}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["G"] = {metadata={position={x=826,y=528}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["H"] = {metadata={position={x=826,y=556}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["I"] = {metadata={position={x=877,y=417}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["J"] = {metadata={position={x=819,y=368}, uniqueMobs=3}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1, [DAWN_ONE_INDEX_MAP.COALESCED_TIME_206140] = 1, [DAWN_ONE_INDEX_MAP.TEMPORAL_FUSION_206068] = 1,}},
                ["K"] = {metadata={position={x=796,y=339}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["L"] = {metadata={position={x=815,y=312}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["M"] = {metadata={position={x=728,y=344}, uniqueMobs=3}, mobs={[DAWN_ONE_INDEX_MAP.COALESCED_MOMENT_206064] = 1, [DAWN_ONE_INDEX_MAP.TEMPORAL_FUSION_206068] = 1, [DAWN_ONE_INDEX_MAP.TEMPORAL_DEVIATION_206063] = 2,}},
                ["N"] = {metadata={position={x=704,y=361}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["O"] = {metadata={position={x=681,y=323}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_LEECH_206066] = 1,}},
                ["P"] = {metadata={position={x=756,y=373}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.TIMESTREAM_ANOMALY_199749] = 1,}},
                ["Q"] = {metadata={position={x=751,y=433}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.MANIFESTED_TIMEWAYS_198996] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=561,y=417}, uniqueMobs=1}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_INFILTRATOR_206214] = 1,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=356,y=169}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.RISEN_DRAGON_205804] = 1, [DAWN_ONE_INDEX_MAP.BLIGHT_CHUNK_204536] = 7,}},
                ["B"] = {metadata={position={x=393,y=146}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.RISEN_DRAGON_205804] = 1, [DAWN_ONE_INDEX_MAP.BLIGHT_CHUNK_204536] = 7,}},
                ["C"] = {metadata={position={x=374,y=246}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.RISEN_DRAGON_205804] = 1, [DAWN_ONE_INDEX_MAP.BLIGHT_CHUNK_204536] = 5,}},
                ["D"] = {metadata={position={x=403,y=245}, uniqueMobs=2}, mobs={[DAWN_ONE_INDEX_MAP.RISEN_DRAGON_205804] = 1, [DAWN_ONE_INDEX_MAP.BLIGHT_CHUNK_204536] = 10,}},
                ["E"] = {metadata={position={x=425,y=275}, uniqueMobs=4}, mobs={[DAWN_ONE_INDEX_MAP.BLIGHT_OF_GALAKROND_198997] = 1, [DAWN_ONE_INDEX_MAP.AHNZON_201792] = 1, [DAWN_ONE_INDEX_MAP.DAZHAK_201788] = 1, [DAWN_ONE_INDEX_MAP.LOSZKELETH_201790] = 1,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=329,y=387}, uniqueMobs=3, canActivateAfter=3}, mobs={[DAWN_ONE_INDEX_MAP.IRIDIKRONS_CREATION_205691] = 1, [DAWN_ONE_INDEX_MAP.EPOCH_RIPPER_205435] = 1, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 1,}},
                ["B"] = {metadata={position={x=367,y=412}, uniqueMobs=2, canActivateAfter=3}, mobs={[DAWN_ONE_INDEX_MAP.IRIDIKRONS_CREATION_205691] = 1, [DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 1,}},
                ["C"] = {metadata={position={x=417,y=419}, uniqueMobs=3, canActivateAfter=3}, mobs={[DAWN_ONE_INDEX_MAP.INFINITE_TIMESLICER_205408] = 2, [DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 1, [DAWN_ONE_INDEX_MAP.IRIDIKRONS_CREATION_205691] = 2,}},
                ["D"] = {metadata={position={x=468,y=427}, uniqueMobs=2, canActivateAfter=3}, mobs={[DAWN_ONE_INDEX_MAP.EPOCH_RIPPER_205435] = 2, [DAWN_ONE_INDEX_MAP.INFINITE_CHRONOWEAVER_205384] = 1,}},
                ["E"] = {metadata={position={x=567,y=426}, uniqueMobs=1, canActivateAfter=3}, mobs={[DAWN_ONE_INDEX_MAP.IRIDIKRON_198933] = 1,}},
            },
        },
    }
}

local DAWN_ONE_TOTAL_FORCES = 398;

-- statuses = {
--   [unitId] = {
--       buffs = { [buffId] = [buffName] }
--   }
-- }

local DISPLAY_EVERYONE = 1;
local DISPLAY_SELF = 2;
local DISPLAY_HEALER = 4;
local DISPLAY_TANK = 8;
local DISPLAY_DPS = 16;

local CHRONIKAR_CHRONOSHEAR = 413013;
local MANIFESTED_TIMEWAYS_ACCELERATING = 403912;
local MANIFESTED_TIMEWAYS_CHRONOFADED = 404141;
local BLIGHT_CORROSION = 407406;
local IRIDIKRON_EXTINCTION_BLAST = 409268;
local IRIDIKRON_CRUSHING_ONSLAUGHT = 414075;

local function ProcessGroup(status)
    local messages = {size=0, items={}};
    local isAccelerating = false;

    for i = 1, status.size do
        local statusList = status.items[i];

        local p = statusList.p; -- character/unit information

        if statusList.buffs then
            if statusList.buffs[MANIFESTED_TIMEWAYS_ACCELERATING] then
                isAccelerating = true;
            end
        end

        if statusList.debuffs then
            if statusList.debuffs[CHRONIKAR_CHRONOSHEAR] then
                -- HEAL OFF HEALING ABSORB: <#> LEFT
                messages.size = messages.size+1;
                messages.items[messages.size] = {priority = 0, display=DISPLAY_HEALER, text="PRIORITY HEAL TO REMOVE SHIELD: " .. p.playerName};
            end

            if isAccelerating and statusList.debuffs[MANIFESTED_TIMEWAYS_CHRONOFADED] then
                -- SAFE TO DISPEL: <name>
                messages.size = messages.size+1;
                messages.items[messages.size] = {priority = 0, display=DISPLAY_HEALER, text="SAFE TO DISPEL: " .. p.playerName};
            end

            if statusList.debuffs[BLIGHT_CORROSION] then
                -- TAKE DEBUFF TO TANK, SLOWER IN PHASE 2 / PHASE 3
                messages.size = messages.size+1;
                messages.items[messages.size] = {priority = 0, display=DISPLAY_SELF, text="RUN INTO TANK WITH CORROSION. RUN SLOWER IN PHASE 2 AND 3"};
            end

            if statusList.debuffs[IRIDIKRON_EXTINCTION_BLAST] then
                -- MOVE TO CHROMIE
                messages.size = messages.size+1;
                messages.items[messages.size] = {priority = 0, display=DISPLAY_SELF, text="STAND ON CHROMIE"};
            end

            if statusList.debuffs[IRIDIKRON_CRUSHING_ONSLAUGHT] then
                -- check stacks
                -- STACKS HIGH (<#>), CLEAR STACKS
                messages.size = messages.size+1;
                messages.items[messages.size] = {priority = 0, display=DISPLAY_SELF, text="HIGH STACKS OF CRUSHING ONSLAUGHT, CLEAR STACKS"};
            end
        end
    end

    return messages;
end

-- scenario objectives
-- #1: chronikar
-- #2: manifested timeways
-- #3: blight of galakrond
-- #4: iridikron

function DM_Dungeons_GetDawnPartOneContext()
   return {
      name="Dawn of the Infinites: Galakrond's Fall",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 743,
         xOffset = 0,
         yOffset = 4,
         floorCount = 5,
         floorMapInfo = {
            [1] = {name="Sanctum of Chronology", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_a"},
            [2] = {name="Millennia's Threshold", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_b"},
            [3] = {name="Locus of Eternity", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_c"},
            [4] = {name="Spoke of Endless Winter", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_d"},
            [5] = {name="Crossroads of Fate", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_e"},
            -- [6] = {name="Floor 6", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_f"},
            -- [7] = {name="Floor 7", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_g"},
            -- [8] = {name="Floor 8", mapFolder="dawnoftheinfinite", mapTilePrefix="dawnoftheinfinite_h"},
         }
      },
      zoneId=2579,
      zoneDiscriminator = 1,
      timer=34*60, -- 34:00
      requiredForceCount=300,
      totalForceCount=DAWN_ONE_TOTAL_FORCES,
      totalMobGroups=0,
      --mobGroups=DAWN_ONE_MOB_GROUPS,
      areaCount=DAWN_ONE_AREA_COUNT,
      areas=DAWN_ONE_MAP_AREAS,
      mapMarkers=DAWN_ONE_MAP_MARKERS,
      npcs=DAWN_ONE_NPCS,
      --mobGroupPositions=DAWN_ONE_GROUP_POSITIONS,
      mobIndexMap=DAWN_ONE_INDEX_MAP,
      envMarkers=DAWN_ONE_POI,
      abilities=DAWN_ONE_ABILITIES,
      abilitiesByMob=DAWN_ONE_BY_MOB,
      neighbors=DAWN_ONE_GROUP_NEIGHBORS,
      priorityAbilities=DAWN_ONE_PRIORITY_ABILITIES,
      buffDebuffScan = ProcessGroup
   };
end
