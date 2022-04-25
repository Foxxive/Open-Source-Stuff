-- This script is if you want to add leaderstats to your Roblox game.

-- Make sure this is a Server Script, not a local script. Place it in ServerScriptService for convenience.


-- Roblox services
local Players = game:GetService("Players")
local TestService = game:GetService("TestService")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("DataStoreValues") --Name the DataStore whatever you want

Players.PlayerAdded:Connect(function(player)

    local leaderstats = Instance.new('Folder')
    leaderstats.Name = 'leaderstats'
    leaderstats.Parent = player


	  local Coins = Instance.new('IntValue') -- This is a leaderstat for the Currency of your game. 
	  Coins.Name = 'Coins' -- You can name this whatever you want.
    Coins.Parent = leaderstats
	  Coins.Value = 0

	local value1Data = Coins


	local s, e = pcall(function()
		value1Data = DataStore:GetAsync(player.UserId..'-Value1') or 0 --check if they have data, if not it'll be "0"
	end)

	if s then
		Coins.Value = value1Data --setting data if the data exists.
	else
		TestService:Error(e)  --if not success then we error it to the console
	end
end)

Players.PlayerRemoving:Connect(function(player)
  local s, e = pcall(function()
	  DataStore:SetAsync(player.UserId..'-Value1', player.leaderstats.Coins.Value) --setting data
      end)
	  if not s then TestService:Error(e) -- Errors if the data failed to save
  	end
end)

game:BindToClose(function(player)
         
      for _, player in ipairs(Players:GetPlayers()) do 
          local s, e = pcall(function()
	            DataStore:SetAsync(player.UserId..'-data', player.leaderstats.Coins.Value) --setting data
                  print("Saved!")
	        if not s then 
            TestService:Error(e) 
            print("Not Saved!")
	        end
        end
     end)
  end)
end)
