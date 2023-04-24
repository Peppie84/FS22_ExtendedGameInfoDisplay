---
-- ExtendedGameInfoDisplayGui
--
-- Class to handle the new ui controls on the settings frame
-- to control the temperature info on & off and saves the
-- value in the modSettings-folder.
--
-- Copyright (c) Peppie84, 2023
--
ExtendedGameInfoDisplayGui = {
    MOD_DIRECTORY = g_currentModDirectory,
    MOD_SETTINGS_DIRECTORY = g_currentModSettingsDirectory .. '../',
    MOD_SETTINGS_FILENAME = 'ExtendedGameInfoDisplay.xml',
    MOD_SETTINGS_XML_ROOT_NODE = 'settings',
    CURRENT_MOD = g_currentModName or 'unknown',
    L10N_SYMBOLS = {
        MOD_TITLE = 'mod_title',
        TEMPERATURE_SETTING_LABEL = 'settings_temperature_label',
        TEMPERATURE_SETTING_DESCRIPTION = 'settings_temperature_description',
        EASYARMCONTROL_TEMPERATURE_OPTION1 = 'settings_temperature_option1',
        EASYARMCONTROL_TEMPERATURE_OPTION2 = 'settings_temperature_option2',
    },
    ENUM_EASYARMCONTROL_INDEX = {
        LABEL = 4,
        DESCRIPTION = 6,
    },
    ENUM_TEMPERATURE_VIEW_STATE = {
        ON = 1,
        OFF = 2,
    }
}

ExtendedGameInfoDisplayGui.settings = {}
ExtendedGameInfoDisplayGui.settings.temperatureVisibility = true

---Append to InGameMenuGeneralSettingsFrame.onFrameOpen
---Initialize our gui elements for the settings frame that we need.
function ExtendedGameInfoDisplayGui:initGui()
    if not self.initGuiDone then
        local title = TextElement.new()
        local temperaturSettingTitleText = g_i18n:getText(ExtendedGameInfoDisplayGui.L10N_SYMBOLS.MOD_TITLE, ExtendedGameInfoDisplayGui.CURRENT_MOD)
        local temperaturSettingLabelText = g_i18n:getText(ExtendedGameInfoDisplayGui.L10N_SYMBOLS.TEMPERATURE_SETTING_LABEL, ExtendedGameInfoDisplayGui.CURRENT_MOD)
        local temperaturSettingDescriptionText = g_i18n:getText(ExtendedGameInfoDisplayGui.L10N_SYMBOLS.TEMPERATURE_SETTING_DESCRIPTION, ExtendedGameInfoDisplayGui.CURRENT_MOD)
        local temperaturSettingOption1Text = g_i18n:getText(ExtendedGameInfoDisplayGui.L10N_SYMBOLS.EASYARMCONTROL_TEMPERATURE_OPTION1, ExtendedGameInfoDisplayGui.CURRENT_MOD)
        local temperaturSettingOption2Text = g_i18n:getText(ExtendedGameInfoDisplayGui.L10N_SYMBOLS.EASYARMCONTROL_TEMPERATURE_OPTION2, ExtendedGameInfoDisplayGui.CURRENT_MOD)

        self.ExtendedGameInfoDisplay = self.checkUseEasyArmControl:clone()
        self.ExtendedGameInfoDisplay.target = ExtendedGameInfoDisplayGui
        self.ExtendedGameInfoDisplay.id = 'ExtendedGameInfoDisplay'
        self.ExtendedGameInfoDisplay:setCallback('onClickCallback', 'onExtendedGameInfoDisplayChanged')
        self.ExtendedGameInfoDisplay:setTexts({temperaturSettingOption1Text, temperaturSettingOption2Text})
        self.ExtendedGameInfoDisplay.elements[ExtendedGameInfoDisplayGui.ENUM_EASYARMCONTROL_INDEX.LABEL]:setText(temperaturSettingLabelText)
        self.ExtendedGameInfoDisplay.elements[ExtendedGameInfoDisplayGui.ENUM_EASYARMCONTROL_INDEX.DESCRIPTION]:setText(temperaturSettingDescriptionText)

        title:applyProfile('settingsMenuSubtitle', true)
        title:setText(temperaturSettingTitleText)

        self.boxLayout:addElement(title)
        self.boxLayout:addElement(self.ExtendedGameInfoDisplay)

        local state = ExtendedGameInfoDisplayGui.ENUM_TEMPERATURE_VIEW_STATE.ON
        if ExtendedGameInfoDisplayGui.settings.temperatureVisibility == false then
            state = ExtendedGameInfoDisplayGui.ENUM_TEMPERATURE_VIEW_STATE.OFF
        end

		self.ExtendedGameInfoDisplay:setState(state)
        self.initGuiDone = true
    end
end

---Callback function for our gui element by on change
---@param state number
function ExtendedGameInfoDisplayGui:onExtendedGameInfoDisplayChanged(state)
	ExtendedGameInfoDisplayGui.settings.temperatureVisibility = true
    if state == ExtendedGameInfoDisplayGui.ENUM_TEMPERATURE_VIEW_STATE.OFF then
        ExtendedGameInfoDisplayGui.settings.temperatureVisibility = false
    end

	ExtendedGameInfoDisplayGui:saveSettings()
    g_currentMission.hud.gameInfoDisplay:setTemperatureVisible(nil)
end

---Appand to and InGameMenuGeneralSettingsFrame.updateGameSettings()
---Just udpate the gui
function ExtendedGameInfoDisplayGui:updateGui()
    if self.initGuiDone and self.ExtendedGameInfoDisplay ~= nil then
        self.ExtendedGameInfoDisplay:setState(ExtendedGameInfoDisplayGui.ENUM_TEMPERATURE_VIEW_STATE.ON)
    end
end

---Save the settings into its own xml under modSettings/ path
function ExtendedGameInfoDisplayGui:saveSettings()
	local filename = ExtendedGameInfoDisplayGui.MOD_SETTINGS_DIRECTORY .. ExtendedGameInfoDisplayGui.MOD_SETTINGS_FILENAME
	local xmlRootNode = ExtendedGameInfoDisplayGui.MOD_SETTINGS_XML_ROOT_NODE
	local xmlFile = XMLFile.create("settingsXML", filename, xmlRootNode)

	if xmlFile ~= nil then
		xmlFile:setBool(xmlRootNode .. ".temperatureVisibility", self.settings.temperatureVisibility)

		xmlFile:save()
		xmlFile:delete()
	end
end

---Load the settings xml from modSettings/
function ExtendedGameInfoDisplayGui:loadSettings()
    local filename = ExtendedGameInfoDisplayGui.MOD_SETTINGS_DIRECTORY .. ExtendedGameInfoDisplayGui.MOD_SETTINGS_FILENAME
	local xmlRootNode = ExtendedGameInfoDisplayGui.MOD_SETTINGS_XML_ROOT_NODE
	local xmlFile = XMLFile.loadIfExists("settingsXML", filename, xmlRootNode)

	if xmlFile ~= nil then
		ExtendedGameInfoDisplayGui.settings.temperatureVisibility = Utils.getNoNil(xmlFile:getBool(xmlRootNode .. ".temperatureVisibility"), true)

		xmlFile:delete()
	end
end

---Event from addModEventListener after loading the map
function ExtendedGameInfoDisplayGui:loadMap()
    ExtendedGameInfoDisplayGui:loadSettings()
    g_currentMission.hud.gameInfoDisplay:setTemperatureVisible(nil)
end

---Init
local function init()
    InGameMenuGeneralSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuGeneralSettingsFrame.onFrameOpen, ExtendedGameInfoDisplayGui.initGui)
    InGameMenuGeneralSettingsFrame.updateGameSettings = Utils.appendedFunction(InGameMenuGeneralSettingsFrame.updateGameSettings, ExtendedGameInfoDisplayGui.updateGui)
end

init()
addModEventListener(ExtendedGameInfoDisplayGui)
