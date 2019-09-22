local meta = FindMetaTable( "Player" )

function meta:SetPlayerVariable( name, value )
    local playerVariables = self.PlayerVariables
    playerVariables[ name ] = value
end

function meta:GetPlayerVariable( name )
    local playerVariables = self.PlayerVariables
    return playerVariables[ name ]
end

