--local groupEventsFrame = CreateFrame("FRAME", "dmGroupEventsFrame");
--print("ADDON_LOADED registered: " .. tostring(rootEventsFrame:RegisterEvent("ADDON_LOADED")));
-- frame:RegisterEvent("PLAYER_LOGOUT")
-- frame:RegisterEvent("CHAT_MSG_ADDON");
-- frame:RegisterEvent("CHAT_MSG_CHANNEL");
--print("CHAT_MSG_PARTY registered: " .. tostring(rootEventsFrame:RegisterEvent("CHAT_MSG_PARTY")));
--print("CHAT_MSG_WHISPER registered: " .. tostring(rootEventsFrame:RegisterEvent("CHAT_MSG_WHISPER")));
--print("COMBAT_LOG_EVENT_UNFILTERED registered: " .. tostring(rootEventsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")));
--groupEventsFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
--groupEventsFrame:RegisterEvent("RAID_ROSTER_UPDATE");
--rootEventsFrame:RegisterEvent("CHALLENGE_MODE_START");
-- rootEventsFrame:RegisterEvent("CHALLENGE_MODE_END");
--rootEventsFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
--rootEventsFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
--rootEventsFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED");
--rootEventsFrame:RegisterEvent("WORLD_STATE_TIMER_START");
--rootEventsFrame:RegisterEvent("CHAT_MSG_ADDON");

local currentGroupList = {
   isRaid = 0,
   isGroup = 0,
   isSolo = 0,
   size = 0,
   items = {
     -- [1] = {playerGuid="", playerName="", unitId=""}
   }
};

local groupMembersCache = {size = 0, items = {}};

local numberPlayersInGroup = 1;

function DM_Group_InitGroupList()
   currentGroupList = {
      isRaid = 0,
      isGroup = 0,
      isSolo = 0,
      size = 0,
      items = {
        -- [1] = {playerGuid="", playerName="", unitId=""}
      }
   };
   
   groupMembersCache = {size = 0, items = {}};
end

function DM_Group_GroupSize()
   return currentGroupList.size;
end

function DM_Group_IsGuidAPlayer(guid)
   for i=1, currentGroupList.size do
      if guid == currentGroupList.items[i].playerGuid then
         return true;
      end
   end

   return false;
end

function DM_Group_GroupMember(index)
   return currentGroupList.items[index];
end

function DM_Group_DidGroupSizeChange(currentPlayersInGroup)
   if numberPlayersInGroup ~= currentPlayersInGroup then
      return true;
   end

   return false;
end

function DM_Group_DidGroupChange(currentGroup)
   if groupMembersCache.size ~= currentGroupList.size then
      return true;
   end

   for i=1, currentGroupList.size do
      if groupMembersCache.items[currentGroupList.items[i].playerGuid] == nil then
         return true;
      end
   end

   return false;
end

function DM_Group_AnyPlayersDead()
   if not currentGroupList or currentGroupList.size == 0 then
      return false;
   end

   for i = 1, currentGroupList.size do
      local unitId = currentGroupList.items[i].unitId;

      if UnitIsDeadOrGhost(unitId) then
         return true;
      end
   end

   return false;
end

function DM_Group_CacheMembers()
   groupMembersCache.size = currentGroupList.size;
   groupMembersCache.items = {};
   for i=1, currentGroupList.size do
      groupMembersCache.items[currentGroupList.items[i].playerGuid] = 1;
   end

   -- print("--- group members cached ---");
   --print("CacheMembers: group changed, group is now:");
   for i=1, currentGroupList.size do
      --print("#" .. tostring(i) .. ": " .. currentGroupList.items[i].playerName .. ", guid=" .. currentGroupList.items[i].playerGuid);
      --print("#" .. tostring(i) .. ": " .. currentGroupList.items[i].playerName .. "-" .. currentGroupList.items[i].realmName .. " (g=" .. currentGroupList.items[i].playerGuid .. ", r=" .. currentGroupList.items[i].playerRole ..")");
   end
end

local commTargetPriority = {};

function DM_Group_RefreshPriorityOrder()
   commTargetPriority = {size=0, items={}};

   commTargetPriority.size = numberPlayersInGroup;

   -- Pass 1: find TANK
   for i = 1, currentGroupList.size do
      local p = currentGroupList.items[i].playerRole;

      if p.playerRole == "TANK" then
         commTargetPriority.size = commTargetPriority.size + 1;
         commTargetPriority.items[commTargetPriority.size] = {groupIndex=i};
      end
   end

   -- Pass 2: find HEALER
   for i = 1, currentGroupList.size do
      local p = currentGroupList.items[i].playerRole;

      if p.playerRole == "HEALER" then
         commTargetPriority.size = commTargetPriority.size + 1;
         commTargetPriority.items[commTargetPriority.size] = {groupIndex=i};
      end
   end

   -- Pass 3: find DAMAGER
   for i = 1, currentGroupList.size do
      local p = currentGroupList.items[i].playerRole;

      if p.playerRole == "DAMAGER" then
         commTargetPriority.size = commTargetPriority.size + 1;
         commTargetPriority.items[commTargetPriority.size] = {groupIndex=i};
      end
   end
end

function GetPrimary()
end

function DM_Group_RefreshMembers()
   local num = GetNumGroupMembers();
   local uId = "player";
   local playerClassIndex;
   local realmName;

   if num == 0 then
      num = 1;
   end

   numberPlayersInGroup = num;

   currentGroupList.size = num;
   _,_,playerClassIndex = UnitClass(uId);
   _,realmName = UnitFullName(uId);
   --print("realmName: " .. realmName);
   currentGroupList.items = {[1] = {playerGuid=UnitGUID(uId), playerName=UnitName(uId), realmName=realmName or GetRealmName(),
                                    unitId=uId, playerClass=playerClassIndex, playerRole=UnitGroupRolesAssigned(uId) }};

   if IsInRaid() then
      currentGroupList.isRaid = 1;
      currentGroupList.isSolo = 0;
      currentGroupList.isGroup = 0;

      for i = 2, num do
         uId = "raid" .. (i-1);
         _,_,playerClassIndex = UnitClass(uId);
         _,realmName = UnitFullName(uId);
         currentGroupList.items[i] = {playerGuid=UnitGUID(uId), playerName=UnitName(uId), realmName=realmName or GetRealmName(), 
                                      unitId=uId, playerClass=playerClassIndex, playerRole=UnitGroupRolesAssigned(uId) };
      end
   elseif IsInGroup() then
      currentGroupList.isRaid = 0;
      currentGroupList.isSolo = 0;
      currentGroupList.isGroup = 1;

      for i = 2, num do
         uId = "party" .. (i-1);
         _,realmName = UnitFullName(uId);
         _,_,playerClassIndex = UnitClass(uId);
         currentGroupList.items[i] = {playerGuid=UnitGUID(uId), playerName=UnitName(uId), realmName=realmName or GetRealmName(),
                                      unitId=uId, playerClass=playerClassIndex, playerRole=UnitGroupRolesAssigned(uId) };
      end
   else
      currentGroupList.isRaid = 0;
      currentGroupList.isSolo = 1;
      currentGroupList.isGroup = 0;
   end

--   print("--- current group ---");
--   print("   size=" .. num);
--   for i = 1, num do
--      print("   #" .. i .. ": " .. currentGroupList.items[i].unitId .. ", " .. currentGroupList.items[i].playerName .. ", " .. currentGroupList.items[i].playerGuid);
--   end

   if DM_Group_DidGroupChange(currentGroupList) then
      -- PopulateRaidAbilityTable();
      DM_Group_CacheMembers();
      DM_Group_RefreshPriorityOrder();
   end
end

function DM_Group_UnitGuidInGroup(guid)
   for i=1,currentGroupList.size do
      if currentGroupList.items[i].playerGuid == guid then
         return true;
      end
   end

   return false;
end

function DM_Group_IsUnitRegistered(guid)
   if registeredUnits == nil or registeredUnits.items[guid] == nil then
      return false;
   end

   return true;
end

function DM_Group_RegisterUnit(guid, name, health, enemy)
   if DM_Group_IsUnitRegistered(guid) == 1 then
      return;
   end

   -- registeredUnits goes nil when all players in group are out of combat
   if registeredUnits == nil then
      registeredUnits = {size = 0, items={}};
   end

   -- note: rate limit controls checking for DPS stopping, 10 determined experimentally on a glasshide basilisk in tanaris
   registeredUnits.items[guid] = {name=name, totalHealth=health, currentHealth=health, deltaHealth=0,
                                  currentRateLimit = 0, maxRateLimit = 10,
                                  dpsTime = 0, dps = 0,
                                  hpsTime = 0, hps = 0,
                                  firstTimestamp=GetTime(), firstTimestamp_old=time(), timeToDeath=0, isEnemy=enemy};
   registeredUnits.size = registeredUnits.size + 1;
end

function DM_Group_GetUnit(guid)
   if not DM_Group_IsUnitRegistered(guid) then
      return nil;
   end

   return registeredUnits.items[guid];
end

function DM_Group_FormatUnitName(unitId, options)
   local buffString = "";
   local buffStringDisplayLen = 0;

   if options.includeBuffs then
     for i=1,40 do
        local buff = UnitBuff(unitId, i);

        if buff ~= nil then
           if highPriorityBuffs[buff] == 1 then
              buffString = "+";
              buffStringDisplayLen = 1;
           end
        end
     end
   end

   local debuffString = "";
   local debuffStringDisplayLen = 0;

   if options.includeDebuffs then
     for i=1,40 do
        local debuff = UnitDebuff(unitId, i);

        if debuff ~= nil then
           if highPriorityDebuffs[debuff] == 1 then
              debuffString = "#";
              debuffStringDisplayLen = 1;
           end
        end
     end
   end

   local raidIconIndex = GetRaidTargetIndex(unitId);
   local raidIconString = "";
   local raidIconDisplayLen = 0;
   local unitName = GetUnitName(unitId);
   local healthString = "";
   local powerString = "";

   if raidIconIndex ~= nil and includeRaidTargetIcon then
      raidIconString = raidTargetIconTextures[raidIconIndex];
      raidIconDisplayLen = 1;
   end

   if options.includeHealth and unitName ~= nil then
   --                         raidHelperColors.healthColor .. col4format .. " " ..
   --                         raidHelperColors.powerColor .. col5format .. "   " ..
      if options.colorHealth ~= nil and options.colorHealth then
        healthString = raidHelperColors.healthColor;
      else
        healthString = "";
      end

      healthString = healthString .. " " .. string.format("%.2f",100*UnitHealth(unitId)/UnitHealthMax(unitId)) .. "";
   end

   if options.includePower and unitName ~= nil then
      if options.colorPower ~= nil and options.colorPower then
         powerString = raidHelperColors.powerColor;
      else
         powerString = "";
      end

      powerString = powerString .. " " .. string.format("%.2f",100*UnitPower(unitId)/UnitPowerMax(unitId)) .. "";
   end

   local deadStr = "";

   if not UnitIsConnected(unitId) and unitName ~= nil then
       deadStr = "   |cFF00FFFF--OFFLINE--";
   end

   if unitName == nil then
      unitName = "<none>";
   end

   return {text=debuffString .. buffString .. raidIconString .. unitName .. healthString .. powerString .. deadStr,
           displayLength=debuffStringDisplayLen + buffStringDisplayLen + raidIconDisplayLen + string.len(unitName .. healthString .. powerString)};
end

-- local function handleGameEvent(self, event, ...)
--    DM_Group_RefreshMembers();
-- end

-- groupEventsFrame:SetScript("OnEvent", handleGameEvent);

DM_Group_RefreshMembers();
