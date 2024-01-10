local dmCoreEventsFrame = CreateFrame("FRAME", "dmCoreEventsFrame");

dmCoreEventsFrame:RegisterEvent("ADDON_LOADED");

local addonChatPrefix = "DungeonMentor";

local DM_OPTIONS_IMMEDIATE_ACTION_ENABLED = "General.ImmediateActionEnabled";
local DM_OPTIONS_HIDE_BLIZZARD_UI = "General.HideBlizzardUi";

if not DM_Options then
    DM_Options = {[DM_OPTIONS_IMMEDIATE_ACTION_ENABLED] = true, [DM_OPTIONS_HIDE_BLIZZARD_UI] = false};
end

if not DM_GlobalOptions then
    DM_GlobalOptions = {[DM_OPTIONS_IMMEDIATE_ACTION_ENABLED] = true, [DM_OPTIONS_HIDE_BLIZZARD_UI] = false};
end

function DM_Core_ToggleShown()
   DM_Trackers_ShowWindow();
   DM_Info_ShowWindow();
end

function DM_Core_CreateWindows()
    DM_Trackers_InitWindows();
    DM_Info_InitWindow();
end

local function HandleSlashCommands(str)
    local bits = nil;

    if str == nil or str == "" then
        print("Dungeon Mentor Slash Commands");

        print("/vdm show: shows dungeon mentor windows");
        print("/vdm options: opens options window");
        print("/vdm route show: shows the route builder UI");
        print("/vdm blizzard hide: hides Blizzard's M+ UI");
        print("/vdm blizzard show: shows Blizzard's M+ UI");

        return;
    end

    if str == "show" then
        DM_Trackers_ShowWindow();
        DM_Info_ShowWindow();
    end

    if str == "options" then
        DM_Options_Show();
    end

    if str == "blizzard hide" then
        ObjectiveTrackerFrame:Hide();
    end

    if str == "blizzard show" then
        ObjectiveTrackerFrame:Show();
    end

    if str == "route show" then
        DM_RouteBuilder_Toggle();
    end

    if str == "dawn 1" then
        DM_Util_PrintSystemMessage("Dawn of the Infinites set to Galakrond's Fall. If you need to change this, type: /vdm dawn 2");
        DM_Dungeons_SetZoneDiscriminator(1);
    end

    if str == "dawn 2" then
        DM_Util_PrintSystemMessage("Dawn of the Infinites set to Murozond's Rise. If you need to change this, type: /vdm dawn 1");
        DM_Dungeons_SetZoneDiscriminator(2);
    end

    if str == "test" then
        DM_Options_OptionTest();
    end
end

local function handleGameEvent(self, event, ...)
--    if event == "WORLD_STATE_TIMER_START" then
--       worldStateTimerId = select(3, ...);
--       return;
--    end

   if event == "ADDON_LOADED" then
      local addonName = ...;

      if addonName == "DungeonMentor" then
         SLASH_DungeonMentor1 = "/vdm";
         SlashCmdList.DungeonMentor = HandleSlashCommands;
         successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix(addonChatPrefix);

         DM_Group_RefreshMembers();
         --DM_Core_ToggleShown();
         DM_Core_CreateWindows();
         DM_Util_PrintSystemMessage("Dungeon Mentor running. To view, type /vdm show");

         DM_Patch_Data_ZoneIdsToIndex();
      end
   end
end

local blizzAddonOptionsStub = CreateFrame("Frame", "DM_Blizz_OptionsStub", UIParent);
blizzAddonOptionsStub.name = "Dungeon Mentor";
blizzAddonOptionsStub:Hide();

blizzAddonOptionsStub:SetScript("OnShow", function(self)
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
	title:SetPoint("TOPLEFT", 16, -16);
	title:SetText("Dungeon Mentor");

	local context = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	context:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8);
	context:SetText("To view options, type /vdm options");

	local open = CreateFrame("Button", nil, self, "UIPanelButtonTemplate");
	open:SetText("Open Options");
	open:SetWidth(160);
	open:SetHeight(24);
	open:SetPoint("TOPLEFT", context, "BOTTOMLEFT", 0, -30);
	open.tooltipText = "";
	open:SetScript("OnClick", function()
		DM_Options_Show();
	end)

	self:SetScript("OnShow", nil);
end);

if Settings and Settings.RegisterCanvasLayoutCategory then
	local category, layout = Settings.RegisterCanvasLayoutCategory(blizzAddonOptionsStub, "Dungeon Mentor");
	Settings.RegisterAddOnCategory(category);
else
	InterfaceOptions_AddCategory(blizzAddonOptionsStub);
end

dmCoreEventsFrame:SetScript("OnEvent", handleGameEvent);
