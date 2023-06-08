local ScrollFix = {}
ScrollFix.__index = ScrollFix

type ScrollFix = {
    -- // Properties
    Frame : Frame,
    CanvasSize : Vector2,
    Scale : UDim2,
    Padding : UIPadding | nil,

    --// Functions
    Start : () -> (),
    Update : () -> (),
    Stop : () -> (),

    -- // Connections
    Connection : RBXScriptConnection | nil,
    CanvasConnection : RBXScriptConnection | nil,
}

function ScrollFix.new(Frame: Frame) : ScrollFix
	assert(Frame.Parent and Frame.Parent:IsA("ScrollingFrame"), "Frame must be parented to a ScrollingFrame")
	local self = setmetatable({}, ScrollFix)

	self.Frame = Frame
	self.CanvasSize = Frame.Parent.AbsoluteCanvasSize

	return self
end

function ScrollFix:Start()
	self.CanvasSize = self.Frame.Parent.AbsoluteCanvasSize
	self.Scale = self.Frame.Size

	if self.Frame.Parent:FindFirstChild("UIPadding") then
		self.Padding = self.Frame.Parent.UIPadding
	end

	self:Update()
	self.Connection = self.Frame.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:Update()
	end)
    
    self.CanvasConnection = self.Frame.Parent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        self:Update()
    end)
end

function ScrollFix:Update()
	self.CanvasSize = self.Frame.Parent.AbsoluteCanvasSize
	self.Frame.Size = UDim2.fromOffset(
		self.Scale.X.Offset
			+ (self.Scale.X.Scale * self.CanvasSize.X)
			- (self.Padding.PaddingLeft.Offset + self.Padding.PaddingRight.Offset),
		self.Scale.Y.Offset
			+ (self.Scale.Y.Scale * self.CanvasSize.Y)
			- (self.Padding.PaddingTop.Offset + self.Padding.PaddingBottom.Offset)
	)
end

function ScrollFix:Stop()
	self.Connection:Disconnect()
    self.CanvasConnection:Disconnect()
end

return ScrollFix
