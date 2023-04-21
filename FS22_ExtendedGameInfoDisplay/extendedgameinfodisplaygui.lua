---
-- ExtendedGameInfoDisplayGui
--
-- TODO
--
-- Copyright (c) Peppie84, 2023
--
ExtendedGameInfoDisplayGui = {
    MOD_DIRECTORY = g_currentModDirectory,
    MOD_SETTINGS_DIRECTORY = g_currentModSettingsDirectory .. '../',
    MOD_SETTINGS_FILENAME = 'ExtendedGameInfoDisplay.xml',
    MOD_SETTINGS_XML_ROOT_NODE = 'settings',
}

ExtendedGameInfoDisplayGui.settings = {}
ExtendedGameInfoDisplayGui.settings.temperaturVisible = true

---Append to InGameMenuGeneralSettingsFrame.onFrameOpen
---Initialize our gui elements for the settings frame that we need.
function ExtendedGameInfoDisplayGui:initGui()
    if not self.initGuiDone then
        local target = ExtendedGameInfoDisplayGui

        self.ExtendedGameInfoDisplay = self.checkUseEasyArmControl:clone()
        self.ExtendedGameInfoDisplay.target = target
        self.ExtendedGameInfoDisplay.id = "ExtendedGameInfoDisplay"
        self.ExtendedGameInfoDisplay:setCallback("onClickCallback", "onExtendedGameInfoDisplayChanged")

        self.ExtendedGameInfoDisplay.elements[4]:setText('Temperatuanzeige')
        self.ExtendedGameInfoDisplay.elements[6]:setText('Steuert die Anzeige der aktuellen Temperatur oben rechts im Hud.')

        local title = TextElement.new()
        title:applyProfile('settingsMenuSubtitle', true)
        title:setText('Erweiterte Spiel-Infodarstellung')

        self.boxLayout:addElement(title)
        self.boxLayout:addElement(self.ExtendedGameInfoDisplay)

		self.ExtendedGameInfoDisplay:setTexts({
            "Eingeblendet",
            "Ausgeblendet"
        })
        local state = 1
        if ExtendedGameInfoDisplayGui.settings.temperaturVisible == false then
            state = 2
        end
		self.ExtendedGameInfoDisplay:setState(state)

        self.initGuiDone = true
    end
end

---Callback function for our gui element by on change
---@param state number
function ExtendedGameInfoDisplayGui:onExtendedGameInfoDisplayChanged(state)
	ExtendedGameInfoDisplayGui.settings.temperaturVisible = true
    if state == 2 then
        ExtendedGameInfoDisplayGui.settings.temperaturVisible = false
    end
	ExtendedGameInfoDisplayGui:saveSettings()
    g_currentMission.hud.gameInfoDisplay:setTemperatureVisible(nil)
end

---Appand to and InGameMenuGeneralSettingsFrame.updateGameSettings()
---Just udpate the gui
function ExtendedGameInfoDisplayGui:updateGui()
    if self.initGuiDone and self.ExtendedGameInfoDisplay ~= nil then
        self.ExtendedGameInfoDisplay:setState(1)
    end
end

---Save the settings into its own xml under modSettings/ path
function ExtendedGameInfoDisplayGui:saveSettings()
	local filename = ExtendedGameInfoDisplayGui.MOD_SETTINGS_DIRECTORY .. ExtendedGameInfoDisplayGui.MOD_SETTINGS_FILENAME
	local xmlRootNode = ExtendedGameInfoDisplayGui.MOD_SETTINGS_XML_ROOT_NODE
	local xmlFile = XMLFile.create("settingsXML", filename, xmlRootNode)

	if xmlFile ~= nil then
		xmlFile:setBool(xmlRootNode .. ".temperaturVisible", self.settings.temperaturVisible)

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
		ExtendedGameInfoDisplayGui.settings.temperaturVisible = Utils.getNoNil(xmlFile:getBool(xmlRootNode .. ".temperaturVisible"), true)

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
