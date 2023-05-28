local anchorRotate = {};
anchorRotate.__index = anchorRotate;

function anchorRotate.new(frame)
	local self = setmetatable({}, anchorRotate);
	
	self.frame = frame;
	self.absPosition = frame.AbsolutePosition;
	
	return self;
end

function anchorRotate:Rotate(theta)
	local size = self.frame.AbsoluteSize;
	local topLeftCorner = self.absPosition - size*self.frame.AnchorPoint
	
	local offset = size*self.frame.AnchorPoint;
	local center = topLeftCorner + size/2
	local nonRotatedAnchor = topLeftCorner + offset;
	
	local cos, sin = math.cos(theta), math.sin(theta);
	local v = nonRotatedAnchor - center;
	local rv = Vector2.new(v.x*cos - v.y*sin, v.x*sin + v.y*cos);
	
	local rotatedAnchor = center + rv;
	local difference = nonRotatedAnchor - rotatedAnchor;
	
	self.frame.Position = UDim2.new(0, nonRotatedAnchor.x + difference.x + offset.x, 0, nonRotatedAnchor.y + difference.y + offset.y);
	self.frame.Rotation = math.deg(theta);
end

return anchorRotate;