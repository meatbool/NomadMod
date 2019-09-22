local meta = FindMetaTable( "Player" )

function meta:SetMoney( amount )
    self:SetNWInt( "money", amount )
end

function meta:GetMoney()
    return self:GetNWInt( "money" )
end

function meta:AddMoney( amount )
    self:SetNWInt( "money", self:GetNWInt( "money" ) + amount )
    print( "Money: " .. self:GetMoney() )
end

function meta:SetSalary( amount )
    self:SetNWInt( "salary", amount )
end

function meta:GetSalary()
    return self:GetNWInt( "salary" )
end

function meta:PayDay()
    self:AddMoney( self:GetNWInt( "salary" ) )
    self:ChatPrint( "You have received a paycheck for $" .. self:GetSalary() .. "!" )
end
