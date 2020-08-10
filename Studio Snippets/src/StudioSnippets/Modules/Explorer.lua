warn("hey")

-- // Variables \\ --

local ExplorerModule = {}
local Handler = require(script.Parent.Handler)
local Settings = require(script.Parent.Settings)
local SnippetsStorage = game.ServerStorage.Snippets
local Update, CanvasCons = {}, {}

-- // Helper Functions \\ --

local function FindDescendant(Ancestor, Target, GettingIndex)
	for i,v in pairs(Ancestor:GetDescendants()) do
		if v.Name == Target then
			if GettingIndex then
				return i
			else
				return v
			end
		end
	end
end
	 	
local function GetGeneration(Start, Target)
	local Temp = Start
	local i = 0
		
	repeat
		Temp = Temp.Parent
			
		if Temp == Target then
			return i
		end
			
		i = i + 1
	until Temp == Target or not Temp
end
	
local function UpdateCanvasSize(GUI, Offset)	
	if not Offset then
		Offset = 0
	end
	
	GUI.CanvasSize = UDim2.new(0, 0, 0, GUI.UIListLayout.AbsoluteContentSize.Y + Offset)
end
	
local function UpdateSectionSize(GUI, Offset)
	if not Offset then
		Offset = 0
	end
	
	GUI.Size = UDim2.new(GUI.Size.X.Scale, 0, 0, GUI.UIListLayout.AbsoluteContentSize.Y + Offset)
end

-- // Main Functions \\ --

Update = {
	
	Init = function()
		Update.Canvas()
	end,
	
	Canvas = function()
		local Frame = Handler.Explorer.GUI
		
		local function StartCanvasCon(v)
			CanvasCons[v:GetFullName()] = v:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				UpdateCanvasSize(v.Parent)
			end)			
		end
		
		for _,v in pairs(Frame:GetDescendants()) do
			if v:IsA("UIListLayout") and v.Parent:IsA("ScrollingFrame") then
				StartCanvasCon(v)
			end
		end		
		
		Frame.DescendantAdded:Connect(function(v)		
			if v:IsA("UIListLayout") and v.Parent:IsA("ScrollingFrame") then
				StartCanvasCon(v)
			end		
		end)
		
		Frame.DescendantRemoving:Connect(function(v)
			if v:IsA("UIListLayout") and v.Parent:IsA("ScrollingFrame") then
				StartCanvasCon(v)
			end	
		end)		
	end
	
}

ExplorerModule.Create = function()
	
	local Frame = Handler.Explorer.GUI
	
	for i,v in pairs(SnippetsStorage:GetDescendants()) do
		local Gen = GetGeneration(v, SnippetsStorage)
		
		if v:IsA("Folder") then
			
			local Title = Frame.UIListLayout.TitleTemplate:Clone()
			Title.Parent = FindDescendant(Frame, v.Parent.Name .. "Frame") or Frame
			Title.Name = v.Name .. "Title"
			Title.Button.Label.Text = v.Name
			Title.Size = UDim2.new(1, -Gen*Settings.Explorer.Widget.IndentOffset, 0, Title.Size.Y.Offset)
			Title.LayoutOrder = FindDescendant(SnippetsStorage, v.Name, true) * Settings.Explorer.Widget.LayoutMultiplier
			
			local SnippetFrame = Frame.UIListLayout.Template:Clone()
			SnippetFrame.Parent = FindDescendant(Frame, v.Parent.Name .. "Frame") or Frame
			SnippetFrame.Name = v.Name .. "Frame"
			SnippetFrame.Size = UDim2.new(1, 0, 0, #v:GetDescendants() * Settings.Explorer.Widget.VerticalSize - Settings.Explorer.Widget.VerticalOffset)
			SnippetFrame.LayoutOrder = FindDescendant(SnippetsStorage, v.Name, true) * Settings.Explorer.Widget.LayoutMultiplier + 1
					
			Title.Button.MouseButton1Click:Connect(function()
				SnippetFrame.Visible = not SnippetFrame.Visible
				
				local TempFrameParent = FindDescendant(Frame, v.Parent.Name .. "Frame")		
				if TempFrameParent then				
					local PossibleParent = TempFrameParent
					repeat
						UpdateSectionSize(PossibleParent)
						PossibleParent = PossibleParent.Parent
					until not PossibleParent or PossibleParent == Frame				
				end
			end)		
			
		elseif v:IsA("LuaSourceContainer") then
			
			local SnippetFrame = FindDescendant(Frame, v.Parent.Name .. "Frame")
			local SnippetButton = SnippetFrame.UIListLayout.Template:Clone()
			SnippetButton.Parent = SnippetFrame or Frame
			SnippetButton.Name = v.Name
			SnippetButton.Button.Label.Text = v.Name
			SnippetButton.Size = UDim2.new(1, -Gen * Settings.Explorer.Widget.IndentOffset, 0, SnippetButton.Size.Y.Offset)
			
			SnippetButton.Button.MouseButton1Click:Connect(function()
				print("Inserting " .. SnippetButton.Name)
			end)
			
		end
		
	end
	
	Update.Init()
	
end

return ExplorerModule