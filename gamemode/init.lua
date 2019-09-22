AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "moneysystem.lua" )
AddCSLuaFile( "jobsystem.lua" )
AddCSLuaFile( "cl_itemscroll.lua" )
AddCSLuaFile( "cl_inventory.lua" )

include( "shared.lua" )
include( "moneysystem.lua" )
include( "jobsystem.lua" )
include( "cl_itemscroll.lua" )

function GM:PlayerSpawn(player)
    player:UpdateItems()
end 

local function LoadPlayerData( ply )
    print( "Loading player data" )
    --If player doesn't have money entry, they haven't joined before. Set to default starting cash
    if ply:GetPData( "money" ) == nil then 
        ply:SetPData( "money", 1000 )
    --Otherwise just load
    else 
        ply:SetMoney( ply:GetPData( "money" ) )
    end

end

local function SavePlayerData( ply )
    --Save player data when they disconnect
    print( "Saving player data" )
    print( "saving money: " .. ply:GetMoney() )
    ply:SetPData( "money", ply:GetMoney() )
end

local function InitializePlayer( ply )
    print( "Player spawned for first time, initializing" )
    ply:CrosshairDisable();
    ply:SetJob( "citizen" )
    timer.Create( "payTimer", 30, 0, function() ply:PayDay() end )
end

hook.Add( "PlayerInitialSpawn", "LoadPlayerdDataHook", LoadPlayerData )
hook.Add( "PlayerDisconnected", "SavePlayerDataHook", SavePlayerData )
hook.Add( "PlayerDeath", "PlayerDeathHook", SavePlayerData )
hook.Add( "PlayerInitialSpawn", "InitializePlayerHook", InitializePlayer )
hook.Add( "WeaponEquip", "WeaponEquipHook", function( wep, ply ) timer.Simple( 0, function() ply:UpdateItems() end ) end )
concommand.Add( "printweapons", function( ply, cmd, args ) ply:PrintItems() end )
concommand.Add( "stripweapon", function( ply, cmd, args ) ply:RemoveWeapon( args[ 1 ] ) end )