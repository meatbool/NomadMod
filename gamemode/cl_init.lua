include( "shared.lua" )
include( "moneysystem.lua" )
include( "jobsystem.lua" )
include( "cl_itemscroll.lua" )
include( "cl_inventory.lua" )

local scrW = ScrW()
local scrH = ScrH()
local panelWidth = scrW / 10
local panelHeight = 4
local invPanelWidth = 100
local invPanelSpacing = 20
local timerElapsed = true
local debounceElapsed = true


surface.CreateFont( "newFont", { 
    font = "Arial",
    size = 32,
    weight = 500
} )

function GM:HUDWeaponPickedUp( weapon )
    --Print something to show new item
    return true
end

function GM:HUDPaint()
    if !LocalPlayer():Alive() then return end
    draw.RoundedBox( 0, 32, scrH - 32 - panelHeight, panelWidth, panelHeight, Color( 135, 54, 0 ))
    draw.RoundedBox( 0, scrW - panelWidth - 32, scrH - 32 -panelHeight, panelWidth, panelHeight, Color( 20, 90, 50 ) )
    draw.SimpleText("Health: " .. LocalPlayer():Health(), "newFont", 32, scrH - 32, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( "Wallet: " .. LocalPlayer():GetMoney(), "newFont", scrW - panelWidth - 32,  scrH - 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    --Draw inventory blocks
    draw.RoundedBox( 0, scrW / 2 - 290, scrH - 32 - panelHeight, invPanelWidth, panelHeight, Color( 255, 255, 255 ))
    draw.RoundedBox( 0, scrW / 2 - 170, scrH - 32 - panelHeight, invPanelWidth, panelHeight, Color( 255, 255, 255 ))
    draw.RoundedBox( 0, scrW / 2 - 50, scrH - 32 - panelHeight, invPanelWidth, panelHeight, Color( 255, 255, 255 ))
    draw.RoundedBox( 0, scrW / 2 + 70, scrH - 32 - panelHeight, invPanelWidth, panelHeight, Color( 255, 255, 255 ))
    draw.RoundedBox( 0, scrW / 2 + 190, scrH - 32 - panelHeight, invPanelWidth, panelHeight, Color( 255, 255, 255 ))
    --draw.RoundedBox(cornerRadius, x, y, width, height, color)

    local itemIndex = LocalPlayer():GetItemIndex()
    if itemIndex then 
        if itemIndex == 1 then
            draw.RoundedBox( 0, scrW / 2 - 290, scrH - 32 - panelHeight + 20, invPanelWidth, panelHeight, Color( 153, 0, 0 ))
        elseif itemIndex == 2 then
            draw.RoundedBox( 0, scrW / 2 - 170, scrH - 32 - panelHeight + 20, invPanelWidth, panelHeight, Color( 153, 0, 0 ))
        elseif itemIndex == 3 then
            draw.RoundedBox( 0, scrW / 2 - 50, scrH - 32 - panelHeight + 20, invPanelWidth, panelHeight, Color( 153, 0, 0 ))
        elseif itemIndex == 4 then
            draw.RoundedBox( 0, scrW / 2 + 70, scrH - 32 - panelHeight + 20, invPanelWidth, panelHeight, Color( 153, 0, 0 ))
        elseif itemIndex == 5 then
            draw.RoundedBox( 0, scrW / 2 + 190, scrH - 32 - panelHeight + 20, invPanelWidth, panelHeight, Color( 153, 0, 0 ))
        end
    end
    --Don't bother drawing armor if there isn't any
    if LocalPlayer():Armor() > 0 then
         draw.SimpleText( "Armor: " .. LocalPlayer():Armor(), "newFont", 64 + panelWidth, scrH - 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
         draw.RoundedBox( 0, 64 + panelWidth, scrH -32 - panelHeight, panelWidth, panelHeight, Color( 21, 67, 96 ))
    end
    --Don't bother drawing ammo data if no active weapon
    if LocalPlayer():GetActiveWeapon():IsValid() then
        draw.RoundedBox( 0, scrW - 96 - 2 * panelWidth, scrH - 32 - panelHeight, panelWidth, panelHeight, Color( 21, 67, 96 ))
        draw.SimpleText( LocalPlayer():GetActiveWeapon():Clip1() .." / " .. LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ), "newFont", scrW - 96 - 2 * panelWidth,  scrH - 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    end
end

--Return false if trying to draw stock HUD elements, using a hook so we don't override function
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" ) then return false 
    end
end )

local function ProcessBindPress( ply, bind, pressed )
    --Blocks the normal ability to scroll through weapons so we can overwrite weapon scrolling
    if bind == "invnext" and pressed then
        ply:DrawNextItem()
        return true
    elseif bind == "invprev" and pressed then
        ply:DrawPreviousItem()
        return true
    elseif bind == "KEY_1" and pressed then
        ply:SetSelectedWeapon( 1 )
        return true
    elseif bind == "KEY_2" and pressed then
        ply:SetSelectedWeapon( 2 )
        return true
    elseif bind == "KEY_3" and pressed then
        ply:SetSelectedWeapon( 3 )
        return true
    elseif bind == "KEY_4" and pressed then
        ply:SetSelectedWeapon( 4 )
        return true
    elseif bind == "KEY_5" and pressed then
        ply:SetSelectedWeapon( 5 )
        return true
    end

end

local function ProcessButtonDown( ply, button )
    if button == KEY_Q then --and debounceElapsed then
        ply:ShowPanel()
        --ply:TogglePanel()
        --debounceElapsed = false
        --timer.Simple( 0.1, function() debounceElapsed = true end )
    end
end

local function ProcessButtonUp( ply, button )
    if button == KEY_Q then
        ply:HidePanel()
    end
end

hook.Add( "PlayerBindPress", "BindPressedHook", ProcessBindPress )
hook.Add( "PlayerButtonDown", "ButtonDownHook", ProcessButtonDown )
hook.Add( "PlayerButtonUp", "ButtonUpHook", ProcessButtonUp )
--hook.Add( "HUDWeaponPickedUp", "WeaponPickupHook",  )