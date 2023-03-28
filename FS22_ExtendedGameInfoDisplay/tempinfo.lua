---
-- Tempinfo
--
-- Main class for activating the vanilla Temp information box
-- and changed the information text elements.
--
-- Copyright (c) Peppie84, 2021
--
tempInfo = {}

function tempInfo:gameinfodisplay__setTemperatureVisible(oldfunc, isVisible)
    self.showTemperature = true

    self.temperatureBox:setVisible(true)
    self:storeScaledValues()
    self:updateSizeAndPositions()
end

function tempInfo:gameinfodisplay__updateTemperature()
    local minTemp, maxTemp = self.environment.weather:getCurrentMinMaxTemperatures()
    local currentTemp = self.environment.weather:getCurrentTemperature()

    self.temperatureDayText = string.format("%d°", currentTemp)
    self.temperatureNightText = string.format("%d°/%d°", maxTemp, minTemp)

    local trend = self.environment.weather:getCurrentTemperatureTrend()

    self.temperatureIconStable:setVisible(trend == 0)
    self.temperatureIconRising:setVisible(trend > 0)
    self.temperatureIconDropping:setVisible(trend < 0)
end

-- Overwrite the default GameInfoDisplay.setTemperatureVisible function
GameInfoDisplay.setTemperatureVisible = Utils.overwrittenFunction(GameInfoDisplay.setTemperatureVisible, tempInfo.gameinfodisplay__setTemperatureVisible)
-- Overwrite the default GameInfoDisplay.updateTemperature function
GameInfoDisplay.updateTemperature = Utils.overwrittenFunction(GameInfoDisplay.updateTemperature, tempInfo.gameinfodisplay__updateTemperature)

-- Change dimensions of the temp box
GameInfoDisplay.SIZE.TEMPERATURE_BOX = {
    105,
    GameInfoDisplay.BOX_HEIGHT
}
