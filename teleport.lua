local AllIDs = {}
local foundAnything = ""
local S_T = game:GetService("TeleportService")
local S_H = cloneref(game:GetService("HttpService"))
local S_P = cloneref(game:GetService("Players"))

local File = pcall(function()
	AllIDs = S_H:JSONDecode(readfile("teleport-temp.json"))
end)

if not File then
	pcall(function()
		writefile("teleport-temp.json", S_H:JSONEncode(AllIDs))
	end)
end

local function DeleteTemp()
    for id, time in pairs(AllIDs) do
        if (os.time() - time) > 120 then -- время в секундах
            AllIDs[id] = nil
        end
    end
end

local function TPReturner(placeId)
	local Site, ID;

	if foundAnything == "" then
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
	else
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end

	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
		foundAnything = Site.nextPageCursor
	end

	for i, v in pairs(Site.data) do
		ID = tostring(v.id)

		if (tonumber(v.maxPlayers) > tonumber(v.playing)) and (tostring(game.JobId) ~= ID) and not AllIDs[ID] then
			table.insert(AllIDs, ID)
			pcall(function()
				writefile("teleport-temp.json", S_H:JSONEncode(AllIDs))
				S_T:TeleportToPlaceInstance(placeId, ID, S_P.LocalPlayer)
			end)
			task.wait(4)
		end
	end
end

function Teleport(placeId)
	while task.wait(1) do
    DeleteTemp()
		pcall(function()
			TPReturner(placeId)
			if foundAnything ~= "" then
				TPReturner(placeId)
			end
		end)
	end
end

Teleport(game.PlaceId)
