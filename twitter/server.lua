local webhookURL = GetConvar(config.webhookURL)
local charLimit = GetConvarInt(config.charLimit)


RegisterCommand("tweet", function(source, args, rawCommand)
    name = (source == 0) and 'console' or GetPlayerName(source)

    tweet = table.concat(args, " ")


    if (tweet == "") then
        errorMessage("Vous ne pouvez pas poster un tweet vide", source)
    elseif (tweet:len() >= charLimit) then
        errorMessage("Votre tweet dépasse la limite de caractères autorisée " .. charLimit, source)
    else
        announcetweet(name, tweet)
        postDiscordWebhook(name, tweet)
    end

end, false)

function errorMessage(message, id)
    TriggerClientEvent('chatMessage', id, "^8" .. message)
end

function announcetweet(name, tweet)
    TriggerClientEvent('chatMessage', -1, "^0[^4tweeter^0]", {30, 144, 255}, "^3@" .. name .."^0 " .. tweet)
end

function postDiscordWebhook(name, tweet)
    if webhookURL ~= "nil" then
            PerformHttpRequest(webhookURL, function(statusCode, text, headers)
                -print(statusCode)
            end, 'POST', json.encode({ content = tweet, username = name}), { ["Content-Type"] = 'application/json' })
    end
end