local GlowLib = LibStub("LibCustomGlow-1.0");
local AC = LibStub:GetLibrary("AceComm-3.0");

local trackerEventsFrame = CreateFrame("FRAME", "DM_trackerEventsFrame");

local corruptedRouteHandled = false;
local pullTrackerDisabled = false;
local npcTrackerHistoryIndex = nil;
local replayingHistory = false;

local versionData = "2024-01-09-10-2-0-9";
local playerVersionResponses = {};

DUNGEON_MENTOR_STATUS_CHAT_PREFIX = "VDMxS";

trackerEventsFrame:RegisterEvent("CHALLENGE_MODE_START");
trackerEventsFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
trackerEventsFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
trackerEventsFrame:RegisterEvent("WORLD_STATE_TIMER_START");
trackerEventsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
trackerEventsFrame:RegisterEvent("SCENARIO_CRITERIA_UPDATE");
trackerEventsFrame:RegisterEvent("READY_CHECK");
trackerEventsFrame:RegisterEvent("READY_CHECK_CONFIRM");
trackerEventsFrame:RegisterEvent("READY_CHECK_FINISHED");
trackerEventsFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
trackerEventsFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
trackerEventsFrame:RegisterEvent("RAID_ROSTER_UPDATE");

local activeDungeonContext = nil;

local challengeModeStartTime = nil;

local trackerWindowPrefix = "Dungeon Mentor: ";
local trackerViewTitles = { [1] = "Planned Pulls", [2] = "Off-Route Pulls", [3] = "Spawned Mobs" };
local trackerNextViewOrder = {[1] = 2, [2] = 3, [3] = 1};
local trackerPrevViewOrder = {[1] = 3, [2] = 1, [3] = 2};

local highPriorityFrame = nil;
local timerStatusBar = nil;
local timerStatusBarRoot = nil;

local trackerWindow = nil;
local trackerLines = {size=0, items={}};
local DEFAULT_TRACKER_LINE_COUNT = 0;

local trackerScrollFrame;
local trackerScrollChild;
local trackerLines = {size=0,items={}};

local bloodlustUpTime = nil;

local actorLastEventTimeByGuid = {};

local currentDeadForces = 0; -- this combines on/off/min forces routes

local dungeonForcesInactiveText = "";

local VIEW_ON_ROUTE = 1;
local VIEW_OFF_ROUTE = 2;
local VIEW_SPAWNED = 3;
local VIEW_MIN_FORCES_NEEDED = 4;

local UNLINKED_PULL = 0;
local LINKED_PULL_CHAIN_START = 1;
local LINKED_PULL_CHAIN_CONTINUED = 2;

local onRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
local offRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
local minForcesRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
local activeRoute = onRoute;
local activeView = VIEW_ON_ROUTE;
local spawned = {mobs={size=0, items={}}, guids={}, deadMobs={}, deadForces=0};

local currentLightState = 0;

local lightStates = {
   afk = {},
   food = {},
   mana = {}
};

local trackedPriorityEvents = {size=0, items={}};

local TimeSinceLastUpdate = 0;
local UPDATE_INTERVAL = 0.05;

local stoplightAnimationTime = nil;
local stoplightAnimationActive = false;
local stoplightAnimationSpan = 0.1;
local maxColor = 255;
local minColor = 100;

local lightRedComponent = 0;
local lightGreenComponent = 0;
local lightBlueComponent = 0;

local forceText;
local timerText;

local forcesCriteriaIndex = nil;

local lightIcon;

local nextPullGroup = 1;

local groupNotesShown = {};

local dawnDiscriminatorFrame;
local dawnDiscriminator = 1;

local bloodlustLines = {size=0, items={}};

local manaIcon;
local afkIcon;
local foodIcon;
local routeCorruptionIcon;
local wingsIcon;

-- Immediate action data
local currentImmediateAction = nil;

-- important: these are in priority order. lower number = higher priority
local IMMEDIATE_ACTION_EMPTY = 0;
local IMMEDIATE_ACTION_CUSTOM = 1;
local IMMEDIATE_ACTION_SIGNAL_RELEASE = 100;
local IMMEDIATE_ACTION_SAFE_TO_RELEASE = 101;
local IMMEDIATE_ACTION_DO_NOT_RELEASE = 102;
local IMMEDIATE_ACTION_DUNGEON_ON_MYTHIC = 1000;
local IMMEDIATE_ACTION_DUNGEON_NOT_MYTHIC = 1001;

local immediateActionText = {
   [IMMEDIATE_ACTION_EMPTY] = "",
   [IMMEDIATE_ACTION_DO_NOT_RELEASE] = "DO NOT RELEASE",
   [IMMEDIATE_ACTION_SAFE_TO_RELEASE] = "SAFE TO RELEASE",
   [IMMEDIATE_ACTION_SIGNAL_RELEASE] = "CLICK WINGS TO SIGNAL SAFE TO RELEASE",
   --[IMMEDIATE_ACTION_DUNGEON_ON_MYTHIC] = "DUNGEON ON MYTHIC",
   [IMMEDIATE_ACTION_DUNGEON_ON_MYTHIC] = "",
   [IMMEDIATE_ACTION_DUNGEON_NOT_MYTHIC] = "DUNGEON NOT ON MYTHIC",
   [500] = "TEST MESSAGE"
};

local historyTrackingEnabled = false;

--- messaging ---

local MESSAGE_TYPE_AFK = 1000;
local MESSAGE_TYPE_MANA = 1001;
local MESSAGE_TYPE_FOOD = 1002;

local MESSAGE_TYPE_ANNOUNCE_MOB_HIT = 2000;
local MESSAGE_TYPE_ANNOUNCE_MOB_DEATH = 2001;

AC:RegisterComm(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, function(prefix, message, distribution, sender)
    local bits = DM_Util_SplitString(message, ":");
    local dmEvent = bits[1];

    local combatLogTimestamp = nil;
    local timestamp = nil;
    local guid = nil;
    local playerInvolved = nil;
    local areaKey = nil;
    local mobGroup = nil;
    local mobIndex = nil;
    local wasExternal = nil;
    local wasSkipped = nil;
    local flags = nil;

    if dmEvent == "release" then
        DM_Trackers_HandleReleaseMessage(tonumber(bits[2]));
        return;
    end

    if dmEvent == "afk" then
        DM_Trackers_HandleAfkStatus(sender, tonumber(bits[2]));
    end
    if dmEvent == "food" then
        DM_Trackers_HandleFoodStatus(sender, tonumber(bits[2]));
    end
    if dmEvent == "mana" then
        DM_Trackers_HandleManaStatus(sender, tonumber(bits[2]));
    end

    if dmEvent == "mobhit" then
        if bits[2] ~= nil then
            combatLogTimestamp = tonumber(bits[2]);
        end
        if bits[3] ~= nil then
            timestamp = tonumber(bits[3]);
        end
        guid = bits[4];
        playerInvolved = (bits[5] == "true");
        areaKey = bits[6];
        mobGroup = bits[7];
        if bits[8] ~= "nil" then
            mobIndex = tonumber(bits[8]);
        end
        if bits[9] ~= "nil" then
            wasExternal = (bits[9] == "true");
        end

        DM_Trackers_HandleExternalMobHit(timestamp, nil, guid, playerInvolved, areaKey, mobGroup, mobIndex);
        return;
    end

    if dmEvent == "mobdeath" then
        if bits[2] ~= nil then
            combatLogTimestamp = tonumber(bits[2]);
        end
        if bits[3] ~= nil then
            timestamp = tonumber(bits[3]);
        end
        guid = bits[4];
        playerInvolved = (bits[5] == "true");
        areaKey = bits[6];
        mobGroup = bits[7];
        if bits[8] ~= "nil" then
            mobIndex = tonumber(bits[8]);
        end
        if bits[9] ~= "nil" then
            wasExternal = (bits[9] == "true");
        end
        if bits[10] ~= "nil" then
            wasSkipped = (bits[10] == "true");
        end
        if bits[11] ~= "nil" then
            flags = bits[11];
        end

        DM_Trackers_HandleExternalMobDeath(timestamp, nil, guid, playerInvolved, areaKey, mobGroup, mobIndex, wasSkipped, flags);
        return;
    end

    if dmEvent == "versionRequest" then
        DM_Trackers_SendVersionReply(sender);
    end

    if dmEvent == "versionReply" then
        DM_Trackers_HandleVersionCheck(sender, bits[2]);
    end
 end);
 
function DM_Status_AnnounceAfk(state, includePartyChat)
    DM_Comm_SendAfkStatus(state, includePartyChat);
end

function DM_Status_AnnounceFood(state, includePartyChat)
    DM_Comm_SendFoodStatus(state, includePartyChat);
end

function DM_Status_AnnounceMana(state, includePartyChat)
    DM_Comm_SendManaStatus(state, includePartyChat);
end

function DM_Trackers_SendVersionReply(sender)
    AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                       "versionReply:" .. versionData,
                       "WHISPER", sender, "NORMAL");
end

function DM_Trackers_StartVersionRequests()
    playerVersionResponses = {};

    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if member and member.playerName ~= "Unknown" then
            local whisperTarget = member.playerName;

            if member.realmName then
                whisperTarget = whisperTarget  .. "-" .. member.realmName;
            end

            if whisperTarget and member.unitId and UnitIsConnected(member.unitId) then
                AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                                   "versionRequest:0", 
                                   "WHISPER", whisperTarget, "NORMAL");
            end
        end
    end
end

function DM_Trackers_HandleVersionCheck(sender, v)
    playerVersionResponses[sender] = v;

    -- print(tostring(sender) .. " is running Dungeon Mentor version " .. tostring(v));

    -- 1,2,3 are year, month, day
    -- 4,5,6,7 are game version major, game version minor, addon major, addon minor

    local bits = DM_Util_SplitString(v, "-");
    local gameMajor = tonumber(bits[4]);
    local gameMinor = tonumber(bits[5]);
    local addonMajor = tonumber(bits[6]);
    local addonMinor = tonumber(bits[7]);

    bits = DM_Util_SplitString(versionData, "-");
    local currentGameMajor = tonumber(bits[4]);
    local currentGameMinor = tonumber(bits[5]);
    local currentAddonMajor = tonumber(bits[6]);
    local currentAddonMinor = tonumber(bits[7]);

    local v = addonMajor * 10000 + addonMinor;
    local cv = currentAddonMajor * 10000 + currentAddonMinor;

    if cv < v then
        -- rgb(221,160,221) DDA0DD
        --print("|cFFDDA0DD<DM> Your version of Dungeon Mentor is out-of-date.|r");
        --print("|cFFDDA0DD<DM> Update now from curseforge to ensure your addon is fully operational.|r");
        DM_Util_PrintSystemMessage("Your version of Dungeon Mentor is out-of-date.");
        DM_Util_PrintSystemMessage("Update now from curseforge to ensure your addon is fully operational.");
    end
end

function DM_Comm_SendAfkStatus(status, includePartyChat)
     for i = 1, DM_Group_GroupSize() do
         local member = DM_Group_GroupMember(i);

         if DM_Trackers_CanAnnounceTo(member) then
            local whisperTarget = member.playerName .. "-" .. member.realmName;
  
            AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                               "afk:" .. tostring(status), 
                               "WHISPER", whisperTarget, "NORMAL");
         end
    end

    if includePartyChat then
        if status == 0 then
            DM_Comm_SendGroupMessage("I am back/ready");
        elseif status == 1 then
            DM_Comm_SendGroupMessage("Requesting a slow to AFK briefly");
        elseif status == 2 then
            DM_Comm_SendGroupMessage("Requesting a stop to AFK for a few");
        end
    end
end

function DM_Comm_SendFoodStatus(status, includePartyChat)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
           local whisperTarget = member.playerName .. "-" .. member.realmName;

           AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                           "food:" .. tostring(status), 
                           "WHISPER", whisperTarget, "NORMAL");
        end
    end

    if includePartyChat then
        if status == 0 then
            DM_Comm_SendGroupMessage("Health/food buff is good, I am ready");
        elseif status == 1 then
            DM_Comm_SendGroupMessage("Requesting a slow for food buff/health");
        elseif status == 2 then
            DM_Comm_SendGroupMessage("Requesting a stop for food buff/health");
        end
    end
end

function DM_Comm_SendGroupMessage(message)
    SendChatMessage(message, "PARTY");
end

function DM_Comm_SendWhisper(target, message)
    SendChatMessage(message, "WHISPER", nil, target);
end

function DM_Comm_SendManaStatus(status, includePartyChat)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
           local whisperTarget = member.playerName .. "-" .. member.realmName;

           AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                           "mana:" .. tostring(status), 
                           "WHISPER", whisperTarget, "NORMAL");
        end
    end

    if includePartyChat then
        if status == 0 then
            DM_Comm_SendGroupMessage("Mana is good, I am ready");
        elseif status == 1 then
            DM_Comm_SendGroupMessage("Requesting a slow for mana regeneration");
        elseif status == 2 then
            DM_Comm_SendGroupMessage("Requesting a stop for mana regeneration");
        end
    end
end

function DM_Comm_SendSafeToReleaseStatus(status)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
           local whisperTarget = member.playerName .. "-" .. member.realmName;

           AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
                           "release:" .. tostring(status), 
                           "WHISPER", whisperTarget, "NORMAL");
        end
    end

    DM_Comm_SendGroupMessage("Safe to release");
end

function DM_Trackers_HandleReleaseMessage(status)
    if status == 1 then
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_SAFE_TO_RELEASE);
    end
end

function DM_Trackers_InitHistory()
    if not historyTrackingEnabled then
        return;
    end

    print("Dungeon Mentor: history tracking initialized");

    if not DM_Tracker_History then
        DM_Tracker_History = {};
    end

    local zoneId = DM_Util_GetCurrentZoneId();

    if not DM_Tracker_History[zoneId] then
        DM_Tracker_History[zoneId] = {size=0, items={}};
    end

    DM_Tracker_History[zoneId].size = DM_Tracker_History[zoneId].size + 1;
    DM_Tracker_History[zoneId].items[DM_Tracker_History[zoneId].size] = {size=0, items={}};

    npcTrackerHistoryIndex = DM_Tracker_History[zoneId].size;
end

function DM_Trackers_ShowHistory(zoneId)
    if not historyTrackingEnabled then
        return;
    end

    local dungeonNames = {
        [1763] = "ATAL", [1501] = "BRH", [1466] = "DHT", [2579] = "DOTI", [1279] = "EB", [643] = "TOTT", [1862] = "WM"
    };

    if not DM_Tracker_History or not DM_Tracker_History[zoneId] then
        print("No history found for " .. dungeonNames[zoneId]);
    else
        print(tostring(DM_Tracker_History[zoneId].size) .. " history entries found for " .. dungeonNames[zoneId]);
    end
end

function DM_Trackers_RecordMobHit(ts1, ts2, g, playerInvolved, ak, mg, idx, wasEx)
    if not historyTrackingEnabled then
        return;
    end

    if not npcTrackerHistoryIndex then
        return;
    end

    if replayingHistory then
        return;
    end

    if not playerInvolved then
        print("DM_Trackers_RecordMobHit: not player involved, skipping logging event");
        return;
    end

    if not DM_Trackers_IsChallengeModeActive() then
        return;
    end

    local zoneId = DM_Util_GetCurrentZoneId();
    local history = DM_Tracker_History[zoneId].items[npcTrackerHistoryIndex];

    if history.size == 0 then
        history.createdTime = ts2;
    end

    history.size = history.size + 1;
    history.items[history.size] = {
        eventType=1,
        combatLogTimestamp=ts1,
        timestamp=ts2,
        guid=g,
        p=playerInvolved,
        areaKey=ak,
        mobGroup=mg,
        index=idx,
        wasExternal=wasEx
    };
end

function DM_Trackers_RecordMobDeath(ts1, ts2, g, playerInvolved, ak, mg, idx, wasEx, wasS, f)
    if not historyTrackingEnabled then
        return;
    end

    if not npcTrackerHistoryIndex then
        return;
    end

    if replayingHistory then
        return;
    end

    local zoneId = DM_Util_GetCurrentZoneId();
    local history = DM_Tracker_History[zoneId].items[npcTrackerHistoryIndex];

    if history.size == 0 then
        history.createdTime = ts2;
    end

    history.size = history.size + 1;
    history.items[history.size] = {
        eventType=2,
        combatLogTimestamp=ts1,
        timestamp=ts2,
        guid=g,
        p=playerInvolved,
        areaKey=ak,
        mobGroup=mg,
        index=idx,
        wasExternal=wasEx,
        wasSkipped=wasS,
        flags=f
    };
end

function DM_Trackers_PlayerHasDm(groupMember)
    return playerVersionResponses[groupMember.playerName .. " - " .. groupMember.realmName] ~= nil or
           playerVersionResponses[groupMember.playerName] ~= nil;
end

function DM_Trackers_CanAnnounceTo(groupMember)
    return groupMember and groupMember.unitId and UnitIsConnected(groupMember.unitId) and DM_Trackers_PlayerHasDm(groupMember);
end

function DM_Trackers_AnnounceMobHit(combatLogTimestamp, timestamp, guid, playerInvolved, areaKey, mobGroup, mobRelativeIndex, mobAbsoluteIndex, wasExternal)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
            local whisperTarget = member.playerName .. "-" .. member.realmName;

            AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
            "mobhit:" .. tostring(combatLogTimestamp) 
                    .. ":" .. tostring(timestamp)
                    .. ":" .. tostring(guid)
                    .. ":" .. tostring(playerInvolved)
                    .. ":" .. tostring(areaKey)
                    .. ":" .. tostring(mobGroup)
                    .. ":" .. tostring(mobRelativeIndex)
                    .. ":" .. tostring(wasExternal), "WHISPER", whisperTarget, "NORMAL");
        end
    end
end

function DM_Trackers_AnnounceMobSkip(timestamp, guid, playerInvolved, areaKey, mobGroup, mobRelativeIndex, mobAbsoluteIndex, wasExternal)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
            local whisperTarget = member.playerName .. "-" .. member.realmName;

            AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
            "mobskip:" .. tostring(combatLogTimestamp) 
                    .. ":" .. tostring(timestamp)
                    .. ":" .. tostring(guid)
                    .. ":" .. tostring(playerInvolved)
                    .. ":" .. tostring(areaKey)
                    .. ":" .. tostring(mobGroup)
                    .. ":" .. tostring(mobRelativeIndex)
                    .. ":" .. tostring(wasExternal), "WHISPER", whisperTarget, "NORMAL");
        end
    end
end

function DM_Trackers_AnnounceMobDeath(combatLogTimestamp, timestamp, guid, playerInvolved, areaKey, mobGroup, mobRelativeIndex, mobAbsoluteIndex, wasExternal, wasSkipped, flags)
    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        if DM_Trackers_CanAnnounceTo(member) then
            local whisperTarget = member.playerName .. "-" .. member.realmName;

            AC:SendCommMessage(DUNGEON_MENTOR_STATUS_CHAT_PREFIX, 
            "mobdeath:" .. tostring(combatLogTimestamp) 
                    .. ":" .. tostring(timestamp)
                    .. ":" .. tostring(guid)
                    .. ":" .. tostring(playerInvolved)
                    .. ":" .. tostring(areaKey)
                    .. ":" .. tostring(mobGroup)
                    .. ":" .. tostring(mobAbsoluteIndex)
                    .. ":" .. tostring(wasExternal)
                    .. ":" .. tostring(wasSkipped)
                    .. ":" .. tostring(flags), "WHISPER", whisperTarget, "NORMAL");
        end
    end
end

local historySessionMobHitIndex = nil;
local historySessionMobDeathIndex = nil;
local activeHistorySession = nil;

function DM_Trackers_ReplayNextMobHit()
    if not activeHistorySession then
        print("no active history session");
        return;
    end

    local index = historySessionMobHitIndex+1;
    for i = index, activeHistorySession.size do
        local h = activeHistorySession.items[i];

        if h.eventType == 1 and h.p then
            if h.wasExternal then
                print("replaying external mob hit=" .. tostring(h.guid) .. " at index=" .. tostring(i));
                DM_Trackers_HandleExternalMobHit(h.combatLogTimestamp, nil, h.guid, h.p, h.index);
            else
                print("replaying mob hit: guid=" .. tostring(h.guid) .. " at index=" .. tostring(i));
                DM_Trackers_HandleMobHit(h.combatLogTimestamp, nil, h.guid, true, h.index);
            end

            historySessionMobHitIndex = i;
            return;
        end
    end
end

function DM_Trackers_ReplayNextMobDeath()
    if not activeHistorySession then
        print("no active history session");
        return;
    end

    local index = historySessionMobDeathIndex+1;
    for i = index, activeHistorySession.size do
        local h = activeHistorySession.items[i];

        if h.eventType == 2 then
            if h.wasExternal then
                print("replaying external mob death=" .. tostring(h.guid) .. " at index=" .. tostring(i));
                DM_Trackers_HandleExternalMobDeath(h.combatLogTimestamp, nil, h.guid, h.p, h.areaKey, h.mobGroup, h.index, h.wasSkipped, h.flags);
            else
                DM_Trackers_HandleNpcDeath(h.combatLogTimestamp, nil, h.guid, h.wasSkipped, h.flags);
            end

            historySessionMobDeathIndex = i;
            return;
        end
    end
end

function DM_Trackers_StartHistoryReplay(zoneId, index)
    if not DM_Tracker_History or not DM_Tracker_History[zoneId] or not DM_Tracker_History[zoneId].items[index] then
        print("cannot start history session: entry not found for zone id/index specified")
    end

    print("history replay session starting");

    replayingHistory = true;

    historySessionMobHitIndex = 0;
    historySessionMobDeathIndex = 0;

    activeHistorySession = DM_Tracker_History[zoneId].items[index];
end

function DM_Trackers_StopHistoryReplay()
    print("history replay session ending");

    replayingHistory = false;
    historySessionMobHitIndex = 0;
    historySessionMobDeathIndex = 0;
    activeHistorySession = nil;
end

function DM_Trackers_InitRoute()
    onRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
    offRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
    minForcesRoute = {pulls={size=0, items={}}, guids={}, deadPulls={}, deadForces=0};
    activeRoute = onRoute;
    activeView = VIEW_ON_ROUTE;
    spawned = {mobs={size=0, items={}}, guids={}, deadMobs={}, deadForces=0};

    groupNotesShown = {};
end

function DM_Trackers_SetView_OnRoute()
    activeRoute = onRoute;
    activeView = VIEW_ON_ROUTE;
end

function DM_Trackers_SetView_OffRoute()
    activeRoute = offRoute;
    activeView = VIEW_OFF_ROUTE;
end

function DM_Trackers_SetView_Spawned()
    activeRoute = nil;
    activeView = VIEW_SPAWNED;
end

function DM_Trackers_SetView_MinForces()
    activeRoute = minForcesRoute;
    activeView = VIEW_MIN_FORCES_NEEDED;
end

function DM_Trackers_ChangeView(view)
    if view == VIEW_ON_ROUTE then
        DM_Trackers_SetView_OnRoute();
    elseif view == VIEW_OFF_ROUTE then
        DM_Trackers_SetView_OffRoute();
    elseif view == VIEW_SPAWNED then
        DM_Trackers_SetView_Spawned();
    elseif view == VIEW_MIN_FORCES_NEEDED then
        DM_Trackers_SetView_MinForces();
    end

    DM_Trackers_RefreshPullTracker();
end

function DM_Trackers_ClearAndHideLines(startLineIndex)
    for i = startLineIndex, trackerLines.size do
        local line = DM_Trackers_GetTrackerLine(i);
        line.primaryText:SetText("...");
        line:Hide();
    end
end

function DM_Trackers_IsChallengeModeActive()
    return C_ChallengeMode.GetActiveChallengeMapID() ~= nil;
end

local activeRouteContext = nil;

-- This is destructive to any already instantiated route
function DM_Trackers_CreateOnRouteInstance()
    --print("DM_Trackers_CreateOnRouteInstance");
    local route = DM_RouteBuilder_CurrentRoute();

    onRoute.pulls = DM_Trackers_CreateRouteInstance(route);
    --DM_RouteBuilder_CurrentRouteContext(), DM_RouteBuilder_GetCurrentDungeonNotes());

    DM_Trackers_SetActiveRouteContext(route);
end

function DM_Trackers_CreateOffRouteInstance()
    -- TODO
    -- offRoute.pulls = DM_Trackers_CreateRouteInstance(DM_RouteBuilder_OffRouteContext(), DM_RouteBuilder_GetCurrentDungeonNotes());
end

function DM_Trackers_InitPullWindows()
--print("DM_Trackers_InitPullWindows");
    DM_Trackers_InitRoute();
    DM_Trackers_CreateOnRouteInstance();
    DM_Trackers_CreateOffRouteInstance();
    DM_Trackers_RefreshPullTracker();
end

function DM_Trackers_SetActiveRouteContext(routeContext)
    activeRouteContext = routeContext;
end

function DM_Trackers_GetActiveRouteContext()
    return activeDungeonContext;
end

function DM_Trackers_GetActiveDungeonContext()
    if not activeRouteContext then
        return nil;
    end

    return DM_Dungeons_GetDungeonContextByZone(activeRouteContext.zoneId, activeRouteContext.zoneDiscriminator);
end

function DM_Trackers_CreateRouteInstance(route, dungeonNotes)
    if not route then
        DM_Util_PrintSystemMessage("ERROR: DM_Trackers_CreateRouteInstance cannot create route instance, no route provided");
        return;
    end
--print("DM_Trackers_CreateRouteInstance: route=" .. tostring(route));
--print("route, zoneid=" .. tostring(route.zoneId) .. ", zone discriminator=" .. tostring(route.zoneDiscriminator));
-- NOTE: dungeonNotes currently does nothing
    local dungeonCtx = DM_Dungeons_GetDungeonContextByZone(route.zoneId, route.zoneDiscriminator);
    -- local r = routeContext.route;
    local nextLineIndex = 1;

    -- if r == nil then
    --     return nil;
    -- end

    local routeInstance = {size = 0, items={}};

    local previousAreaKey = nil;

    local nextPullNumber = 0;

    --print("# route items: " .. tostring(route.routeItems.size));

    for i = 1, route.routeItems.size do
        local routeItem = route.routeItems.items[i];
        local areaKey = routeItem.areaKey;
        local mobGroup = routeItem.mobGroup;
        local n = routeItem.note;

        local metadata = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup].metadata;
        local mobGroupList = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup].mobs;
        local mutexMobGroupList = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup].mutexMobs;

        if mobGroupList == nil then
            DM_Util_PrintSystemMessage("ERROR: no mob group found for: [" .. mobGroup .. "], mob group count likely off in dungeon data");
            return;
        end

        -- we're only adding an area header line when the area changes, this could be
        -- as often as every pull group (but hopefully not, in actual usage)
        if areaKey ~= previousAreaKey then
            routeInstance.size = routeInstance.size + 1;
            routeInstance.items[routeInstance.size] = { mobGroup=nil, mobGroupNum=nil,
                                                        absoluteIndex=routeInstance.size,
                                                        isAreaHeader = true, isHeader = false,
                                                        areaKey = areaKey,
                                                        areaName = dungeonCtx.areas[areaKey].name,
                                                        groupSize = 0, deadCount=0, 
                                                        routeNote = n,
                                                        linkStatus=routeItem.linkStatus,
                                                        pullNumber = nil,
                                                        headerIndex=routeInstance.size, prevHeaderIndex=nil };
            nextLineIndex = nextLineIndex + 1;
            previousAreaKey = areaKey;
        end

        -- Every pull group has a header, so we will always add a header line
        routeInstance.size = routeInstance.size + 1;
        nextPullNumber = nextPullNumber + 1;
        routeInstance.items[routeInstance.size] = { mobGroup=mobGroup, mobGroupNum=i, isHeader = true, 
                                                    absoluteIndex=routeInstance.size,
                                                    areaKey = areaKey,
                                                    areaName = dungeonCtx.areas[areaKey].name,
                                                    canActivateAfter = metadata.canActivateAfter,
                                                    groupSize = 0, deadCount=0, 
                                                    routeNote = n,
                                                    linkStatus= routeItem.linkStatus,
                                                    annotations = routeItem.annotations,
                                                    pullNumber = nextPullNumber,
                                                    headerIndex=routeInstance.size, prevHeaderIndex=nil };
        nextLineIndex = nextLineIndex + 1;

        local headerIndex = routeInstance.size;

        if headerIndex > 1 then
            routeInstance.items[routeInstance.size].prevHeaderIndex = routeInstance.items[headerIndex-1].headerIndex;
        end

        for mobIndex, mobCount in pairs(mobGroupList) do
            local m = dungeonCtx.npcs.items[mobIndex];

            routeInstance.items[headerIndex].groupSize = routeInstance.items[headerIndex].groupSize + mobCount;
            for j = 1, mobCount do
                -- there's some poor design here, whether something is top level or in 'status'
                -- is more arbitrary than i'd like, like the "dead" status is a proper status but
                -- then the "skipped" status goes top level, this will be cleaned up in a future
                -- release and likely have functions wrapping data handling to ease the mental load
                routeInstance.size = routeInstance.size + 1;
                routeInstance.items[routeInstance.size] = { mobGroup=mobGroup, mobGroupNum=i, 
                                                            absoluteIndex=routeInstance.size,
                                                            canActivateAfter = metadata.canActivateAfter,
                                                            areaKey = routeItem.areaKey,
                                                            areaName = dungeonCtx.areas[areaKey].name,
                                                            headerIndex=headerIndex, prevHeaderIndex=nil,
                                                            isHeader = false, mob=m, guid=nil,
                                                            linkStatus={isStart=false,isLinked=false},
                                                            pullNumber = nil,
                                                            status={pullTime=nil,aggroTime=nil,
                                                                    pullBy=nil, aggroBy=nil, killTime=nil,
                                                                    skipTime=nil, isDead=false, isActive=false } };
                
                if headerIndex > 1 then
                    routeInstance.items[routeInstance.size].prevHeaderIndex = routeInstance.items[headerIndex-1].headerIndex;
                end

                nextLineIndex = nextLineIndex + 1;
            end
        end

        if mutexMobGroupList and mutexMobGroupList.size > 0 then
            for j = 1, mutexMobGroupList.size do
                -- each mutex mob entry adds 1 mob to group
                routeInstance.items[headerIndex].groupSize = routeInstance.items[headerIndex].groupSize + 1;

                local m1 = dungeonCtx.npcs.items[mutexMobGroupList.items[j].option1];
                local m2 = dungeonCtx.npcs.items[mutexMobGroupList.items[j].option2];

                routeInstance.size = routeInstance.size + 1;
                routeInstance.items[routeInstance.size] = { mobGroup=mobGroup, mobGroupNum=i, 
                                                            absoluteIndex=routeInstance.size,
                                                            areaKey = routeItem.areaKey,
                                                            areaName = dungeonCtx.areas[areaKey].name,
                                                            headerIndex=headerIndex, prevHeaderIndex=nil,
                                                            isHeader = false, 
                                                            guid=nil,
                                                            isMutex=true,
                                                            mutexDisplay=mutexMobGroupList.items[j].display,
                                                            mutexMob1=m1,
                                                            mutexMob2=m2,
                                                            linkStatus={isStart=false,isLinked=false},
                                                            status={pullTime=nil,aggroTime=nil,
                                                                    pullBy=nil, aggroBy=nil, killTime=nil,
                                                                    skipTime=nil, isDead=false, isActive=false } };
                
                if headerIndex > 1 then
                    routeInstance.items[routeInstance.size].prevHeaderIndex = routeInstance.items[headerIndex-1].headerIndex;
                end

                nextLineIndex = nextLineIndex + 1;
            end
        end
    end

    return routeInstance;
end

function DM_Trackers_IsGroupActive(index)
    local pullHeaderIndex = activeRoute.pulls.items[index].headerIndex;
    local pullHeader = activeRoute.pulls.items[pullHeaderIndex];

    -- we go from the group member to the group header, check its bookkeeping first
    if pullHeader.deadCount > 0 and pullHeader.deadCount < pullHeader.groupSize then
        return true;
    end

    -- next we see if any members of the group are active
    for j = pullHeaderIndex+1, pullHeaderIndex+pullHeader.groupSize do
        if activeRoute.pulls.items[j].status.isActive then
            return true;
        end
    end

    return false;
end

function DM_Trackers_IsGroupNextPull(index, ak, mg)
    local pullHeaderIndex = activeRoute.pulls.items[index].headerIndex;
    local pullHeader = activeRoute.pulls.items[pullHeaderIndex];

    local i = index - 1;

    -- we find the first pull line that doesn't match the area key/mob group at 'index'
    while i >= 1 and activeRoute.pulls.items[i].areaKey == ak and activeRoute.pulls.items[i].mobGroup == mg do
        i = i-1;
    end

    -- if this previous group is active, then we know the group at 'index' is next
    if i >= 1 then
        return DM_Trackers_IsGroupActive(i);
    end

    return false;
end

function DM_Trackers_IsPreviousGroupActive(index)
    local pullHeaderIndex = activeRoute.pulls.items[index].headerIndex;

    if pullHeaderIndex == 1 then
        return false;
    end

    -- we leap to the header belonging to the group before the current group
    local delta = 1;

    if activeRoute.pulls.items[pullHeaderIndex-1].isAreaHeader then
        delta = 2;
    end

    if not activeRoute.pulls.items[pullHeaderIndex-delta] then
        return false;
    end

    pullHeaderIndex = activeRoute.pulls.items[pullHeaderIndex-delta].headerIndex;

    local pull = activeRoute.pulls.items[pullHeaderIndex];

    if pull.deadCount > 0 and pull.deadCount < pull.groupSize then
        return true;
    end

    for j = pullHeaderIndex+1, pullHeaderIndex+pull.groupSize do
        if activeRoute.pulls.items[j].status.isActive then
            return true;
        end
    end

    return false;
end

function DM_Trackers_IsLinkedPullStart(p)
    -- we track certain data at the header level, so if we need it we leap up to it
    if not p.isHeader then
        p = activeRoute.pulls.items[p.headerIndex];
    end

   return p.linkStatus and p.linkStatus == LINKED_PULL_CHAIN_START;
end

function DM_Trackers_IsLinkedPull(ri)
    -- we track certain data at the header level, so if we need it we leap up to it
    if not ri.isHeader then
        ri = activeRoute.pulls.items[ri.headerIndex];
    end

    return ri.linkStatus and ri.linkStatus == LINKED_PULL_CHAIN_CONTINUED;
end

function DM_Trackers_IsUnLinked(ri)
    if not ri.isHeader then
        ri = activeRoute.pulls.items[ri.headerIndex];
    end

    return not ri.linkStatus or (ri.linkStatus and ri.linkStatus == UNLINKED_PULL);
end

function DM_Trackers_ShowSpawnedMobs()
    DM_Trackers_ClearAndHideLines(1);
end

local notesDisplayed = nil;

-- big todo: this needs fixing up to take a route context as well as handle mutex mobs, disabling for now
function DM_Trackers_GatherNotesForGroup(areaKey, mobGroup)
    -- local dungeonCtx = DM_Dungeons_GetDungeonContextByCurrentZone();

    -- if not dungeonCtx then
    --     return;
    -- end

    -- if not areaKey or not mobGroup then
    --     print("areaKey/mobGroup are nil, cannot get notes")
    --     return;
    -- end

    -- local pull = nil;
    -- local pullHeaderIndex = 0;

    -- for i = 1, activeRoute.pulls.size do
    --     if activeRoute.pulls.items[i].isHeader and activeRoute.pulls.items[i].mobGroup == mobGroup then
    --         pull = activeRoute.pulls.items[i];
    --         pullHeaderIndex = i;
    --     end
    -- end

    -- local textColors = {[0] = "|cFF00FFFF", [1] = "|cFFFFFFFF"};
    -- local textColorIndex = 0;

    -- local text = "";
    -- local npcsDone = {};
    -- local abilityId = 0;
    -- local textContentSet = false;

    -- text = text .. "GROUP " .. mobGroup .. "\n\n";

    -- for i = 1, pull.groupSize do
    --     local p = activeRoute.pulls.items[pullHeaderIndex + i];
    --     local m = p.mob;

    --     textColorIndex = 0;

    --     -- todo: need to properly handle mutex mobs here
    --     if m and not npcsDone[m.npcid] then
    --         npcsDone[m.npcid] = true;

    --         if dungeonCtx.abilitiesByMob and dungeonCtx.abilitiesByMob[m.npcid] then
    --             for j = 1, dungeonCtx.abilitiesByMob[m.npcid].size do
    --                 abilityId = dungeonCtx.abilitiesByMob[m.npcid].items[j];
    --                 text = text .. textColors[textColorIndex];
    --                 text = text .. m.name .. " :: " .. dungeonCtx.abilities[abilityId].name .. "\n";
    --                 text = text .. "   " .. dungeonCtx.abilities[abilityId].text .. "\n";
    --                 text = text .. "|r";
    --                 textColorIndex = (textColorIndex + 1) % 2;
    --                 textContentSet = true;
    --             end
    --             text = text .. "\n";
    --         end
    --     end
    -- end

    -- if not textContentSet then
    --     return nil;
    -- end

    -- return text;
end

-- TODO: need to pass in route context, disabling this for now
function DM_Trackers_ShowGroupNotes(pull)
    return;
    -- local mobGroup = pull.mobGroup;

    -- if not pull.areaKey or not pull.mobGroup then
    --     -- should never happen, but just in case
    --     return;
    -- end

    -- if not notesDisplayed or not notesDisplayed.areas then
    --     notesDisplayed = {};
    --     notesDisplayed.areas = {};
    -- end

    -- if not notesDisplayed.areas[pull.areaKey] then
    --     notesDisplayed.areas[pull.areaKey] = {};
    -- end

    -- if not notesDisplayed.areas[pull.areaKey] then
    --     print("!!! ERROR in ShowGroupNotes: areas for area key [" .. tostring(pull.areaKey) .. "] is nil and should not be");
    --     return;
    -- end

    -- if not notesDisplayed.areas[pull.areaKey][pull.mobGroup] then
    --     local n = DM_Trackers_GatherNotesForGroup(pull.areaKey, pull.mobGroup);

    --     if n then
    --         notesDisplayed.areas[pull.areaKey][pull.mobGroup] = true;
    --         DM_Info_SetText(n);
    --     end
    -- end
end

function DM_Trackers_GatherGroupBuffsAndDebuffs()
    local status = {size=0, items={}};
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId;

    for i = 1, DM_Group_GroupSize() do
        local member = DM_Group_GroupMember(i);

        status.size = status.size + 1;
        status.items[status.size] = {p=member, buffs={}, debuffs={}};

        for a = 1, 40 do
            name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitDebuff(member.unitId, a);

            if name then
                local db = {name=name, count=count, duration=duration, expirationTime=expirationTime, unitCaster=unitCaster, spellId=spellId};
                status.items[status.size].debuffs[spellId] = db;
                -- tinsert(status.items[status.size].debuffs, db);
            end

            name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff(member.unitId, a);
            if name then
                local b = {name=name, count=count, duration=duration, expirationTime=expirationTime, unitCaster=unitCaster, spellId=spellId};
                status.items[status.size].buffs[spellId] = b;
                --tinsert(status.items[status.size].buffs, b);
            end
        end
    end

    return status;
end

local DISPLAY_EVERYONE = 1;
local DISPLAY_SELF = 2;
local DISPLAY_HEALER = 4;
local DISPLAY_TANK = 8;
local DISPLAY_DPS = 16;

-- priority order:
--    self > role specific > everyone
--    then by specific "priority"

local limitPrint = {};
local MAX_PRINTS = 3;

function DM_Trackers_LimitPrint(key, msg)
    if not limitPrint[key] then
        limitPrint[key] = 0;
    end

    if limitPrint[key] < MAX_PRINTS then
        print(msg);
        limitPrint[key] = limitPrint[key] + 1;
    end
end

function DM_Trackers_ProcessInCombatImmediateMessages()
    local dungeonCtx = DM_Trackers_GetActiveDungeonContext();

    if not dungeonCtx or not dungeonCtx.buffDebuffScan then
        DM_Trackers_LimitPrint("imm1", "Missing dungeon context or buffDebuffScan function");
        return;
    end

    local buffDebuffStatuses = DM_Trackers_GatherGroupBuffsAndDebuffs();
    local processedMessages = dungeonCtx.buffDebuffScan(buffDebuffStatuses);
    local role = UnitGroupRolesAssigned("player");

    local isTank = (role == "TANK");
    local isHealer = (role == "HEALER");
    local isDamager = (role == "DAMAGER");

    -- execute in priority order
    for i = 1, processedMessages.size do
        if processedMessages.items[i].display == DISPLAY_HEALER then
            DM_Trackers_LimitPrint("imm2", "Setting immediate action to: " .. processedMessages.items[i].text);
            DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_CUSTOM, processedMessages.items[i].text);
            return; -- first one wins
        end
    end
end

function DM_Trackers_Test_ProcessInCombatImmediateMessages()
    local dungeonCtx = DM_Trackers_GetActiveDungeonContext();

    if not dungeonCtx or not dungeonCtx.buffDebuffScan then
        DM_Trackers_LimitPrint("imm1", "Missing dungeon context or buffDebuffScan function");
        return;
    end

    --local buffDebuffStatuses = DM_Trackers_GatherGroupBuffsAndDebuffs();
    local buffDebuffStatuses = {
        size = 1,
        items = {
            [1] = {
                p={["unitId"]="player",["playerName"]="Zeljin"},
                debuffs = {
                    -- chronofaded
                    [404141] = {}
                },
                buffs = {
                    -- accelerating
                    [403912] = {}
                }
            }
        }
    };

    local processedMessages = dungeonCtx.buffDebuffScan(buffDebuffStatuses);
    local role = UnitGroupRolesAssigned("player");

    local isTank = (role == "TANK");
    local isHealer = (role == "HEALER");
    local isDamager = (role == "DAMAGER");

    -- execute in priority order
    for i = 1, processedMessages.size do
        if processedMessages.items[i].display == DISPLAY_HEALER then
            DM_Trackers_LimitPrint("imm2", "Setting immediate action to: " .. processedMessages.items[i].text);
            DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_CUSTOM, processedMessages.items[i].text);
            return; -- first one wins
        end
    end
end

function DM_Trackers_UpdateBloodlustTimers()
    local bloodlustBuffNames = {
         ["Bloodlust"] = 1,
         ["Heroism"] = 1,
         ["Fury of the Aspects"] = 1,
         ["Time Warp"] = 1,
         ["Primal Rage"] = 1,
         ["Drums of Rage"] = 1,
         ["Drums of Fury"] = 1,
         ["Drums of the Mountain"] = 1,
         ["Drums of the Maelstrom"] = 1,
         ["Drums of Deathly Ferocity"] = 1,
         ["Feral Hide Drums"] = 1,
    };

    -- spell ids
    -- bloodlust: 
    --     https://www.wowhead.com/spell=2825/bloodlust
    --     https://www.wowhead.com/spell=71975/bloodlust
    --     https://www.wowhead.com/spell=204361/bloodlust
    --     https://www.wowhead.com/spell=369754/bloodlust
    --     https://www.wowhead.com/spell=290583/bloodlust
    --     https://www.wowhead.com/spell=6742/bloodlust
    --     https://www.wowhead.com/spell=420321/bloodlust
    -- heroism:
    --     https://www.wowhead.com/spell=32182/heroism
    --     https://www.wowhead.com/spell=78151/heroism
    --     https://www.wowhead.com/spell=204362/heroism
    --     https://www.wowhead.com/spell=290582/heroism
    --     https://www.wowhead.com/spell=65983/heroism
    --  fury of the aspects:
    --     https://www.wowhead.com/spell=390386/fury-of-the-aspects
    --     https://www.wowhead.com/spell=397744/fury-of-the-aspects
    --     https://www.wowhead.com/spell=431286/fury-of-the-aspects
    --  time warp:
    --     https://www.wowhead.com/spell=80353/time-warp
    --     https://www.wowhead.com/spell=145534/time-warp
    --     https://www.wowhead.com/spell=287925/time-warp
    --     https://www.wowhead.com/spell=397571/time-warp
    --     https://www.wowhead.com/spell=96794/time-warp
    --     https://www.wowhead.com/spell=173106/time-warp
    --     https://www.wowhead.com/spell=121546/time-warp
    --     https://www.wowhead.com/spell=428941/time-warp
    --     https://www.wowhead.com/spell=162128/time-warp
    --  primal rage:
    --     https://www.wowhead.com/spell=264667/primal-rage
    --     https://www.wowhead.com/spell=357650/primal-rage
    --     https://www.wowhead.com/spell=272678/primal-rage
    --  drums of rage:
    --     https://www.wowhead.com/item=102351/drums-of-rage
    --     https://www.wowhead.com/spell=146613/drums-of-rage
    --  drums of fury:
    --     https://www.wowhead.com/item=120257/drums-of-fury
    --     https://www.wowhead.com/spell=178208/drums-of-fury
    -- drums of the mountain:
    --     https://www.wowhead.com/item=142406/drums-of-the-mountain
    --     https://www.wowhead.com/spell=230955/drums-of-the-mountain
    --     https://www.wowhead.com/spell=230954/drums-of-the-mountain
    --     https://www.wowhead.com/spell=230936/drums-of-the-mountain
    -- drums of the maelstrom:
    --     https://www.wowhead.com/item=154167/drums-of-the-maelstrom
    --     https://www.wowhead.com/spell=256791/drums-of-the-maelstrom
    -- Drums of Deathly Ferocity:
    --     https://www.wowhead.com/item=172233/drums-of-deathly-ferocity
    --     https://www.wowhead.com/spell=309173/drums-of-deathly-ferocity
    -- feral hide drums:
    --     https://www.wowhead.com/item=193470/feral-hide-drums

    local bloodlustSpellIds = {
        -- bloodlust
        [2825] = 1,
        [71975] = 1,
        [204361] = 1,
        [369754] = 1,
        [290583] = 1,
        [6742] = 1,
        [420321] = 1,
        -- heroism
        [32182] = 1,
        [78151] = 1,
        [204362] = 1,
        [290582] = 1,
        [65983] = 1,
        -- fury of the aspects
        [390386] = 1,
        [397744] = 1,
        [431286] = 1,
        -- time warp
        [80353] = 1,
        [145534] = 1,
        [287925] = 1,
        [397571] = 1,
        [96794] = 1,
        [173106] = 1,
        [121546] = 1,
        [428941] = 1,
        [162128] = 1,
        -- primal rage
        [264667] = 1,
        [357650] = 1,
        [272678] = 1,
        -- drums of rage
        [102351] = 1, -- item
        [146613] = 1,
        -- drums of fury
        [120257] = 1, -- item
        [178208] = 1,
        -- drums of the mountain
        [142406] = 1, -- item
        [230955] = 1,
        [230954] = 1,
        [230936] = 1,
        -- drums of the maelstrom
        [154167] = 1, -- item
        [256791] = 1,
        -- drums of deathly ferocity
        [172233] = 1, -- item
        [309173] = 1,
        -- feral hide drums
        [193470] = 1,
    };

    -- sated:
    --    https://www.wowhead.com/spell=57724/sated
    -- exhaustion:
    --    https://www.wowhead.com/spell=390435/exhaustion
    --    https://www.wowhead.com/spell=57723/exhaustion
    -- temporal displacement:
    --    https://www.wowhead.com/spell=80354/temporal-displacement
    --    https://www.wowhead.com/spell=288293/temporal-displacement
    -- fatigued:
    --    https://www.wowhead.com/spell=264689/fatigued
    --    

    local bloodlustDebuffNames = {
        ["Sated"] = 1,
        ["Exhaustion"] = 1,
        ["Temporal Displacement"] = 1,
        ["Fatigued"] = 1
    };

    local bloodlustDebuffSpellIds = {
        -- sated
        [57724] = 1,
        -- exhaustion
        [390435] = 1,
        [57723] = 1,
        -- temporal displacement
        [80354] = 1,
        [288293] = 1,
        -- fatigued
        [264689] = 1,
    }

    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId;
    local debuffTimeLeft = nil;
    local buffTimeLeft = nil;

    for d=1,40 do
        name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitDebuff("player", d);

        if expirationTime and (bloodlustDebuffNames[name] or bloodlustDebuffSpellIds[spellId]) then
            debuffTimeLeft = expirationTime - GetTime();
        end

        name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff("player", d);

        if expirationTime and (bloodlustBuffNames[name] or bloodlustSpellIds[spellId]) then
            buffTimeLeft = expirationTime - GetTime();
        end
    end

    -- Prioritize when bloodlust is active, once it falls off we'll report the debuff timer
    if buffTimeLeft and buffTimeLeft > 0 then
        for i = 1, bloodlustLines.size do
            bloodlustLines.items[i].primaryText:SetText("Haste Boost (Bloodlust/Heroism) active for " .. DM_Util_SecondsToClock(buffTimeLeft));
        end
    elseif debuffTimeLeft and debuffTimeLeft > 0 then
        for i = 1, bloodlustLines.size do
            bloodlustLines.items[i].primaryText:SetText("Haste Boost (Bloodlust/Heroism) unavailable for " .. DM_Util_SecondsToClock(debuffTimeLeft));
        end
    else
        for i = 1, bloodlustLines.size do
            bloodlustLines.items[i].primaryText:SetText("Haste Boost (Bloodlust/Heroism) ready");
        end
    end
end

function DM_Trackers_HandleCorruptedRoute()
    if not corruptedRouteHandled then
        DM_Colors_SetIconColor(routeCorruptionIcon, COLOR_KEY_GENERAL_MEDIUM);
        routeCorruptionIcon:Show();
        corruptedRouteHandled = true;
    end
end

function DM_Trackers_EnablePullTracker()
    DM_Colors_SetIconColor(routeCorruptionIcon, COLOR_KEY_GENERAL_MEDIUM);
    routeCorruptionIcon:Hide();
    corruptedRouteHandled = false;
    pullTrackerDisabled = false;
end

function DM_Trackers_DisablePullTracker()
    pullTrackerDisabled = true;
    DM_Colors_SetIconColor(routeCorruptionIcon, COLOR_KEY_GENERAL_LOW);
end

function DM_Trackers_ResetRouteCorruption()
    routeCorruptionIcon:Hide();
    corruptedRouteHandled = false;
    pullTrackerDisabled = false;
end

function DM_Trackers_ShouldDisplayAreaHeader(pulls, areaHeaderIndex)    
    local i = areaHeaderIndex + 1;
    local found = false;
 
    -- first, find next pull line
    while i <= pulls.size and not found do
       local pull = pulls.items[i];
       local isLineActive = not activeRoute.deadPulls[pull.areaKey] or not activeRoute.deadPulls[pull.areaKey][pull.mobGroup];
 
       if isLineActive then
          found = true;
       end

       i = i + 1;
    end
 
    if not found then
       return false;
    end
 
    return pulls.items[i].areaKey == pulls.items[areaHeaderIndex].areaKey;
end

local autoCompletesMarked = {};

function DM_Trackers_ScanPullsForAutocomplete(route, completedCriteria)
    if not route or not route.pulls then
        return;
    end

    if autoCompletesMarked[completedCriteria] then
        return;
    end

    for i = 1, route.pulls.size do
        local p = route.pulls.items[i];

        if p.isMutex and p.mutexMob1 and p.mutexMob1.autocompleteAfter and p.mutexMob1.autocompleteAfter == completedCriteria then
            DM_Trackers_FlagMobAsDead(GetTime(), p.areaKey, p.mobGroup, nil, p.guid, true);
            autoCompletesMarked[completedCriteria] = true;
        elseif p.mob and p.mob.autocompleteAfter and p.mob.autocompleteAfter == completedCriteria then
            DM_Trackers_FlagMobAsDead(GetTime(), p.areaKey, p.mobGroup, nil, p.guid, true);
            autoCompletesMarked[completedCriteria] = true;
        end
    end

    return autoCompletesMarked[completedCriteria];
end

function DM_Trackers_RefreshPullTracker()
    if pullTrackerDisabled then
        return;
    end

    bloodlustLines = {size=0, items={}};

    -- have to special case this since spawned mobs aren't sorted into any sort of group,
    -- there's a few ways we could make this NOT a special case, such as labelling areas of the
    -- dungeon that can spawn mobs with a mob marker (like in shadowmoon burial grounds with the
    -- bone piles) or associate them with an existing mob group (such as the cloud princes in VP,
    -- though those mobs only spawn mobs in M0, so it's just an example)
    if activeView == VIEW_SPAWNED then
        DM_Trackers_ShowSpawnedMobs();
        return;
    end

    if activeRoute == nil then
        return;
    end

    local nextLineIndex = 1;
    local pulls = activeRoute.pulls;

    if not pulls or pulls.size == 0 then
        DM_Trackers_ClearAndHideLines(1);
        return;
    end

    local lastLinkStatus = nil;

    local gatheredNotes = {};

    local headersShown = {};

    local routeItemAnnotationsText = {
        [1] = {
            [0] = "CAUTION!",
            [1] = "SLOW",
            [2] = "WAIT HERE FOR TANK"
        },
        [2] = {
            [0] = "LUST ON PULL",
            [1] = "LUST WHEN CALLED"
        },
        [3] = {
            [0] = "LOS PULL, HIDE"
        },
        [4] = {
            [0] = "INVIS WHEN CALLED"
        },
    }
    
    local initialAreaKey = nil;
    local initialMobGroup = nil;

    local firstInactiveIndex = nil;
    local firstNextPullIndex = nil;

    local skipLine = false;

    local mobIndexWithinGroup = 0;

    for i = 1, pulls.size do
        local pull = pulls.items[i];
        local groupSize = pull.groupSize;
        local line = DM_Trackers_GetTrackerLine(nextLineIndex);

        if not activeRoute.deadPulls[pull.areaKey] or not activeRoute.deadPulls[pull.areaKey][pull.mobGroup] then
            if pull.isAreaHeader then
                if DM_Trackers_ShouldDisplayAreaHeader(pulls, i) then
                   line.isAreaHeader = true;
                   line.isHeader = false;
                   line.flagKilledIcon:Hide();
                   line.flagSkippedIcon:Hide();
                   line.chatOutputIcon:Hide();
                   line.primaryText:SetText("AREA: " .. pull.areaName);
                   DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_AREAHEADER);
                else
                    skipLine = true;
                end
            elseif pull.isHeader then
                mobIndexWithinGroup = 0;

                if initialAreaKey == nil then
                    initialAreaKey = pull.areaKey;
                    initialMobGroup = pull.mobGroup;
                end

                -- route note will take precedence over other annotations
                if pull.routeNote and pull.routeNote.promote and pull.routeNote.text and string.len(pull.routeNote.text) > 0 then
                    line.primaryText:SetText(pull.routeNote.text);
                    line.isHeader = false;
                    line.isAnnotation = true;
                    line.isAreaHeader = false;
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_ROUTE_NOTE);
                    line.flagKilledIcon:Hide();
                    line.flagSkippedIcon:Hide();
                    line.chatOutputIcon:Hide();
                    line:Show();

                    nextLineIndex = nextLineIndex + 1;
                    line = DM_Trackers_GetTrackerLine(nextLineIndex);
                end

                -- add annotations ahead of group header
                if pull.annotations then
                    for a = 1, 10 do
                        if pull.annotations[a] then
                            line.primaryText:SetText(routeItemAnnotationsText[a][pull.annotations[a].msgIndex]);
                            line.isHeader = false;
                            line.isAnnotation = true;
                            line.isAreaHeader = false;
                            DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_ANNOTATION);
                            line.flagKilledIcon:Hide();
                            line.flagSkippedIcon:Hide();
                            line.chatOutputIcon:Hide();
                            line:Show();

                            -- special casing bloodlust annotation
                            if a == 2 then
                                bloodlustLines.size = bloodlustLines.size + 1;
                                bloodlustLines.items[bloodlustLines.size] = line;
                            end

                            nextLineIndex = nextLineIndex + 1;
                            line = DM_Trackers_GetTrackerLine(nextLineIndex);
                      end
                    end
                else
                    --print("no annotations");
                end
                
                line.metadata = { mobGroup = pull.mobGroup,
                                areaKey = pull.areaKey,
                                note = pull.note,
                                routeNote = pull.note,
                                dungeonNote = pull.dungeonNote,
                                groupNotes = {size=0,items={}} };
  
                line.isHeader = true;
                line.isAreaHeader = false;

                line.flagKilledIcon:Show();
                line.flagSkippedIcon:Show();
                line.flagSkippedIcon.mobText = tostring(pull.areaKey) .. ", " .. tostring(pull.mobGroup);
                line.flagSkippedIcon.areaKey = pull.areaKey;
                line.flagSkippedIcon.mobGroup = pull.mobGroup;
                line.flagSkippedIcon.isHeader = true;

                line.flagKilledIcon.mobText = tostring(pull.areaKey) .. ", " .. tostring(pull.mobGroup);
                line.flagKilledIcon.areaKey = pull.areaKey;
                line.flagKilledIcon.mobGroup = pull.mobGroup;
                line.flagKilledIcon.isHeader = true;

                line.chatOutputIcon:Hide();

                local prefix = "#" .. tostring(pull.pullNumber) .. " - ";
                local suffix = tostring(pull.deadCount) .. "/" .. tostring(pull.groupSize);

                if pull.notes and string.len(pull.notes) > 0 then
                    line.primaryText:SetText(prefix .. pull.mobGroup .. " " .. pull.notes .. " " .. suffix);
                else
                    line.primaryText:SetText(prefix .. pull.mobGroup .. " " .. suffix);
                end

                -- this is some tripwire logic for debugging only
                if not headersShown.areas then
                    headersShown.areas = {};
                end
                if not headersShown.areas[pull.areaKey] then
                    headersShown.areas[pull.areaKey] = {};
                end
                if headersShown.areas[pull.areaKey][pull.mobGroup] and headersShown.areas[pull.areaKey][pull.mobGroup] == 1 then
                    -- print("header is showing twice for -- area: " .. tostring(pull.areaKey) .. ", mob group: " .. tostring(pull.mobGroup));
                    headersShown.areas[pull.areaKey][pull.mobGroup] = headersShown.areas[pull.areaKey][pull.mobGroup] + 1;
                else
                    headersShown.areas[pull.areaKey][pull.mobGroup] = 1;
                end

                if DM_Trackers_IsGroupActive(i) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_ACTIVE);
                elseif DM_Trackers_IsLinkedPullStart(pull) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_LINKEDPULLSTART);
                elseif DM_Trackers_IsLinkedPull(pull) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_LINKEDPULL);
                elseif DM_Trackers_IsUnLinked(pull) and DM_Trackers_IsPreviousGroupActive(i, pull.areaKey, pull.mobGroup) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_NEXTGROUP);
                elseif (pull.areaKey == initialAreaKey and pull.mobGroup == initialMobGroup) or DM_Trackers_IsGroupNextPull(i, pull.areaKey, pull.mobGroup) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_NEXTGROUP);

                    DM_Trackers_ShowGroupNotes(pull);
                elseif DM_Trackers_IsUnLinked(pull) then
                    DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_INACTIVE);
                end

                isInitialGroup = false;
            else
                line.metadata = { mobGroup = pull.mobGroup,
                                areaKey = pull.areaKey,
                                note = pull.note,
                                routeNote = pull.note,
                                dungeonNote = pull.dungeonNote,
                                groupNotes = {size=0,items={}} };

                line.flagKilledIcon:Show();
                line.flagSkippedIcon:Show();
                line.chatOutputIcon:Hide();
                line.isHeader = false;
                line.isAreaHeader = false;

                line.metadata.mobIndex = mobIndexWithinGroup;

                line.flagSkippedIcon.mobText = tostring(pull.areaKey) .. ", " .. tostring(pull.mobGroup);
                line.flagSkippedIcon.areaKey = pull.areaKey;
                line.flagSkippedIcon.mobGroup = pull.mobGroup;
                line.flagSkippedIcon.isHeader = false;
                line.flagSkippedIcon.pullData = pull;
                line.flagSkippedIcon.mobIndex = mobIndexWithinGroup;

                line.flagKilledIcon.mobText = tostring(pull.areaKey) .. ", " .. tostring(pull.mobGroup);
                line.flagKilledIcon.areaKey = pull.areaKey;
                line.flagKilledIcon.mobGroup = pull.mobGroup;
                line.flagKilledIcon.isHeader = false;
                line.flagKilledIcon.pullData = pull;
                line.flagKilledIcon.mobIndex = mobIndexWithinGroup;

                mobIndexWithinGroup = mobIndexWithinGroup + 1;

                local m = pull.mob;

                line.pullData = pull;

                local displayText = "";
                local forceCount = 0;
                if pull.isMutex then
                    displayText = pull.mutexDisplay;
                    forceCount = pull.mutexMob1.forceCount;
                else
                    displayText = pull.mob.name;
                    forceCount = pull.mob.forceCount;
                end

                local extendedText = "";

                if pull.status.warningActive then
                    extendedText = DM_Trackers_FormatWarningText(
                        pull.status.warningAbility.warningEvents[pull.status.warningStartEvent].warnText,
                                                                 pull.status.warningAbilityName, 
                                                                 pull.status.warningSourceName, 
                                                                 pull.status.warningSourceGUID, 
                                                                 pull.status.warningDestName, 
                                                                 pull.status.warningDestGUID);
                end

                --line.primaryText:SetText(pull.mobGroupNum .. ": " .. displayText .. " (" .. tostring(forceCount) .. ") " .. extendedText);
                line.primaryText:SetText(displayText .. " (" .. tostring(forceCount) .. ") " .. extendedText);

                local isGroupActive = DM_Trackers_IsGroupActive(i);

                if isGroupActive then
                    if pull.wasSkipped then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_SKIPPED);
                    elseif not pull.status.isDead then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_ACTIVE);
                    elseif pull.status.isDead then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_DEAD);
                    else
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_INACTIVE);
                    end

                    if (firstInactiveIndex and i > firstInactiveIndex) or (firstNextPullIndex and i > firstNextPullIndex) then
                        DM_Trackers_HandleCorruptedRoute();
                    end
                elseif not isGroupActive then
                    if pull.wasSkipped then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_SKIPPED);
                    elseif DM_Trackers_IsLinkedPullStart(pull) then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_LINKEDPULLSTART);
                    elseif DM_Trackers_IsLinkedPull(pull) then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_LINKEDPULL);
                    elseif DM_Trackers_IsUnLinked(pull) and DM_Trackers_IsPreviousGroupActive(i, pull.areaKey, pull.mobGroup) then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_NEXTGROUP);

                        if not firstNextPullIndex then
                            firstNextPullIndex = i;
                        end
                    elseif (pull.areaKey == initialAreaKey and pull.mobGroup == initialMobGroup) or DM_Trackers_IsGroupNextPull(i, pull.areaKey, pull.mobGroup) then
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_NEXTGROUP);

                        if not gatheredNotes[pull.mobGroup] then
                            gatheredNotes[pull.mobGroup] = {size=0, items={}};
    
                            gatheredNotes[pull.mobGroup].size = gatheredNotes[pull.mobGroup].size + 1;
                            gatheredNotes[pull.mobGroup].items[gatheredNotes[pull.mobGroup].size] = line.metadata.dungeonNote;
                            gatheredNotes[pull.mobGroup].size = gatheredNotes[pull.mobGroup].size + 1;
                            gatheredNotes[pull.mobGroup].items[gatheredNotes[pull.mobGroup].size] = line.metadata.routeNote;
                        end

                        if not firstNextPullIndex then
                            firstNextPullIndex = i;
                        end
                    else
                        DM_Colors_SetStatusBarColor(line.mobDetails, COLOR_KEY_PULLTRACKER_INACTIVE);

                        if not firstInactiveIndex then
                            firstInactiveIndex = i;
                        end
                    end
                end

                if pull.status.warningStateChanged then
                    DM_Trackers_HandleGlowStateChange(pull, line);

                    if pull.status.warningActive or pull.status.warningState == 1 then
                        extendedText = DM_Trackers_FormatWarningText(
                            pull.status.warningAbility.warningEvents[pull.status.warningStartEvent].warnText,
                                                                     pull.status.warningAbilityName, 
                                                                     pull.status.warningSourceName, 
                                                                     pull.status.warningSourceGUID, 
                                                                     pull.status.warningDestName, 
                                                                     pull.status.warningDestGUID);
                    end
    
                    line.primaryText:SetText(pull.mobGroupNum .. ": " .. m.name .. "[" .. tostring(m.npcid) .. "]" .. " (" .. tostring(m.forceCount) .. ") [G] " .. extendedText);
                end
            end

            if skipLine then
                skipLine = false;
            else
                line:Show();

                nextLineIndex = nextLineIndex + 1;
            end
        end
    end
 
    DM_Trackers_ClearAndHideLines(nextLineIndex);

    -- big todo: bring notes back, need to account for route context / area / etc.
    -- local text = "";
    -- local notesSet = false;

    -- for mg, mgNotes in pairs(gatheredNotes) do
    --     if not groupNotesShown[mg] then
    --         text = text .. "NOTES FOR GROUP " .. mg .. "\n\n";

    --         for i = 1, mgNotes.size do
    --             if mgNotes.items[i] and #mgNotes.items[i] > 0 then
    --                 text = text .. mgNotes.items[i] .. "\n";
    --                 notesSet = true;
    --             end
    --         end

    --         groupNotesShown[mg] = true;
    --     end
    -- end

    -- if notesSet then
    --     DM_Info_SetText(text);
    -- end
end

function DM_Trackers_FormatWarningText(warnText, abilityName, sourceName, sourceGuid, destName, destGuid)
    local t = warnText;

    t = string.gsub(t, "$an", (abilityName or "..."));
    t = string.gsub(t, "$sn", (sourceName or "..."));
    t = string.gsub(t, "$sg", (sourceGuid or "..."));
    t = string.gsub(t, "$dn", (destName or "..."));
    t = string.gsub(t, "$dg", (destGuid or "..."));

    return t;
end

local readyCheckReceivedResponses = nil;

function DM_Trackers_InitReadyCheckStatus()
    if UnitIsGroupLeader("player") then
        readyCheckReceivedResponses = {size=1, players={["player"]=true}};
    else
        readyCheckReceivedResponses = {size=1, players={["initiator"]=true}};
    end
end

function DM_Trackers_HandleReadyCheckConfirm(unitTarget, isReady)
    if not readyCheckReceivedResponses.players[unitTarget] then
        readyCheckReceivedResponses.size = readyCheckReceivedResponses.size + 1;
        readyCheckReceivedResponses.players[unitTarget] = isReady;
    end
end

function DM_Trackers_GatherGroupStatus()
    local t = {};

    if not readyCheckReceivedResponses then
        table.insert(t, "No recent ready check");
        return t;
    end

    local highestState = 0;
    local notReadyCount = 0;
    local readyCount = 0;

    if readyCheckReceivedResponses.size < DM_Group_GroupSize() then
        highestState = 2;
    else
        for unitTarget, readyStatus in pairs(readyCheckReceivedResponses.players) do
            if not readyStatus then
                highestState = 2;
                notReadyCount = notReadyCount + 1;
            else
                readyCount = readyCount + 1;
            end
        end
    end

    local partySize = GetNumGroupMembers();

    if partySize == 0 then
        partySize = 1;
    end

    if highestState == 0 then
        table.insert(t, "All players are ready");
    else
        table.insert(t, "Players not ready: " .. tostring(notReadyCount));
    end

    return t;
end

function DM_Trackers_HandleReadyCheckFinished()
    local highestState = 0;
    local notReadyCount = 0;
    local readyCount = 0;

    if readyCheckReceivedResponses.size < DM_Group_GroupSize() then
        highestState = 2;
    else
        for unitTarget, readyStatus in pairs(readyCheckReceivedResponses.players) do
            if not readyStatus then
                highestState = 2;
                notReadyCount = notReadyCount + 1;
            else
                readyCount = readyCount + 1;
            end
        end
    end

    if highestState == 0 then
        DM_Trackers_SetLightGreen();
        local text = "Ready check complete: all players are ready!";
        DM_Info_SetText(text);
    else
        DM_Trackers_SetLightRed();
        local text = "Ready check complete: " .. tostring(readyCount) .. "/" .. tostring(DM_Group_GroupSize()) .. " players are ready";
        DM_Info_SetText(text);
    end

    readyCheckReceivedResponses = nil;
end

function DM_Trackers_CreateToolbar(frame)
    lightIcon = DM_Tex_CreateMainIcon(frame, "STOPLIGHT", 20, 20);

    DM_Colors_SetIconColor(lightIcon, COLOR_KEY_GENERAL_HIGH);
    lightIcon:ClearAllPoints();
    lightIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -24);
    lightIcon:Show();
 
    lightIcon:EnableMouse(true);
    lightIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("Group Status");

       local groupStatus = DM_Trackers_GatherGroupStatus();

       for idx,msg in pairs(groupStatus) do
          GameTooltip:AddLine(msg);
       end

       GameTooltip:AddLine(" ");
       GameTooltip:AddLine("(click to start a ready check)");
       GameTooltip:Show();
    end);
    lightIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);
    lightIcon:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            if UnitIsGroupLeader("player") then
                DM_Util_PrintSystemMessage("Starting ready check...");
                DoReadyCheck();
            end
        elseif button == "RightButton" then
            DM_Trackers_ResetLight();
        end
    end);

    foodIcon = DM_Tex_CreateMainIcon(frame, "FOOD", 24, 24, "OVERLAY");
 
    foodIcon:ClearAllPoints();
    DM_Colors_SetIconColor(foodIcon, COLOR_KEY_GENERAL_HIGH);
    foodIcon:SetPoint("TOPLEFT", lightIcon, "TOPRIGHT", 8, 0);
    foodIcon:Show();
 
    foodIcon.warningState = 0;
 
    foodIcon:EnableMouse(true);
    foodIcon:SetScript("OnMouseUp", function(self)
       if self.warningState == 0 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_MEDIUM);
          self.warningState = 1;
       elseif self.warningState == 1 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_LOW);
          self.warningState = 2;
       elseif self.warningState == 2 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_HIGH);
          self.warningState = 0;
       end
       DM_Status_AnnounceFood(self.warningState);
    end);
    foodIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("FOOD BUFF, click to change");
       GameTooltip:AddLine("GREEN: Have food buff");
       GameTooltip:AddLine("YELLOW: Want food buff (slow down), will be set automatically if you eat");
       GameTooltip:AddLine("RED: Need food buff (stop pulling)");
       GameTooltip:Show();
    end);
    foodIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);
 
    manaIcon = DM_Tex_CreateMainIcon(frame, "MANA", 24, 24, "OVERLAY");
 
    manaIcon:ClearAllPoints()
    DM_Colors_SetIconColor(manaIcon, COLOR_KEY_GENERAL_HIGH);
    manaIcon:SetPoint("TOPLEFT", foodIcon, "TOPRIGHT", 8, 0);
    manaIcon:Show();
 
    manaIcon.warningState = 0;
 
    manaIcon:EnableMouse(true);
    manaIcon:SetScript("OnMouseUp", function(self)
       if self.warningState == 0 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_MEDIUM);
          self.warningState = 1;
       elseif self.warningState == 1 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_LOW);
          self.warningState = 2;
       elseif self.warningState == 2 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_HIGH);
          self.warningState = 0;
       end

       DM_Status_AnnounceMana(self.warningState);
    end);
    manaIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("MANA, click to change");
       GameTooltip:AddLine("GREEN: Good on mana");
       GameTooltip:AddLine("YELLOW: Want mana (slow down), will be set automatically if you drink");
       GameTooltip:AddLine("RED: Need mana (stop pulling)");
       GameTooltip:Show();
    end);
    manaIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);
 
    afkIcon = DM_Tex_CreateMainIcon(frame, "AFK", 24, 24, "OVERLAY");

    afkIcon:ClearAllPoints();
    DM_Colors_SetIconColor(afkIcon, COLOR_KEY_GENERAL_HIGH);
    afkIcon:SetPoint("TOPLEFT", manaIcon, "TOPRIGHT", 8, 0);
    afkIcon:Show();
 
    afkIcon.warningState = 0;
 
    afkIcon:EnableMouse(true);
    afkIcon:SetScript("OnMouseUp", function(self)
       if self.warningState == 0 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_MEDIUM);
          self.warningState = 1;
       elseif self.warningState == 1 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_LOW);
          self.warningState = 2;
       elseif self.warningState == 2 then
          DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_HIGH);
          self.warningState = 0;
       end

       DM_Status_AnnounceAfk(self.warningState);
    end);
    afkIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("AFK, click to change");
       GameTooltip:AddLine("GREEN: Not AFK");
       GameTooltip:AddLine("YELLOW: Need to AFK (slow down)");
       GameTooltip:AddLine("RED: Are AFK (stop pulling)");
       GameTooltip:Show();
    end);
    afkIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);

    local mapIcon = DM_Tex_CreateRouteBuilderIcon(frame, "MAP", 20, 20);
    DM_Colors_SetIconColor(mapIcon, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
    mapIcon:SetPoint("TOPLEFT", afkIcon, "TOPRIGHT", 16, 0);
    mapIcon:EnableMouse(true);
    mapIcon:SetScript("OnEnter", function(self)
       DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED);

       GameTooltip:SetOwner(self, "ANCHOR_LEFT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("Click to open the route builder");
       GameTooltip:Show();
    end);
    mapIcon:SetScript("OnLeave", function(self)
       DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
       GameTooltip:Hide();
    end);
    mapIcon:SetScript("OnMouseUp", function(self)
       DM_RouteBuilder_Toggle();
    end);

   routeCorruptionIcon = DM_Tex_CreateRouteBuilderIcon(frame, "CAUTION", 20, 20);
   DM_Colors_SetIconColor(routeCorruptionIcon, COLOR_KEY_GENERAL_MEDIUM);
      routeCorruptionIcon:SetPoint("TOPLEFT", mapIcon, "TOPRIGHT", 8, 0);
      routeCorruptionIcon:EnableMouse(true);
      routeCorruptionIcon:SetScript("OnEnter", function(self)
      DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED);
  
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      GameTooltip:ClearLines();

      if pullTrackerDisabled then
         GameTooltip:AddLine("Pull Tracker Disabled");
         GameTooltip:AddLine("Left click to re-enable");
         GameTooltip:Show();
     else
         GameTooltip:AddLine("Pulls are happening out of order");
         GameTooltip:AddLine("Left click to disable pull tracker");
         GameTooltip:AddLine("Right click to reset this detection");
         GameTooltip:Show();
      end
   end);
   routeCorruptionIcon:SetScript("OnLeave", function(self)
      DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_MEDIUM);
      GameTooltip:Hide();
   end);
   routeCorruptionIcon:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            if pullTrackerDisabled then
                DM_Util_PrintSystemMessage("Enabling pull tracker");
                DM_Trackers_EnablePullTracker();
            else
                DM_Util_PrintSystemMessage("Disabling pull tracker");
                DM_Trackers_DisablePullTracker();
            end
        elseif button == "RightButton" then
            DM_Util_PrintSystemMessage("Out-of-order route detection reset");
            DM_Trackers_ResetRouteCorruption();
        end
   end);
   routeCorruptionIcon:Hide();

   wingsIcon = DM_Tex_CreateRouteBuilderIcon(frame, "WINGS", 20, 20);
   DM_Colors_SetIconColor(wingsIcon, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
   wingsIcon:SetPoint("TOPLEFT", routeCorruptionIcon, "TOPRIGHT", 8, 0);
   wingsIcon:EnableMouse(true);
   wingsIcon:SetScript("OnEnter", function(self)
      DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED);
 
      GameTooltip:SetOwner(self, "ANCHOR_LEFT");
      GameTooltip:ClearLines();
      GameTooltip:AddLine("Click to signal safe to release");
      GameTooltip:Show();
   end);
   wingsIcon:SetScript("OnLeave", function(self)
      DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
      GameTooltip:Hide();
   end);

   wingsIcon:SetScript("OnMouseUp", function(self)
       DM_Comm_SendSafeToReleaseStatus(1);
   end);

   wingsIcon:Hide();
end

function DM_Trackers_HandleDeathStatus(sender, state)
    if state == 1 then
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_SAFE_TO_RELEASE);
    end
end

function DM_Status_SetDrinking()
    local status = manaIcon.warningState;

    if status ~= 0 then
        return;
    end

    manaIcon.warningState = 1;
    DM_Colors_SetIconColor(manaIcon, COLOR_KEY_GENERAL_MEDIUM);
    manaIcon.setAutomatically = true;

    DM_Status_AnnounceMana(manaIcon.warningState, false);
end

function DM_Status_ClearDrinking()
    manaIcon.warningState = 0;
    DM_Colors_SetIconColor(manaIcon, COLOR_KEY_GENERAL_HIGH);
    manaIcon.setAutomatically = false;

    DM_Status_AnnounceMana(manaIcon.warningState, false);
end

function DM_Status_SetEating()
    local status = foodIcon.warningState;

    if status ~= 0 then
        return;
    end

    foodIcon.warningState = 1;
    DM_Colors_SetIconColor(foodIcon, COLOR_KEY_GENERAL_MEDIUM);
    foodIcon.setAutomatically = true;

    DM_Status_AnnounceFood(foodIcon.warningState, false);
end

function DM_Status_ClearEating()
    foodIcon.warningState = 0;
    DM_Colors_SetIconColor(foodIcon, COLOR_KEY_GENERAL_HIGH);
    foodIcon.setAutomatically = false;

    DM_Status_AnnounceFood(foodIcon.warningState, false);
end

function DM_Trackers_Show()
    if trackerWindow == nil then
        DM_Trackers_CreateWindow();
        DM_Trackers_CreateImmediateActionFrame();
    end

    trackerWindow:Show();
end

function DM_Trackers_GetTrackerLine(index)
    if index > trackerLines.size+1 then
        print("Dungeon Mentor: ERROR - Cannot access out-of-bounds tracker line. If you see this message please report this bug with details of what you were doing");
        return;
    end

    if index > trackerLines.size then
        DM_Trackers_CreateTrackerLine(trackerScrollChild, 0);
    end

    return trackerLines.items[index];
end

-- objective: one set of lines for all views, this lets us optimize frame usage
--            as we'll only ever create as many lines as we need for the maximum
--            amount of information. this assumption will change in future
--            if we split any of the views (off-route/spawned/min pulls to force count)
--            to other windows. WoW seems well optimized for high frame usage but
--            not knowing internal details we won't add to its burden prematurely
function DM_Trackers_CreateTrackerLine(rootFrame, vertPadding)
    trackerLines.size = trackerLines.size + 1;

    local pullLineRoot = CreateFrame("Frame",  "DM_PullTrackerLine_" .. tostring(trackerLines.size), rootFrame);

    pullLineRoot:SetHeight(20);

    local priorityIconColumnWidth = 6; -- 18;

    if trackerLines.size == 1 then
        pullLineRoot:SetPoint("TOPLEFT", rootFrame, "TOPLEFT", priorityIconColumnWidth, vertPadding);
        pullLineRoot:SetPoint("RIGHT", trackerScrollFrame, "RIGHT", 0, 0);
    else
        pullLineRoot:SetPoint("TOPLEFT", trackerLines.items[trackerLines.size-1], "BOTTOMLEFT", 0, 0);
        pullLineRoot:SetPoint("RIGHT", trackerScrollFrame, "RIGHT", 0, 0);
    end

    pullLineRoot:EnableMouse(true);
    pullLineRoot:SetScript("OnMouseUp", function(self)
        if not self.isGlowing then
            self.isGlowing = true;
            GlowLib.AutoCastGlow_Start(self, {1, 1, 0, 1}, 16);
        else
            self.isGlowing = nil;
            GlowLib.AutoCastGlow_Stop(self);
        end
    end);

    pullLineRoot.mobDetails = CreateFrame("StatusBar", nil, pullLineRoot);
    pullLineRoot.mobDetails:SetAllPoints(pullLineRoot);

    pullLineRoot.mobDetails:SetStatusBarTexture(DM_Tex_StatusBarTexture(), "ARTWORK");
    pullLineRoot.mobDetails:GetStatusBarTexture():SetHorizTile(false);
    pullLineRoot.mobDetails:GetStatusBarTexture():SetVertTile(false);

    DM_Colors_SetStatusBarColor(pullLineRoot.mobDetails, COLOR_KEY_PULLTRACKER_INACTIVE);

    pullLineRoot.mobDetails:SetMinMaxValues(0, 100);
    pullLineRoot.mobDetails:SetValue(100);
    pullLineRoot.mobDetails:Show();

    pullLineRoot.primaryText = pullLineRoot.mobDetails:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    pullLineRoot.primaryText:SetPoint("LEFT", pullLineRoot.mobDetails, "LEFT", 2, 0);
    pullLineRoot.primaryText:SetJustifyH("LEFT");
    pullLineRoot.primaryText:SetTextColor(1, 1, 1, 1);
    pullLineRoot.primaryText:SetWordWrap(false);
    pullLineRoot.primaryText:SetText("...");

    local flagKilledIcon;
    local chatOutputIcon;
    local flagSkippedIcon;

    flagSkippedIcon = DM_Tex_CreateMainIcon(pullLineRoot.mobDetails, "BIG_X", 12, 12, "OVERLAY");

    flagSkippedIcon:ClearAllPoints()
    flagSkippedIcon:SetVertexColor(1, 1, 1, 1);
    flagSkippedIcon:SetPoint("TOPRIGHT", pullLineRoot.mobDetails, "TOPRIGHT", -10, -4);
    flagSkippedIcon:Show();

    flagSkippedIcon:EnableMouse(true);
    flagSkippedIcon:SetScript("OnMouseUp", function(self)
        if self.isHeader then
            DM_Trackers_FlagMobGroupAsSkipped(GetTime(), self.areaKey, self.mobGroup);
        else
            DM_Trackers_FlagMobAsSkipped(GetTime(), self.areaKey, self.mobGroup, self.mobIndex, self.pullData.guid);
        end
    end);
    flagSkippedIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("Click to mark skipped");
       GameTooltip:Show();
    end);
    flagSkippedIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);

    flagKilledIcon = DM_Tex_CreateMainIcon(pullLineRoot.mobDetails, "SKULL", 12, 12, "OVERLAY");

    flagKilledIcon:ClearAllPoints()
    flagKilledIcon:SetVertexColor(1, 1, 1, 1);
    flagKilledIcon:SetPoint("TOPRIGHT", flagSkippedIcon, "TOPLEFT", -10, 0);
    flagKilledIcon:Show();
    flagKilledIcon.parentLine = pullLineRoot;

    flagKilledIcon:EnableMouse(true);
    flagKilledIcon:SetScript("OnMouseUp", function(self)
        if self.isHeader then
            DM_Trackers_FlagMobGroupAsDead(GetTime(), self.areaKey, self.mobGroup);
        else
            DM_Trackers_FlagMobAsDead(GetTime(), self.areaKey, self.mobGroup, self.mobIndex, self.pullData.guid);
        end
    end);
    flagKilledIcon:SetScript("OnEnter", function(self)
       GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
       GameTooltip:ClearLines();
       GameTooltip:AddLine("Click to mark killed");
       GameTooltip:Show();
    end);
    flagKilledIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);

    chatOutputIcon = DM_Tex_CreateMainIcon(pullLineRoot.mobDetails, "CHAT", 12, 12, "OVERLAY");

    chatOutputIcon.parentLine = pullLineRoot;
    chatOutputIcon:ClearAllPoints()
    chatOutputIcon:SetVertexColor(0.8, 0.8, 0.8, 1);
    chatOutputIcon:SetPoint("TOPRIGHT", flagKilledIcon, "TOPLEFT", -10, 0);
    chatOutputIcon:Hide();

    chatOutputIcon:EnableMouse(true);
    chatOutputIcon:SetScript("OnMouseUp", function(self)
    end);
    chatOutputIcon:SetScript("OnEnter", function(self)
        -- todo: bring this back with rest of notes functionality
        -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        -- GameTooltip:ClearLines();
       
        -- local m = chatOutputIcon.parentLine.metadata;
        -- -- this is the data from the addon, it'll add an unknown number
        -- -- of lines. if this grows too big we'll want to separate this
        -- -- into something like "abilities/advicve" and "notes" icons/buttons
        -- if m and m.addonNotes and m.addonNotes.size > 0 then
        --     for i = 1, m.addonNotes.size do
        --         GameTooltip:AddLine(m.addonNotes.items[i]);
        --     end
        -- end
        -- -- dungeon note is the dungeon-level note added by the player running this addon
        -- -- this adds 1 line
        -- if m and m.dungeonNote then
        --     GameTooltip:AddLine(m.dungeonNote);
        -- end
        -- -- route note is the note that travels with the route
        -- -- this adds 1 line
        -- if m and m.routeNote then
        --     GameTooltip:AddLine(m.routeNote);
        --     --GameTooltip:AddLine("");
        -- end
        -- -- group notes are the dungeon notes for the OTHER players in the group,
        -- -- this will add up to 4 lines
        -- if m and m.groupNotes and m.groupNotes.size > 0 then
        --     for i = 1, m.groupNotes.size do
        --         GameTooltip:AddLine(m.groupNotes.items[i]);
        --     end
        -- end

        -- GameTooltip:AddLine("Click to send details to chat.");
        -- GameTooltip:Show();
    end);
    chatOutputIcon:SetScript("OnLeave", function(self)
       GameTooltip:Hide();
    end);

    trackerLines.items[trackerLines.size] = pullLineRoot;

    pullLineRoot.flagKilledIcon = flagKilledIcon;
    pullLineRoot.chatOutputIcon = chatOutputIcon;
    pullLineRoot.flagSkippedIcon = flagSkippedIcon;
end

function DM_Trackers_SetTimerProgress3(pct)
    timerStatusBar:SetStatusBarColor(0, 0.8, 0, 1);
    timerStatusBarRoot:SetBackdropColor(0, 0.4, 0, 1);
    timerStatusBar:SetValue(floor(pct or 100));
end

function DM_Trackers_SetTimerProgress2(pct)
    timerStatusBar:SetStatusBarColor(0.8, 0.8, 0, 1);
    timerStatusBarRoot:SetBackdropColor(0.4, 0.4, 0, 1);
    timerStatusBar:SetValue(floor(pct or 100));
end

function DM_Trackers_SetTimerProgress1(pct)
    timerStatusBar:SetStatusBarColor(0.8, 0, 0, 1);
    timerStatusBarRoot:SetBackdropColor(0.4, 0, 0, 1);
    timerStatusBar:SetValue(floor(pct or 100));
end

function DM_Trackers_SetTimerProgressOT()
    timerStatusBar:SetStatusBarColor(0, 0, 0, 1);
    timerStatusBarRoot:SetBackdropColor(0, 0, 0, 1);
    timerStatusBar:SetValue(0);
end

function DM_Trackers_SetDungeonTimerInvalid()
    timerStatusBar.text:SetText("Waiting for dungeon");
    timerStatusBar:SetValue(0);
    timerStatusBarRoot:SetBackdropColor(0, 0, 0, 1);
end

function DM_Trackers_SetDeathCount(count)
    if not timerStatusBar or not timerStatusBar.deathIcon or not timerStatusBar.deathText then
        return;
    end

    if not count or count == 0 then
        -- hide the death text / skull icon
        timerStatusBar.deathIcon:Hide();
        timerStatusBar.deathText:Hide();
        return;
    end

    -- show the death text/ skull icon
    timerStatusBar.deathText:SetText(tostring(count));
    timerStatusBar.deathIcon:Show();
    timerStatusBar.deathText:Show();
end

function DM_Trackers_CreateTimerTextFrame(rootFrame)
    timerStatusBarRoot = CreateFrame("Frame", "DM_TimerRoot", rootFrame, "BackdropTemplate");

    timerStatusBarRoot:SetBackdrop({
	    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	    edgeSize = 8,
	    insets = { left = 0, right = 0, top = 0, bottom = 0 },
    });

    timerStatusBarRoot:SetPoint("TOPLEFT", rootFrame, "TOPLEFT", 6, -50);
    timerStatusBarRoot:SetPoint("BOTTOMRIGHT", rootFrame, "TOPRIGHT", -6, -70);

    timerStatusBar = CreateFrame("StatusBar", nil, timerStatusBarRoot);
    timerStatusBar:SetPoint("TOPLEFT", timerStatusBarRoot, "TOPLEFT", 2, -2);
    timerStatusBar:SetPoint("BOTTOMRIGHT", timerStatusBarRoot, "BOTTOMRIGHT", -2, 2);
    timerStatusBar:SetStatusBarTexture(DM_Tex_StatusBarTexture(), "ARTWORK");
    timerStatusBar:GetStatusBarTexture():SetHorizTile(false);
    timerStatusBar:GetStatusBarTexture():SetVertTile(false);
    timerStatusBar:SetMinMaxValues(0, 100);
    timerStatusBar:SetValue(100);

    timerStatusBar.text = timerStatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    timerStatusBar.text:SetPoint("LEFT", timerStatusBar, "LEFT", 6, 0);
    timerStatusBar.text:SetJustifyH("LEFT");
    timerStatusBar.text:SetTextColor(1, 1, 1, 1);
    timerStatusBar.text:SetWordWrap(false);
    timerStatusBar.text:SetText("");

    timerStatusBar.deathIcon = DM_Tex_CreateMainIcon(timerStatusBar, "SKULL", 12, 12, "OVERLAY");
    timerStatusBar.deathIcon:SetPoint("TOPRIGHT", timerStatusBar, "TOPRIGHT", -4, -2);
    timerStatusBar.deathIcon:SetVertexColor(1, 1, 1, 1);

    timerStatusBar.deathText = timerStatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    timerStatusBar.deathText:SetPoint("RIGHT", timerStatusBar.deathIcon, "LEFT", -4, 0);
    timerStatusBar.deathText:SetJustifyH("LEFT");
    timerStatusBar.deathText:SetTextColor(1, 1, 1, 1);
    timerStatusBar.deathText:SetWordWrap(false);
    timerStatusBar.deathText:SetText("");

    timerStatusBar.deathIcon:Hide();
    timerStatusBar.deathText:Hide();

    DM_Trackers_SetDungeonTimerInvalid();

    timerStatusBar:Show();
    timerStatusBarRoot:Show();
end

function DM_Trackers_CreateHighPriorityTextFrame(rootFrame)
    highPriorityFrame = CreateFrame("StatusBar", nil, rootFrame);

    highPriorityFrame:SetPoint("TOPLEFT", timerStatusBarRoot, "BOTTOMLEFT", 0, -2);
    highPriorityFrame:SetPoint("BOTTOMRIGHT", timerStatusBarRoot, "BOTTOMRIGHT", 0, -24); -- -72

    highPriorityFrame.text = highPriorityFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    highPriorityFrame.text:SetPoint("LEFT", highPriorityFrame, "LEFT", 6, 0);
    highPriorityFrame.text:SetJustifyH("LEFT");
    highPriorityFrame.text:SetTextColor(1, 1, 1, 1);
    highPriorityFrame.text:SetWordWrap(false);
    highPriorityFrame.text:SetText("HIGH PRIORITY TEXT HERE");

    highPriorityFrame:SetHeight(20);

    highPriorityFrame:SetStatusBarTexture(DM_Tex_StatusBarTexture(), "ARTWORK");
    highPriorityFrame:GetStatusBarTexture():SetHorizTile(false);
    highPriorityFrame:GetStatusBarTexture():SetVertTile(false);

    DM_Colors_HighPriority_SetNeutral(highPriorityFrame);

    highPriorityFrame:SetMinMaxValues(0, 100);
    highPriorityFrame:SetValue(100);
    highPriorityFrame:Hide();
end

function DM_Trackers_CreateTrackerPane(rootFrame)
    trackerScrollFrame = CreateFrame("ScrollFrame", "DM_Tracker_ScrollPane", rootFrame, "UIPanelScrollFrameTemplate")
    trackerScrollFrame:SetPoint("TOPLEFT", highPriorityFrame, "BOTTOMLEFT", 0, 16);
    trackerScrollFrame:SetPoint("BOTTOMRIGHT", rootFrame, "BOTTOMRIGHT", -30, 6);

    local scrollBarLevel = _G[trackerScrollFrame:GetName() .. "ScrollBar"]:GetFrameLevel();
    _G[trackerScrollFrame:GetName() .. "ScrollBarScrollUpButton"]:SetFrameLevel(scrollBarLevel);
    _G[trackerScrollFrame:GetName() .. "ScrollBarScrollDownButton"]:SetFrameLevel(scrollBarLevel);

    trackerScrollChild = CreateFrame("Frame");
    trackerScrollFrame:SetScrollChild(trackerScrollChild);
    trackerScrollChild:SetWidth(300);
    trackerScrollChild:SetHeight(1);
end

function DM_Trackers_MoveResize_OnMouseDown(self, button)
    if (button == "LeftButton") then
       self:StartMoving();
    elseif button == "RightButton" then
       self:StartSizing();
       self.isSizing = true;
       
       local w, h = trackerWindow:GetSize();

       trackerScrollChild:SetSize(w, h);
    end
end

function DM_Trackers_MoveResize_OnMouseUp(self, button)
    self:StopMovingOrSizing();
end

function DM_Trackers_InitWindows()
    if trackerWindow == nil then
        DM_Trackers_CreateWindow();
        DM_Trackers_CreateImmediateActionFrame();
    end
end

function DM_Trackers_ShowWindow()
    if trackerWindow == nil then
        DM_Trackers_CreateWindow();
        DM_Trackers_CreateImmediateActionFrame();
    end

    trackerWindow:Show();
end

function DM_Trackers_GlowTest()
   if not trackerWindow then
       return;
   end

   GlowLib.AutoCastGlow_Start(trackerWindow);
end

local immediateActionFrame = nil;

local defaultUiTooltipBackdrop = {
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
};

function DM_Move_OnMouseDown(self, button)
    if (button == "LeftButton") then
       self:StartMoving();
    end
end

function DM_Move_OnMouseUp(self, button)
    self:StopMovingOrSizing();
end

function DM_Trackers_CreateImmediateActionFrame()
    immediateActionFrame = CreateFrame("Frame", "DM_ImmediateActionFrame", UIParent, "BackdropTemplate");
    immediateActionFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 120);

    immediateActionFrame:SetMovable(true);

    immediateActionFrame:SetHeight(28);

    immediateActionFrame.text = immediateActionFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
    immediateActionFrame.text:ClearAllPoints();
    immediateActionFrame.text:SetPoint("CENTER", immediateActionFrame, "CENTER", 0, 0);

    immediateActionFrame.text:SetText("one two three zebra apple key");
    immediateActionFrame.text:SetShown(true);
    immediateActionFrame:SetWidth(immediateActionFrame.text:GetStringWidth() + 50);

    immediateActionFrame:EnableMouse(true);
    immediateActionFrame:SetScript("OnEnter", function(self)
        self.backdropInfo = defaultUiTooltipBackdrop;
        self:ApplyBackdrop();
        self:SetBackdropColor(0.4, 0.4, 0, 1);

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Dungeon Mentor Immediate Action Frame");
        GameTooltip:AddLine("Hold down left click and drag to re-locate");
        GameTooltip:Show();
    end);
    immediateActionFrame:SetScript("OnLeave", function(self)
        self:ClearBackdrop();
        GameTooltip:Hide();
    end);
    immediateActionFrame:SetScript("OnMouseDown", DM_Move_OnMouseDown);
    immediateActionFrame:SetScript("OnMouseUp", DM_Move_OnMouseUp);

    immediateActionFrame:Show();
    immediateActionFrame.text:Show();
end

function DM_Trackers_CreateWindow()
    if trackerWindow ~= nil then
        return;
    end

    trackerWindow = CreateFrame("Frame", "DM_TrackerRoot", UIParent, "BackdropTemplate");

    local iconWidth = 12;
    local iconHeight = 12;

    trackerWindow:SetBackdrop(DM_Tex_CreateBackdrop());
    DM_Colors_SetFrameBackdropColors(trackerWindow);

    trackerWindow:SetSize(320, 200);
    trackerWindow:SetPoint("CENTER", UIParent, "CENTER");
    trackerWindow:SetMovable(true);
    trackerWindow:SetResizable(true);
    trackerWindow:EnableMouse(true);
    trackerWindow:SetScript("OnMouseDown", DM_Trackers_MoveResize_OnMouseDown);
    trackerWindow:SetScript("OnMouseUp", DM_Trackers_MoveResize_OnMouseUp);

    trackerWindow.title = trackerWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    trackerWindow.title:ClearAllPoints();
    trackerWindow.title:SetPoint("TOPLEFT", trackerWindow, "TOPLEFT", 10, -8);
    trackerWindow.title:SetText(trackerWindowPrefix .. trackerViewTitles[1]);
    trackerWindow:SetShown(false);

    trackerWindow.currentWindow = 1;

    trackerWindow:SetScript("OnMouseWheel", function(self,delta)
        local frameScale = trackerWindow:GetScale();
        if delta == -1 then
            frameScale = max(frameScale - 0.1, 0.5);
        else
            frameScale = min(frameScale + 0.1, 1.5);
        end
        trackerWindow:SetScale(frameScale);
    end);

    local closeIcon = DM_Tex_CreateMainIcon(trackerWindow, "CIRCLE_X", iconWidth, iconHeight, "OVERLAY");

    closeIcon.parentWindow = trackerWindow;
    closeIcon:ClearAllPoints();
    closeIcon:SetPoint("TOPRIGHT", trackerWindow, "TOPRIGHT", -8, -6);
    closeIcon:EnableMouse(true);
    DM_Colors_SetIconColor(closeIcon, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
    closeIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED);
    end);
    closeIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_PULLTRACKER_ICON_NORMAL);
    end);
    closeIcon:SetScript("OnMouseUp", function(self)
        closeIcon.parentWindow:Hide();
    end);

    forceText = trackerWindow:CreateFontString("ARTWORK", nil, "GameFontNormalLarge");
    forceText:SetPoint("TOPRIGHT", closeIcon, "BOTTOMRIGHT", 0, -10);
    forceText:SetText(dungeonForcesInactiveText);
    forceText:Show();

    DM_Trackers_CreateTimerTextFrame(trackerWindow);
    DM_Trackers_CreateHighPriorityTextFrame(trackerWindow);

    DM_Trackers_CreateToolbar(trackerWindow);
    DM_Trackers_CreateTrackerPane(trackerWindow);
end

function DM_Trackers_StartLightAnimation(r, g, b)
   stoplightAnimationTime = nil;
   stoplightAnimationActive = true;
   lightRedComponent = r or 1;
   lightGreenComponent = g or 0;
   lightBlueComponent = b or 0;
end

function DM_Trackers_SetLightRed()
    DM_Trackers_StartLightAnimation(1,0,0);
end

function DM_Trackers_SetLightYellow()
    DM_Trackers_StartLightAnimation(1,1,0);
end

function DM_Trackers_SetLightGreen()
    DM_Trackers_StartLightAnimation(0,1,0);
end

-- this will NOT force light to green, only get it out of a bad state
-- on the chance it's in a bad state
function DM_Trackers_ResetLight()
    DM_Trackers_StartLightAnimation(0,1,0);
    currentLightState = 0;
end

function DM_Trackers_PollLightState()
    local highestState = 0;

    for sender, state in pairs(lightStates.afk) do
        if state > highestState then
            highestState = state;
        end
    end

    if highestState == 2 then
        return highestState;
    end

    for sender, state in pairs(lightStates.food) do
        if state > highestState then
            highestState = state;
        end
    end

    if highestState == 2 then
        return highestState;
    end

    for sender, state in pairs(lightStates.mana) do
        if state > highestState then
            highestState = state;
        end
    end

    return highestState;
end

function DM_Trackers_PollAndAnimateLight()
    local state = DM_Trackers_PollLightState();

    if state ~= currentLightState then
        currentLightState = state;

        if state == 1 then
            DM_Trackers_SetLightYellow();
        end

        if state == 2 then
            DM_Trackers_SetLightRed();
        end

        if state == 0 then
            DM_Trackers_SetLightGreen();
        end
    end
end

local wasEating = false;
local wasDrinking = false;

function DM_Trackers_ScanForBuffs()
    local isFood = false;
    local isDrink = false;

    for i = 1, 40 do
        local auraName = UnitBuff("player", i);

        if auraName == "Food" then
            isFood = true;
        elseif auraName == "Drink" then
            isDrink = true;
            wasDrinking = true;
        elseif auraName == "Food & Drink" then
            isFood = true;
            isDrink = true;
            -- wasDrinking = true;
        end
    end

    if isFood then
        wasEating = true;
        DM_Status_SetEating();
    end

    if not isFood and wasEating then
        wasEating = false;
        DM_Status_ClearEating();
    end

    if isDrink then
        wasDrinking = true;
        DM_Status_SetDrinking();
    end

    if not isDrink and wasDrinking then
        wasDrinking = false;
        DM_Status_ClearDrinking();
    end
end

function DM_Trackers_HandleAfkStatus(sender, state)
    lightStates.afk.sender = state;
end

function DM_Trackers_HandleFoodStatus(sender, state)
    lightStates.food.sender = state;
end

function DM_Trackers_HandleManaStatus(sender, state)
    lightStates.mana.sender = state;
end

function DM_Trackers_SetForceText(t)
    if forceText then
        forceText:SetText(t);
    else
        forceText:SetText("-");
    end
end

function DM_Trackers_UpdateDungeonTimer()
    if DM_Util_GetWorldStateTimerId() == nil then
       DM_Trackers_SetDungeonTimerInvalid();
       return;
    end

    local dungeonLevel, affixes, energized = C_ChallengeMode.GetActiveKeystoneInfo();
    local prefix = "Level " .. tostring(dungeonLevel) .. ": ";

    local numDeaths, timeLost = C_ChallengeMode.GetDeathCount(); -- timeLost is in seconds
    local elapsedTime = DM_Util_GetWorldStateTimer_Elapsed(); -- + timeLost; -- don't think we need to subtract this out
    local challengeModeMapId = C_ChallengeMode.GetActiveChallengeMapID();

    if challengeModeMapId then
        DM_Trackers_SetDeathCount(numDeaths);

        local _, _, timeLimit = C_ChallengeMode.GetMapUIInfo(challengeModeMapId);
 
        -- at this point we have timeLimit and elapsedTime and can format the time however we want
        -- beating timer 40% ahead is +3, 20% ahead is +2, on time is +1
        local remainingTime = timeLimit - elapsedTime; -- this is in seconds

        local t40 = timeLimit*0.6 - elapsedTime;
        local t20 = timeLimit*0.8 - elapsedTime;
        local t0 = timeLimit - elapsedTime;

        if elapsedTime <= (timeLimit*0.6) then
            timerStatusBar.text:SetText(prefix .. DM_Util_SecondsToClock(remainingTime) .. " (+3, " .. DM_Util_SecondsToClock(t40) .. ")");
            DM_Trackers_SetTimerProgress3(100 - (elapsedTime / (timeLimit*0.6)) * 100);
        elseif elapsedTime <= (timeLimit*0.8) then
            timerStatusBar.text:SetText(prefix .. DM_Util_SecondsToClock(remainingTime) .. " (+2, " .. DM_Util_SecondsToClock(t20) .. ")");
            DM_Trackers_SetTimerProgress2(100 - (elapsedTime / (timeLimit*0.8)) * 100);
        elseif remainingTime >= 0 then
            --DM_Trackers_SetTimerText(DM_Util_SecondsToClock(remainingTime) .. " (+1)");
            timerStatusBar.text:SetText(prefix .. DM_Util_SecondsToClock(remainingTime) .. " (+1, " .. DM_Util_SecondsToClock(t0) .. ")");
            DM_Trackers_SetTimerProgress1(100 - (elapsedTime / timeLimit) * 100);
        else
            -- energized should be false here
            timerStatusBar.text:SetText(prefix .. DM_Util_SecondsToClock(-remainingTime) .. " (overtime)");
            DM_Trackers_SetTimerProgressOT();
        end
    end
end

function DM_Trackers_CheckDungeonDifficulty()
    if not immediateActionFrame then
        return;
    end

    if DM_Util_IsDungeonNormal() or DM_Util_IsDungeonHeroic() then
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_DUNGEON_NOT_MYTHIC);
    else
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_DUNGEON_ON_MYTHIC);
    end
end

local DM_OPTIONS_HIDE_BLIZZARD_UI = "General.HideBlizzardUi";
local DM_OPTIONS_PER_CHARACTER_SETTINGS = "General.PerCharacterSettings";
local DM_OPTIONS_IMMEDIATE_ACTION_ENABLED = "General.ImmediateActionEnabled";

function DM_Options_DataRoot()
    if DM_GlobalOptions[DM_OPTIONS_PER_CHARACTER_SETTINGS] then
      return DM_Options;
    end

    return DM_GlobalOptions;
end

function DM_Options_GetOption(key)
    if globalOptionList[key] then
      return DM_GlobalOptions[key];
    end

    return DM_Options_DataRoot()[key];
end

function DM_Options_ShouldHideBlizzardUI()
    return DM_Options_GetOption(DM_OPTIONS_HIDE_BLIZZARD_UI);
end

function DM_Options_IsImmediateActionEnabled()
    return DM_Options_GetOption(DM_OPTIONS_IMMEDIATE_ACTION_ENABLED);
end

local fakeTooltipFrame = nil;

-- /dump DM_Trackers_ExtractNumberFromBuff("player", 371172)
function DM_Trackers_ExtractNumberFromBuff(unit, targetSpellId)
    if not fakeTooltipFrame then
        fakeTooltipFrame = CreateFrame("GameTooltip", "DM_FakeTooltip", nil, "GameTooltipTemplate");
        fakeTooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE");
    end

    for i = 1, 40 do
        --name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff(unit, i);
        _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i);

        if spellId == targetSpellId then
            -- print("found buff at index: " .. tostring(i));
            fakeTooltipFrame:ClearLines();
            fakeTooltipFrame:SetUnitBuff(unit, i);
            local text = _G[fakeTooltipFrame:GetName() .. "TextLeft2"]:GetText();
            --print("text: " .. tostring(text));
            --local num = sub(text, find(text,"%d+"));
            return tonumber(string.match(text, "%d+"));
            --print("number value: " .. tostring(num));
        end
    end

    return nil;
end

function DM_Trackers_SetImmediateAction(actionId, customText)
    if not immediateActionFrame then
        return;
    end

    if DM_Options_IsImmediateActionEnabled() then
        immediateActionFrame.text:Show();
        immediateActionFrame:Show();
    else
        --immediateActionFrame.text:Hide();
        --immediateActionFrame:Hide();
        return;
    end

    immediateActionTextLastActionId = actionId;

    -- todo: revisit this, will need to ensure prioritizing messages works well
    --if currentImmediateAction and actionId > currentImmediateAction then
    --    return;
    --end

    if currentImmediateAction == actionId and currentImmediateAction ~= IMMEDIATE_ACTION_CUSTOM then
        return;
    end

    currentImmediateAction = actionId;

    if customText then
        --print("setting imm frame to: " .. tostring(customText));
        immediateActionFrame.text:SetText(customText);
    else
        --print("setting imm frame to: " .. tostring(immediateActionText[actionId]));
        immediateActionFrame.text:SetText(immediateActionText[actionId]);
    end

    immediateActionFrame:SetWidth(immediateActionFrame.text:GetStringWidth() + 50);
end

function DM_Trackers_ClearImmediateAction()
    if DM_Options_IsImmediateActionEnabled() and immediateActionFrame and immediateActionFrame.text then
        immediateActionFrame.text:SetText(immediateActionText[IMMEDIATE_ACTION_EMPTY]);
        currentImmediateAction = nil;
    end
end

function DM_Trackers_GroupScan()
    if wingsIcon and wingsIcon:IsShown() and not DM_Group_AnyPlayersDead() then
        wingsIcon:Hide();

        if    currentImmediateAction == IMMEDIATE_ACTION_DO_NOT_RELEASE 
           or currentImmediateAction == IMMEDIATE_ACTION_SAFE_TO_RELEASE 
           or currentImmediateAction == IMMEDIATE_ACTION_SIGNAL_RELEASE
        then
            DM_Trackers_ClearImmediateAction();
        end
    end

    if wingsIcon and not wingsIcon:IsShown() and DM_Group_AnyPlayersDead() then
        wingsIcon:Show();
        if UnitIsDeadOrGhost("player") then
            DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_DO_NOT_RELEASE);
        else
            DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_SAFE_TO_RELEASE);
        end
    end
end

function DM_Trackers_OnUpdate(self, elapsed)
    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;

    while(TimeSinceLastUpdate > UPDATE_INTERVAL) do
        if stoplightAnimationActive and not stoplightAnimationTime then
            stoplightAnimationTime = 0;
        end

        if stoplightAnimationActive and stoplightAnimationTime then
            stoplightAnimationTime = stoplightAnimationTime + elapsed;

            local currentColor = minColor + ( (maxColor-minColor) / (stoplightAnimationSpan / stoplightAnimationTime) );
            if currentColor >= maxColor then
                stoplightAnimationActive = false;
                stoplightAnimationTime = nil;
                currentColor = maxColor;
            end

            lightIcon:SetVertexColor(lightRedComponent * (currentColor/255),
                                     lightGreenComponent * (currentColor/255), 
                                     lightBlueComponent * (currentColor/255), 1);
        end

        TimeSinceLastUpdate = TimeSinceLastUpdate - UPDATE_INTERVAL;

        if DM_Trackers_IsChallengeModeActive() then
            DM_Trackers_UpdateDungeonTimer();
            DM_Trackers_ScanForBuffs();
            DM_Trackers_PollAndAnimateLight();
            DM_Trackers_ScanForGlowDeactivations();
            DM_Trackers_UpdateBloodlustTimers();
            -- DM_Trackers_ProcessInCombatImmediateMessages();
        else
            DM_Trackers_CheckDungeonDifficulty();
        end

        DM_Trackers_PollAndAnimateLight();
        DM_Trackers_GroupScan();
    end
end

local mobEventsOfInterest = {
    ["SPELL_CAST_START"] = 1,
    ["SPELL_CAST_SUCCESS"] = 1,
    ["SPELL_CAST_PERIODIC_DAMAGE"] = 1,
    ["SPELL_DAMAGE"] = 1,
    ["SWING_MISSED"] = 1,
    ["SWING_DAMAGE_LANDED"] = 1,
    ["SPELL_MISSED"] = 1,
    ["SPELL_PERIODIC_DAMAGE"] = 1,
    ["SPELL_AURA_APPLIED"] = 1
};

function DM_Trackers_FlagMobAsDead(ts, areaKey, mobGroup, mobIndex, guid, preventRefresh) 
    if not guid then
        return;
    end

    DM_Trackers_ProcessDeadMob(GetTime(), guid, nil, onRoute, preventRefresh);

    if not preventRefresh then
        DM_Trackers_RefreshPullTracker();
    end
end

function DM_Trackers_FlagMobGroupAsDead(ts, areaKey, mobGroup, preventRefresh)
    local pulls = activeRoute.pulls;

    local nextIndex = 0;

    for i = 1, pulls.size do
        local p = pulls.items[i];

        if p.areaKey == areaKey and p.mobGroup == mobGroup and not p.isHeader and not p.isAreaHeadera and not p.wasSkipped and not pull.status.isDead then
            DM_Trackers_FlagMobAsDead(ts, areaKey, mobGroup, nextIndex, p.guid, preventRefresh);
            nextIndex = nextIndex + 1;
        end
    end

    if not preventRefresh then
        DM_Trackers_RefreshPullTracker();
    end
end

function DM_Trackers_FlagMobAsSkipped(ts, areaKey, mobGroup, relativeMobIndex, guid)
    DM_Trackers_ProcessSkippedMob(ts, areaKey, mobGroup, relativeMobIndex, guid);
end

function DM_Trackers_FlagMobGroupAsSkipped(ts, areaKey, mobGroup)
    local pulls = activeRoute.pulls;

    local nextIndex = 0;

    for i = 1, pulls.size do
        local p = pulls.items[i];

        if p.areaKey == areaKey and p.mobGroup == mobGroup and not p.isHeader and not p.isAreaHeader and not p.wasSkipped then
            DM_Trackers_FlagMobAsSkipped(ts, areaKey, mobGroup, nextIndex, p.guid);

            nextIndex = nextIndex + 1;
        end
    end

    DM_Trackers_RefreshPullTracker();
end

function DM_Trackers_PullHasNpcId(pull, npcId)
    if pull.isMutex then
        return pull.mutexMob1.npcid == npcId or pull.mutexMob2.npcid == npcId;
    end

    if pull.mob then
        return pull.mob.npcid == npcId;
    end

    return false;
end

function DM_Trackers_EligibleForActivation(pull)
    local dungeonCtx = DM_Dungeons_GetDungeonContextByCurrentZone();

    if not pull.canActivateAfter then
        -- if no specific indicator when we're delaying activation, we'll default to true
        return true;
    end

    return DM_Trackers_IsObjectiveComplete(pull.canActivateAfter);
end

function DM_Trackers_HandleMobHit(timestamp, name, guid, playerInvolved, index)
    if not DM_Trackers_IsChallengeModeActive() then
        -- only handle mob hits when dungeon is active
        return;
    end

    -- todo: better to check flags here rather than the "Player"
    if not guid or string.len(guid) == 0 or StringStartsWith(guid, "Player") then
        return;
    end

    if not playerInvolved then
        return;
    end

    local needsUpdate = false;
    local mobFound = false;

    if onRoute.guids[guid] ~= nil then
        return;
    end

    local npcId = DM_Util_NpcIdFromGuid(guid);

    if not npcId then
        return;
    end

    for i = 1, onRoute.pulls.size do
        local pull = onRoute.pulls.items[i];

        if     not mobFound 
           and not pull.isHeader 
           and not pull.isAreaHeader 
           and not pull.wasSkipped
           and (not onRoute.deadPulls[pull.areaKey] or not onRoute.deadPulls[pull.areaKey][pull.mobGroup])
           and (pull.guid == nil or 
                  (pull.mob and pull.mob.allowGuidReassign) or
                  (pull.mutexMob1 and pull.mutexMob1.allowGuidReassign) or
                  (pull.mutexMob2 and pull.mutexMob2.allowGuidReassign)
               )
           and DM_Trackers_PullHasNpcId(pull, npcId) 
           and DM_Trackers_EligibleForActivation(pull) then
              needsUpdate = true;
              pull.guid = guid;
              mobFound = true;
              onRoute.guids[guid] = i; -- TODO: rename "guids" to "guidToAbsoluteIndex"
              pull.status.isActive = true;

              DM_Trackers_AnnounceMobHit(timestamp, GetTime(), guid, playerInvolved, pull.areaKey, pull.mobGroup, i-pull.headerIndex-1, i);
              DM_Trackers_RecordMobHit(timestamp, GetTime(), guid, playerInvolved, pull.areaKey, pull.mobGroup, i, false);
        end
    end

    if needsUpdate then
        DM_Trackers_RefreshPullTracker();
    else
        -- print("HandleMobHit pull not found for guid=" .. tostring(guid) .. ", npcid=" .. tostring(npcId));
    end
end

function DM_Trackers_HandleExternalMobDeath(timestamp, name, guid, playerInvolved, 
    areaKey, mobGroup, mobIndex, wasSkipped, flags)
    local pull = DM_Trackers_GetPullByGroupAndRelativeIndex(onRoute.pulls, areaKey, mobGroup, mobIndex);

    if pull then
        if guid then
            if pull.status.isDead then
                return;
            end

            pull.status.isDead = true;
            pull.status.isActive = false;
            pull.guid = guid;

            if pull.status.warningActive then
                DM_Trackers_DeactivateGlow(pull);
            end

            if not wasSkipped then
                currentDeadForces = currentDeadForces + pull.mob.forceCount;
                onRoute.deadForces = onRoute.deadForces + pull.mob.forceCount;
            else
                pull.wasSkipped = true;
            end

            onRoute.pulls.items[pull.headerIndex].deadCount = onRoute.pulls.items[pull.headerIndex].deadCount + 1;

            if onRoute.pulls.items[pull.headerIndex].deadCount == onRoute.pulls.items[pull.headerIndex].groupSize then
                if not onRoute.deadPulls[pull.areaKey] then
                    onRoute.deadPulls[pull.areaKey] = {};
                end

                onRoute.deadPulls[pull.areaKey][pull.mobGroup] = true;
            end

            onRoute.guids[guid] = mobIndex;
            --pull.status.isActive = true;

            DM_Trackers_RefreshPullTracker();
        else
            -- print("DM_Trackers_HandleExternalMobDeath: guid not specified");
        end
    else
        -- print("DM_Trackers_HandleExternalMobDeath: pull not found");
    end
end

function DM_Trackers_HandleExternalMobHit(timestamp, name, guid, playerInvolved, areaKey, mobGroup, mobIndexRelative, preventRefresh)
    if not DM_Trackers_IsChallengeModeActive() then
        -- only handle mob hits when dungeon is active
        return;
    end

    local pull = DM_Trackers_GetPullByGroupAndRelativeIndex(onRoute.pulls, areaKey, mobGroup, mobIndexRelative);

    if pull then
        if guid then
            if pull.status and pull.status.isActive then
                return;
            end

            pull.guid = guid;
            onRoute.guids[guid] = pull.absoluteIndex;

            pull.status.isActive = true;
            if not preventRefresh then
                DM_Trackers_RefreshPullTracker();
            end
        else
            -- print("DM_Trackers_HandleExternalMobHit: guid not specified");
        end
    else
        -- print("DM_Trackers_HandleExternalMobHit: pull not found");
    end
end

function DM_Trackers_IsPlayerInvolved(sourceFlags, destFlags)
    if sourceFlags and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_MASK) == COMBATLOG_OBJECT_TYPE_PLAYER then
        return true;
    end

    if destFlags and bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK) == COMBATLOG_OBJECT_TYPE_PLAYER then
        return true;
    end

    return false;
end

function DM_Trackers_HandleEventOfInterest(timestamp, subevent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool)
    if sourceName == nil or sourceGUID == nil then
        return;
    end

    local needsUpdate = false;

    if mobEventsOfInterest[subevent] == 1 then
        DM_Trackers_HandleMobHit(timestamp, sourceName, sourceGUID, DM_Trackers_IsPlayerInvolved(sourceFlags, destFlags));
        DM_Trackers_HandleMobHit(timestamp, destName, destGUID, DM_Trackers_IsPlayerInvolved(sourceFlags, destFlags));
    end
end

local trackedGlows = {size=0, items={}};
local glowBorderPointsByPriority = {[1] = 32, [2] = 16, [3] = 8, [4] = 4, [5] = 2};

function DM_Trackers_MarkGlowForActivation(pull, subevent, warnDef, sourceName, sourceGuid, destName, destGuid, spellId, spellName)
    pull.status.warningStateChanged = true;

    if DM_Trackers_IsPriorityStartEvent(subevent, spellId) then
        DM_Trackers_TrackPriorityEvent(subevent, spellId, warnDef, sourceName, sourceGuid, destName, destGuid);

        pull.status.warningState = 1;
        pull.status.warningActive = false;
        pull.status.warningAbility = warnDef;
        pull.status.warningAbilityName = spellName;
        pull.status.warningSourceGUID = sourceGuid;
        pull.status.warningSourceName = sourceName;
        pull.status.warningDestGUID = destGuid;
        pull.status.warningDestName = destName;
        pull.status.warningFrame = nil;
        pull.status.warningStartEvent = subevent;
    else
        -- print("MarkGlowForActivation: not a priority start event");
    end
end

function DM_Trackers_ActivateGlow(pull, pullFrame)
    local a = pull.status.warningAbility;

    pull.status.warningActive = true;
    pull.status.warningFrame = pullFrame;

    GlowLib.AutoCastGlow_Start(pullFrame, a.color, glowBorderPointsByPriority[a.priority]);

    if a.isTimed then
        pull.status.removeAfter = GetTimePreciseSec() + a.aliveTime/1000;
        -- print("ActivateGlow: remove after set to: " .. tostring(pull.status.removeAfter));
    end

    trackedGlows.size = trackedGlows.size + 1;
    trackedGlows.items[trackedGlows.size] = pull;
end

function DM_Trackers_DeactivateGlow(pull)
    local pullFrame = pull.status.warningFrame;

    pull.status.warningActive = false;
    pull.status.warningFrame = nil;

    GlowLib.AutoCastGlow_Stop(pullFrame);
end

function DM_Trackers_HandleGlowStateChange(pull, pullFrame)
    if pull.status.warningStateChanged then
        local a = pull.status.warningAbility;

        if pull.status.warningState == 1 then
            DM_Trackers_ActivateGlow(pull, pullFrame);
        else
            DM_Trackers_DeactivateGlow(pull);
        end

        pull.status.warningStateChanged = false;
    end
end

function DM_Trackers_ScanForGlowDeactivations()
    local t = GetTimePreciseSec();

    for i = 1, trackedGlows.size do
        local p = trackedGlows.items[i];

        if p and p.status.warningActive then
            if p.status.warningAbility.isTimed then
                if t > p.status.removeAfter then
                    DM_Trackers_DeactivateGlow(p);

                    trackedGlows.items[i] = nil;
                end
            end
        end
    end
end

function DM_Trackers_TrackPriorityEvent(e, s, w, sn, sg, dn, dg)
    trackedPriorityEvents.size = trackedPriorityEvents.size + 1;
    trackedPriorityEvents.items[trackedPriorityEvents.size] = { startEvent=e, spellId=s, warnDef=w, sourceName=sn, sourceGuid=sg, destName=dn, destGuid=dg };
end

function DM_Trackers_IsPriorityStartEvent(subevent, spellId)
    local dungeonCtx = DM_Dungeons_GetDungeonContextByCurrentZone();

    return dungeonCtx.priorityAbilities[spellId] ~= nil and dungeonCtx.priorityAbilities[spellId].warningEvents[subevent] ~= nil;
end

function DM_Trackers_IsPriorityClearEvent(subevent, spellId)
    for i = 1, trackedPriorityEvents.size do
        local e = trackedPriorityEvents.items[i];

        if e.spellId == spellId and e.warnDef.warningEvents[e.startEvent].clearEvents[subevent] then
            return true;
        end
    end

    return false;
end

function DM_Trackers_HandlePriorityAbility(timestamp, subevent, sourceGUID, sourceName, destGUID, destName, spellId, spellName, spellSchool)
    local dungeonCtx = DM_Dungeons_GetDungeonContextByCurrentZone();

    local a = dungeonCtx.priorityAbilities[spellId];

    if not sourceName or not sourceGUID then
        return;
    end

    -- todo: add check for player involved?

    local needsUpdate = false;

    local pull = nil;

    if onRoute.guids[sourceGUID] == nil then
        return;
    end

    local isPriorityStartEvent = DM_Trackers_IsPriorityStartEvent(subevent, spellId);
    local isPriorityClearEvent = DM_Trackers_IsPriorityClearEvent(subevent, spellId);

    if not isPriorityStartEvent and not isPriorityClearEvent then
        return;
    end

    for i = 1, onRoute.pulls.size do
        pull = onRoute.pulls.items[i];

        if not needsUpdate and not pull.isHeader and pull.guid == sourceGUID then
            if not pull.status.warningActive and DM_Trackers_IsPriorityStartEvent(subevent, spellId) then
                DM_Trackers_MarkGlowForActivation(pull, subevent, a, sourceName, sourceGUID, destName, destGUID, spellId, spellName);
            elseif pull.status.warningActive and isPriorityClearEvent then
                DM_Trackers_DeactivateGlow(pull);
            end

            needsUpdate = true;
        end
    end

    if needsUpdate then
        DM_Trackers_RefreshPullTracker();
    end
end

function DM_Trackers_HandleNpcDeath(ts, name, guid, markSkipped, flags)
    DM_Trackers_ProcessDeadMob(ts, guid, flags, onRoute);
end

function DM_Trackers_HandlePlayerDeath(ts, name, guid, markSkipped, flags)
    if guid and guid == UnitGUID("player") then
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_DO_NOT_RELEASE);
    else
        DM_Trackers_SetImmediateAction(IMMEDIATE_ACTION_SIGNAL_RELEASE);
    end

    wingsIcon:Show();
end

function DM_Trackers_GetPullByGroupAndRelativeIndex(pulls, areaKey, mobGroup, mobIndex)
    for i = 1, pulls.size do
        local p = pulls.items[i];

        if p.areaKey == areaKey and p.mobGroup == mobGroup and p.isHeader then
            return pulls.items[i+1+mobIndex];
        end
    end
end

function DM_Trackers_ProcessSkippedMob(ts, areaKey, mobGroup, mobIndex, guid, r)
    -- guid can be nil here but mobIndex should never be nil.
    -- this path allows user interaction with any group in the tracker so the mobs
    -- may not be active (have a guid) yet.

    if not mobIndex then
        print("Dungeon Mentor: error, to flag a mob as skipped an index into the group must be passed");
        return;
    end

    if not r and not onRoute then
        print("Dungeon Mentor: error, to flag a mob a valid route must be available");
        return;
    end

    local route = r or onRoute;
    local pulls = route.pulls;

    if not pulls then
        print("Dungeon Mentor: pulls is nil in ProcessSkippedMob, this should not happen");
        return;
    end

    local p = DM_Trackers_GetPullByGroupAndRelativeIndex(pulls, areaKey, mobGroup, mobIndex);

    if p then
        p.wasSkipped = true;

        route.pulls.items[p.headerIndex].deadCount = route.pulls.items[p.headerIndex].deadCount + 1;

        if route.pulls.items[p.headerIndex].deadCount == route.pulls.items[p.headerIndex].groupSize then
            if not route.deadPulls[p.areaKey] then
                route.deadPulls[p.areaKey] = {};
            end

            route.deadPulls[p.areaKey][p.mobGroup] = true;
        end

        DM_Trackers_RefreshPullTracker();
    else
        -- print("Dungeon Mentor: pull not found in ProcessSkippedMob, this should not happen");
    end
end

function DM_Trackers_ProcessDeadMob(ts, guid, flags, r, preventRefresh)
    if not DM_Trackers_IsChallengeModeActive() then
        -- only handle mob hits when dungeon is active
        return;
    end

    -- if the mob is dead, then we have two cases to handle:
    -- #1: mob is already active, meaning we'll find the guid registered
    -- #2: mob is not active yet, so guid won't be registered. this will generally apply to
    --     one-shots of the mob. we want the addon to work for non-key dungeons as much as possible
    --     to save ourselves work when we get to handling non-key dungeons, and in general
    --     non-key dungeons are good testing beds. so we must handle this case

    if not guid then
        DM_Util_PrintSystemMessage("ERROR - trying to process dead mob without a guid. If you see this please report it as a bug along with what was happening in the dungeon");
        return;
    end

    if not r and not onRoute then
        DM_Util_PrintSystemMessage("ERROR - flagging a mob's death requires a valid route");
        return;
    end

    local refreshTracker = false;
    local mobFound = false;
    local npcId = DM_Util_NpcIdFromGuid(guid);

    -- default to the on route pulls but allow override

    local route = r or onRoute;
    local pulls = route.pulls;

    if guid and route.guids[guid] ~= nil then
        -- Case #1: guid is already assigned, so we can make the assumption the HandleMobHit logic
        --          has already fired for this specific pull line
        local pull = pulls.items[route.guids[guid]];

        if not pull.status.isDead then
            pull.status.isDead = true;
            refreshTracker = true;
            mobFound = true;
            pull.status.isActive = false;

            DM_Trackers_RecordMobDeath(ts, GetTime(), guid, false, pull.areaKey, 
                                       pull.mobGroup, route.guids[guid], false, markSkipped, flags);

            if pull.status.warningActive then
                DM_Trackers_DeactivateGlow(pull);
            end

            local mob = pull.mob or pull.mutexMob1;

            if not markSkipped then
                currentDeadForces = currentDeadForces + mob.forceCount;
                onRoute.deadForces = route.deadForces + mob.forceCount;
            else
                pull.wasSkipped = true;
            end

            onRoute.pulls.items[pull.headerIndex].deadCount = route.pulls.items[pull.headerIndex].deadCount + 1;

            if route.pulls.items[pull.headerIndex].deadCount == route.pulls.items[pull.headerIndex].groupSize then
                if not route.deadPulls[pull.areaKey] then
                    route.deadPulls[pull.areaKey] = {};
                end

                route.deadPulls[pull.areaKey][pull.mobGroup] = true;
            end
        else
            -- we won't error here as we'll allow this path to happen since this is a possibility:
            -- pre-req: a group has 3 mobs
            -- #1: 2 mobs get assigned GUIDs
            -- #2: the user clicks "mark group as dead" or 2 mobs die naturally
            -- #3: the user clicks "mark group as dead", this will re-process the 2 already dead mobs
        end
    else
        -- case #2: mob has NOT been hit yet, so we'll be combining guid assignment with death
        for i = 1, route.pulls.size do
            local pull = route.pulls.items[i];

            if not mobFound and not pull.isHeader and not pull.isAreaHeader
                   and not pull.guid
                   and not pull.wasSkipped 
                   and (not route.deadPulls[pull.areaKey] or not route.deadPulls[pull.areaKey][pull.mobGroup])
                   and (pull.mob and pull.mob.npcid == npcId)
                   and not pull.status.isDead
                   and DM_Trackers_EligibleForActivation(pull) then
                if guid then
                    pull.guid = guid;
                    route.guids[guid] = i;
                end

                pull.status.isDead = true;
                pull.status.isActive = false;
                if not markSkipped then
                    currentDeadForces = currentDeadForces + pull.mob.forceCount;
                    route.deadForces = route.deadForces + pull.mob.forceCount;
                else
                    pull.wasSkipped = true;
                end

                if pull.status.warningActive then
                    DM_Trackers_DeactivateGlow(pull);
                end

                refreshTracker = true;
                mobFound = true;
                route.pulls.items[pull.headerIndex].deadCount = route.pulls.items[pull.headerIndex].deadCount + 1;

                DM_Trackers_RecordMobDeath(ts, GetTime(), guid, false, pull.areaKey, pull.mobGroup, i, false, markSkipped, flags);

                if route.pulls.items[pull.headerIndex].deadCount == route.pulls.items[pull.headerIndex].groupSize then
                    if not route.deadPulls[pull.areaKey] then
                        route.deadPulls[pull.areaKey] = {};
                    end

                    route.deadPulls[pull.areaKey][pull.mobGroup] = true;
                end
            end
        end
    end

    if refreshTracker and not preventRefresh then
        DM_Trackers_RefreshPullTracker();
    end
end

local function HandleUnitDeath(timestamp, destName, destFlags, destGuid)
    if destName then
        if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK) == COMBATLOG_OBJECT_TYPE_NPC then
            --print("NPC Death: " .. tostring(destName));
            -- DM_Trackers_HandleNpcDeath(timestamp, destName, destGuid, false, destFlags);
            DM_Trackers_ProcessDeadMob(timestamp, destGuid, destFlags, onRoute);
        elseif bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK) == COMBATLOG_OBJECT_TYPE_PLAYER then
            --print("Player Death: " .. tostring(destName));
            DM_Trackers_HandlePlayerDeath(timestamp, destName, destGuid, false, destFlags);
        end
	end    
end

-- https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT
local function handleCombatLogEventUnfiltered(...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...;
    local spellId, spellName, spellSchool, failedType;
    local auraType;
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, absorbed;

    if subevent == "UNIT_DIED" then
        HandleUnitDeath(timestamp, destName, destFlags, destGUID);
    end

    if mobEventsOfInterest[subevent] == 1 then
        spellId, spellName, spellSchool = select(12, ...);
        DM_Trackers_HandleEventOfInterest(timestamp, subevent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool);
    end

    spellId, spellName, spellSchool = select(12, ...);

    local dungeonCtx = DM_Dungeons_GetDungeonContextByCurrentZone();

    if spellId and dungeonCtx and dungeonCtx.priorityAbilities and dungeonCtx.priorityAbilities[spellId] then
        DM_Trackers_HandlePriorityAbility(timestamp, subevent, sourceGUID, sourceName, destGUID, destName, spellId, spellName, spellSchool);
    end
end

local lastQuantity = 0;
local criteriaObjectives = {};

function DM_Trackers_ClearObjectives()
    criteriaObjectives = {};
end

function DM_Trackers_SetObjectiveComplete(criteriaNumber)
    criteriaObjectives[criteriaNumber] = true;
end

function DM_Trackers_IsObjectiveComplete(criteriaNumber)
    return criteriaObjectives and criteriaObjectives[criteriaNumber];
end

function DM_Trackers_UpdateCriteria()
    local scenarioName, currentStage, numStages, flags, _, _, _, xp, money, scenarioType, _, textureKit = C_Scenario.GetInfo();

    if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local numCriteria = select(3, C_Scenario.GetStepInfo())
        local anyIncomplete = false;
        local anyMarked = false;

        for criteriaIndex = 1, numCriteria do
			local criteriaString, criteriaType, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
			if isWeightedProgress then
				local currentQuantity = quantityString and tonumber( strsub(quantityString, 1, -2) )

                DM_Trackers_SetForceText(tostring(currentQuantity) .. " / " .. tostring(totalQuantity));

                if currentQuantity < totalQuantity then
                    anyIncomplete = true;
                end

				lastQuantity = currentQuantity;
            else
                if quantity and totalQuantity and quantity < totalQuantity then
                    anyIncomplete = true;
                elseif quantity and totalQuantity and quantity == totalQuantity then
                    DM_Trackers_SetObjectiveComplete(criteriaIndex);

                    if DM_Trackers_ScanPullsForAutocomplete(activeRoute, criteriaIndex) then
                        anyMarked = true;
                    end
                end
			end
		end

        if not anyIncomplete then
            -- todo: add 'complete' action for final criteria that isn't enemy forces (ie, numCriteria-1)
            --       ozumat was not getting marked complete
            -- updated todo: i think this issue is fixed but leaving here in case it isn't
            ObjectiveTrackerFrame:Show(); -- re-enable this for usage outside the dungeon
        end

        if anyMarked then
            DM_Trackers_RefreshPullTracker();
        end
	end
end

function DM_Trackers_CreateDawnDialog()
    local backdrop = {
        bgFile = "Interface/BUTTONS/WHITE8X8",
        edgeFile = "Interface/GLUES/Common/Glue-Tooltip-Border",
        tile = true,
        edgeSize = 8,
        tileSize = 8,
        insets = {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        },
    }

    dawnDiscriminatorFrame = CreateFrame("Frame", "DM_Trackers_DawnFrame", UIParent, "UIPanelDialogTemplate");
    dawnDiscriminatorFrame:Hide();
    dawnDiscriminatorFrame:SetSize(260, 140);
    dawnDiscriminatorFrame:SetMovable(true);
    dawnDiscriminatorFrame:EnableMouse(true);
    dawnDiscriminatorFrame:ClearAllPoints();
    dawnDiscriminatorFrame:SetFrameStrata("DIALOG");
    dawnDiscriminatorFrame:SetPoint("CENTER");

    dawnDiscriminatorFrame.ui = {};
    dawnDiscriminatorFrame.ui.titleText = dawnDiscriminatorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dawnDiscriminatorFrame.ui.titleText:SetPoint("TOPLEFT", dawnDiscriminatorFrame, "TOPLEFT", 20, -10)
    dawnDiscriminatorFrame.ui.titleText:SetJustifyH("LEFT")
    dawnDiscriminatorFrame.ui.titleText:SetText("Dungeon Mentor");
    dawnDiscriminatorFrame.ui.titleText:SetHeight(10);
    dawnDiscriminatorFrame.ui.titleText:Show();

    dawnDiscriminatorFrame.ui.mainText = dawnDiscriminatorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dawnDiscriminatorFrame.ui.mainText:SetPoint("TOPLEFT", dawnDiscriminatorFrame, "TOPLEFT", 20, -34)
    dawnDiscriminatorFrame.ui.mainText:SetJustifyH("LEFT")
    dawnDiscriminatorFrame.ui.mainText:SetText("Dungeon Mentor needs to know whether you are running the first half or the second half of this dungeon. Please select.");
    dawnDiscriminatorFrame.ui.mainText:SetWordWrap(true);
    dawnDiscriminatorFrame.ui.mainText:SetWidth(230);
    dawnDiscriminatorFrame.ui.mainText:Show();

    dawnDiscriminatorFrame.ui.dawnOneButton = CreateFrame("Button", "DM_Trackers_DawnButton1", dawnDiscriminatorFrame, "UIPanelButtonTemplate");
    dawnDiscriminatorFrame.ui.dawnOneButton:SetPoint("TOPLEFT", dawnDiscriminatorFrame.ui.mainText, "BOTTOMLEFT", 20, -10);
    dawnDiscriminatorFrame.ui.dawnOneButton:SetHeight(22);
    dawnDiscriminatorFrame.ui.dawnOneButton:SetWidth(170);
    dawnDiscriminatorFrame.ui.dawnOneButton:SetText("Galakrond's Fall (Part 1)");
    dawnDiscriminatorFrame.ui.dawnOneButton:Show();
    dawnDiscriminatorFrame.ui.dawnOneButton:SetScript("OnClick", function(self)
        DM_Util_PrintSystemMessage("Dawn of the Infinites set to Galakrond's Fall. If you need to change this, type: /vdm dawn 2");
        DM_Dungeons_SetZoneDiscriminator(1);
        dawnDiscriminatorFrame:Hide();
    end);

    dawnDiscriminatorFrame.ui.dawnTwoButton = CreateFrame("Button", "DM_Trackers_DawnButton2", dawnDiscriminatorFrame, "UIPanelButtonTemplate");
    dawnDiscriminatorFrame.ui.dawnTwoButton:SetPoint("TOPLEFT", dawnDiscriminatorFrame.ui.dawnOneButton, "BOTTOMLEFT", 0, 0);
    dawnDiscriminatorFrame.ui.dawnTwoButton:SetHeight(22);
    dawnDiscriminatorFrame.ui.dawnTwoButton:SetWidth(170);
    dawnDiscriminatorFrame.ui.dawnTwoButton:SetText("Muruzond's Rise (Part 2)");
    dawnDiscriminatorFrame.ui.dawnTwoButton:Show();
    dawnDiscriminatorFrame.ui.dawnTwoButton:SetScript("OnClick", function(self)
        DM_Util_PrintSystemMessage("Dawn of the Infinites set to Murozond's Rise. If you need to change this, type: /vdm dawn 1");
        DM_Dungeons_SetZoneDiscriminator(2);
        dawnDiscriminatorFrame:Hide();
    end);
end

-- This will change per season. Not worth trying to generalize this code
-- just for the mega-dungeons.
function DM_Trackers_HandleZoneChange()
    local zoneId = DM_Util_GetCurrentZoneId();
    local mapId = C_Map.GetBestMapForUnit("player");

    -- 2579 is zone id, 2190 is map id
    if zoneId == 2579 or zoneId == 2190 then
        if not dawnDiscriminatorFrame then
            DM_Trackers_CreateDawnDialog();
        end

        dawnDiscriminatorFrame:Show();
    end
end

function DM_Trackers_SetUiActive()
    routeCorruptionIcon:Hide();
    wingsIcon:Hide();
    forceText:SetText("");
    forceText:Show();
end

function DM_Trackers_SetUiInactive()
    routeCorruptionIcon:Hide();
    wingsIcon:Hide();
    forceText:SetText("");
    forceText:Hide();
    readyCheckReceivedResponses = nil;
end

local function handleGameEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        handleCombatLogEventUnfiltered(CombatLogGetCurrentEventInfo());
    end

    if event == "CHALLENGE_MODE_START" then
        DM_Util_PrintSystemMessage("Dungeon Mentor: Good luck in your dungeon!");
        activeDungeonContext = DM_Dungeons_GetDungeonContextByCurrentZone();
        if not activeDungeonContext then
            DM_Util_PrintSystemMessage("Dungeon Mentor - ERROR: CHALLENGE_MODE_START -- cannot obtain current dungeon context by zone");
            return;
        end

        DM_Trackers_SetUiActive();
        DM_Trackers_InitHistory();
        DM_Trackers_ClearObjectives();

        challengeModeStartTime = GetTime();

        -- TODO: do more testing here to hide the smallest frame possible
        -- if DM_Options_ShouldHideBlizzardUI() then
        --     ObjectiveTrackerFrame:Hide();
        -- end
    end

    if event == "READY_CHECK" then
        if DM_Util_InDungeonGroup() then
            DM_Trackers_InitReadyCheckStatus();
        end
    end

    if event == "READY_CHECK_CONFIRM" then
        local unitTarget, isReady = ...;

        if DM_Util_InDungeonGroup() then
            DM_Trackers_HandleReadyCheckConfirm(unitTarget, isReady);
        end
    end

    if event == "READY_CHECK_FINISHED" then
        if DM_Util_InDungeonGroup() then
            DM_Trackers_HandleReadyCheckFinished();
        end
    end

    if event == "ZONE_CHANGED_NEW_AREA" then
        DM_Trackers_HandleZoneChange();
    end

    if event == "SCENARIO_CRITERIA_UPDATE" then
        DM_Trackers_UpdateCriteria();
    end

    if event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE" then
        DM_Group_RefreshMembers();
        DM_Trackers_StartVersionRequests();
    end
end

trackerEventsFrame:SetScript("OnEvent", handleGameEvent);
trackerEventsFrame:SetScript("OnUpdate", DM_Trackers_OnUpdate);

