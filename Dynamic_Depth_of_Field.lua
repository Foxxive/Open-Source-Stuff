--// Made by Foxxive \\--

--[[           ______ ______   ____   _________      ________ 
		  ____ |  ____/ __ \ \ / /\ \ / /_   _\ \    / /  ____|
		 / __ \| |__ | |  | \ V /  \ V /  | |  \ \  / /| |__   
		/ / _` |  __|| |  | |> <    > <   | |   \ \/ / |  __|  
	   | | (_| | |   | |__| / . \  / . \ _| |_   \  /  | |____ 
		\ \__,_|_|    \____/_/ \_\/_/ \_\_____|   \/   |______|
		 \____/                                                
															    ]]


-- creates new DOF effect, make sure you don't have another one already because it'll do weird stuff
local DOF = Instance.new("DepthOfFieldEffect", game.Lighting)
DOF.InFocusRadius = 0
DOF.NearIntensity = 0

local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- how far the object can be before it focuses
local focusRadius = 6

-- TweenService is messy, you can change this if you like lol
function Lerp(a, b, t)
	return a + (b - a) * t
end

-- checks if the camera is fully zoomed in, because you can't check if the player is in first person for some reason
function isFirstPerson()
	local cameraDistance = (camera.CFrame.Position - camera.Focus.Position).Magnitude
	return (cameraDistance < 1)
end

game:GetService("RunService").RenderStepped:Connect(function(dt)
	local ignoreList = isFirstPerson() and {character} or {}

	local camRay = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector * focusRadius)
	local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(camRay, ignoreList)

	-- this is so transparent stuff doesn't break, change the value if you want
	if hit and hit.Transparency < 0.3 then
		local distanceFromCamera = (hitPosition - camera.CFrame.Position).Magnitude
		local intensity = focusRadius / distanceFromCamera * 0.25
		DOF.FocusDistance = distanceFromCamera
		DOF.FarIntensity = Lerp(DOF.FarIntensity, intensity, dt * 8)
	else
		DOF.FarIntensity = Lerp(DOF.FarIntensity, 0, dt * 8)
	end
end)