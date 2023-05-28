# CPM.lua
How to use:

  CPM requires a little bit of setup before using
  1. Create a screengui and name it "Particles"
  2. Create a frame inside that screengui and also name it "Particles"
  3. Place the [WaitForPath](https://devforum.roblox.com/uploads/short-url/mUXElMJBOjChH6mSyJAim7d0m5p.rbxmx) Module in ReplicatedStorage

  ```lua
  CPM.Fireworks(Amount, Interval)
  ```
  Interval by default is .2

# 2DTriangle.lua
How to add:

  If you are not using [Rojo](https://rojo.space/), Then you'll have to copy the modules directly into roblox using rojo's format:
  <br />The structure is like this:
  <br />  - 2DTriangle (init.lua)
  <br />&nbsp;&nbsp;&nbsp;&nbsp;    - AnchorRotate (AnchorRotate.lua)
     
How to use:

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
