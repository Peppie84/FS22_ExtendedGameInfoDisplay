---
-- YearInfo
--
-- Main class for append the current year to the date on the
-- top right corner hud.
--
-- Copyright (c) Peppie84, 2021
-- https://github.com/Peppie84/FS22_ExtendedGameInfoDisplay
--
YearInfo = {
    L10N_SYMBOLS = {
        YEAR_TEXT = "yearinfo_current_year"
    },
    CURRENT_MOD = g_currentModName or 'unknown'
}

---Overwritten GameInfoDisplay.drawDateText()
---Overwrite the vanilla drawDateText function to append the
---current year under the current month.
---@param overwrittenFunc function
function YearInfo:gameinfodisplay__drawDateText(overwrittenFunc)
    setTextBold(false)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextColor(unpack(GameInfoDisplay.COLOR.TEXT))

    local textSizeInPixelForMonth = GameInfoDisplay.TEXT_SIZE.MONTH
    local textSizeInPixelForYear = textSizeInPixelForMonth - 5

    local scaledTextSizeForMonth = self:scalePixelToScreenHeight(textSizeInPixelForMonth)
    local scaledTextSizeForYear = self:scalePixelToScreenHeight(textSizeInPixelForYear)

    local textPositionYForMonth = self.monthTextPositionY + (scaledTextSizeForMonth * 0.5)
    local textPositionYForYear = self.monthTextPositionY - (scaledTextSizeForMonth * 0.30)

    local l10nTextYear = g_i18n:getText(YearInfo.L10N_SYMBOLS.YEAR_TEXT, YearInfo.CURRENT_MOD)

    --
    renderText(self.monthTextPositionX, textPositionYForMonth, scaledTextSizeForMonth, self.monthText)
    renderText(self.monthTextPositionX, textPositionYForYear, scaledTextSizeForYear, l10nTextYear .. " " .. tostring(self.environment.currentYear))
end

-- Overwrite the default GameInfoDisplay.drawDateText function
GameInfoDisplay.drawDateText = Utils.overwrittenFunction(GameInfoDisplay.drawDateText, YearInfo.gameinfodisplay__drawDateText)
