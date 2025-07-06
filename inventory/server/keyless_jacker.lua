Use["keylessjacker"] = function(source, Passport, Amount, Slot, Full, Item, Split)
    TriggerClientEvent("inventory:Close",source)
    TriggerEvent("Monkey:KeylessJacker", source)
end

Use["keylesspacker"] = function(source, Passport, Amount, Slot, Full, Item, Split)
    TriggerClientEvent("inventory:Close",source)
    TriggerEvent("Monkey:KeylessPacker", source)
end

local Vehicles = {}
local Active = {}

local RateLimiter = {}
local RATE_LIMIT_SECONDS = 30

local function isRateLimited(passport, action)
    if not passport or not action then return false, 0 end

    RateLimiter[action] = RateLimiter[action] or {}

    local now = os.time()

    local last = RateLimiter[action][passport] or 0

    if now - last < RATE_LIMIT_SECONDS then
        return true, RATE_LIMIT_SECONDS - (now - last)
    end

    RateLimiter[action][passport] = now
    return false, 0
end

RegisterNetEvent("Monkey:KeylessJacker")
AddEventHandler("Monkey:KeylessJacker", function(source)
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local limited, wait = isRateLimited(Passport, "KeylessJacker")
    if limited then
        TriggerClientEvent("Notify", source, "Aviso", "Aguarde " .. wait .. "s para usar novamente.", "amarelo", 5000)
        return
    end

    vRPC.AnimActive(source)
    vRPC.CreateObjects(source, "amb@world_human_stand_mobile@male@text@idle_a", "idle_a", "prop_phone_ing_02_lod", 1, 28422, 0.10, 0.0, 0.0, -92.0, 260.0, 5.0)

    Player(source)["state"]["Buttons"] = true

    if vRP.Task(source, 10, 10000) then
        TriggerClientEvent("Progress", source, "Realizando Hacking", 5000)

        Citizen.Wait(1000)

        local VehicleData = {}
        VehicleData.Vehicle, VehicleData.Networked, VehicleData.Plate, VehicleData.Model, VehicleData.Class, VehicleData.Coords = vRPC.VehicleList(source)

        if not VehicleData or not VehicleData.Plate then
            TriggerClientEvent("Notify", source, "Erro", "Não foi possível capturar o veículo.", "vermelho", 5000)
            return
        end

        Vehicles[Passport] = VehicleData
        TriggerClientEvent("Notify", source, "Sucesso", "<b>Keyless</b> " .. VehicleData.Model .. " capturado.", "verde", 5000)
    end

    Player(source)["state"]["Buttons"] = false
    vRPC.Destroy(source)
end)

RegisterNetEvent("Monkey:KeylessPacker")
AddEventHandler("Monkey:KeylessPacker", function(source)
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local limited, wait = isRateLimited(Passport, "KeylessPacker")
    if limited then
        TriggerClientEvent("Notify", source, "Aviso", "Aguarde " .. wait .. "s para usar novamente.", "amarelo", 5000)
        return
    end

    if not Vehicles[Passport] or not Vehicles[Passport].Plate then
        TriggerClientEvent("Notify", source, "Erro", "Nenhum veículo disponível para hackear.", "vermelho", 5000)
        return
    end

    local Vehicle, Network, Plate, Model, Class, Coords = Vehicles[Passport].Vehicle, Vehicles[Passport].Networked, Vehicles[Passport].Plate, Vehicles[Passport].Model, Vehicles[Passport].Class, Vehicles[Passport].Coords
    local PlayerCoords = vRP.GetEntityCoords(source)

    if Model == "stockade" or Class == 15 or Class == 16 or Class == 19 then
        TriggerClientEvent("Notify", source, "Erro", "Este veículo não pode ser desbloqueado.", "vermelho", 5000)
        return
    end

    local Distance = #(vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z) - vector3(Coords.x, Coords.y, Coords.z))
    if Distance >= 10.0 then
        TriggerClientEvent("Notify", source, "Aviso", "O veículo está fora do alcance do sinal da antena.", "amarelo", 5000)
        return
    end

    vRPC.AnimActive(source)
    vRPC.CreateObjects(source, "amb@world_human_stand_mobile@male@text@idle_a", "idle_a", "prop_phone_ing_02_lod", 1, 28422, 0.10, 0.0, 0.0, -92.0, 260.0, 5.0)
    Player(source)["state"]["Buttons"] = true

    if vRP.Task(source, 10, 5000) then
        vGARAGE.RegisterDecors(source, Vehicle)
        TriggerClientEvent("Progress", source, "Realizando Hack", 5000)

        Citizen.Wait(1000)

        local Networked = NetworkGetEntityFromNetworkId(Network)

        if Dismantle and Dismantle[Plate] then
            NotifyTitle = "Desmanche"
            TriggerClientEvent("dismantle:Dispatch", source)
        elseif Boosting and Boosting[Plate] then
            NotifyTitle = "Boosting"
            TriggerClientEvent("boosting:Dispatch", source)
        end

        exports["vrp"]:CallPolice({
            ["Source"] = source,
            ["Passport"] = Passport,
            ["Permission"] = "PMESP",
            ["Name"] = "Hackeamento",
            ["Percentage"] = 25,
            ["Wanted"] = 300,
            ["Code"] = 31,
            ["Color"] = 44,
            ["Vehicle"] = VehicleName(Model) .. " - " .. Plate
        })

        Citizen.Wait(100)

        if DoesEntityExist(Networked) then
            if not vRP.PassportPlate(Plate) then
                if not Dismantle[Plate] then
                    Entity(Networked)["state"]:set("Fuel", 100, true)
                    Entity(Networked)["state"]:set("Nitro", 0, true)
                end

                Entity(Networked)["state"]:set("Lockpick", Passport, true)
                SetVehicleDoorsLocked(Networked, 1)
                TriggerClientEvent("sounds:Private", source, "locked", 0.3)
                TriggerClientEvent("Notify", source, "Sucesso", "O veículo foi destrancado com sucesso.", "verde", 5000)
            elseif math.random(100) >= 75 then
                SetVehicleDoorsLocked(Networked, 1)
                TriggerClientEvent("sounds:Private", source, "locked", 0.3)
                TriggerClientEvent("Notify", source, "Sucesso", "O veículo foi destrancado com sucesso.", "verde", 5000)
            end
        end

    end
    
    Player(source)["state"]["Buttons"] = false
    Vehicles[Passport] = nil
    vRPC.Destroy(source)
end)