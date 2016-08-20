--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The OnLoad function. This is called after everything in the game save finishes loading.
Most of your script code goes here. --]]
function onload()
    --[[ Text tool variant disabled until TTS supports putting them into bags
    -- Get the text tool
    --textObject = getObjectFromGUID('9226bf')
    if textObject == nil then
        -- The GUID is invalid
        errorGuidInvalid()
        textTool = nil
    else
        textTool = textObject.TextTool
    end
    --]]
    emptyText = ' '
    --[[
    if textTool == nil then
        -- The GUID is invalid
        errorGuidInvalid()
    else
        -- Initialize the text options
        local textColor = {}
        textColor['r'] = 200
        textColor['g'] = 200
        textColor['b'] = 200
        textTool.setFontColor(textColor)
        textTool.setFontSize(40)
        textTool.setValue(emptyText)
    end
    --]]
end

--[[ The Update function. This is called once per frame. --]]
function update ()
    --[[
    -- Validate text object
    if textTool == nil then
        -- The GUID is invalid
        errorGuidInvalid()
        return
    end
    --]]
    -- Get and validate cardboard object
    if cardboard == nil then
        cardboard = getObjectFromGUID('11df74')
        if cardboard == nil then
            -- The GUID is invalid
            errorGuidInvalid()
            return
        end
    end

    -- If the zone is moving, wait
    if not self.resting then
        --textTool.setValue(emptyText)
        --cardboard.setDescription(emptyText)
        return
    end

    local ownPos = self.getPosition()
    local ownRotation = self.getRotation()['x']
    local ownScale = self.getScale()['x']

    -- Move the display with the box
    --[[
    local displayOffsetX = -1.8 * ownScale
    local displayOffsetY = 0.08 * ownScale
    local displayOffsetZ = 2.5 * ownScale
    --]]
    local displayOffsetX = -1 * ownScale
    local displayOffsetY = 0.05 * ownScale
    local displayOffsetZ = 1.8 * ownScale
    --textObject.setPosition({ownPos['x'] + displayOffsetX, ownPos['y'] + displayOffsetY, ownPos['z'] + displayOffsetZ})
    cardboard.setPosition({ownPos['x'] + displayOffsetX, ownPos['y'] + displayOffsetY, ownPos['z'] + displayOffsetZ})

    -- Compute the bounds of the box
    local boundOffset = 2.6
    local leftBound = ownPos['x'] - boundOffset * ownScale
    local rightBound = ownPos['x'] + boundOffset * ownScale
    local upperBound = ownPos['z'] + boundOffset * ownScale
    local lowerBound = ownPos['z'] - boundOffset * ownScale

    local valueToCounter = {}
    local valuesToSort = {}

    -- Iterate all objects in the zone
    for _, obj in pairs(getAllObjects()) do
        -- Fetch resting dices
        if obj != nil and obj.tag == 'Dice' and obj.resting then
            -- Only use objects inside the zone
            local objPos = obj.getPosition()
            if objPos['x'] > leftBound and objPos['x'] < rightBound and objPos['z'] > lowerBound and objPos['z'] < upperBound then
                local value = obj.getValue()
                local counter = valueToCounter[value]
                -- First occurrence of this value
                if counter == nil then
                    counter = 0
                    valuesToSort[#valuesToSort + 1] = value
                end
                -- Increase the occurrence of this value
                counter = counter + 1
                valueToCounter[value] = counter
            end
        end
    end

    -- Process the tracked values, sorted and build the lines to display
    local textLines = {}
    table.sort(valuesToSort)
    for index, value in ipairs(valuesToSort) do
        local counter = valueToCounter[value]
        local line = '#' .. value .. ': ' .. counter
        textLines[#textLines + 1] = line
    end

    -- Display the text
    local text = table.concat(textLines, '\n')
    if text == '' then
        -- Suppress the default text 'Type Here'
        text = emptyText
    end
    --textTool.setValue(text)
    cardboard.setDescription(text)
end

function errorGuidInvalid()
    print('Error: GUID invalid')
end
