local AllDebuggingProtocols = 
{
  ["DEBUG"] = "[DEBUG]: ",
  ["ERROR"] = "[ERROR]: ",
  ["WARNING"] = "[WARNING]: ",
  ["INFO"] = "[INFO]: ",
  ["FETCH"] = "[FETCH]: ",
  ["FAILED"] = "[FAILED]: ",
  ["SUCCESS"] = "[SUCCESS]: ",
}
local MovementDirectionMappings = 
{
  ["up"] = turtle.up,
  ["forward"] = turtle.forward,
  ["down"] = turtle.down,
  ["back"] = turtle.back,
}
local NumericDirectionMappings = 
{
  [0] = MovementDirectionMappings["up"],
  MovementDirectionMappings["forward"],
  MovementDirectionMappings["down"],
  MovementDirectionMappings["back"],
}
local RotationMappings = 
{
  [0] = function(CurrentCoordinates)
	CurrentCoordinates.X = CurrentCoordinates.X + 1
	turtle.forward()
	return CurrentCoordinates
  end,
  [1] = function(CurrentCoordinates)
	CurrentCoordinates.Z = CurrentCoordinates.Z + 1
	turtle.forward()
	return CurrentCoordinates
  end,
  [2] = function(CurrentCoordinates)
	CurrentCoordinates.X = CurrentCoordinates.X - 1
	turtle.forward()
	return CurrentCoordinates
  end,
  [3] = function(CurrentCoordinates)
	CurrentCoordinates.Z = CurrentCoordinates.Z - 1
	turtle.forward()
	return CurrentCoordinates
  end,
  [4] = function(CurrentCoordinates)
	CurrentCoordinates.Y = CurrentCoordinates.Y + 1
	turtle.up()
	return CurrentCoordinates
  end,
  [5] = function(CurrentCoordinates)
	CurrentCoordinates.Y = CurrentCoordinates.Y - 1
	turtle.down()
	return CurrentCoordinates
  end,
}

-- Delimiter

local RCS = {}
RCS.__index = RCS
local FileName = "RCS.lua"
local SaveFile = "Coordinates.RCSSV"
local Coordinates
local Dir
local Absolute
local Debug = true
local Verbose = true

function RCS.Init()
  local function Load()
	local File = fs.open(Dir .. SaveFile, "r")
	local Data = File:read("*all")
	File:close()
	local ParsingString, ResultingTable, Len = "", {}, Data:len()
	for i = 1, Len, 1 do
	  local Sub = Data:sub(i, i)
	  if i == Len then
		ParsingString = ParsingString .. Sub
		ResultingTable[#ResultingTable] = ParsingString
		ParsingString = nil
	  elseif Sub == "\n" then
		ResultingTable[#ResultingTable] = ParsingString
		ParsingString = ""
	  else
		ParsingString = ParsingString .. Sub
	  end
	end
	ResultingTable.X = ResultingTable[1]
	ResultingTable.Y = ResultingTable[2]
	ResultingTable.Z = ResultingTable[3]
	ResultingTable.Direction = ResultingTable[4]
	ResultingTable[1] = nil
	ResultingTable[2] = nil
	ResultingTable[3] = nil
	ResultingTable[4] = nil
	return ResultingTable
  end
  
  local function Create()
	local Data = table.concat({0, 0, 0, 0}, "\n")
	local File = fs.open(Dir .. SaveFile, "w")
	File.write(Data)
	File.close()
	io.write(AllDebuggingProtocols["WARNING"], "Coordinates are set to 0, 0, 0, 0 due to missing save file\n")
	io.write(AllDebuggingProtocols["WARNING"], "If ", SaveFile, " already existed beforehand and you're\n")
	io.write(AllDebuggingProtocols["WARNING"], "getting this warning, please contact LiKTOi1029 on GitHub.com\n")
	return {X = tonumber(Data[1]), Y = tonumber(Data[2]), Z = tonumber(Data[3]), Direction = tonumber(Data[4])}
  end

  Dir = shell.dir() .. "/"
  Absolute = shell.resolve(FileName)
  io.write(AllDebuggingProtocols["INFO"], "Resolving directory identities\n")
  io.write(AllDebuggingProtocols["INFO"], "Absolute identity -> ", Absolute, "\n")
  io.write(AllDebuggingProtocols["INFO"], "Folder identity -> ", Dir, "\n")
  io.write(AllDebuggingProtocols["FETCH"], "Identifying ", SaveFile, "\n")
  if fs.exists(Dir .. SaveFile) then
	io.write(AllDebuggingProtocols["SUCCESS"], "Found ", SaveFile, "!\n")
	Coordinates = Load()
  else
	io.write(AllDebuggingProtocols["FAILED"], SaveFile, " not found! Creating anew\n")
	Coordinates = Create()
  end
  io.write(AllDebuggingProtocols["SUCCESS"], "Initialization complete\n")
  return true
end

function RCS.UpdateCoordinates(NewCoordinates)
  Coordinates = NewCoordinates
  local File = fs.open(Dir .. SaveFile)
  File.write(table.concat(Data, "\n"), "w")
  File.close()
end

function RCS.Move(Direction, Number)
  if not Number then Number = 1 end
  local TemporaryCoordinates
  if type(Direction) == "number" then
	if not RotationMappings[Direction] then
	  io.write(AllDebuggingProtocols["ERROR"], Direction, " not a valid numeric direction value (0-3)\n")
	  return false
	end
	for i = 1, Number, 1 do
	  TemporaryCoordinates = RotationMappings[Direction]()
	end
	RCS.UpdateCoordinates(TemporaryCoordinates)
  else
	io.write(AllDebuggingProtocols["ERROR"], "Direction must be integer\n")
	return false
  end
  return true
end

function RCS.Turn(TurnCount)
  local TemporaryCoordinates = Coordinates
  TurnCount = math.abs(Coordinates.Direction + TurnCount) % 4
  TemporaryCoordinates.Direction = TurnCount
  RCS.UpdateCoordinates(TemporaryCoordinates)
  return true
end

RCS.Init()

return RCS