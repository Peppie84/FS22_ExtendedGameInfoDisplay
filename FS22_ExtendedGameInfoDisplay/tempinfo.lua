---
-- TempInfo
--
-- Main class for activating the vanilla temperature information box
-- and changed the information text elements.
--
-- Copyright (c) Peppie84, 2021
--
TempInfo = {}

---Overwritten GameInfoDisplay:setTemperatureVisible()
---Set the isVisible always to true.
---@param overwrittenFunc function
---@param isVisible boolean
function TempInfo:gameinfodisplay__setTemperatureVisible(overwrittenFunc, isVisible)
    overwrittenFunc(self, ExtendedGameInfoDisplayGui.settings.temperaturVisible)
end

---Overwritten GameInfoDisplay:updateTemperature()
---Overwrite the vanilla day text with the current temperatur
---and night text with the current min/max temperatur
---@param overwrittenFunc function
function TempInfo:gameinfodisplay__updateTemperature(overwrittenFunc)
    overwrittenFunc(self)

    local minTemperatur, maxTemperatur = self.environment.weather:getCurrentMinMaxTemperatures()
    local currentTemperatur = self.environment.weather:getCurrentTemperature()

    self.temperatureDayText = string.format("%d°", currentTemperatur)
    self.temperatureNightText = string.format("%d°/%d°", maxTemperatur, minTemperatur)
end

---Overwritten GameInfoDisplay:drawTemperatureText()
---Scale the night text smaller
---@param overwrittenFunc function
function TempInfo:gameinfodisplay__drawTemperatureText(overwrittenFunc)
	setTextBold(false)
	setTextAlignment(RenderText.ALIGN_RIGHT)
	setTextColor(unpack(GameInfoDisplay.COLOR.TEXT))
	renderText(self.temperatureHighTextPositionX, self.temperatureHighTextPositionY, self.temperatureTextSize, self.temperatureDayText)
	renderText(self.temperatureLowTextPositionX, self.temperatureLowTextPositionY, self.temperatureTextSize - self:scalePixelToScreenHeight(5), self.temperatureNightText)
end

-- Overwrite the default GameInfoDisplay.setTemperatureVisible function
GameInfoDisplay.setTemperatureVisible = Utils.overwrittenFunction(GameInfoDisplay.setTemperatureVisible, TempInfo.gameinfodisplay__setTemperatureVisible)
-- Overwrite the default GameInfoDisplay.updateTemperature function
GameInfoDisplay.updateTemperature = Utils.overwrittenFunction(GameInfoDisplay.updateTemperature, TempInfo.gameinfodisplay__updateTemperature)
-- Overwrite the default GameInfoDisplay.drawTemperatureText function
GameInfoDisplay.drawTemperatureText = Utils.overwrittenFunction(GameInfoDisplay.drawTemperatureText, TempInfo.gameinfodisplay__drawTemperatureText)

-- Change dimensions of the temp box
GameInfoDisplay.SIZE.TEMPERATURE_BOX = {
    95,
    GameInfoDisplay.BOX_HEIGHT
}
