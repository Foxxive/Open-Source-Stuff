--// Made by Foxxive or something \\--

--[[
███████╗░█████╗░██╗░░██╗██╗░░██╗██╗██╗░░░██╗███████╗
██╔════╝██╔══██╗╚██╗██╔╝╚██╗██╔╝██║██║░░░██║██╔════╝
█████╗░░██║░░██║░╚███╔╝░░╚███╔╝░██║╚██╗░██╔╝█████╗░░
██╔══╝░░██║░░██║░██╔██╗░░██╔██╗░██║░╚████╔╝░██╔══╝░░
██║░░░░░╚█████╔╝██╔╝╚██╗██╔╝╚██╗██║░░╚██╔╝░░███████╗
╚═╝░░░░░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░╚═╝░░░╚══════╝
]]--


--// This code is actually atrocious but it works i promise \\--
--// Put this in StarterCharacterScripts btw lol \\--

while true do
	wait();
	if game.Players.LocalPlayer.Character then
		break;
	end;
end;
camera = game.Workspace.CurrentCamera;
character = game.Players.LocalPlayer.Character;
Z = 0;
damping = character.Humanoid.WalkSpeed / 2; --[[This is pretty much the speed of the camera bobbing 
you are free to change the character.Humanoid.WalkSpeed / 2 to either a whole number or change the division]]--
PI = 3.1415926;
tick = PI / 2;
running = false;
strafing = false;
character.Humanoid.Strafing:connect(function(p1)
	strafing = p1;
end);
character.Humanoid.Jumping:connect(function()
	running = false;
end);
character.Humanoid.Swimming:connect(function()
	running = false;
end);
character.Humanoid.Running:connect(function(p2)
	if p2 > 0.1 then
		running = true;
		return;
	end;
	running = false;
end);
character.Humanoid.Died:connect(function()
	running = false;
end);
function mix(p3, p4, p5)
	return p4 + (p3 - p4) * p5;
end;
while true do
	local step = game:GetService("RunService").RenderStepped:wait();
	fps = (camera.CoordinateFrame.p - character.Head.Position).Magnitude;
	if fps < 0.52 then
		Z = 0;
	else
		Z = 0;
	end;
	if running == true and strafing == false then
		tick = tick + character.Humanoid.WalkSpeed / 102 * (30*step);
	else
		if tick > 0 and tick < PI / 2 then
			tick = mix(tick, PI / 2, 0.9);
		end;
		if PI / 2 < tick and tick < PI then
			tick = mix(tick, PI / 2, 0.9);
		end;
		if PI < tick and tick < PI * 1.5 then
			tick = mix(tick, PI * 1.5, 0.9);
		end;
		if PI * 1.5 < tick and tick < PI * 2 then
			tick = mix(tick, PI * 1.5, 0.9);
		end;
	end;
	if PI * 2 <= tick then
		tick = 0;
	end;
	camera.CoordinateFrame = camera.CoordinateFrame * CFrame.new(math.cos(tick) / damping, math.sin(tick * 2) / (damping * 2), Z) * CFrame.Angles(0, 0, math.sin(tick - PI * 1.5) / (damping * 20));
end;

--// You are free to modify this as you please \\--