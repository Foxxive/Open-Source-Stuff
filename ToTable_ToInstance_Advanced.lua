local values = {
	['string'] = 'StringValue';
	['number'] = 'IntValue';
	['boolean'] = 'BoolValue';
	['BrickColor'] = 'BrickColorValue';
	['Instance'] = 'ObjectValue';
	['Vector3'] = 'Vector3Value';
	['CFrame'] = 'CFrameValue';
	['Color3'] = 'Color3Value';
	['Ray'] = 'RayValue';
}

local module = {
	['instanceTypes'] = {
		['string'] = 'StringValue';
		['number'] = 'IntValue';
		['boolean'] = 'BoolValue';
	};
	['SpecialTypes'] = {
		['BrickColor'] = 'BrickColorValue';
		['Vector3'] = 'Vector3Value';
		['CFrame'] = 'CFrameValue';
		['Color3'] = 'Color3Value';
		['Ray'] = 'RayValue';
	};
	['ToTableFunctions'] = {
		['BrickColor'] = function(brickColor)
			return {
				['__SPECTYPE'] = 'BrickColor';
				['Value'] = brickColor.Name
			}
		end;
		['Vector3'] = function(vector3)
			return {
				['__SPECTYPE'] = 'Vector3';
				['Value'] = {
					vector3.X;
					vector3.Y;
					vector3.Z;
				}
			}
		end;
		['CFrame'] = function(cFrame)
			local tbl =  {
				['__SPECTYPE'] = 'CFrame';
				['Value'] = table.pack(cFrame:GetComponents())
			}
			tbl.Value.n = nil
			return tbl
		end;
		['Color3'] = function(color3)
			return {
				['__SPECTYPE'] = 'Color3';
				['Value'] = {
					color3.R;
					color3.G;
					color3.B;
				};
			}
		end;
		['Ray'] = function(ray)
			return {
				['__SPECTYPE'] = 'Ray';
				['Value'] = {
					ray.Origin.X;
					ray.Origin.Y;
					ray.Origin.Z;
					ray.Direction.X;
					ray.Direction.Y;
					ray.Direction.Z;
				}
			}
		end;
	};
	['ToInstanceFunctions'] = {
		['BrickColor'] = function(tbl)
			local obj = Instance.new('BrickColorValue')
			obj.Value = BrickColor.new(tbl.Value)
			return obj
		end;
		['Vector3'] = function(tbl)
			local obj = Instance.new('Vector3Value')
			obj.Value = Vector3.new(table.unpack(tbl.Value))
			return obj
		end;
		['CFrame'] = function(tbl)
			local obj = Instance.new('CFrameValue')
			obj.Value = CFrame.new(table.unpack(tbl))
			return obj
		end;
		['Color3'] = function(tbl)
			local obj = Instance.new('Color3Value')
			obj.Value = Color3.new(table.unpack(tbl.Value))
			return obj
		end;
		['Ray'] = function(tbl)
			local obj = Instance.new('RayValue')
			obj.Value = Ray.new(Vector3.new(table.unpack(tbl.Value, 1, 3)), Vector3.new(table.unpack(tbl.Value, 4, 6)))
			return obj
		end;
	};
	['ToTableForDataStore'] = function(self, folder)
		local compiledTable = {}
		for i,v in pairs(folder:GetChildren()) do
			local dataType = typeof(v.Value)
			if v:IsA('Folder') then
				compiledTable[v.Name] = self:ToTableForDataStore(v)
			else
				if self.instanceTypes[typeof(v.Value)] then
					compiledTable[v.Name] = v.Value
				else
					compiledTable[v.Name] = self.ToTableFunctions[dataType](v.Value)
				end
			end
		end
		return compiledTable
	end;
	['ToInstanceFromDataStore'] = function(self, tbl, folder)
		for i,v in pairs(tbl) do
			local currentType = type(v)
			if currentType == 'table' then
				local typeFromDS = v.__SPECTYPE
				if typeFromDS then
					local obj = self.ToInstanceFunctions[typeFromDS](v)
					obj.Parent = folder
					obj.Name = i
				else
					local currentObj = Instance.new('Folder')
					currentObj.Parent = folder
					currentObj.Name = i
					self:ToInstanceFromDataStore(v, currentObj)
				end
			else
				local currentObj = Instance.new(currentType)
				currentObj.Parent = folder
			end
		end
		return folder
	end;
}

return module
