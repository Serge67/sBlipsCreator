ESX = exports["es_extended"]:getSharedObject()

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end	
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function openBlipsCreator()

    local blipsCreator_main = RageUI.CreateMenu("Blips Creator", "Blips Creator")
    local blipsCreator_builder = RageUI.CreateSubMenu(blipsCreator_main, "Blips Creator", "Blips Creator")
    local blipsCreator_gestion = RageUI.CreateSubMenu(blipsCreator_main, "Blips Creator", "Blips Creator")

    local coordsIndex = 1
    local coordsList = {"Actuelles", "Personnalisées"}
    local flashesIndex = 1
    local flashesList = {"Non", "Oui"}
    local scaleIndex = 1
    local scaleList = {1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0}
    name = "Indéfini"
    label = "Indéfini"
    coords = GetEntityCoords(PlayerPedId())
    sprite = 1
    display = 4
    flashes = false
    scale = scaleList[scaleIndex]
    color = 0

    local blipSelected = nil

    local blipsList = nil
    Citizen.CreateThread(function()
        while blipsCreator_main do
            ESX.TriggerServerCallback('sBlipsCreator:getBlips', function(result)
                blipsList = result
            end)
            Citizen.Wait(2000)
        end
    end)

    blipsCreator_builder.Closed = function()
        deleteExampleBlips()
    end

    RageUI.Visible(blipsCreator_main, not RageUI.Visible(blipsCreator_main))
    while blipsCreator_main do
        Citizen.Wait(0)

        RageUI.IsVisible(blipsCreator_main, true, false, true, function()

            RageUI.ButtonWithStyle("~g~Créer un blip", nil, {RightLabel = "→"}, true, function(_, _, Selected)
                if Selected then
                    createExampleBlips()
                end
            end, blipsCreator_builder)

            RageUI.Separator("~b~↓ ~s~Liste des blips ~b~↓")

            if blipsList ~= nil then
                for k,v in pairs(blipsList) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "→"}, true, function(_, _, Selected)
                        if Selected then
                            blipSelected = v
                            RageUI.NextMenu = blipsCreator_gestion
                        end
                    end)
                end
            end

        end, function()
        end)

        RageUI.IsVisible(blipsCreator_builder, true, false, true, function()

            RageUI.ButtonWithStyle("Nom", "Identifiant (unique)", {RightLabel = "~b~" ..name}, true, function(_, _, Selected)
                if Selected then
                    name = KeyboardInput("Nom:", name, 32)
                    if name == nil then
                        name = ""
                    end
                end
            end)

            RageUI.ButtonWithStyle("Label", "Nom visible", {RightLabel = "~b~" ..label}, true, function(_, _, Selected)
                if Selected then
                    label = KeyboardInput("Label:", label, 32)
                    if label == nil then
                        label = ""
                    end
                end
            end)

            RageUI.List("Coordonnées", coordsList, coordsIndex, "~b~" ..coords, {}, true, function(_, _, Selected, Index)
                if Selected then
                    if coordsIndex == 1 then
                        coords = GetEntityCoords(PlayerPedId())
                    elseif coordsIndex == 2 then
                        coords = KeyboardInput("Coordonnées:", coords, 50)
                    end
                    SetBlipCoords(exampleBlips, coords)
                end
                coordsIndex = Index
            end)
            
            RageUI.List("Taille", scaleList, scaleIndex, nil, {}, true, function(_, Active, Selected, Index)
                if Active then
                    scale = scaleList[Index]
                    SetBlipScale(exampleBlips, scale)
                end
                scaleIndex = Index
            end)

            RageUI.ButtonWithStyle("Type", nil, {RightLabel = "~b~" ..sprite.. " ~s~→"}, true, function(_, _, Selected)
                if Selected then
                    sprite = KeyboardInput("Type:", sprite, 3)
                    SetBlipSprite(exampleBlips, tonumber(sprite))
                end
            end)


            RageUI.ButtonWithStyle("Couleur", nil, {RightLabel = "~b~" ..color.. " ~s~→"}, true, function(_, _, Selected)
                if Selected then
                    color = KeyboardInput("Couleur:", color, 3)
                    SetBlipColour(exampleBlips, tonumber(color))
                end
            end)

            if Config.advancedMode then
                RageUI.ButtonWithStyle("Display", nil, {RightLabel = "~b~" ..display.. " ~s~→"}, true, function(_, _, Selected)
                    if Selected then
                        display = KeyboardInput("Display:", display, 2)
                        SetBlipDisplay(exampleBlips, tonumber(display))
                    end
                end)

                RageUI.List("Clignote", flashesList, flashesIndex, flashesList[Index], {}, true, function(_, Active, Selected, Index)
                    if Active then
                        if flashesIndex == 1 then
                            flashes = false
                        elseif flashesIndex == 2 then
                            flashes = true
                        end
                        SetBlipFlashes(exampleBlips, flashes)
                    end
                    flashesIndex = Index
                end)
            end

            RageUI.ButtonWithStyle("Créer le blips", nil, {RightLabel = "→"}, true, function(_, _, Selected)
                if Selected then
                    local coordsFinal = {}
                    table.insert(coordsFinal,{x = coords.x, y = coords.y, z = coords.z})
                    TriggerServerEvent('sBlipsCreator:createBlip', name, label, json.encode(coordsFinal), sprite, display, scale, color, flashes)
                    deleteExampleBlips()
                    RageUI.CloseAll()
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(blipsCreator_gestion, true, false, true, function()
        
            RageUI.Separator(blipSelected.label)

            RageUI.ButtonWithStyle("~r~Supprimer le blips", nil, {RightLabel = "→"}, true, function(_, _, Selected)
                if Selected then
                    TriggerServerEvent('sBlipsCreator:deleteBlip', blipSelected.name)
                    RageUI.CloseAll()
                end
            end)
        
        end)

        if not RageUI.Visible(blipsCreator_main) and not RageUI.Visible(blipsCreator_builder) and not RageUI.Visible(blipsCreator_gestion) then
            blipsCreator_main = RMenu:DeleteType("Blips Creator", true)
        end
    end
end

local exampleBlipsActive = false
function createExampleBlips()
    if exampleBlipsActive then
        exampleBlipsActive = false
        RemoveBlip(exampleBlips)
    end
    if not exampleBlipsActive then
        exampleBlipsActive = true
        Citizen.CreateThread(function()
            exampleBlips = AddBlipForCoord(coords)
        
            SetBlipSprite(exampleBlips, sprite)
            SetBlipScale(exampleBlips, scale)
            SetBlipColour(exampleBlips, color)
            SetBlipAsShortRange(exampleBlips, true)
            SetBlipDisplay(exampleBlips, display)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(label)
            EndTextCommandSetBlipName(exampleBlips)
        end)
    end
end

function deleteExampleBlips()
    if exampleBlipsActive then
        RemoveBlip(exampleBlips)
    end
    exampleBlipsActive = false
end

local allBlips = nil
Citizen.CreateThread(function()
    ESX.TriggerServerCallback('sBlipsCreator:getBlips', function(result)
        allBlips = result
    end)
    while not allBlips do
        Citizen.Wait(1000)
    end
    for i = 1, #allBlips do
        local coordsFinal = json.decode(allBlips[i].coords)
        blip = AddBlipForCoord(coordsFinal[1].x, coordsFinal[1].y, coordsFinal[1].z)
        SetBlipSprite(blip, allBlips[i].sprite)
        SetBlipScale(blip, ESX.Math.Round(allBlips[i].scale, 1))
        SetBlipColour(blip, allBlips[i].color)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, allBlips[i].display)
        SetBlipFlashes(blip, allBlips[i].flashes)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(allBlips[i].label)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.actualization)
        ESX.TriggerServerCallback('sBlipsCreator:getBlips', function(result)
            if #allBlips ~= #result then
                for i = 1, #allBlips do
                    RemoveBlip(blip)
                end
                allBlips = result
                for i = 1, #allBlips do
                    local coordsFinal = json.decode(allBlips[i].coords)
                    blip = AddBlipForCoord(coordsFinal[1].x, coordsFinal[1].y, coordsFinal[1].z)
                    SetBlipSprite(blip, allBlips[i].sprite)
                    SetBlipScale(blip, ESX.Math.Round(allBlips[i].scale, 1))
                    SetBlipColour(blip, allBlips[i].color)
                    SetBlipAsShortRange(blip, true)
                    SetBlipDisplay(blip, allBlips[i].display)
                    SetBlipFlashes(blip, allBlips[i].flashes)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(allBlips[i].label)
                    EndTextCommandSetBlipName(blip)
                end
            end
        end)
    end
end)

RegisterCommand(Config.command, function()
    ESX.TriggerServerCallback('sBlipsCreator:getUserGroup', function(group)
        playerGroup = group
        for k,v in pairs(Config.permission) do
            if playerGroup == v then
                openBlipsCreator()
            end
        end
    end)
end)

Keys.Register(Config.control, 'BlipsCreator', 'Ouvre le menu de création de blips', function()
    ESX.TriggerServerCallback('sBlipsCreator:getUserGroup', function(group)
        playerGroup = group
        for k,v in pairs(Config.permission) do
            if playerGroup == v then
                openBlipsCreator()
            end
        end
    end)
end)
