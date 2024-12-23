local npc = script.Parent
local hum = npc:WaitForChild("Humanoid")
local hrp = npc:WaitForChild("HumanoidRootPart")

local on = false

local RPS = game:GetService("ReplicatedStorage")


hum.Died:Connect(function()
	if not on then
		local clone = RPS:WaitForChild("Buffoon"):Clone()
		on = true
		clone:PivotTo(hrp.CFrame)
		wait(2)
		clone.Name = "Buffoon"
		clone.Parent = workspace
		wait(3)
		npc:Destroy()
	end
	
end)