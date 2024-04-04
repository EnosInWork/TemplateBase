ESX.RegisterCommand({'setcoords', 'tp'}, 'admin', function(xPlayer, args)
	xPlayer.setCoords({ x = args.x, y = args.y, z = args.z })
end, false, {
	help = TranslateCap('command_setcoords'),
	validate = true,
	arguments = {
		{ name = 'x', help = TranslateCap('command_setcoords_x'), type = 'coordinate' },
		{ name = 'y', help = TranslateCap('command_setcoords_y'), type = 'coordinate' },
		{ name = 'z', help = TranslateCap('command_setcoords_z'), type = 'coordinate' }
	}
})

ESX.RegisterCommand('setjob', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
	else
		showError(_U('command_setjob_invalid'))
	end
	ESX.DiscordLogFields("setJob", "/setjob Triggered", "pink", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Job", value = args.job, inline = true},
    {name = "Grade", value = args.grade, inline = true}
	})
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('setjob2', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job2, args.grade2) then
		args.playerId.setJob2(args.job2, args.grade2)
	else
		showError(_U('command_setjob_invalid'))
	end
	ESX.DiscordLogFields("setJob", "/setjob2 Triggered", "pink", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Job", value = args.job2, inline = true},
    {name = "Grade", value = args.grade2, inline = true}
	})
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job2', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade2', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('teleport', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	local playerped = GetPlayedPed(-1)
	SetEntityCoords(args[1], args[2], args[3], args[4])
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'x', help = "x", type = 'string'},
	{name = 'y', help = "y", type = 'string'},
	{name = 'z', help = "z", type = 'string'}
}})

local upgrades = Config.SpawnVehMaxUpgrades and
	{
		plate = "ADMINCAR",
		modEngine = 3,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modArmor = true,
		fuelLevel = 100.0,
		windowTint = 1
	} or {}

ESX.RegisterCommand('car', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	if not xPlayer then
		return showError('[^1ERROR^7] The xPlayer value is nil')
	end

	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local playerHeading = GetEntityHeading(playerPed)
	local playerVehicle = GetVehiclePedIsIn(playerPed)

	if not args.car or type(args.car) ~= 'string' then
		args.car = 'adder'
	end

	if playerVehicle then
		DeleteEntity(playerVehicle)
	end

	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Spawn Car /car Triggered!", "pink", {
			{ name = "Player",  value = xPlayer and xPlayer.name or "Server Console",   inline = true },
			{ name = "ID",      value = xPlayer and xPlayer.source or "Unknown ID", inline = true },
			{ name = "Vehicle", value = args.car,       inline = true }
		})
	end

	ESX.OneSync.SpawnVehicle(args.car, playerCoords, playerHeading, upgrades, function(networkId)
		if networkId then
			local vehicle = NetworkGetEntityFromNetworkId(networkId)
			for _ = 1, 20 do
				Wait(0)
				SetPedIntoVehicle(playerPed, vehicle, -1)

				if GetVehiclePedIsIn(playerPed, false) == vehicle then
					break
				end
			end
			if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
				showError('[^1ERROR^7] The player could not be seated in the vehicle')
			end
		end
	end)
end, false, {
	help = TranslateCap('command_car'),
	validate = false,
	arguments = {
		{ name = 'car', validate = false, help = TranslateCap('command_car_car'), type = 'string' }
	}
})

ESX.RegisterCommand({'cardel', 'dv'}, {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
	if not args.radius then args.radius = 4 end
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('setaccountmoney', {"admin", "dev"}, function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
	ESX.DiscordLogFields("giveMoney", "/setaccountmoney Triggered", "red", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Account", value = args.account, inline = true},
    {name = "Amount", value = args.amount, inline = true}
	})
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', {"admin", "dev"}, function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
	ESX.DiscordLogFields("giveMoney", "/giveaccountmoney Triggered", "red", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Account", value = args.account, inline = true},
    {name = "Amount", value = args.amount, inline = true}
	})
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveitem', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	args.playerId.addInventoryItem(args.item, args.count)
	ESX.DiscordLogFields("giveItemWeapon", "/giveitem Triggered", "green", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Item", value = args.item, inline = true},
    {name = "Amount", value = args.count, inline = true}
	})
end, true, {help = _U('command_giveitem'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
	{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
}})

ESX.RegisterCommand('giveweapon', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weapon) then
		showError(_U('command_giveweapon_hasalready'))
	else
		args.playerId.addWeapon(args.weapon, args.ammo)
	end
	ESX.DiscordLogFields("giveItemWeapon", "/giveweapon Triggered", "green", {
		{name = "Player", value = xPlayer.name, inline = true},
		{name = "Weapon", value = args.weapon, inline = true},
    {name = "Ammo", value = args.ammo, inline = true}
	})
end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
}})

ESX.RegisterCommand('giveweaponcomponent', {"admin", "dev"}, function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weaponName) then
		local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

		if component then
			if args.playerId.hasWeaponComponent(args.weaponName, args.componentName) then
				showError(_U('command_giveweaponcomponent_hasalready'))
			else
				args.playerId.addWeaponComponent(args.weaponName, args.componentName)
			end
		else
			showError(_U('command_giveweaponcomponent_invalid'))
		end
	else
		showError(_U('command_giveweaponcomponent_missingweapon'))
	end
end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'}
}})


ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:client:ClearChat')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, {"admin", "dev"}, function(xPlayer, args, showError)
	TriggerClientEvent('chat:client:ClearChat', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})
ESX.RegisterCommand('clearloadout', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	for i=#args.playerId.loadout, 1, -1 do
		args.playerId.removeWeapon(args.playerId.loadout[i].name)
	end
end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('setgroup', {"dev"}, function(xPlayer, args, showError)
	if not args.playerId then args.playerId = xPlayer.source end
	if args.group == "superadmin" then args.group = "admin" end
	args.playerId.setGroup(args.group)
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', {"admin", "dev"}, function(xPlayer, args, showError)
	ESX.SavePlayer(args.playerId)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', {"admin", "dev"}, function(xPlayer, args, showError)
	ESX.SavePlayers()
end, true, {help = _U('command_saveall')})

ESX.RegisterCommand('tpm', {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
	xPlayer.triggerEvent("esx:tpm")
end, true)

ESX.RegisterCommand('goto', {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
		local targetCoords = args.playerId.getCoords()
		xPlayer.setCoords(targetCoords)
end, true, {help = _U('goto'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('bring', {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
	local playerCoords = xPlayer.getCoords()
	args.playerId.setCoords(playerCoords)
end, true, {help = _U('bring'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('kill', {"admin", "dev", "gerant"}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:killPlayer')
end, true, {help = _U('kill'), validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('freeze', {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:freezePlayer', "freeze")
end, true, {help = _U('kill'), validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('unfreeze', {"moderateur", "admin", "dev", "gerant"}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:freezePlayer', "unfreeze")
end, true, {help = _U('kill'), validate = true, arguments = {
{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('players', {"admin", "dev"}, function(xPlayer, args, showError)
	local xPlayers = ESX.GetExtendedPlayers() -- Returns all xPlayers
	print('^5'..#xPlayers..' ^2online player(s)^0') -- Get overall player count
	for _, xPlayer in pairs(xPlayers) do
	  print('^1[ ^2ID : ^5'..xPlayer.source..' ^0| ^2Name : ^5'..xPlayer.getName()..' ^0 | ^2Group : ^5'..xPlayer.getGroup()..' ^0 | ^2Identifier : ^5'.. xPlayer.identifier ..'^1]^0\n') -- print players info
	end
end, true)
