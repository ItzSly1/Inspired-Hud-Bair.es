Config = {}

Config.StatusUpdateInterval = 5000 -- Time it takes for status to update (lowering this value adds ms)
Config.CommandHideHud = 'hud' -- Command to hide the hud
Config.timetomugshot = 10000 -- Time to take the mugshot

function GetStatus(cb)  -- You can change your status here
    TriggerEvent("esx_status:getStatus", "hunger", function(h)
        TriggerEvent("esx_status:getStatus", "thirst", function(t)
            local hunger = h.getPercent()
            local thirst = t.getPercent()
            cb({hunger, thirst,})
        end)
    end)
end


Config.Commands = {
    -- Car Belt
    belt = 'carbelt',
    key = 'G',
}
