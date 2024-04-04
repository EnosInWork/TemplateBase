HUD.Data.hudHidden = false
RegisterCommand("hud", function()
    HUD:Toggle(HUD.Data.hudHidden)
    HUD.Data.hudHidden = not HUD.Data.hudHidden
end, false)

RegisterCommand("togglehud", function()
    HUD:Toggle(HUD.Data.hudHidden)
    HUD.Data.hudHidden = not HUD.Data.hudHidden
end, false)

RegisterCommand("hudsettings", function()
    SendNUIMessage({ type = "OPEN_SETTINGS" })
    SetNuiFocus(true, true)
end, false)

if not Config.Disable.VehicleHandlers and not Config.Disable.Vehicle then
    local leftSignal, rightSignal = false, false

    ESX.RegisterInput("esx_hud:indicator:left", Translate("indicatorLeft"), "keyboard", "NUMPAD4", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end
        leftSignal = not leftSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 1, leftSignal)
    end)

    ESX.RegisterInput("esx_hud:indicator:right", Translate("indicatorRight"), "keyboard", "NUMPAD6", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end
        rightSignal = not rightSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 0, rightSignal)
    end)

    ESX.RegisterInput("esx_hud:toggleEngine", Translate("toggleEngine"), "keyboard", "N", function()
        if not HUD.Data.Vehicle then
            return
        end
        local engineState = GetIsVehicleEngineRunning(HUD.Data.Vehicle)
        engineState = not engineState
        SetVehicleEngineOn(HUD.Data.Vehicle, engineState, true, true)
    end)
end
