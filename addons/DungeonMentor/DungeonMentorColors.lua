-- colors

--window:SetBackdropBorderColor(79/255, 115/255, 142/255);
--window:SetBackdropColor(79/255, 115/255, 142/255, 1.0);

-- note, string colors are in ARGB format
-- local uiColors = {
--     iconNormal = { r=230/255, g=159/255, b=0/255, a=1 },
--     iconHighlight = { r=213/255, g=94/255, b=0/255, a=1 },
--     iconDepressed = { r=0/255, g=114/255, b=178/255, a=1 },
--     iconDisabled = { r=96/255, g=96/255, b=96/255, a=1 },
--     textHeader = { r=86/255, g=180/255, b=1, a=233/255 },
--     textNormal = { r=1, g=1, b=1, a=1 },
--     defaultAnnotationText = { r = 1, g = 0.5, b = 0, a = 1 },
--     -- stop = { r = 136, g = 34, b = 85, a = 1, str = "FF882255" },
--     stop = { r = 220/255, g = 38/255, b = 127/255, a = 1, str = "FFDC267F" },
--     warning = { r = 240/255, g = 228/255, b = 66/255, a = 1, str = "FFF0E442" },
--     ok = { r = 0, g = 1, b = 100/255, a = 1, str = "FF00FF99"}
--     -- ok = { r = 0, g = 158/255, b = 115/255, a = 1, str = "FF009E73" }
-- };

-- function DM_Colors_UiColors()
--     return uiColors;
-- end

-- function DM_Colors_SetBackdropColors(frame)
--     frame:SetBackdropBorderColor(79/255, 115/255, 142/255);
--     frame:SetBackdropColor(79/255, 115/255, 142/255, 1.0);
-- end

-- function DM_Colors_SetIconColor_Normal(icon)
--     icon:SetVertexColor(uiColors.iconNormal.r, uiColors.iconNormal.g, uiColors.iconNormal.b, uiColors.iconNormal.a);
-- end

-- function DM_Colors_SetIconColor_Highlighted(icon)
--     icon:SetVertexColor(uiColors.iconHighlight.r, uiColors.iconHighlight.g, uiColors.iconHighlight.b, uiColors.iconHighlight.a);
-- end

-- function DM_Colors_SetIconColor_Depressed(icon)
-- end

-- function DM_Colors_SetIconColor_OK(icon)
--     icon:SetVertexColor(uiColors.ok.r, uiColors.ok.g, uiColors.ok.b, uiColors.ok.a);
-- end

-- local pullLineColors = {
--     areaHeader = { r=20/255, g=20/255, b=20/255, a=1 },

--     -- GREY
--     inactiveMob = { r=167/255, g=173/255, b=187/255, a=1 },

--     -- GREEN
--     currentPullLivingMob = { r=0, g=0.4, b=0, a=1 },

--     -- RED
--     currentPullDeadMob = { r=0.4, g=0, b=0, a=1 },

--     -- rgb(255, 172, 28) bright orange
--     linkedPullGroupStartNotPulled = { r=255/255, g=172/255, b=28/255, a=1 },

--     -- cyan
--     -- linkedPullGroupNotPulled = { r=0, g=0.6, b=0.6, a=1 },
--     linkedPullGroupNotPulled = { r=128/255, g=86/255, b=14/255, a=1 },

--     -- yellow
--     nextPullGroupUnlinked = { r=160/255, g=160/255, b=0, a=1 },

--     -- purple
--     annotation = { r = 137/255, g = 0/255, b = 174/255, a = 1 }, -- 227,185,255

--     -- black / unknown
--     unknownStatus = { r = 0, g = 0, b = 0, a = 1 }
-- };

COLOR_KEY_GENERAL_BACKDROP = "Colors.General.Backdrop";
COLOR_KEY_GENERAL_BACKDROP_BORDER = "Colors.General.BackdropBorder";
COLOR_KEY_GENERAL_NORMAL_TEXT = "Colors.General.NormalText";
COLOR_KEY_GENERAL_HEADER_TEXT = "Colors.General.HeaderText";
COLOR_KEY_GENERAL_ANNOTATION_TEXT = "Colors.General.AnnotationText";
COLOR_KEY_GENERAL_LOW = "Colors.General.Low";
COLOR_KEY_GENERAL_MEDIUM= "Colors.General.Medium";
COLOR_KEY_GENERAL_HIGH = "Colors.General.High";
COLOR_KEY_GENERAL_ICON_NORMAL = "Colors.General.NormalIcon";
COLOR_KEY_GENERAL_ICON_HIGHLIGHTED = "Colors.General.HighlightedIcon";
COLOR_KEY_GENERAL_ICON_DISABLED = "Colors.General.DisabledIcon";

COLOR_KEY_ROUTEBUILDER_STATUSBAR_SELECTED = "Colors.RouteBuilder.StatusBarSelected";
COLOR_KEY_ROUTEBUILDER_STATUSBAR_NORMAL = "Colors.RouteBuilder.StatusBarNormal";
COLOR_KEY_ROUTEBUILDER_GROUP_HEADER_TEXT = "Colors.RouteBuilder.GroupHeaderText";
COLOR_KEY_ROUTEBUILDER_NORMAL_TEXT = "Colors.RouteBuilder.NormalText";
COLOR_KEY_ROUTEBUILDER_ICON_NORMAL = "Colors.RouteBuilder.NormalIcon";
COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED = "Colors.RouteBuilder.HighlightedIcon";
COLOR_KEY_ROUTEBUILDER_ICON_DISABLED = "Colors.RouteBuilder.DisabledIcon";
COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION = "Colors.RouteBuilder.MapAnnotation";
COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_HIGHLIGHTED = "Colors.RouteBuilder.MapAnnotationHighlighted";
COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_TEXT = "Colors.RouteBuilder.MapAnnotationText";

COLOR_KEY_PULLTRACKER_AREAHEADER = "Colors.PullTracker.AreaHeader";
COLOR_KEY_PULLTRACKER_INACTIVE = "Colors.PullTracker.Inactive";
COLOR_KEY_PULLTRACKER_ACTIVE = "Colors.PullTracker.Active";
COLOR_KEY_PULLTRACKER_DEAD = "Colors.PullTracker.Dead";
COLOR_KEY_PULLTRACKER_LINKEDPULLSTART = "Colors.PullTracker.LinkedPullStart";
COLOR_KEY_PULLTRACKER_LINKEDPULL = "Colors.PullTracker.LinkedPull";
COLOR_KEY_PULLTRACKER_NEXTGROUP = "Colors.PullTracker.NextGroup";
COLOR_KEY_PULLTRACKER_ANNOTATION = "Colors.PullTracker.Annotation";
COLOR_KEY_PULLTRACKER_ROUTE_NOTE = "Colors.PullTracker.RouteNote";
COLOR_KEY_PULLTRACKER_SKIPPED = "Colors.PullTracker.Skipped";
COLOR_KEY_PULLTRACKER_UNKNOWN = "Colors.PullTracker.Unknown";

COLOR_KEY_PULLTRACKER_ICON_NORMAL = "Colors.PullTracker.NormalIcon";
COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED = "Colors.PullTracker.HighlightedIcon";
COLOR_KEY_PULLTRACKER_ICON_DISABLED = "Colors.PullTracker.DisabledIcon";

COLOR_KEY_STATUS_ICON_NORMAL = "Colors.Status.NormalIcon";
COLOR_KEY_STATUS_ICON_HIGHLIGHTED = "Colors.Status.HighlightedIcon";
COLOR_KEY_STATUS_ICON_DISABLED = "Colors.Status.DisabledIcon";

local defaultColors = {
    [COLOR_KEY_PULLTRACKER_AREAHEADER] = {r=20/255, g=20/255, b=20/255, a=1},
    [COLOR_KEY_PULLTRACKER_INACTIVE] = { r=167/255, g=173/255, b=187/255, a=1 },
    [COLOR_KEY_PULLTRACKER_ACTIVE] = { r=0, g=0.4, b=0, a=1 },
    [COLOR_KEY_PULLTRACKER_DEAD] = { r=0.4, g=0, b=0, a=1 },
    [COLOR_KEY_PULLTRACKER_LINKEDPULLSTART] = { r=255/255, g=172/255, b=28/255, a=1 },
    [COLOR_KEY_PULLTRACKER_LINKEDPULL] = { r=128/255, g=86/255, b=14/255, a=1 },
    [COLOR_KEY_PULLTRACKER_NEXTGROUP] = { r=160/255, g=160/255, b=0, a=1 },
    [COLOR_KEY_PULLTRACKER_ANNOTATION] = { r = 137/255, g = 0/255, b = 174/255, a = 1 },
    [COLOR_KEY_PULLTRACKER_ROUTE_NOTE] = { r = 60/255, g = 100/255, b = 60/255, a = 1 },
    [COLOR_KEY_PULLTRACKER_SKIPPED] = { r = 0, g = 0, b = 0, a = 1 },
    [COLOR_KEY_PULLTRACKER_UNKNOWN] = { r = 0, g = 0, b = 0, a = 1 },
    [COLOR_KEY_PULLTRACKER_ICON_NORMAL] = { r=230/255, g=159/255, b=0, a=1 },
    [COLOR_KEY_PULLTRACKER_ICON_HIGHLIGHTED] = { r=213/255, g=94/255, b=0, a=233/255 },
    [COLOR_KEY_PULLTRACKER_ICON_DISABLED] = { r=86/255, g=180/255, b=1, a=233/255 },

    [COLOR_KEY_GENERAL_BACKDROP] = {r=79/255, g=115/255, b=142/255, a=1.0},
    [COLOR_KEY_GENERAL_BACKDROP_BORDER] = {r=79/255, g=115/255, b=142/255, a=1.0},
    [COLOR_KEY_GENERAL_NORMAL_TEXT] = {r=1,g=1,b=1,a=1},
    [COLOR_KEY_GENERAL_HEADER_TEXT] = {r=86/255, g=180/255, b=1, a=233/255},
    [COLOR_KEY_GENERAL_ANNOTATION_TEXT] = {r=1,g=0.5,b=0,a=1},
    [COLOR_KEY_GENERAL_ICON_NORMAL] = { r=230/255, g=159/255, b=0, a=1 },
    [COLOR_KEY_GENERAL_ICON_HIGHLIGHTED] = { r=213/255, g=94/255, b=0, a=233/255 },
    [COLOR_KEY_GENERAL_ICON_DISABLED] = { r=86/255, g=180/255, b=1, a=233/255 },

    --[COLOR_KEY_GENERAL_LOW] = { r = 220/255, g = 38/255, b = 127/255, a = 1 },
    --[COLOR_KEY_GENERAL_MEDIUM] = {r = 240/255, g = 228/255, b = 66/255, a = 1},
    [COLOR_KEY_GENERAL_LOW] = { r = 1, g = 0, b = 0, a = 1 },
    [COLOR_KEY_GENERAL_MEDIUM] = {r = 1, g = 1, b = 0, a = 1},
    [COLOR_KEY_GENERAL_HIGH] = {r = 0, g = 1, b = 100/255, a = 1},
    [COLOR_KEY_ROUTEBUILDER_STATUSBAR_SELECTED] = {r=0,g=0,b=0.8,a=1},
    [COLOR_KEY_ROUTEBUILDER_STATUSBAR_NORMAL] = {r=0,g=0,b=0.4,a=1},
    [COLOR_KEY_ROUTEBUILDER_GROUP_HEADER_TEXT] = { r=86/255, g=180/255, b=1, a=233/255 },
    [COLOR_KEY_ROUTEBUILDER_NORMAL_TEXT] = { r=1, g=1, b=1, a=1 },
    [COLOR_KEY_ROUTEBUILDER_ICON_NORMAL] = { r=230/255, g=159/255, b=0, a=1 },
    [COLOR_KEY_ROUTEBUILDER_ICON_HIGHLIGHTED] = { r=213/255, g=94/255, b=0, a=233/255 },
    [COLOR_KEY_ROUTEBUILDER_ICON_DISABLED] = { r=96/255, g=96/255, b=96/255, a=1 },
    [COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION] = {r=140/255, g=200/255, b=210/255, a=1.0},
    [COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_HIGHLIGHTED] = {r=160/255, g=220/255, b=235/255, a=1.0},
    [COLOR_KEY_ROUTEBUILDER_MAP_ANNOTATION_TEXT] = { r=255/255, g=255/255, b=255/255, a=1.0 },

    [COLOR_KEY_STATUS_ICON_NORMAL] = { r=230/255, g=159/255, b=0, a=1 },
    [COLOR_KEY_STATUS_ICON_HIGHLIGHTED] = { r=213/255, g=94/255, b=0, a=233/255 },
    [COLOR_KEY_STATUS_ICON_DISABLED] = { r=86/255, g=180/255, b=1, a=233/255 },
};

function DM_Colors_ToHexString(r, g, b, a)
   return string.format("%02x", a*255) .. 
          string.format("%02x", r*255) ..
          string.format("%02x", g*255) ..
          string.format("%02x", b*255);
end

function DM_Colors_GetColor(key)
    local c = DM_Options_DataRoot()[key] or defaultColors[key];
    --local c = defaultColors[key];

    return c;
end

function DM_Colors_GetColorString(key)
    local c = DM_Options_DataRoot()[key] or defaultColors[key];

    return DM_Colors_ToHexString(c.r, c.g, c.b, c.a);
end

function DM_Colors_SaveColor(key, r, g, b, a)
    DM_Options_DataRoot()[key] = {r=r, g=g, b=b, a=a};
end

function DM_Colors_SetTextColor(text, key)
   local c = DM_Colors_GetColor(key);

   text:SetTextColor(c.r, c.g, c.b, c.a);
end

function DM_Colors_SetStatusBarColor(statusBar, key)
   local c = DM_Colors_GetColor(key);

   if c and statusBar then
    statusBar:SetStatusBarColor(c.r, c.g, c.b, c.a);
   end
end

function DM_Colors_SetIconColor(icon, key)
    local c = DM_Colors_GetColor(key);

    if c and icon then
        icon:SetVertexColor(c.r, c.g, c.b, c.a);
    end
end

function DM_Colors_SetFrameBackdropColors(frame)
    local backdrop = DM_Colors_GetColor(COLOR_KEY_GENERAL_BACKDROP);
    local backdropBorder = DM_Colors_GetColor(COLOR_KEY_GENERAL_BACKDROP_BORDER);

    frame:SetBackdropColor(backdrop.r, backdrop.g, backdrop.b, backdrop.a);
    frame:SetBackdropBorderColor(backdropBorder.r, backdropBorder.g, backdropBorder.b, backdropBorder.a);
end

-- defaulting to black - but we'll control it here so we can alter in future
function DM_Colors_SetDefaultBackdropColor(frame)
    frame:SetBackdropColor(0,0,0);
end

-- function DM_Colors_SetPull_AreaHeader(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_AREAHEADER);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     --pg.mobDetails:SetStatusBarColor(pullLineColors.areaHeader.r, pullLineColors.areaHeader.g, 
--     --                                pullLineColors.areaHeader.b, pullLineColors.areaHeader.a);
-- end

-- function DM_Colors_SetPull_Unknown(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_UNKNOWN);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);
--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.unknownStatus.r, pullLineColors.unknownStatus.g, 
--     --                                pullLineColors.unknownStatus.b, pullLineColors.unknownStatus.a);
-- end

-- function DM_Colors_SetPull_Inactive(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_INACTIVE);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.inactiveMob.r, pullLineColors.inactiveMob.g, 
--     --                                pullLineColors.inactiveMob.b, pullLineColors.inactiveMob.a);
-- end

-- function DM_Colors_SetPull_CurrentPullLivingMob(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_ACTIVE);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.currentPullLivingMob.r, pullLineColors.currentPullLivingMob.g, 
--     --                                pullLineColors.currentPullLivingMob.b, pullLineColors.currentPullLivingMob.a);
-- end

-- function DM_Colors_SetPull_CurrentPullDeadMob(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_DEAD);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.currentPullDeadMob.r, pullLineColors.currentPullDeadMob.g, 
--     --                                pullLineColors.currentPullDeadMob.b, pullLineColors.currentPullDeadMob.a);
-- end

-- function DM_Colors_SetPull_LinkedPullStartNotPulled(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_LINKEDPULLSTART);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.linkedPullGroupStartNotPulled.r, pullLineColors.linkedPullGroupStartNotPulled.g, 
--     --                                pullLineColors.linkedPullGroupStartNotPulled.b, pullLineColors.linkedPullGroupStartNotPulled.a);
-- end

-- function DM_Colors_SetPull_LinkedPullNotPulled(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_LINKEDPULL);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.linkedPullGroupNotPulled.r, pullLineColors.linkedPullGroupNotPulled.g, 
--     --                                pullLineColors.linkedPullGroupNotPulled.b, pullLineColors.linkedPullGroupNotPulled.a);
-- end

-- function DM_Colors_SetPull_NextGroupUnlinked(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_NEXTGROUP);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.nextPullGroupUnlinked.r, pullLineColors.nextPullGroupUnlinked.g, 
--     --                                pullLineColors.nextPullGroupUnlinked.b, pullLineColors.nextPullGroupUnlinked.a);
-- end

-- function DM_Colors_SetPull_Annotation(pg)
--     local c = DM_Colors_GetColor(COLOR_KEY_PULLTRACKER_ANNOTATION);

--     pg.mobDetails:SetStatusBarColor(c.r, c.g, c.b, c.a);

--     -- pullLineRoot.mobDetails:SetStatusBarColor(0, 0.4, 0, 1);
--     --pg.mobDetails:SetStatusBarColor(pullLineColors.annotation.r, pullLineColors.annotation.g, 
--     --                                pullLineColors.annotation.b, pullLineColors.annotation.a);
-- end

function DM_Colors_HighPriority_SetNeutral(sb)
    sb:SetStatusBarColor(0,0,0,1);
end

-- if onRouteDeadPullGroups has the mob group in it, skip ahead
-- HEADER
-- #1: if group is active, it's the current pull
-- #2: if group is not active:
--     o if linkStatus == 1, color it 'linked pull group start, not pulled'
--     o if linkStatus == 2, color it 'linked pull group, not pulled'
--     o if linkStatus == 0 and previous group is active, color it 'next pull unlinked'
--     o if linkStatus == 0 and previous group is inactive, color it 'inactive'

-- MOBS
-- #1: if group is active and mob is not dead, color it 'current pull living mob'
-- #2: if group is active and mob is dead, color it 'current pull dead mob'
-- #3: if group is not active and linkStatus==1, color it 'linked pull group start, not pulled'
-- #4: if group is not active and linkStatus==2, color it 'linked pull group, not pulled'
-- #5: if group is not active and linkStatus==0 and previous group is active, color it 'next group, unlinked'
-- #6: otherwise, color it inactive
