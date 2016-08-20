--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The OnLoad function. This is called after everything in the game save finishes loading.
Most of your script code goes here. --]]
function onload()
    -- Tip out the bag
    local ownPos = self.getPosition()
    local ownScale = self.getScale()['x']

    -- Spawn stuff with offset to the bag
    local spawnOffsetYStep = 1 * ownScale

    local spawnOffsetX = 5 * ownScale
    local spawnOffsetY = spawnOffsetYStep
    local spawnOffsetZ = 0

    for _, objData in pairs(self.getObjects()) do
        local params = {}
        params.guid = objData['guid']
        params.position = {ownPos['x'] + spawnOffsetX, ownPos['y'] + spawnOffsetY, ownPos['z'] + spawnOffsetZ}
        self.takeObject(params)

        -- Increase spawn height for each object so that they don't spawn inside each other
        spawnOffsetY = spawnOffsetY + spawnOffsetYStep
    end
end

--[[ The Update function. This is called once per frame. --]]
function update ()
    --
end