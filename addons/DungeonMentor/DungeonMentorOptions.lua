
local DM_OPTIONS_PER_CHARACTER_SETTINGS = "General.PerCharacterSettings";
local DM_OPTIONS_IMMEDIATE_ACTION_ENABLED = "General.ImmediateActionEnabled";
local DM_OPTIONS_HIDE_BLIZZARD_UI = "General.HideBlizzardUi";

-- this tracks options that are ONLY at the global scope
local globalOptionList = {
    [DM_OPTIONS_PER_CHARACTER_SETTINGS] = 1
};

function DM_Options_DataRoot()
    if DM_GlobalOptions[DM_OPTIONS_PER_CHARACTER_SETTINGS] then
      return DM_Options;
    end

    return DM_GlobalOptions;
end

function DM_Options_CharacterDataRoot()
    return DM_Options;
end

function DM_Options_SetOption(key, value)
    if globalOptionList[key] then
        DM_GlobalOptions[key] = value;
        return;
    end

    DM_Options_DataRoot()[key] = value;
end

function DM_Options_GetOption(key)
    if globalOptionList[key] then
      return DM_GlobalOptions[key];
    end

    return DM_Options_DataRoot()[key];
end

local colorOptionDefaults = {
   
};

local colorOptions = {
   ["WINDOW_HEADER_BG"] = 1,
   ["WINDOW_HEADER_TEXT"] = 2,
   ["WINDOW_BG"] = 3,
   ["WINDOW_CONTENT_BG"] = 4,
   ["WINDOW_CONTENT_TEXT"] = 5,
   ["WINDOW_STAUTS_LEFT_TEXT"] = 6,
   ["WINDOW_STAUTS_RIGHT_TEXT"] = 7
   -- window header background
   -- window header foreground [text]
   -- window background
   -- status text background
   -- status text foreground
   -- main window status text left
   -- main window status text right
};

local r,g,b,a = 1, 0, 0, 1;

local activeStatusBar = nil;

local optionsFrame = nil;
local generalOptionsPane = nil;
local pullTrackerOptionsPane = nil;

local optionPanes = {
    size = 0,
    items = {}
};

local function pullTrackerLineColorCallback(restore)
   if not activeStatusBar then
      return;
   end

   local newR, newG, newB, newA;
  
   if restore then
      newR, newG, newB, newA = unpack(restore);
   else
      newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
   end
 
   r, g, b, a = newR, newG, newB, newA;

   activeStatusBar:SetStatusBarColor(r, g, b, a);
   DM_Colors_SaveColor(activeStatusBar.colorKey, r, g, b, a);

   if DM_Trackers_RefreshPullTracker then
      DM_Trackers_RefreshPullTracker();
   end
end

local function DM_Options_SaveIconColor(restore, icon)
   local newR, newG, newB, newA;

   if restore then
    newR, newG, newB, newA = unpack(restore);
   else
    newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
   end
   
   r, g, b, a = newR, newG, newB, newA;

   icon:SetVertexColor(r, g, b, a);
   
   ColorPickerFrame.func = function() end;
   ColorPickerFrame.opacityFunc = function() end;
   ColorPickerFrame.cancelFunc = function() end;
end

local function ShowColorPicker(r, g, b, a, changedCallback)
   ColorPickerFrame:SetColorRGB(r,g,b);
   ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
   ColorPickerFrame.previousValues = {r,g,b,a};
   ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback;
   ColorPickerFrame:Hide(); -- Needed to run the OnShow handler.
   ColorPickerFrame:Show();
end

local optionsDropDown = nil;

local function DM_Options_CategoryClicked(self, arg1, arg2, checked)
   UIDropDownMenu_SetSelectedID(optionsDropDown, arg1);

   for i = 1, optionPanes.size do
      optionPanes.items[i]:Hide();
   end

   if not optionPanes.items[arg1] then
       print("no options pane at index " .. tostring(arg1));
   else
       optionPanes.items[arg1]:Show();
   end
end

local mainInterfaceIconsTextureFile = "Interface\\AddOns\\DungeonMentor\\textures\\main_interface_icons";

local function DM_Options_CreateText(rootFrame, relativeFrame, xOfs, yOfs)
   local t = rootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");

   t:ClearAllPoints();
   t:SetPoint("TOPLEFT", relativeFrame or rootFrame, "TOPRIGHT", xOfs or 0, yOfs or 0);
   t:SetJustifyH("LEFT");
   t:SetWordWrap(false);
   t:SetTextColor(1, 1, 1, 1);
   t:SetText("");

   return t;
end

local mainInterfaceIcons = {
   sourceImageWidth = 2048,
   iconWidth = 128,
   iconHeight = 128,
   horizCount = 10,
   vertCount = 1
};

function DM_Options_GetInterfaceIconCoords(iconIndex)
   return { left=( (iconIndex-1)*mainInterfaceIcons.iconWidth )/(mainInterfaceIcons.sourceImageWidth), right=(iconIndex*mainInterfaceIcons.iconWidth)/(mainInterfaceIcons.sourceImageWidth), top=0, bottom=1 };
end

local function DM_Options_CreateColorIcon(label, rootFrame, relativeUiElement, xOfs, yOfs)
   local colorIcon = rootFrame:CreateTexture(nil, "OVERLAY", nil, 0);
   colorIcon:SetTexture(mainInterfaceIconsTextureFile);

   coord = DM_Options_GetInterfaceIconCoords(13);
   colorIcon:SetTexCoord(coord.left, coord.right, coord.top, coord.bottom);
   colorIcon:SetWidth(18);
   colorIcon:SetHeight(18);
   colorIcon:ClearAllPoints()
   colorIcon:SetVertexColor(79/255, 115/255, 142/255, 1); -- window:SetBackdropBorderColor(79/255, 115/255, 142/255);
   colorIcon:SetPoint("TOPLEFT", relativeUiElement, "BOTTOMLEFT", xOfs or 0, yOfs or 0);
   colorIcon:Show();

   colorIcon:EnableMouse(true);
   colorIcon:SetScript("OnMouseUp", function(self, button)
      if (button == "LeftButton") then
          ShowColorPicker(79/255, 115/255, 142/255, 1, function(restore) print("saving icon color for: " .. label); DM_Options_SaveIconColor(restore, colorIcon) end);
      end
   end);

   return colorIcon;
end

local function CreateCheckboxOption(rootFrame, relativeFrame, anchor, name, text, xOfs, yOfs)
   local cb = CreateFrame("CheckButton", name, rootFrame, "ChatConfigCheckButtonTemplate");
   cb:SetPoint("TOPLEFT", relativeFrame, anchor, xOfs, yOfs);

   cb:Show();

   local label = rootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   label:SetPoint("TOPLEFT", cb, "TOPRIGHT", 4, -6);
   label:SetText(text);
   label:Show();

   return cb, label;
end

local function DM_Options_CreateGeneralPane(rootFrame, baseRelativeUiElement)
  generalOptionsPane = CreateFrame("frame", "DM_Options_GeneralPane", rootFrame);

  local perCharacterOptions, _ = CreateCheckboxOption(generalOptionsPane, baseRelativeUiElement, "TOPLEFT", "DM_Options_General_PerCharacter", "Per Character Settings", 14, -34);

  perCharacterOptions:SetScript("OnClick", function(self)
     DM_Options_SetOption(DM_OPTIONS_PER_CHARACTER_SETTINGS, self:GetChecked());
  end);

  perCharacterOptions:SetScript("OnEnter", function(self)
     GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
     GameTooltip:ClearLines();
     GameTooltip:AddLine("When checked, most options are scoped to specific characters");
     GameTooltip:Show();
  end);

  perCharacterOptions:SetScript("OnLeave", function(self)
     GameTooltip:Hide();
  end);

  perCharacterOptions:SetChecked(DM_GlobalOptions[DM_OPTIONS_PER_CHARACTER_SETTINGS]);

  local immActionCb, _ = CreateCheckboxOption(generalOptionsPane, perCharacterOptions, "BOTTOMLEFT", "DM_Options_General_ImmAction", "Immediate Action Enabled", 0, -8);

  immActionCb:SetScript("OnClick", function(self)
      DM_Options_SetOption(DM_OPTIONS_IMMEDIATE_ACTION_ENABLED, self:GetChecked());
  end);

  immActionCb:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
      GameTooltip:ClearLines();
      GameTooltip:AddLine("Enable/disable the immediate action text");
      GameTooltip:Show();
  end);

  immActionCb:SetScript("OnLeave", function(self)
     GameTooltip:Hide();
  end);

  immActionCb:SetChecked(DM_Options_GetOption(DM_OPTIONS_IMMEDIATE_ACTION_ENABLED));

  local hideBlizzardUiCb, _ = CreateCheckboxOption(generalOptionsPane, immActionCb, "BOTTOMLEFT", "DM_Options_General_HideBlizzardUI", "Always Hide Blizzard Objective UI", 0, -8);

  hideBlizzardUiCb:SetScript("OnClick", function(self)
      DM_Options_SetOption(DM_OPTIONS_HIDE_BLIZZARD_UI, self:GetChecked());
  end);

  hideBlizzardUiCb:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
      GameTooltip:ClearLines();
      GameTooltip:AddLine("When checked, hides the objective UI after dungeon start");
      GameTooltip:Show();
  end);

  hideBlizzardUiCb:SetScript("OnLeave", function(self)
     GameTooltip:Hide();
  end);

  hideBlizzardUiCb:SetChecked(DM_Options_GetOption(DM_OPTIONS_HIDE_BLIZZARD_UI));

  return generalOptionsPane;
end

-- Social

--    [ ] Automatically send tactics to chat
--    [ ] Automatically send mob abilities to chat

-- Alerts/Warnings

-- Low Health Thresold
--     [0 - 100% slider]
--     Track for: [ ] Tank    [ ] DPS    [ ] Healer

-- Low Mana Thresold
--     [0 - 100% slider]
--     Track for: [ ] Tank    [ ] DPS    [ ] Healer

-- Pull Tracker
--    <example pull window here>
--       !!! A - 1 - example mob           <--- current pull group, first mob is dead
--               1 - example mob                second mob is alive
--               1 - example mob
--       !!! B - 2 - example mob           <--- linked to A, not pulled
--               2 - example mob
--               C - 3 - example mob           <--- next pull group
--               D - 4 - example mob           <--- inactive (not current, not next)

--    [ ] Alert Icon Enabled
--    [ ] Enable Off-Route View
--    [ ] Enable Spawned View
--    [ ] Enable Quickest Pulls to Force Requirements View

--    Colors
--       Text Color
--       Icon Color
--       Warning Color

--       Inactive Group
--       Current Pull Group
--       Next Pull Group
--       Linked Groups [not pulled yet]

--       Dead Mob
--       Important Mob

--    Display
--       [               ]

--       %g = group label, %n = group number
--       %m = mob name, %t = mob's target (if it has one),

local function DM_Options_CreateSamplePullTrackerLine(rootFrame, index, relativeUiElement, anchor, xOfs, yOfs)
   local statusBarContainer = CreateFrame("Frame", "DM_Options_PullTrackerLine" .. tostring(index), rootFrame);

   statusBarContainer:SetPoint("TOPLEFT", relativeUiElement, anchor or "TOPLEFT", xOfs or 0, yOfs or 0);
   statusBarContainer:SetHeight(20);
   statusBarContainer:SetWidth(300);

   local statusBar = CreateFrame("StatusBar", nil, statusBarContainer);
   statusBar:SetStatusBarTexture(DM_Tex_StatusBarTexture(), "ARTWORK");
   statusBar:GetStatusBarTexture():SetHorizTile(false);
   statusBar:GetStatusBarTexture():SetVertTile(false);
   statusBar:SetStatusBarColor(1, 0, 0, 1);
   statusBar:SetAllPoints(statusBarContainer);

   statusBar:SetMinMaxValues(0, 100);
   statusBar:SetValue(100);
   statusBar:Show();

   statusBar.PriorityText = statusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
   statusBar.PriorityText:ClearAllPoints();
   statusBar.PriorityText:SetPoint("TOPRIGHT", statusBar, "TOPLEFT", -3, -4);
   statusBar.PriorityText:SetJustifyH("LEFT");
   statusBar.PriorityText:SetWordWrap(false);
   statusBar.PriorityText:SetTextColor(1, 1, 1, 1);

   statusBar.MainColumnText = statusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
   statusBar.MainColumnText:SetPoint("LEFT", statusBar, "LEFT", 2, 0);
   statusBar.MainColumnText:SetJustifyH("LEFT");
   statusBar.MainColumnText:SetTextColor(1, 1, 1, 1);
   statusBar.MainColumnText:SetWordWrap(false);
   statusBar.MainColumnText:SetText("");

   statusBarContainer.statusBar = statusBar;
   statusBarContainer:Show();

   statusBarContainer:SetScript("OnMouseUp", function(self, button)
      if (button == "LeftButton") then
         activeStatusBar = self.statusBar;

         local color = DM_Colors_GetColor(activeStatusBar.colorKey);
         ShowColorPicker(color.r, color.g, color.b, color.a, pullTrackerLineColorCallback);
      end
   end);

   return statusBarContainer;
end

local function DM_Options_LinkColor(statusBar, key)
   statusBar.colorKey = key;
   DM_Colors_SetStatusBarColor(statusBar, key);
end

local function DM_Options_CreatePullTrackerPane(rootFrame, baseRelativeUiElement)
   pullTrackerOptionsPane = CreateFrame("frame", "DM_Options_PullTrackerPane", rootFrame);

   pullTrackerOptionsPane:SetWidth(300);
   pullTrackerOptionsPane:SetHeight(200);
   pullTrackerOptionsPane:SetPoint("TOPLEFT", baseRelativeUiElement, "BOTTOMLEFT", 0, -4);

   local headerLine = pullTrackerOptionsPane:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");

   headerLine:SetPoint("TOPLEFT", pullTrackerOptionsPane, "TOPLEFT", 20, -4);
   headerLine:SetJustifyH("LEFT");
   headerLine:SetWordWrap(false);
   headerLine:SetTextColor(1, 1, 1, 1);

   headerLine:SetText("Click on a bar to change its color");

   local line1 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 1, headerLine, 0, -12);
   local line2 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 2, line1, "BOTTOMLEFT", 0, 0);
   local line3 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 3, line2, "BOTTOMLEFT", 0, 0);
   local line4 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 4, line3, "BOTTOMLEFT", 0, 0);
   local line5 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 5, line4, "BOTTOMLEFT", 0, 0);
   local line6 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 6, line5, "BOTTOMLEFT", 0, 0);
   local line7 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 7, line6, "BOTTOMLEFT", 0, 0);
   local line8 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 8, line7, "BOTTOMLEFT", 0, 0);
   local line9 = DM_Options_CreateSamplePullTrackerLine(pullTrackerOptionsPane, 9, line8, "BOTTOMLEFT", 0, 0);

   line1.statusBar.MainColumnText:SetText("AREA HEADER");
   DM_Options_LinkColor(line1.statusBar, COLOR_KEY_PULLTRACKER_AREAHEADER);

   line2.statusBar.MainColumnText:SetText("GROUP ANNOTATION");
   DM_Options_LinkColor(line2.statusBar, COLOR_KEY_PULLTRACKER_ANNOTATION);

   line3.statusBar.MainColumnText:SetText("ROUTE NOTE FOR GROUP");
   DM_Options_LinkColor(line3.statusBar, COLOR_KEY_PULLTRACKER_ROUTE_NOTE);

   line4.statusBar.MainColumnText:SetText("A - 1 - NEXT PULL GROUP");
   DM_Options_LinkColor(line4.statusBar, COLOR_KEY_PULLTRACKER_NEXTGROUP);

   line5.statusBar.MainColumnText:SetText("B - 1 - INACTIVE");
   DM_Options_LinkColor(line5.statusBar, COLOR_KEY_PULLTRACKER_INACTIVE);

   line6.statusBar.MainColumnText:SetText("C - 1 - ACTIVE");
   DM_Options_LinkColor(line6.statusBar, COLOR_KEY_PULLTRACKER_ACTIVE);

   line7.statusBar.MainColumnText:SetText("C - 2 - DEAD");
   DM_Options_LinkColor(line7.statusBar, COLOR_KEY_PULLTRACKER_DEAD);

   line8.statusBar.MainColumnText:SetText("D - 1 - LINKED PULL GROUP - START");
   DM_Options_LinkColor(line8.statusBar, COLOR_KEY_PULLTRACKER_LINKEDPULLSTART);

   line9.statusBar.MainColumnText:SetText("E - 1 - LINKED PULL GROUP");
   DM_Options_LinkColor(line9.statusBar, COLOR_KEY_PULLTRACKER_LINKEDPULL);
end

-- https://colors.artyclick.com/color-names-dictionary/color-names/metallic-blue-color

function DM_Options_Show()
   if not optionsFrame then
       optionsFrame = CreateFrame("Frame", "DM_Options_Frame", UIParent, "BackdropTemplate");
       optionsFrame:SetFrameStrata("HIGH");
   end

   local backdropColor = { 0.058823399245739, 0.058823399245739, 0.058823399245739, 0.2 };

   local backdropInfoOriginal = {
      bgFile = "Interface/Tooltips/UI-Tooltip-Background",
      tile = true,
      tileSize = 64,
      edgeFile = "Interface\\AddOns\\DungeonMentor\\textures\\bright_blue_gradient_edges2",
      edgeSize = 16,
      insets = {left = 4, right = 1, top = 1, bottom = 1},
   };

   local backDrop = DM_Tex_CreateBackdrop(4, 1, 1, 1);

   optionsFrame:SetBackdrop(backDrop);

   optionsFrame:SetBackdropBorderColor(79/255, 115/255, 142/255);
   optionsFrame:SetBackdropColor(79/255, 115/255, 142/255, 1.0);

   optionsFrame.background = optionsFrame:CreateTexture(nil, "BACKGROUND", nil, 0);
   optionsFrame.background:SetAllPoints();
   optionsFrame.background:SetColorTexture(unpack(backdropColor));
   optionsFrame.background:SetAlpha(0.2);
   optionsFrame:SetSize(400, 300);
   optionsFrame:SetResizable(true)
   optionsFrame:SetMovable(true);

   optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
   optionsFrame.title:ClearAllPoints();
   optionsFrame.title:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", 10, -8);
   optionsFrame.title:SetText("Dungeon Mentor: Options");
   optionsFrame.title:Show();

   local closeIcon = DM_Tex_CreateMainIcon(optionsFrame, "CIRCLE_X");

   closeIcon.parentWindow = optionsFrame;
   closeIcon:SetWidth(16);
   closeIcon:SetHeight(16);
   closeIcon:ClearAllPoints();
   closeIcon:SetVertexColor(1, 1, 1, 1);
   closeIcon:SetPoint("TOPRIGHT", optionsFrame, "TOPRIGHT", -8, -6);
   closeIcon:Show();
   closeIcon:EnableMouse(true);
   DM_Colors_SetIconColor(closeIcon, COLOR_KEY_GENERAL_ICON_NORMAL);
   closeIcon:SetScript("OnEnter", function(self)
       DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_ICON_HIGHLIGHTED);
   end);
   closeIcon:SetScript("OnLeave", function(self)
       DM_Colors_SetIconColor(self, COLOR_KEY_GENERAL_ICON_NORMAL);
   end);
   closeIcon:SetScript("OnMouseUp", function(self)
       closeIcon.parentWindow:Hide();
   end);

   optionsFrame:ClearAllPoints();
   optionsFrame:SetPoint("CENTER");

   optionsFrame:EnableMouse(true);
   optionsFrame:SetScript("OnMouseDown", function(self) self:StartMoving(); end);
   optionsFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing(); end);

   optionsDropDown = CreateFrame("FRAME", "DM_Options_DropDown", optionsFrame, "UIDropDownMenuTemplate");
   optionsDropDown:SetPoint("TOPLEFT", optionsFrame.background, "TOPLEFT", 2, -28);
   UIDropDownMenu_SetWidth(optionsDropDown, 200);

   UIDropDownMenu_SetText(optionsDropDown, "");
   UIDropDownMenu_Initialize(optionsDropDown, 
      function(self, level, menuList)
          local optionCategories = {
              [1] = "General",
              [2] = "Pull Tracker",
              -- [3] = "Social",
          };

          for i = 1, 2 do
              local info = UIDropDownMenu_CreateInfo();
              info.text, info.hasArrow, info.arg1, info.func = optionCategories[i], nil, i, DM_Options_CategoryClicked;
              UIDropDownMenu_AddButton(info);
          end
   end);

   UIDropDownMenu_SetSelectedID(optionsDropDown, 1);

   DM_Options_CreateGeneralPane(optionsFrame, optionsDropDown);
   DM_Options_CreatePullTrackerPane(optionsFrame, optionsDropDown);

   optionPanes.size = optionPanes.size + 1;
   optionPanes.items[optionPanes.size] = generalOptionsPane;
   optionPanes.size = optionPanes.size + 1;
   optionPanes.items[optionPanes.size] = pullTrackerOptionsPane;

   generalOptionsPane:Show();
   pullTrackerOptionsPane:Hide();

   optionsFrame:Show();
end
