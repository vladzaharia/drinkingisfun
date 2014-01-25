local Map = {}

local ExampleWorld = {{"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"},
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "W"}, 
					  {"W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W", "W"}}

function Map:getExampleWorld()
	return ExampleWorld
end

return Map