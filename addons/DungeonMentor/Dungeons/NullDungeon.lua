local NULL_NPCS = {
   size = 0,
   items = {
   }
}

NULL_INDEX_MAP = {
}

NULL_MOB_GROUPS = {
}

NULL_GROUP_POSITIONS = {
    [1] = {
    }
}

NULL_POI = {
}

NULL_POI_POSITIONS = {
   [1] = {
   }
};

NULL_ABILITIES = {
};

NULL_ABILITIES_BY_MOB = {
};

NULL_GROUP_NEIGHBORS = {
}

NULL_PRIORITY_ABILITIES = {
}

function DM_Dungeons_GetNullContext()
   return {
      name="Null Dungeon",
      config = {
         SOURCE_MAP_WIDTH = 1120,
         SOURCE_MAP_HEIGHT = 644,
         floorCount = 0,
         floorMapInfo = {
         }
      },
      zoneId=0,
      timer=0,
      requiredForceCount=0,
      totalForceCount=0,
      totalMobGroups=0,
      mobGroups=NULL_MOB_GROUPS,
      npcs=NULL_NPCS,
      mobGroupPositions=NULL_GROUP_POSITIONS,
      mobIndexMap=NULL_INDEX_MAP,
      envMarkers=NULL_POI,
      abilities=NULL_ABILITIES,
      abilitiesByMob=NULL_BY_MOB,
      neighbors=NULL_GROUP_NEIGHBORS,
      priorityAbilities=NULL_PRIORITY_ABILITIES
   };
end
