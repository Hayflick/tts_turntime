--[[
    Tabletop Simulator Turn Timer Mod
    
    This script tracks how long each player takes on their turns and 
    displays these stats in the top-left corner of the screen.
]]

--------------------------------------------------
--               Global Variables
--------------------------------------------------
-- We store two dictionaries:
-- 1) turnStartTimes: The moment a player's turn starts (in seconds).
-- 2) totalTurnTimes: Accumulated total time for each player.
turnStartTimes = {}
totalTurnTimes = {}

--------------------------------------------------
--                 onLoad
--------------------------------------------------
function onLoad()
    -- Initialize both tracking tables for each available color.
    for _, color in ipairs(Player.getColors()) do
        turnStartTimes[color] = 0
        totalTurnTimes[color] = 0
    end

    createTimerUI()
    updateTimerUI()
end

--------------------------------------------------
--          Turn Event Handlers
--------------------------------------------------
-- Called automatically by TTS when a player’s turn starts.
function onPlayerTurnStart(player_color_start, player_color_previous)
    --If the color is missing from turnStarTimes, then skip
    if not turnStartTimes[player_color_start] then
        return
    end
    
    turnStartTimes[player_color_start] = Time.time
end

-- Called automatically by TTS when a player's turn ends.
function onPlayerTurnEnd(player_color_end)
    if not turnStartTimes[player_color_end] or not totalTurnTimes[player_color_end] then
        return 
    end
    

    local turnDuration = Time.time - (turnStartTimes[player_color_end] or 0)
    totalTurnTimes[player_color_end] = (totalTurnTimes[player_color_end] or 0) + turnDuration
    
    updateTimerUI()
end

--------------------------------------------------
--                 UI Creation
--------------------------------------------------
function createTimerUI()
    -- This XML defines a Panel (a container) and a Text element inside it.
    -- The 'RectTransform' attributes position the Panel in the top-left corner.
    local uiXml = [[
    <Panel id="TimePanel" rectAlignment="MiddleRight" width="400" height="250" offsetXY="-20 -330" color="#000000EE" allowDragging="false" returnToOriginalPositionWhenReleased="false">
        <Text 
            id="TimeText"
            text="Turn Times"
            fontSize="18"
            color="#FFFFFFFF"
            alignment="UpperLeft"
            rectAlignment="UpperLeft"
            offsetXY="10 -10"
            width="395"
            height="245"
        />
    </Panel>
    ]]
    
    -- Pass the XML to TTS to generate the UI elements.
    UI.setXml(uiXml)
end

--------------------------------------------------
--               UI Updating
--------------------------------------------------
function updateTimerUI()
    -- We'll build a display string that shows each player's total turn time in seconds.
    local displayText = "Turn Times (seconds):\n"
    for _, color in ipairs(Player.getAvailableColors()) do
        local totalTime = totalTurnTimes[color] or 0
        displayText = displayText .. color .. ": " .. string.format("%.2f", totalTime) .. "\n"
    end
    
    -- We set the text of the UI element (with id="TimeText") to our displayText.
    UI.setValue("TimeText", displayText)
end