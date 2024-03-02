--Class
ModLoader = Object:extend()

--Constructor
ModLoader:init()
    self.mods = {}
    self.enabledMods = {}
    self.modCount = 0

    self:loadDatabase()
    self:discoverMods()
end

--Load the database
function ModLoader:loadDatabase()
    --If the database file exists
    if love.filesystem.getInfo("mods/mods.db") ~= nil then
        --Load the database
        local db, size = love.filesystem.read("mods/mods.db")
        --Get enabled mods
        for line in db():gmatch("[^\r\n]+") do
            local mod, enabled = line:match("(.+) = (.+)")
            self.enabledMods[mod] = enabled == "true"
        end
    end
end

--Save the database
function ModLoader:saveDatabase()
    --Create the database file
    local db = love.filesystem.newFile("mods/mods.db")
    --Open the database file
    db:open("w")
    for mod, enabled in pairs(self.enabledMods) do
        db:write(mod.." = "..tostring(enabled).."\n")
    end
    --Close the database file
    db:close()
end

--Load all mods
function ModLoader:discoverMods()
    local baseDir = love.filesystem.getSourceBaseDirectory()
    --If the mods directory exists
    if love.filesystem.getInfo("mods") == nil then
        --Create the mods directory
        love.filesystem.createDirectory("mods")
    end
    --Get all mods
    local mods = love.filesystem.getDirectoryItems("mods")
    --For each mod
    for i, mod in ipairs(mods) do
        --If it's a directory
        if love.filesystem.getInfo("mods/"..mod).type == "directory" then
            --Load the mod
            self:loadMod(mod)
        end
    end
end

--Load a mod
function ModLoader:loadMod(mod)
    --If the mod is not already loaded and enabled
    if self.mods[mod] == nil and self.enabledMods[mod] == true then
        --Load the mod
        local modFile = require("mods."..mod..".main")
        --Add the mod to the list
        self.mods[mod] = modFile
        self.modCount = self.modCount + 1
    end
end

--Enable a mod
function ModLoader:enableMod(mod)
    --If the mod is not already enabled
    if self.enabledMods[mod] == nil then
        --Enable the mod
        self.enabledMods[mod] = true
    end
end

--Disable a mod
function ModLoader:disableMod(mod)
    --If the mod is enabled
    if self.enabledMods[mod] ~= nil then
        --Disable the mod
        self.enabledMods[mod] = nil
    end
end
