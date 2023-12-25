
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FrameWork = nil -- REPLACE WITH YOUR FRAMEWORK

local Services = { } -- Start off by creating the module table

Services.Directory = { }

local function GetSharedModules(type)
	Services.Directory["Server"] = { ServerScriptService, FrameWork } -- Set up the server directories
	Services.Directory["Client"] = { Players.LocalPlayer,  FrameWork } -- Set up the client directories

	local SharedModules = Services.Directory[type] -- get the shared modules from the directory

	local mt = { } -- second module table
	
	if not Services[type] then
		Services[type] = { } -- set up the cache for the services
	end

	function mt:GetService(Module)

		if Services[type][Module] then -- check is service is already set up
			return Services[type][Module] -- return service data
		end

		for _, Directory in SharedModules do -- go through all the directories
			for _, NewModule in Directory:GetDescendants() do -- loop through the descendants of directory children
				if not NewModule:IsA("ModuleScript") then
					continue -- if v :: NewModule > is not a ModuleScript, continue through descendant loop
				end

				if NewModule.Name ~= Module then
					continue -- if v :: NewModule (s) name is not the service being called, continue through descendant loop
				end

				Services[type][Module] = require(NewModule) -- set up the service

				return Services[type][Module] -- return cached service
			end
		end
	end
	
	function mt:AddService(Module, ModuleData)
		if Services[type][Module] then -- check is service is already set up
			return Services[type][Module] -- return service data
		end
	end

	return mt -- return second module table
end

return setmetatable(Services, { -- Return module table through meta table
	__call = function(self, type) -- __call is called by using: "()"
		return GetSharedModules(type) -- return mt :: Cached service
	end
}) -- returning this will make the source of your code available from other scripts!

--[[

Examples on how to use the new meta table:

local Services = require(Framework.Services)("Server") :: RUNSERVICE SERVER
local Services = require(Framework.Services)("Client") :: RUNSERVICE CLIENT

Calling Server will result in server stored services
Calling Client will result in client stored services

PLEASE CONTRIBUTE ANY ISSUES YOU RECIEVE USING THIS

--]]

