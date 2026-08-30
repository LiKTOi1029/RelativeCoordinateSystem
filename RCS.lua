local RCS = {}
local Coordinates
local FacingDirection = 0
local Dir
local Absolute

function RCS.Init()
  Dir = shell.dir()
  Absolute = shell.resolve(Dir)
  print(Absolute)
end

function RCS.UpdateCoordintes()
  
end

function RCS.Move(Direction)
  
end

function RCS.Turn(Direction)
  
end

RCS.Init()

return RCS