local Map = {}

-- local ExampleWorld = {{"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"},
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
-- 					  {"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"}}


local World1 = {{"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"},
                {"W", nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W", "W", "W", "W", "W", "W", nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, nil, "W", "W", "W", nil, nil, "W", nil, nil, "W", "W", "W", "W", "W", "W", nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, nil, "W", "W", "W", nil, nil, "W", nil, nil, "W", "W", "W", "W", "W", "W", nil, nil, "W"},
                {"W", nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, "W", "W", "W", "W", "W", "W", "W", nil, nil, "W", "W", "W", "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {nil, nil, nil, nil, nil, nil, "W", nil, nil, nil, nil, nil, "W", "W", "W", "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {nil, nil, nil, nil, nil, nil, "W", nil, nil, nil, nil, nil, nil, nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, "W", "W", "W", "W", nil, nil, "W", nil, nil, nil, nil, nil, "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, "W", "W", "W", "W", nil, nil, "W", "W", "W", "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, "W", "W", "W", "W", nil, nil, "W", "W", "W", "W", "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W", "W", "W", "W", nil, nil, "W", "W", nil, nil, "W"},
                {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W", nil, nil, "W", "W", nil, nil, "W"},
                {"W", nil, nil, "W", "W", "W", "W", "W", nil, nil, "W", nil, nil, nil, nil, nil, "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, nil, "W", nil, nil, "W", nil, nil, nil, nil, nil, nil, nil, nil, "W", nil, nil, nil, nil, nil, nil, "W"},
                {"W", nil, nil, nil, "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W", "W", "W"},
                {"W", "W", "W", "W", "W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W", "W", "W", "W", "W"},
                {"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"}}

local ExampleWorld = {}

function Map:getWorld()
  return World1
end

function Map:getExampleWorld(width, height)
	numRows = math.floor(height / GRID_SIZE)
	numCols = math.floor(width / GRID_SIZE)

	for i = 1,numRows do
    ExampleWorld[i] = {}

    for j = 1,numCols do
      if i == 1 or i == numRows or j == 1 or j == numCols then
        ExampleWorld[i][j] = "W"
      else 
        ExampleWorld[i][j] = nil
      end
    end
  end

	return ExampleWorld
end

return Map