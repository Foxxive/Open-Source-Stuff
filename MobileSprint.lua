local plrs = game:GetService("Players")

local plr = plrs.LocalPlayer 
local char = plr.Character
local hum = char:FindFirstChild("Humanoid")

local ts = game:GetService("TweenService") 

local sprint = false

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

local contextActionService = game:GetService("ContextActionService")
local playerName = script.Parent.Parent.Name
local sprintValue = Instance.new("BoolValue")
sprintValue.Parent = script
local sprint = sprintValue.Value
function onButtonPress()
	if sprint == false then
		sprint = true
		tween1:Play()
		tween3:Play()
	else
		sprint = false
		tween2:Play()
		tween4:Play()
	end
end
local mobilebutton = contextActionService:BindAction("SprintButton",onButtonPress,true,"Sprint")
contextActionService:SetPosition("SprintButton",UDim2.new(0.72,-25,0.20,-25))
contextActionService:SetImage("SprintButton","rbxassetid://2572666627")