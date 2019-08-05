local isGameInProgress = false
local bet = nil
local player1 = nil
local player2 = nil
local croupier = nil
local isGameStarting = false
local playersjoined = false
local player1result = nil
local player2result = nil
local player1finished = false
local player2finished = false
local player1black = false
local player2black = false

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('program-blackjack:startTable')
AddEventHandler('program-blackjack:startTable', function(quantity)
    isGameStarting = true
    bet = quantity
	local source = source
	local xPlayers = ESX.GetPlayers()
        
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('program-casino:notifyPlayers',xPlayers[i],quantity)
    end
    croupier = source
    
end)

RegisterServerEvent('program-blackjack:stopTable')
AddEventHandler('program-blackjack:stopTable', function()
    local player1 = ESX.GetPlayerFromId(player1)
    local player2 = ESX.GetPlayerFromId(player2)
    if isGameInProgress == true then
        if player2black then
            player2.addAccountMoney('black_money', bet)
        else
            player2.addMoney(bet)
        end
        if player1black then
            player1.addAccountMoney('black_money', bet)
        else
            player1.addMoney(bet)
        end
        isGameStarting = false
    end
    if isGameInProgress == true then
        isGameInProgress = false
    end
    player2 = nil
    player1 = nil
    player1finished = false
    player2finished = false
    player1result = nil
    player2result = nil
    player1black = false
    player2black = false
    croupier = nil
    bet = nil
    playersjoined = false
    TriggerEvent('program-blackjack:clear')
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    StopResource('pNotify')
    StartResource('pNotify')
end)

RegisterServerEvent('program-blackjack:started')
AddEventHandler('program-blackjack:started', function()
    if isGameStarting == true and isGameInProgress == false then
        isGameStarting = false
        isGameInProgress = true
        local xPlayers = ESX.GetPlayers()
        local player1 = ESX.GetPlayerFromId(player1)
        local player2 = ESX.GetPlayerFromId(player2)
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.source == player1.source then
                TriggerClientEvent('program-blackjack:givecards', xPlayer.source)
                print("Player1")
                if player1black then
                    xPlayer.removeAccountMoney('black_money', bet)
                else
                    xPlayer.removeMoney(bet)
                end
            elseif xPlayer.source == player2.source then
                TriggerClientEvent('program-blackjack:givecards', xPlayer.source)
                print("Player2")
                if player2black then
                    xPlayer.removeAccountMoney('black_money', bet)
                else
                    xPlayer.removeMoney(bet)
                end
            end
        end
    end
end)


ESX.RegisterServerCallback('program-blackjack:checkStarting', function(source, cb)
    cb(isGameStarting)
end)

ESX.RegisterServerCallback('program-blackjack:checkMoney', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    money = tonumber(money)
    bet = tonumber(bet)
    if money >= bet then
        cb(true)
    else 
        cb(false)
    end
end)

ESX.RegisterServerCallback('program-blackjack:checkBlackMoney', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount('black_money').money
    money = tonumber(money)
    bet = tonumber(bet)
    if money >= bet then
        cb(true)
    else 
        cb(false)
    end
end)

RegisterServerEvent('program-blackjack:p1black')
AddEventHandler('program-blackjack:p1black', function()
    player1black = true
end)
RegisterServerEvent('program-blackjack:p2black')
AddEventHandler('program-blackjack:p2black', function()
    player2black = true
end)


RegisterServerEvent('program-blackjack:p1')
AddEventHandler('program-blackjack:p1', function()
    player1 = source
    if player1 ~= nil and player2 ~=nil then
        TriggerEvent('program-blackjack:started')
    end 
end)

RegisterServerEvent('program-blackjack:p2')
AddEventHandler('program-blackjack:p2', function()
    player2 = source
    if player1 ~= nil and player2 ~=nil then
        print("elo")
        TriggerEvent('program-blackjack:started')
    end 
end)


RegisterServerEvent('program-blackjack:p1left')
AddEventHandler('program-blackjack:p1left', function()
    local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
		societyAccount = account
    end)
    player1 = nil
    local player2 = ESX.GetPlayerFromId(player2)
    if isGameInProgress then
        player2.addMoney(bet*1.5)
        societyAccount.addMoney(bet*0.5)
        player2=nil
        player1finished=false
        player2finished=false
        player1result = nil
        player2result = nil
        croupier = nil
        isGameInProgress = false
        player1black = false
        player2black = false
        bet = nil
        isGameStarting = false
        playersjoined = false
        player1=nil
    end
    TriggerEvent('program-blackjack:clear')
end)

RegisterServerEvent('program-blackjack:p2left')
AddEventHandler('program-blackjack:p2left', function()
    local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
		societyAccount = account
	end)
    player2 = nil

    local player1 = ESX.GetPlayerFromId(player1)
    if isGameInProgress then
        player1.addMoney(bet*1.5)
        societyAccount.addMoney(bet*0.5)
        player2=nil
        player1finished=false
        player2finished=false
        player1result = nil
        player2result = nil
        croupier = nil
        isGameInProgress = false
        player1black = false
        player2black = false
        bet = nil
        isGameStarting = false
        playersjoined = false
        player1=nil
    end
    TriggerEvent('program-blackjack:clear')
end)



RegisterServerEvent('program-blackjack:sendResult1')
AddEventHandler('program-blackjack:sendResult1', function(result)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player1 = ESX.GetPlayerFromId(player1)
    if player1 ~= nil then
        if xPlayer.source == player1.source then
            player1result=result
            player1finished = true
        end
    end
    print("One")
    if player1finished and player2finished then
        TriggerEvent('program-blackjack:pickWinner')
    end
end)

RegisterServerEvent('program-blackjack:sendResult2')
AddEventHandler('program-blackjack:sendResult2', function(result)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player2 = ESX.GetPlayerFromId(player2)
    if player2 ~= nil then
        if xPlayer.source == player2.source then
            player2result=result
            player2finished = true
        end
    end
    if player1finished and player2finished then
        TriggerEvent('program-blackjack:pickWinner')
    end
    print("Two")
end)

RegisterServerEvent('program-blackjack:pickWinner')
AddEventHandler('program-blackjack:pickWinner', function()
    local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
		societyAccount = account
	end)
    local player1subtraction = 21 - player1result
    local player2subtraction = 21 - player2result
    local croupier = ESX.GetPlayerFromId(croupier)
    local player1 = ESX.GetPlayerFromId(player1)
    local player2 = ESX.GetPlayerFromId(player2)
    if player1result >= 21 and player2result >= 21 then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~Draw~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~Draw~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~Draw~s~!')
        if player1black then
            player1.addAccountMoney('black_money', bet)
        else
            player1.addMoney(bet)
        end
        if player2black then
            player2.addAccountMoney('black_money', bet)
        else
            player2.addMoney(bet)
        end
    elseif player1result > 21 and player2result <= 21 then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~The player won from the chair of the second~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~The player won from the chair of the second~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~The player won from the chair of the second~s~!')
        societyAccount.addMoney(bet*0.025)
        player2.addMoney(bet*1.975)
    elseif player2result > 21 and player1result <= 21 then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~The player from the first chair won~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~The player from the first chair won~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~The player from the first chair won~s~!')
        societyAccount.addMoney(bet*0.025)
        player1.addMoney(bet*1.975)
    elseif player1subtraction < player2subtraction then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~The player from the first chair won~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~The player from the first chair won~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~The player from the first chair won~s~!')
        societyAccount.addMoney(bet*0.025)
        player1.addMoney(bet*1.975)
    elseif player2subtraction < player1subtraction then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~The player won from the chair of the second~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~The player won from the chair of the second~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~The player won from the chair of the second~s~!')
        player2.addMoney(bet*1.975)
        societyAccount.addMoney(bet*0.025)
    elseif player1subtraction == player2subtraction then
        TriggerClientEvent('esx:showNotification', player1.source, '~y~Draw~s~!')
        TriggerClientEvent('esx:showNotification', player2.source, '~y~Draw~s~!')
        TriggerClientEvent('esx:showNotification', croupier.source, '~y~Draw~s~!')
        if player1black then
            player1.addAccountMoney('black_money', bet)
        else
            player1.addMoney(bet)
        end
        if player2black then
            player2.addAccountMoney('black_money', bet)
        else
            player2.addMoney(bet)
        end
    end
    player2=nil
    player1=nil
    player1finished=false
    player2finished=false
    player1result = nil
    player2result = nil
    player1black = false
    player2black = false
    croupier = nil
    isGameInProgress = false
    bet = nil
    isGameStarting = false
    playersjoined = false
    TriggerEvent('program-blackjack:clear')
end)


RegisterServerEvent('program-blackjack:clear')
AddEventHandler('program-blackjack:clear', function()
    player2=nil
    player1=nil
    player1finished=false
    player2finished=false
    player1result = nil
    player2result = nil
    player1black = false
    player2black = false
    croupier = nil
    isGameInProgress = false
    bet = nil
    isGameStarting = false
    playersjoined = false
end)