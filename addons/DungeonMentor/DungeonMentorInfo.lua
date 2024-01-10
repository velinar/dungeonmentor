local infoEventsFrame = CreateFrame("FRAME", "dmInfoEventsFrame");

infoEventsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

infoEventsFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED");

local infoUI;
local infoTextScrollFrame;
local infoTextBox;

local maxHistoryEntries = 5;
local currentHistoryIndex = nil;

local infoTextHistory = {
   size = 0,
   items = {}
};

-- this always causes the view to flip to the text being set
function DM_Info_SetText(text)
    if not text then
        return;
    end

    if infoTextHistory.size < maxHistoryEntries then
        infoTextHistory.size = infoTextHistory.size + 1;
        infoTextHistory.items[infoTextHistory.size] = text;
        currentHistoryIndex = infoTextHistory.size;
        infoTextBox:SetText(text);
        infoTextBox:Show();
        return;
    end

    for i = 1, maxHistoryEntries-1 do
        infoTextHistory.items[i] = infoTextHistory.items[i+1];
    end

    infoTextHistory.items[maxHistoryEntries] = text;
    currentHistoryIndex = maxHistoryEntries;
    infoTextBox:SetText(text);
    infoTextBox:Show();
end

function DM_Info_PreviousInfo()
    if currentHistoryIndex and currentHistoryIndex > 1 then
        currentHistoryIndex = currentHistoryIndex - 1;
        infoTextBox:SetText(infoTextHistory.items[currentHistoryIndex]);
    end
end

function DM_Info_NextInfo()
    if currentHistoryIndex and currentHistoryIndex < infoTextHistory.size then
        currentHistoryIndex = currentHistoryIndex + 1;
        infoTextBox:SetText(infoTextHistory.items[currentHistoryIndex]);
    end
end

function DM_Info_MoveResize_OnMouseDown(self, button)
    if (button == "LeftButton") then
       self:StartMoving();
    elseif button == "RightButton" then
       self:StartSizing();
       self.isSizing = true;
    end
end

function DM_Info_MoveResize_OnMouseUp(self, button)
    self:StopMovingOrSizing();
    infoTextBox:SetWidth(infoTextScrollFrame:GetWidth() - 16);
end

function DM_Info_SetTestPassOneDefaultText()
    local text = "";

    text = text .. "Thank you for using Dungeon Mentor!\n\n";
    text = text .. "If you are reading this you are part of the first wave of users.\n\n";
    text = text .. "Look up Dungeon Mentor project on curseforge for official Discord information.\n\n";
    text = text .. "With your help I'd like to make this addon an invaluable tool for M+ players. I welcome all feedback.\n\n";
    text = text .. "Here are a few commands:\n";
    text = text .. "   /vdm options         Opens options for addon\n";
    text = text .. "   /vdm blizzard hide   Hides Blizzard's objective UI\n";
    text = text .. "   /vdm blizzard show   Shows Blizzard's objective UI\n\n";
    text = text .. "I hope you enjoy! - Velinar\n\n";

    DM_Info_SetText(text);
end

function DM_Info_InitWindow()
    DM_Info_CreateWindow();
end

function DM_Info_ShowWindow()
    DM_Info_CreateWindow();

    infoUI:Show();
end

function DM_Info_ResetWindow()
    infoUI:SetPoint("CENTER", UIParent, "CENTER");
end

function DM_Info_CreateWindow()
    if infoUI then
        return;
    end

    infoUI = CreateFrame("Frame", "DM_Info_Window", UIParent, "BackdropTemplate");

    infoUI:Hide();

    local iconWidth = 12;
    local iconHeight = 12;

    infoUI:SetBackdrop(DM_Tex_CreateBackdrop());
    DM_Colors_SetFrameBackdropColors(infoUI);

    infoUI:SetSize(320, 200);
    infoUI:SetPoint("CENTER", UIParent, "CENTER");
    infoUI:SetMovable(true);
    infoUI:SetResizable(true);
    infoUI:EnableMouse(true);
    infoUI:SetScript("OnMouseDown", DM_Info_MoveResize_OnMouseDown);
    infoUI:SetScript("OnMouseUp", DM_Info_MoveResize_OnMouseUp);

    infoUI.title = infoUI:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    infoUI.title:ClearAllPoints();
    infoUI.title:SetPoint("TOPLEFT", infoUI, "TOPLEFT", 10, -8);
    infoUI.title:SetText("Dungeon Mentor: Information");
    infoUI.title:Show();

    infoUI:SetScript("OnMouseWheel", function(self,delta)
        local frameScale = infoUI:GetScale();
        if delta == -1 then
            frameScale = max(frameScale - 0.1, 0.5);
        else
            frameScale = min(frameScale + 0.1, 1.5);
        end
        infoUI:SetScale(frameScale);
    end);

    local closeIcon = DM_Tex_CreateMainIcon(infoUI, "CIRCLE_X", iconWidth, iconHeight, "OVERLAY");

    closeIcon.parentWindow = infoUI;
    closeIcon:ClearAllPoints();
    closeIcon:SetPoint("TOPRIGHT", infoUI, "TOPRIGHT", -8, -6);
    closeIcon:EnableMouse(true);
    DM_Colors_SetIconColor(closeIcon, COLOR_KEY_STATUS_ICON_NORMAL);
    closeIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_HIGHLIGHTED);
    end);
    closeIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_NORMAL);
    end);
    closeIcon:SetScript("OnMouseUp", function(self)
        closeIcon.parentWindow:Hide();
    end);

    local infoScrollFrameId = "DM_Info_TextScrollFrame";
 
    infoTextScrollFrame = CreateFrame("ScrollFrame", infoScrollFrameId, infoUI, "UIPanelScrollFrameTemplate");

    -- ScrollBar
    -- ScrollBarScrollUpButton
    -- ScrollBarScrollDownButton

    local scrollBarLevel = _G[infoScrollFrameId .. "ScrollBar"]:GetFrameLevel();
    _G[infoScrollFrameId .. "ScrollBarScrollUpButton"]:SetFrameLevel(scrollBarLevel);
    _G[infoScrollFrameId .. "ScrollBarScrollDownButton"]:SetFrameLevel(scrollBarLevel);

    infoTextScrollFrame:ClearAllPoints();
    infoTextScrollFrame:SetPoint("TOPLEFT", infoUI, "TOPLEFT", 8, -40);
    infoTextScrollFrame:SetPoint("BOTTOMRIGHT", infoUI, "BOTTOMRIGHT", -28, 8);
 
    infoTextBox = CreateFrame("EditBox", nil, infoUI);
    infoTextBox:SetMultiLine(true);
    infoTextBox:SetHeight(1);
    infoTextBox:SetWidth(infoTextScrollFrame:GetWidth() - 16);
    infoTextBox:SetMaxLetters(99999);
    infoTextBox:SetFontObject(GameFontNormal);
    infoTextBox:SetMultiLine(true);
    infoTextBox:SetAutoFocus(false);
    infoTextBox:ClearFocus();
    infoTextBox:SetText("");
    DM_Info_SetTestPassOneDefaultText();
    infoTextBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);

    infoTextScrollFrame:SetScrollChild(infoTextBox);
 
    infoTextBox:Show();
    infoTextScrollFrame:Show();

    local nextIcon = DM_Tex_CreateMainIcon(infoUI, "CIRCLE_NEXT", 12, 12, "OVERLAY");

    nextIcon.parentWindow = infoUI;
    nextIcon:ClearAllPoints();
    DM_Colors_SetIconColor(nextIcon, COLOR_KEY_STATUS_ICON_NORMAL);

    nextIcon:EnableMouse(true);
    nextIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_HIGHLIGHTED);
    end);
    nextIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_NORMAL);
    end);
    nextIcon:SetScript("OnMouseUp", function(self)
        DM_Info_NextInfo();
    end);

    local prevIcon = DM_Tex_CreateMainIcon(infoUI, "CIRCLE_PREV", 12, 12, "OVERLAY");
    prevIcon.parentWindow = infoUI;
    DM_Colors_SetIconColor(prevIcon, COLOR_KEY_STATUS_ICON_NORMAL);

    prevIcon:EnableMouse(true);
    prevIcon:SetScript("OnEnter", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_HIGHLIGHTED);
    end);
    prevIcon:SetScript("OnLeave", function(self)
        DM_Colors_SetIconColor(self, COLOR_KEY_STATUS_ICON_NORMAL);
    end);
    prevIcon:SetScript("OnMouseUp", function(self)
        DM_Info_PreviousInfo();
    end);

    prevIcon:ClearAllPoints();

    prevIcon:SetPoint("BOTTOMLEFT", infoTextScrollFrame, "TOPLEFT", 2, 4);
    nextIcon:SetPoint("TOPLEFT", prevIcon, "TOPRIGHT", 4, 0);
end

function handleListAppInfoUpdated(searchResultId, newInfo, oldInfo, groupName)
    local header = nil;

    if newInfo == "invited" then
        header = "You're invited to the following group:\n\n";
    elseif newInfo == "inviteaccepted" then
        header = "You accepted an invitation to the following group:\n\n";
    end

    if header then
        local info = C_LFGList.GetSearchResultInfo(searchResultId);

        local activityInfo = C_LFGList.GetActivityInfoTable(info.activityID);

        --print("info secure: " .. tostring(issecurevariable(info)));
        --print("activityInfo secure: " .. tostring(issecurevariable(activityInfo)));

        local fullName = activityInfo.fullName; -- Brackenhide Hollow (Mythic Keystone)
        local shortName = activityInfo.shortName; -- Mythic+
        local categoryID = activityInfo.categoryID; -- 2
        local isMythicPlusActivity = activityInfo.isMythicPlusActivity; -- true

        if isMythicPlusActivity then
          local title = info.name;
          local zone = tostring(fullName);
          local lead = info.leaderName;
          local body = info.comment;

          local text = header .. "ZONE: " .. tostring(zone)
                              .. "\nLEADER: " .. tostring(lead)
                              .. "\n\n" .. tostring(body) .. "  ";

          print("(Dungeon Mentor Group Notification)");
          print(header);
          print("  GROUP: " .. title);
          print("  DUNGEON: " .. zone);
          print("  LEADER: " .. lead);
          print("  DESCRIPTION: " .. body);

          DM_Info_SetText(text);
       end
    end
end

-- https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT
local function handleCombatLogEventUnfiltered(...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...;
    local spellId, spellName, spellSchool, failedType;
    local auraType;
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, absorbed;
end

local function handleGameEvent(self, event, ...)
    if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
        handleListAppInfoUpdated(...);
    end
end

infoEventsFrame:SetScript("OnEvent", handleGameEvent);

