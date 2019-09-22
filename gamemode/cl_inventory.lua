local meta = FindMetaTable( "Player" )

function meta:InitializeInventoryPanel()
    frame = vgui.Create( "DFrame" )
    frame:SetPos( 500, 500 )
    frame:SetSize( 960 + 9 * 15, 700 )
    frame:SetTitle( "Inventory" )
    frame:SetAlpha( 100 )
    frame:SetVisible( false )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame:SetKeyBoardInputEnabled(false)
    frame:Center()
    panelVisible = false

    inventoryGrid = {}

    for row = 1, 4 do
        for col = 1, 8 do
            local panel = vgui.Create( "DPanel", frame )
            panel:SetPos( 15 + 135 * ( col - 1 ), 50 + ( 135 * ( row - 1 ) ) )
            panel:SetSize( 120, 120 )
            local index = ( ( row - 1 ) * 8 ) + col
            local inventorySlot = { panel, index }
            local label = vgui.Create( "DLabel", panel )
            label:SetPos( 15, 15 )
            label:SetText( index )
            label:SetDark( 1 )
            inventoryGrid[ index ] = inventorySlot
            print( "Adding panel to index " .. index )
        end
    end

    local image = vgui.Create( "DImage", inventoryGrid[1][1] )
    image:SetSize( 100, 100 )
    image:Center()
    image:SetImage( "ar.jpg" )

end

function meta:ShowPanel()
    if not frame then self:InitializeInventoryPanel() end

    if not panelVisible then
        panelVisible = true
        frame:SetVisible( panelVisible )
        frame:SetMouseInputEnabled( panelVisible )
    end
end

function meta:HidePanel()
    if not frame then self:InitializeInventoryPanel() end

    if panelVisible then
        panelVisible = false
        frame:SetVisible( panelVisible )
        frame:SetMouseInputEnabled( panelVisible )
    end
end

function meta:TogglePanel()
    if panelVisible then
        self:HidePanel()
    else
        self:ShowPanel()
    end
end