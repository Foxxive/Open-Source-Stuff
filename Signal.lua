local signal = {}
signal.__index = signal

local connection = {}
connection.__index = connection

-- connection methods --

function connection:Disconnect()
	assert(self:IsConnection(), 'Attempt to call member function Connection.Disconnect on a non-connection value')
	for k, v in ipairs(self.orgSelf.Connections) do
		if v == self then
			table.remove(self.orgSelf.Connections, k)
		end
	end
	self.Connected = false
	setmetatable(self, nil)
end
connection.disconnect = connection.Disconnect

function connection:IsConnection()
	return true
end

-- signal methods --

function signal.new()
	return setmetatable({
		['_connections'] = {};
		['_yields'] = {};
	}, signal)
end

function signal:Fire(...)
	assert(self:IsSignal(), 'Attempt to call member function Signal.Fire on a non-signal value!')
	for _, v in ipairs(self._connections) do
		coroutine.wrap(v.func)(...)
	end

	for k, v in ipairs(self._yields) do
		coroutine.resume(v, ...)
		table.remove(self._yields, k)
	end
end
signal.fire = signal.Fire

function signal:Connect(func)
	assert(self:IsSignal(), 'Attempt to call member function Signal.Connect on a non-signal value!')
	local connection = setmetatable({
		func = func;
		orgSelf = self;
		Connected = true
	}, connection)

	table.insert(self._connections, connection)
	return connection
end
signal.connect = signal.Connect

function signal:Wait()
	assert(self:IsSignal(), 'Attempt to call member function Signal.Wait on a non-signal value!')
	table.insert(self._yields, coroutine.running())
	return coroutine.yield()
end
signal.wait = signal.Wait

function signal:Destroy()
	assert(self:IsSignal(), 'Attempt to call member function Signal.Destroy on a non-signal value!')
	
	for _, v in ipairs(self._connections) do
		v:Disconnect()
	end
	for _, v in ipairs(self._yields) do
		coroutine.resume(v)
	end

	setmetatable(self, nil)
end
signal.destroy = signal.Destroy

return signal
