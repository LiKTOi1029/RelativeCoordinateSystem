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
-- Delimiter
local RCS = {}
RCS.__index = RCS
local FileName = "RCS.lua"
local SaveFile = "Coordinates.RCSSV"
local Coordinates
local FacingDirection = 0
local Dir
local Absolute
local Debug = true

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
	local Data = table.concat({"0", "0", "0", "0"}, "\n")
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
end

function RCS.UpdateCoordinates()
  
end

function RCS.Move(Direction)
  
end

function RCS.Turn(Direction)
  
end

RCS.Init()

return RCS