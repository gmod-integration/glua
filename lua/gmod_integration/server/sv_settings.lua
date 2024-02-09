function gmInte.saveSetting(setting, value)
    if gmInte.config[setting] == nil then
        gmInte.log("Unknown Setting")
        return
    end

    // Boolean
    if (value == "true") then value = true end
    if (value == "false") then value = false end

    // Number
    if (tonumber(value) != nil) then value = tonumber(value) end

    gmInte.config[setting] = value
    file.Write("gm_integration/config.json", util.TableToJSON(gmInte.config, true))
    gmInte.log("Setting Saved")
end

function gmInte.tryConfig()
    gmInte.http.get("",
        function(code, body)
            print(" ")
            gmInte.log("Congratulations your server is now connected to Gmod Integration")
            gmInte.log("Server Name: " .. body.name)
            gmInte.log("Server ID: " .. body.id)
            print(" ")
        end
    )
end

function gmInte.testConnection(ply)
    gmInte.http.get("",
        function(code, body)
            if (ply) then gmInte.SendNet(3, body, ply) end
        end,
        function(code, body)
            if (ply) then gmInte.SendNet(3, body, ply) end
        end
    )
end

function gmInte.refreshSettings()
    gmInte.config = util.JSONToTable(file.Read("gm_integration/config.json", "DATA"))
    gmInte.log("Settings Refreshed")
    gmInte.tryConfig()
end

function gmInte.superadminGetConfig(ply)
    if (!gmInte.plyValid(ply) || !ply:IsSuperAdmin()) then return end

    gmInte.config.websocket = GWSockets && true || false
    gmInte.SendNet(2, gmInte.config, ply)
end

function gmInte.publicGetConfig(ply)
    if (!gmInte.plyValid(ply)) then return end

    gmInte.SendNet(5, {
        ["debug"] = gmInte.config.debug,
        ["devInstance"] = gmInte.config.devInstance
    }, ply)
end

function gmInte.superadminSetConfig(ply, data)
    if (!gmInte.plyValid(ply) || !ply:IsSuperAdmin()) then return end

    for k, v in pairs(data) do
        gmInte.saveSetting(k, v)
    end

    if data.token || data.id then
        gmInte.testConnection(ply)
    end
end