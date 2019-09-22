local pmeta = FindMetaTable( "Player" )

function pmeta:GetPlayerVariable( name )
    local playerVariables = PlayerVariables[ name ]
    return playerVariables[ name ]
end