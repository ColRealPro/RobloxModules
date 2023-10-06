# CPM.lua
### How to use:

CPM requires a little bit of setup before using
1. Create a screengui and name it "Particles"
2. Create a frame inside that screengui and also name it "Particles"
3. Place the [WaitForPath](https://devforum.roblox.com/uploads/short-url/mUXElMJBOjChH6mSyJAim7d0m5p.rbxmx) Module in ReplicatedStorage

```lua
CPM.Fireworks(Amount, Interval)
```
Interval by default is .2

# 2DTriangle.lua
### How to add:

If you are not using [Rojo](https://rojo.space/), Then you'll have to copy the modules directly into roblox using rojo's format:
<br />The structure is like this:
<br />- 2DTriangle (init.lua)
<br />&nbsp;&nbsp;&nbsp;&nbsp;- AnchorRotate (AnchorRotate.lua)
 
### How to use:

Creating a triangle:
```lua
Triangle2D.new(Angle, Parent, InstanceType)
```
InstanceType by default is "Frame"

Changing the angle:
```lua
local Triangle = Triangle2D.new(45, Parent)
Triangle:ChangeAngle(30)
```

Destroying the triangle:
```lua
local Triangle = Triangle2D.new(45, Parent)
Triangle:Destroy()
```

# ScrollFix.lua
### How to use:

Creating the ScrollFix:
```lua
local Fix = ScrollFix.new(Frame)
```

Starting the ScrollFix:
```lua
local Fix = ScrollFix.new(Frame)
Fix:Start()
```

Stopping the ScrollFix:
```lua
local Fix = SrollFix.new(Frame)
Fix:Stop()
```

### Documentation:

```lua
ScrollFix.new(Frame)
```
Description: Creates a new ScrollFix for the given frame
<br>Params: Frame
<br>Returns: ScrollFix

```lua
ScrollFix:Start()
```
Description: Starts the ScrollFix, this will start automatically scaling the frame
<br>Params: None
<br>Returns: nil 

```lua
ScrollFix:Stop()
```
Description: Stops the ScrollFix, this will stop automatically scaling the frame
<br>Params: None
<br>Returns: nil 

GitHub Copilot: Here is the updated documentation for the `BarePhysics` module:

# BarePhysics.lua
### How to use:

Creating a new physics object:
```lua
local Physics = BarePhysics.new(Part)
```

Starting the simulation:
```lua
local Physics = BarePhysics.new(Part)
Physics:Run()
```

Stopping the simulation:
```lua
local Physics = BarePhysics.new(Part)
Physics:Stop()
```

### Documentation:

```lua
BarePhysics.new(Part)
```
Description: Creates a new physics object for the given part
<br>Params: Part
<br>Returns: BarePhysics

```lua
BarePhysics:ApplyVelocity(velocity: Vector3)
```
Description: Applies the given velocity to the physics object
<br>Params: velocity (Vector3)
<br>Returns: nil

```lua
BarePhysics:SetGravity(gravity: number)
```
Description: Sets the gravity for the physics object
<br>Params: gravity (number)
<br>Returns: nil

```lua
BarePhysics:SetTimescale(timescale: number)
```
Description: Sets the timescale for the physics object
<br>Params: timescale (number)
<br>Returns: nil

```lua
BarePhysics:SetFacingDirection(enabled: boolean)
```
Description: Sets whether the part should face the direction of its velocity
<br>Params: enabled (boolean)
<br>Returns: nil

```lua
BarePhysics:GetTimeUntilCollision(position: Vector3)
```
Description: Gets the time until the part collides with the given position
<br>Params: position (Vector3)
<br>Returns: number or nil

```lua
BarePhysics:Run()
```
Description: Starts the physics simulation for the physics object
<br>Params: None
<br>Returns: nil

```lua
BarePhysics:Stop()
```
Description: Stops the physics simulation for the physics object
<br>Params: None
<br>Returns: nil

```lua
BarePhysics:Destroy()
```
Description: Destroys the physics object and stops the simulation if it is currently running
<br>Params: None
<br>Returns: nil
