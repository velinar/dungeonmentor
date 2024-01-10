local WAYCREST_AREA_COUNT = 14;
local WAYCREST_MAP_AREAS = {
    ["area#0"] = {
        areaIndex = 0,
        name = "Uncategorized",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#1"] = {
        areaIndex = 1,
        name = "Grand Foyer",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#2"] = {
        areaIndex = 2,
        name = "Hunting Lodge",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#3"] = {
        areaIndex = 3,
        name = "Hallway to Banquet Hall",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#4"] = {
        areaIndex = 4,
        name = "Banquet Hall",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#5"] = {
        areaIndex = 5,
        name = "Hallway to Ballroom",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#6"] = {
        areaIndex = 6,
        name = "Ballroom",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#7"] = {
        areaIndex = 7,
        name = "Outside",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#8"] = {
        areaIndex = 8,
        name = "Above Banquet Hall",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#9"] = {
        areaIndex = 9,
        name = "Above Ballroom",
        locationHint = "TBD",
        floorIndex = 2
    },
    ["area#10"] = {
        areaIndex = 13,
        name = "Down to Cellar",
        locationHint = "TBD",
        floorIndex = 1
    },
    ["area#11"] = {
        areaIndex = 10,
        name = "Cellar",
        locationHint = "TBD",
        floorIndex = 3
    },
    ["area#12"] = {
        areaIndex = 11,
        name = "Catacombs",
        locationHint = "TBD",
        floorIndex = 4
    },
    ["area#13"] = {
        areaIndex = 12,
        name = "Rupture",
        locationHint = "TBD",
        floorIndex = 5
    },
}

local WAYCREST_NPCS = {
    size = 35,
    items = {
        [1] = {
            ["npcid"] = 135240,
            ["name"] = "Soul Essence",
            ["type"] = "",
            ["forceCount"] = 2,
            ["count"] = 0,
        },
        [2] = {
            ["npcid"] = 131850,
            ["name"] = "Maddened Survivalist",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [3] = {
            ["npcid"] = 135234,
            ["name"] = "Diseased Mastiff",
            ["type"] = "",
            ["forceCount"] = 3,
            ["count"] = 0,
        },
        [4] = {
            ["npcid"] = 131677,
            ["name"] = "Heartsbane Runeweaver",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [5] = {
            ["npcid"] = 131685,
            ["name"] = "Runic Disciple",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [6] = {
            ["npcid"] = 131849,
            ["name"] = "Crazed Marksman",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [7] = {
            ["npcid"] = 131585,
            ["name"] = "Enthralled Guard",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [8] = {
            ["npcid"] = 131586,
            ["name"] = "Banquet Steward",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [9] = {
            ["npcid"] = 131587,
            ["name"] = "Bewitched Captain",
            ["type"] = "",
            ["forceCount"] = 5,
            ["count"] = 0,
        },
        [10] = {
            ["npcid"] = 131666,
            ["name"] = "Coven Thornshaper",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [11] = {
            ["npcid"] = 131669,
            ["name"] = "Jagged Hound",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [12] = {
            ["npcid"] = 131812,
            ["name"] = "Heartsbane Soulcharmer",
            ["type"] = "",
            ["forceCount"] = 6,
            ["count"] = 0,
        },
        [13] = {
            ["npcid"] = 131819,
            ["name"] = "Coven Diviner",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [14] = {
            ["npcid"] = 131847,
            ["name"] = "Waycrest Reveler",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [15] = {
            ["npcid"] = 131858,
            ["name"] = "Thornguard",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [16] = {
            ["npcid"] = 134024,
            ["name"] = "Devouring Maggot",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
        [17] = {
            ["npcid"] = 134041,
            ["name"] = "Infected Peasant",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [18] = {
            ["npcid"] = 135048,
            ["name"] = "Gorestained Piglet",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [19] = {
            ["npcid"] = 135329,
            ["name"] = "Matron Bryndle",
            ["type"] = "",
            ["forceCount"] = 10,
            ["count"] = 0,
        },
        [20] = {
            ["npcid"] = 135474,
            ["name"] = "Thistle Acolyte",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [21] = {
            ["npcid"] = 137830,
            ["name"] = "Pallid Gorger",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [22] = {
            ["npcid"] = 135365,
            ["name"] = "Matron Alma",
            ["type"] = "",
            ["forceCount"] = 16,
            ["count"] = 0,
        },
        [23] = {
            ["npcid"] = 131527,
            ["name"] = "Lord Waycrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [24] = {
            ["npcid"] = 131545,
            ["name"] = "Lady Waycrest",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 4,
            ["allowGuidReassign"] = true,
        },
        [25] = {
            ["npcid"] = 131667,
            ["name"] = "Soulbound Goliath",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 2,
            ["allowGuidReassign"] = true,
        },
        [26] = {
            ["npcid"] = 131823,
            ["name"] = "Sister Malady",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [27] = {
            ["npcid"] = 131824,
            ["name"] = "Sister Solena",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [28] = {
            ["npcid"] = 131825,
            ["name"] = "Sister Briar",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 1,
            ["allowGuidReassign"] = true,
        },
        [29] = {
            ["npcid"] = 131863,
            ["name"] = "Raal the Gluttonous",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 3,
            ["allowGuidReassign"] = true,
        },
        [30] = {
            ["npcid"] = 131864,
            ["name"] = "Gorak Tul",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 5,
            ["allowGuidReassign"] = true,
        },
        [31] = {
            ["npcid"] = 144324,
            ["name"] = "Gorak Tul",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
            ["autocompleteAfter"] = 5,
            ["allowGuidReassign"] = true,
        },
        [32] = {
            ["npcid"] = 131821,
            ["name"] = "Faceless Maiden",
            ["type"] = "",
            ["forceCount"] = 0,
            ["count"] = 0,
        },
        [33] = {
            ["npcid"] = 135049,
            ["name"] = "Dreadwing Raven",
            ["type"] = "",
            ["forceCount"] = 2,
            ["count"] = 0,
        },
        [34] = {
            ["npcid"] = 139269,
            ["name"] = "Gloom Horror",
            ["type"] = "",
            ["forceCount"] = 4,
            ["count"] = 0,
        },
        [35] = {
            ["npcid"] = 135052,
            ["name"] = "Blight Toad",
            ["type"] = "",
            ["forceCount"] = 1,
            ["count"] = 0,
        },
    }
}

WAYCREST_INDEX_MAP = {
    SOUL_ESSENCE_135240 = 1,
    [135240] = 1,
    MADDENED_SURVIVALIST_131850 = 2,
    [131850] = 2,
    DISEASED_MASTIFF_135234 = 3,
    [135234] = 3,
    HEARTSBANE_RUNEWEAVER_131677 = 4,
    [131677] = 4,
    RUNIC_DISCIPLE_131685 = 5,
    [131685] = 5,
    CRAZED_MARKSMAN_131849 = 6,
    [131849] = 6,
    ENTHRALLED_GUARD_131585 = 7,
    [131585] = 7,
    BANQUET_STEWARD_131586 = 8,
    [131586] = 8,
    BEWITCHED_CAPTAIN_131587 = 9,
    [131587] = 9,
    COVEN_THORNSHAPER_131666 = 10,
    [131666] = 10,
    JAGGED_HOUND_131669 = 11,
    [131669] = 11,
    HEARTSBANE_SOULCHARMER_131812 = 12,
    [131812] = 12,
    COVEN_DIVINER_131819 = 13,
    [131819] = 13,
    WAYCREST_REVELER_131847 = 14,
    [131847] = 14,
    THORNGUARD_131858 = 15,
    [131858] = 15,
    DEVOURING_MAGGOT_134024 = 16,
    [134024] = 16,
    INFECTED_PEASANT_134041 = 17,
    [134041] = 17,
    GORESTAINED_PIGLET_135048 = 18,
    [135048] = 18,
    MATRON_BRYNDLE_135329 = 19,
    [135329] = 19,
    THISTLE_ACOLYTE_135474 = 20,
    [135474] = 20,
    PALLID_GORGER_137830 = 21,
    [137830] = 21,
    MATRON_ALMA_135365 = 22,
    [135365] = 22,
    LORD_WAYCREST_131527 = 23,
    [131527] = 23,
    LADY_WAYCREST_131545 = 24,
    [131545] = 24,
    SOULBOUND_GOLIATH_131667 = 25,
    [131667] = 25,
    SISTER_MALADY_131823 = 26,
    [131823] = 26,
    SISTER_SOLENA_131824 = 27,
    [131824] = 27,
    SISTER_BRIAR_131825 = 28,
    [131825] = 28,
    RAAL_THE_GLUTTONOUS_131863 = 29,
    [131863] = 29,
    GORAK_TUL_131864 = 30,
    [131864] = 30,
    GORAK_TUL_144324 = 31,
    [144324] = 31,
    FACELESS_MAIDEN_131821 = 32,
    [131821] = 32,
    DREADWING_RAVEN_135049 = 33,
    [135049] = 33,
    GLOOM_HORROR_139269 = 34,
    [139269] = 34,
    BLIGHT_TOAD_135052 = 35,
    [135052] = 35,
}

local WAYCREST_MAP_MARKERS = {
    areas = {
        ["area#0"] = {
            pullGroups = {
            },
        },
        ["area#1"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=513,y=526}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 1,}},
                ["B"] = {metadata={position={x=533,y=499}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 2,}},
                ["C"] = {metadata={position={x=606,y=574}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 2,}},
                ["D"] = {metadata={position={x=610,y=502}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 2,}},
            },
        },
        ["area#2"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=753,y=482}, uniqueMobs=3}, mobs={[WAYCREST_INDEX_MAP.CRAZED_MARKSMAN_131849] = 1, [WAYCREST_INDEX_MAP.MADDENED_SURVIVALIST_131850] = 1, [WAYCREST_INDEX_MAP.DISEASED_MASTIFF_135234] = 1,}},
                ["B"] = {metadata={position={x=826,y=513}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.MADDENED_SURVIVALIST_131850] = 1, [WAYCREST_INDEX_MAP.DISEASED_MASTIFF_135234] = 1,}},
                ["C"] = {metadata={position={x=792,y=549}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.MADDENED_SURVIVALIST_131850] = 1, [WAYCREST_INDEX_MAP.CRAZED_MARKSMAN_131849] = 1,}},
            },
        },
        ["area#3"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=843,y=421}, uniqueMobs=3}, mobs={[WAYCREST_INDEX_MAP.INFECTED_PEASANT_134041] = 1, [WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3, [WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["B"] = {metadata={position={x=812,y=419}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.PALLID_GORGER_137830] = 2,}},
                ["C"] = {metadata={position={x=781,y=417}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["D"] = {metadata={position={x=776,y=435}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["E"] = {metadata={position={x=672,y=431}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.INFECTED_PEASANT_134041] = 1, [WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["F"] = {metadata={position={x=672,y=412}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["G"] = {metadata={position={x=679,y=382}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["H"] = {metadata={position={x=670,y=341}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["I"] = {metadata={position={x=681,y=322}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["J"] = {metadata={position={x=675,y=259}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.INFECTED_PEASANT_134041] = 1, [WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
            },
        },
        ["area#4"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=731,y=369}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["B"] = {metadata={position={x=774,y=356}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.BANQUET_STEWARD_131586] = 1, [WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 1,}},
                ["C"] = {metadata={position={x=728,y=317}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.WAYCREST_REVELER_131847] = 1, [WAYCREST_INDEX_MAP.PALLID_GORGER_137830] = 1,}},
                ["D"] = {metadata={position={x=753,y=244}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.BANQUET_STEWARD_131586] = 1,}},
                ["E"] = {metadata={position={x=728,y=269}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.WAYCREST_REVELER_131847] = 3,}},
                ["F"] = {metadata={position={x=774,y=272}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.PALLID_GORGER_137830] = 1, [WAYCREST_INDEX_MAP.GORESTAINED_PIGLET_135048] = 2,}},
                ["G"] = {metadata={position={x=784,y=317}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.RAAL_THE_GLUTTONOUS_131863] = 1,}},
            },
        },
        ["area#5"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=398,y=287}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 2, [WAYCREST_INDEX_MAP.RUNIC_DISCIPLE_131685] = 1,}},
                ["B"] = {metadata={position={x=395,y=367}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.BEWITCHED_CAPTAIN_131587] = 1, [WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 1,}},
                ["C"] = {metadata={position={x=424,y=324}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.BEWITCHED_CAPTAIN_131587] = 1, [WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 1,}},
                ["D"] = {metadata={position={x=415,y=436}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.BEWITCHED_CAPTAIN_131587] = 1, [WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 1,}},
                ["E"] = {metadata={position={x=427,y=463}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_SOULCHARMER_131812] = 1,}},
            },
        },
        ["area#6"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=346,y=430}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.THISTLE_ACOLYTE_135474] = 1, [WAYCREST_INDEX_MAP.BLIGHT_TOAD_135052] = 3,}},
                ["B"] = {metadata={position={x=345,y=606}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.THISTLE_ACOLYTE_135474] = 1, [WAYCREST_INDEX_MAP.BLIGHT_TOAD_135052] = 3,}},
                ["C"] = {metadata={position={x=299,y=520}, uniqueMobs=3}, mobs={[WAYCREST_INDEX_MAP.SISTER_BRIAR_131825] = 1, [WAYCREST_INDEX_MAP.SISTER_SOLENA_131824] = 1, [WAYCREST_INDEX_MAP.SISTER_MALADY_131823] = 1,}},
            },
        },
        ["area#7"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=536,y=377}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.JAGGED_HOUND_131669] = 4,}},
                ["B"] = {metadata={position={x=547,y=401}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.JAGGED_HOUND_131669] = 3,}},
                ["C"] = {metadata={position={x=612,y=404}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.THORNGUARD_131858] = 1, [WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 2,}},
                ["D"] = {metadata={position={x=589,y=345}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 1, [WAYCREST_INDEX_MAP.JAGGED_HOUND_131669] = 4,}},
                ["E"] = {metadata={position={x=578,y=298}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 1, [WAYCREST_INDEX_MAP.THORNGUARD_131858] = 1,}},
                ["F"] = {metadata={position={x=548,y=228}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 1,}},
                ["G"] = {metadata={position={x=604,y=228}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 1,}},
                ["H"] = {metadata={position={x=576,y=184}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.JAGGED_HOUND_131669] = 3, [WAYCREST_INDEX_MAP.MATRON_BRYNDLE_135329] = 1,}},
                ["I"] = {metadata={position={x=579,y=134}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.SOULBOUND_GOLIATH_131667] = 1,}},
            },
        },
        ["area#8"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=814,y=449}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.MADDENED_SURVIVALIST_131850] = 1, [WAYCREST_INDEX_MAP.DISEASED_MASTIFF_135234] = 2,}},
                ["B"] = {metadata={position={x=818,y=497}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_RUNEWEAVER_131677] = 1,}},
                ["C"] = {metadata={position={x=825,y=357}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.FACELESS_MAIDEN_131821] = 2, [WAYCREST_INDEX_MAP.RUNIC_DISCIPLE_131685] = 1,}},
            },
        },
        ["area#9"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=252,y=221}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_SOULCHARMER_131812] = 1, [WAYCREST_INDEX_MAP.DREADWING_RAVEN_135049] = 2,}},
                ["B"] = {metadata={position={x=220,y=386}, uniqueMobs=3}, mobs={[WAYCREST_INDEX_MAP.THISTLE_ACOLYTE_135474] = 1, [WAYCREST_INDEX_MAP.DREADWING_RAVEN_135049] = 1, [WAYCREST_INDEX_MAP.RUNIC_DISCIPLE_131685] = 1,}},
                ["C"] = {metadata={position={x=352,y=444}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.RUNIC_DISCIPLE_131685] = 1, [WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 1,}},
                ["D"] = {metadata={position={x=217,y=613}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.RUNIC_DISCIPLE_131685] = 1, [WAYCREST_INDEX_MAP.DREADWING_RAVEN_135049] = 1,}},
            },
        },
        ["area#10"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=766,y=216}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["B"] = {metadata={position={x=752,y=194}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_RUNEWEAVER_131677] = 1,}},
                ["C"] = {metadata={position={x=724,y=215}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
                ["D"] = {metadata={position={x=708,y=184}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.DEVOURING_MAGGOT_134024] = 3,}},
            },
        },
        ["area#11"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=750,y=189}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.COVEN_THORNSHAPER_131666] = 1, [WAYCREST_INDEX_MAP.JAGGED_HOUND_131669] = 4,}},
                ["B"] = {metadata={position={x=737,y=364}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.MATRON_ALMA_135365] = 1,}},
                ["C"] = {metadata={position={x=725,y=496}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.BEWITCHED_CAPTAIN_131587] = 1,}},
                ["D"] = {metadata={position={x=691,y=494}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_RUNEWEAVER_131677] = 1,}},
                ["E"] = {metadata={position={x=286,y=324}, uniqueMobs=3}, mobs={[WAYCREST_INDEX_MAP.BEWITCHED_CAPTAIN_131587] = 1, [WAYCREST_INDEX_MAP.ENTHRALLED_GUARD_131585] = 1, [WAYCREST_INDEX_MAP.FACELESS_MAIDEN_131821] = 1,}},
                ["F"] = {metadata={position={x=345,y=450}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.COVEN_DIVINER_131819] = 1, [WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 1,}},
            },
        },
        ["area#12"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=689,y=622}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_SOULCHARMER_131812] = 1,}},
                ["B"] = {metadata={position={x=575,y=599}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.COVEN_DIVINER_131819] = 1, [WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 2,}},
                ["C"] = {metadata={position={x=575,y=493}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.HEARTSBANE_SOULCHARMER_131812] = 1, [WAYCREST_INDEX_MAP.SOUL_ESSENCE_135240] = 2,}},
                ["D"] = {metadata={position={x=576,y=173}, uniqueMobs=2}, mobs={[WAYCREST_INDEX_MAP.LORD_WAYCREST_131527] = 1, [WAYCREST_INDEX_MAP.LADY_WAYCREST_131545] = 1,}},
                ["E"] = {metadata={position={x=656,y=334}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GLOOM_HORROR_139269] = 3,}},
                ["F"] = {metadata={position={x=693,y=311}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GLOOM_HORROR_139269] = 2,}},
                ["G"] = {metadata={position={x=755,y=273}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GLOOM_HORROR_139269] = 2,}},
            },
        },
        ["area#13"] = {
            pullGroups = {
                ["A"] = {metadata={position={x=646,y=334}, uniqueMobs=1}, mobs={[WAYCREST_INDEX_MAP.GORAK_TUL_131864] = 1,}},
            },
        },
    }
}

local WAYCREST_TOTAL_FORCES = 428;

-- scenario objectives:
-- #1: heartsbane triad
-- #2: soulbound goliath
-- #3: raal the gluttonous
-- #4: lord/lady waycrest
-- #5: gorak tul

function DM_Dungeons_GetWaycrestContext()
   return {
      name="Waycrest Manor",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 743,
         xOffset = 0,
         yOffset = 4,
         floorCount = 5,
         floorMapInfo = {
            [1] = {name="The Grand Foyer", mapFolder="Waycrest", mapTilePrefix="Waycrest1_"},
            [2] = {name="Upstairs", mapFolder="Waycrest", mapTilePrefix="Waycrest2_"},
            [3] = {name="The Cellar", mapFolder="Waycrest", mapTilePrefix="Waycrest3_"},
            [4] = {name="Catacombs", mapFolder="Waycrest", mapTilePrefix="Waycrest4_"},
            [5] = {name="The Rupture", mapFolder="Waycrest", mapTilePrefix="Waycrest5_"},
         }
      },
      zoneId=1862,
      timer=37*60, -- 37:00
      requiredForceCount=305,
      totalForceCount=WAYCREST_TOTAL_FORCES,
      totalMobGroups=0,
      --mobGroups=WAYCREST_MOB_GROUPS,
      areaCount=WAYCREST_AREA_COUNT,
      areas=WAYCREST_MAP_AREAS,
      mapMarkers=WAYCREST_MAP_MARKERS,
      npcs=WAYCREST_NPCS,
      --mobGroupPositions=WAYCREST_GROUP_POSITIONS,
      mobIndexMap=WAYCREST_INDEX_MAP,
      envMarkers=WAYCREST_POI,
      abilities=WAYCREST_ABILITIES,
      abilitiesByMob=WAYCREST_BY_MOB,
      neighbors=WAYCREST_GROUP_NEIGHBORS,
      priorityAbilities=WAYCREST_PRIORITY_ABILITIES
   };
end
