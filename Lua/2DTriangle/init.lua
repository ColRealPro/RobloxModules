local Triangle = {}
Triangle.__index = Triangle

local AnchorRotate = require(script.AnchorRotate)

function Triangle.new(angle, parent, type)
    local self = setmetatable({}, Triangle)
    self.Canvas = Instance.new("CanvasGroup")
    self.Canvas.BackgroundTransparency = 1
    self.Canvas.Parent = parent
    self.Canvas.Size = UDim2.new(.5,0,.5,0)

    self.AspectRatio = Instance.new("UIAspectRatioConstraint")
    self.AspectRatio.Parent = self.Canvas

    self.Frame = Instance.new(type or "Frame")
    self.Frame.Parent = self.Canvas
    self.Frame.AnchorPoint = Vector2.new(1,0)
    self.Frame.Size = UDim2.new(2,0,1,0)
    
    local rotateCanvas = angle > 0
    angle = math.abs(angle)

    local angleRad = math.rad(angle)
    local base = self.Canvas.AbsoluteSize.Y / math.tan(angleRad)
    local rest = self.Canvas.AbsoluteSize.X - base

    local scaleRest = math.clamp(rest / self.Canvas.AbsoluteSize.X, 0, 1)

    self.Frame.Position = UDim2.new(scaleRest,0,0,0)

    local anchorRotate = AnchorRotate.new(self.Frame)
    anchorRotate:Rotate(math.rad(angle+180))
    
    if rotateCanvas then
        self.Canvas.Rotation = 180
    end

    return self
end

function Triangle:ChangeAngle(newAngle)
    self.Canvas.Rotation = 0

    local OriginalPos = self.Canvas.Position
    local OriginalAnchorPoint = self.Canvas.AnchorPoint

    self.Canvas.AnchorPoint = Vector2.zero
    self.Canvas.Position = UDim2.new()

    local rotateCanvas = newAngle > 0
    newAngle = math.abs(newAngle)

    local angleRad = math.rad(newAngle)
    local base = self.Canvas.AbsoluteSize.Y / math.tan(angleRad)
    local rest = self.Canvas.AbsoluteSize.X - base

    local scaleRest = math.clamp(rest / self.Canvas.AbsoluteSize.X, 0, 1)

    self.Frame.Position = UDim2.new(scaleRest,0,0,0)

    local anchorRotate = AnchorRotate.new(self.Frame)
    anchorRotate:Rotate(math.rad(newAngle+180))

    if rotateCanvas then
        self.Canvas.Rotation = 180
    end

    self.Canvas.AnchorPoint = OriginalAnchorPoint
    self.Canvas.Position = OriginalPos
end

function Triangle:Destroy()
    self.Canvas:Destroy()
    setmetatable(self, nil)
end

return Triangle