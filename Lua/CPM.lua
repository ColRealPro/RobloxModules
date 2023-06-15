--!strict

--[[
                                                                                                                                                                 
                                                                                                                                        .--,-``-.                
  .--.--.                      ____              ,--,                       .--.--.                                            ___     /   /     '.              
 /  /    '.   ,--,           ,'  , `.,-.----.  ,--.'|                      /  /    '.                     ,--,   ,-.----.    ,--.'|_  / ../        ;       ,---, 
|  :  /`. / ,--.'|        ,-+-,.' _ |\    /  \ |  | :                     |  :  /`. /            __  ,-.,--.'|   \    /  \   |  | :,' \ ``\  .`-    '    ,---.'| 
;  |  |--`  |  |,      ,-+-. ;   , |||   :    |:  : '                     ;  |  |--`           ,' ,'/ /||  |,    |   :    |  :  : ' :  \___\/   \   :    |   | : 
|  :  ;_    `--'_     ,--.'|'   |  |||   | .\ :|  ' |        .--,         |  :  ;_       ,---. '  | |' |`--'_    |   | .\ :.;__,'  /        \   :   |    |   | | 
 \  \    `. ,' ,'|   |   |  ,', |  |,.   : |: |'  | |      /_ ./|          \  \    `.   /     \|  |   ,',' ,'|   .   : |: ||  |   |         /  /   /   ,--.__| | 
  `----.   \'  | |   |   | /  | |--' |   |  \ :|  | :   , ' , ' :           `----.   \ /    / ''  :  /  '  | |   |   |  \ ::__,'| :         \  \   \  /   ,'   | 
  __ \  \  ||  | :   |   : |  | ,    |   : .  |'  : |__/___/ \: |           __ \  \  |.    ' / |  | '   |  | :   |   : .  |  '  : |__   ___ /   :   |.   '  /  | 
 /  /`--'  /'  : |__ |   : |  |/     :     |`-'|  | '.'|.  \  ' |          /  /`--'  /'   ; :__;  : |   '  : |__ :     |`-'  |  | '.'| /   /\   /   :'   ; |:  | 
'--'.     / |  | '.'||   | |`-'      :   : :   ;  :    ; \  ;   :         '--'.     / '   | '.'|  , ;   |  | '.'|:   : :     ;  :    ;/ ,,/  ',-    .|   | '/  ' 
  `--'---'  ;  :    ;|   ;/          |   | :   |  ,   /   \  \  ;           `--'---'  |   :    :---'    ;  :    ;|   | :     |  ,   / \ ''\        ; |   :    :| 
            |  ,   / '---'           `---'.|    ---`-'     :  \  \                     \   \  /         |  ,   / `---'.|      ---`-'   \   \     .'   \   \  /   
             ---`-'                    `---`                \  ' ;                      `----'           ---`-'    `---`                `--`-,,-'      `----'    
                                                             `--`                                                                                                
]]

--[[
	How to use:
		1. Require it lol
		2. call .Fireworks(Amount, Interval) Interval defaults to 0.2
	Example:
		require(game.ReplicatedStorage.Modules.CPM).Fireworks(50, 0.3)	
]]

local TweenService = game:GetService("TweenService")
local Camera = game.Workspace.CurrentCamera
local WaitForPath = require(game.ReplicatedStorage.WaitForPath)
local Player = game.Players.LocalPlayer
local ParticlesGui = WaitForPath(Player, "PlayerGui.Particles.Particles")
local cpm = {}
local debug = false
local VisualDebug = false

-- Checks weather a position is on the left or right of a position
function getSideX(CheckPos: UDim2, Position: number)
	if CheckPos.X.Offset <= Position then
		return "Left"
	else
		return "Right"
	end
end

-- Udim2 to vector 2 from offset, simple
function Udim2ToVector2(Position: UDim2)
	return Vector2.new(Position.X.Offset, Position.Y.Offset)
end

-- lerp between two points
function lerp(a: number, b: number, t: number)
	return a + (b - a) * t
end

function MoveAndConvertUniform2DPoints(Points: {}, MoveTo: UDim2)
	local NewPoints = {} -- creates an empty table to store all the new points inside
	for i, v: Vector2 in pairs(Points) do -- loops through all of the provied points
		local newPoint = UDim2.new(0, MoveTo.X.Offset - v.X + 150, 0, MoveTo.Y.Offset - v.Y + 150) -- Converts it to a udim2 as well as moving it to the specified position (150 because thats how big the uniform2d is)
		table.insert(NewPoints, newPoint) -- inserts it into the new points table
	end
	return NewPoints
end

function CreateUniform2D(Points: number, Resolution: number)
	local PointsTable = {} -- creates an empty table to store all the points

	for i = 1, Points do
		local pos = Vector2.new(math.random(1, Resolution), math.random(1, Resolution)) -- Generates a random position within the resolution
		local function checkPos() -- function to check if the position is already inside the table, if it is then regenerate it
			if table.find(PointsTable, pos) then -- check if its in the table
				pos = Vector2.new(math.random(1, Resolution), math.random(1, Resolution)) -- regenerate
				checkPos() -- call the function again to make sure its not in the table again (rare chance)
			end
		end
		checkPos()
		table.insert(PointsTable, pos) -- inserts the position into the pointsTable
	end

	return { Resolution = Resolution, Points = PointsTable } -- returns the resolution as well as the points
end

function getPointsFromUniform2D(Uniform2D: {}, Radius: number)
	local Resolution: number = Uniform2D["Resolution"] -- Get resolution from the uniform 2d
	local Points = Uniform2D["Points"] -- Get points from the uniform 2d

	local randomPos = Vector2.new(Resolution / 2, Resolution / 2) -- This used to be a random position (hence the name of the variable) but i hardcoded it to the center
	local ValidPoints = {} -- creates an empty table to store all the points inside of the circle into
	for i, v: Vector2 in pairs(Points) do -- Loop through all points
		if (v - randomPos).Magnitude <= Radius then -- Checks if the point is in the circle (by checking if the magnitude is less than or equal to radius)
			table.insert(ValidPoints, v) -- insert the valid point into the Valid Points
		end
	end
	if debug then -- just a debug print
		print("CPM Debug: PointsInUniform2D: " .. #ValidPoints)
	end
	return ValidPoints
end

-- Optimization purposes, allow the module to reuse the dead frames
local Reusables = {
	Fireworks = {},
	Smoke = {},
}

-- Create the explosion
function FireworkExplosion(Position: UDim2)
    local AbsolutePosition = Udim2ToVector2(Position) -- Convert the position to a vector2
	local ResolutionX = Camera.ViewportSize.X
	local ResolutionY = Camera.ViewportSize.Y
	local random = Random.new()
	local randomSize = 0.0055 -- used to be a random size but I hardcoded it to 0.0055 because it looked funky on mobile devices
	local sound = Instance.new("Sound") -- Create an explosion sound
	sound.Volume = 0.4
	sound.SoundId = "rbxassetid://269146157"
	sound.Parent = workspace
	sound:Play()
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
	local VectorPoints = getPointsFromUniform2D(CreateUniform2D(120, 250), 100) -- Get the points inside a new uniform 2d
	local MiddlePoints =
		MoveAndConvertUniform2DPoints(getPointsFromUniform2D({ Resolution = 250, Points = VectorPoints }, 50), Position) -- Get points in a circle with a radius of 50 from the uniform 2d
	local AllPoints = MoveAndConvertUniform2DPoints(VectorPoints, Position) -- Move and convert the uniform 2d to the explosion position
	local OutsideHue = random:NextNumber(100, 500) % 5 / 5 -- random hue
	local OutsideColor = Color3.fromHSV(OutsideHue, 1, 1) -- random color
	local InsideHue = random:NextNumber(100, 500) % 5 / 5 -- random hue
	local InsideColor = Color3.fromHSV(InsideHue, 1, 1) -- random color
	local TemplateFrame = Instance.new("Frame") -- Template frame (For optimization)
	TemplateFrame.Size = UDim2.new(0, randomSize * ResolutionY, 0, randomSize * ResolutionY)
	TemplateFrame.BorderSizePixel = 0
	TemplateFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	for i, v in pairs(AllPoints) do -- Loop through all points
		if VisualDebug then -- if visual debug then create a frame for each point
			local debugframe = Instance.new("Frame")
			debugframe.Size = UDim2.new(0, randomSize * ResolutionY, 0, randomSize * ResolutionY)
			debugframe.BorderSizePixel = 0
			if not table.find(MiddlePoints, v) then
				debugframe.BackgroundColor3 = OutsideColor
			else
				debugframe.BackgroundColor3 = InsideColor
			end
			debugframe.AnchorPoint = Vector2.new(0.5, 0.5)
			debugframe.Position = v
			debugframe.Parent = ParticlesGui
		end
		local frame
		-- Reuse dead frames (Optimizations)
		if #Reusables.Fireworks > 0 then
			frame = Reusables.Fireworks[1]
			table.remove(Reusables.Fireworks, 1)
		elseif #Reusables.Smoke > 0 then
			frame = Reusables.Smoke[1]
			table.remove(Reusables.Smoke, 1)
		else
			frame = TemplateFrame:Clone() -- No reusable frame, Create a new frame
		end
		if not table.find(MiddlePoints, v) then -- Check if the point is on the outside
			frame.BackgroundColor3 = OutsideColor -- Set color to outside color
		else
			frame.BackgroundColor3 = InsideColor -- Set color to inside color
		end
		frame.Position = Position -- Move frame to the explosion position
		local diff = Udim2ToVector2(v) - AbsolutePosition
		local angle = math.atan2(diff.Y, diff.X) -- get angle
		frame.Rotation = math.deg(angle) -- set rotation
		frame.Parent = ParticlesGui -- parent frame to particles ui
		local direction = Vector2.new(math.cos(frame.Rotation), math.sin(frame.Rotation)) -- get direction
		local speed: number = 0 -- speed of frame (0 because its set below)
		if not table.find(MiddlePoints, v) then
			speed = (ResolutionY * 0.26) * (128 / (VectorPoints[i] - Vector2.new(0, 0)).Magnitude) -- Outside Point
		else
			speed = ResolutionY * 0.26 * (50 / (VectorPoints[i] - Vector2.new(0, 0)).Magnitude) -- Inside Point
		end
		local goal = {} -- empty table, properties below
		goal.Position = UDim2.fromOffset(
			AbsolutePosition.X + direction.X * speed,
			AbsolutePosition.Y + direction.Y * speed
		)
		goal.BackgroundTransparency = 1

		local info = TweenInfo.new(1.5) -- new tween info of 1.5 seconds

		local tween = TweenService:Create(frame, info, goal) -- create the tween
		tween:Play() -- play the tween
		tween.Completed:Connect(function()
			table.insert(Reusables.Fireworks, frame) -- Insert it to the reusables to be reused
			frame.Parent = nil -- parent it to nil
			frame.BackgroundTransparency = 0 -- make visible
			task.delay(60, function() -- after 60 seconds, remove the frame
				if table.find(Reusables.Fireworks, frame) then
					table.remove(Reusables.Fireworks, table.find(Reusables.Fireworks, frame))
					frame:Destroy()
				end
			end)
		end)
	end
end

function LaunchParticle(Type: string)
	local ResolutionX = Camera.ViewportSize.X
	local ResolutionY = Camera.ViewportSize.Y

	local LaunchPosX = math.random((0.1 * ResolutionX), ResolutionX - (0.1 * ResolutionX)) -- get random position on x
	local GoalPosX = math.random(LaunchPosX - (0.1 * ResolutionX), LaunchPosX + (0.1 * ResolutionX)) -- get another random position on x with a max of .1 distance from the original position
	local height = math.random((0.2 * ResolutionY), ResolutionY - (0.33 * ResolutionY)) -- get random height for it to explode at, only 2/3 of the screen can be used
	if debug then -- debug
		print("CPM Debug: LaunchPosX: " .. LaunchPosX)
		print("CPM Debug: Height: " .. height)
	end
	if VisualDebug then -- visual debug (was used to show the position it would explode at and the launch pos, was never made for goal pos because i only used it during early dev)
		local debugframe = Instance.new("Frame")
		debugframe.Size = UDim2.new(0, 5, 0, 5)
		debugframe.BorderSizePixel = 0
		debugframe.BackgroundColor3 = Color3.fromRGB(255, 137, 34)
		debugframe.AnchorPoint = Vector2.new(0.5, 0.5)
		debugframe.Position = UDim2.new(0, LaunchPosX, 0, height)
		debugframe.Parent = ParticlesGui
	end
	local currentheight = ResolutionY -- Put current height at bottom of screen
	local inrow = { Val = 0, Inrow = 0 } -- just a thing to make it so it can only go to one side 3 times in a row
	local templateFrame = Instance.new("Frame") -- template frame (Optimizations)
	local randomSize = --[[random:NextNumber(0.0047, 0.0055)]]
		0.0055 -- used to be a random size (You can see the old code for it) removed because funky on mobile
	templateFrame.Size = UDim2.new(0, randomSize * ResolutionY, 0, randomSize * ResolutionY)
	templateFrame.BorderSizePixel = 0
	templateFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	templateFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	local function fire() -- Fire function (cause of delta time)
		local stateHeight = currentheight -- create another variable with the value of current height because there used to be a task.delay is used and current height would be different
		local percent = (currentheight - ResolutionY) / (height - ResolutionY) -- reverse lerp
		local random = Random.new()
		local SmokeFrame
		-- Reuse dead frames (Optimizations)
		if #Reusables.Smoke > 0 then
			SmokeFrame = Reusables.Smoke[1]
			table.remove(Reusables.Smoke, 1)
		elseif #Reusables.Fireworks > 0 then
			SmokeFrame = Reusables.Fireworks[1]
			SmokeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			table.remove(Reusables.Fireworks, 1)
		else
			SmokeFrame = templateFrame:Clone()
		end
		local Pos = UDim2.new(
			0,
			math.random(lerp(LaunchPosX, GoalPosX, percent) - 7, lerp(LaunchPosX, GoalPosX, percent) + 7),
			0,
			currentheight
		) -- get the position where the frame is supposed to be (lerps between the x launch pos and the goal launch pos so it rotates a little)
		SmokeFrame.Position = Pos -- set pos
		SmokeFrame.Parent = ParticlesGui -- set parent
		--task.delay(random:NextNumber(.05, .12), function()
		--local side = getSideX(Pos, LaunchPosX)
		local side = math.random(1, 2) -- get side to move to
		if inrow.Inrow == 3 then -- ensure it cannot be the same 3 times in a row
			inrow.Inrow = 0
			if inrow.Val == 1 then
				side = 2
			else
				side = 1
			end
		else
			if inrow.Val == side then
				inrow.Inrow += 1
			end
			inrow.Val = side
		end
		local Goal = {} -- properties below
		Goal.BackgroundTransparency = 1

		local Time = random:NextNumber(0.3, 0.65) -- random time between .3 and .65 (lifetime)

		local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear) -- tweeninfo, the linear wasnt needed but I added it anyway

		local Tween = TweenService:Create(SmokeFrame, Info, Goal) -- create tween
		Tween:Play() -- play tween
		Tween.Completed:Connect(function()
			-- Turn frame into a dead frame
			table.insert(Reusables.Smoke, SmokeFrame) -- allow reusing
			SmokeFrame.Parent = nil -- parent it to nil
			SmokeFrame.BackgroundTransparency = 0 -- make it visible again
			task.delay(60, function() -- after 60 seconds, destroy the frame
				if table.find(Reusables.Smoke, SmokeFrame) then
					table.remove(Reusables.Smoke, table.find(Reusables.Smoke, SmokeFrame))
					SmokeFrame:Destroy()
				end
			end)
		end)
		local Goal2 = {} -- properties below

		if side == 1 then -- if the side is 1 then move it to the left
			Goal2.Position = UDim2.new(0, math.random(Pos.X.Offset - 25, Pos.X.Offset - 9), 0, stateHeight + 55)
		else -- if the side is 2 then move it to the right
			Goal2.Position = UDim2.new(0, math.random(Pos.X.Offset + 9, Pos.X.Offset + 25), 0, stateHeight + 55)
		end

		local Info2 = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In) -- tweeninfo, linear and in were not needed

		local Tween2 = TweenService:Create(SmokeFrame, Info2, Goal2) -- Create tween
		Tween2:Play() -- play tween
		--end)
	end
	repeat
		local dt = task.wait(0.01) -- task.wait returns how long it took to wait that amount of time
		local iterations = math.floor(dt / 0.01) -- get the number of iterations passed during that time
		for _ = 1, iterations do -- create a frame for each iteration
			if currentheight < height then
				break
			end
			currentheight -= ResolutionY * 0.0125
			fire()
		end
	until currentheight <= height
	if Type == "Firework" then -- if the type is firework (fireworks are the only thing supported rn) then create a firework explosion at the goal pos
		FireworkExplosion(UDim2.new(0, GoalPosX, 0, height))
	end
end

function cpm.Fireworks(Amount: number, Interval: number) -- function used to launch the fireworks
	if Interval == nil then -- if no interval is specified, default to .2
		Interval = 0.2
	end
	for _ = 1, Amount do -- loop until the amount of fireworks specified have all been created
		task.spawn(function() -- create a new thread
			LaunchParticle("Firework") -- launch it
		end)
		task.wait(Interval) -- wait the specified interval
	end
end

return cpm
