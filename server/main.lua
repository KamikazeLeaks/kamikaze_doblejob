ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('kamikaze_doblejob:getSecondJob')
AddEventHandler('kamikaze_doblejob:getSecondJob', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT secondjob, secondjob_grade FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.getIdentifier() }, function(result)

        if result[1] ~= nil and result[1].secondjob ~= nil and result[1].secondjob_grade ~= nil then
                TriggerClientEvent('kamikaze_doblejob:returnSecondJob', _source, result[1].secondjob, result[1].secondjob_grade)
        else
            xPlayer.showNotification('Hay un error en la base!')
        end
    end)
end)

RegisterServerEvent('kamikaze_doblejob:setSecondJob')
AddEventHandler('kamikaze_doblejob:setSecondJob', function(job1, job1_grade, job2, job2_grade)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.setJob(job2, job2_grade)

    MySQL.Async.execute('UPDATE users SET secondjob = @secondjob, secondjob_grade = @secondjob_grade WHERE identifier = @identifier',
        { 
            ['@secondjob'] = job1,
            ['@secondjob_grade'] = job1_grade,
            ['@identifier'] = xPlayer.getIdentifier(),
        },
        function(affectedRows)
            if affectedRows == 0 then
                print('Player with steam ID: '..xPlayer.getIdentifier()..' had an issue while changing his job with saving his secondjob')
            end
        end
    )  

    SendDiscordWebhook(_source, job1, job1_grade, job2, job2_grade, 255)
end)

function SendDiscordWebhook(source, job1, job1_grade, job2, job2_grade, color)
    local xPlayer = ESX.GetPlayerFromId(source)
		local connect = {
			  {
				  ["color"] = color,
				  ["title"] = Config.ServerName ..'RP'..GetPlayerName(source)..', SteamID: '..xPlayer.getIdentifier(),
				  ["description"] = 'Ha cambiado de **FROM**: '..job1..' con grado: '..job1_grade..' **a**: '..job2.. ' con grado '..job2_grade,
				  ["footer"] = {
					  ["text"] = Config.EmbedFooter ..'Comando /'.. Config.ChangeJobCommand .. '..os.date("%Y/%m/%d %X"),
				  },
			  }
		  }
	PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

local CurrentVersion = '1.1'

PerformHttpRequest('https://cdn.elneko.es/scripts/kamikaze/doblejob/version.txt', function(Error, NewestVersion, Header)
    PerformHttpRequest('https://cdn.elneko.es/scripts/kamikaze/doblejob/version.txt', function(Error, Changes, Header)
        print('^0')
        print('^6[kamikaze_doblejob]^0 Comprobando actualizaciones...')
        print('^0')
        print('^6[kamikaze_doblejob]^0 Version: ^5' .. CurrentVersion .. '^0')
        print('^0')
        if CurrentVersion ~= NewestVersion then
            print('^6[kamikaze_doblejob]^0 Your script is ^8outdated^0!')
            print('^0')
            print('^6[kamikaze_doblejob] ^3Nueva Version ^5' .. NewestVersion .. ':^0')
            print('^3')
            print('^0')
            print('^6[kamikaze_doblejob]^0 Tu ^8no tienes^0 la ultima version de ^5chema_doblejob^0. Actualizalo: https://github.com/ChemaSanchez/chema_doblejob/releases/tag/'.. NewestVersion)
        else
            print('^6[kamikaze_doblejob]^0 Esta ^2actualizado^0')
        end
        print('^0')
    end)
end)
