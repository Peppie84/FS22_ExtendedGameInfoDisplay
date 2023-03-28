---
-- YearInfo
--
-- Main class for append the current year to the date on the
-- top right corner hud.
--
-- Copyright (c) Peppie84, 2021
--
yearInfo = {}
yearInfo.currentModName = g_currentModName
yearInfo.currentModDirectory = g_currentModDirectory

function yearInfo:gameinfodisplay__drawDateText()
    setTextBold(false)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextColor(unpack(GameInfoDisplay.COLOR.TEXT))

    local textSizeInPixelForMonth = GameInfoDisplay.TEXT_SIZE.MONTH
    local textSizeInPixelForYear = textSizeInPixelForMonth - 5

    local scaledTextSizeForMonth = self:scalePixelToScreenHeight(textSizeInPixelForMonth)
    local scaledTextSizeForYear = self:scalePixelToScreenHeight(textSizeInPixelForYear)

    local textPositionYForMonth = self.monthTextPositionY + (scaledTextSizeForMonth * 0.5)
    local textPositionYForYear = self.monthTextPositionY - (scaledTextSizeForMonth * 0.30)

    local l10nTextYear = g_i18n:getText(yearInfo.L10N_SYMBOL.YEAR_TEXT, yearInfo.currentModName)

    --
    renderText(self.monthTextPositionX, textPositionYForMonth, scaledTextSizeForMonth, self.monthText)
    renderText(self.monthTextPositionX, textPositionYForYear, scaledTextSizeForYear, l10nTextYear .. " " .. tostring(self.environment.currentYear))
end

-- Overwrite the default GameInfoDisplay.drawDateText function
GameInfoDisplay.drawDateText = Utils.overwrittenFunction(GameInfoDisplay.drawDateText, yearInfo.gameinfodisplay__drawDateText)

yearInfo.L10N_SYMBOL = {
    YEAR_TEXT = "current_year"
}
