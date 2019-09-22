local meta = FindMetaTable( "Player" )

function meta:DrawNextItem()
    local itemIndex = self:GetItemIndex()
    itemIndex = itemIndex + 1;

    if itemIndex > table.Count( self:GetWeapons() ) or itemIndex > 5 then
        itemIndex = 1
    end

    self:SetSelectedItem( itemIndex )

end

function meta:DrawPreviousItem()
    local itemIndex = self:GetItemIndex()
    itemIndex = itemIndex - 1;

    if itemIndex < 1 then
        if table.Count( self:GetWeapons() ) < 5 then
            itemIndex = table.Count( self:GetWeapons() )
        else
            itemIndex = 5
        end
    end

    self:SetSelectedItem( itemIndex )

end

--Sets which inventory slot to select and draws it
function meta:SetSelectedItem( index )
    local playerItems = self:GetWeapons()
    if playerItems[ index ] == nil then
        --Nothing in inventory slot, do nothing
    else
        input.SelectWeapon( playerItems[ index ] )
        self:SetItemIndex( index )
    end

    --If current selected item isn't valid, set the current item index to be invalid
    if playerItems[ self:GetItemIndex() ] == nil then
        self:SetItemIndex( -1 )
    end

end

--Called when a new item is picked up or dropped
function meta:UpdateItems()
    if not self:GetActiveWeapon():IsValid() then
        self:SetItemIndex( -1 )
        print( "Invalid active weapon" )
    elseif table.Count( self:GetWeapons() ) > 5 then
        self:RemoveWeapon( 6 )
    else
        self:SetItemIndex( ( self:GetActiveWeapon() ):GetSlotPos() + 1 )
        print( "Setting new item index to " .. self:GetItemIndex() )
    end
    print( "Updating items" )
end

function meta:PrintItems()
    playerItems = self:GetWeapons()
    for k, v in pairs( playerItems ) do
        print( "Item at index " .. k .. ": " .. v:GetPrintName() )
    end
    
end

function meta:GetItemIndex()
    return self:GetNWInt( "itemindex" )
end

function meta:SetItemIndex( val )
    return self:SetNWInt( "itemindex", val )
end

function meta:RemoveWeapon( index )
    print( "removing weapon at index '" .. index .. "'" )
    local name = self:GetWeapons()[ tonumber( index ) ]:GetClass()
    self:StripWeapon( name )
    self:UpdateItems()
end