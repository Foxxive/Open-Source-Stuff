local module = {
    instanceTypes = {
        ['boolean'] = 'BoolValue';
        ['string'] = 'StringValue';
        ['number'] = 'NumberValue';
    };
    ToInstance = function(self, tbl, parent)
        for i,v in pairs(tbl) do
            local number = tonumber(v)
            if number then
                tbl[i] = number
            end
            if type(v) == 'table' then
                local currentFolder = Instance.new('Folder')
                currentFolder.Parent = parent
                currentFolder.Name = i
                self:ToInstance(v, currentFolder)
            else
                for i2,v2 in pairs(self.instanceTypes) do
                    if type(v) == i2 then
                        local currentValue = Instance.new(v2)
                        currentValue.Parent = parent
                        currentValue.Name = i
                        currentValue.Value = v
                    end
                end
            end
        end
    end;

    ToTable = function(self, parent)
        local function currentFunction(newParent)
            local returnedData = {}
            for i,v in pairs(newParent:GetChildren()) do
                if v:IsA('Folder') then
                    returnedData[v.Name] = currentFunction(v)
                else
                    returnedData[v.Name] = v.Value
                end
            end
            return returnedData
        end
        local constructedTable = currentFunction(parent)
        return constructedTable
    end;
};

return module
