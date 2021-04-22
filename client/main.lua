ESX = nil
local job1, job2
local job1_grade, job2_grade
local timer = 0
local sleepThread = 1000
local allowCommand = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("trabajo", function (src, args, raw)
    if timer == 0 and allowCommand then
        TriggerServerEvent('kamikaze_doblejob:getSecondJob')
        timer = 15
        allowCommand = false
    else
        ESX.ShowNotification('Tienes que esperar 15 segundos entre cambiar de trabajo. Quedan '..timer) 
    end
end, false)

RegisterNetEvent('kamikaze_doblejob:returnSecondJob')
AddEventHandler('kamikaze_doblejob:returnSecondJob', function(secondjob, secondjob_grade)
    job2 = secondjob
    job2_grade = secondjob_grade
    job1 = ESX.PlayerData.job.name
    job1_grade = ESX.PlayerData.job.grade
    TriggerServerEvent('kamikaze_doblejob:setSecondJob', job1, job1_grade, job2, job2_grade)
    ESX.ShowNotification('Has cambiado de trabajo.')
    Wait(5000)
    ESX.ShowNotification('Su trabajo actual es: '..ESX.PlayerData.job.label..' y su calificacion: '..ESX.PlayerData.job.grade_label) 
end)

Citizen.CreateThread(function()
    
    while true do
        if timer > 1 then
            timer = timer-1  
        elseif timer == 1 then
            allowCommand = true
            timer = 0
        end
        Citizen.Wait(sleepThread)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
