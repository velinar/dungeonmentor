local Serializer = LibStub:GetLibrary("AceSerializer-3.0");
local AC = LibStub:GetLibrary("AceComm-3.0");

-- CONSTANTS
local DUNGEON_MENTOR_ROUTE_CHAT_PREFIX = "VDMxR";
local DUNGEON_MENTOR_STATUS_CHAT_PREFIX = "VDMxS";
local ROUTE_ITEM_TYPE_MOBGROUP = 1;
local ROUTE_ITEM_TYPE_ENVMARKER = 2;
local ROUTE_ITEM_ANNOTATION_COUNT = 4;
local ROUTE_ITEM_ANNOTATION_CAUTION = 1;
local ROUTE_ITEM_ANNOTATION_LUST = 2;
local ROUTE_ITEM_ANNOTATION_LOS_PULL = 3;
local ROUTE_ITEM_ANNOTATION_STEALTH = 4;
local NOTE_CHARACTER_LIMIT = 60;
local NO_ROUTES_TEXT = "(No Routes)";

local CURRENT_GAME_VERSION = 10;
local CURRENT_SEASON = 3;

local MAP_TILE_UI_PREFIX = "mapTile";

local DEFAULT_IMPORT_BODY_TEXT = "Paste a valid route into below text box.";
local DEFAULT_EXPORT_BODY_TEXT = "Copy text below to your system clipboard, then share outside the game.";
local EXPORT_ROUTE_FRAME_TITLE = "Dungeon Mentor: Import Route";
local EXPORT_ROUTE_FRAME_TITLE = "Dungeon Mentor: Export Route";

local MESSAGE_TYPE_ROUTE_REQUEST = 1;

local MAP_MARKER_NORMAL_SIZE = 16;
local MAP_MARKER_ZOOMED_SIZE = 32;

local IMPORT_VIEW = 0;
local EXPORT_VIEW = 1;

local ROUTEBUILDER_UI_SOURCE_MAP_WIDTH = 1120;
local ROUTEBUILDER_UI_SOURCE_MAP_HEIGHT = 740;

local ROUTEBUILDER_UI_WIDTH = ROUTEBUILDER_UI_SOURCE_MAP_WIDTH + 325;
local ROUTEBUILDER_UI_HEIGHT = ROUTEBUILDER_UI_SOURCE_MAP_HEIGHT + 30;

local SIDE_PANEL_WIDTH = 300;

local DEFAULT_IMPORT_ROUTE_TEXT = "Paste a valid route into below text box.";
local routeItemAnnotationsText = {
    [ROUTE_ITEM_ANNOTATION_CAUTION] = {
        [0] = "CAUTION!",
        [1] = "SLOW",
        [2] = "WAIT FOR TANK"
    },
    [ROUTE_ITEM_ANNOTATION_LUST] = {
        [0] = "LUST ON PULL",
        [1] = "LUST WHEN CALLED"
    },
    [ROUTE_ITEM_ANNOTATION_LOS_PULL] = {
        [0] = "LOS PULL, HIDE"
    },
    [ROUTE_ITEM_ANNOTATION_STEALTH] = {
        [0] = "INVIS WHEN CALLED"
    },
}

local ui = {
    routeBuilderRootFrame = nil,
    routeBuilderMapRootFrame = nil,
    routeBuilderMapPanelFrame = nil,
    routeBuilderMapScrollFrame = nil,
    routeBuilderMapScrollChildFrame = nil, -- previously mapPanelFrame
    mapButtons = {
        pullNumberAnnotation = nil
    },
    routeCheckBoxes = {
        defaultCb = nil,
        tyrCb = nil,
        fortCb = nil
    },
    dropdowns = {
        dungeon = nil,
        dungeonFloor = nil,
        routes = nil
    },
    mapAnnotationStrings = {size=0, items={}},
    sidePanelRootFrame = nil,
    sidePanelTextLines = {size=0, items={}},
    routeItemToolbarItems = {size=0, items={}},
    sidePanelPullScrollFrame = nil,
    sidePanelPullScrollChildFrame = nil,
    sidePanelUiForcesString = nil,
    sidePanelActivateRouteButton = nil,
    importExportFrame = nil,
    importExportFrameChild = nil,
    routeImportExportEditBox = nil,
    importExportEditBox = nil,
    noteFrame = nil,
    confirmDialog = nil
};

-- this tracks what was previously drawn, so we can reference it as view of the map/UI changes via uiContext
local uiDrawnContext = {
    selectedMapMobMarker = nil,
    mapMobMarkers = nil
};

-- Gathering all the various bookkeeping data here
local uiContext = {
    -- going a little crazy with what we keep in context just to make the code as easy as possible

    -- previously this was "route context" but cleaning up the mental model here.
    -- a route contains data about the route and then the route itself.
    -- the route itself is now called "route items" and what was the "route context" is just the "route"
    -- as this makes everything a lot clearer.
    currentRoute = nil,
    currentRouteIndex = nil,
    currentDungeonContext = nil,
    currentDungeonIndex = nil,
    currentFloorIndex = nil,

    -- this allows us to improve user experience by retaining the context
    -- of a specific dungeon as they change dungeons. e.g., if the 3rd floor
    -- is selected in black rook and they change to atal'dazar, it'll show
    -- first floor, but swapping back to black rook will present 3rd floor
    -- again.
    dungeonSpecificContext = {
        -- [1] = { selectedFloorIndex = 1, selectedRouteIndex = 1 }
    },

    selectedRouteItem = nil,

    routes = nil,

    defaultRouteChecked = nil,
    tyrChecked = nil,
    fortChecked = nil,

    sidePanelTextLines = {size=0, items={}},
    sidePanelDisplayedTextLineCount = 0,

    setImportView = false,
    setExportView = false,
    importExportView = nil,

    routeItemsToolbarEnabled = false,

    selectedMapMobMarker = nil,
    mapMobMarkers = {},

    mapAnnotations = {
        pullNumbersEnabled = false
    },

    tempRouteForImport = nil,

    noteEditingContext = {
        data = nil,
        startNote = "",
        savedNote = "",
        promote = false,
        wasSaved = false,
        wasCanceled = false
    }
};

if not DM_GlobalOptions then
    DM_GlobalOptions = {};
end

if not DM_Routes then
    DM_Routes = {};
end

if not DM_Tracker_History then
    DM_Tracker_History = {};
end

if not DM_GlobalDungeons then
    DM_GlobalDungeons = {};
end

------------------------------------------------------------------------------
-- Managing UI state
------------------------------------------------------------------------------

local function DM_RouteBuilder_Map_EnablePullNumbers()
    uiContext.mapAnnotations.pullNumbersEnabled = true;
end

local function DM_RouteBuilder_Map_ArePullNumbersEnabled()
    return uiContext.mapAnnotations.pullNumbersEnabled;
end

local function DM_RouteBuilder_Map_DisablePullNumbers()
    uiContext.mapAnnotations.pullNumbersEnabled = false;
end

local function DM_RouteBuilder_Map_TogglePullNumbers()
    uiContext.mapAnnotations.pullNumbersEnabled = not uiContext.mapAnnotations.pullNumbersEnabled;
end

local function DM_RouteBuilder_Map_MapAnnotationsEnabled()
    return DM_RouteBuilder_Map_ArePullNumbersEnabled();
end

local function DM_RouteBuilder_Controls_DisableRouteItemToolbars()
end

local function DM_RouteBuilder_Controls_EnableRouteItemToolbars()
end

local function DM_RouteBuilder_DungeonSpecificContext(dungeonIndex)
    if not uiContext.dungeonSpecificContext then
        uiContext.dungeonSpecificContext = {};
    end

    if not uiContext.dungeonSpecificContext[dungeonIndex] then
        uiContext.dungeonSpecificContext[dungeonIndex] = {};
    end

    return uiContext.dungeonSpecificContext[dungeonIndex];
end

------------------------------------------------------------------------------
-- Route communication
------------------------------------------------------------------------------

-- format for route requests is:
-- route:1:<zoneId>:<route name in full>
-- ^^^^ literal 'route'
--       ^ literal '1', this corresponds to MESSAGE_TYPE_ROUTE_REQUEST, prefer constant MESSAGE_TYPE_ROUTE_REQUEST over using 1 in code
--         ^^^^^^^^ numbers corresponding to zone ID of route, for mega-dungeons the zone discriminator is simply appended to zone ID (thus translation is required)
--                  ^^^^^^^^^^^^^^^^^^^^^^^ route name, special characters are allowed as this is simply "the rest of the input"
--
-- important note: the discriminator is appended to zoneId, just to shift work from parsing to separating zone ID from discriminator
AC:RegisterComm(DUNGEON_MENTOR_ROUTE_CHAT_PREFIX, function(prefix, message, distribution, sender)
    if StringStartsWith(message, "route:") then
        local _, _, msgType, msgSubtype, zoneId, routeName = message:find("(%a+):(%d+):(%d+):(.*)");

        if tonumber(msgSubtype) == MESSAGE_TYPE_ROUTE_REQUEST then
            local zoneDisc = nil;
            local zid = tonumber(zoneId);

            if zid == 2579 or zid == 25791 then
                zoneDisc = 1;
                zid = 2579;
            elseif zid == 25792 then
                zoneDisc = 2;
                zid = 2579;
            end

            local route = DM_RouteBuilder_GetRouteByZoneAndName(zid, zoneDisc, routeName);

            if route then
               local shrunkRoute = DM_RouteBuilder_DehydrateRoute(route);

               if shrunkRoute then
                  local encodedRoute = DM_Util_Base64_Encode(Serializer:Serialize(shrunkRoute));
                  local routeResponse = "routeReply:" .. zoneId .. ":" .. encodedRoute;

                  AC:SendCommMessage(DUNGEON_MENTOR_ROUTE_CHAT_PREFIX, routeResponse, "WHISPER", sender, "NORMAL");
               end
            else
               DM_Util_PrintSystemMessage("ERROR: route with name [" .. routeName .. "] not found, cannot respond to route request");
           end
        end
    elseif StringStartsWith(message, "routeReply:") then
        local _, _, zoneId, encodedRoute = message:find("(%d+):(.*)");

        local zoneDisc = nil;
        local zid = tonumber(zoneId);

        if zid == 2579 or zid == 25791 then
            zoneDisc = 1;
            zid = 2579;
        elseif zid == 25792 then
            zoneDisc = 2;
            zid = 2579;
        end

        DM_RouteBuilder_ImportRoute(zid, zoneDisc, encodedRoute);
    end
end);

-- I want full expressiveness of the route locally so we can track whatever data we want,
-- but when we send the route to another player/share online, I want a much lighter
-- format. We'll abbreviate (mg for mobGroup, l for linkStatus, an for annotations) 
-- as well as trim any data that isn't present. We'll also assume lack of a linkStatus 
-- means the linkStatus is 0 when we re-hydrate the route. This dehydration reduces 
-- input size by somewhere around 30-60% depending on how many notes are included 
-- with the route, this savings has an amplifying effect on the size of the Base64 encoded text.
-- we're not compressing the base64 yet but this will be done in the future

-- important: route context is the specific route (the route items) with the additional data about the route
function DM_RouteBuilder_DehydrateRoute(r)
    local shrunk = {};

    shrunk.n = r.name;
    shrunk.gv = r.gameVersion;
    shrunk.s = r.season;
    shrunk.z = r.zoneId;
    shrunk.zd = r.zoneDiscriminator;
    shrunk.a = r.author;

    -- this is "route type" and includes default / tyrannical / fortified as bitwise, 
    -- we'll change this to nil if it's still zero after we build the value.
    -- this exists only in the hydration code to combine other fields into one
    --
    -- fields:
    --    0x4 = fortified
    --    0x2 = tyrannical
    --    0x1 = default
    -- 0x4 and 0x2 are mutually exclusive and care must be taken to enforce this
    shrunk.rt = 0;

    if r.isDefault then
        shrunk.rt = shrunk.rt + 1;
    end
    if r.isFort then
        shrunk.rt = shrunk.rt + 4;
    end
    if r.isTyr then
        shrunk.rt = shrunk.rt + 2;
    end
    if shrunk.rt == 0 then
        shrunk.rt = nil; -- nil this out so it is excluded
    end

    shrunk.i = {};
    shrunk.size = r.routeItems.size;
    for i = 1, r.routeItems.size do
        shrunk.i[i] = { };
        shrunk.i[i].mg = r.routeItems.items[i].mobGroup;
        shrunk.i[i].e = r.routeItems.items[i].envMarker;
        shrunk.i[i].t = r.routeItems.items[i].type;
        shrunk.i[i].a = r.routeItems.items[i].areaKey;
        if r.routeItems.items[i].note and r.routeItems.items[i].note.text and string.len(r.routeItems.items[i].note.text) > 0 then
            shrunk.i[i].n = r.routeItems.items[i].note.text;
            shrunk.i[i].pn = r.routeItems.items[i].note.promote;
        end
        if r.routeItems.items[i].linkStatus ~= 0 then
            shrunk.i[i].l = r.routeItems.items[i].linkStatus;
        end
        if r.routeItems.items[i].annotations then
            for ai = 1, ROUTE_ITEM_ANNOTATION_COUNT do
                if r.routeItems.items[i].annotations[ai] then
                    if not shrunk.i[i].an then
                        shrunk.i[i].an = {};
                    end

                    shrunk.i[i].an[ai] = {i=r.routeItems.items[i].annotations[ai].msgIndex};
                end
            end
        end
    end

    return shrunk;
end

-- returns nil if data in 's' does not match the required format for a route
function DM_RouteBuilder_RehydrateRoute(s)
    if s == nil then
        return nil;
    end

    local r = { name = "", routeItems={size=0, items={}}, itemsIndexMap={}};
    local shrunk = {};

    if not s.n then
        return nil;
    end

    r.name = s.n;

    if not s.gv then
        return nil;
    end

    r.gameVersion = s.gv;

    if not s.s then
        return nil;
    end

    r.season = s.s;

    if not s.z then
        return nil;
    end

    r.zoneId = s.z;

    -- will be nil most of the time, except for mega-dungeons split into 2 or other "use same zone twice" shenanigans
    r.zoneDiscriminator = s.zd;

    if not s.a then
        return nil;
    end

    r.author = s.a;

    if not s.size then
        return nil;
    end

    r.routeItems.size = s.size;

    if not s.i then
        return nil;
    end

    -- this is "route type" and includes default / tyrannical / fortified as bitwise, 
    -- we'll change this to nil if it's still zero after we build the value.
    -- this exists only in the hydration code to combine other fields into one
    --
    -- fields:
    --    0x4 = fortified
    --    0x2 = tyrannical
    --    0x1 = default
    -- 0x4 and 0x2 are mutually exclusive and care must be taken to enforce this

    if s.rt then
        local num = tonumber(s.rt);

        if bit.band(num, 4) == 4 then
            r.isFort = true;
        end
        if bit.band(num, 2) == 2 then
            r.isTyr = true;
        end
        if bit.band(num, 1) == 1 then
            r.isDefault = true;
        end
    else
        r.isDefault = false;
        r.isTyr = false;
        r.isFort = false;
    end

    for i = 1, s.size do
        r.routeItems.items[i] = {note=nil, linkStatus=0, 
                                 type=s.i[i].t,
                                 areaKey=s.i[i].a, mobGroup=s.i[i].mg, 
                                 envMarker=s.i[i].e, annotations={} };
        if s.i[i].n then
            r.routeItems.items[i].note = {text=s.i[i].n, promote=s.i[i].pn};
            --r.route.items[i].note = s.i[i].n;
            --r.route.items[i].promoteNote = s.i[i].pn;
        end
        if s.i[i].l then
            r.routeItems.items[i].linkStatus = s.i[i].l;
        end
        if s.i[i].an then
            for ai = 1, ROUTE_ITEM_ANNOTATION_COUNT do
                if s.i[i].an and s.i[i].an[ai] then
                    r.routeItems.items[i].annotations[ai] = { msgIndex=s.i[i].an[ai].i };
                end
            end
        end
    end

    for i = 1, r.routeItems.size do
        local t = r.routeItems.items[i].type;
        local a = r.routeItems.items[i].areaKey;
        local m = r.routeItems.items[i].mobGroup or r.routeItems.items[i].envMarker;

        if t == ROUTE_ITEM_TYPE_MOBGROUP then
            DM_RouteBuilder_SetMobGroupRouteItemIndex(r, a, m, i);
        --elseif t == ROUTE_ITEM_TYPE_ENVMARKER then
        --    DM_RouteBuilder_SetEnvMarkerRouteItemIndex(r, a, m, i);
        end
    end

    return r;
end

------------------------------------------------------------------------------
-- Route-centric Logic
------------------------------------------------------------------------------

local function DM_RouteBuilder_SelectRouteItem(areaKey, mobGroup)
    if not uiContext.currentRoute then
        DM_Util_PrintSystemMessage("ERROR: Cannot select route item, no active route. This is likely a bug.");
        return;
    end

    uiContext.currentRoute.selectedAreaKey = areaKey;
    uiContext.currentRoute.selectedMobGroup = mobGroup;

    uiContext.selectedRouteItem = DM_RouteBuilder_GetRouteItemByPullGroup(uiContext.currentRoute, areaKey, mobGroup);
end

local function DM_RouteBuilder_DeselectRouteItem()
    uiContext.currentRoute.selectedAreaKey = nil;
    uiContext.currentRoute.selectedMobGroup = nil;
    uiContext.selectedRouteItem = nil;
end

local function DM_RouteBuilder_IsPullGroupSelected(areaKey, mobGroup)
    if not uiContext.currentRoute then
        return false;
    end

    return uiContext.currentRoute.selectedAreaKey == areaKey and
           uiContext.currentRoute.selectedMobGroup == mobGroup;
end

local function DM_Data_DungeonSpecificData(dungeonIndex)
    if not uiContext.dungeonSpecificContext then
        uiContext.dungeonSpecificContext = {};
    end

    if not uiContext.dungeonSpecificContext[dungeonIndex] then
        uiContext.dungeonSpecificContext[dungeonIndex] = {};
    end

    return uiContext.dungeonSpecificContext[dungeonIndex];
end

local function DM_Data_RoutesRoot(dungeonIndex)
    if not dungeonIndex then
        return nil;
    end

    -- we're versioning routes because data format is almost guaranteed
    -- to change over time and this will give us a way to preserve old
    -- data formats as well as transition to new formats
    if not DM_Routes then
        DM_Routes = {v1={game={[10]={seasons={[3]={dungeons={}}}}}}};

        for i = 1, 8 do
            DM_Routes.v1.game[10].seasons[3].dungeons[i] = {};
            DM_Routes.v1.game[10].seasons[3].dungeons[i].routes = {size=0, items={}};
        end
    end

    if not DM_Routes then
        DM_Routes = {v1={game={[10]={seasons={[3]={dungeons={}}}}}}};
    end

    if not DM_Routes.v1 then
        DM_Routes.v1 = {game={[10]={seasons={[3]={dungeons={}}}}}};
    end

    if not DM_Routes.v1.game then
        DM_Routes.v1.game = {[10]={seasons={[3]={dungeons={}}}}};
    end

    if not DM_Routes.v1.game[10] then
        DM_Routes.v1.game[10] = {seasons={[3]={dungeons={}}}};
    end

    if not DM_Routes.v1.game[10].seasons then
        DM_Routes.v1.game[10].seasons = {};
        DM_Routes.v1.game[10].seasons[3] = {dungeons={}};
    end

    if not DM_Routes.v1.game[10].seasons[3].dungeons then
        DM_Routes.v1.game[10].seasons[3].dungeons = {};
    end

    for i = 1, 8 do
        if not DM_Routes.v1.game[10].seasons[3].dungeons[i] then
            DM_Routes.v1.game[10].seasons[3].dungeons[i] = {};
        end

        if not DM_Routes.v1.game[10].seasons[3].dungeons[i].routes then
            DM_Routes.v1.game[10].seasons[3].dungeons[i].routes = {size=0, items={}};
        end
    end

    return DM_Routes.v1.game[10].seasons[3].dungeons[dungeonIndex].routes;
end

local function DM_Data_DungeonDataRoot(dungeonIndex)
    if not dungeonIndex then
        print("DM_Data_DungeonDataRoot: ERROR - dungeonIndex is invalid, value=[" .. tostring(dungeonIndex) .. "]");
        return nil;
    end

    -- we're versioning this data much like routes, but highly unlikely we'll need
    -- to work too hard here version to version. routes are much more sensitive
    if not DM_GlobalDungeons then
        DM_GlobalDungeons = {v1={game={[10]={seasons={[3]={dungeons={}}}}}}};

        for i = 1, 8 do
            DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[i] = {};
            DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[i].data = {mobGroupNotes={}};
        end
    end

    if not DM_GlobalDungeons then
        DM_GlobalDungeons = {v1={game={[10]={seasons={[3]={dungeons={}}}}}}};
    end

    if not DM_GlobalDungeons.v1 then
        DM_GlobalDungeons.v1 = {game={[10]={seasons={[3]={dungeons={}}}}}};
    end

    if not DM_GlobalDungeons.v1.game then
        DM_GlobalDungeons.v1.game = {[10]={seasons={[3]={dungeons={}}}}};
    end

    if not DM_GlobalDungeons.v1.game[10] then
        DM_GlobalDungeons.v1.game[10] = {seasons={[3]={dungeons={}}}};
    end

    if not DM_GlobalDungeons.v1.game[10].seasons then
        DM_GlobalDungeons.v1.game[10].seasons = {};
        DM_GlobalDungeons.v1.game[10].seasons[3] = {dungeons={}};
    end

    if not DM_GlobalDungeons.v1.game[10].seasons[3].dungeons then
        DM_GlobalDungeons.v1.game[10].seasons[3].dungeons = {};
    end

    for i = 1, 8 do
        if not DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[i] then
            DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[i] = {};
            DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[i].data = {mobGroupNotes={}};
        end
    end

    return DM_GlobalDungeons.v1.game[10].seasons[3].dungeons[dungeonIndex].data;
end

local function DM_Data_DungeonMobGroupNotes(dungeonIndex, areaKey, mobGroup)
    local dataRoot = DM_Data_DungeonDataRoot(dungeonIndex);

    if not dataRoot.mobGroupNotes then
        dataRoot.mobGroupNotes = {};
    end

    if not dataRoot.mobGroupNotes.areas then
        dataRoot.mobGroupNotes.areas = {};
    end

    if not dataRoot.mobGroupNotes.areas[areaKey] then
        dataRoot.mobGroupNotes.areas[areaKey] = {};
    end

    if not dataRoot.mobGroupNotes.areas[areaKey].mobGroups then
        dataRoot.mobGroupNotes.areas[areaKey].mobGroups = {};
    end

    if not dataRoot.mobGroupNotes.areas[areaKey].mobGroups[mobGroup] then
        dataRoot.mobGroupNotes.areas[areaKey].mobGroups[mobGroup] = {text=""};
    end

    return dataRoot.mobGroupNotes.areas[areaKey].mobGroups[mobGroup];
end

local function DM_Data_Dungeon_GetNoteForMobGroup(dungeonIndex, areaKey, mobGroup)
    local data = DM_Data_DungeonMobGroupNotes(dungeonIndex, areaKey, mobGroup);

    if not data then
        DM_Util_PrintSystemMessage("ERROR: DM_Data_DungeonMobGroupNotes returned nil, this should not happen");
        return;
    end

    return data.text;
end

local function DM_Data_Dungeon_SetNoteForMobGroup(dungeonIndex, areaKey, mobGroup, noteText)
    local data = DM_Data_DungeonMobGroupNotes(dungeonIndex, areaKey, mobGroup);

    if not data then
        DM_Util_PrintSystemMessage("ERROR: DM_Data_DungeonMobGroupNotes returned nil, this should not happen");
        return;
    end

    data.text = noteText;
end

function DM_RouteBuilder_CurrentRoute()
    return uiContext.currentRoute;
end

--
-- DATA PATCH #1
--
-- This changes data format from initial data format to one that makes two key improvements:
-- dungeons are referred to by index; routes are organized under GAME VERSION -> SEASON -> DUNGEON
function DM_Patch_Data_ZoneIdsToIndex()
    if not DM_Routes or not DM_Routes.v1 then
        return;
    end

    -- DF season 2 zone IDs
    local zoneIds = {[1]=2520, [2]=1754, [3]=2527, [4]=2519, [5]=1458, [6]=657, [7]=2451, [8]=1841};
    local root = DM_Routes.v1;

    local needsPatch = false;

    for i = 1, 8 do
        if root[zoneIds[i]] then
            needsPatch = true;
        end
    end

    if needsPatch then
        DM_Util_PrintSystemMessage("Upgrading route data format, this is a one time operation.");
    else
        return;        
    end

    if not root.game then
        root.game = {};
        root.game[10] = {};
    end

    if not root.game[10].seasons then
        root.game[10].seasons = {};
        root.game[10].seasons[3] = {};
    end

    if not root.game[10].seasons[3].dungeons then
        root.game[10].seasons[3].dungeons = {};
    end

    -- step 1: move the old route data over
    for i = 1, 8 do
        root.game[10].seasons[3].dungeons[i] = {};
        root.game[10].seasons[3].dungeons[i].routes = root[zoneIds[i]];
        root[zoneIds[i]] = nil;
    end

    -- step 2: rename 'route' to 'routeItems'
    for i = 1, 8 do
        if root.game[10].seasons[3].dungeons[i].routes then
            for j = 1, root.game[10].seasons[3].dungeons[i].routes.size do
                root.game[10].seasons[3].dungeons[i].routes.items[j].routeItems = root.game[10].seasons[3].dungeons[i].routes.items[j].route;
                root.game[10].seasons[3].dungeons[i].routes.items[j].route = nil;

                -- step 3: rebuild the index map
                if not root.game[10].seasons[3].dungeons[i].routes.items[j].itemsIndexMap then
                    DM_RouteBuilder_RebuildRouteIndexMap(root.game[10].seasons[3].dungeons[i].routes.items[j]);
                end
            end
        end
    end
end

local function DM_RouteBuilder_DungeonHasRoutes(dungeonIndex)
    local r = DM_Data_RoutesRoot(dungeonIndex);

    return r and r.size > 0;
end

local function DM_RouteBuilder_DungeonRoutes(dungeonIndex)
    return DM_Data_RoutesRoot(dungeonIndex);
end

-- the 'items' here refers to the list of routes in the dungeon
local function DM_RouteBuilder_DungeonRoute(dungeonIndex, routeIndex)
    local r = DM_Data_RoutesRoot(dungeonIndex);

    if not r or routeIndex > r.size or routeIndex < 1 then
        return nil;
    end

    return r.items[routeIndex];
end

local function DM_RouteBuilder_DungeonRoutesCount(dungeonIndex)
    local r = DM_Data_RoutesRoot(dungeonIndex);

    if not r then
        return 0;
    end

    return r.size;
end

local function DM_RouteBuilder_ChangeLinkStatus(linkStatus, linkIconName)
    if uiContext.selectedRouteItem then
        uiContext.selectedRouteItem.linkStatus = linkStatus;

        DM_RouteBuilder_RefreshUi();
    end
end

local function DM_RouteBuilder_SetSelectedGroupPullChainStart()
    DM_RouteBuilder_ChangeLinkStatus(1, "CHAIN_LINKED_FLIPPED");
end

local function DM_RouteBuilder_SetSelectedGroupUnlinked()
    DM_RouteBuilder_ChangeLinkStatus(0, "CHAIN_UNLINKED");
end

local function DM_RouteBuilder_SetSelectedGroupLinked()
    DM_RouteBuilder_ChangeLinkStatus(2, "CHAIN_LINKED");
end

local function DM_RouteBuilder_AddRouteItemAnnotation(routeItem, annotationType)
    if not routeItem.annotations then
        routeItem.annotations = {};
    end

    routeItem.annotations[annotationType] = {msgIndex=0};
end

local function DM_RouteBuilder_AnnotateSelectedRouteItem(annotationType)
    if uiContext.selectedRouteItem then
       DM_RouteBuilder_AddRouteItemAnnotation(uiContext.selectedRouteItem, annotationType);

       DM_RouteBuilder_RefreshUi();
    end
end

local function DM_RouteBuilder_CycleAnnotationText(routeItem, annotationType)
    if not annotationType then
        return;
    end

    if not routeItemAnnotationsText[annotationType][routeItem.annotations[annotationType].msgIndex+1] then
        routeItem.annotations[annotationType].msgIndex = 0;
    else
        routeItem.annotations[annotationType].msgIndex = routeItem.annotations[annotationType].msgIndex + 1;
    end
end

------------------------------------------------------------------------------
-- Route item addition/removal/movement
------------------------------------------------------------------------------

function DM_RouteBuilder_SetMobGroupRouteItemIndex(route, areaKey, mobGroup, index)
    if not route.itemsIndexMap then
        route.itemsIndexMap = {};
    end

    if not route.itemsIndexMap.areas then
        route.itemsIndexMap.areas = {};
    end

    if not route.itemsIndexMap.areas[areaKey] then
        route.itemsIndexMap.areas[areaKey] = {};
    end

    if not route.itemsIndexMap.areas[areaKey].mobGroups then
        route.itemsIndexMap.areas[areaKey].mobGroups = {};
    end

    route.itemsIndexMap.areas[areaKey].mobGroups[mobGroup] = index;
end

-- this is adjusted, needs to take what was the route context now and not just the route items.
-- this means items index map is moved to the context and out of the route items table
function DM_RouteBuilder_RebuildRouteIndexMap(route)
    for i = 1, route.routeItems.size do
        local ri = route.routeItems.items[i];

        if ri.type == ROUTE_ITEM_TYPE_MOBGROUP then
            DM_RouteBuilder_SetMobGroupRouteItemIndex(route, ri.areaKey, ri.mobGroup, i);
        --elseif ri.type == ROUTE_ITEM_TYPE_ENVMARKER then
        --    DM_RouteBuilder_SetEnvMarkerRouteItemIndex(r, ri.areaKey, ri.envMarker, i);
        end
    end
end

-- this is adjusted, needs what was the route context now and not just the specific route items table
local function DM_RouteBuilder_GetRouteItemIndex_ByMarker(route, areaKey, marker)
    if not route or not route.itemsIndexMap
                 or not route.itemsIndexMap.areas
                 or not route.itemsIndexMap.areas[areaKey]
                 or not route.itemsIndexMap.areas[areaKey].mobGroups
                 or not route.itemsIndexMap.areas[areaKey].mobGroups[marker] then
        return nil;
    end

    if route.itemsIndexMap.areas[areaKey].mobGroups and route.itemsIndexMap.areas[areaKey].mobGroups[marker] then
        return route.itemsIndexMap.areas[areaKey].mobGroups[marker];
    --elseif route.itemsIndexMap.areas[areaKey].envMarkers and route.itemsIndexMap.areas[areaKey].envMarkers[marker] then
    --    return route.itemsIndexMap.areas[areaKey].envMarkers[marker];
    end

    return nil;
end

local function DM_RouteBuilder_RouteContainsMobGroup(route, areaKey, mobGroup)
    return DM_RouteBuilder_GetRouteItemIndex_ByMarker(route, areaKey, mobGroup) ~= nil;
end

local function DM_RouteBuilder_CreateNewRouteItem(areaKey, mobGroup)
    return { areaKey=areaKey, mobGroup=mobGroup, linkStatus=0, 
             note={text="", promote=false},
             type = ROUTE_ITEM_TYPE_MOBGROUP };
end

local function DM_RouteBuilder_AddMobGroupToEndOfRoute(route, areaKey, mobGroup)
    route.routeItems.size = route.routeItems.size + 1;

    route.routeItems.items[route.routeItems.size] = DM_RouteBuilder_CreateNewRouteItem(areaKey, mobGroup);

    DM_RouteBuilder_SetMobGroupRouteItemIndex(route, areaKey, mobGroup, route.routeItems.size);
end

local function DM_RouteBuilder_AddMobGroupBeneathRouteItem(topRouteItem, route, areaKey, mobGroup)
    local index = DM_RouteBuilder_GetRouteItemIndex_ByMarker(route, topRouteItem.areaKey, topRouteItem.mobGroup);

    if not index then
        DM_Util_PrintSystemMessage("ERROR: AddMobGroupBeneathRouteItem does not have valid index for selected route item");
        return;
    end

    local routeItems = route.routeItems;

    local itemsToMoveDown = routeItems.size - index;

    routeItems.size = routeItems.size + 1;

    for i = 1, itemsToMoveDown do
        local s = routeItems.size - i;

        routeItems.items[s+1] = routeItems.items[s];
    end

    route.routeItems.items[index+1] = DM_RouteBuilder_CreateNewRouteItem(areaKey, mobGroup);

    DM_RouteBuilder_RebuildRouteIndexMap(route);
end

local function DM_RouteBuilder_RenumberRoute(route)
    local routeItems = route.routeItems;

    if not route or not routeItems or not routeItems.items then
        return;
    end

    local nextNumber = 1;

    for i = 1, routeItems.size do
        -- future todo: this will need to account for other map marker types
        if routeItems.items[i].type == ROUTE_ITEM_TYPE_MOBGROUP then
            routeItems.items[i].pullNumber = nextNumber;
            nextNumber = nextNumber + 1;
        end
    end
end

local function DM_RouteBuilder_FindIndexForMobGroup(route, areaKey, mobGroup)
    local routeItems = route.routeItems;

    if not route or not routeItems then
        return nil;
    end

    for i = 1, routeItems.size do
        if     routeItems.items[i].type == ROUTE_ITEM_TYPE_MOBGROUP
           and routeItems.items[i].areaKey == areaKey
           and routeItems.items[i].mobGroup == mobGroup then
              return i;
        end
    end

    return nil;
end

-- todo: should use the items index map
-- todo: need to move up to make this 'local'
function DM_RouteBuilder_GetRouteItemByPullGroup(route, areaKey, mobGroup)
    if not route or not route.routeItems then
        return nil;
    end

    return route.routeItems.items[DM_RouteBuilder_FindIndexForMobGroup(route, areaKey, mobGroup)];
end

local function DM_RouteBuilder_GetAnnotation(route, areaKey, mobGroup)
    local ri = DM_RouteBuilder_GetRouteItemByPullGroup(route, areaKey, mobGroup);

    if ri and ri.pullNumber then
        return tostring(ri.pullNumber);
    end

    return "";
end

local function DM_RouteBuilder_CreateAndSelectNewRoute(includeUiRefresh)
    local dungeonCtx = uiContext.currentDungeonContext;

    local routeAuthor = UnitFullName("player")[1] or UnitName("player");

    uiContext.routes.size = uiContext.routes.size + 1;
    uiContext.routes.items[uiContext.routes.size] = { name = "New Route " .. tostring(uiContext.routes.size),
                                                      gameVersion = CURRENT_GAME_VERSION, season = CURRENT_SEASON,
                                                      zoneId = dungeonCtx.zoneId,
                                                      zoneDiscriminator = dungeonCtx.zoneDiscriminator,
                                                      author = routeAuthor,
                                                      isDefault = false, isTyr = false, isFort = false,
                                                      itemsIndexMap={},
                                                      routeItems={size=0, items={}}
                                                    };

    uiContext.currentRouteIndex = uiContext.routes.size;
    uiContext.currentRoute = uiContext.routes.items[uiContext.routes.size];

    if includeUiRefresh then
        DM_RouteBuilder_RefreshUi();
    end
end

local function DM_RouteBuilder_AddMobGroupToRoute(route, areaKey, mobGroup)
    local dungeonIndex = uiContext.currentDungeonIndex;

    if not route then
        DM_RouteBuilder_CreateAndSelectNewRoute();

        uiContext.currentRoute = uiContext.routes.items[1];
        uiContext.currentRouteIndex = 1;

        route = uiContext.currentRoute;
    end

    local existingIndex = DM_RouteBuilder_FindIndexForMobGroup(uiContext.currentRoute, areaKey, mobGroup);

    if existingIndex then
        -- not treating this as an error
        -- DM_Util_PrintSystemMessage("ERROR: group already exists in route: " .. tostring(areaKey) .. ", " .. tostring(mobGroup));
        return;
    end

    local selectedRouteItem = nil;

    if route.selectedAreaKey and route.selectedMobGroup then
        selectedRouteItem = DM_RouteBuilder_GetRouteItemByPullGroup(route, 
                                                                    route.selectedAreaKey, 
                                                                    route.selectedMobGroup);
    end

    if selectedRouteItem then
        DM_RouteBuilder_AddMobGroupBeneathRouteItem(selectedRouteItem, route, areaKey, mobGroup);
    else
        DM_RouteBuilder_AddMobGroupToEndOfRoute(route, areaKey, mobGroup);
    end

    DM_RouteBuilder_RenumberRoute(route);
    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_RemoveMobGroupFromRoute(areaKey, mobGroup)
    local route = uiContext.currentRoute;
    local routeItems = route.routeItems;

    local index = DM_RouteBuilder_FindIndexForMobGroup(route, areaKey, mobGroup);

    if index == nil then
        DM_Util_PrintSystemMessage("ERROR: entry does not exist in route for " .. tostring(areaKey) .. ", " .. tostring(mobGroup));
        return;
    end

    if index then
         for i = index, routeItems.size - 1 do
            routeItems.items[i] = routeItems.items[i+1];
            route.itemsIndexMap.areas[routeItems.items[i].areaKey].mobGroups[routeItems.items[i].mobGroup] = i;
         end

         routeItems.size = routeItems.size - 1;
         route.itemsIndexMap.areas[areaKey].mobGroups[mobGroup] = nil;

         DM_RouteBuilder_RenumberRoute(route);
         DM_RouteBuilder_RefreshUi();
    end
end

local function DM_RouteBuilder_DeleteRouteConfirmed()
    local routes = uiContext.routes;

    if routes.size == 0 then
        return;
    end

    for i = uiContext.currentRouteIndex, routes.size do
        routes.items[i] = routes.items[i+1];
    end

    routes.size = routes.size - 1;

    if routes.size == 0 then
        -- if we deleted all routes, clear our bookkeeping
        uiContext.currentRouteIndex = nil;
        uiContext.currentRoute = nil;
    elseif uiContext.currentRouteIndex > routes.size then
        -- if we're 1 beyond the end of the routes, shift back 1 to a valid route
        uiContext.currentRouteIndex = uiContext.currentRouteIndex - 1;
        uiContext.currentRoute = routes.items[uiContext.currentRouteIndex];
    else
        -- otherwise we're deleting in the top/middle so we'll just maintain the old currentRouteIndex
        uiContext.currentRoute = routes.items[uiContext.currentRouteIndex];
    end

    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_DeleteCurrentRoute()
    if not uiContext.currentRouteIndex then
        print("DM_RouteBuilder_DeleteCurrentRoute: ERROR - no route index available, cannot delete");
        return;
    end

    DM_RouteBuilder_ShowConfirmDialog("Confirm Route Deletion", DM_RouteBuilder_DeleteRouteConfirmed);
end

function DM_RouteBuilder_ClearRouteConfirmed()
    if not uiContext.currentRoute then
        return;
    end

    uiContext.currentRoute.routeItems = {size=0, items={}};
    uiContext.currentRoute.itemsIndexMap = {};
    uiContext.currentRoute.selectedAreaKey = nil;
    uiContext.currentRoute.selectedMobGroup = nil;
    uiContext.selectedRouteItem = nil;
    uiContext.selectedMapMobMarker = nil;
    uiContext.mapMobMarkers = {};

    DM_RouteBuilder_RefreshUi();
end

-- does this duplicate DM_RouteBuilder_SetMobGroupRouteItemIndex?
local function DM_RouteBuilder_SetRouteItemIndex(route, routeItem, index)
    local originalIndex = nil;

    if routeItem.mobGroup then
        originalIndex = route.itemsIndexMap.areas[routeItem.areaKey].mobGroups[routeItem.mobGroup];
        route.itemsIndexMap.areas[routeItem.areaKey].mobGroups[routeItem.mobGroup] = index;
    elseif routeItem.envMarker then
        originalIndex = route.itemsIndexMap.areas[routeItem.areaKey].envMarkers[routeItem.envMarker];
        route.itemsIndexMap.areas[routeItem.areaKey].envMarkers[routeItem.envMarker] = index;
    else
        originalIndex = route.itemsIndexMap.other[routeItem.type][routeItem.key];
        route.itemsIndexMap.other[routeItem.type][routeItem.key] = index;
    end

    return originalIndex;
end

local function DM_RouteBuilder_ShiftRouteItemUp(route, index)
    local routeItems = route.routeItems;

    local topItem = routeItems.items[index-1];
    local movingItem = routeItems.items[index];

    DM_RouteBuilder_SetRouteItemIndex(route, movingItem, index-1);
    DM_RouteBuilder_SetRouteItemIndex(route, topItem, index);

    routeItems.items[index-1] = movingItem;
    routeItems.items[index] = topItem;

    DM_RouteBuilder_RenumberRoute(route);
end

local function DM_RouteBuilder_MoveRouteItemUpByIndex(index)
    if index == 1 then
        return;
    end

    DM_RouteBuilder_ShiftRouteItemUp(uiContext.currentRoute, index);
    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_MoveRouteItemUp(routeItem)
    local index = DM_RouteBuilder_GetRouteItemIndex_ByMarker(uiContext.currentRoute, routeItem.areaKey, routeItem.mobGroup);

    if index == nil then
        return;
    end

    DM_RouteBuilder_MoveRouteItemUpByIndex(index);
end

local function DM_RouteBuilder_MoveRouteItemDownByIndex(index)
    local route = uiContext.currentRoute;
    local routeItems = uiContext.currentRoute.routeItems;

    if index == routeItems.size then
        return;
    end

    local g1 = routeItems.items[index+1];
    local g2 = routeItems.items[index];

    DM_RouteBuilder_SetRouteItemIndex(route, g2, index+1);
    DM_RouteBuilder_SetRouteItemIndex(route, g1, index);

    routeItems.items[index+1] = g2;
    routeItems.items[index] = g1;

    DM_RouteBuilder_RenumberRoute(route);
    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_MoveRouteItemDown(routeItem)
    local index = DM_RouteBuilder_GetRouteItemIndex_ByMarker(uiContext.currentRoute, routeItem.areaKey, routeItem.mobGroup);

    if index == nil then
        return;
    end

    DM_RouteBuilder_MoveRouteItemDownByIndex(index);
end

------------------------------------------------------------------------------
-- Main UI Logic
------------------------------------------------------------------------------

local function DM_RouteBuilder_DropDown_RouteSelected(self, routeIndex, arg2, checked)
    local dungeonIndex = uiContext.currentDungeonIndex;

    uiContext.currentRouteIndex = routeIndex;
    uiContext.currentRoute = uiContext.routes.items[uiContext.currentRouteIndex];

    DM_RouteBuilder_DungeonSpecificContext(uiContext.currentDungeonIndex).selectedRouteIndex = uiContext.currentRouteIndex;

    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_RefreshRoutesDropdown()
    if not uiContext.currentDungeonIndex or not DM_RouteBuilder_DungeonHasRoutes(uiContext.currentDungeonIndex) then
        UIDropDownMenu_SetText(ui.dropdowns.routes, "(No Routes)");
         UIDropDownMenu_Initialize(ui.dropdowns.routes, function(self, level, menuList) end);
         return;
    end

    local routes = uiContext.routes;

    UIDropDownMenu_Initialize(ui.dropdowns.routes, 
        function(self, level, menuList)
            for i = 1, routes.size do
                local info = UIDropDownMenu_CreateInfo();
                info.text, info.hasArrow, info.arg1, info.func = routes.items[i].name, nil, i, DM_RouteBuilder_DropDown_RouteSelected;
                UIDropDownMenu_AddButton(info);
            end
        end);

    if uiContext.currentRouteIndex then
        UIDropDownMenu_SetSelectedID(ui.dropdowns.routes, uiContext.currentRouteIndex);
    else
        UIDropDownMenu_SetSelectedID(ui.dropdowns.routes, nil);
    end

    if uiContext.currentRoute then
        UIDropDownMenu_SetText(ui.dropdowns.routes, uiContext.currentRoute.name);
    else
        UIDropDownMenu_SetText(ui.dropdowns.routes, "(No Current Route)");
    end
end

local function DM_RouteBuilder_ShowMapMobMarkerTooltip(frameOwner, areaKey, mobGroup)
    local dungeonCtx = uiContext.currentDungeonContext;
    local area = dungeonCtx.areas[areaKey];

    GameTooltip:SetOwner(frameOwner, "ANCHOR_RIGHT");
    GameTooltip:ClearLines();

    GameTooltip:AddLine("Area: " .. tostring(area.name));
    GameTooltip:AddLine("Group " .. mobGroup .. ": " .. DM_RouteBuilder_GetTotalForcesForMobGroup(areaKey, mobGroup) .. " Forces");

    local forceList = DM_RouteBuilder_GetForceList(dungeonCtx, areaKey, mobGroup);

    if not forceList then
        return;
    end

    for i = 1, forceList.size do
        GameTooltip:AddLine(forceList.items[i]);
    end

    local dungeonNote = DM_Data_Dungeon_GetNoteForMobGroup(uiContext.currentDungeonIndex, areaKey, mobGroup);

    GameTooltip:AddLine(" ");
    if dungeonNote and string.len(dungeonNote) > 0 then
        GameTooltip:AddLine(DM_Data_Dungeon_GetNoteForMobGroup(uiContext.currentDungeonIndex, areaKey, mobGroup));
    else
        GameTooltip:AddLine("Right click to add dungeon note for group");
    end

    GameTooltip:Show();
end

local nextMapAnnotationIndex = 1;

-- we'll create a single marker texture for each area key/mob group since they are
-- reused across dungeons. not sure what this optimization is worth but since
-- there's so many textures potentially being created and disposed i feel better with this here
function DM_RouteBuilder_GetOrCreateMapMobMarker(rootFrame, areaIndex, areaKey, mobGroup)
    if not uiContext.mapMobMarkers then
        uiContext.mapMobMarkers = {};
    end

    if not uiContext.mapMobMarkers.areas then
        uiContext.mapMobMarkers.areas = {};
    end

    if not uiContext.mapMobMarkers.areas[areaKey] then
        uiContext.mapMobMarkers.areas[areaKey] = {mobGroups={}};
    end

    if not uiContext.mapMobMarkers.areas[areaKey].mobGroups[mobGroup] then
        local m = DM_Tex_CreateMapPullGroupIcon(rootFrame, areaIndex, mobGroup);

        uiContext.mapMobMarkers.areas[areaKey].mobGroups[mobGroup] = m;

        m:EnableMouse(true);
        -- m.isSelected = 0;
        m.mobGroup = mobGroup;
        m.areaKey = areaKey;

        m.mapAnnotation = rootFrame:CreateFontString("DM_MapAnnotation_" .. tostring(nextMapAnnotationIndex), "OVERLAY", "GameFontNormalLarge");
        m.mapAnnotation:SetText("");
        m.mapAnnotation:SetHeight(10);
        m.mapAnnotation:SetPoint("CENTER", m, "CENTER", 4, -4);
        DM_Colors_SetTextColor(m.mapAnnotation, COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_TEXT);
        nextMapAnnotationIndex = nextMapAnnotationIndex + 1;

        local rootScale = ui.routeBuilderRootFrame:GetScale();
        m:SetWidth(MAP_MARKER_NORMAL_SIZE * rootScale);
        m:SetHeight(MAP_MARKER_NORMAL_SIZE * rootScale);

        m:SetScript("OnEnter", function(self)
            local rootScale = ui.routeBuilderRootFrame:GetScale();
            self:SetWidth(MAP_MARKER_ZOOMED_SIZE * rootScale);
            self:SetHeight(MAP_MARKER_ZOOMED_SIZE * rootScale);
            self.isMousedOver = true;
            DM_RouteBuilder_ShowMapMobMarkerTooltip(self, self.areaKey, self.mobGroup);
        end);

        m:SetScript("OnLeave", function(self)
            local rootScale = ui.routeBuilderRootFrame:GetScale();
            self:SetWidth(MAP_MARKER_NORMAL_SIZE * rootScale);
            self:SetHeight(MAP_MARKER_NORMAL_SIZE * rootScale);
            self.isMousedOver = false;
            GameTooltip:Hide();
        end);

        m:SetScript("OnMouseUp", function(self, button)

            if button == "LeftButton" then
                local existingIndex = DM_RouteBuilder_FindIndexForMobGroup(self.areaKey, self.mobGroup);
                if not existingIndex then
                    DM_RouteBuilder_AddMobGroupToRoute(uiContext.currentRoute, self.areaKey, self.mobGroup);
                    DM_RouteBuilder_RefreshUi();
                else
                    -- we're purposely not letting a 2nd click remove the group from the route,
                    -- as this potentially is a degraded user experience if they accidentally click
                    -- on a group marker. we instead move the "remove" intention to the side which is
                    -- a far better context for the user to state their intention anyhow (good suggestion shadow)
                end
            end
    
            if button == "RightButton" then
                DM_RouteBuilder_StartEditDungeonNote(self.areaKey, self.mobGroup);
            end
        end);
    end

    return uiContext.mapMobMarkers.areas[areaKey].mobGroups[mobGroup];
end

local function DM_RouteBuilder_TrackDrawnMapMobMarker(areaKey, mobGroup, marker)
    if not uiDrawnContext.mapMobMarkers then
        uiDrawnContext.mapMobMarkers = {};
    end

    if not uiDrawnContext.mapMobMarkers.areas then
        uiDrawnContext.mapMobMarkers.areas = {};
    end

    if not uiDrawnContext.mapMobMarkers.areas[areaKey] then
        uiDrawnContext.mapMobMarkers.areas[areaKey] = {};
    end

    if not uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups then
        uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups = {};
    end

    uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups[mobGroup] = marker;
end

-- This function's purpose in life is to assign a map mob marker an x,y position
local function DM_RouteBuilder_DrawMapMobGroupMarker(dungeonCtx, areaKey, mobGroup)
    local pullGroup = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup];

    local position = pullGroup.metadata.position;

    if not position then
        return;
    end

    local nx = position.x / dungeonCtx.config.SOURCE_MAP_WIDTH;
    local ny = position.y / dungeonCtx.config.SOURCE_MAP_HEIGHT;

    local mapMobGroupMarker = DM_RouteBuilder_GetOrCreateMapMobMarker(ui.routeBuilderMapPanelFrame, dungeonCtx.areas[areaKey].areaIndex, areaKey, mobGroup);
    local size = 12;

    local objectDrawLayer = mapDrawLayer;
    local drawLayer = 7;

    local rootScale = ui.routeBuilderRootFrame:GetScale();

    mapMobGroupMarker:SetWidth(16 * rootScale);
    mapMobGroupMarker:SetHeight(16 * rootScale);
    mapMobGroupMarker:Show();
    mapMobGroupMarker:ClearAllPoints();

    local mainFrameWidth, mainFrameHeight = ui.routeBuilderRootFrame:GetSize();
    local px = nx * ui.routeBuilderMapPanelFrame:GetWidth() + (rootScale*8);
    local py = ny * ui.routeBuilderMapPanelFrame:GetHeight() + (rootScale*4);

    mapMobGroupMarker:SetPoint("CENTER", ui.routeBuilderMapRootFrame, "TOPLEFT", px + dungeonCtx.config.xOffset, py * -1 + dungeonCtx.config.yOffset);

    mapMobGroupMarker.px = px + dungeonCtx.config.xOffset;
    mapMobGroupMarker.py = py * -1 + dungeonCtx.config.yOffset;

    if not mapMobGroupMarker.selectionBox then
        mapMobGroupMarker.selectionBox = DM_Tex_CreateRouteBuilderIcon(ui.routeBuilderMapPanelFrame, "BOX", 32, 32, "OVERLAY");
        mapMobGroupMarker.selectionBox:ClearAllPoints();
        DM_Colors_SetIconColor(mapMobGroupMarker.selectionBox, COLOR_KEY_ROUTEBUILDER_STATUSBAR_SELECTED);
    end

    mapMobGroupMarker.selectionBox:SetShown(false);
    mapMobGroupMarker.selectionBox:SetPoint("TOPLEFT", mapMobGroupMarker, "TOPLEFT", -6, 6);
    mapMobGroupMarker.selectionBox:SetPoint("BOTTOMRIGHT", mapMobGroupMarker, "BOTTOMRIGHT", 6, -6);

    if not mapMobGroupMarker.linkedGroupBox then
        mapMobGroupMarker.linkedGroupBox = DM_Tex_CreateRouteBuilderIcon(ui.routeBuilderMapPanelFrame, "DIAMOND", 32, 32, "OVERLAY");
        mapMobGroupMarker.linkedGroupBox:ClearAllPoints();
        DM_Colors_SetIconColor(mapMobGroupMarker.linkedGroupBox, COLOR_KEY_PULLTRACKER_LINKEDPULLSTART);
    end

    mapMobGroupMarker.linkedGroupBox:SetShown(false);
    mapMobGroupMarker.linkedGroupBox:SetPoint("TOPLEFT", mapMobGroupMarker, "TOPLEFT", -12, 12);
    mapMobGroupMarker.linkedGroupBox:SetPoint("BOTTOMRIGHT", mapMobGroupMarker, "BOTTOMRIGHT", 12, -12);

    DM_RouteBuilder_TrackDrawnMapMobMarker(areaKey, mobGroup, mapMobGroupMarker);
end

function DM_RouteBuilder_DrawMapAreaMobMarkers(dungeonCtx, areaKey, pullGroups)
    for mobGroup, mobGroupDetails in pairs(pullGroups) do
        DM_RouteBuilder_DrawMapMobGroupMarker(dungeonCtx, areaKey, mobGroup);
    end
end

local function DM_RouteBuilder_RefreshMapMobMarkerState()
    if uiDrawnContext.mapMobMarkers then
        for areaKey, area in pairs(uiDrawnContext.mapMobMarkers.areas) do
            for mobGroup, marker in pairs(uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups) do
                marker:Show();

                if uiContext.currentRoute and DM_RouteBuilder_RouteContainsMobGroup(uiContext.currentRoute, areaKey, mobGroup) then
                    DM_Tex_SetPullGroupIconHighlighted(marker);
                else
                    DM_Tex_SetPullGroupIconNormal(marker);
                end

                if DM_RouteBuilder_IsPullGroupSelected(areaKey, mobGroup) then
                    marker.selectionBox:SetShown(true);
                else
                    marker.selectionBox:SetShown(false);
                end

                if DM_RouteBuilder_Map_MapAnnotationsEnabled() then
                    local annotationText = DM_RouteBuilder_GetAnnotation(uiContext.currentRoute, areaKey, mobGroup);
                    marker.mapAnnotation:SetText(annotationText);
                    marker.mapAnnotation:SetShown(true);
                else
                    marker.mapAnnotation:SetText("");
                    marker.mapAnnotation:SetShown(false);
                end
            end
        end
    end
end

function DM_RouteBuilder_DrawMapMobMarkers()
    if not uiContext.currentDungeonContext then
        DM_Util_PrintSystemMessage("DM_RouteBuilder_DrawMapMobMarkers no current dungeon context");
        return;
    end

    local dungeonCtx = uiContext.currentDungeonContext;

    uiDrawnContext.mapMobMarkers = {size=0, items={}};

    for nextAreaIndex = 0, dungeonCtx.areaCount do
        local areaKey = "area#" .. tostring(nextAreaIndex);
        local a = dungeonCtx.areas[areaKey];

        if a and a.floorIndex == uiContext.currentFloorIndex then
            DM_RouteBuilder_DrawMapAreaMobMarkers(dungeonCtx, areaKey, dungeonCtx.mapMarkers.areas[areaKey].pullGroups);
            -- env. markers aren't needed for season 3 but will be added back in for future, they'll cover
            -- elements like item buffs in court of stars or chains in neltharus
            --
            -- DM_RouteBuilder_DrawMapAreaEnvMarkers(ctx, a, ctx.mapMarkers.areas[areaKey].envMarkers);
        end
    end
end

function DM_RouteBuilder_RefreshMapMarkers()
    if uiDrawnContext.selectedMapMobMarker then
        uiDrawnContext.selectedMapMobMarker.selectionBox:SetShown(false);
    end

    if uiDrawnContext.mapMobMarkers then
        for areaKey, area in pairs(uiDrawnContext.mapMobMarkers.areas) do
            for mobGroup, marker in pairs(uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups) do
                DM_Tex_SetPullGroupIconNormal(marker);
                marker.selectionBox:SetShown(false);
                marker:Hide();
                if marker.mapAnnotation then
                    marker.mapAnnotation:SetShown(false);
                end
            end
        end
    end

    DM_RouteBuilder_DrawMapMobMarkers();

    DM_RouteBuilder_RefreshMapMobMarkerState();
end

function DM_RouteBuilder_GetForceList(dungeonCtx, areaKey, mobGroup)
    if not dungeonCtx then
        print("DM_RouteBuilder_GetForceList: ERROR - dungeon context is nil");
        return;
    end

    local forceList = { size = 0, items = {} };

    local g = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup];

    if g == nil then
        DM_Util_PrintSystemMessage("DM_RouteBuilder_GetForceList: ERROR - pullGroups is invalid, area/mob group likely do not match current dungeon, check route bookkeeping");
        return nil;
    end

    for mobIndex, mobCount in pairs(g.mobs) do
        local npc = dungeonCtx.npcs.items[mobIndex];

        for i = 1, mobCount do
            forceList.size = forceList.size+1;
            forceList.items[forceList.size] = npc.name .. " (" .. tostring(npc.forceCount) .. ")";
        end
    end

    -- if we have any mutually exclusive mobs (e.g. darkheart thicket, packs will have a ruiner or a poisoner randomly)
    -- then add them here
    if g.mutexMobs then
        for i = 1, g.mutexMobs.size do
            local npc1 = dungeonCtx.npcs.items[g.mutexMobs.items[i].option1];
            local npc2 = dungeonCtx.npcs.items[g.mutexMobs.items[i].option2];

            -- force count should always be equal between these two NPCs or it doesn't make sense
            -- for blizzard to randomly spawn them. add a validation check here

            forceList.size = forceList.size+1;
            forceList.items[forceList.size] = g.mutexMobs.items[i].display .. " (" .. tostring(npc1.forceCount) .. ")";
        end
    end

    return forceList;
end

function DM_RouteBuilder_SetTextLineIndent(textLine, indentLevel)
    local indentOffset = (indentLevel or 0) * 20;
    local relativeUiElement = textLine.parent.StatusBar;

    textLine:SetPoint("TOPLEFT", relativeUiElement, "TOPLEFT", 2 + indentOffset, -2);
end

function DM_RouteBuilder_HideTextLineHeaderUiElements(textLine)
    for i = 1, textLine.headerUiElements.size do
        if textLine.headerUiElements.items[i] then
            textLine.headerUiElements.items[i]:Hide();
        end
    end
end

function DM_RouteBuilder_ShowTextLineHeaderUiElements(textLine)
    for i = 1, textLine.headerUiElements.size do
        if textLine.headerUiElements.items[i] then
            textLine.headerUiElements.items[i]:Show();
        end
    end
end

function DM_RouteBuilder_GetTotalForcesForMobGroup(areaKey, mobGroup)
    local dungeonCtx = uiContext.currentDungeonContext;
    local g = dungeonCtx.mapMarkers.areas[areaKey].pullGroups[mobGroup];

    if g == nil then
        return 0;
    end

    local total = 0;

    for mobIndex, mobCount in pairs(g.mobs) do
        local f = dungeonCtx.npcs.items[mobIndex].forceCount;

        total = total + mobCount * f;
    end

    return total;
end

function DM_RouteBuilder_UpdateUiForceStrings()
    local ctx = uiContext.currentDungeonContext;
    local requiredCount = ctx.requiredForceCount;
    local plannedCount = 0;

    local route = uiContext.currentRoute;

    if route then
        local r = route.routeItems;

        for i = 1, r.size do
            local mobGroup = r.items[i].mobGroup;
            local areaKey = r.items[i].areaKey;

            -- todo: add check here for route item type so it's scoped to headers?

            if mobGroup and areaKey then
               local count = DM_RouteBuilder_GetTotalForcesForMobGroup(areaKey, mobGroup);
               plannedCount = plannedCount + count;
            end
        end
    end

    local c = "|c" .. DM_Colors_GetColorString(COLOR_KEY_GENERAL_LOW);

    -- if we're within 10% of required, we'll color it yellow/medium
    if plannedCount < requiredCount and plannedCount >= (requiredCount * 0.9) then
       c = "|c" .. DM_Colors_GetColorString(COLOR_KEY_GENERAL_MEDIUM);
    elseif plannedCount >= requiredCount then
       c = "|c" .. DM_Colors_GetColorString(COLOR_KEY_GENERAL_HIGH);
    end

    if plannedCount == 0 then
        ui.sidePanelUiForcesString:SetText(c .. plannedCount .. "|r/" .. requiredCount);
    else
        ui.sidePanelUiForcesString:SetText(c .. plannedCount .. "|r/" .. requiredCount .. " (" .. (ctx.totalForceCount - plannedCount) .. " free)");
    end
end

local function DM_RouteBuilder_EnsurePullLineExists(index)
    if index == ui.sidePanelTextLines.size + 1 then
        ui.sidePanelTextLines.size = ui.sidePanelTextLines.size + 1;

        ui.sidePanelTextLines.items[ui.sidePanelTextLines.size] = 
                DM_RouteBuilder_CreatePullLine(ui.sidePanelTextLines.size,
                                               "DM_RouteBuilder_PullLine" .. tostring(ui.sidePanelTextLines.size),
                                               {marginEnabled=0}, 280-24, "");
    elseif index > ui.sidePanelTextLines.size then
        DM_Util_PrintSystemMessage("ERROR: DM_RouteBuilder_EnsurePullLineExists, allocated=" .. tostring(ui.sidePanelTextLines.size) .. ", requesting=" .. tostring(index) .. ", out of bounds");
    end
end

-- This function ensures side panel pull line exists if it doesn't already.
-- Pull line indexes greater than 1 beyond the end will result in an error,
-- as the contract here is to grow the pull line display one line at a time.
-- This is a resource usage guard.
local function DM_RouteBuilder_GetPullLine(index)
    DM_RouteBuilder_EnsurePullLineExists(index);

    return ui.sidePanelTextLines.items[index];
end

function DM_RouteBuilder_RefreshPullGroupsDisplay()
    local route = uiContext.currentRoute;

    if not route then
        for i = 1, ui.sidePanelTextLines.size do
            ui.sidePanelTextLines.items[i]:Hide();
        end

        return;
    end

    local routeItems = route.routeItems;

    local lineIndex = 1;

    local savedsidePanelDisplayedTextLineCount = uiContext.sidePanelDisplayedTextLineCount;
    uiContext.sidePanelDisplayedTextLineCount = 0;

    local previousAreaKey = nil;
    local dungeonCtx = uiContext.currentDungeonContext;

    DM_RouteBuilder_RenumberRoute(route);

    for i = 1, routeItems.size do
        local routeItem = routeItems.items[i];

        local areaKey = routeItem.areaKey;
        local mobGroup = routeItem.mobGroup;

        -- CASE #1: we're transitioning to a new area, so place an area header
        if areaKey and areaKey ~= previousAreaKey then
            local areaHeaderLine = DM_RouteBuilder_GetPullLine(lineIndex);

            areaHeaderLine.MainColumnText:SetText("AREA: " .. dungeonCtx.areas[areaKey].name);
            areaHeaderLine.MainColumnText:SetFontObject("GameFontHighlightLarge");
            areaHeaderLine.routeItem = routeItem;
            areaHeaderLine.isAreaHeader = true;
            areaHeaderLine.header = false;
            areaHeaderLine.annotationType = nil;
            DM_Colors_SetTextColor(areaHeaderLine.MainColumnText, COLOR_KEY_GENERAL_HEADER_TEXT);

            DM_RouteBuilder_SetTextLineIndent(areaHeaderLine.MainColumnText, 0);
            DM_RouteBuilder_HideTextLineHeaderUiElements(areaHeaderLine);

            areaHeaderLine.rightArrowIcon:Hide();

            DM_Colors_SetStatusBarColor(areaHeaderLine.StatusBar, COLOR_KEY_ROUTEBUILDER_STATUSBAR_NORMAL);
            areaHeaderLine.StatusBar:SetValue(0);

            areaHeaderLine:Show();

            lineIndex = lineIndex + 1;
            previousAreaKey = areaKey;

            uiContext.sidePanelDisplayedTextLineCount = uiContext.sidePanelDisplayedTextLineCount + 1;
        end

        -- CASE #2: not mutually exclusive with #1, here we add the pull group
        if routeItem.type == ROUTE_ITEM_TYPE_MOBGROUP then
            local pullNumber = routeItem.pullNumber;

            local mobGroupForces;

            mobGroupForces = DM_RouteBuilder_GetForceList(dungeonCtx, areaKey, mobGroup);

            if routeItem.annotations then
                for i = 1, ROUTE_ITEM_ANNOTATION_COUNT do
                    if routeItem.annotations[i] then
                        local a = routeItem.annotations[i];

                        local annotationLine = DM_RouteBuilder_GetPullLine(lineIndex);

                        annotationLine.MainColumnText:SetText(routeItemAnnotationsText[i][a.msgIndex]);

                        DM_RouteBuilder_SetTextLineIndent(annotationLine.MainColumnText, 0);
                        DM_RouteBuilder_HideTextLineHeaderUiElements(annotationLine);
                        annotationLine.linkIcon:Hide();
                        annotationLine.routeItem = routeItem;
                        annotationLine.isAreaHeader = false;
                        annotationLine.header = false;
                        annotationLine.annotationType = i;

                        DM_Colors_SetTextColor(annotationLine.MainColumnText, COLOR_KEY_GENERAL_ANNOTATION_TEXT);
                        annotationLine.MainColumnText:SetFontObject("GameFontHighlight");
                        annotationLine.MainColumnText:SetText(routeItemAnnotationsText[i][a.msgIndex]);
        
                        DM_Colors_SetStatusBarColor(annotationLine.StatusBar, COLOR_KEY_PULLTRACKER_ANNOTATION);
                        annotationLine.StatusBar:SetValue(0);

                        annotationLine.rightArrowIcon:Show();
                        annotationLine.removeIcon:Show();

                        annotationLine:Show();

                        lineIndex = lineIndex + 1;
                        uiContext.sidePanelDisplayedTextLineCount = uiContext.sidePanelDisplayedTextLineCount + 1;
                    end
                end
            end

            local headerLine = DM_RouteBuilder_GetPullLine(lineIndex);

            if DM_RouteBuilder_IsPullGroupSelected(areaKey, mobGroup) then
                DM_Colors_SetStatusBarColor(headerLine.StatusBar, COLOR_KEY_ROUTEBUILDER_STATUSBAR_SELECTED);
                headerLine.StatusBar:SetValue(100);
            else
                DM_Colors_SetStatusBarColor(headerLine.StatusBar, COLOR_KEY_ROUTEBUILDER_STATUSBAR_NORMAL);
                headerLine.StatusBar:SetValue(0);
            end

            local headerPrefix = "";

            if pullNumber then
                headerPrefix = tostring(pullNumber) .. " - ";
            end

            headerLine.MainColumnText:SetText(headerPrefix .. "GROUP " .. mobGroup .. " - " .. DM_RouteBuilder_GetTotalForcesForMobGroup(areaKey, mobGroup) .. " FORCES");
            headerLine.routeItem = routeItem;
            headerLine.header = true;
            headerLine.isAreaHeader = false;
            headerLine.MainColumnText:SetFontObject("GameFontHighlightSmall");
            DM_Colors_SetTextColor(headerLine.MainColumnText, COLOR_KEY_ROUTEBUILDER_GROUP_HEADER_TEXT);
            headerLine.rightArrowIcon:Hide();
            headerLine.annotationType = nil;
            DM_RouteBuilder_SetTextLineIndent(headerLine.MainColumnText, 2);
            headerLine:Show();
            DM_RouteBuilder_ShowTextLineHeaderUiElements(headerLine);
            lineIndex = lineIndex + 1;

            if routeItem.linkStatus == 0 then
                headerLine.linkIcon:Hide();
            else
                if routeItem.linkStatus == 1 then
                    DM_Tex_ChangeRouteBuilderIcon(headerLine.linkIcon, "CHAIN_LINKED_FLIPPED");
                elseif routeItem.linkStatus == 2 then
                    DM_Tex_ChangeRouteBuilderIcon(headerLine.linkIcon, "CHAIN_LINKED");
                end

                headerLine.linkIcon:Show();
            end

            for j = 1, mobGroupForces.size do
                local line = DM_RouteBuilder_GetPullLine(lineIndex);

                line.MainColumnText:SetText(mobGroupForces.items[j]);
                DM_RouteBuilder_SetTextLineIndent(line.MainColumnText, 3);
                DM_Colors_SetTextColor(line.MainColumnText, COLOR_KEY_ROUTEBUILDER_NORMAL_TEXT);
                line.MainColumnText:SetFontObject("GameFontHighlightSmall");
                line.header = false;
                line.isAreaHeader = false;
                line.annotationType = nil;
                line.rightArrowIcon:Hide();

                DM_Colors_SetStatusBarColor(line.StatusBar, COLOR_KEY_ROUTEBUILDER_UNSELECTED);
                line.StatusBar:SetValue(0);

                line:Show();
                line.routeItem = routeItem;
                DM_RouteBuilder_HideTextLineHeaderUiElements(line);
    
                lineIndex = lineIndex + 1;
            end

            -- 1 for header; forces size for rest
            uiContext.sidePanelDisplayedTextLineCount = uiContext.sidePanelDisplayedTextLineCount + mobGroupForces.size + 1;
        end
    end

    -- hide any overflow to account for a group removal
    if savedsidePanelDisplayedTextLineCount > uiContext.sidePanelDisplayedTextLineCount then
        for i = uiContext.sidePanelDisplayedTextLineCount + 1, savedsidePanelDisplayedTextLineCount do
            ui.sidePanelTextLines.items[i]:Hide();
        end
    end
end

-- This function is always safe to call. Worst case it becomes a no-op, medium case it
-- has no work to do and best case it fixes the zoom on the markers to match the zoom level
-- of rest of the window.
local function DM_RouteBuilder_ReapplyZoomToMapMobMarkers()
    if not uiDrawnContext.mapMobMarkers or not uiDrawnContext.mapMobMarkers.areas then
        return;
    end

    local rootScale = ui.routeBuilderRootFrame:GetScale();

    for areaKey, area in pairs(uiDrawnContext.mapMobMarkers.areas) do
        for mobGroup, marker in pairs(uiDrawnContext.mapMobMarkers.areas[areaKey].mobGroups) do
            if marker.isMousedOver then
                marker:SetWidth(MAP_MARKER_ZOOMED_SIZE * rootScale);
                marker:SetHeight(MAP_MARKER_ZOOMED_SIZE * rootScale);
            else
                marker:SetWidth(MAP_MARKER_NORMAL_SIZE * rootScale);
                marker:SetHeight(MAP_MARKER_NORMAL_SIZE * rootScale);
            end
        end
    end
end

local function DM_RouteBuilder_RefreshFloorsDropdown()
    if uiContext.currentDungeonContext and uiContext.currentDungeonContext.config.floorCount > 1 then
        UIDropDownMenu_Initialize(ui.dropdowns.dungeonFloor, 
            function(self, level, menuList)
                for i = 1, uiContext.currentDungeonContext.config.floorCount do
                   local info = UIDropDownMenu_CreateInfo();
                   info.text, info.hasArrow, info.arg1, info.func = uiContext.currentDungeonContext.config.floorMapInfo[i].name, nil, i, DM_RouteBuilder_DropDown_FloorSelected;
                   UIDropDownMenu_AddButton(info);
                end
            end);

        UIDropDownMenu_SetText(ui.dropdowns.dungeonFloor, uiContext.currentDungeonContext.config.floorMapInfo[1].name);
        UIDropDownMenu_SetSelectedID(ui.dropdowns.dungeonFloor, uiContext.currentFloorIndex);

        ui.dropdowns.dungeonFloor:Show();
    else
        ui.dropdowns.dungeonFloor:Hide();
    end
end

-- updates UI to match bookkeeping
function DM_RouteBuilder_RefreshUi()
    DM_RouteBuilder_RefreshRoutesDropdown();
    DM_RouteBuilder_ShowMap();
    DM_RouteBuilder_RefreshMapMarkers();
    DM_RouteBuilder_RefreshFloorsDropdown();
    DM_RouteBuilder_ReapplyZoomToMapMobMarkers();
    DM_RouteBuilder_RefreshPullGroupsDisplay();
    DM_RouteBuilder_UpdateUiForceStrings();
end

local function DM_RouteBuilder_DropDown_DungeonSelected(self, dungeonIndex, arg2, checked)
    if not dungeonIndex then
        return;
    end

    local dungeonContext = DM_Dungeons_GetCurrentSeasonContext().items[dungeonIndex];

    -- update bookkeeping first
    uiContext.currentDungeonContext = dungeonContext;
    uiContext.currentDungeonIndex = dungeonIndex;

    if uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex] and uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex].selectedFloor then
        uiContext.currentFloorIndex = uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex].selectedFloor;
    else
        uiContext.currentFloorIndex = 1;
    end

    uiContext.routes = DM_RouteBuilder_DungeonRoutes(uiContext.currentDungeonIndex);

    if DM_RouteBuilder_DungeonHasRoutes(uiContext.currentDungeonIndex) then
        if uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex] and uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex].selectedRouteIndex then
            uiContext.currentRouteIndex = uiContext.dungeonSpecificContext[uiContext.currentDungeonIndex].selectedRouteIndex;
        else
            uiContext.currentRouteIndex = 1;
        end

        uiContext.currentRoute = DM_RouteBuilder_DungeonRoute(uiContext.currentDungeonIndex, uiContext.currentRouteIndex);
    else
        uiContext.currentRouteIndex = nil;
        uiContext.currentRoute = nil;
    end

    -- set the dropdown
    UIDropDownMenu_SetSelectedID(ui.dropdowns.dungeon, uiContext.currentDungeonIndex);

    -- refresh full UI
    DM_RouteBuilder_RefreshUi();
end

function DM_RouteBuilder_DropDown_FloorSelected(self, floorIndex, arg2, checked)
    DM_Data_DungeonSpecificData(uiContext.currentDungeonIndex).selectedFloor = floorIndex;

    uiContext.currentFloorIndex = floorIndex;

    UIDropDownMenu_SetSelectedID(ui.dropdowns.dungeonFloor, floorIndex);

    DM_RouteBuilder_RefreshUi();
end

local function DM_RouteBuilder_Map_HideAnnotations()
end

local function DM_RouteBuilder_Map_ShowPullNumberAnnotations()
end

local function DM_RouteBuilder_ResetUi()
end

function DM_RouteBuilder_ShowMap()
    if not uiContext.currentDungeonContext then
        DM_Util_PrintSystemMessage("ERROR: Route builder UI not initialized");
        return;
    end

    local mapFolder = uiContext.currentDungeonContext.config.floorMapInfo[uiContext.currentFloorIndex].mapFolder;
    local mapName = uiContext.currentDungeonContext.config.floorMapInfo[uiContext.currentFloorIndex].mapTilePrefix;

    if mapFolder then
        uiContext.mapFolder = mapFolder;
        uiContext.mapTilePrefix = mapName;
    end

    local fileName = mapFolder;

    if mapName ~= nil then
        fileName = mapName;
    end

    local path = "Interface\\WorldMap\\" .. mapFolder .. "\\";
    local tileFormat = 4;

    for i = 1, 12 do
        local texName = path .. fileName .. i;

        if ui.routeBuilderMapPanelFrame.tiles[i] then
            ui.routeBuilderMapPanelFrame.tiles[i]:SetTexture(texName);
            ui.routeBuilderMapPanelFrame.tiles[i]:Show();
        end
    end
end

------------------------------------------------------------------------------
-- UI Creation
------------------------------------------------------------------------------

-- TODO: i originally wanted more of a distinct look for addon but can prolly rely on a built-in font
--       and remove this from distribution package
local function DM_RouteBuilder_CreateString(frame, id, text, x, y)
    local str = frame:CreateFontString(id);
    str:SetFont("Interface\\AddOns\\DungeonMentor\\Textures\\NotoMono-Regular.ttf", 16, "");

    str:SetTextColor(1, 1, 1, 1);
    str:SetJustifyH("LEFT");
    str:SetJustifyV("TOP");
    str:SetText(text);
    str:ClearAllPoints();
    str:SetPoint("TOPLEFT", frame, "TOPLEFT", x or 0 , y or 0);
    str:Show();

    return str;
end

-- CONFIRM DIALOG

local function DM_RouteBuilder_CreateConfirmDialog()
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

    ui.confirmDialog = CreateFrame("Frame", "DM_RouteBuilder_ConfirmFrame", UIParent, "UIPanelDialogTemplate");
    ui.confirmDialog:Hide();
    ui.confirmDialog:SetSize(240, 90);
    ui.confirmDialog:SetMovable(true);
    ui.confirmDialog:EnableMouse(true);
    ui.confirmDialog:ClearAllPoints();
    ui.confirmDialog:SetFrameStrata("DIALOG");
    ui.confirmDialog:SetPoint("CENTER");
    ui.confirmDialog:SetScript("OnMouseDown", function(self) self:StartMoving() end);
    ui.confirmDialog:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);

    ui.confirmDialog.ui = {};
    ui.confirmDialog.ui.titleText = ui.confirmDialog:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ui.confirmDialog.ui.titleText:SetPoint("TOPLEFT", ui.confirmDialog, "TOPLEFT", 20, -10)
    ui.confirmDialog.ui.titleText:SetJustifyH("LEFT")
    ui.confirmDialog.ui.titleText:SetText("...");
    ui.confirmDialog.ui.titleText:SetHeight(10);
    ui.confirmDialog.ui.titleText:Show();

    ui.confirmDialog.ui.confirmButton = CreateFrame("Button", "DM_RouteBuilder_Confirm_ConfirmButton", ui.confirmDialog, "UIPanelButtonTemplate");
    ui.confirmDialog.ui.confirmButton:SetPoint("TOPLEFT", ui.confirmDialog, "TOPLEFT", 20, -34);
    ui.confirmDialog.ui.confirmButton:SetHeight(22);
    ui.confirmDialog.ui.confirmButton:SetWidth(90);
    ui.confirmDialog.ui.confirmButton:SetText("CONFIRM");
    ui.confirmDialog.ui.confirmButton:Show();
    ui.confirmDialog.ui.confirmButton:SetScript("OnClick", function(self)
        if self.onConfirm then
            self.onConfirm();
        end

        ui.confirmDialog:Hide();
    end);

    ui.confirmDialog.ui.cancelButton = CreateFrame("Button", "DM_RouteBuilder_Confirm_CancelButton", ui.confirmDialog, "UIPanelButtonTemplate");
    ui.confirmDialog.ui.cancelButton:SetPoint("TOPRIGHT", ui.confirmDialog, "TOPRIGHT", -20, -34);
    ui.confirmDialog.ui.cancelButton:SetHeight(22);
    ui.confirmDialog.ui.cancelButton:SetWidth(90);
    ui.confirmDialog.ui.cancelButton:SetText("CANCEL");
    ui.confirmDialog.ui.cancelButton:Show();
    ui.confirmDialog.ui.cancelButton:SetScript("OnClick", function(self)
        if self.onCancel then
            self.onCancel();
        end

        ui.confirmDialog:Hide();
    end);
end

function DM_RouteBuilder_ShowConfirmDialog(titleText, onConfirm, onCancel)
    if ui.confirmDialog == nil then
        DM_RouteBuilder_CreateConfirmDialog();
    end

    ui.confirmDialog.ui.titleText:SetText(titleText);

    ui.confirmDialog.ui.confirmButton.onConfirm = onConfirm;
    ui.confirmDialog.ui.cancelButton.onCancel = onCancel;
    ui.confirmDialog:Show();
end

-- NOTE DIALOG

local function DM_RouteBuilder_CreateNoteFrame()
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

    ui.noteFrame = CreateFrame("Frame", "DM_RouteBuilder_RootNoteFrame", UIParent, "UIPanelDialogTemplate");
    ui.noteFrame:Hide();
    ui.noteFrame:SetSize(400, 110);
    ui.noteFrame:SetMovable(true);
    ui.noteFrame:EnableMouse(true);
    ui.noteFrame:ClearAllPoints();
    ui.noteFrame:SetFrameStrata("DIALOG");
    ui.noteFrame:SetPoint("CENTER");
    ui.noteFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end);
    ui.noteFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);

    ui.noteFrame.ui = {};
    ui.noteFrame.ui.titleText = ui.noteFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ui.noteFrame.ui.titleText:SetPoint("TOPLEFT", ui.noteFrame, "TOPLEFT", 20, -10)
    ui.noteFrame.ui.titleText:SetJustifyH("LEFT")
    ui.noteFrame.ui.titleText:SetText("...");
    ui.noteFrame.ui.titleText:SetHeight(10);

    ui.noteFrame.ui.editBoxBorder = CreateFrame("Frame", "DM_RouteBuilder_RootNoteFrame_Border", ui.noteFrame, "BackdropTemplate");
    ui.noteFrame.ui.editBoxBorder:Show();

    ui.noteFrame.ui.editBoxBorder:SetPoint("TOPLEFT", ui.noteFrame, "TOPLEFT", 12, -30);
    ui.noteFrame.ui.editBoxBorder:SetPoint("BOTTOMRIGHT", ui.noteFrame, "TOPRIGHT", -10, -54);
    ui.noteFrame.ui.editBoxBorder:SetHeight(14);

    ui.noteFrame.ui.editBoxBorder:SetBackdrop(backdrop);
    DM_Colors_SetDefaultBackdropColor(ui.noteFrame.ui.editBoxBorder);

    ui.noteFrame.ui.limitText = ui.noteFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    ui.noteFrame.ui.limitText:SetPoint("TOPLEFT", ui.noteFrame.ui.editBoxBorder, "TOPLEFT", 8, -4);
    ui.noteFrame.ui.limitText:SetJustifyH("LEFT");
    ui.noteFrame.ui.limitText:SetText("Keep notes short! Only the first " .. tostring(NOTE_CHARACTER_LIMIT) .. " characters are used");
    ui.noteFrame.ui.limitText:SetHeight(10);

    ui.noteFrame.ui.editBox = CreateFrame("EditBox", nil, ui.noteFrame.ui.editBoxBorder);
    ui.noteFrame.ui.editBox:SetMultiLine(false);
    ui.noteFrame.ui.editBox:SetSize(360, 12);
    ui.noteFrame.ui.editBox:SetPoint("TOPLEFT", ui.noteFrame.ui.editBoxBorder, "TOPLEFT", 8, -4);
    ui.noteFrame.ui.editBox:SetMaxLetters(100);
    ui.noteFrame.ui.editBox:SetFontObject(GameFontNormal);
    ui.noteFrame.ui.editBox:SetAutoFocus(true);
    ui.noteFrame.ui.editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);

    ui.noteFrame.ui.saveButton = CreateFrame("Button", "DM_RouteBuilder_RootNoteFrame_Button", ui.noteFrame, "UIPanelButtonTemplate");
    ui.noteFrame.ui.saveButton:SetPoint("BOTTOMRIGHT", ui.noteFrame, "BOTTOMRIGHT", -8, 10);
    ui.noteFrame.ui.saveButton:SetHeight(22);
    ui.noteFrame.ui.saveButton:SetWidth(100);
    ui.noteFrame.ui.saveButton:SetText("SAVE");
    ui.noteFrame.ui.saveButton.ui = ui.noteFrame.ui;
    ui.noteFrame.ui.saveButton:SetScript("OnClick", function(self)
        local text = self.ui.editBox:GetText();

        if uiContext.noteEditingContext.charLimit and text and string.len(text) > NOTE_CHARACTER_LIMIT then
            text = string.sub(text, 1, NOTE_CHARACTER_LIMIT);
        end

        uiContext.noteEditingContext.wasCanceled = false;
        uiContext.noteEditingContext.wasSaved = true;
        uiContext.noteEditingContext.promote = self.ui.promoteCb:GetChecked();
        uiContext.noteEditingContext.savedNote = text;
        if(uiContext.noteEditingContext.onSave ~= nil) then
            uiContext.noteEditingContext.onSave(uiContext.noteEditingContext.data, uiContext.noteEditingContext.savedNote, uiContext.noteEditingContext.promote);
        end
        ui.noteFrame:Hide();
    end);

    ui.noteFrame.ui.promoteCb = CreateFrame("CheckButton", "DM_RouteBuilder_PromoteNoteCB", ui.noteFrame, "ChatConfigCheckButtonTemplate");
    _G[ui.noteFrame.ui.promoteCb:GetName() .. "Text"]:SetText("Promote to Annotation");
    ui.noteFrame.ui.promoteCb:SetPoint("TOPLEFT", ui.noteFrame.ui.editBoxBorder, "BOTTOMLEFT", 0, 0);
    ui.noteFrame.ui.promoteCb:Show();

    ui.noteFrame.ui.promoteCb:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Note will appear as annotation in pull tracker.");
        GameTooltip:AddLine("Keep the note short and use this option carefully.");
        GameTooltip:Show();
     end);
     ui.noteFrame.ui.promoteCb:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
     end);
end

local function DM_RouteBuilder_StartEditingNote(titleText, note, contextData, saveFn, hidePromote, charLimit)
    if ui.noteFrame == nil then
        DM_RouteBuilder_CreateNoteFrame();
    end

    ui.noteFrame.ui.titleText:SetText(titleText);

    if note then
        if not note.text then
            return;
        end
        ui.noteFrame.ui.editBox:SetText(note.text);
    else
        ui.noteFrame.ui.editBox:SetText("");
    end

    if charLimit then
        ui.noteFrame.ui.limitText:Show();
        ui.noteFrame.ui.limitText:SetText("Keep this short! Only the first " .. tostring(charLimit) .. " characters are used");
        ui.noteFrame.ui.limitText:SetPoint("TOPLEFT", ui.noteFrame, "TOPLEFT", 12, -30);
        ui.noteFrame.ui.editBoxBorder:SetPoint("TOPLEFT", ui.noteFrame.ui.limitText, "BOTTOMLEFT", 0, -4);
        ui.noteFrame.ui.editBoxBorder:SetPoint("BOTTOMRIGHT", ui.noteFrame.ui.limitText, "TOPRIGHT", 30, -38);
    else
        ui.noteFrame.ui.editBox:SetPoint("TOPLEFT", ui.noteFrame.ui.editBoxBorder, "TOPLEFT", 8, -4);
        ui.noteFrame.ui.editBoxBorder:SetPoint("TOPLEFT", ui.noteFrame, "TOPLEFT", 12, -30);
        ui.noteFrame.ui.editBoxBorder:SetPoint("BOTTOMRIGHT", ui.noteFrame, "TOPRIGHT", -10, -54);

        ui.noteFrame.ui.limitText:Hide();
    end

    if hidePromote then
        ui.noteFrame.ui.promoteCb:Hide();
    else
        ui.noteFrame.ui.promoteCb:Show();
        ui.noteFrame.ui.promoteCb:SetChecked(note.promote);
    end

    uiContext.noteEditingContext.charLimit = charLimit;
    uiContext.noteEditingContext.data = contextData;

    if note then
        uiContext.noteEditingContext.startNote = note.text;
        uiContext.noteEditingContext.promote = note.promote;
    else
        uiContext.noteEditingContext.startNote = nil;
        uiContext.noteEditingContext.promote = nil;
    end

    uiContext.noteEditingContext.wasCanceled = true; -- default to canceled; ANY "hide" operation is effectively a cancel
    uiContext.noteEditingContext.wasSaved = false;
    uiContext.noteEditingContext.onSave = saveFn;

    ui.noteFrame:Show();
end

function DM_RouteBuilder_SaveRouteName(context, name)
    uiContext.currentRoute.name = name;

    DM_RouteBuilder_RefreshUi();
end

function DM_RouteBuilder_SaveRouteNote(noteContext, note, promote)
    local index = DM_RouteBuilder_FindIndexForMobGroup(uiContext.currentRoute, noteContext.areaKey, noteContext.mobGroup);
    local routeItem = uiContext.currentRoute.routeItems.items[index];

    routeItem.note = {text=note, promote=promote};
end

-- for now, 'promote' is ignored, too much note promotion will make pull tracker noisy but will
-- revisit in future
local function DM_RouteBuilder_SaveDungeonNote(noteContext, noteText, promote)
    DM_Data_Dungeon_SetNoteForMobGroup(uiContext.currentDungeonIndex, noteContext.areaKey, noteContext.mobGroup, noteText);
end

local function DM_RouteBuilder_StartEditRouteNote(areaKey, mobGroup)
    local index = DM_RouteBuilder_FindIndexForMobGroup(uiContext.currentRoute, areaKey, mobGroup);
    local routeItem = uiContext.currentRoute.routeItems.items[index];

    local dungeonCtx = uiContext.currentDungeonContext;
    local areaName = dungeonCtx.areas[areaKey].name;

    local text = "";
    local promote = false;
    
    if routeItem.note then
        text = routeItem.note.text or "";
        promote = routeItem.note.promote;
    end

    DM_RouteBuilder_StartEditingNote("Edit Note for Area " .. areaName .. ", Group " .. mobGroup, 
                                     {text=text, promote=promote},
                                     {mobGroup=routeItem.mobGroup,areaKey=routeItem.areaKey},
                                     DM_RouteBuilder_SaveRouteNote, false, NOTE_CHARACTER_LIMIT);
end

function DM_RouteBuilder_StartEditDungeonNote(areaKey, mobGroup)
    local dungeonCtx = uiContext.currentDungeonContext;
    local areaName = dungeonCtx.areas[areaKey].name;

    local text = DM_Data_Dungeon_GetNoteForMobGroup(uiContext.currentDungeonIndex, areaKey, mobGroup) or "";

    DM_RouteBuilder_StartEditingNote("Edit Note for Area " .. areaName .. ", Group " .. mobGroup, 
                                     {text=text},
                                     {mobGroup=mobGroup,areaKey=areaKey},
                                     DM_RouteBuilder_SaveDungeonNote, true, NOTE_CHARACTER_LIMIT);
end

--------------------------------------------------------------
-- import/export frame
--------------------------------------------------------------

function DM_RouteBuilder_ImportRoute(zoneId, zoneDisc, encodedRoute)
    DM_RouteBuilder_Show();

    local index = DM_Dungeons_ZoneIdToDungeonIndex(zoneId, zoneDisc);
    local routes = DM_Data_RoutesRoot(index);

    local deserSuccess, deserData = Serializer:Deserialize(DM_Util_Base64_Decode(encodedRoute));

    if not deserSuccess then
        DM_Util_PrintSystemMessage("ERROR: route to import has invalid format");
        return;
    end

    uiContext.tempRouteForImport = DM_RouteBuilder_RehydrateRoute(deserData);

    if not uiContext.tempRouteForImport then
        DM_Util_PrintSystemMessage("ERROR: route to import has invalid format");
        return;
    end

    local prefix = uiContext.tempRouteForImport.name;
    local num = 1;
    local name = prefix .. " (" .. tostring(num) .. ")";

    while DM_RouteBuilder_RouteNameExists(name, routes) do
        num = num + 1;
        name = prefix .. " (" .. tostring(num) .. ")";
    end

    uiContext.tempRouteForImport.name = name;

    uiContext.routes.size = uiContext.routes.size + 1;
    uiContext.routes.items[uiContext.routes.size] = uiContext.tempRouteForImport;

    uiContext.currentRouteIndex = uiContext.routes.size;
    uiContext.currentRoute = uiContext.routes.items[uiContext.currentRouteIndex];

    DM_RouteBuilder_DungeonSpecificContext(index).selectedRouteIndex = uiContext.currentRouteIndex;

    DM_RouteBuilder_RebuildRouteIndexMap(uiContext.currentRoute);

    DM_Util_PrintSystemMessage("Route imported for " .. DM_Dungeons_ZoneIdToDungeonName(zoneId, zoneDisc));

    ui.importExportFrame:Hide();

    DM_RouteBuilder_RefreshUi();
end

function DM_RouteBuilder_ShowImport()
    if ui.importExportFrame == nil then
        DM_RouteBuilder_CreateImportExportFrame();
    end

    uiContext.importExportView = IMPORT_VIEW;

    ui.importExportFrame.titleText:SetText(EXPORT_ROUTE_FRAME_TITLE);

    ui.routeImportExportEditBox:SetText("");
    ui.routeImportExportEditBox:SetFocus();
    ui.importExportFrame.bodyText:SetText(DEFAULT_IMPORT_BODY_TEXT);

    ui.importExportFrame:Show();
end

function DM_RouteBuilder_ShowExport()
    if ui.importExportFrame == nil then
        DM_RouteBuilder_CreateImportExportFrame();
    end

    uiContext.importExportView = EXPORT_VIEW;

    ui.importExportFrame.titleText:SetText(EXPORT_ROUTE_FRAME_TITLE);
    ui.importExportFrame.bodyText:SetText(DEFAULT_EXPORT_BODY_TEXT);
    ui.importExportFrame.copyButton:Hide();
    ui.importExportFrame.importButton:Hide();
    ui.importExportFrame:Show();

    if not uiContext.currentRoute then
        ui.routeImportExportEditBox:SetText("<No Active Route>");
    else
        ui.routeImportExportEditBox:SetText(DM_Util_Base64_Encode(Serializer:Serialize(DM_RouteBuilder_DehydrateRoute(uiContext.currentRoute))));
        ui.routeImportExportEditBox:HighlightText();
        ui.routeImportExportEditBox:SetFocus();
    end
end

local function DM_RouteBuilder_Comm_RequestRoute(charName, realmName, zoneId, zoneDisc, routeName)
    local z = tostring(zoneId);

    if zoneDisc and (zoneDisc==1 or zoneDisc==2 or zoneDisc=="1" or zoneDisc=="2") then
        z = z .. tostring(zoneDisc);
    end

    AC:SendCommMessage(DUNGEON_MENTOR_ROUTE_CHAT_PREFIX,
                       "route:" .. tostring(MESSAGE_TYPE_ROUTE_REQUEST) .. ":" .. z .. ":" .. routeName,
                       "WHISPER", charName .. "-" .. realmName, "NORMAL");
end

function DM_RouteBuilder_RequestRoute(charName, realmName, zoneId, routeName)
    local zoneDisc = nil;

    if tonumber(zoneId) == 25791 or tonumber(zoneId) == 2579 then
        zoneId = 2579;
        zoneDisc = 1;
    elseif tonumber(zoneId) == 25792 then
        zoneId = 2579;
        zoneDisc = 2;
    end

    DM_RouteBuilder_Comm_RequestRoute(charName, realmName, zoneId, zoneDisc, routeName);
end

function DM_RouteBuilder_ImportExportTextChanged()
    if uiContext.importExportView == 0 then
        DM_RouteBuilder_ImportTextChanged();
    end
end

function DM_RouteBuilder_RouteNameExists(name, routes)
    local root = routes or uiContext.routes;

    for i = 1, root.size do
        if root.items[i].name == name then
            return true;
        end
    end

    return false;
end

function DM_RouteBuilder_GetRouteByZoneAndName(zoneId, zoneDisc, routeName)
    local index = DM_Dungeons_ZoneIdToDungeonIndex(zoneId, zoneDisc);
    local routes = DM_Data_RoutesRoot(index);

    for i = 1, routes.size do
        local r = routes.items[i];

        if r.name == routeName then
            return r;
        end
    end

    return nil;
end

function DM_RouteBuilder_ImportConfirmClicked()
    local existingIndex = nil;

    if uiContext.routes.size > 0 then
        for i = 1, uiContext.routes.size do
            if uiContext.routes.items[i].name == uiContext.tempRouteForImport.name then
                existingIndex = i;
            end
        end
    end

    if existingIndex then
        uiContext.routes.items[existingIndex] = uiContext.tempRouteForImport;
        uiContext.currentRouteIndex = existingIndex;
        uiContext.currentRoute = uiContext.routes.items[existingIndex];
    else
        uiContext.routes.size = uiContext.routes.size + 1;
        uiContext.routes.items[uiContext.routes.size] = uiContext.tempRouteForImport;
        uiContext.currentRouteIndex = uiContext.routes.size;
        uiContext.currentRoute = uiContext.routes.items[uiContext.routes.size];
    end

    -- Swap dungeons because the route we imported may not match what the route builder is currenting displaying
    local dungeonIndex = DM_Dungeons_ZoneIdToDungeonIndex(uiContext.currentRoute.zoneId, uiContext.currentRoute.zoneDiscriminator);
    uiContext.currentDungeonIndex = dungeonIndex;
    DM_RouteBuilder_DungeonSpecificContext(uiContext.currentDungeonIndex).selectedRouteIndex = uiContext.currentRouteIndex;

    ui.importExportFrame:Hide();

    DM_RouteBuilder_RefreshUi();
end

function DM_RouteBuilder_CopyClicked()
    if not uiContext.tempRouteForImport then
        return;
    end

    local prefix = uiContext.tempRouteForImport.name;
    local num = 1;
    local name = prefix .. " (" .. tostring(num) .. ")";

    while DM_RouteBuilder_RouteNameExists(name) do
        num = num + 1;
        name = prefix .. " (" .. tostring(num) .. ")";
    end

    uiContext.tempRouteForImport.name = name;

    uiContext.routes.size = uiContext.routes.size + 1;
    uiContext.routes.items[uiContext.routes.size] = uiContext.tempRouteForImport;

    uiContext.currentRoute = uiContext.routes.items[uiContext.routes.size];
    uiContext.currentRouteIndex = uiContext.routes.size;

    -- Swap dungeons because the route we imported may not match what the route builder is currenting displaying
    local dungeonIndex = DM_Dungeons_ZoneIdToDungeonIndex(uiContext.currentRoute.zoneId, uiContext.currentRoute.zoneDiscriminator);
    uiContext.currentDungeonIndex = dungeonIndex;
    DM_RouteBuilder_DungeonSpecificContext(uiContext.currentDungeonIndex).selectedRouteIndex = uiContext.currentRouteIndex;

    ui.importExportFrame:Hide();

    DM_RouteBuilder_RefreshUi();
end

function DM_RouteBuilder_ImportTextChanged()
    if not uiContext.importExportView then
        return;
    end

    local t = ui.routeImportExportEditBox:GetText();

    ui.importExportFrame.importButton:SetText("IMPORT");
    ui.importExportFrame.copyButton:Hide();
    ui.importExportFrame.importButton:Hide();

    if t == nil or #t == 0 or t == "" then
        return;
    end

    local d = DM_Util_Base64_Decode(t);

    if d == nil or #d == 0 or #d == "" then
        ui.importExportFrame.bodyText:SetText("Invalid route.");
    else
        local deserSuccess, deserData = Serializer:Deserialize(d);

        uiContext.tempRouteForImport = DM_RouteBuilder_RehydrateRoute(deserData);

        if not deserSuccess or not uiContext.tempRouteForImport or not uiContext.tempRouteForImport.name then
            ui.importExportFrame.bodyText:SetText("Invalid route.");
            ui.importExportView = nil;
        else
            if DM_RouteBuilder_RouteNameExists(uiContext.tempRouteForImport.name) then
                ui.importExportFrame.bodyText:SetText("Route exists. 'COPY' to import a copy, or 'REPLACE'");
                ui.importExportFrame.copyButton:Show();
                ui.importExportFrame.importButton:Show();
                ui.importExportFrame.importButton:SetText("REPLACE");
                ui.importExportFrame.importButton:SetEnabled(true);
            else
                ui.importExportFrame.bodyText:SetText("Click 'IMPORT' to complete import.");
                ui.importExportFrame.importButton:Show();
                ui.importExportFrame.importButton:SetEnabled(true);
                ui.importExportFrame.copyButton:Hide();
                ui.importExportFrame.importButton:Show();
            end
        end
    end
end

function DM_RouteBuilder_CreateImportExportFrame()
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

    ui.importExportFrame = CreateFrame("Frame", "DM_Route_ImportExportFrame", UIParent, "UIPanelDialogTemplate");
    ui.importExportFrame:SetSize(600, 250);
    ui.importExportFrame:SetMovable(true);
    ui.importExportFrame:EnableMouse(true);
    ui.importExportFrame:ClearAllPoints();
    ui.importExportFrame:SetFrameStrata("DIALOG");
    ui.importExportFrame:SetPoint("CENTER", UIParent, "CENTER");
    ui.importExportFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end);
    ui.importExportFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);

    ui.importExportFrame.titleText = ui.importExportFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ui.importExportFrame.titleText:SetPoint("TOPLEFT", ui.importExportFrame, "TOPLEFT", 20, -10)
    ui.importExportFrame.titleText:SetJustifyH("LEFT")
    ui.importExportFrame.titleText:SetText("Dungeon Mentor: Export Route");
    ui.importExportFrame.titleText:SetHeight(10);

    ui.importExportFrame.bodyText = ui.importExportFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ui.importExportFrame.bodyText:SetPoint("TOPLEFT", ui.importExportFrame, "TOPLEFT", 20, -34)
    ui.importExportFrame.bodyText:SetJustifyH("LEFT")
    ui.importExportFrame.bodyText:SetText("Copy below text to your system clipboard and share outside the game.");

    ui.importExportFrame.importButton = CreateFrame("Button", "DM_RouteBuilder_ImportExport_ImportButton", ui.importExportFrame, "UIPanelButtonTemplate");
    ui.importExportFrame.importButton:SetPoint("TOPRIGHT", ui.importExportFrame, "TOPRIGHT", -12, -32);
    ui.importExportFrame.importButton:SetHeight(22);
    ui.importExportFrame.importButton:SetWidth(100);
    ui.importExportFrame.importButton:SetText("CONFIRM");
    ui.importExportFrame.importButton:SetScript("OnClick", function(self)
        DM_RouteBuilder_ImportConfirmClicked();
    end);

    ui.importExportFrame.copyButton = CreateFrame("Button", "DM_RouteBuilder_ImportExport_CopyButton", ui.importExportFrame, "UIPanelButtonTemplate");
    ui.importExportFrame.copyButton:SetPoint("TOPRIGHT", ui.importExportFrame.importButton, "TOPLEFT", -12, 0);
    ui.importExportFrame.copyButton:SetHeight(22);
    ui.importExportFrame.copyButton:Hide();
    ui.importExportFrame.copyButton:SetWidth(100);
    ui.importExportFrame.copyButton:SetText("COPY");
    ui.importExportFrame.copyButton:SetScript("OnClick", function(self)
        DM_RouteBuilder_CopyClicked();
    end);

    ui.importExportFrameChild = CreateFrame("Frame", "DM_Route_ImportExportFrameSF", ui.importExportFrame, "BackdropTemplate")
    ui.importExportFrameChild:Show();
    ui.importExportFrameChild:SetPoint("TOPLEFT", ui.importExportFrame, "TOPLEFT", 8, -60);
    ui.importExportFrameChild:SetPoint("BOTTOMRIGHT", ui.importExportFrame, "BOTTOMRIGHT", -10, 8);

    ui.importExportFrameChild:SetBackdrop(backdrop)
    DM_Colors_SetDefaultBackdropColor(ui.importExportFrameChild);

    ui.importExportFrameChild.SF = CreateFrame("ScrollFrame", "$parent_DF", ui.importExportFrameChild, "UIPanelScrollFrameTemplate")
    ui.importExportFrameChild.SF:SetPoint("TOPLEFT", ui.importExportFrameChild, 12, -10)
    ui.importExportFrameChild.SF:SetPoint("BOTTOMRIGHT", ui.importExportFrameChild, -30, 10)
    ui.importExportFrameChild.SF:SetSize(500, 400);

    local scrollBarLevel = _G[ui.importExportFrameChild.SF:GetName() .. "ScrollBar"]:GetFrameLevel();
    _G[ui.importExportFrameChild.SF:GetName() .. "ScrollBarScrollUpButton"]:SetFrameLevel(scrollBarLevel);
    _G[ui.importExportFrameChild.SF:GetName() .. "ScrollBarScrollDownButton"]:SetFrameLevel(scrollBarLevel);

    ui.routeImportExportEditBox = CreateFrame("EditBox", nil, ui.importExportFrameChild.SF);

    ui.importExportFrameChild.Text = ui.routeImportExportEditBox;

    ui.importExportFrameChild.Text:SetWidth(500);
    ui.importExportFrameChild.Text:SetMultiLine(true);
    ui.importExportFrameChild.Text:SetFontObject(GameFontNormal);
    ui.importExportFrameChild.Text:SetAutoFocus(true);
    ui.importExportFrameChild.Text:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);
    ui.importExportFrameChild.Text:SetScript("OnTextChanged", function(self) DM_RouteBuilder_ImportExportTextChanged(); end);
    ui.importExportFrameChild.SF:SetScrollChild(ui.importExportFrameChild.Text);
end

local function DM_RouteBuilder_EnableRouteItemToolbarItems()
    for i = 1, ui.routeItemToolbarItems.size do
        DM_Colors_SetIconColor(ui.routeItemToolbarItems.items[i], COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end

    uiContext.routeItemToolbarDisabled = false;
end

local function DM_RouteBuilder_DisableRouteItemToolbarItems()
    for i = 1, ui.routeItemToolbarItems.size do
        DM_Colors_SetIconColor(ui.routeItemToolbarItems.items[i], COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end

    uiContext.routeItemToolbarDisabled = true;
end

function DM_RouteBuilder_CreatePullLine(index, name, options, width, text)
    local uiParent = ui.sidePanelPullScrollChildFrame;
    local contentLine = CreateFrame("Button", name, uiParent);
 
    contentLine:SetPoint("TOPLEFT", uiParent, "TOPLEFT", 0, (index-1) * -20);
    contentLine:SetPoint("RIGHT", uiParent, "RIGHT");
 
    local marginPosition = 18;
 
    if not options.marginEnabled then
       marginPosition = 0;
    end
 
    contentLine:SetHeight(20);

    contentLine.StatusBar = CreateFrame("StatusBar", nil, contentLine);
    contentLine.StatusBar:SetAllPoints(contentLine);
 
    contentLine.StatusBar:SetStatusBarTexture("Interface\\Addons\\DungeonMentor\\Textures\\BantoBar_statusbar");
    contentLine.StatusBar:GetStatusBarTexture():SetHorizTile(false);
    contentLine.StatusBar:GetStatusBarTexture():SetVertTile(false);

    DM_Colors_SetStatusBarColor(contentLine.StatusBar, COLOR_KEY_ROUTEBUILDER_STATUSBAR_NORMAL);

    contentLine.StatusBar:SetMinMaxValues(0, 100);
    contentLine.StatusBar:SetValue(0); -- at 0 it blends with background, at 100 it sticks out
    contentLine.StatusBar:Show();

    contentLine.StatusBar.parentLine = contentLine;

    contentLine.StatusBar:EnableMouse(true);
    contentLine.StatusBar:SetScript("OnMouseUp", function(self)
        if not self.parentLine.header then
            return;
        end

        local ri = self.parentLine.routeItem;

        if not DM_RouteBuilder_IsPullGroupSelected(ri.areaKey, ri.mobGroup) then
            DM_RouteBuilder_SelectRouteItem(ri.areaKey, ri.mobGroup);
            DM_RouteBuilder_EnableRouteItemToolbarItems();
        else
            DM_RouteBuilder_DeselectRouteItem();
            DM_RouteBuilder_DisableRouteItemToolbarItems();
        end

        DM_RouteBuilder_RefreshUi();
    end);

    local routeNoteIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "NOTE", 16, 16, "OVERLAY");

    routeNoteIcon:ClearAllPoints()
    DM_Colors_SetIconColor(routeNoteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    routeNoteIcon:Show();
    routeNoteIcon:SetPoint("LEFT", contentLine.StatusBar, "LEFT", 2, 0);
    routeNoteIcon.parentLine = contentLine;
    routeNoteIcon:EnableMouse(true);
    routeNoteIcon:SetScript("OnEnter", function(self)
        local routeItem = self.parentLine.routeItem;
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:ClearLines();

        local n = routeItem.note;

        if not n or not n.text or string.len(n.text) == 0 then
            GameTooltip:AddLine("Route Note: Click to add");
            GameTooltip:AddLine("This note is shared as part of the route");
        else
            GameTooltip:AddLine("Route Note");
            if n.promote then
                GameTooltip:AddLine("(Displays as annotation in pull tracker)");
            end
            GameTooltip:AddLine(" ");
            GameTooltip:AddLine(n.text);
        end

        GameTooltip:Show();
    end);
    routeNoteIcon:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
    end);
    routeNoteIcon:SetScript("OnMouseUp", function(self)
        local routeItem = self.parentLine.routeItem;

        DM_RouteBuilder_StartEditRouteNote(routeItem.areaKey, routeItem.mobGroup);
    end);

    local linkIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "CHAIN_UNLINKED", 16, 16, "OVERLAY");

    linkIcon:ClearAllPoints();
    linkIcon:SetPoint("TOPLEFT", routeNoteIcon, "TOPRIGHT", 4, 0);
    DM_Colors_SetIconColor(linkIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    linkIcon.parentLine = contentLine;
    linkIcon:Hide();
    linkIcon.linkMode = 0; -- 0 = unlinked, 1 = start of pull chain, 2 = linked to existing pull chain
    contentLine.linkIcon = linkIcon;

    contentLine.MainColumnText = contentLine.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    contentLine.MainColumnText:SetPoint("TOPLEFT", contentLine.StatusBar, "TOPLEFT", 2, -2);
    contentLine.MainColumnText:SetJustifyH("LEFT");
    contentLine.MainColumnText:SetTextColor(1, 1, 1, 1);
    contentLine.MainColumnText:SetWordWrap(false);
    contentLine.MainColumnText:SetText(text);
    contentLine.indentWidth = 0;
    contentLine.MainColumnText.indentWidth = 0;
    contentLine.MainColumnText.parent = contentLine;

    local rightArrowIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "RIGHT_ARROW", 16, 16, "OVERLAY");

    rightArrowIcon:ClearAllPoints()
    rightArrowIcon:SetPoint("TOPLEFT", contentLine.MainColumnText, "TOPRIGHT", 8, 2);
    DM_Colors_SetIconColor(rightArrowIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    rightArrowIcon.parentLine = contentLine;
    rightArrowIcon:Hide();
    rightArrowIcon:EnableMouse(true);
    rightArrowIcon.parentLine = contentLine;
    rightArrowIcon.parentLine.annotationType = nil;
    rightArrowIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to see other display options");
        GameTooltip:Show();
    end);
    rightArrowIcon:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);
    rightArrowIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_CycleAnnotationText(self.parentLine.routeItem, self.parentLine.annotationType);
        DM_RouteBuilder_RefreshUi();
    end);

    contentLine.rightArrowIcon = rightArrowIcon;

    local removeIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "BIG_X", 16, 16, "OVERLAY");

    removeIcon:ClearAllPoints()
    removeIcon:SetPoint("TOPRIGHT", contentLine.StatusBar, "TOPRIGHT", -8, 0);
    DM_Colors_SetIconColor(removeIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    removeIcon.parentLine = contentLine;
    removeIcon:Hide();
    removeIcon:EnableMouse(true);

    removeIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to remove from route");
        GameTooltip:Show();
    end);
    removeIcon:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);
    removeIcon:SetScript("OnMouseUp", function(self)
        local line = self.parentLine;
        local routeItem = self.parentLine.routeItem;

        if line.annotationType then
            routeItem.annotations[line.annotationType] = nil;
            DM_RouteBuilder_RefreshPullGroupsDisplay();
            return;
        end

        if routeItem.areaKey and routeItem.mobGroup then
            DM_RouteBuilder_RemoveMobGroupFromRoute(routeItem.areaKey, routeItem.mobGroup);
        end

        DM_RouteBuilder_RefreshUi();
    end);

    contentLine.removeIcon = removeIcon;

    local arrowDownIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "DOWN_ARROW", 16, 16, "OVERLAY");

    arrowDownIcon:ClearAllPoints()
    arrowDownIcon:SetPoint("TOPRIGHT", removeIcon, "TOPLEFT", -8, 0);
    DM_Colors_SetIconColor(arrowDownIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    arrowDownIcon.parentLine = contentLine;
    arrowDownIcon:Hide();

    local arrowUpIcon = DM_Tex_CreateRouteBuilderIcon(contentLine.StatusBar, "UP_ARROW", 16, 16, "OVERLAY");

    arrowUpIcon:ClearAllPoints()
    arrowUpIcon:SetPoint("TOPRIGHT", arrowDownIcon, "TOPLEFT", -4, 0);
    arrowUpIcon:SetVertexColor(230/255,159/255,0/255,1); -- TODO
    arrowUpIcon.parentLine = contentLine;
    arrowUpIcon:Hide();

    arrowUpIcon:EnableMouse(true);
    arrowDownIcon:EnableMouse(true);
    arrowUpIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
    end);
    arrowUpIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);

    arrowDownIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
    end);
    arrowDownIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);

    arrowUpIcon:SetScript("OnMouseUp", function(self)
        local routeItem = self.parentLine.routeItem;

        if not routeItem then
            return;
        end

        DM_RouteBuilder_MoveRouteItemUp(routeItem);
    end);

    arrowDownIcon:SetScript("OnMouseUp", function(self)
        local routeItem = self.parentLine.routeItem;

        if not routeItem then
            return;
        end

        DM_RouteBuilder_MoveRouteItemDown(routeItem);
    end);

    contentLine.headerUiElements = {
        size = 6,
        items = {
            [1] = arrowUpIcon,
            [2] = arrowDownIcon,
            [3] = routeNoteIcon,
            [4] = personalNoteIcon,
            [5] = linkIcon,
            [6] = removeIcon
        }
    };

    return contentLine;
end

local function DM_RouteBuilder_CreateSidePanel()
    if ui.sidePanelRootFrame then
        return;
    end

    local canvasDrawLayer = "BORDER";
    local firstDungeon = DM_Dungeons_GetCurrentSeasonContext().items[1];

    ui.sidePanelRootFrame = CreateFrame("Frame", "DM_RouteBuilder_SideFrame", ui.routeBuilderRootFrame);
    ui.sidePanelRootFrame.sidePanelTex = ui.sidePanelRootFrame:CreateTexture(nil, "BACKGROUND", nil, 0);
    ui.sidePanelRootFrame.sidePanelTex:SetAllPoints();
    ui.sidePanelRootFrame.sidePanelTex:SetDrawLayer(canvasDrawLayer, -5);
    ui.sidePanelRootFrame.sidePanelTex:SetColorTexture(unpack({ 0, 0, 0, 0.4 }));
    ui.sidePanelRootFrame.sidePanelTex:Show();

    ui.sidePanelRootFrame:EnableMouse(true);

    ui.sidePanelRootFrame:ClearAllPoints();
    ui.sidePanelRootFrame:SetWidth(SIDE_PANEL_WIDTH);
    ui.sidePanelRootFrame:SetPoint("TOPLEFT", ui.routeBuilderMapRootFrame, "TOPRIGHT");
    ui.sidePanelRootFrame:SetPoint("BOTTOMLEFT", ui.routeBuilderMapRootFrame, "BOTTOMRIGHT");

    ui.dropdowns.dungeon = CreateFrame("FRAME", "DM_RouteBuilder_DungeonDropDown", ui.sidePanelRootFrame, "UIDropDownMenuTemplate");
    ui.dropdowns.dungeon:SetPoint("TOPLEFT", ui.sidePanelRootFrame, "TOPLEFT", 10, -6);
    UIDropDownMenu_SetWidth(ui.dropdowns.dungeon, 200);

    ui.dropdowns.dungeonFloor = CreateFrame("FRAME", "DM_RouteBuilder_DungeonFloorDropDown", ui.sidePanelRootFrame, "UIDropDownMenuTemplate");
    ui.dropdowns.dungeonFloor:SetPoint("TOPLEFT", ui.dropdowns.dungeon, "BOTTOMLEFT", 0, -2);
    UIDropDownMenu_SetWidth(ui.dropdowns.dungeonFloor, 200);
    UIDropDownMenu_SetText(ui.dropdowns.dungeonFloor, "...");
    ui.dropdowns.dungeonFloor:Hide();

    UIDropDownMenu_SetText(ui.dropdowns.dungeon, firstDungeon.name);
    UIDropDownMenu_Initialize(ui.dropdowns.dungeon, 
        function(self, level, menuList)
            local dungeons = DM_Dungeons_GetCurrentSeasonContext();

            for i = 1, dungeons.size do
               local info = UIDropDownMenu_CreateInfo();
               info.text, info.hasArrow, info.arg1, info.func = dungeons.items[i].name, nil, i, DM_RouteBuilder_DropDown_DungeonSelected;
               UIDropDownMenu_AddButton(info);
            end
    end);

    UIDropDownMenu_SetSelectedID(ui.dropdowns.dungeon, 1);

    local prevIcon = nil;

    ui.routeItemToolbarItems = {size=0,items={}};

    local newRouteIcon;
    local importRouteIcon;
    local exportRouteIcon;
    local clearRouteIcon;
    local shareRouteIcon;

    -- new route icon
    newRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "NEW", 26, 26, "OVERLAY");
    DM_Colors_SetIconColor(newRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);

    newRouteIcon:EnableMouse(true);
    newRouteIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_CreateAndSelectNewRoute(true);
    end);
    newRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to create new route.");
        GameTooltip:AddLine("Changes to any existing route will not be lost.");
        GameTooltip:Show();
    end);
    newRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);

    -- clear icon
    clearRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "CIRCLE_X", 26, 26, "OVERLAY");
    DM_Colors_SetIconColor(clearRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    clearRouteIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_ShowConfirmDialog("Confirm Route Clear", DM_RouteBuilder_ClearRouteConfirmed);
    end);
    clearRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to clear route. This will also lose");
        GameTooltip:AddLine("any notes added to the route.");
        GameTooltip:Show();
    end);
    clearRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);

    -- import (paste)
    importRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "PASTE", 26, 26, "OVERLAY");
    DM_Colors_SetIconColor(importRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    importRouteIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_ShowImport();
    end);

    importRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to import route.");
        GameTooltip:Show();
    end);
    importRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);

    -- export (copy)
    exportRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "COPY", 26, 26, "OVERLAY");
    DM_Colors_SetIconColor(exportRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    exportRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to export route.");
        GameTooltip:Show();
    end);
    exportRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);
    exportRouteIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_ShowExport();
    end);

    -- share
    shareRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "SHARE", 26, 26, "OVERLAY");
    DM_Colors_SetIconColor(shareRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    shareRouteIcon:SetScript("OnMouseUp", function(self)
        if not uiContext.currentRoute then
            DM_Util_PrintSystemMessage("ERROR: No route available to share");
            return;
        end

        local editbox = GetCurrentKeyBoardFocus();
        if(editbox) then
            local r = uiContext.currentRoute;
            local z = tostring(uiContext.currentDungeonContext.zoneId);
            if uiContext.currentDungeonContext.zoneDiscriminator then
                z = z .. tostring(uiContext.currentDungeonContext.zoneDiscriminator);
            end

            local charName, realmName = UnitFullName("player");

            editbox:Insert("[DungeonMentor: " .. charName .. "-" .. realmName .. " - " .. z .. "-" .. r.name .. "]");
        end
    end);
    shareRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Shift-click to share route to an open chat");
        GameTooltip:Show();
    end);
    shareRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);

    -- ordering the icons
    newRouteIcon:ClearAllPoints();
    newRouteIcon:SetPoint("TOPLEFT", ui.dropdowns.dungeonFloor, "TOPLEFT", (280 / 2) - (32 * 6) / 2, -32);
    clearRouteIcon:SetPoint("TOPLEFT", newRouteIcon, "TOPRIGHT", 6, 0);
    importRouteIcon:SetPoint("TOPLEFT", clearRouteIcon, "TOPRIGHT", 6, 0);
    exportRouteIcon:SetPoint("TOPLEFT", importRouteIcon, "TOPRIGHT", 6, 0);
    shareRouteIcon:SetPoint("TOPLEFT", exportRouteIcon, "TOPRIGHT", 6, 0);

    -- showing the icons
    newRouteIcon:Show();
    clearRouteIcon:Show();
    importRouteIcon:Show();
    exportRouteIcon:Show();
    shareRouteIcon:Show();

    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = newRouteIcon;
    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = clearRouteIcon;
    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = importRouteIcon;
    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = exportRouteIcon;
    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = shareRouteIcon;

    ui.dropdowns.routes = CreateFrame("FRAME", "DM_RouteBuilder_SavedRoutesDD", ui.sidePanelRootFrame, "UIDropDownMenuTemplate");
    ui.dropdowns.routes:SetPoint("TOPLEFT", ui.routeItemToolbarItems.items[1], "BOTTOMLEFT", -18 - 26, -8);
    UIDropDownMenu_SetWidth(ui.dropdowns.routes, 200);
    UIDropDownMenu_SetText(ui.dropdowns.routes, NO_ROUTES_TEXT);

    ui.routeCheckBoxes.defaultCb = CreateFrame("CheckButton", "DM_RouteBuilder_DefaultRouteCB", ui.sidePanelRootFrame, "ChatConfigCheckButtonTemplate");
    ui.routeCheckBoxes.defaultCb:SetPoint("TOPLEFT", ui.dropdowns.routes, "BOTTOMLEFT", 140, 4);
    _G[ui.routeCheckBoxes.defaultCb:GetName() .. "Text"]:SetText("Default Route");
    ui.routeCheckBoxes.defaultCb:SetScript("OnClick", function(self)
        DM_Util_PrintSystemMessage("Setting default route state on a route NIY");
    end);

    ui.routeCheckBoxes.defaultCb:Show();

    ui.routeCheckBoxes.tyrCb = CreateFrame("CheckButton", "DM_RouteBuilder_TyrRouteCB", ui.sidePanelRootFrame, "ChatConfigCheckButtonTemplate");
    _G[ui.routeCheckBoxes.tyrCb:GetName() .. "Text"]:SetText("Tyrannical");
    ui.routeCheckBoxes.tyrCb:SetPoint("TOPLEFT", ui.routeCheckBoxes.defaultCb, "BOTTOMLEFT", 0, 4);
    ui.routeCheckBoxes.tyrCb:Show();
    ui.routeCheckBoxes.tyrCb:SetScript("OnClick", function(self)
        if ui.routeCheckBoxes.fortCb:GetChecked() then
            ui.routeCheckBoxes.fortCb:SetChecked(false);
        end

        if uiContext.currentRoute then
            if ui.routeCheckBoxes.tyrCb:GetChecked() then
                uiContext.currentRoute.isTyr = true;
            else
                uiContext.currentRoute.isTyr = false;
            end
            if ui.routeCheckBoxes.fortCb:GetChecked() then
                uiContext.currentRoute.isFort = true;
            else
                uiContext.currentRoute.isFort = false;
            end
        end
    end);

    ui.routeCheckBoxes.fortCb = CreateFrame("CheckButton", "DM_RouteBuilder_FortRouteCB", ui.sidePanelRootFrame, "ChatConfigCheckButtonTemplate");
    _G[ui.routeCheckBoxes.fortCb:GetName() .. "Text"]:SetText("Fortified");
    ui.routeCheckBoxes.fortCb:SetPoint("TOPLEFT", ui.routeCheckBoxes.tyrCb, "BOTTOMLEFT", 0, 4);
    ui.routeCheckBoxes.fortCb:Show();
    ui.routeCheckBoxes.fortCb:SetScript("OnClick", function(self)
        if ui.routeCheckBoxes.tyrCb:GetChecked() then
            ui.routeCheckBoxes.tyrCb:SetChecked(false);
        end

        if uiContext.currentRoute then
            if ui.routeCheckBoxes.tyrCb:GetChecked() then
                uiContext.currentRoute.isTyr = true;
            else
                uiContext.currentRoute.isTyr = false;
            end
            if ui.routeCheckBoxes.fortCb:GetChecked() then
                uiContext.currentRoute.isFort = true;
            else
                uiContext.currentRoute.isFort = false;
            end
        end
    end);

    ui.sidePanelActivateRouteButton = DM_Tex_CreateSetButton(ui.sidePanelRootFrame);
    ui.sidePanelActivateRouteButton:ClearAllPoints();
    ui.sidePanelActivateRouteButton:SetPoint("TOPLEFT", ui.dropdowns.routes, "BOTTOMLEFT", 12, -8);
    ui.sidePanelActivateRouteButton:SetWidth(128);
    ui.sidePanelActivateRouteButton:SetHeight(24);
    ui.sidePanelActivateRouteButton:Show();

    ui.sidePanelActivateRouteButton:EnableMouse(true);
    ui.sidePanelActivateRouteButton:SetScript("OnEnter", function(self)
        DM_Tex_SetSetButtonHighlighted(ui.sidePanelActivateRouteButton);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to send this route to pull tracker");
        GameTooltip:Show();
    end);
    ui.sidePanelActivateRouteButton:SetScript("OnLeave", function(self)
        DM_Tex_SetSetButtonNormal(ui.sidePanelActivateRouteButton);
        GameTooltip:Hide();
    end);
    ui.sidePanelActivateRouteButton:SetScript("OnMouseUp", function(self)
        if not uiContext.currentRoute then
            DM_Util_PrintSystemMessage("ERROR: No route to activate, please create a route");
        else
            DM_Trackers_InitPullWindows();
        end
    end);

    local renameRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "RENAME", 16, 16, "OVERLAY");
    renameRouteIcon:EnableMouse(true);
    renameRouteIcon:SetPoint("TOPLEFT", ui.dropdowns.routes, "TOPRIGHT", -12, -4);
    DM_Colors_SetIconColor(renameRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    renameRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to rename route");
        GameTooltip:Show();
     end);
     renameRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
     end);
     renameRouteIcon:SetScript("OnMouseUp", function(self)
        if not uiContext.currentRoute then
            return;
        end

        DM_RouteBuilder_StartEditingNote("Edit Route Name", 
                                            {text=uiContext.currentRoute.name or ""},
                                            {}, 
                                            DM_RouteBuilder_SaveRouteName, 
                                            true,
                                            NOTE_CHARACTER_LIMIT);
     end);

     local deleteRouteIcon = DM_Tex_CreateRouteBuilderIcon(ui.sidePanelRootFrame, "BIG_X", 16, 16, "OVERLAY");
     deleteRouteIcon:EnableMouse(true);
     deleteRouteIcon:SetPoint("TOPLEFT", renameRouteIcon, "TOPRIGHT", 4, 0);
     DM_Colors_SetIconColor(deleteRouteIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     deleteRouteIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Click to delete route.");
        GameTooltip:Show();
     end);
     deleteRouteIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
     end);
     deleteRouteIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_DeleteCurrentRoute();
     end);

     ui.sidePanelPullScrollFrame = CreateFrame("ScrollFrame", "DM_RouteBuilder_PullsScroll", ui.sidePanelRootFrame, "UIPanelScrollFrameTemplate")
     ui.sidePanelPullScrollFrame:SetPoint("TOPLEFT", ui.sidePanelRootFrame, "TOPLEFT", 0, -250);
     ui.sidePanelPullScrollFrame:SetPoint("BOTTOMRIGHT", ui.sidePanelRootFrame, "BOTTOMRIGHT", -24, 0);

     ui.sidePanelUiForcesString = DM_RouteBuilder_CreateString(ui.sidePanelRootFrame, "DM_RouteBuilder_SideForcesText", "", 12, 0);
     ui.sidePanelUiForcesString:SetPoint("TOPLEFT", ui.sidePanelPullScrollFrame, "TOPLEFT", 4, 28);

     local scrollBarLevel = _G[ui.sidePanelPullScrollFrame:GetName() .. "ScrollBar"]:GetFrameLevel();
     _G[ui.sidePanelPullScrollFrame:GetName() .. "ScrollBarScrollUpButton"]:SetFrameLevel(scrollBarLevel);
     _G[ui.sidePanelPullScrollFrame:GetName() .. "ScrollBarScrollDownButton"]:SetFrameLevel(scrollBarLevel);

     local routeItemIconsHorizPadding = 4;

     local chainStartItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "PULLCHAIN_START", 18, 18, "OVERLAY");
     chainStartItem:ClearAllPoints();
     chainStartItem:SetPoint("TOPLEFT", ui.sidePanelRootFrame, "TOPLEFT", 70, -200);
     DM_Colors_SetIconColor(chainStartItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     chainStartItem:Show();

     chainStartItem:EnableMouse(true);
     chainStartItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Marks selected pull group as start of pull chain.");
        GameTooltip:Show();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
     end);
     chainStartItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        GameTooltip:Hide();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);
     chainStartItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_SetSelectedGroupPullChainStart();
     end);
     ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
     ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = chainStartItem;
 
     local chainLinkedItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "PULLCHAIN_LINKED", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
     chainLinkedItem:ClearAllPoints();
     chainLinkedItem:SetPoint("TOPLEFT", chainStartItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
     DM_Colors_SetIconColor(chainLinkedItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     chainLinkedItem:Show();

     chainLinkedItem:EnableMouse(true);
     chainLinkedItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Marks selected pull group as part of pull chain.");
        GameTooltip:Show();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
     end);
     chainLinkedItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);
    chainLinkedItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_SetSelectedGroupLinked();
    end);

    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = chainLinkedItem;

    local chainUnlinkedItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "UNLINKED", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
    chainUnlinkedItem:ClearAllPoints();
    chainUnlinkedItem:SetPoint("TOPLEFT", chainLinkedItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
    DM_Colors_SetIconColor(chainUnlinkedItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    chainUnlinkedItem:Show();

    chainUnlinkedItem:EnableMouse(true);
    chainUnlinkedItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Marks selected pull group as un-linked.");
        GameTooltip:Show();
     end);
     chainUnlinkedItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
     end);
     chainUnlinkedItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_SetSelectedGroupUnlinked();
     end);

     ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
     ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = chainUnlinkedItem;

     local cautionRouteItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "CAUTION", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
     cautionRouteItem:ClearAllPoints();
     cautionRouteItem:SetPoint("TOPLEFT", chainUnlinkedItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
     DM_Colors_SetIconColor(cautionRouteItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     cautionRouteItem:Show();

     cautionRouteItem:EnableMouse(true);
     cautionRouteItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Adds caution/slow warning for pull group.");
        GameTooltip:Show();
     end);
     cautionRouteItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);
     cautionRouteItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_AnnotateSelectedRouteItem(ROUTE_ITEM_ANNOTATION_CAUTION);
        DM_RouteBuilder_RefreshUi();
     end);
     ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
     ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = cautionRouteItem;

     local lustRouteItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "LUST", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
     lustRouteItem:ClearAllPoints();
     lustRouteItem:SetPoint("TOPLEFT", cautionRouteItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
     DM_Colors_SetIconColor(lustRouteItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     lustRouteItem:Show();

     lustRouteItem:EnableMouse(true);
     lustRouteItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Adds indicator to lust on selected pull group.");
        GameTooltip:Show();
     end);
     lustRouteItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
     end);
     lustRouteItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_AnnotateSelectedRouteItem(ROUTE_ITEM_ANNOTATION_LUST);
        DM_RouteBuilder_RefreshPullGroupsDisplay();
     end);

     ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
     ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = lustRouteItem;

     local losPullRouteItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "LOS", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
     losPullRouteItem:ClearAllPoints();
     losPullRouteItem:SetPoint("TOPLEFT", lustRouteItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
     DM_Colors_SetIconColor(losPullRouteItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
     losPullRouteItem:Show();

     losPullRouteItem:EnableMouse(true);
     losPullRouteItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Adds indicator pull group is a LOS pull.");
        GameTooltip:Show();
     end);
     losPullRouteItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);
    losPullRouteItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_AnnotateSelectedRouteItem(ROUTE_ITEM_ANNOTATION_LOS_PULL);
        DM_RouteBuilder_RefreshPullGroupsDisplay();
    end);
    ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
    ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = losPullRouteItem;

    local stealthRouteItem = DM_Tex_CreateRouteItemIcon(ui.sidePanelRootFrame, "STEALTH", routeItemToolIconWidth, routeItemToolIconHeight, "OVERLAY");
    stealthRouteItem:ClearAllPoints();
    stealthRouteItem:SetPoint("TOPLEFT", losPullRouteItem, "TOPRIGHT", routeItemIconsHorizPadding, 0);
    DM_Colors_SetIconColor(stealthRouteItem, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    stealthRouteItem:Show();

    stealthRouteItem:EnableMouse(true);
    stealthRouteItem:SetScript("OnEnter", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT");
            GameTooltip:ClearLines();
            GameTooltip:AddLine("Requires a selected pull group.");
            GameTooltip:Show();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        GameTooltip:AddLine("Adds indicator to stealth/invis before pull group.");
        GameTooltip:Show();
    end);
    stealthRouteItem:SetScript("OnLeave", function(self)
        if uiContext.routeItemToolbarDisabled then
            GameTooltip:Hide();
            return;
        end
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
        GameTooltip:Hide();
    end);
    stealthRouteItem:SetScript("OnMouseUp", function(self)
        if uiContext.routeItemToolbarDisabled then
            return;
        end
        DM_RouteBuilder_AnnotateSelectedRouteItem(ROUTE_ITEM_ANNOTATION_STEALTH);
        DM_RouteBuilder_RefreshPullGroupsDisplay();
     end);

     ui.routeItemToolbarItems.size = ui.routeItemToolbarItems.size + 1;
     ui.routeItemToolbarItems.items[ui.routeItemToolbarItems.size] = stealthRouteItem;

     ui.sidePanelPullScrollChildFrame = CreateFrame("Frame");
     ui.sidePanelPullScrollFrame:SetScrollChild(ui.sidePanelPullScrollChildFrame);
     ui.sidePanelPullScrollChildFrame:SetWidth(280);
     ui.sidePanelPullScrollChildFrame:SetHeight(1);

     for i = 1, 10 do
        ui.sidePanelTextLines.size = ui.sidePanelTextLines.size + 1;

        ui.sidePanelTextLines.items[ui.sidePanelTextLines.size] = DM_RouteBuilder_CreatePullLine(i, "DM_RouteBuilder_Line" .. tostring(i),
                                                                                                 {marginEnabled=0},
                                                                                                 280-24, "");

        ui.sidePanelTextLines.items[ui.sidePanelTextLines.size]:Hide();
     end

     ui.sidePanelRootFrame:Show();
end

local function DM_RouteBuilder_SetDefaultUI()
    -- local ctx = DM_RouteBuilder_GetCurrentDungeonContext();
    local dungeonCtx = DM_Dungeons_GetDungeonByIndex(1); -- we're cheating here, but not really
    local floors = dungeonCtx.config.floorMapInfo;

    uiContext.currentDungeonContext = dungeonCtx;
    uiContext.currentDungeonIndex = 1;
    uiContext.currentFloorIndex = 1;

    if dungeonCtx.config.floorCount > 1 then
        UIDropDownMenu_Initialize(ui.dropdowns.dungeonFloor, 
            function(self, level, menuList)
                for i = 1, dungeonCtx.config.floorCount do
                   local info = UIDropDownMenu_CreateInfo();
                   info.text, info.hasArrow, info.arg1, info.func =
                        dungeonCtx.config.floorMapInfo[i].name, nil, i, DM_RouteBuilder_DropDown_FloorSelected;
                   UIDropDownMenu_AddButton(info);
                end
        end);

        UIDropDownMenu_SetText(ui.dropdowns.dungeonFloor, dungeonCtx.config.floorMapInfo[1].name);
        UIDropDownMenu_SetSelectedID(ui.dropdowns.dungeonFloor, 1);

        ui.dropdowns.dungeonFloor:Show();
    else
        ui.dropdowns.dungeonFloor:Hide();
    end

    uiContext.routes = DM_RouteBuilder_DungeonRoutes(uiContext.currentDungeonIndex);

    if uiContext.routes.size > 0 then
        uiContext.currentRoute = uiContext.routes.items[1];
        uiContext.currentRouteIndex = 1;

        if uiContext.currentRoute.selectedAreaKey and uiContext.currentRoute.selectedMobGroup then
            uiContext.selectedRouteItem = DM_RouteBuilder_GetRouteItemByPullGroup(uiContext.currentRoute, uiContext.currentRoute.selectedAreaKey, uiContext.currentRoute.selectedMobGroup);
        end
    else
        uiContext.currentRouteIndex = nil;
        uiContext.currentRoute = nil;
    end

    DM_RouteBuilder_RefreshRoutesDropdown();
end

local function DM_RouteBuilder_CreateRouteBuilderFrame()
    ui.routeBuilderRootFrame = CreateFrame("Frame", "DM_RouteBuilder_RootFrame", UIParent, "BackdropTemplate");
    ui.routeBuilderRootFrame:SetBackdrop(DM_Tex_CreateBackdrop());

    DM_Colors_SetFrameBackdropColors(ui.routeBuilderRootFrame);
    ui.routeBuilderRootFrame:SetMovable(true);
    ui.routeBuilderRootFrame:SetResizable(false);
    ui.routeBuilderRootFrame:EnableMouse(true);
    ui.routeBuilderRootFrame:SetPoint("CENTER");
    ui.routeBuilderRootFrame:SetSize(ROUTEBUILDER_UI_WIDTH, ROUTEBUILDER_UI_HEIGHT);
    ui.routeBuilderRootFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end);
    ui.routeBuilderRootFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);
    ui.routeBuilderRootFrame:Hide();

    ui.routeBuilderRootFrame.title = ui.routeBuilderRootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ui.routeBuilderRootFrame.title:ClearAllPoints();
    ui.routeBuilderRootFrame.title:SetFontObject("GameFontHighlight");
    ui.routeBuilderRootFrame.title:SetPoint("TOPLEFT", ui.routeBuilderRootFrame, "TOPLEFT", 10, -8);
    ui.routeBuilderRootFrame.title:SetText("Dungeon Mentor: Route Builder");

    local closeIcon = DM_Tex_CreateMainIcon(ui.routeBuilderRootFrame, "CIRCLE_X", 16, 16, "OVERLAY");

    closeIcon.parentWindow = ui.routeBuilderRootFrame;
    closeIcon:ClearAllPoints();
    closeIcon:SetPoint("TOPRIGHT", ui.routeBuilderRootFrame, "TOPRIGHT", -8, -6);
    closeIcon:EnableMouse(true);
    DM_Colors_SetIconColor(closeIcon, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    closeIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED);
    end);
    closeIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_ICON_NORMAL);
    end);
    closeIcon:SetScript("OnMouseUp", function(self)
        DM_RouteBuilder_Hide();
    end);

    ui.routeBuilderMapRootFrame = CreateFrame("Frame", "DM_RouteBuilder_MapRootFrame", ui.routeBuilderRootFrame);
    ui.routeBuilderMapRootFrame:SetSize(ROUTEBUILDER_UI_SOURCE_MAP_WIDTH, ROUTEBUILDER_UI_SOURCE_MAP_HEIGHT);
    ui.routeBuilderMapRootFrame:SetPoint("TOPLEFT", ui.routeBuilderRootFrame.title, "BOTTOMLEFT", -2, -2);
    
    ui.routeBuilderMapScrollFrame = CreateFrame("ScrollFrame", "DM_RouteBuilder_MapScrollFrame", ui.routeBuilderMapRootFrame);

    ui.routeBuilderMapScrollFrame:ClearAllPoints();
    ui.routeBuilderMapScrollFrame:SetSize(ROUTEBUILDER_UI_SOURCE_MAP_WIDTH, ROUTEBUILDER_UI_SOURCE_MAP_HEIGHT);
    ui.routeBuilderMapScrollFrame:SetAllPoints(ui.routeBuilderMapRootFrame);

    ui.routeBuilderMapPanelFrame = CreateFrame("Frame", "DM_RouteBuilder_MapPanelFrame", ui.routeBuilderRootFrame);
    ui.routeBuilderMapPanelFrame:ClearAllPoints();
    ui.routeBuilderMapPanelFrame:SetSize(ROUTEBUILDER_UI_SOURCE_MAP_WIDTH, ROUTEBUILDER_UI_SOURCE_MAP_HEIGHT);

    ui.routeBuilderMapScrollFrame:EnableMouseWheel(true);

    -- start scale: 1, min scale: 0.5, max scale: 1.5, step size: 0.05
    ui.routeBuilderMapScrollFrame:SetScript("OnMouseWheel", function(self,delta)
        local frameScale = ui.routeBuilderRootFrame:GetScale();
        if delta == -1 then
            frameScale = max(frameScale - 0.05, 0.5);
        else
            frameScale = min(frameScale + 0.05, 1.5);
        end
        ui.routeBuilderRootFrame:SetScale(frameScale);
        --DM_RouteBuilder_New_ReapplyZoomToMapMobMarkers();
        DM_RouteBuilder_ReapplyZoomToMapMobMarkers();
    end);

    -- NOTE: MDT uses both small (12 tile) and large (150 tile) maps, for DF season 1-3
    --       I did not see the large maps being used but if a future season digs deep enough into
    --       legacy WoW we'll likely need the 150 tile maps also.
    ui.routeBuilderMapPanelFrame.tiles = {};
    for i = 1, 12 do
        ui.routeBuilderMapPanelFrame.tiles[i] = ui.routeBuilderMapPanelFrame:CreateTexture("DM_RouteBuilder_MapPanelTile" .. i, "BACKGROUND", nil, 0);
        ui.routeBuilderMapPanelFrame.tiles[i]:SetDrawLayer("BORDER", 0);
        ui.routeBuilderMapPanelFrame.tiles[i]:SetSize(ui.routeBuilderMapRootFrame:GetWidth() / 4 + (5), 
                                                      ui.routeBuilderMapRootFrame:GetWidth() / 4 + (5));
    end

    ui.routeBuilderMapPanelFrame.tiles[1]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame, "TOPLEFT", 0, 0)
    ui.routeBuilderMapPanelFrame.tiles[2]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[1], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[3]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[2], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[4]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[3], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[5]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[1], "BOTTOMLEFT")
    ui.routeBuilderMapPanelFrame.tiles[6]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[5], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[7]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[6], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[8]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[7], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[9]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[5], "BOTTOMLEFT")
    ui.routeBuilderMapPanelFrame.tiles[10]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[9], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[11]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[10], "TOPRIGHT")
    ui.routeBuilderMapPanelFrame.tiles[12]:SetPoint("TOPLEFT", ui.routeBuilderMapPanelFrame.tiles[11], "TOPRIGHT")

    ui.routeBuilderMapScrollFrame:SetScrollChild(ui.routeBuilderMapPanelFrame);

    ui.mapButtons.pullNumberAnnotation = DM_Tex_CreateRouteBuilderIcon(ui.routeBuilderMapPanelFrame, "NUMBER", 32, 32, "OVERLAY");

    ui.mapButtons.pullNumberAnnotation:ClearAllPoints();
    DM_Colors_SetIconColor(ui.mapButtons.pullNumberAnnotation, COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION);
    ui.mapButtons.pullNumberAnnotation:SetPoint("TOPRIGHT", ui.routeBuilderMapPanelFrame, "TOPRIGHT", -8, -48);
    ui.mapButtons.pullNumberAnnotation:Show();
    ui.mapButtons.pullNumberAnnotation:EnableMouse(true);
    ui.mapButtons.pullNumberAnnotation:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_HIGHLIGHTED);

        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:ClearLines();
        local visState = "show";
        if uiContext.mapAnnotations.pullNumbersEnabled then
            visState = "hide";
        end
        GameTooltip:AddLine("Click to " .. visState .. " pull order on map");
        GameTooltip:Show();
    end);
    ui.mapButtons.pullNumberAnnotation:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
        DM_Colors_SetIconColor(self, COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION);
    end);
    ui.mapButtons.pullNumberAnnotation:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            DM_RouteBuilder_Map_TogglePullNumbers();

            if uiContext.mapAnnotations.pullNumbersEnabled then
                DM_Tex_ChangeRouteBuilderIcon(self, "NUMBER_FILLED");
            else
                DM_Tex_ChangeRouteBuilderIcon(self, "NUMBER");
            end

            DM_RouteBuilder_RefreshUi();
        end
    end);

    ui.routeBuilderMapRootFrame:Hide();
    ui.routeBuilderMapScrollFrame:Hide();
    ui.routeBuilderMapPanelFrame:Hide();

    ui.routeBuilderRootFrame:Hide();

    ui.routeBuilderRootFrame:SetFrameLevel(10);
    ui.routeBuilderMapRootFrame:SetFrameLevel(11);
    ui.routeBuilderMapScrollFrame:SetFrameLevel(12);
    ui.routeBuilderMapPanelFrame:SetFrameLevel(13);

    DM_RouteBuilder_CreateSidePanel();

    DM_RouteBuilder_SetDefaultUI();

    DM_RouteBuilder_RefreshUi();
end

------------------------------------------------------------------------------
-- External UI Control
------------------------------------------------------------------------------

function DM_RouteBuilder_Hide()
    ui.routeBuilderMapRootFrame:Hide();
    ui.routeBuilderMapScrollFrame:Hide();
    ui.routeBuilderMapPanelFrame:Hide();

    ui.routeBuilderRootFrame:Hide();
end

function DM_RouteBuilder_Show()
    if not ui.routeBuilderRootFrame then
        DM_RouteBuilder_CreateRouteBuilderFrame();
    end

    if not ui.routeBuilderRootFrame:IsVisible() then
        ui.routeBuilderMapRootFrame:Show();
        ui.routeBuilderMapScrollFrame:Show();
        ui.routeBuilderMapPanelFrame:Show();

        ui.routeBuilderRootFrame:Show();
    end
end

function DM_RouteBuilder_Toggle()
    if ui.routeBuilderRootFrame and ui.routeBuilderRootFrame:IsVisible() then
        DM_RouteBuilder_Hide();
    else
        DM_RouteBuilder_Show();
    end
end

---------------------------------------------------------------------------------------
-- Chat hooks for route sharing. "borrowed" from weak auras and slightly adjusted
---------------------------------------------------------------------------------------

local dmAddonName = "DungeonMentor";

local function filterFunc(_, event, msg, player, l, cs, t, flag, channelId, ...)
    if flag == "GM" or flag == "DEV" or (event == "CHAT_MSG_CHANNEL" and type(channelId) == "number" and channelId > 0) then
      return
    end

    local newMsg = "";
    local remaining = msg;
    local done;
    repeat
      local start, finish, characterName, displayName = remaining:find("%[" .. dmAddonName .. ": ([^%s]+) %- (.*)%]");
      if(characterName and displayName) then
        characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "");
        displayName = displayName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "");
        newMsg = newMsg..remaining:sub(1, start-1);
        newMsg = newMsg.."|Haddon:" .. dmAddonName .. "|h|cFF8800FF["..characterName.." |r|cFF8800FF- "..displayName.."]|h|r";
        remaining = remaining:sub(finish + 1);
      else
        done = true;
      end
    until(done)
    if newMsg ~= "" then
      local trimmedPlayer = Ambiguate(player, "none")
      if event == "CHAT_MSG_WHISPER" and not UnitInRaid(trimmedPlayer) and not UnitInParty(trimmedPlayer) then -- XXX: Need a guild check
        local _, num = BNGetNumFriends()
        for i=1, num do
          if C_BattleNet then -- introduced in 8.2.5 PTR
            local toon = C_BattleNet.GetFriendNumGameAccounts(i)
            for j=1, toon do
              local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(i, j);
              if gameAccountInfo.characterName == trimmedPlayer and gameAccountInfo.clientProgram == "WoW" then
                return false, newMsg, player, l, cs, t, flag, channelId, ...; -- Player is a real id friend, allow it
              end
            end
          end
        end
        return true -- Filter strangers
      else
        return false, newMsg, player, l, cs, t, flag, channelId, ...;
      end
   end
end

hooksecurefunc("SetItemRef", function(link, text)
    local _, _, characterName, displayName = text:find("|Haddon:" .. dmAddonName .. "|h|cFF8800FF%[([^%s]+) |r|cFF8800FF%- (.*)%]|h");

    if (link == "addon:" .. dmAddonName and characterName and displayName) then
      characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "");
      routeDetails = displayName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "");

      local bits = DM_Util_SplitString(characterName, "-");
      local charName, realmName = bits[1], bits[2];

      local _, _, zoneId, routeName = routeDetails:find("(%d+)%-(.*)");

      DM_RouteBuilder_RequestRoute(charName, realmName, zoneId, routeName);
    end
end)

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)

