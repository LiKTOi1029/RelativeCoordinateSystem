RCS = {}
RCS.__index = RCS

RCS.Coordinates = {["X"] = 0, ["Y"] = 0, ["Z"] = 0}

Switch = 0
function DirectionUpdater(Boolean)
	if Switch == 3 and Boolean then
		Switch = 0
	elseif Switch == 0 and not Boolean then
		Switch = 3
	elseif Boolean then
		Switch = Switch + 1
	else
		Switch = Switch - 1
	end
end
function CoordinatesUpdater(AmIGoingAlongTheYAxis)
	if not AmIGoingAlongTheYAxis then
		if Switch == 0 then
			RCS.Coordinates["X"] = RCS.Coordinates["X"] + 1
		elseif Switch == 1 then
			RCS.Coordinates["Z"] = RCS.Coordinates["Z"] + 1
		elseif Switch == 2 then
			RCS.Coordinates["X"] = RCS.Coordinates["X"] - 1
		else
			RCS.Coordinates["Z"] = RCS.Coordinates["Z"] - 1
		end
	elseif AmIGoingAlongTheYAxis == 1 then
		RCS.Coordinates["Y"] = RCS.Coordinates["Y"] + 1
	elseif AmIGoingAlongTheYAxis == -1 then
		RCS.Coordinates["Y"] = RCS.Coordinates["Y"] - 1
	end
end
function RCS.turnLeft()
	turtle.turnLeft()
	DirectionUpdater(false)
end
function RCS.turnRight()
	turtle.turnRight()
	DirectionUpdater(true)
end
function RCS.forward()
	turtle.forward()
	CoordinatesUpdater(false)
end
function RCS.back()
	turtle.forward()
	CoordinatesUpdater(false)
end
function RCS.up()
	turtle.forward()
	CoordinatesUpdater(1)
end
function RCS.down()
	turtle.forward()
	CoordinatesUpdater(-1)
end

return RCS
