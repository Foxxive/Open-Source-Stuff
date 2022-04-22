local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")

local plr = plrs.LocalPlayer 
local char = plr.Character
local hum = char:FindFirstChild("Humanoid")

local ts = game:GetService("TweenService") 

local default = 70
local nowfov = 90
local walkSpeed = 10

local properties = {FieldOfView = default + 20}
local properties2 = {FieldOfView = nowfov - 20}
local properties3 = {WalkSpeed = 20}
local properties4 = {WalkSpeed = 10}

local tweenInfo = TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
local info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local tween1 = ts:Create(game.Workspace.CurrentCamera, info, properties)
local tween2 = ts:Create(game.Workspace.CurrentCamera, info, properties2)
local tween3 = ts:Create(hum,tweenInfo, properties3)
local tween4 = ts:Create(hum,tweenInfo,properties4)

uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then 
		tween1:Play()
		tween3:Play()
		uis.InputEnded:Connect(function(input) 
			if input.KeyCode == Enum.KeyCode.LeftShift then
				tween2:Play()
				tween4:Play() 
			end
		end)
	end
end)