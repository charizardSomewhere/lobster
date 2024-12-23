-- this is elevator1

local players = game:GetService("Players")
local replicatedstorage = game:GetService("ReplicatedStorage")
local tpService = game:GetService("TeleportService")
local serverscriptservice = game:GetService("ServerScriptService")
local safetp = require(serverscriptservice.SafeTeleport)

local movingEvent = replicatedstorage:WaitForChild("MovingElevator")
local elevatorevent = replicatedstorage:WaitForChild("Elevator")
local elevator = script.Parent
local prismatic = elevator.shaft.PrismaticConstraint
local gui = elevator.Screen.SurfaceGui
local config = elevator.Config
local playersWaiting = {}
local countdownrunning = false
local moving = false

local function Setup()
	playersWaiting = {}
	moving = false
	gui.Title.Text = #playersWaiting.."/"..config.MaxPlayers.Value.." Players"
	gui.Status.Text = "Waiting..."
end

local function teleportPlayers()
	local placeId = 112277089163916
	local server = tpService:ReserveServer(placeId)
	local options = Instance.new("TeleportOptions")
	options.ReservedServerAccessCode = server
	safetp(placeId, playersWaiting, options)
	print("Finished Teleport")
end

local function moveElevator()
	moving = true
	for i, player in pairs(playersWaiting) do
		movingEvent:FireClient(player)
	end
	gui.Status.Text = "Teleporting Players..."
	prismatic.TargetPosition = -20
	teleportPlayers()
	task.wait(10)
	prismatic.TargetPosition = 0
	task.wait(8)
	Setup()
end

local function RunCountDown()
	countdownrunning = true
	for i = 10, 1, -1 do
		gui.Status.Text = "Starting in "..i
		task.wait(1)
		if #playersWaiting < 1 then
			countdownrunning = false
			Setup()
			return
		end
	end
	moveElevator()
	countdownrunning = false
end



elevator.entrance.Touched:Connect(function(part)
	print("Touched")
	local player = players:GetPlayerFromCharacter(part.Parent)
	local isWaiting = table.find(playersWaiting, player)
	
	if player and not isWaiting and #playersWaiting < config.MaxPlayers.Value and moving == false then
		table.insert(playersWaiting, player)
		gui.Title.Text = #playersWaiting.."/"..config.MaxPlayers.Value.." Players"
		player.Character.PrimaryPart.CFrame = elevator.TeleportIn.CFrame
		elevatorevent:FireClient(player, elevator)
		if not countdownrunning then
			RunCountDown()
		end
	end
end)

elevatorevent.OnServerEvent:Connect(function(player, elevator)
	local isWaiting = table.find(playersWaiting, player)
	if isWaiting then
		table.remove(playersWaiting, isWaiting)
	end
	
	gui.Title.Text = #playersWaiting.."/"..config.MaxPlayers.Value.." Players"
	
	if player.Character then
		player.Character.PrimaryPart.CFrame = elevator.TeleportOut1.CFrame
	end
end)

