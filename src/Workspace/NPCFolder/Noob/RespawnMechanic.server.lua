local npc = script.Parent
local hum = npc:WaitForChild("Humanoid")
local hrp = npc:WaitForChild("HumanoidRootPart")

local on = false

local RPS = game:GetService("ReplicatedStorage")


hum.Died:Connect(function()
	if not on then
		local clone = RPS:WaitForChild("Noob"):Clone()
		on = true
		wait(3)
		clone:PivotTo(hrp.CFrame)
		clone.Name = "Noob"
		clone.Parent = workspace
		wait(3)
		npc:Destroy()
	end
	
end)