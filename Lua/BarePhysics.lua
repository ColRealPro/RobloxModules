local RunService = game:GetService("RunService")
local BarePhysics = {}
BarePhysics.__index = BarePhysics

function BarePhysics.new(part: Part)
	local self = setmetatable({}, BarePhysics)

	self._part = part
	self._velocity = Vector3.zero
	self._gravity = workspace.Gravity
	self._timescale = 1
	self._facesDirection = false

	return self
end

function BarePhysics:ApplyVelocity(velocity: Vector3)
	self._velocity = velocity
end

function BarePhysics:SetGravity(gravity: number)
	self._gravity = gravity
end

function BarePhysics:SetTimescale(timescale: number)
	self._timescale = timescale
end

function BarePhysics:SetFacingDirection(enabled: boolean)
	self._facesDirection = enabled
end

function BarePhysics:GetTimeUntilCollision(position: Vector3)
	local currentPosition = self._part.Position
	local currentVelocity = self._velocity
	local gravity = self._gravity

	local a = -0.5 * gravity
	local b = currentVelocity.Y
	local c = currentPosition.Y - position.Y

	local discriminant = b * b - 4 * a * c

	if discriminant < 0 then
		return nil
	end

	local t1 = (-b + math.sqrt(discriminant)) / (2 * a)
	local t2 = (-b - math.sqrt(discriminant)) / (2 * a)

	if t1 < 0 and t2 < 0 then
		return nil
	elseif t1 < 0 then
		return t2
	elseif t2 < 0 then
		return t1
	else
		return math.min(t1, t2)
	end
end

function BarePhysics:Run()
	self._connection = RunService.Heartbeat:Connect(function(deltaTime: number) 
		deltaTime *= self._timescale

		self._velocity -= Vector3.new(0, self._gravity * deltaTime, 0)

		local NextPosition = self._part.Position + self._velocity * deltaTime

		if self._facesDirection then
			self._part.CFrame = CFrame.lookAt(NextPosition, NextPosition + self._velocity)
		else
			self._part.CFrame = CFrame.new(NextPosition)
		end
	end)
end

function BarePhysics:Stop()
	if not self._connection then
		return warn("[BarePhysics] Cannot stop physics because physics is not currently running!")
	end
	
	self._connection:Disconnect()
	self._connection = nil
end

function BarePhysics:Destroy()
	if self._connection then
		self:Stop()
	end
	
	setmetatable(self, nil)
	table.clear(self)
end

return BarePhysics