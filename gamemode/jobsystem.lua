local meta = FindMetaTable( "Player" )

function meta:SetJob( jobname )

    if jobname == "citizen" then
        self:SetSalary( 50 )
        self:SetNWString( "job", "citizen" )
        print( "player job is citizen" )
    end
end