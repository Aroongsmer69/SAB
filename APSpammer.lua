-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local COMMAND_KEY = "78a772b6-9e1c-4827-ab8b-04a07838f298"

local Commands = {
	"ragdoll",
	"jail",
	"balloon",
	"jumpscare",
	"morph",
	"inverse",
	"rocket"
}

-- ✅ FIND REMOTE WITH SLASH IN NAME
local Net = ReplicatedStorage
	:WaitForChild("Packages")
	:WaitForChild("Net")

local REMOTE_NAME = "RE/352aad58-c786-4998-886b-3e4fa390721e"

local Remote
for _, v in ipairs(Net:GetDescendants()) do
	if v:IsA("RemoteEvent") and v.Name == REMOTE_NAME then
		Remote = v
		break
	end
end

if not Remote then
	error("RemoteEvent '" .. REMOTE_NAME .. "' not found")
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AroonsAPSpamGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(150, 200)
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.Position = UDim2.new(1, -10, 1, -10)
Frame.BackgroundColor3 = Color3.fromRGB(34,34,38)
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(58,58,62)
stroke.Parent = Frame

Frame.Active = true
Frame.Draggable = true

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(40,40,44)
topBar.Parent = Frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Aroon’s AP Spam"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Parent = topBar

local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(0,31)
list.Size = UDim2.new(1,0,1,-31)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 2
list.CanvasSize = UDim2.new(0,0,0,0)
list.Parent = Frame

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,4)

Instance.new("UIPadding", list).PaddingTop = UDim.new(0,4)

-- COMMAND EXECUTION
local function runCommands(targetPlayer)
	for _, cmd in ipairs(Commands) do
		Remote:FireServer(COMMAND_KEY, targetPlayer, cmd)
	end
end

-- PLAYER BUTTONS
local function addPlayer(plr)
	if plr == LocalPlayer then return end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,28)
	btn.BackgroundColor3 = Color3.fromRGB(46,46,50)
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = list
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.fromOffset(20,20)
	avatar.Position = UDim2.fromOffset(4,4)
	avatar.BackgroundTransparency = 1
	avatar.Image = Players:GetUserThumbnailAsync(
		plr.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size48x48
	)
	avatar.Parent = btn
	Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Position = UDim2.fromOffset(28,0)
	nameLabel.Size = UDim2.new(1,-30,1,0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = plr.DisplayName
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 11
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextColor3 = Color3.fromRGB(235,235,235)
	nameLabel.Parent = btn

	btn.MouseButton1Click:Connect(function()
		runCommands(plr)
	end)
end

-- REFRESH
local function refresh()
	for _, v in ipairs(list:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		addPlayer(plr)
	end

	task.wait()
	list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 4)
end

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
