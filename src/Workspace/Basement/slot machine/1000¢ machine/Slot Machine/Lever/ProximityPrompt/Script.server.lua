local prox = script.Parent
local lever = prox.Parent
local l = prox.Parent.Parent.LEDs
local price = 1000 -- Preço padrão da aposta

-- Ajuste dos multiplicadores de prêmio para garantir que a máquina não fique no prejuízo
local prizeMultiplier = {
	["rbxassetid://47671036"] = 100, -- 777
	["rbxassetid://47671152"] = 3, -- 666
	["rbxassetid://47671141"] = 1, -- 555
}

local badgeService = game:GetService("BadgeService")
local id = 2465909023601393

prox.ObjectText = "Price: " .. price .. " credits"
prox.ActionText = "Gamble"

local Images = {
	"rbxassetid://47671036",
	"rbxassetid://47671036",
	"rbxassetid://47671152",
	"rbxassetid://47671152",
	"rbxassetid://47671141",
	"rbxassetid://47671141",
	"rbxassetid://47671141",
	"rbxassetid://47671141",
	"rbxassetid://47671141",
	"rbxassetid://47671141",
}

local S1 = prox.Parent.Parent.Spinny1.Decor.Decal
local S2 = prox.Parent.Parent.Spinny2.Decor.Decal
local S3 = prox.Parent.Parent.Spinny3.Decor.Decal

prox.Triggered:Connect(function(player)
	prox.Enabled = false

	if not player or not player.leaderstats or not player.leaderstats.Credits then
		return
	end

	if player.leaderstats.Credits.Value < price then
		lever.Not:Play()
		prox.Enabled = true
		return -- Sai da função se o jogador não tiver moedas suficientes
	end

	player.leaderstats.Credits.Value -= price
	lever.Sound:Play()

	local function spinSlots()
		for i = 1, 20 do
			wait(0.1)
			S1.Texture = Images[math.random(1, #Images)]
			S2.Texture = Images[math.random(1, #Images)]
			S3.Texture = Images[math.random(1, #Images)]
		end
		lever.Slots:Play()
	end

	spinSlots()
	spinSlots()
	spinSlots()

	local slot1Image = S1.Texture
	local slot2Image = S2.Texture
	local slot3Image = S3.Texture

	local prize = 0
	if prizeMultiplier[slot1Image] and prizeMultiplier[slot2Image] and prizeMultiplier[slot3Image] then
		if prizeMultiplier[slot1Image] == prizeMultiplier[slot2Image] and prizeMultiplier[slot2Image] == prizeMultiplier[slot3Image] then
			prize = price * prizeMultiplier[slot1Image]
		elseif slot1Image == slot2Image or slot2Image == slot3Image or slot1Image == slot3Image then
			prize = price * 0.5
		end
	end

	if prize > 0 then
		player.leaderstats.Credits.Value += prize
		lever.Winner:Play()
		badgeService:AwardBadge(player.UserId, id)
		for i = 1, 9 do
			l.Color = Color3.new(1, 0.333333, 0)
			wait(0.1)
			l.Color = Color3.new(1, 0, 0.498039)
			wait(0.1)
			l.Color = Color3.new(0, 1, 0)
			wait(0.1)
			l.Color = Color3.new(1, 0.752941, 0.0117647)
			wait(0.1)
		end
	end

	prox.Enabled = true
end)
