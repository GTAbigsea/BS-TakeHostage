local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("TakeHostage:sync")
AddEventHandler("TakeHostage:sync", function(targetSrc)
	local source = source

	TriggerClientEvent("TakeHostage:syncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:releaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:killHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("TakeHostage:stop")
AddEventHandler("TakeHostage:stop", function(targetSrc)
	local source = source

	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end

	if takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)

-- 版本检查功能
local version = 'V1.0'
local expectedResourceName = "BX-Carjob"

if Config.CheckUpdate then
    CreateThread(function()
        Wait(5000)
        local resourceName = GetCurrentResourceName()
        local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
        local versionUrl = 'https://raw.githubusercontent.com/BX-DEV-FIVEM/BX-Carjob/main/version.lua'

        PerformHttpRequest(versionUrl, function(error, result, headers)
            if error ~= 200 then
                print("^1Error checking version: GitHub is having issues or the manifest file is not accessible.^0")
                return
            end

            -- Pattern to extract version from version.lua content
            local latestVersion = result:match("local version = ['\"](%S+)['\"]")

            if latestVersion == nil then
                print("^1Error: Version information could not be found in the version file.^0")
                return
            end

            if currentVersion ~= latestVersion then
                print("  //\n  || ^1   " .. resourceName .. "^0 from ^5BX-DEV^0")
                print("  ||    Last Version: ❌ ")
                print(string.format("  ||    ^3New version available!^0 Current Version: ^5%s^0, Latest Version: ^2%s^0  ", currentVersion, latestVersion))
                print("  || ^5   https://github.com/xB3NDO/CARJOB ^0\n  \\\\")
            else
                print("  //\n  || ^1   " .. resourceName .. "^0 from ^5BX-DEV^0")
                print("  ||    Version : ^2" .. latestVersion .. "^0")
                print("  ||    Last Version: ✔️ \n  \\\\")
            end
        end, 'GET')
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= expectedResourceName then
        print("^1  Ressource Name must be 'BX-Carjob' ^0")
    end
end)