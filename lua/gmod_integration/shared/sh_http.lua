//
// HTTP
//

local function sendHTTP(params)
    gmInte.log("HTTP Request: " .. params.method .. " " .. params.endpoint, true)
    gmInte.log("HTTP Body: " .. (params.body || "No body"), true)
    HTTP({
        url = "https://api.gmod-integration.com" .. params.endpoint,
        method = params.method,
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = params.body and string.len(params.body) || 0,
            ["id"] = gmInte.config.id,
            ["token"] = gmInte.config.token,
            ["version"] = gmInte.version
        },
        body = params.body && params.body || "",
        type = "application/json",
        success = function(code, body, headers)
            gmInte.log("HTTP Response: " .. code, true)
            if (gmInte.debug) then gmInte.log("HTTP Body: " .. body, true) end
            if (string.sub(code, 1, 1) == "2") then
                if (params.success) then
                    params.success(code, body, headers)
                end
            else
                gmInte.logError("HTTP Request failed with code " .. code)
                if (gmInte.debug) then gmInte.logError("HTTP Body: " .. body) end
            end
        end,
        failed = function(error)
            gmInte.logError(error)
        end
    })
end

function gmInte.get(endpoint, onSuccess)
    sendHTTP({
        endpoint = endpoint,
        method = "GET",
        success = onSuccess
    })
end

function gmInte.post(endpoint, data, onSuccess)
    sendHTTP({
        endpoint = endpoint,
        method = "POST",
        body = util.TableToJSON(data),
        success = onSuccess
    })
end

function gmInte.put(endpoint, data, onSuccess)
    sendHTTP({
        endpoint = endpoint,
        method = "PUT",
        body = util.TableToJSON(data),
        success = onSuccess
    })
end

function gmInte.delete(endpoint, onSuccess)
    sendHTTP({
        endpoint = endpoint,
        method = "DELETE",
        success = onSuccess
    })
end

/*
// Fetch Example
gmInte.fetch(
    // Endpoint
    "",
    // Parameters
    { request = "requ" },
    // onSuccess
    function( body, length, headers, code )
        print(body)
    end
)

// Post Example
gmInte.post(
    // Endpoint
    "",
    // Data
    {
        data = "data"
    },
    // onSuccess
    function( body, length, headers, code )
        print(body)
    end
)
*/